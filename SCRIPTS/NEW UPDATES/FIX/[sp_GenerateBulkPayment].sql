USE [LEASINGDB]
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_GenerateBulkPayment]
    -- Add the parameters for the stored procedure here
    @RefId             VARCHAR(50)    = NULL,
    @PaidAmount        DECIMAL(18, 2) = NULL, ---Is Actual Amount From Payment Mode (Due Amount)
    @ReceiveAmount     DECIMAL(18, 2) = NULL,
    @ChangeAmount      DECIMAL(18, 2) = NULL,
    @SecAmountADV      DECIMAL(18, 2) = NULL,
    @EncodedBy         INT            = NULL,
    @ComputerName      VARCHAR(30)    = NULL,
    @CompanyORNo       VARCHAR(30)    = NULL,
    @CompanyPRNo       VARCHAR(30)    = NULL,
    @BankAccountName   VARCHAR(30)    = NULL,
    @BankAccountNumber VARCHAR(30)    = NULL,
    @BankName          VARCHAR(30)    = NULL,
    @SerialNo          VARCHAR(30)    = NULL,
    @PaymentRemarks    VARCHAR(100)   = NULL,
    @REF               VARCHAR(100)   = NULL,
    @CheckDate         VARCHAR(100)   = NULL,
    @ReceiptDate       VARCHAR(100)   = NULL,
    @BankBranch        VARCHAR(100)   = NULL,
    @ModeType          VARCHAR(20)    = NULL,
    @XML               XML
AS
    BEGIN

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';
        DECLARE @TranRecId BIGINT = 0
        DECLARE @TranID VARCHAR(50) = ''
        DECLARE @RcptRecId BIGINT = 0
        DECLARE @RcptID VARCHAR(50) = ''
        DECLARE @IsFullPayment BIT = 0
        DECLARE @TotalRent DECIMAL(18, 2) = NULL
        DECLARE @PenaltyPct DECIMAL(18, 2) = NULL
        DECLARE @ActualAmountPaid DECIMAL(18, 2) = NULL
        DECLARE @AmountToDeduct DECIMAL(18, 2)
        DECLARE @ForMonth DATE
        DECLARE @RefRecId BIGINT = NULL
        DECLARE @ForMonthRecID BIGINT = NULL

        DECLARE @MaintenanceAndRentalAmount DECIMAL(18, 2) = NULL

        CREATE TABLE [#tblBulkPostdatedMonth]
            (
                [Recid] VARCHAR(10)
            )
        IF (@XML IS NOT NULL)
            BEGIN
                INSERT INTO [#tblBulkPostdatedMonth]
                    (
                        [Recid]
                    )
                            SELECT
                                [ParaValues].[data].[value]('c1[1]', 'VARCHAR(10)')
                            FROM
                                @XML.[nodes]('/Table1') AS [ParaValues]([data])
            END

        SELECT
            @TotalRent  = [tblUnitReference].[TotalRent],
            @PenaltyPct = [tblUnitReference].[PenaltyPct],
            @RefRecId   = [tblUnitReference].[RecId]
        FROM
            [dbo].[tblUnitReference] WITH (NOLOCK)
        WHERE
            [tblUnitReference].[RefId] = @RefId

        /*Related to old penalty integration*/
        --UPDATE
        --    [dbo].[tblMonthLedger]
        --SET
        --    [tblMonthLedger].[ActualAmount] = [tblMonthLedger].[LedgRentalAmount]
        --                                      + ISNULL([tblMonthLedger].[PenaltyAmount], 0)
        --WHERE
        --    [tblMonthLedger].[ReferenceID] = @RefRecId
        --    AND
        --        (
        --            ISNULL([tblMonthLedger].[IsPaid], 0) = 0
        --            OR ISNULL([tblMonthLedger].[IsHold], 0) = 1
        --        )



        INSERT INTO [dbo].[tblTransaction]
            (
                [RefId],
                [PaidAmount],
                [ReceiveAmount],
                [ActualAmountPaid],
                [ChangeAmount], ---Not Assigned
                [Remarks],
                [EncodedBy],
                [EncodedDate],
                [ComputerName],
                [IsActive]
            )
        VALUES
            (
                @RefId, @PaidAmount, @ReceiveAmount, @ReceiveAmount, @ChangeAmount, 'FOLLOW-UP PAYMENT', @EncodedBy,
                GETDATE(), @ComputerName, 1
            );

        SET @TranRecId = @@IDENTITY
        SELECT
            @TranID = [tblTransaction].[TranID]
        FROM
            [dbo].[tblTransaction] WITH (NOLOCK)
        WHERE
            [tblTransaction].[RecId] = @TranRecId


        DECLARE [CursorName] CURSOR FOR
            SELECT
                IIF([tblMonthLedger].[BalanceAmount] > 0,
                    [tblMonthLedger].[BalanceAmount],
                    IIF([tblMonthLedger].[ActualAmount] > 0,
                        CAST([tblMonthLedger].[ActualAmount] AS DECIMAL(18, 2)),
                        [tblMonthLedger].[LedgRentalAmount])) AS [Amount],
                [tblMonthLedger].[LedgMonth],
                [tblMonthLedger].[Recid],
                [tblMonthLedger].[LedgAmount]
            FROM
                [dbo].[tblMonthLedger] WITH (NOLOCK)
            WHERE
                [tblMonthLedger].[ReferenceID] =
                (
                    SELECT
                        [tblUnitReference].[RecId]
                    FROM
                        [dbo].[tblUnitReference] WITH (NOLOCK)
                    WHERE
                        [tblUnitReference].[RefId] = @RefId
                )
                AND [tblMonthLedger].[Recid] IN
                        (
                            SELECT
                                [#tblBulkPostdatedMonth].[Recid]
                            FROM
                                [#tblBulkPostdatedMonth] WITH (NOLOCK)
                        )
                AND
                    (
                        ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                        OR ISNULL([tblMonthLedger].[IsHold], 0) = 1
                    )
            ORDER BY
                [tblMonthLedger].[LedgMonth] ASC

        OPEN [CursorName]

        FETCH NEXT FROM [CursorName]
        INTO
            @AmountToDeduct,
            @ForMonth,
            @ForMonthRecID,
            @MaintenanceAndRentalAmount

        WHILE @@FETCH_STATUS = 0
            BEGIN


                SELECT
                    @ActualAmountPaid = [tblTransaction].[ActualAmountPaid]
                FROM
                    [dbo].[tblTransaction]
                WHERE
                    [tblTransaction].[RecId] = @TranRecId


                IF @ActualAmountPaid > 0
                    BEGIN


                        UPDATE
                            [dbo].[tblTransaction]
                        SET
                            [tblTransaction].[ActualAmountPaid] = [tblTransaction].[ActualAmountPaid] - @AmountToDeduct
                        WHERE
                            [tblTransaction].[RecId] = @TranRecId


                        IF @ActualAmountPaid >= @AmountToDeduct
                            BEGIN
                                UPDATE
                                    [dbo].[tblMonthLedger]
                                SET
                                    [tblMonthLedger].[IsPaid] = 1,
                                    [tblMonthLedger].[IsHold] = 0,
                                    [tblMonthLedger].[CompanyORNo] = @CompanyORNo,
                                    [tblMonthLedger].[CompanyPRNo] = @CompanyPRNo,
                                    [tblMonthLedger].[REF] = @REF,
                                    [tblMonthLedger].[BNK_ACCT_NAME] = @BankAccountName,
                                    [tblMonthLedger].[BNK_ACCT_NUMBER] = @BankAccountNumber,
                                    [tblMonthLedger].[BNK_NAME] = @BankName,
                                    [tblMonthLedger].[SERIAL_NO] = @SerialNo,
                                    [tblMonthLedger].[ModeType] = @ModeType,
                                    [tblMonthLedger].[BankBranch] = @BankBranch,
                                    [tblMonthLedger].[BalanceAmount] = 0,
                                    [tblMonthLedger].[TransactionID] = @TranID,
                                    [tblMonthLedger].[CheckDate] = @CheckDate,
                                    [tblMonthLedger].[ReceiptDate] = @ReceiptDate,
                                    [tblMonthLedger].[PaymentRemarks] = @PaymentRemarks
                                WHERE
                                    [tblMonthLedger].[LedgMonth] = @ForMonth
                                    AND
                                        (
                                            ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                                            OR ISNULL([tblMonthLedger].[IsHold], 0) = 1
                                        )
                                    AND [tblMonthLedger].[Recid] = @ForMonthRecID
                                BEGIN
                                    INSERT INTO [dbo].[tblPayment]
                                        (
                                            [TranId],
                                            [RefId],
                                            [Amount],
                                            [ForMonth],
                                            [Remarks],
                                            [EncodedBy],
                                            [EncodedDate],
                                            [ComputerName],
                                            [IsActive],
                                            [Notes],
                                            [LedgeRecid]
                                        )
                                                SELECT
                                                    @TranID                      AS [TranId],
                                                    @RefId                       AS [RefId],
                                                    @AmountToDeduct              AS [Amount], ---THIS IS NOT A ACTUAL AMOUNT PAID  FOR FUTURE JOIN TRAN TO PAYMENT TRANID TO GET THE ACTUAL SUM PAYMENT                   
                                                    [tblMonthLedger].[LedgMonth] AS [ForMonth],
                                                    'FOLLOW-UP PAYMENT'          AS [Remarks],
                                                    @EncodedBy,
                                                    GETDATE(),                                --Dated payed
                                                    @ComputerName,
                                                    1,
                                                    [tblMonthLedger].[Remarks],
                                                    [tblMonthLedger].[Recid]
                                                FROM
                                                    [dbo].[tblMonthLedger] WITH (NOLOCK)
                                                WHERE
                                                    [tblMonthLedger].[ReferenceID] =
                                                    (
                                                        SELECT
                                                            [tblUnitReference].[RecId]
                                                        FROM
                                                            [dbo].[tblUnitReference] WITH (NOLOCK)
                                                        WHERE
                                                            [tblUnitReference].[RefId] = @RefId
                                                    )
                                                    AND [tblMonthLedger].[Recid] IN (
                                                                                        @ForMonthRecID
                                                                                    )
                                END

                            END
                        ELSE IF @ActualAmountPaid < @AmountToDeduct
                            BEGIN
                                UPDATE
                                    [dbo].[tblMonthLedger]
                                SET
                                    [tblMonthLedger].[IsHold] = 1,
                                    [tblMonthLedger].[CompanyORNo] = @CompanyORNo,
                                    [tblMonthLedger].[CompanyPRNo] = @CompanyPRNo,
                                    [tblMonthLedger].[REF] = @REF,
                                    [tblMonthLedger].[BNK_ACCT_NAME] = @BankAccountName,
                                    [tblMonthLedger].[BNK_ACCT_NUMBER] = @BankAccountNumber,
                                    [tblMonthLedger].[BNK_NAME] = @BankName,
                                    [tblMonthLedger].[SERIAL_NO] = @SerialNo,
                                    [tblMonthLedger].[ModeType] = @ModeType,
                                    [tblMonthLedger].[BankBranch] = @BankBranch,
                                    [tblMonthLedger].[BalanceAmount] = ABS(@ActualAmountPaid - @AmountToDeduct),
                                    [tblMonthLedger].[TransactionID] = @TranID, --- TRN WILL CHANGE IF ALWAYS A PAYMENT FOR BALANCE AMOUNT
                                    [tblMonthLedger].[CheckDate] = @CheckDate,
                                    [tblMonthLedger].[ReceiptDate] = @ReceiptDate,
                                    [tblMonthLedger].[PaymentRemarks] = @PaymentRemarks
                                WHERE
                                    [tblMonthLedger].[LedgMonth] = @ForMonth
                                    AND
                                        (
                                            ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                                            OR ISNULL([tblMonthLedger].[IsHold], 0) = 1
                                        )
                                    AND [tblMonthLedger].[Recid] = @ForMonthRecID

                                INSERT INTO [dbo].[tblPayment]
                                    (
                                        [TranId],
                                        [RefId],
                                        [Amount],
                                        [ForMonth],
                                        [Remarks],
                                        [EncodedBy],
                                        [EncodedDate],
                                        [ComputerName],
                                        [IsActive],
                                        [Notes],
                                        [LedgeRecid]
                                    )
                                            SELECT
                                                @TranID                                    AS [TranId],
                                                @RefId                                     AS [RefId],
                                                [tblMonthLedger].[LedgRentalAmount]
                                                - ABS(@ActualAmountPaid - @AmountToDeduct) AS [Amount], ---THIS IS NOT A ACTUAL AMOUNT PAID  FOR FUTURE JOIN TRAN TO PAYMENT TRANID TO GET THE ACTUAL SUM PAYMENT                   
                                                [tblMonthLedger].[LedgMonth]               AS [ForMonth],
                                                'FOLLOW-UP PAYMENT'                        AS [Remarks],
                                                @EncodedBy,
                                                GETDATE(),                                              --Dated payed
                                                @ComputerName,
                                                1,
                                                [tblMonthLedger].[Remarks],
                                                [tblMonthLedger].[Recid]
                                            FROM
                                                [dbo].[tblMonthLedger] WITH (NOLOCK)
                                            WHERE
                                                [tblMonthLedger].[ReferenceID] =
                                                (
                                                    SELECT
                                                        [tblUnitReference].[RecId]
                                                    FROM
                                                        [dbo].[tblUnitReference] WITH (NOLOCK)
                                                    WHERE
                                                        [tblUnitReference].[RefId] = @RefId
                                                )
                                                AND [tblMonthLedger].[Recid] IN (
                                                                                    @ForMonthRecID
                                                                                )

                            END
                    END

                FETCH NEXT FROM [CursorName]
                INTO
                    @AmountToDeduct,
                    @ForMonth,
                    @ForMonthRecID,
                    @MaintenanceAndRentalAmount
            END

        CLOSE [CursorName]
        DEALLOCATE [CursorName]

        UPDATE
            [dbo].[tblUnitReference]
        SET
            [tblUnitReference].[IsPaid] = 1
        WHERE
            [tblUnitReference].[RefId] = @RefId;


        INSERT INTO [dbo].[tblReceipt]
            (
                [TranId],
                [Amount],
                [Description],
                [EncodedBy],
                [EncodedDate],
                [ComputerName],
                [IsActive],
                [PaymentMethod],
                [CompanyORNo],
                [CompanyPRNo],
                [BankAccountName],
                [BankAccountNumber],
                [BankName],
                [SerialNo],
                [REF],
                [BankBranch],
                [RefId],
                [ReceiptDate],
                [PaymentRemarks],
                [CheckDate]
            )
        VALUES
            (
                @TranID, @ReceiveAmount, 'FOLLOW-UP PAYMENT', @EncodedBy, GETDATE(), @ComputerName, 1, @ModeType,
                @CompanyORNo, @CompanyPRNo, @BankAccountName, @BankAccountNumber, @BankName, @SerialNo, @REF,
                @BankBranch, @RefId, @ReceiptDate, @PaymentRemarks, @CheckDate
            );

        SET @RcptRecId = @@IDENTITY
        SELECT
            @RcptID = [tblReceipt].[RcptID]
        FROM
            [dbo].[tblReceipt] WITH (NOLOCK)
        WHERE
            [tblReceipt].[RecId] = @RcptRecId

        INSERT INTO [dbo].[tblPaymentMode]
            (
                [RcptID],
                [CompanyORNo],
                [CompanyPRNo],
                [REF],
                [BNK_ACCT_NAME],
                [BNK_ACCT_NUMBER],
                [BNK_NAME],
                [SERIAL_NO],
                [ModeType],
                [BankBranch],
                [ReceiptDate],
                [PaymentRemarks],
                [CheckDate]
            )
        VALUES
            (
                @RcptID, @CompanyORNo, @CompanyPRNo, @REF, @BankAccountName, @BankAccountNumber, @BankName, @SerialNo,
                @ModeType, @BankBranch, @ReceiptDate, @PaymentRemarks, @CheckDate
            );


        IF (
               @TranID <> ''
               AND @@ROWCOUNT > 0
           )
            BEGIN

                SET @Message_Code = 'SUCCESS'
            END


        SET @ErrorMessage = ERROR_MESSAGE()
        IF @ErrorMessage <> ''
            BEGIN
                INSERT INTO [dbo].[ErrorLog]
                    (
                        [ProcedureName],
                        [ErrorMessage],
                        [LogDateTime]
                    )
                VALUES
                    (
                        'sp_GenerateBulkPayment', @ErrorMessage, GETDATE()
                    );

            END

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code],
            @RcptID       AS [ReceiptID],
            @TranID       AS [TranID]


        DROP TABLE [#tblBulkPostdatedMonth]

    END
GO

