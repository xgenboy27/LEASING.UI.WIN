USE [LEASINGDB]
GO
/****** Object:  StoredProcedure [dbo].[demo_REPORT]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[demo_REPORT]
AS
    BEGIN
        SET NOCOUNT ON;


        CREATE TABLE [#TMP]
            (
                [client_no] VARCHAR(50),
                [lot_area]  DECIMAL(18, 2),
                [Res_pay]   DECIMAL(18, 2),
                [Cash_sale] DECIMAL(18, 2),
                [DP_Pay]    DECIMAL(18, 2),
                [MA_Pay]    DECIMAL(18, 2),
                [VAT]       DECIMAL(18, 2),
                [Others]    DECIMAL(18, 2),
                [Tot_Cash]  DECIMAL(18, 2),
                [Tot_Chk]   DECIMAL(18, 2),
                [Tot_Pay]   DECIMAL(18, 2),
                [PR_No]     VARCHAR(50),
                [Penalty]   DECIMAL(18, 2),
                [phase]     VARCHAR(50),
                [tran_date] DATE,
                [interest]  DECIMAL(18, 2),
                [tcost]     DECIMAL(18, 2),
                [tcp]       DECIMAL(18, 2),
                [tin]       VARCHAR(50),
            );


        INSERT INTO [#TMP]
            (
                [client_no],
                [lot_area],
                [Res_pay],
                [Cash_sale],
                [DP_Pay],
                [MA_Pay],
                [VAT],
                [Others],
                [Tot_Cash],
                [Tot_Chk],
                [Tot_Pay],
                [PR_No],
                [Penalty],
                [phase],
                [tran_date],
                [interest],
                [tcost],
                [tcp],
                [tin]
            )
        VALUES
            (
                'INV10000010', -- client_no - varchar(50)
                3.75, -- lot_area - decimal(18, 2)
                100, -- Res_pay - decimal(18, 2)
                50, -- Cash_sale - decimal(18, 2)
                100, -- DP_Pay - decimal(18, 2)
                100, -- MA_Pay - decimal(18, 2)
                10, -- VAT - decimal(18, 2)
                100, -- Others - decimal(18, 2)
                100, -- Tot_Cash - decimal(18, 2)
                100, -- Tot_Chk - decimal(18, 2)
                100, -- Tot_Pay - decimal(18, 2)
                '12345689', -- PR_No - varchar(50)
                100, -- Penalty - decimal(18, 2)
                'DEMO PHASE', -- phase - varchar(50)
                CONVERT(DATE,GETDATE()), -- tran_date - date
                100, -- interest - decimal(18, 2)
                100, -- tcost - decimal(18, 2)
                100, -- tcp - decimal(18, 2)
                '12312123'  -- tin - varchar(50)
            );

        SELECT
            [#TMP].[client_no],
            [#TMP].[lot_area],
            [#TMP].[Res_pay],
            [#TMP].[Cash_sale],
            [#TMP].[DP_Pay],
            [#TMP].[MA_Pay],
            [#TMP].[VAT],
            [#TMP].[Others],
            [#TMP].[Tot_Cash],
            [#TMP].[Tot_Chk],
            [#TMP].[Tot_Pay],
            [#TMP].[PR_No],
            [#TMP].[Penalty],
            [#TMP].[phase],
            [#TMP].[tran_date],
            [#TMP].[interest],
            [#TMP].[tcost],
            [#TMP].[tcp],
            [#TMP].[tin]
        FROM
            [#TMP];


        DROP TABLE [#TMP];
    END;
GO
/****** Object:  StoredProcedure [dbo].[GenerateInsertsMomths]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC [GenerateInsertsMomths] @StartDate = '07/31/2023',@MonthsCount = 3
CREATE PROCEDURE [dbo].[GenerateInsertsMomths]
    @StartDate   DATE,
    @MonthsCount INT
AS
    BEGIN

        CREATE TABLE [#GeneratedMonths]
            (
                [Month] DATE
            );
        WITH [MonthsCTE]
        AS (   SELECT
                   @StartDate AS [Month]
               UNION ALL
               SELECT
                   DATEADD(MONTH, 1, [MonthsCTE].[Month])
               FROM
                   [MonthsCTE]
               WHERE
                   DATEADD(MONTH, 1, [MonthsCTE].[Month]) <= DATEADD(MONTH, @MonthsCount - 1, @StartDate))
        INSERT INTO [#GeneratedMonths]
            (
                [Month]
            )
                    SELECT
                        [MonthsCTE].[Month]
                    FROM
                        [MonthsCTE];


        INSERT INTO [dbo].[sample_table]
            (
                [Month],
                [data]
            )
                    SELECT
                        [#GeneratedMonths].[Month],
                        'test'
                    FROM
                        [#GeneratedMonths];

        DROP TABLE [#GeneratedMonths];

    END;

GO
/****** Object:  StoredProcedure [dbo].[GenerateStringWithIdentity_DEBUG]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GenerateStringWithIdentity_DEBUG]
AS
BEGIN
    DECLARE @IdentityNumber INT
    DECLARE @GeneratedString VARCHAR(50)

    -- Get the latest identity value
    SELECT @IdentityNumber = IDENT_CURRENT('demoTable')+1

    -- Increment the identity value if it is less than 100
    IF @IdentityNumber < 1000
        SET @IdentityNumber = 1000

    -- Generate the string
    SET @GeneratedString = 'CORP-' + RIGHT('00' + CAST(@IdentityNumber + 1 AS VARCHAR(10)), 3)

    -- Output the generated string
    SELECT @GeneratedString AS GeneratedString
END
GO
/****** Object:  StoredProcedure [dbo].[pr_BlankAllTransactionRecords]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
	EXEC [pr_BlankAllTransactionRecords]
*/
CREATE     PROC [dbo].[pr_BlankAllTransactionRecords]
AS
    BEGIN


       TRUNCATE TABLE 
        [dbo].[tblUnitReference]
        --DBCC CHECKIDENT('[tblUnitReference]', RESEED, 0);

       TRUNCATE TABLE 
        [dbo].[tblTransaction]
        --DBCC CHECKIDENT('[tblTransaction]', RESEED, 0);

        TRUNCATE TABLE 
        [dbo].[tblMonthLedger]
        --DBCC CHECKIDENT('[tblMonthLedger]', RESEED, 0);

        TRUNCATE TABLE 
        [dbo].[tblReceipt]
        --DBCC CHECKIDENT('[tblReceipt]', RESEED, 0);

        TRUNCATE TABLE 
        [dbo].[tblPayment]
        --DBCC CHECKIDENT('[tblPayment]', RESEED, 0);

        TRUNCATE TABLE 
        [dbo].[tblAdvancePayment]
        --DBCC CHECKIDENT('[tblAdvancePayment]', RESEED, 0);

       TRUNCATE TABLE 
        [dbo].[tblPaymentMode]
        --DBCC CHECKIDENT('[tblPaymentMode]', RESEED, 0);

        TRUNCATE TABLE 
        [dbo].[LoggingEvent]
        --DBCC CHECKIDENT('[LoggingEvent]', RESEED, 0);

        TRUNCATE TABLE 
        [dbo].[ErrorLog]
        --DBCC CHECKIDENT('[ErrorLog]', RESEED, 0);

        UPDATE
            [dbo].[tblUnitMstr]
        SET
            [tblUnitMstr].[UnitStatus] = 'VACANT'
    END













GO
/****** Object:  StoredProcedure [dbo].[sp_ActivateLocationById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ActivateLocationById] @RecId INT
AS
    BEGIN

        SET NOCOUNT ON;

        UPDATE
            [dbo].[tblLocationMstr]
        SET
            [tblLocationMstr].[IsActive] = 1
        WHERE
            [tblLocationMstr].[RecId] = @RecId;

        IF (@@ROWCOUNT > 0)
            BEGIN

                SELECT
                    'SUCCESS' AS [Message_Code];

            END;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ActivatePojectById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ActivatePojectById] @RecId INT
AS
    BEGIN

        SET NOCOUNT ON;

        UPDATE
            [dbo].[tblProjectMstr]
        SET
            [tblProjectMstr].[IsActive] = 1
        WHERE
            [tblProjectMstr].[RecId] = @RecId;

        IF (@@ROWCOUNT > 0)
            BEGIN

                SELECT
                    'SUCCESS' AS [Message_Code];

            END;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_activatePurchaseItemById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC sp_GetPurchaseItemInfoById @RecId = 2
-- =============================================
CREATE PROCEDURE [dbo].[sp_activatePurchaseItemById] @RecId INT
AS
    BEGIN

        SET NOCOUNT ON;

        UPDATE
            [dbo].[tblProjPurchItem]
        SET
            [tblProjPurchItem].[IsActive] = 1
        WHERE
            [tblProjPurchItem].[RecId] = @RecId;


        IF (@@ROWCOUNT > 0)
            BEGIN
                SELECT
                    'SUCCESS' AS [Message_Code];
            END;


    END;

GO
/****** Object:  StoredProcedure [dbo].[sp_CheckContractProjectType]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_CheckContractProjectType] @RefId AS VARCHAR(20) = NULL
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
                [tblUnitReference].[RefId],
                [tblUnitReference].[UnitId],
                [tblUnitMstr].[UnitNo],
                [tblUnitMstr].[FloorType],
                IIF(ISNULL([tblUnitReference].[Unit_IsParking], 0) = 1, 'PARKING', 'UNIT') AS [UnitType],
                [tblProjectMstr].[ProjectType]
        FROM
                [dbo].[tblUnitReference]
            INNER JOIN
                [dbo].[tblUnitMstr]
                    ON [tblUnitMstr].[RecId] = [tblUnitReference].[UnitId]
            INNER JOIN
                [dbo].[tblProjectMstr]
                    ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
        WHERE
                [tblUnitReference].[RefId] = @RefId;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_CheckHoldPenalty]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_CheckHoldPenalty]
--@parameter_name AS INT
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
BEGIN

    DECLARE @startDate DATE = '2023-01-01'; -- Replace with your actual start date
    DECLARE @endDate DATE = '2023-01-30'; -- Replace with your actual end date
    DECLARE @thresholdDays INT = 30; -- Replace with your desired threshold
    DECLARE @initialAmount DECIMAL(10, 2) = 1000; -- Replace with your initial amount

    DECLARE @dateDifference INT = DATEDIFF(DAY, @startDate, @endDate);
    DECLARE @totalMonths INT;
    DECLARE @remainingDays INT;
    DECLARE @penaltyPercentage DECIMAL(5, 2);
    DECLARE @penaltyAmount DECIMAL(10, 2);
    DECLARE @message NVARCHAR(100);

    SET @totalMonths = DATEDIFF(MONTH, @startDate, @endDate);
    SET @remainingDays = @dateDifference - (@totalMonths * @thresholdDays);

    -- Calculate penalty based on the conditions
    IF @dateDifference > @thresholdDays
    BEGIN
        -- Calculate penalty percentage based on the number of months
        SET @penaltyPercentage = @totalMonths * 3.00; -- 3% penalty per month

        -- Calculate penalty amount
        SET @penaltyAmount = (@penaltyPercentage / 100) * @initialAmount;

        SET @message = N'Penalty: ' + CAST(@penaltyAmount AS NVARCHAR(20));
    END;
    ELSE
    BEGIN
        SET @message = N'No Penalty';
    END;

    PRINT 'Total Months: ' + CAST(@totalMonths AS NVARCHAR(10)) + ', Remaining Days: '
          + CAST(@remainingDays AS NVARCHAR(10));
    PRINT 'Message: ' + @message;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_CheckIfOrIsEmpty]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_CheckIfOrIsEmpty] @TranId AS VARCHAR(30) = NULL
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
BEGIN
    SELECT [tblReceipt].[RecId],
           [tblReceipt].[RcptID],
           [tblReceipt].[TranId],
           --[tblReceipt].[Amount],
           --[tblReceipt].[Description],
           --[tblReceipt].[Remarks],
           --[tblReceipt].[EncodedBy],
           --[tblReceipt].[EncodedDate],
           --[tblReceipt].[LastChangedBy],
           --[tblReceipt].[LastChangedDate],
           --[tblReceipt].[ComputerName],
           --[tblReceipt].[IsActive],
           --[tblReceipt].[PaymentMethod],
           ISNULL([tblReceipt].[CompanyORNo], '') AS [CompanyORNo],
           --[tblReceipt].[BankAccountName],
           --[tblReceipt].[BankAccountNumber],
           --[tblReceipt].[BankName],
           --[tblReceipt].[SerialNo],
           --[tblReceipt].[REF],
           ISNULL([tblReceipt].[CompanyPRNo], '') AS [CompanyPRNo]
    FROM [dbo].[tblReceipt]
    WHERE [tblReceipt].[TranId] = @TranId;


END;
GO
/****** Object:  StoredProcedure [dbo].[sp_CheckOrNumber]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--EXEC [sp_CheckOrNumber] '234234234'
CREATE PROCEDURE [dbo].[sp_CheckOrNumber] @CompanyORNo AS VARCHAR(100) = NULL
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            1 AS [IsExist]
        FROM
            [dbo].[tblPaymentMode]
        WHERE
            [tblPaymentMode].[CompanyORNo] = @CompanyORNo;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_CheckPRNumber]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--EXEC [sp_CheckOrNumber] '234234234'
CREATE PROCEDURE [dbo].[sp_CheckPRNumber] @CompanyPRNo AS VARCHAR(100) = NULL
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            1 AS [IsExist]
        FROM
            [dbo].[tblPaymentMode]
        WHERE
            [tblPaymentMode].[CompanyPRNo] = @CompanyPRNo;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_CloseContract]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CloseContract]
    @ReferenceID  VARCHAR(50) = NULL,
    @EncodedBy    INT         = NULL,
    @ComputerName VARCHAR(20) = NULL
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @Message_Code NVARCHAR(MAX);

        -- Insert statements for procedure here
        UPDATE
            [dbo].[tblUnitReference]
        SET
            [tblUnitReference].[IsDone] = 1,
            [tblUnitReference].[LastCHangedBy] = @EncodedBy,
            [tblUnitReference].[ContactDoneDate] = GETDATE()
        WHERE
            [tblUnitReference].[RefId] = @ReferenceID;

        IF (@@ROWCOUNT > 0)
            BEGIN
                -- Log a success event
                INSERT INTO [dbo].[LoggingEvent]
                    (
                        [EventType],
                        [EventMessage]
                    )
                VALUES
                    (
                        'SUCCESS',
                        'Result From : sp_CloseContract -(' + @ReferenceID
                        + ': IsDone=1) tblUnitReference updated successfully'
                    );

                SET @Message_Code = N'SUCCESS';
            END;
        ELSE
            BEGIN
                -- Log an error event
                INSERT INTO [dbo].[LoggingEvent]
                    (
                        [EventType],
                        [EventMessage]
                    )
                VALUES
                    (
                        'ERROR', 'Result From : sp_CloseContract -' + 'No rows affected in tblUnitReference table'
                    );

            END;

        UPDATE
            [dbo].[tblUnitMstr]
        SET
            [tblUnitMstr].[UnitStatus] = 'HOLD'
        --LastChangedBy = @EncodedBy,
        --ComputerName = @ComputerName,
        --LastChangedDate = GETDATE()
        WHERE
            [RecId] =
            (
                SELECT
                    [tblUnitReference].[UnitId]
                FROM
                    [dbo].[tblUnitReference] WITH (NOLOCK)
                WHERE
                    [tblUnitReference].[RefId] = @ReferenceID
            );
        IF (@@ROWCOUNT > 0)
            BEGIN
                -- Log a success event
                INSERT INTO [dbo].[LoggingEvent]
                    (
                        [EventType],
                        [EventMessage]
                    )
                VALUES
                    (
                        'SUCCESS',
                        'Result From : sp_CloseContract -(UnitStatus= HOLD) tblUnitMstr updated successfully'
                    );

                SET @Message_Code = N'SUCCESS';
            END;
        ELSE
            BEGIN
                -- Log an error event
                INSERT INTO [dbo].[LoggingEvent]
                    (
                        [EventType],
                        [EventMessage]
                    )
                VALUES
                    (
                        'ERROR', 'Result From : sp_CloseContract -' + 'No rows affected in tblUnitMstr table'
                    );

            END;
        -- Log the error message
        DECLARE @ErrorMessage NVARCHAR(MAX);
        SET @ErrorMessage = ERROR_MESSAGE();

        IF @ErrorMessage <> ''
            BEGIN
                -- Log an error event
                INSERT INTO [dbo].[LoggingEvent]
                    (
                        [EventType],
                        [EventMessage]
                    )
                VALUES
                    (
                        'ERROR', 'From : sp_CloseContract -' + @ErrorMessage
                    );

                -- Insert into a logging table
                INSERT INTO [dbo].[ErrorLog]
                    (
                        [ProcedureName],
                        [ErrorMessage],
                        [LogDateTime]
                    )
                VALUES
                    (
                        'sp_CloseContract', @ErrorMessage, GETDATE()
                    );

                -- Return an error message				
                SET @Message_Code = @ErrorMessage;
            END;

        SELECT
            @Message_Code AS [Message_Code];

    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ConrtactSignedByPass]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ConrtactSignedByPass]
    @ReferenceId      VARCHAR(500) = NULL
   
AS
    BEGIN                 
        -- Update the flag in tblUnitReference
        
            BEGIN
                UPDATE
                    [dbo].[tblUnitReference]
                SET
                    [tblUnitReference].[IsSignedContract] = 1,
                    [tblUnitReference].[SignedContractDate] = GETDATE()
                WHERE
                    [tblUnitReference].[RefId] = @ReferenceId;

                IF (@@ROWCOUNT > 0)
                    BEGIN
                        -- Log a success event
                        INSERT INTO [dbo].[LoggingEvent]
                            (
                                [EventType],
                                [EventMessage]
                            )
                        VALUES
                            (
                                'SUCCESS',
                                'Result From : sp_ConrtactSignedByPass -' + '(' + @ReferenceId
                                + ': IsSignedContract = 1 ) UnitReference updated successfully'
                            );

                        SELECT
                            'SUCCESS' AS [Message_Code];
                    END;
                ELSE
                    BEGIN

                        -- Log an error event
                        INSERT INTO [dbo].[LoggingEvent]
                            (
                                [EventType],
                                [EventMessage]
                            )
                        VALUES
                            (
                                'ERROR', 'Result From : sp_ConrtactSignedByPass -' + 'No rows affected in UnitReference table'
                            );
                    END;
            END;
        -- Log the error message
        DECLARE @ErrorMessage NVARCHAR(MAX);
        SET @ErrorMessage = ERROR_MESSAGE();


        IF @ErrorMessage <> ''
            BEGIN
                -- Log an error event
                INSERT INTO [dbo].[LoggingEvent]
                    (
                        [EventType],
                        [EventMessage]
                    )
                VALUES
                    (
                        'ERROR', 'From : sp_ConrtactSignedByPass -' + @ErrorMessage
                    );

                -- Insert into a logging table
                INSERT INTO [dbo].[ErrorLog]
                    (
                        [ProcedureName],
                        [ErrorMessage],
                        [LogDateTime]
                    )
                VALUES
                    (
                        'sp_ConrtactSignedByPass', @ErrorMessage, GETDATE()
                    );

                -- Return an error message
                SELECT
                    'ERROR'       AS [Message_Code],
                    @ErrorMessage AS [ErrorMessage];
            END;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ContractSignedCommercialReport]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_ContractSignedCommercialReport] @RefId AS VARCHAR(20) = NULL
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
    BEGIN
        SET NOCOUNT ON;



        SELECT
                DAY([dbo].[tblUnitReference].[EncodedDate])                                                                 AS [ThisDayOf],
                DATENAME(MONTH, [dbo].[tblUnitReference].[EncodedDate])                                                     AS [InMonth],
                DATENAME(YEAR, [dbo].[tblUnitReference].[EncodedDate])                                                      AS [OfYear],
                CONVERT(VARCHAR(10), [tblUnitReference].[StatDate], 103) + ' - '
                + CONVERT(VARCHAR(10), [tblUnitReference].[FinishDate], 103)                                                AS [ByAndBetween],
                [tblCompany].[CompanyName]                                                                                  AS [CompanyName],
                [tblCompany].[CompanyAddress]                                                                               AS [CompanyAddress],
                [tblCompany].[CompanyOwnerName]                                                                             AS [CompanyOwnerName],
                [tblClientMstr].[ClientName]                                                                                AS [LesseeName],            ---CLIENT NAME
                'Certificate of Title No. 001-2021003286'                                                                   AS [CertificateOfTitle],
                'Under The Trade Name Of'                                                                                   AS [UnderTheTradeNameOf],   ---CLIENT UNDER OF?
                [tblClientMstr].[PostalAddress]                                                                             AS [LesseeAddress],         ---CLIENT ADDRESS


                UPPER([tblProjectMstr].[ProjectName])                                                                       AS [TheLessorIsTheOwnerOf], ---PROJECT NAME
                [tblProjectMstr].[ProjectAddress]                                                                           AS [Situated],              ---PROJECT ADDRESS

                [tblUnitMstr].[UnitNo]                                                                                      AS [LeasedUnit],            ---UNIT NUMBER
                [tblUnitMstr].[AreaSqm]                                                                                     AS [AreaOf],                ---UNIT AREA

                UPPER([dbo].[fnNumberToWordsWithDecimalMain]([tblUnitMstr].[AreaSqm])) + 'decimeters'                       AS [AreaByWord],            ---UNIT AREA
                [dbo].[fn_GetDateFullName]([tblUnitReference].[StatDate])                                                   AS [YearStarting],
                [dbo].[fn_GetDateFullName]([tblUnitReference].[FinishDate])                                                 AS [YearEnding],
                CONVERT(VARCHAR(20), [tblUnitReference].[StatDate], 107) + ' - '
                + CONVERT(VARCHAR(20), [tblUnitReference].[FinishDate], 107)                                                AS [PeriodCover],
                [dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[TotalRent]) + ' Pesos Only ('
                + CAST([tblUnitReference].[TotalRent] AS VARCHAR(100)) + ')'                                                AS [RentalForLeased_AmountInWords],
                [dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[SecAndMaintenance]) + '('
                + CAST([tblUnitReference].[SecAndMaintenance] AS VARCHAR(100)) + ')'                                        AS [AsShareInSecAndMaint_AmountInWords],
                [dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[TotalRent]) + '('
                + CAST([tblUnitReference].[TotalRent] AS VARCHAR(100)) + ')'                                                AS [TotalAmountInYear_AmountInWords],
                CAST([tblUnitReference].[Unit_Vat] AS VARCHAR(100)) + ' %'                                                  AS [VatPercentage_WithWords],
                CAST([tblUnitReference].[PenaltyPct] AS VARCHAR(100)) + ' %'                                                AS [PenaltyPercentage_WithWords],
                [tblClientMstr].[ClientName]                                                                                AS [Lessee],
                [tblUnitReference].[Unit_TotalRental]                                                                       AS [MonthlyRentalOfVat],
                [tblUnitReference].[Unit_BaseRentalVatAmount]                                                               AS [Vatlessor],
                [tblUnitReference].[Unit_TaxAmount]                                                                         AS [WithHoldingTax],
                [tblUnitReference].[Unit_TotalRental]                                                                       AS [RentDuePerMonth],
                [tblUnitReference].[GenVat]                                                                                 AS [VatDisplay],
                [tblUnitReference].[WithHoldingTax]                                                                         AS [TaxDisplay],
                [dbo].[fnGetBaseSecAmount]([tblUnitReference].[UnitId])                                                     AS [SecBaseAmount],
                [dbo].[fnGetSecVatAmount]([tblUnitReference].[UnitId])                                                      AS [SecVatAmount],
                [dbo].[fnGetBaseSecAmount]([tblUnitReference].[UnitId])
                + [dbo].[fnGetSecVatAmount]([tblUnitReference].[UnitId])                                                    AS [SecRentDue],
                [tblUnitReference].[Unit_TotalRental]                                                                       AS [TotalRentAmount],
                UPPER([dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[SecDeposit])) + 'PESOS ONLY ' + ' ('
                + CAST(ISNULL([tblUnitReference].[SecDeposit], 0) AS VARCHAR(50)) + ') '                                    AS [SecDepositByWords],
                UPPER([dbo].[fnNumberToWordsWithDecimal]([dbo].[fnGetTotalMonthAdvanceAmount]([tblUnitReference].[RefId])))
                + 'PESOS ONLY ' + ' ('
                + CAST(ISNULL([dbo].[fnGetTotalMonthAdvanceAmount]([tblUnitReference].[RefId]), 0) AS VARCHAR(50)) + ') '   AS [MonthAdvanceByWords],
                UPPER([dbo].[fnNumberToWordsWithDecimal]([dbo].[fnGetTotalMonthPostDatedAmount]([tblUnitReference].[RecId])))
                + 'PESOS ONLY ' + ' ('
                + CAST(ISNULL([dbo].[fnGetTotalMonthPostDatedAmount]([tblUnitReference].[RecId]), 0) AS VARCHAR(50)) + ') ' AS [TotalMonthPostDatedAmount],
                [dbo].[fnGetAdvancePeriodCover]([tblUnitReference].[RefId])                                                 AS [AdvanceMonthPeriodCover],
                [dbo].[fnGetPostDatedPeriodCover]([tblUnitReference].[RecId])                                               AS [PostDatedPeriodCover],
                CAST([tblUnitReference].[SecDeposit] / [tblUnitReference].[TotalRent] AS INT)                               AS [SecDepositCount],
                [dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId])                                            AS [MonthAdvanceCount],
                [dbo].[fnGetPostDatedMonthCount]([tblUnitReference].[RecId])                                                AS [PostDatedCheckCount],
                [dbo].[fnNumberToWordsWithDecimal]([dbo].[fnGetPostDatedMonthCount]([tblUnitReference].[RecId]))            AS [PostDatedCheckCountbyWord],
                CAST(DATENAME(DAY, [tblUnitReference].[StatDate]) AS VARCHAR(50))                                           AS [PostDatedDay],
                [dbo].[fnGetClientIsRenewal]([dbo].[tblUnitReference].[ClientID], [dbo].[tblUnitReference].[ProjectId])
                + '(' + UPPER([dbo].[fnGetProjectTypeByUnitId]([dbo].[tblUnitReference].[UnitId])) + ')'                    AS [ContractTitle]
        FROM
                [dbo].[tblUnitReference] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblProjectMstr] WITH (NOLOCK)
                    ON [dbo].[tblUnitReference].[ProjectId] = [tblProjectMstr].[RecId]
            INNER JOIN
                [dbo].[tblCompany] WITH (NOLOCK)
                    ON [tblProjectMstr].[CompanyId] = [tblCompany].[RecId]
            INNER JOIN
                [dbo].[tblClientMstr] WITH (NOLOCK)
                    ON [tblUnitReference].[ClientID] = [tblClientMstr].[ClientID]
            INNER JOIN
                [dbo].[tblUnitMstr] WITH (NOLOCK)
                    ON [dbo].[tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
        WHERE
                [tblUnitReference].[RefId] = @RefId
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ContractSignedParkingReport]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ContractSignedParkingReport] @RefId AS VARCHAR(20) = NULL
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
                DAY([dbo].[tblUnitReference].[EncodedDate])                                                                                                     AS [ThisDayOf],
                DATENAME(MONTH, [dbo].[tblUnitReference].[EncodedDate])                                                                                         AS [InMonth],
                DATENAME(YEAR, [dbo].[tblUnitReference].[EncodedDate])                                                                                          AS [OfYear],
                CONVERT(VARCHAR(10), [tblUnitReference].[StatDate], 103) + ' - '
                + CONVERT(VARCHAR(10), [tblUnitReference].[FinishDate], 103)                                                                                    AS [ByAndBetween],
                UPPER([tblCompany].[CompanyName])                                                                                                               AS [CompanyName],
                [tblCompany].[CompanyAddress]                                                                                                                   AS [CompanyAddress],
                [tblCompany].[CompanyOwnerName]                                                                                                                 AS [CompanyOwnerName],
                [tblClientMstr].[ClientName]                                                                                                                    AS [LesseeName],            ---CLIENT NAME
                'Under The Trade Name Of'                                                                                                                       AS [UnderTheTradeNameOf],   ---CLIENT UNDER OF?
                [tblClientMstr].[PostalAddress]                                                                                                                 AS [LesseeAddress],         ---CLIENT ADDRESS

                UPPER([tblProjectMstr].[ProjectName])                                                                                                           AS [TheLessorIsTheOwnerOf], ---PROJECT NAME
                [tblProjectMstr].[ProjectAddress]                                                                                                               AS [Situated],              ---PROJECT ADDRESS

                [tblUnitMstr].[UnitNo]                                                                                                                          AS [LeasedUnit],            ---UNIT NUMBER
                [tblUnitMstr].[AreaSqm]                                                                                                                         AS [AreaOf],                ---UNIT AREA

                [dbo].[fn_GetDateFullName]([tblUnitReference].[StatDate])                                                                                       AS [YearStarting],
                [dbo].[fn_GetDateFullName]([tblUnitReference].[FinishDate])                                                                                     AS [YearEnding],
                [dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[Unit_BaseRentalWithVatAmount]) + '('
                + CAST([tblUnitReference].[Unit_BaseRentalWithVatAmount] AS VARCHAR(100)) + ')'                                                                 AS [RentalForLeased_AmountInWords],
                [dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[Unit_SecAndMainWithVatAmount]) + '('
                + CAST([tblUnitReference].[Unit_SecAndMainWithVatAmount] AS VARCHAR(100)) + ')'                                                                 AS [AsShareInSecAndMaint_AmountInWords],
                [dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[TotalRent]) + '('
                + CAST([tblUnitReference].[TotalRent] AS VARCHAR(100)) + ')'                                                                                    AS [TotalAmountInYear_AmountInWords],
                CAST([tblUnitReference].[GenVat] AS VARCHAR(100)) + ' %'                                                                                        AS [VatPercentage_WithWords],
                [tblClientMstr].[ClientName]                                                                                                                    AS [Lessee],
                [dbo].[fnGetClientIsRenewal]([dbo].[tblUnitReference].[ClientID], [dbo].[tblUnitReference].[ProjectId])
                + '(' + 'PARKING' + ')'                                                                                                                         AS [ContractTitle],
                CAST(CONCAT(
                               CONVERT(VARCHAR(10), [tblUnitReference].[StatDate], 101), '-',
                               CONVERT(VARCHAR(10), [tblUnitReference].[FinishDate], 101)
                           ) AS VARCHAR(150))                                                                                                                   AS [TPeriodCoverd],
                CAST(CAST([tblUnitReference].[Unit_BaseRentalWithVatAmount] - [tblUnitReference].[Unit_BaseRentalVatAmount] AS DECIMAL(18, 2)) AS VARCHAR(150)) AS [TMonthlyRental],
                CAST([tblUnitReference].[Unit_SecAndMainAmount] AS VARCHAR(150))                                                                                AS [TSecurityandMaintenance],
                CONCAT(CAST([tblUnitReference].[Unit_Vat] AS VARCHAR(150)), ' % VAT')                                                                           AS [TLableVAT],
                CAST(CAST([tblUnitReference].[Unit_BaseRentalVatAmount] + [tblUnitReference].[Unit_SecAndMainVatAmount] AS DECIMAL(18, 2)) AS VARCHAR(150))     AS [TVAT],
                CAST([tblUnitReference].[Unit_TotalRental] AS VARCHAR(150))                                                                                     AS [TTotalMonthlyRental],
                CAST(DATENAME(DAY, [tblUnitReference].[StatDate]) AS VARCHAR(150))                                                                              AS [DayOfMonth]
        FROM
                [dbo].[tblUnitReference] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblProjectMstr] WITH (NOLOCK)
                    ON [dbo].[tblUnitReference].[ProjectId] = [tblProjectMstr].[RecId]
            INNER JOIN
                [dbo].[tblCompany] WITH (NOLOCK)
                    ON [tblProjectMstr].[CompanyId] = [tblCompany].[RecId]
            INNER JOIN
                [dbo].[tblClientMstr] WITH (NOLOCK)
                    ON [tblUnitReference].[ClientID] = [tblClientMstr].[ClientID]
            INNER JOIN
                [dbo].[tblUnitMstr] WITH (NOLOCK)
                    ON [dbo].[tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
        WHERE
                [tblUnitReference].[RefId] = @RefId


    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ContractSignedResidentialReport]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ContractSignedResidentialReport] @RefId AS VARCHAR(20) = NULL
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
                DAY([dbo].[tblUnitReference].[EncodedDate])                                                                                                 AS [ThisDayOf],
                DATENAME(MONTH, [dbo].[tblUnitReference].[EncodedDate])                                                                                     AS [InMonth],
                DATENAME(YEAR, [dbo].[tblUnitReference].[EncodedDate])                                                                                      AS [OfYear],
                CONVERT(VARCHAR(10), [tblUnitReference].[StatDate], 103) + ' - '
                + CONVERT(VARCHAR(10), [tblUnitReference].[FinishDate], 103)                                                                                AS [ByAndBetween],
                UPPER([tblCompany].[CompanyName])                                                                                                           AS [CompanyName],
                [tblCompany].[CompanyAddress]                                                                                                               AS [CompanyAddress],
                [tblCompany].[CompanyOwnerName]                                                                                                             AS [CompanyOwnerName],
                [tblClientMstr].[ClientName]                                                                                                                AS [LesseeName],            ---CLIENT NAME
                'Under The Trade Name Of'                                                                                                                   AS [UnderTheTradeNameOf],   ---CLIENT UNDER OF?
                [tblClientMstr].[PostalAddress]                                                                                                             AS [LesseeAddress],         ---CLIENT ADDRESS

                UPPER([tblProjectMstr].[ProjectName])                                                                                                       AS [TheLessorIsTheOwnerOf], ---PROJECT NAME
                [tblProjectMstr].[ProjectAddress]                                                                                                           AS [Situated],              ---PROJECT ADDRESS

                [tblUnitMstr].[UnitNo]                                                                                                                      AS [LeasedUnit],            ---UNIT NUMBER
                [tblUnitMstr].[AreaSqm]                                                                                                                     AS [AreaOf],                ---UNIT AREA

                [dbo].[fn_GetDateFullName]([tblUnitReference].[StatDate])                                                                                   AS [YearStarting],
                [dbo].[fn_GetDateFullName]([tblUnitReference].[FinishDate])                                                                                 AS [YearEnding],
                [dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[Unit_BaseRentalWithVatAmount]) + '('
                + CAST([tblUnitReference].[Unit_BaseRentalWithVatAmount] AS VARCHAR(100)) + ')'                                                             AS [RentalForLeased_AmountInWords],
                [dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[Unit_SecAndMainWithVatAmount]) + '('
                + CAST([tblUnitReference].[Unit_SecAndMainWithVatAmount] AS VARCHAR(100)) + ')'                                                             AS [AsShareInSecAndMaint_AmountInWords],
                [dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[TotalRent]) + '('
                + CAST([tblUnitReference].[TotalRent] AS VARCHAR(100)) + ')'                                                                                AS [TotalAmountInYear_AmountInWords],
                CAST([tblUnitReference].[GenVat] AS VARCHAR(100)) + ' %'                                                                                    AS [VatPercentage_WithWords],
                [tblClientMstr].[ClientName]                                                                                                                AS [Lessee],
                [dbo].[fnGetClientIsRenewal]([dbo].[tblUnitReference].[ClientID], [dbo].[tblUnitReference].[ProjectId])
                + '(' + UPPER([dbo].[fnGetProjectTypeByUnitId]([dbo].[tblUnitReference].[UnitId])) + ')'                                                    AS [ContractTitle],
                CAST(CONCAT(
                               CONVERT(VARCHAR(10), [tblUnitReference].[StatDate], 101), '-',
                               CONVERT(VARCHAR(10), [tblUnitReference].[FinishDate], 101)
                           ) AS VARCHAR(150))                                                                                                               AS [TPeriodCoverd],
                CONVERT(
                           VARCHAR,
                           CAST([tblUnitReference].[Unit_BaseRentalWithVatAmount]
                                - [tblUnitReference].[Unit_BaseRentalVatAmount] AS MONEY), 1
                       )                                                                                                                                    AS [TMonthlyRental],
                CONVERT(VARCHAR, CAST([tblUnitReference].[Unit_SecAndMainAmount] AS MONEY), 1)                                                              AS [TSecurityandMaintenance],
                CONCAT(CAST([tblUnitReference].[Unit_Vat] AS VARCHAR(150)), ' % VAT')                                                                       AS [TLableVAT],
                CAST(CAST([tblUnitReference].[Unit_BaseRentalVatAmount] + [tblUnitReference].[Unit_SecAndMainVatAmount] AS DECIMAL(18, 2)) AS VARCHAR(150)) AS [TVAT],
                CONVERT(VARCHAR, CAST([tblUnitReference].[Unit_TotalRental] AS MONEY), 1)                                                                   AS [TTotalMonthlyRental]
        FROM
                [dbo].[tblUnitReference] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblProjectMstr] WITH (NOLOCK)
                    ON [dbo].[tblUnitReference].[ProjectId] = [tblProjectMstr].[RecId]
            INNER JOIN
                [dbo].[tblCompany] WITH (NOLOCK)
                    ON [tblProjectMstr].[CompanyId] = [tblCompany].[RecId]
            INNER JOIN
                [dbo].[tblClientMstr] WITH (NOLOCK)
                    ON [tblUnitReference].[ClientID] = [tblClientMstr].[ClientID]
            INNER JOIN
                [dbo].[tblUnitMstr] WITH (NOLOCK)
                    ON [dbo].[tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
        WHERE
                [tblUnitReference].[RefId] = @RefId


    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ContractSignedWarehouseReport]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_ContractSignedWarehouseReport] @RefId AS VARCHAR(20) = NULL
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
    BEGIN
        SET NOCOUNT ON;


        SELECT
                DAY([dbo].[tblUnitReference].[EncodedDate])                                                                 AS [ThisDayOf],
                DATENAME(MONTH, [dbo].[tblUnitReference].[EncodedDate])                                                     AS [InMonth],
                DATENAME(YEAR, [dbo].[tblUnitReference].[EncodedDate])                                                      AS [OfYear],
                CONVERT(VARCHAR(10), [tblUnitReference].[StatDate], 103) + ' - '
                + CONVERT(VARCHAR(10), [tblUnitReference].[FinishDate], 103)                                                AS [ByAndBetween],
                UPPER([tblCompany].[CompanyName])                                                                           AS [CompanyName],
                [tblCompany].[CompanyAddress]                                                                               AS [CompanyAddress],
                [tblCompany].[CompanyOwnerName]                                                                             AS [CompanyOwnerName],
                [tblClientMstr].[ClientName]                                                                                AS [LesseeName],            ---CLIENT NAME
                'Certificate of Title No. 001-2021003286'                                                                   AS [CertificateOfTitle],
                'Under The Trade Name Of'                                                                                   AS [UnderTheTradeNameOf],   ---CLIENT UNDER OF?
                [tblClientMstr].[PostalAddress]                                                                             AS [LesseeAddress],         ---CLIENT ADDRESS


                UPPER([tblProjectMstr].[ProjectName])                                                                       AS [TheLessorIsTheOwnerOf], ---PROJECT NAME
                [tblProjectMstr].[ProjectAddress]                                                                           AS [Situated],              ---PROJECT ADDRESS

                [tblUnitMstr].[UnitNo]                                                                                      AS [LeasedUnit],            ---UNIT NUMBER
                [tblUnitMstr].[AreaSqm]                                                                                     AS [AreaOf],                ---UNIT AREA

                UPPER([dbo].[fnNumberToWordsWithDecimalMain]([tblUnitMstr].[AreaSqm]))                                      AS [AreaByWord],            ---UNIT AREA


                [dbo].[fn_GetDateFullName]([tblUnitReference].[StatDate])                                                   AS [YearStarting],
                [dbo].[fn_GetDateFullName]([tblUnitReference].[FinishDate])                                                 AS [YearEnding],
                CONVERT(VARCHAR(20), [tblUnitReference].[StatDate], 107) + ' - '
                + CONVERT(VARCHAR(20), [tblUnitReference].[FinishDate], 107)                                                AS [PeriodCover],
                [dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[TotalRent]) + ' Pesos Only ('
                + CAST([tblUnitReference].[TotalRent] AS VARCHAR(100)) + ')'                                                AS [RentalForLeased_AmountInWords],
                [dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[SecAndMaintenance]) + '('
                + CAST([tblUnitReference].[SecAndMaintenance] AS VARCHAR(100)) + ')'                                        AS [AsShareInSecAndMaint_AmountInWords],
                [dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[TotalRent]) + '('
                + CAST([tblUnitReference].[TotalRent] AS VARCHAR(100)) + ')'                                                AS [TotalAmountInYear_AmountInWords],
                CAST([tblUnitReference].[Unit_Vat] AS VARCHAR(100)) + ' %'                                                  AS [VatPercentage_WithWords],
                CAST([tblUnitReference].[PenaltyPct] AS VARCHAR(100)) + ' %'                                                AS [PenaltyPercentage_WithWords],
                [tblClientMstr].[ClientName]                                                                                AS [Lessee],
                [tblUnitReference].[Unit_TotalRental]                                                                       AS [MonthlyRentalOfVat],
                [tblUnitReference].[Unit_BaseRentalVatAmount]                                                               AS [Vatlessor],
                [tblUnitReference].[Unit_TaxAmount]                                                                         AS [WithHoldingTax],
                [tblUnitReference].[Unit_TotalRental]                                                                       AS [RentDuePerMonth],
                [tblUnitReference].[GenVat]                                                                                 AS [VatDisplay],
                [tblUnitReference].[WithHoldingTax]                                                                         AS [TaxDisplay],
                [tblUnitReference].[Unit_SecAndMainAmount]                                                                  AS [SecBaseAmount],
                [dbo].[fnGetSecVatAmount]([tblUnitReference].[UnitId])                                                      AS [SecVatAmount],
                [tblUnitReference].[Unit_SecAndMainWithVatAmount]                                                           AS [SecRentDue],
                [tblUnitReference].[Unit_TotalRental]                                                                       AS [TotalRentAmount],
                UPPER([dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[SecDeposit])) + 'PESOS ONLY ' + ' ('
                + CAST(ISNULL([tblUnitReference].[SecDeposit], 0) AS VARCHAR(50)) + ') '                                    AS [SecDepositByWords],
                UPPER([dbo].[fnNumberToWordsWithDecimal]([dbo].[fnGetTotalMonthAdvanceAmount]([tblUnitReference].[RefId])))
                + 'PESOS ONLY ' + ' ('
                + CAST(ISNULL([dbo].[fnGetTotalMonthAdvanceAmount]([tblUnitReference].[RefId]), 0) AS VARCHAR(50)) + ') '   AS [MonthAdvanceByWords],
                UPPER([dbo].[fnNumberToWordsWithDecimal]([dbo].[fnGetTotalMonthPostDatedAmount]([tblUnitReference].[RecId])))
                + 'PESOS ONLY ' + ' ('
                + CAST(ISNULL([dbo].[fnGetTotalMonthPostDatedAmount]([tblUnitReference].[RecId]), 0) AS VARCHAR(50)) + ') ' AS [TotalMonthPostDatedAmountInWords],
                [dbo].[fnGetAdvancePeriodCover]([tblUnitReference].[RefId])                                                 AS [AdvanceMonthPeriodCover],
                [dbo].[fnGetPostDatedPeriodCover]([tblUnitReference].[RecId])                                               AS [PostDatedPeriodCover],
                CAST([tblUnitReference].[SecDeposit] / [tblUnitReference].[TotalRent] AS INT)                               AS [SecDepositCount],
                [dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId])                                            AS [MonthAdvanceCount],
                [dbo].[fnGetPostDatedMonthCount]([tblUnitReference].[RecId])                                                AS [PostDatedCheckCount],
                [dbo].[fnNumberToWordsWithDecimal]([dbo].[fnGetPostDatedMonthCount]([tblUnitReference].[RecId]))            AS [PostDatedCheckCountbyWord],
                CAST(DATENAME(DAY, [tblUnitReference].[StatDate]) AS VARCHAR(50))                                           AS [PostDatedDay],
                [dbo].[fnGetClientIsRenewal]([dbo].[tblUnitReference].[ClientID], [dbo].[tblUnitReference].[ProjectId])
                + '(' + UPPER([dbo].[fnGetProjectTypeByUnitId]([dbo].[tblUnitReference].[UnitId])) + ')'                    AS [ContractTitle]
        --[fnGetTotalMonthPostDatedAmount]
        FROM
                [dbo].[tblUnitReference] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblProjectMstr] WITH (NOLOCK)
                    ON [dbo].[tblUnitReference].[ProjectId] = [tblProjectMstr].[RecId]
            INNER JOIN
                [dbo].[tblCompany] WITH (NOLOCK)
                    ON [tblProjectMstr].[CompanyId] = [tblCompany].[RecId]
            INNER JOIN
                [dbo].[tblClientMstr] WITH (NOLOCK)
                    ON [tblUnitReference].[ClientID] = [tblClientMstr].[ClientID]
            INNER JOIN
                [dbo].[tblUnitMstr] WITH (NOLOCK)
                    ON [dbo].[tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
        WHERE
                [tblUnitReference].[RefId] = @RefId
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_DeActivateLocationById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeActivateLocationById] @RecId INT
AS
    BEGIN

        SET NOCOUNT ON;

        UPDATE
            [dbo].[tblLocationMstr]
        SET
            [tblLocationMstr].[IsActive] = 0
        WHERE
            [tblLocationMstr].[RecId] = @RecId;

        IF (@@ROWCOUNT > 0)
            BEGIN

                SELECT
                    'SUCCESS' AS [Message_Code];

            END;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_DeActivatePojectById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeActivatePojectById] @RecId INT
AS
    BEGIN

        SET NOCOUNT ON;

        UPDATE
            [dbo].[tblProjectMstr]
        SET
            [tblProjectMstr].[IsActive] = 0
        WHERE
            [tblProjectMstr].[RecId] = @RecId;

        IF (@@ROWCOUNT > 0)
            BEGIN

                SELECT
                    'SUCCESS' AS [Message_Code];

            END;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_DeactivatePurchaseItemById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC sp_GetPurchaseItemInfoById @RecId = 2
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeactivatePurchaseItemById] @RecId INT
AS
    BEGIN

        SET NOCOUNT ON;

        UPDATE
            [dbo].[tblProjPurchItem]
        SET
            [tblProjPurchItem].[IsActive] = 0
        WHERE
            [tblProjPurchItem].[RecId] = @RecId;


        IF (@@ROWCOUNT > 0)
            BEGIN
                SELECT
                    'SUCCESS' AS [Message_Code];
            END;


    END;

GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteBankName]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeleteBankName] @BankName VARCHAR(50) = NULL
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @Message_Code VARCHAR(MAX) = '';
        -- Insert statements for procedure here
        IF EXISTS
            (
                SELECT
                    [tblBankName].[BankName]
                FROM
                    [dbo].[tblBankName]
                WHERE
                    [tblBankName].[BankName] = @BankName
            )
            BEGIN

                DELETE FROM
                [dbo].[tblBankName]
                WHERE
                    [tblBankName].[BankName] = @BankName;
                IF (@@ROWCOUNT > 0)
                    BEGIN
                        SET @Message_Code = 'SUCCESS';
                    END;
            END;

        SELECT
            @Message_Code AS [Message_Code];
    END;

GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteFile]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteFile] @FilePath NVARCHAR(500)
AS
    BEGIN
        DELETE FROM
        [dbo].[Files]
        WHERE
            [Files].[FilePath] = @FilePath;
        -- Log a success event    
        IF (@@ROWCOUNT > 0)
            BEGIN
                -- Log a success event
                INSERT INTO [dbo].[LoggingEvent]
                    (
                        [EventType],
                        [EventMessage]
                    )
                VALUES
                    (
                        'SUCCESS', 'Result From : sp_DeleteFile -(' + @FilePath + ') File deleted successfully'
                    );

                SELECT
                    'SUCCESS' AS [Message_Code];
            END;
        ELSE
            BEGIN


                -- Log an error event
                INSERT INTO [dbo].[LoggingEvent]
                    (
                        [EventType],
                        [EventMessage]
                    )
                VALUES
                    (
                        'ERROR', 'Result From : sp_DeleteFile -' + 'No rows affected in Files table'
                    );
            END;
        -- Log the error message
        DECLARE @ErrorMessage NVARCHAR(MAX);
        SET @ErrorMessage = ERROR_MESSAGE();


        IF @ErrorMessage <> ''
            BEGIN
                -- Log an error event
                INSERT INTO [dbo].[LoggingEvent]
                    (
                        [EventType],
                        [EventMessage]
                    )
                VALUES
                    (
                        'ERROR', 'From : sp_DeleteFile -' + @ErrorMessage
                    );

                -- Insert into a logging table
                INSERT INTO [dbo].[ErrorLog]
                    (
                        [ProcedureName],
                        [ErrorMessage],
                        [LogDateTime]
                    )
                VALUES
                    (
                        'sp_DeleteFile', 'From : sp_DeleteFile -' + @ErrorMessage, GETDATE()
                    );

                -- Return an error message
                SELECT
                    'ERROR'       AS [Message_Code],
                    @ErrorMessage AS [ErrorMessage];
            END;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteLocationById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeleteLocationById] 
					@RecId INT
					
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DELETE FROM tblLocationMstr WHERE RecId = @RecId

	if(@@ROWCOUNT > 0)
	BEGIN

	SELECT 'SUCCESS' AS Message_Code

	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeletePojectById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeletePojectById] @RecId INT
AS
    BEGIN

        SET NOCOUNT ON;


        DELETE FROM
        [dbo].[tblProjectMstr]
        WHERE
            [tblProjectMstr].[RecId] = @RecId;

        IF (@@ROWCOUNT > 0)
            BEGIN

                SELECT
                    'SUCCESS' AS [Message_Code];

            END;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_DeletePurchaseItemById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeletePurchaseItemById] @RecId INT
AS
    BEGIN

        SET NOCOUNT ON;


        DELETE FROM
        [dbo].[tblProjPurchItem]
        WHERE
            [tblProjPurchItem].[RecId] = @RecId;

        IF (@@ROWCOUNT > 0)
            BEGIN

                SELECT
                    'SUCCESS' AS [Message_Code];

            END;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteUnitReferenceById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeleteUnitReferenceById]
    @RecId  INT,
    @UnitId INT
AS
    BEGIN

        SET NOCOUNT ON;

        UPDATE
            [dbo].[tblUnitMstr]
        SET
            [tblUnitMstr].[UnitStatus] = 'VACANT'
        WHERE
            [tblUnitMstr].[RecId] = @UnitId;
        DELETE FROM
        [dbo].[tblUnitReference]
        WHERE
            [tblUnitReference].[RecId] = @RecId;

        IF (@@ROWCOUNT > 0)
            BEGIN

                SELECT
                    'SUCCESS' AS [Message_Code];

            END;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GeneralReport]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE   PROCEDURE [dbo].[sp_GeneralReport]
AS
    BEGIN

        --   CREATE TABLE [#Temp]
        --   (
        --       [Dates] VARCHAR(500),
        --       [ORNumber] VARCHAR(500),
        --       [PRNumber] VARCHAR(500),
        --       [ApplicableMonth] VARCHAR(500),
        --       [Tenant] VARCHAR(500),
        --       [Unit] VARCHAR(500),
        --       [SecurityDeposit] VARCHAR(500),
        --       [BaseRental] VARCHAR(500),
        --       [Penalty] VARCHAR(500),
        --       [Vat] VARCHAR(500),
        --       [SecurityMaintenance] VARCHAR(500),
        --       [Tax] VARCHAR(500),
        --       [Total] VARCHAR(500),
        --       [Remarks] VARCHAR(500)
        --   )


        --INSERT INTO [#Temp]
        --(
        --    [Dates],
        --    [ORNumber],
        --    [PRNumber],
        --    [ApplicableMonth],
        --    [Tenant],
        --    [Unit],
        --    [SecurityDeposit],
        --    [BaseRental],
        --    [Penalty],
        --    [Vat],
        --    [SecurityMaintenance],
        --    [Tax],
        --    [Total],
        --    [Remarks]
        --)
        --VALUES
        --(   NULL, -- Dates - varchar(500)
        --    NULL, -- ORNumber - varchar(500)
        --    NULL, -- PRNumber - varchar(500)
        --    NULL, -- ApplicableMonth - varchar(500)
        --    NULL, -- Tenant - varchar(500)
        --    NULL, -- Unit - varchar(500)
        --    NULL, -- SecurityDeposit - varchar(500)
        --    NULL, -- BaseRental - varchar(500)
        --    NULL, -- Penalty - varchar(500)
        --    NULL, -- Vat - varchar(500)
        --    NULL, -- SecurityMaintenance - varchar(500)
        --    NULL, -- Tax - varchar(500)
        --    NULL, -- Total - varchar(500)
        --    NULL  -- Remarks - varchar(500)
        --    )

        SELECT
                [tblTransaction].[TranID]                                 AS [TransactionNumber],
                CONVERT(VARCHAR(20), [tblTransaction].[EncodedDate], 103) AS [Dates],
                [Receipt].[CompanyORNo]                                   AS [ORNumber],
                [Receipt].[CompanyPRNo]                                   AS [PRNumber],
                [MonthLedgerMain].[LedgMonth]                             AS [ApplicableMonth],
                [tblClientMstr].[ClientName]                              AS [Tenant],
                [tblUnitMstr].[UnitNo]                                    AS [Unit],
                ''                                                        AS [SecurityDeposit],
                ''                                                        AS [BaseRental],
                ''                                                        AS [Penalty],
                ''                                                        AS [Vat],
                ''                                                        AS [SecurityMaintenance],
                ''                                                        AS [Tax],
                ''                                                        AS [Total],
                ''                                                        AS [Remarks]
        --[tblTransaction].[ReceiveAmount]                                                      AS [Amount],
        --ISNULL([MonthLedger].[ActualAmountReceivePerMonth], [tblTransaction].[ReceiveAmount]) AS [ActualAmountReceivePerMonth],
        --[tblClientMstr].[ClientName]                                                          AS [Tenant]
        FROM
                [dbo].[tblTransaction]
            OUTER APPLY
                (
                    SELECT
                        SUM([tblMonthLedger].[ActualAmount]) AS [ActualAmountReceivePerMonth]
                    FROM
                        [dbo].[tblMonthLedger]
                    WHERE
                        [tblTransaction].[TranID] = [tblMonthLedger].[TransactionID]
                    GROUP BY
                        [tblMonthLedger].[TransactionID]
                ) [MonthLedger]
            OUTER APPLY
                (
                    SELECT
                        [tblMonthLedger].[LedgMonth]
                    FROM
                        [dbo].[tblMonthLedger]
                    WHERE
                        [tblTransaction].[TranID] = [tblMonthLedger].[TransactionID]
                ) [MonthLedgerMain]
            OUTER APPLY
                (
                    SELECT
                        [tblReceipt].[CompanyORNo],
                        [tblReceipt].[CompanyPRNo]
                    FROM
                        [dbo].[tblReceipt]
                    WHERE
                        [tblReceipt].[TranId] = [tblTransaction].[TranID]
                ) [Receipt]
            LEFT JOIN
                [dbo].[tblUnitReference]
                    ON [tblUnitReference].[RefId] = [tblTransaction].[RefId]
            INNER JOIN
                [dbo].[tblUnitMstr]
                    ON [tblUnitMstr].[RecId] = [tblUnitReference].[UnitId]
            LEFT JOIN
                [dbo].[tblClientMstr]
                    ON [tblUnitReference].[ClientID] = [tblClientMstr].[ClientID]
    --WHERE [tblUnitReference].[RefId] = 'REF10000000'


    --SELECT *
    --FROM [dbo].[tblUnitReference]
    --SELECT *
    --FROM [dbo].[tblTransaction]
    --SELECT *
    --FROM [dbo].[tblMonthLedger]


    --	SELECT [#Temp].[Dates],
    --       [#Temp].[ORNumber],
    --       [#Temp].[PRNumber],
    --       [#Temp].[ApplicableMonth],
    --       [#Temp].[Tenant],
    --       [#Temp].[Unit],
    --       [#Temp].[SecurityDeposit],
    --       [#Temp].[BaseRental],
    --       [#Temp].[Penalty],
    --       [#Temp].[Vat],
    --       [#Temp].[SecurityMaintenance],
    --       [#Temp].[Tax],
    --       [#Temp].[Total],
    --       [#Temp].[Remarks]
    --FROM [#Temp]


    END
GO
/****** Object:  StoredProcedure [dbo].[sp_GenerateBulkPayment]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_GenerateBulkPayment]
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
    @ReceiptDate       DATETIME       = NULL,
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
        DECLARE @ApplicableMonth1 DATE = NULL
        DECLARE @ApplicableMonth2 DATE = NULL
        DECLARE @IsFullPayment BIT = 0
        DECLARE @TotalRent DECIMAL(18, 2) = NULL
        DECLARE @PenaltyPct DECIMAL(18, 2) = NULL
        DECLARE @ActualAmount DECIMAL(18, 2) = NULL
        DECLARE @AmountToDeduct DECIMAL(18, 2)
        DECLARE @ForMonth DATE
        DECLARE @RefRecId BIGINT = NULL
        DECLARE @ForMonthRecID BIGINT = NULL

        DECLARE @ActualLedgeAMount BIGINT = NULL

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

        UPDATE
            [dbo].[tblMonthLedger]
        SET
            [tblMonthLedger].[ActualAmount] = [tblMonthLedger].[LedgRentalAmount]
                                              + ISNULL([tblMonthLedger].[PenaltyAmount], 0)
        WHERE
            [tblMonthLedger].[ReferenceID] = @RefRecId
            AND
                (
                    ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                    OR ISNULL([tblMonthLedger].[IsHold], 0) = 1
                )



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
            @ActualLedgeAMount

        WHILE @@FETCH_STATUS = 0
            BEGIN


                SELECT
                    @ActualAmount = [tblTransaction].[ActualAmountPaid]
                FROM
                    [dbo].[tblTransaction]
                WHERE
                    [tblTransaction].[RecId] = @TranRecId
                IF @ActualAmount > 0
                    BEGIN
                        UPDATE
                            [dbo].[tblTransaction]
                        SET
                            [tblTransaction].[ActualAmountPaid] = [tblTransaction].[ActualAmountPaid] - @AmountToDeduct
                        WHERE
                            [tblTransaction].[RecId] = @TranRecId

                        IF @ActualAmount >= @AmountToDeduct
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
                                    [tblMonthLedger].[TransactionID] = @TranID
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
                        ELSE IF @ActualAmount < @AmountToDeduct
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
                                    [tblMonthLedger].[BalanceAmount] = ABS(@ActualAmount - @AmountToDeduct),
                                    [tblMonthLedger].[TransactionID] = @TranID --- TRN WILL CHANGE IF ALWAYS A PAYMENT FOR BALANCE AMOUNT
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
                                                @TranID                                AS [TranId],
                                                @RefId                                 AS [RefId],
                                                [tblMonthLedger].[LedgRentalAmount]
                                                - ABS(@ActualAmount - @AmountToDeduct) AS [Amount], ---THIS IS NOT A ACTUAL AMOUNT PAID  FOR FUTURE JOIN TRAN TO PAYMENT TRANID TO GET THE ACTUAL SUM PAYMENT                   
                                                [tblMonthLedger].[LedgMonth]           AS [ForMonth],
                                                'FOLLOW-UP PAYMENT'                    AS [Remarks],
                                                @EncodedBy,
                                                GETDATE(),                                          --Dated payed
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
                    @ActualLedgeAMount
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
                [Remarks],
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
                [ReceiptDate]
            )
        VALUES
            (
                @TranID, @ReceiveAmount, 'FOLLOW-UP PAYMENT', @PaymentRemarks, @EncodedBy, GETDATE(), @ComputerName, 1,
                @ModeType, @CompanyORNo, @CompanyPRNo, @BankAccountName, @BankAccountNumber, @BankName, @SerialNo,
                @REF, @BankBranch, @RefId, @ReceiptDate
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
                [ReceiptDate]
            )
        VALUES
            (
                @RcptID, @CompanyORNo, @CompanyPRNo, @REF, @BankAccountName, @BankAccountNumber, @BankName, @SerialNo,
                @ModeType, @BankBranch, @ReceiptDate
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
/****** Object:  StoredProcedure [dbo].[sp_GenerateFirstPayment]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GenerateFirstPayment]
    -- Add the parameters for the stored procedure here
    @RefId             VARCHAR(50)    = NULL,
    @PaidAmount        DECIMAL(18, 2) = NULL,
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
    @ReceiptDate       DATETIME       = NULL,
    @BankBranch        VARCHAR(100)   = NULL,
    @ModeType          VARCHAR(20)    = NULL
--@XML               XML            = NULL
AS
    BEGIN

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';


        DECLARE @TranRecId BIGINT = 0;
        DECLARE @TranID VARCHAR(150) = '';
        DECLARE @RcptRecId BIGINT = 0;
        DECLARE @RcptID VARCHAR(50) = '';
        --DECLARE @ApplicableMonth1 DATE = NULL;
        --DECLARE @ApplicableMonth2 DATE = NULL;
        DECLARE @IsFullPayment BIT = 0;
        DECLARE @ActualAmount DECIMAL(18, 2) = NULL
        -- Insert statements for procedure here

        SELECT
            @IsFullPayment = ISNULL([tblUnitReference].[IsFullPayment], 0)
        FROM
            [dbo].[tblUnitReference]
        WHERE
            [tblUnitReference].[RefId] = @RefId;

        --CREATE TABLE [#tmpPayments]
        --    (
        --        [LedgAmount] DECIMAL(18, 2),
        --        [LedgMonth]  VARCHAR(20),
        --        [Remarks]    VARCHAR(500),
        --        [ColOR]      VARCHAR(500),
        --        [ColPR]      VARCHAR(500)
        --    )
        --IF (@XML IS NOT NULL)
        --    BEGIN
        --        INSERT INTO [#tmpPayments]
        --            (
        --                [LedgAmount],
        --                [LedgMonth],
        --                [Remarks],
        --                [ColOR],
        --                [ColPR]
        --            )
        --                    SELECT
        --                        [ParaValues].[data].[value]('c1[1]', 'DECIMAL(18,2)'),
        --                        [ParaValues].[data].[value]('c2[1]', 'VARCHAR(150)'),
        --                        [ParaValues].[data].[value]('c3[1]', 'VARCHAR(500)'),
        --                        [ParaValues].[data].[value]('c4[1]', 'VARCHAR(150)'),
        --                        [ParaValues].[data].[value]('c5[1]', 'VARCHAR(150)')
        --                    FROM
        --                        @XML.[nodes]('/Table1') AS [ParaValues]([data]);
        --VALUES
        --    (
        --        @ClientType, @ClientName, @Age, @PostalAddress, @DateOfBirth, @TelNumber, @Gender, @Nationality,
        --        @Occupation, @AnnualIncome, @EmployerName, @EmployerAddress, @SpouseName, @ChildrenNames,
        --        @TotalPersons, @MaidName, @DriverName, @VisitorsPerDay, @BuildingSecretary, GETDATE(), @EncodedBy, 1,
        --        @ComputerName, @TIN_No
        --    );
        --END;
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
                @RefId, @PaidAmount, @ReceiveAmount, @ReceiveAmount, @ChangeAmount,
                IIF(@IsFullPayment = 1,
                    'FULL PAYMENT',
                    IIF(@PaidAmount > @ReceiveAmount, 'PARTIAL - FIRST PAYMENT', 'FIRST PAYMENT')), @EncodedBy,
                GETDATE(), @ComputerName, 1
            );

        SET @TranRecId = @@IDENTITY;
        SELECT
            @TranID = [tblTransaction].[TranID]
        FROM
            [dbo].[tblTransaction]
        WHERE
            [tblTransaction].[RecId] = @TranRecId;

        SELECT
            @ActualAmount = [tblTransaction].[ActualAmountPaid]
        FROM
            [dbo].[tblTransaction]
        WHERE
            [tblTransaction].[RecId] = @TranRecId

        --1). IF Paid Amount > Actual amount ---IS Partial Payment-
        --2). Create A flag in UnitReference As Partial Payment--- Only for First Payment
        --3). Save The Balance Amount-IN UnitReference FirtsPaymentBalanceAmount
        --4). if parial payment dont insert in payment the security and maintenance only after will payall and datepay will be the final date last pay

        --IN PAYMENT HISTORy TO GET THE TRANSACTION FOR FIRST PARTIAL PAYMENT SUM THE AMOUNT OF [Remarks]= 'PARTIAL - FIRST PAYMENT' 
        --then MAP the MAX transactionid to tblpayment then display the payment history

        IF @IsFullPayment = 0
            BEGIN
                IF @PaidAmount > @ActualAmount
                    BEGIN

                        --PARTIAL PAYMENT

                        UPDATE
                            [dbo].[tblUnitReference]
                        SET
                            [tblUnitReference].[IsPartialPayment] = 1,
                            [tblUnitReference].[FirtsPaymentBalanceAmount] = ABS(@PaidAmount - @ActualAmount)
                        WHERE
                            [tblUnitReference].[RefId] = @RefId

                        INSERT INTO [dbo].[tblReceipt]
                            (
                                [TranId],
                                [Amount],
                                [Description],
                                [Remarks],
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
                                [ReceiptDate]
                            )
                        VALUES
                            (
                                @TranID, @ReceiveAmount, 'PARTIAL - FIRST PAYMENT', @PaymentRemarks, @EncodedBy,
                                GETDATE(), @ComputerName, 1, @ModeType, @CompanyORNo, @CompanyPRNo, @BankAccountName,
                                @BankAccountNumber, @BankName, @SerialNo, @REF, @BankBranch, @RefId, @ReceiptDate
                            );


                        SET @RcptRecId = @@IDENTITY;
                        SELECT
                            @RcptID = [tblReceipt].[RcptID]
                        FROM
                            [dbo].[tblReceipt] WITH (NOLOCK)
                        WHERE
                            [tblReceipt].[RecId] = @RcptRecId;

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
                                [ReceiptDate]
                            )
                        VALUES
                            (
                                @RcptID, @CompanyORNo, @CompanyPRNo, @REF, @BankAccountName, @BankAccountNumber,
                                @BankName, @SerialNo, @ModeType, @BankBranch, @ReceiptDate
                            );

                    END
                ELSE
                    BEGIN
                        UPDATE
                            [dbo].[tblUnitReference]
                        SET
                            [tblUnitReference].[FirtsPaymentBalanceAmount] = 0
                        WHERE
                            [tblUnitReference].[RefId] = @RefId
                        INSERT INTO [dbo].[tblPayment]
                            (
                                [TranId],
                                [RefId],
                                [Amount],
                                [ForMonth],
                                [Remarks],
                                [Notes],
                                [EncodedBy],
                                [EncodedDate],
                                [ComputerName],
                                [IsActive],
                                [LedgeRecid]
                            )
                                    --SELECT
                                    --    @TranID                             AS [TranId],
                                    --    @RefId                              AS [RefId],
                                    --    [tblMonthLedger].[LedgRentalAmount] AS [Amount],
                                    --    [tblMonthLedger].[LedgMonth]        AS [ForMonth],
                                    --    'MONTHS ADVANCE'                    AS [Remarks],
                                    --    [tblMonthLedger].[Remarks]          AS [Notes],
                                    --    @EncodedBy,
                                    --    GETDATE(), --Dated payed
                                    --    @ComputerName,
                                    --    1,
                                    --    [tblMonthLedger].[Recid]
                                    --FROM
                                    --    [dbo].[tblMonthLedger] WITH (NOLOCK)
                                    --WHERE
                                    --    [tblMonthLedger].[ReferenceID] =
                                    --    (
                                    --        SELECT
                                    --            [tblUnitReference].[RecId]
                                    --        FROM
                                    --            [dbo].[tblUnitReference] WITH (NOLOCK)
                                    --        WHERE
                                    --            [tblUnitReference].[RefId] = @RefId
                                    --    )
                                    --    AND [tblMonthLedger].[LedgMonth] IN
                                    --            (
                                    --                SELECT
                                    --                    [tblAdvancePayment].[Months]
                                    --                FROM
                                    --                    [dbo].[tblAdvancePayment] WITH (NOLOCK)
                                    --                WHERE
                                    --                    [tblAdvancePayment].[RefId] = @RefId
                                    --            )
                                    --    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                                    --    AND ISNULL([tblMonthLedger].[TransactionID], '') = ''
                                    --UNION
                                    SELECT
                                        @TranID                  AS [TranId],
                                        @RefId                   AS [RefId],
                                        @SecAmountADV            AS [Amount],
                                        CONVERT(DATE, GETDATE()) AS [ForMonth],
                                        'SECURITY DEPOSIT'       AS [Remarks],
                                        NULL,
                                        @EncodedBy,
                                        GETDATE(),
                                        @ComputerName,
                                        1,
                                        0

                        UPDATE
                            [dbo].[tblUnitReference]
                        SET
                            [tblUnitReference].[IsPaid] = 1
                        WHERE
                            [tblUnitReference].[RefId] = @RefId;

                        --UPDATE
                        --    [dbo].[tblMonthLedger]
                        --SET
                        --    [tblMonthLedger].[IsPaid] = 1,
                        --    [tblMonthLedger].[CompanyORNo] = @CompanyORNo,
                        --    [tblMonthLedger].[CompanyPRNo] = @CompanyPRNo,
                        --    [tblMonthLedger].[REF] = @REF,
                        --    [tblMonthLedger].[BNK_ACCT_NAME] = @BankAccountName,
                        --    [tblMonthLedger].[BNK_ACCT_NUMBER] = @BankAccountNumber,
                        --    [tblMonthLedger].[BNK_NAME] = @BankName,
                        --    [tblMonthLedger].[SERIAL_NO] = @SerialNo,
                        --    [tblMonthLedger].[ModeType] = @ModeType,
                        --    [tblMonthLedger].[BankBranch] = @BankBranch,
                        --    [tblMonthLedger].[TransactionID] = @TranID
                        --WHERE
                        --    [tblMonthLedger].[ReferenceID] =
                        --    (
                        --        SELECT
                        --            [tblUnitReference].[RecId]
                        --        FROM
                        --            [dbo].[tblUnitReference] WITH (NOLOCK)
                        --        WHERE
                        --            [tblUnitReference].[RefId] = @RefId
                        --    )
                        --    AND [tblMonthLedger].[LedgMonth] IN
                        --            (
                        --                SELECT
                        --                    [tblAdvancePayment].[Months]
                        --                FROM
                        --                    [dbo].[tblAdvancePayment] WITH (NOLOCK)
                        --                WHERE
                        --                    [tblAdvancePayment].[RefId] = @RefId
                        --            )
                        --    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                        --    AND ISNULL([tblMonthLedger].[TransactionID], '') = '';

                        INSERT INTO [dbo].[tblReceipt]
                            (
                                [TranId],
                                [Amount],
                                [Description],
                                [Remarks],
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
                                [ReceiptDate]
                            )
                        VALUES
                            (
                                @TranID, @PaidAmount, 'FIRST PAYMENT', @PaymentRemarks, @EncodedBy, GETDATE(),
                                @ComputerName, 1, @ModeType, @CompanyORNo, @CompanyPRNo, @BankAccountName,
                                @BankAccountNumber, @BankName, @SerialNo, @REF, @BankBranch, @RefId, @ReceiptDate
                            );
                        --SELECT
                        --    @TranID,
                        --    [#tmpPayments].[LedgAmount],
                        --    'FIRST PAYMENT',
                        --    [#tmpPayments].[Remarks],
                        --    @EncodedBy,
                        --    GETDATE(),
                        --    @ComputerName,
                        --    1,
                        --    @ModeType,
                        --    [#tmpPayments].[ColOR],
                        --    [#tmpPayments].[ColPR],
                        --    @BankAccountName,
                        --    @BankAccountNumber,
                        --    @BankName,
                        --    @SerialNo,
                        --    @REF,
                        --    @BankBranch,
                        --    @RefId,
                        --    @ReceiptDate
                        --FROM
                        --    [#tmpPayments]

                        SET @RcptRecId = @@IDENTITY;
                        SELECT
                            @RcptID = [tblReceipt].[RcptID]
                        FROM
                            [dbo].[tblReceipt] WITH (NOLOCK)
                        WHERE
                            [tblReceipt].[RecId] = @RcptRecId;

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
                                [ReceiptDate]
                            )
                        VALUES
                            (
                                @RcptID, @CompanyORNo, @CompanyPRNo, @REF, @BankAccountName, @BankAccountNumber,
                                @BankName, @SerialNo, @ModeType, @BankBranch, @ReceiptDate
                            );
                    --SELECT
                    --    @RcptID,
                    --    [#tmpPayments].[ColOR],
                    --    [#tmpPayments].[ColPR],
                    --    @REF,
                    --    @BankAccountName,
                    --    @BankAccountNumber,
                    --    @BankName,
                    --    @SerialNo,
                    --    @ModeType,
                    --    @BankBranch,
                    --    @ReceiptDate
                    --FROM
                    --    [#tmpPayments]
                    END
            END
        ELSE IF @IsFullPayment = 1
            BEGIN


                BEGIN
                    UPDATE
                        [dbo].[tblUnitReference]
                    SET
                        [tblUnitReference].[FirtsPaymentBalanceAmount] = 0
                    WHERE
                        [tblUnitReference].[RefId] = @RefId


                    UPDATE
                        [dbo].[tblUnitReference]
                    SET
                        [tblUnitReference].[IsPaid] = 1
                    WHERE
                        [tblUnitReference].[RefId] = @RefId;


                    UPDATE
                        [dbo].[tblMonthLedger]
                    SET
                        [tblMonthLedger].[IsPaid] = 1,
                        [tblMonthLedger].[CompanyORNo] = @CompanyORNo,
                        [tblMonthLedger].[CompanyPRNo] = @CompanyPRNo,
                        [tblMonthLedger].[REF] = @REF,
                        [tblMonthLedger].[BNK_ACCT_NAME] = @BankAccountName,
                        [tblMonthLedger].[BNK_ACCT_NUMBER] = @BankAccountNumber,
                        [tblMonthLedger].[BNK_NAME] = @BankName,
                        [tblMonthLedger].[SERIAL_NO] = @SerialNo,
                        [tblMonthLedger].[ModeType] = @ModeType,
                        [tblMonthLedger].[BankBranch] = @BankBranch,
                        [tblMonthLedger].[TransactionID] = @TranID
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
                        AND ISNULL([IsPaid], 0) = 0
                        AND ISNULL([tblMonthLedger].[TransactionID], '') = '';

                    INSERT INTO [dbo].[tblReceipt]
                        (
                            [TranId],
                            [Amount],
                            [Description],
                            [Remarks],
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
                            [ReceiptDate]
                        )
                    VALUES
                        (
                            @TranID, @PaidAmount, 'FULL PAYMENT', @PaymentRemarks, @EncodedBy, GETDATE(),
                            @ComputerName, 1, @ModeType, @CompanyORNo, @CompanyPRNo, @BankAccountName,
                            @BankAccountNumber, @BankName, @SerialNo, @REF, @BankBranch, @RefId, @ReceiptDate
                        );

                    SET @RcptRecId = @@IDENTITY;
                    SELECT
                        @RcptID = [tblReceipt].[RcptID]
                    FROM
                        [dbo].[tblReceipt] WITH (NOLOCK)
                    WHERE
                        [tblReceipt].[RecId] = @RcptRecId;

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
                            [ReceiptDate]
                        )
                    VALUES
                        (
                            @RcptID, @CompanyORNo, @CompanyPRNo, @REF, @BankAccountName, @BankAccountNumber, @BankName,
                            @SerialNo, @ModeType, @BankBranch, @ReceiptDate
                        );
                END

            END;

        IF (
               @TranID <> ''
               AND @@ROWCOUNT > 0
           )
            BEGIN

                SET @Message_Code = 'SUCCESS'

            END;

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
                        'sp_GenerateFirstPayment', @ErrorMessage, GETDATE()
                    );
            END
        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code],
            @RcptID       AS [ReceiptID],
            @TranID       AS [TranID]


    --DROP TABLE [#tmpPayments]
    END
GO
/****** Object:  StoredProcedure [dbo].[sp_GenerateFirstPaymentParking]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_GenerateFirstPaymentParking]
    -- Add the parameters for the stored procedure here
    @RefId             VARCHAR(50)    = NULL,
    @PaidAmount        DECIMAL(18, 2) = NULL,
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
    @ReceiptDate       DATETIME       = NULL,
    @BankBranch        VARCHAR(100)   = NULL,
    @ModeType          VARCHAR(20)    = NULL
--@XML               XML            = NULL
AS
    BEGIN

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';


        DECLARE @TranRecId BIGINT = 0;
        DECLARE @TranID VARCHAR(150) = '';
        DECLARE @RcptRecId BIGINT = 0;
        DECLARE @RcptID VARCHAR(50) = '';
        --DECLARE @ApplicableMonth1 DATE = NULL;
        --DECLARE @ApplicableMonth2 DATE = NULL;
        DECLARE @IsFullPayment BIT = 0;
        DECLARE @ActualAmount DECIMAL(18, 2) = NULL
        -- Insert statements for procedure here

        SELECT
            @IsFullPayment = ISNULL([tblUnitReference].[IsFullPayment], 0)
        FROM
            [dbo].[tblUnitReference]
        WHERE
            [tblUnitReference].[RefId] = @RefId;

        --CREATE TABLE [#tmpPayments]
        --    (
        --        [LedgAmount] DECIMAL(18, 2),
        --        [LedgMonth]  VARCHAR(20),
        --        [Remarks]    VARCHAR(500),
        --        [ColOR]      VARCHAR(500),
        --        [ColPR]      VARCHAR(500)
        --    )
        --IF (@XML IS NOT NULL)
        --    BEGIN
        --        INSERT INTO [#tmpPayments]
        --            (
        --                [LedgAmount],
        --                [LedgMonth],
        --                [Remarks],
        --                [ColOR],
        --                [ColPR]
        --            )
        --                    SELECT
        --                        [ParaValues].[data].[value]('c1[1]', 'DECIMAL(18,2)'),
        --                        [ParaValues].[data].[value]('c2[1]', 'VARCHAR(150)'),
        --                        [ParaValues].[data].[value]('c3[1]', 'VARCHAR(500)'),
        --                        [ParaValues].[data].[value]('c4[1]', 'VARCHAR(150)'),
        --                        [ParaValues].[data].[value]('c5[1]', 'VARCHAR(150)')
        --                    FROM
        --                        @XML.[nodes]('/Table1') AS [ParaValues]([data]);
        --VALUES
        --    (
        --        @ClientType, @ClientName, @Age, @PostalAddress, @DateOfBirth, @TelNumber, @Gender, @Nationality,
        --        @Occupation, @AnnualIncome, @EmployerName, @EmployerAddress, @SpouseName, @ChildrenNames,
        --        @TotalPersons, @MaidName, @DriverName, @VisitorsPerDay, @BuildingSecretary, GETDATE(), @EncodedBy, 1,
        --        @ComputerName, @TIN_No
        --    );
        --END;
        --INSERT INTO [dbo].[tblTransaction]
        --    (
        --        [RefId],
        --        [PaidAmount],
        --        [ReceiveAmount],
        --        [ActualAmountPaid],
        --        [ChangeAmount], ---Not Assigned
        --        [Remarks],
        --        [EncodedBy],
        --        [EncodedDate],
        --        [ComputerName],
        --        [IsActive]
        --    )
        --VALUES
        --    (
        --        @RefId, @PaidAmount, @ReceiveAmount, @ReceiveAmount, @ChangeAmount,
        --        IIF(@IsFullPayment = 1,
        --            'FULL PAYMENT',
        --            IIF(@PaidAmount > @ReceiveAmount, 'PARTIAL - FIRST PAYMENT', 'FIRST PAYMENT')), @EncodedBy,
        --        GETDATE(), @ComputerName, 1
        --    );

        --SET @TranRecId = @@IDENTITY;
        --SELECT
        --    @TranID = [tblTransaction].[TranID]
        --FROM
        --    [dbo].[tblTransaction]
        --WHERE
        --    [tblTransaction].[RecId] = @TranRecId;

        --SELECT
        --    @ActualAmount = [tblTransaction].[ActualAmountPaid]
        --FROM
        --    [dbo].[tblTransaction]
        --WHERE
        --    [tblTransaction].[RecId] = @TranRecId

        --1). IF Paid Amount > Actual amount ---IS Partial Payment-
        --2). Create A flag in UnitReference As Partial Payment--- Only for First Payment
        --3). Save The Balance Amount-IN UnitReference FirtsPaymentBalanceAmount
        --4). if parial payment dont insert in payment the security and maintenance only after will payall and datepay will be the final date last pay

        --IN PAYMENT HISTORy TO GET THE TRANSACTION FOR FIRST PARTIAL PAYMENT SUM THE AMOUNT OF [Remarks]= 'PARTIAL - FIRST PAYMENT' 
        --then MAP the MAX transactionid to tblpayment then display the payment history

        IF @IsFullPayment = 0
            BEGIN
                IF @PaidAmount > @ActualAmount
                    BEGIN

                        --PARTIAL PAYMENT

                        UPDATE
                            [dbo].[tblUnitReference]
                        SET
                            [tblUnitReference].[IsPartialPayment] = 1,
                            [tblUnitReference].[FirtsPaymentBalanceAmount] = ABS(@PaidAmount - @ActualAmount)
                        WHERE
                            [tblUnitReference].[RefId] = @RefId

                        INSERT INTO [dbo].[tblReceipt]
                            (
                                [TranId],
                                [Amount],
                                [Description],
                                [Remarks],
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
                                [ReceiptDate]
                            )
                        VALUES
                            (
                                @TranID, @ReceiveAmount, 'PARTIAL - FIRST PAYMENT', @PaymentRemarks, @EncodedBy,
                                GETDATE(), @ComputerName, 1, @ModeType, @CompanyORNo, @CompanyPRNo, @BankAccountName,
                                @BankAccountNumber, @BankName, @SerialNo, @REF, @BankBranch, @RefId, @ReceiptDate
                            );


                        SET @RcptRecId = @@IDENTITY;
                        SELECT
                            @RcptID = [tblReceipt].[RcptID]
                        FROM
                            [dbo].[tblReceipt] WITH (NOLOCK)
                        WHERE
                            [tblReceipt].[RecId] = @RcptRecId;

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
                                [ReceiptDate]
                            )
                        VALUES
                            (
                                @RcptID, @CompanyORNo, @CompanyPRNo, @REF, @BankAccountName, @BankAccountNumber,
                                @BankName, @SerialNo, @ModeType, @BankBranch, @ReceiptDate
                            );

                    END
                ELSE
                    BEGIN
                        UPDATE
                            [dbo].[tblUnitReference]
                        SET
                            [tblUnitReference].[FirtsPaymentBalanceAmount] = 0
                        WHERE
                            [tblUnitReference].[RefId] = @RefId
                        --INSERT INTO [dbo].[tblPayment]
                        --    (
                        --        [TranId],
                        --        [RefId],
                        --        [Amount],
                        --        [ForMonth],
                        --        [Remarks],
                        --        [Notes],
                        --        [EncodedBy],
                        --        [EncodedDate],
                        --        [ComputerName],
                        --        [IsActive],
                        --        [LedgeRecid]
                        --    )
                        --SELECT
                        --    @TranID                             AS [TranId],
                        --    @RefId                              AS [RefId],
                        --    [tblMonthLedger].[LedgRentalAmount] AS [Amount],
                        --    [tblMonthLedger].[LedgMonth]        AS [ForMonth],
                        --    'MONTHS ADVANCE'                    AS [Remarks],
                        --    [tblMonthLedger].[Remarks]          AS [Notes],
                        --    @EncodedBy,
                        --    GETDATE(), --Dated payed
                        --    @ComputerName,
                        --    1,
                        --    [tblMonthLedger].[Recid]
                        --FROM
                        --    [dbo].[tblMonthLedger] WITH (NOLOCK)
                        --WHERE
                        --    [tblMonthLedger].[ReferenceID] =
                        --    (
                        --        SELECT
                        --            [tblUnitReference].[RecId]
                        --        FROM
                        --            [dbo].[tblUnitReference] WITH (NOLOCK)
                        --        WHERE
                        --            [tblUnitReference].[RefId] = @RefId
                        --    )
                        --    AND [tblMonthLedger].[LedgMonth] IN
                        --            (
                        --                SELECT
                        --                    [tblAdvancePayment].[Months]
                        --                FROM
                        --                    [dbo].[tblAdvancePayment] WITH (NOLOCK)
                        --                WHERE
                        --                    [tblAdvancePayment].[RefId] = @RefId
                        --            )
                        --    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                        --    AND ISNULL([tblMonthLedger].[TransactionID], '') = ''
                        --UNION
                        --SELECT
                        --    @TranID                  AS [TranId],
                        --    @RefId                   AS [RefId],
                        --    @SecAmountADV            AS [Amount],
                        --    CONVERT(DATE, GETDATE()) AS [ForMonth],
                        --    'SECURITY DEPOSIT'       AS [Remarks],
                        --    NULL,
                        --    @EncodedBy,
                        --    GETDATE(),
                        --    @ComputerName,
                        --    1,
                        --    0

                        UPDATE
                            [dbo].[tblUnitReference]
                        SET
                            [tblUnitReference].[IsPaid] = 1
                        WHERE
                            [tblUnitReference].[RefId] = @RefId;

                    --UPDATE
                    --    [dbo].[tblMonthLedger]
                    --SET
                    --    [tblMonthLedger].[IsPaid] = 1,
                    --    [tblMonthLedger].[CompanyORNo] = @CompanyORNo,
                    --    [tblMonthLedger].[CompanyPRNo] = @CompanyPRNo,
                    --    [tblMonthLedger].[REF] = @REF,
                    --    [tblMonthLedger].[BNK_ACCT_NAME] = @BankAccountName,
                    --    [tblMonthLedger].[BNK_ACCT_NUMBER] = @BankAccountNumber,
                    --    [tblMonthLedger].[BNK_NAME] = @BankName,
                    --    [tblMonthLedger].[SERIAL_NO] = @SerialNo,
                    --    [tblMonthLedger].[ModeType] = @ModeType,
                    --    [tblMonthLedger].[BankBranch] = @BankBranch,
                    --    [tblMonthLedger].[TransactionID] = @TranID
                    --WHERE
                    --    [tblMonthLedger].[ReferenceID] =
                    --    (
                    --        SELECT
                    --            [tblUnitReference].[RecId]
                    --        FROM
                    --            [dbo].[tblUnitReference] WITH (NOLOCK)
                    --        WHERE
                    --            [tblUnitReference].[RefId] = @RefId
                    --    )
                    --    AND [tblMonthLedger].[LedgMonth] IN
                    --            (
                    --                SELECT
                    --                    [tblAdvancePayment].[Months]
                    --                FROM
                    --                    [dbo].[tblAdvancePayment] WITH (NOLOCK)
                    --                WHERE
                    --                    [tblAdvancePayment].[RefId] = @RefId
                    --            )
                    --    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                    --    AND ISNULL([tblMonthLedger].[TransactionID], '') = '';

                    --INSERT INTO [dbo].[tblReceipt]
                    --    (
                    --        [TranId],
                    --        [Amount],
                    --        [Description],
                    --        [Remarks],
                    --        [EncodedBy],
                    --        [EncodedDate],
                    --        [ComputerName],
                    --        [IsActive],
                    --        [PaymentMethod],
                    --        [CompanyORNo],
                    --        [CompanyPRNo],
                    --        [BankAccountName],
                    --        [BankAccountNumber],
                    --        [BankName],
                    --        [SerialNo],
                    --        [REF],
                    --        [BankBranch],
                    --        [RefId],
                    --        [ReceiptDate]
                    --    )
                    --VALUES
                    --    (
                    --        @TranID, @PaidAmount, 'FIRST PAYMENT', @PaymentRemarks, @EncodedBy, GETDATE(),
                    --        @ComputerName, 1, @ModeType, @CompanyORNo, @CompanyPRNo, @BankAccountName,
                    --        @BankAccountNumber, @BankName, @SerialNo, @REF, @BankBranch, @RefId, @ReceiptDate
                    --    );
                    --SELECT
                    --    @TranID,
                    --    [#tmpPayments].[LedgAmount],
                    --    'FIRST PAYMENT',
                    --    [#tmpPayments].[Remarks],
                    --    @EncodedBy,
                    --    GETDATE(),
                    --    @ComputerName,
                    --    1,
                    --    @ModeType,
                    --    [#tmpPayments].[ColOR],
                    --    [#tmpPayments].[ColPR],
                    --    @BankAccountName,
                    --    @BankAccountNumber,
                    --    @BankName,
                    --    @SerialNo,
                    --    @REF,
                    --    @BankBranch,
                    --    @RefId,
                    --    @ReceiptDate
                    --FROM
                    --    [#tmpPayments]

                    --SET @RcptRecId = @@IDENTITY;
                    --SELECT
                    --    @RcptID = [tblReceipt].[RcptID]
                    --FROM
                    --    [dbo].[tblReceipt] WITH (NOLOCK)
                    --WHERE
                    --    [tblReceipt].[RecId] = @RcptRecId;

                    --INSERT INTO [dbo].[tblPaymentMode]
                    --    (
                    --        [RcptID],
                    --        [CompanyORNo],
                    --        [CompanyPRNo],
                    --        [REF],
                    --        [BNK_ACCT_NAME],
                    --        [BNK_ACCT_NUMBER],
                    --        [BNK_NAME],
                    --        [SERIAL_NO],
                    --        [ModeType],
                    --        [BankBranch],
                    --        [ReceiptDate]
                    --    )
                    --VALUES
                    --    (
                    --        @RcptID, @CompanyORNo, @CompanyPRNo, @REF, @BankAccountName, @BankAccountNumber,
                    --        @BankName, @SerialNo, @ModeType, @BankBranch, @ReceiptDate
                    --    );
                    --SELECT
                    --    @RcptID,
                    --    [#tmpPayments].[ColOR],
                    --    [#tmpPayments].[ColPR],
                    --    @REF,
                    --    @BankAccountName,
                    --    @BankAccountNumber,
                    --    @BankName,
                    --    @SerialNo,
                    --    @ModeType,
                    --    @BankBranch,
                    --    @ReceiptDate
                    --FROM
                    --    [#tmpPayments]
                    END
            END
        ELSE IF @IsFullPayment = 1
            BEGIN


                BEGIN
                    UPDATE
                        [dbo].[tblUnitReference]
                    SET
                        [tblUnitReference].[FirtsPaymentBalanceAmount] = 0
                    WHERE
                        [tblUnitReference].[RefId] = @RefId


                    UPDATE
                        [dbo].[tblUnitReference]
                    SET
                        [tblUnitReference].[IsPaid] = 1
                    WHERE
                        [tblUnitReference].[RefId] = @RefId;


                    UPDATE
                        [dbo].[tblMonthLedger]
                    SET
                        [tblMonthLedger].[IsPaid] = 1,
                        [tblMonthLedger].[CompanyORNo] = @CompanyORNo,
                        [tblMonthLedger].[CompanyPRNo] = @CompanyPRNo,
                        [tblMonthLedger].[REF] = @REF,
                        [tblMonthLedger].[BNK_ACCT_NAME] = @BankAccountName,
                        [tblMonthLedger].[BNK_ACCT_NUMBER] = @BankAccountNumber,
                        [tblMonthLedger].[BNK_NAME] = @BankName,
                        [tblMonthLedger].[SERIAL_NO] = @SerialNo,
                        [tblMonthLedger].[ModeType] = @ModeType,
                        [tblMonthLedger].[BankBranch] = @BankBranch,
                        [tblMonthLedger].[TransactionID] = @TranID
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
                        AND ISNULL([IsPaid], 0) = 0
                        AND ISNULL([tblMonthLedger].[TransactionID], '') = '';

                    INSERT INTO [dbo].[tblReceipt]
                        (
                            [TranId],
                            [Amount],
                            [Description],
                            [Remarks],
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
                            [ReceiptDate]
                        )
                    VALUES
                        (
                            @TranID, @PaidAmount, 'FULL PAYMENT', @PaymentRemarks, @EncodedBy, GETDATE(),
                            @ComputerName, 1, @ModeType, @CompanyORNo, @CompanyPRNo, @BankAccountName,
                            @BankAccountNumber, @BankName, @SerialNo, @REF, @BankBranch, @RefId, @ReceiptDate
                        );

                    SET @RcptRecId = @@IDENTITY;
                    SELECT
                        @RcptID = [tblReceipt].[RcptID]
                    FROM
                        [dbo].[tblReceipt] WITH (NOLOCK)
                    WHERE
                        [tblReceipt].[RecId] = @RcptRecId;

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
                            [ReceiptDate]
                        )
                    VALUES
                        (
                            @RcptID, @CompanyORNo, @CompanyPRNo, @REF, @BankAccountName, @BankAccountNumber, @BankName,
                            @SerialNo, @ModeType, @BankBranch, @ReceiptDate
                        );
                END

            END;

        IF @@ROWCOUNT > 0
            BEGIN

                SET @Message_Code = 'SUCCESS'

            END;

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
                        'sp_GenerateFirstPaymentParking', @ErrorMessage, GETDATE()
                    );
            END
        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code],
            @RcptID       AS [ReceiptID],
            @TranID       AS [TranID]


    --DROP TABLE [#tmpPayments]
    END
GO
/****** Object:  StoredProcedure [dbo].[sp_GenerateLedger]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC [sp_GenerateLedger] 
CREATE   PROCEDURE [dbo].[sp_GenerateLedger]
    @FromDate          VARCHAR(10)    = NULL,
    @EndDate           VARCHAR(10)    = NULL,
    @LedgAmount        DECIMAL(18, 2) = NULL,
    @Rental            DECIMAL(18, 2) = NULL,
    @SecAndMaintenance DECIMAL(18, 2) = NULL,
    @ComputationID     INT            = NULL,
    @ClientID          VARCHAR(30)    = NULL,
    @EncodedBy         INT            = NULL,
    @ComputerName      VARCHAR(30)    = NULL,
    @UnitId            INT            = NULL,
    @IsRenewal         BIGINT         = 0
AS
    BEGIN

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';
       
        --DECLARE @StartDate VARCHAR(10) = '08/02/2023';
        --DECLARE @EndDate VARCHAR(10) = '05/02/2024';
        --SELECT DATEDIFF(MONTH, CONVERT(DATE, @StartDate, 101), CONVERT(DATE, @EndDate, 101)) AS NumberOfMonths;


        DECLARE @MonthsCount INT = DATEDIFF(MONTH, CONVERT(DATE, @FromDate, 101), CONVERT(DATE, @EndDate, 101));
        DECLARE @ProjectType AS VARCHAR(20) = '';

        DECLARE @Unit_IsParking AS BIT = 0;
        DECLARE @Unit_IsNonVat AS BIT = 0;
        DECLARE @Unit_AreaSqm AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_AreaRateSqm AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_AreaTotalAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_BaseRentalVatAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_BaseRentalWithVatAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_BaseRentalTax AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_TotalRental AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_SecAndMainAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_SecAndMainVatAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_SecAndMainWithVatAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_Vat AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_Tax AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_TaxAmount AS DECIMAL(18, 2) = 0;


        SELECT
                @ProjectType                  = [tblProjectMstr].[ProjectType],
                @Unit_IsParking               = [tblUnitMstr].[IsParking],
                @Unit_IsNonVat                = [tblUnitMstr].[IsNonVat],
                @Unit_AreaSqm                 = [tblUnitMstr].[AreaSqm],
                @Unit_AreaRateSqm             = [tblUnitMstr].[AreaRateSqm],
                @Unit_AreaTotalAmount         = [tblUnitMstr].[AreaTotalAmount],
                @Unit_BaseRentalVatAmount     = [tblUnitMstr].[BaseRentalVatAmount],
                @Unit_BaseRentalWithVatAmount = [tblUnitMstr].[BaseRentalWithVatAmount],
                @Unit_BaseRentalTax           = [tblUnitMstr].[BaseRentalTax],
                @Unit_TotalRental             = [tblUnitMstr].[TotalRental],
                @Unit_SecAndMainAmount        = [tblUnitMstr].[SecAndMainAmount],
                @Unit_SecAndMainVatAmount     = [tblUnitMstr].[SecAndMainVatAmount],
                @Unit_SecAndMainWithVatAmount = [tblUnitMstr].[SecAndMainWithVatAmount],
                @Unit_Vat                     = [tblUnitMstr].[Vat],
                @Unit_Tax                     = [tblUnitMstr].[Tax],
                @Unit_TaxAmount               = [tblUnitMstr].[TaxAmount]
        FROM
                [dbo].[tblUnitMstr] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblProjectMstr] WITH (NOLOCK)
                    ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
        WHERE
                [tblUnitMstr].[RecId] = @UnitId;

        CREATE TABLE [#GeneratedMonths]
            (
                [Month] DATE
            );
        WITH [MonthsCTE]
        AS (   SELECT
                   CONVERT(DATE, @FromDate) AS [Month]
               UNION ALL
               SELECT
                   DATEADD(MONTH, 1, [MonthsCTE].[Month])
               FROM
                   [MonthsCTE]
               WHERE
                   DATEADD(MONTH, 1, [MonthsCTE].[Month]) <= DATEADD(MONTH, @MonthsCount - 1, CONVERT(DATE, @FromDate)))
        INSERT INTO [#GeneratedMonths]
            (
                [Month]
            )
                    SELECT
                        [MonthsCTE].[Month]
                    FROM
                        [MonthsCTE];



        INSERT INTO [dbo].[tblMonthLedger]
            (
                [LedgMonth],
                [LedgAmount],
                [LedgRentalAmount],
                [ReferenceID],
                [ClientID],
                [IsPaid],
                [EncodedBy],
                [EncodedDate],
                [ComputerName],
                [Remarks],
                [Unit_IsNonVat],
                [Unit_AreaSqm],
                [Unit_AreaRateSqm],
                [Unit_AreaTotalAmount],
                [Unit_BaseRentalVatAmount],
                [Unit_BaseRentalWithVatAmount],
                [Unit_BaseRentalTax],
                [Unit_TotalRental],
                [Unit_SecAndMainAmount],
                [Unit_SecAndMainVatAmount],
                [Unit_SecAndMainWithVatAmount],
                [Unit_Vat],
                [Unit_Tax],
                [Unit_TaxAmount],
                [Unit_ProjectType],
                [Unit_IsParking],
                [IsRenewal]
            )
                    SELECT
                        [#GeneratedMonths].[Month],
                        @LedgAmount,
                        @Rental,
                        @ComputationID,
                        @ClientID,
                        0,
                        @EncodedBy,
                        GETDATE(),
                        @ComputerName,
                        'RENTAL NET OF VAT',
                        @Unit_IsNonVat,
                        @Unit_AreaSqm,
                        @Unit_AreaRateSqm,
                        @Unit_AreaTotalAmount,
                        @Unit_BaseRentalVatAmount,
                        @Unit_BaseRentalWithVatAmount,
                        @Unit_BaseRentalTax,
                        @Unit_TotalRental,
                        @Unit_SecAndMainAmount,
                        @Unit_SecAndMainVatAmount,
                        @Unit_SecAndMainWithVatAmount,
                        @Unit_Vat,
                        @Unit_Tax,
                        @Unit_TaxAmount,
                        @ProjectType,
                        @Unit_IsParking,
                        @IsRenewal
                    FROM
                        [#GeneratedMonths]
                    UNION
                    SELECT
                        [#GeneratedMonths].[Month],
                        @LedgAmount,
                        @SecAndMaintenance,
                        @ComputationID,
                        @ClientID,
                        0,
                        @EncodedBy,
                        GETDATE(),
                        @ComputerName,
                        'SECURITY AND MAINTENANCE NET OF VAT',
                        @Unit_IsNonVat,
                        @Unit_AreaSqm,
                        @Unit_AreaRateSqm,
                        @Unit_AreaTotalAmount,
                        @Unit_BaseRentalVatAmount,
                        @Unit_BaseRentalWithVatAmount,
                        @Unit_BaseRentalTax,
                        @Unit_TotalRental,
                        @Unit_SecAndMainAmount,
                        @Unit_SecAndMainVatAmount,
                        @Unit_SecAndMainWithVatAmount,
                        @Unit_Vat,
                        @Unit_Tax,
                        @Unit_TaxAmount,
                        @ProjectType,
                        @Unit_IsParking,
                        @IsRenewal
                    FROM
                        [#GeneratedMonths]
                    WHERE
                        @SecAndMaintenance IS NOT NULL



        IF (@@ROWCOUNT > 0)
            BEGIN
                UPDATE
                    [dbo].[tblUnitReference]
                SET
                    [tblUnitReference].[ClientID] = @ClientID,
                    [tblUnitReference].[LastCHangedBy] = @EncodedBy,
                    [tblUnitReference].[LastChangedDate] = GETDATE(),
                    [tblUnitReference].[ComputerName] = @ComputerName
                WHERE
                    [tblUnitReference].[RecId] = @ComputationID;
                SET @Message_Code = 'SUCCESS'
            END;


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
                        'sp_GenerateLedger', @ErrorMessage, GETDATE()
                    );
            END
        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
        DROP TABLE [#GeneratedMonths];
    END






GO
/****** Object:  StoredProcedure [dbo].[sp_GenerateSecondPaymentParking]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GenerateSecondPaymentParking]
    -- Add the parameters for the stored procedure here
    @RefId VARCHAR(50) = NULL,
    @PaidAmount DECIMAL(18, 2) = NULL,
    @ReceiveAmount DECIMAL(18, 2) = NULL,
    @ChangeAmount DECIMAL(18, 2) = NULL,
    @EncodedBy INT = NULL,
    @ComputerName VARCHAR(30) = NULL,
    @CompanyORNo VARCHAR(30) = NULL,
    @CompanyPRNo VARCHAR(30) = NULL,
    @BankAccountName VARCHAR(30) = NULL,
    @BankAccountNumber VARCHAR(30) = NULL,
    @BankName VARCHAR(30) = NULL,
    @SerialNo VARCHAR(30) = NULL,
    @PaymentRemarks VARCHAR(100) = NULL,
    @REF VARCHAR(100) = NULL,
    @ModeType VARCHAR(10) = NULL,
    @ledgerRecId INT = NULL
AS
BEGIN TRY
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @ReturnMessage VARCHAR(200);
    DECLARE @TranRecId BIGINT = 0;
    DECLARE @TranID VARCHAR(50) = '';
    DECLARE @RcptRecId BIGINT = 0;
    DECLARE @RcptID VARCHAR(50) = '';
    DECLARE @LedgeMonth DATE = NULL;

    BEGIN TRANSACTION;
    INSERT INTO [dbo].[tblTransaction]
    (
        [RefId],
        [PaidAmount],
        [ReceiveAmount],
        [ChangeAmount],
        [Remarks],
        [EncodedBy],
        [EncodedDate],
        [ComputerName],
        [IsActive]
    )
    VALUES
    (@RefId, @PaidAmount, @ReceiveAmount, @ChangeAmount, 'FOLLOW-UP PAYMENT', @EncodedBy, GETDATE(), @ComputerName, 1);

    SET @TranRecId = @@IDENTITY;
    SELECT @TranID = [tblTransaction].[TranID]
    FROM [dbo].[tblTransaction]
    WHERE [tblTransaction].[RecId] = @TranRecId;

    SELECT @LedgeMonth = [tblMonthLedger].[LedgMonth]
    FROM [dbo].[tblMonthLedger]
    WHERE ISNULL([tblMonthLedger].[IsPaid], 0) = 0
          AND ISNULL([tblMonthLedger].[TransactionID], '') = ''
          AND [tblMonthLedger].[ReferenceID] =
          (
              SELECT [tblUnitReference].[RecId]
              FROM [dbo].[tblUnitReference]
              WHERE [tblUnitReference].[RefId] = @RefId
          )
          AND [tblMonthLedger].[Recid] = @ledgerRecId;
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
        [IsActive]
    )
    SELECT @TranID AS [TranId],
           @RefId AS [RefId],
           [tblMonthLedger].[LedgAmount] AS [Amount],
           [tblMonthLedger].[LedgMonth] AS [ForMonth],
           'FOLLOW-UP PAYMENT' AS [Remarks],
           @EncodedBy,
           GETDATE(), --Dated payed
           @ComputerName,
           1
    FROM [dbo].[tblMonthLedger]
    WHERE [tblMonthLedger].[LedgMonth] = @LedgeMonth
          AND ISNULL([tblMonthLedger].[IsPaid], 0) = 0
          AND ISNULL([tblMonthLedger].[TransactionID], '') = ''
          AND [tblMonthLedger].[ReferenceID] =
          (
              SELECT [tblUnitReference].[RecId]
              FROM [dbo].[tblUnitReference]
              WHERE [tblUnitReference].[RefId] = @RefId
          )
          AND [tblMonthLedger].[Recid] = @ledgerRecId;


    UPDATE [dbo].[tblMonthLedger]
    SET [tblMonthLedger].[IsPaid] = 1,
        [tblMonthLedger].[IsHold] = 0,
        [tblMonthLedger].[TransactionID] = @TranID
    WHERE [tblMonthLedger].[LedgMonth] = @LedgeMonth
          AND ISNULL([IsPaid], 0) = 0
          AND ISNULL([tblMonthLedger].[TransactionID], '') = ''
          AND [tblMonthLedger].[ReferenceID] =
          (
              SELECT [tblUnitReference].[RecId]
              FROM [dbo].[tblUnitReference]
              WHERE [tblUnitReference].[RefId] = @RefId
          )
          AND [Recid] = @ledgerRecId;


    INSERT INTO [dbo].[tblReceipt]
    (
        [TranId],
        [Amount],
        [Description],
        [Remarks],
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
        [REF]
    )
    VALUES
    (@TranID, @PaidAmount, 'FOLLOW-UP PAYMENT', @PaymentRemarks, @EncodedBy, GETDATE(), @ComputerName, 1, @ModeType,
     @CompanyORNo, @CompanyPRNo, @BankAccountName, @BankAccountNumber, @BankName, @SerialNo, @REF);

    SET @RcptRecId = @@IDENTITY;
    SELECT @RcptID = [tblReceipt].[RcptID]
    FROM [dbo].[tblReceipt]
    WHERE [tblReceipt].[RecId] = @RcptRecId;

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
        [ModeType]
    )
    VALUES
    (@RcptID, @CompanyORNo, @CompanyPRNo, @REF, @BankAccountName, @BankAccountNumber, @BankName, @SerialNo, @ModeType);


    IF (@TranID <> '' AND @@ROWCOUNT > 0)
    BEGIN
        SET @ReturnMessage = 'SUCCESS';
    END;
    ELSE
    BEGIN
        SET @ReturnMessage = ERROR_MESSAGE();
    END;
    SELECT @ReturnMessage AS [Message_Code];

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    SET @ReturnMessage = ERROR_MESSAGE();
    SELECT @ReturnMessage AS [ReturnMessage];
END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[sp_GenerateSecondPaymentUnit]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GenerateSecondPaymentUnit]
    -- Add the parameters for the stored procedure here
    @RefId VARCHAR(50) = NULL,
    @PaidAmount DECIMAL(18, 2) = NULL,
    @ReceiveAmount DECIMAL(18, 2) = NULL,
    @ChangeAmount DECIMAL(18, 2) = NULL,
    @EncodedBy INT = NULL,
    @ComputerName VARCHAR(30) = NULL,
    @CompanyORNo VARCHAR(30) = NULL,
    @CompanyPRNo VARCHAR(30) = NULL,
    @BankAccountName VARCHAR(30) = NULL,
    @BankAccountNumber VARCHAR(30) = NULL,
    @BankName VARCHAR(30) = NULL,
    @SerialNo VARCHAR(30) = NULL,
    @PaymentRemarks VARCHAR(100) = NULL,
    @REF VARCHAR(100) = NULL,
    @ModeType VARCHAR(50) = NULL,
    @ledgerRecId INT = NULL
AS
BEGIN TRY
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @ReturnMessage VARCHAR(200);
    DECLARE @TranRecId BIGINT = 0;
    DECLARE @TranID VARCHAR(50) = '';
    DECLARE @RcptRecId BIGINT = 0;
    DECLARE @RcptID VARCHAR(50) = '';
    DECLARE @LedgeMonth DATE = NULL;

    BEGIN TRANSACTION;
    INSERT INTO [dbo].[tblTransaction]
    (
        [RefId],
        [PaidAmount],
        [ReceiveAmount],
        [ChangeAmount],
        [Remarks],
        [EncodedBy],
        [EncodedDate],
        [ComputerName],
        [IsActive]
    )
    VALUES
    (@RefId, @PaidAmount, @ReceiveAmount, @ChangeAmount, 'FOLLOW-UP PAYMENT', @EncodedBy, GETDATE(), @ComputerName, 1);

    SET @TranRecId = @@IDENTITY;
    SELECT @TranID = [tblTransaction].[TranID]
    FROM [dbo].[tblTransaction] WITH (NOLOCK)
    WHERE [tblTransaction].[RecId] = @TranRecId;

    SELECT @LedgeMonth = [tblMonthLedger].[LedgMonth]
    FROM [dbo].[tblMonthLedger] WITH (NOLOCK)
    WHERE ISNULL([tblMonthLedger].[IsPaid], 0) = 0
          AND ISNULL([tblMonthLedger].[TransactionID], '') = ''
          AND [tblMonthLedger].[ReferenceID] =
          (
              SELECT [tblUnitReference].[RecId]
              FROM [dbo].[tblUnitReference] WITH (NOLOCK)
              WHERE [tblUnitReference].[RefId] = @RefId
          )
          AND [tblMonthLedger].[Recid] = @ledgerRecId;
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
        [IsActive]
    )
    SELECT @TranID AS [TranId],
           @RefId AS [RefId],
           [tblMonthLedger].[LedgAmount] AS [Amount],
           [tblMonthLedger].[LedgMonth] AS [ForMonth],
           'FOLLOW-UP PAYMENT' AS [Remarks],
           @EncodedBy,
           GETDATE(), --Dated payed
           @ComputerName,
           1
    FROM [dbo].[tblMonthLedger] WITH (NOLOCK)
    WHERE [tblMonthLedger].[LedgMonth] = @LedgeMonth
          AND ISNULL([tblMonthLedger].[IsPaid], 0) = 0
          AND ISNULL([tblMonthLedger].[TransactionID], '') = ''
          AND [tblMonthLedger].[ReferenceID] =
          (
              SELECT [tblUnitReference].[RecId]
              FROM [dbo].[tblUnitReference] WITH (NOLOCK)
              WHERE [tblUnitReference].[RefId] = @RefId
          )
          AND [tblMonthLedger].[Recid] = @ledgerRecId;


    UPDATE [dbo].[tblMonthLedger]
    SET [tblMonthLedger].[IsPaid] = 1,
        [tblMonthLedger].[IsHold] = 0,
        [tblMonthLedger].[TransactionID] = @TranID
    WHERE [tblMonthLedger].[LedgMonth] = @LedgeMonth
          AND ISNULL([IsPaid], 0) = 0
          AND ISNULL([tblMonthLedger].[TransactionID], '') = ''
          AND [tblMonthLedger].[ReferenceID] =
          (
              SELECT [tblUnitReference].[RecId]
              FROM [dbo].[tblUnitReference] WITH (NOLOCK)
              WHERE [tblUnitReference].[RefId] = @RefId
          )
          AND [Recid] = @ledgerRecId;


    INSERT INTO [dbo].[tblReceipt]
    (
        [TranId],
        [Amount],
        [Description],
        [Remarks],
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
        [REF]
    )
    VALUES
    (@TranID, @PaidAmount, 'FOLLOW-UP PAYMENT', @PaymentRemarks, @EncodedBy, GETDATE(), @ComputerName, 1, @ModeType,
     @CompanyORNo, @CompanyPRNo, @BankAccountName, @BankAccountNumber, @BankName, @SerialNo, @REF);

    SET @RcptRecId = @@IDENTITY;
    SELECT @RcptID = [tblReceipt].[RcptID]
    FROM [dbo].[tblReceipt] WITH (NOLOCK)
    WHERE [tblReceipt].[RecId] = @RcptRecId;

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
        [ModeType]
    )
    VALUES
    (@RcptID, @CompanyORNo, @CompanyPRNo, @REF, @BankAccountName, @BankAccountNumber, @BankName, @SerialNo, @ModeType);


    IF (@TranID <> '' AND @@ROWCOUNT > 0)
    BEGIN
        SET @ReturnMessage = 'SUCCESS';
    END;
    ELSE
    BEGIN
        SET @ReturnMessage = ERROR_MESSAGE();
    END;
    SELECT @ReturnMessage AS [Message_Code],
           @TranID AS [TranID];

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    SET @ReturnMessage = ERROR_MESSAGE();
    SELECT @ReturnMessage AS [ReturnMessage];
END CATCH;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAnnouncement]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_GetAnnouncement]
AS
BEGIN
    SELECT ISNULL([tblAnnouncement].[AnnounceMessage], '') AS [AnnounceMessage]
    FROM [dbo].[tblAnnouncement]

END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAnnouncementCheck]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_GetAnnouncementCheck]
AS
BEGIN
    SELECT ISNULL([tblAnnouncement].[AnnounceMessage], '') AS [AnnounceMessage]
    FROM [dbo].[tblAnnouncement]

END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetCheckPaymentStatus]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetCheckPaymentStatus] @ReferenceID VARCHAR(50) = NULL
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
        IF EXISTS
            (
                SELECT
                    *
                FROM
                    [dbo].[tblMonthLedger]
                WHERE
                    [tblMonthLedger].[ReferenceID] = SUBSTRING(@ReferenceID, 4, 11)
            )
            BEGIN
                SELECT
                    IIF(COUNT(*) > 0, 'IN-PROGRESS', 'PAYMENT DONE') AS [PAYMENT_STATUS]
                FROM
                    [dbo].[tblMonthLedger]
                WHERE
                    [tblMonthLedger].[ReferenceID] = SUBSTRING(@ReferenceID, 4, 11)
                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 0;
            END;
        ELSE
            BEGIN
                SELECT
                    '' AS [PAYMENT_STATUS];
            END;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetClientById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClientById] @ClientID VARCHAR(50)
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT
            [tblClientMstr].[ClientID],
            IIF(ISNULL([tblClientMstr].[ClientType], '') = 'INDV', 'INDIVIDUAL', 'CORPORATE') AS [ClientType],
            ISNULL([tblClientMstr].[ClientName], '')                                          AS [ClientName],
            ISNULL([tblClientMstr].[Age], 0)                                                  AS [Age],
            ISNULL([tblClientMstr].[PostalAddress], '')                                       AS [PostalAddress],
            ISNULL(CONVERT(VARCHAR(10), [tblClientMstr].[DateOfBirth], 101), '')              AS [DateOfBirth],
            ISNULL([tblClientMstr].[TelNumber], 0)                                            AS [TelNumber],
            IIF(ISNULL([tblClientMstr].[Gender], 0) = 1, 'MALE', 'FEMALE')                    AS [Gender],
            ISNULL([tblClientMstr].[Nationality], '')                                         AS [Nationality],
            ISNULL([tblClientMstr].[Occupation], '')                                          AS [Occupation],
            ISNULL([tblClientMstr].[AnnualIncome], 0)                                         AS [AnnualIncome],
            ISNULL([tblClientMstr].[EmployerName], '')                                        AS [EmployerName],
            ISNULL([tblClientMstr].[EmployerAddress], '')                                     AS [EmployerAddress],
            ISNULL([tblClientMstr].[SpouseName], '')                                          AS [SpouseName],
            ISNULL([tblClientMstr].[ChildrenNames], '')                                       AS [ChildrenNames],
            ISNULL([tblClientMstr].[TotalPersons], 0)                                         AS [TotalPersons],
            ISNULL([tblClientMstr].[MaidName], '')                                            AS [MaidName],
            ISNULL([tblClientMstr].[DriverName], '')                                          AS [DriverName],
            ISNULL([tblClientMstr].[VisitorsPerDay], 0)                                       AS [VisitorsPerDay],
            ISNULL([tblClientMstr].[IsTwoMonthAdvanceRental], 0)                              AS [IsTwoMonthAdvanceRental],
            ISNULL([tblClientMstr].[IsThreeMonthSecurityDeposit], 0)                          AS [IsThreeMonthSecurityDeposit],
            ISNULL([tblClientMstr].[Is10PostDatedChecks], 0)                                  AS [Is10PostDatedChecks],
            ISNULL([tblClientMstr].[IsPhotoCopyValidID], 0)                                   AS [IsPhotoCopyValidID],
            ISNULL([tblClientMstr].[Is2X2Picture], 0)                                         AS [Is2X2Picture],
            ISNULL([tblClientMstr].[BuildingSecretary], 0)                                    AS [BuildingSecretary],
            ISNULL([tblClientMstr].[EncodedDate], '')                                         AS [EncodedDate],
            ISNULL([tblClientMstr].[EncodedBy], 0)                                            AS [EncodedBy],
            ISNULL([tblClientMstr].[ComputerName], '')                                        AS [ComputerName],
            IIF(ISNULL([tblClientMstr].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE')             AS [IsActive],
			ISNULL(TIN_No,'') AS TIN_No
        FROM
            [dbo].[tblClientMstr]
        WHERE
            [tblClientMstr].[ClientID] = @ClientID;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetClientFileByFileId]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetClientFileByFileId]
    @ClientName VARCHAR(50),
    @Id         INT
AS
    BEGIN
        SELECT
            [Files].[Id],
            [Files].[FilePath],
            [Files].[FileData],
            [Files].[FileNames],
            [Files].[Notes],
            [Files].[Files]
        FROM
            [dbo].[Files]
        WHERE
            [Files].[ClientName] = @ClientName
            AND [Files].[Id] = @Id;
    END;


GO
/****** Object:  StoredProcedure [dbo].[sp_GetClientID]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClientID] @ClientID VARCHAR(50) = NULL
AS
    BEGIN

        SET NOCOUNT ON;

        IF EXISTS
            (
                SELECT
                    1
                FROM
                    [dbo].[tblClientMstr]
                WHERE
                    [tblClientMstr].[ClientID] = @ClientID
            )
            BEGIN
                SELECT
                    [tblClientMstr].[ClientID],
                    '' AS [Message_Code]
                FROM
                    [dbo].[tblClientMstr] WITH (NOLOCK)
                WHERE
                    ISNULL([tblClientMstr].[ClientID], '') = @ClientID;
            END;
        ELSE
            BEGIN

                SELECT
                    ''                      AS [ClientID],
                    'THIS ID IS NOT EXIST ' AS [Message_Code];
            END;


    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetClientList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClientList]
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT
            ISNULL([tblClientMstr].[ClientID], '')                                            AS [ClientID],
            IIF(ISNULL([tblClientMstr].[ClientType], '') = 'INDV', 'INDIVIDUAL', 'CORPORATE') AS [ClientType],
            ISNULL([tblClientMstr].[ClientName], '')                                          AS [ClientName],
            ISNULL([tblClientMstr].[Age], 0)                                                  AS [Age],
            ISNULL([tblClientMstr].[PostalAddress], '')                                       AS [PostalAddress],
            ISNULL(CONVERT(VARCHAR(10), [tblClientMstr].[DateOfBirth], 101), '')              AS [DateOfBirth],
            ISNULL([tblClientMstr].[TelNumber], 0)                                            AS [TelNumber],
            IIF(ISNULL([tblClientMstr].[Gender], 0) = 1, 'MALE', 'FEMALE')                    AS [Gender],
            ISNULL([tblClientMstr].[Nationality], '')                                         AS [Nationality],
            ISNULL([tblClientMstr].[Occupation], '')                                          AS [Occupation],
            ISNULL([tblClientMstr].[AnnualIncome], 0)                                         AS [AnnualIncome],
            ISNULL([tblClientMstr].[EmployerName], '')                                        AS [EmployerName],
            ISNULL([tblClientMstr].[EmployerAddress], '')                                     AS [EmployerAddress],
            ISNULL([tblClientMstr].[SpouseName], '')                                          AS [SpouseName],
            ISNULL([tblClientMstr].[ChildrenNames], '')                                       AS [ChildrenNames],
            ISNULL([tblClientMstr].[TotalPersons], 0)                                         AS [TotalPersons],
            ISNULL([tblClientMstr].[MaidName], '')                                            AS [MaidName],
            ISNULL([tblClientMstr].[DriverName], '')                                          AS [DriverName],
            ISNULL([tblClientMstr].[VisitorsPerDay], 0)                                       AS [VisitorsPerDay],
            ISNULL([tblClientMstr].[IsTwoMonthAdvanceRental], 0)                              AS [IsTwoMonthAdvanceRental],
            ISNULL([tblClientMstr].[IsThreeMonthSecurityDeposit], 0)                          AS [IsThreeMonthSecurityDeposit],
            ISNULL([tblClientMstr].[Is10PostDatedChecks], 0)                                  AS [Is10PostDatedChecks],
            ISNULL([tblClientMstr].[IsPhotoCopyValidID], 0)                                   AS [IsPhotoCopyValidID],
            ISNULL([tblClientMstr].[Is2X2Picture], 0)                                         AS [Is2X2Picture],
            ISNULL([tblClientMstr].[BuildingSecretary], 0)                                    AS [BuildingSecretary],
            ISNULL([tblClientMstr].[EncodedDate], '')                                         AS [EncodedDate],
            ISNULL([tblClientMstr].[EncodedBy], 0)                                            AS [EncodedBy],
            ISNULL([tblClientMstr].[ComputerName], '')                                        AS [ComputerName],
            IIF(ISNULL([tblClientMstr].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE')             AS [IsActive],
			ISNULL(TIN_No,'') AS TIN_No
        FROM
            [dbo].[tblClientMstr];
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetClientReferencePaid]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClientReferencePaid] @ClientID VARCHAR(30) = NULL
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT [tblClientMstr].[ClientID],
           [tblClientMstr].[ClientName],
           [tblUnitReference].[RefId]
    FROM [dbo].[tblClientMstr] WITH (NOLOCK)
        INNER JOIN [dbo].[tblUnitReference] WITH (NOLOCK)
            ON [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
    WHERE ISNULL([tblUnitReference].[IsPaid], 0) = 1
          --AND ISNULL([tblUnitReference].[IsUnitMove], 0) = 0
          AND [tblClientMstr].[ClientID] = @ClientID;

END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetClientTypeAndID]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClientTypeAndID] @ClientID VARCHAR(50) = NULL
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT
            ISNULL([tblClientMstr].[ClientID], '')                                           AS [ClientID],
            IIF(ISNULL([tblClientMstr].[ClientType], '') = 'INV', 'INDIVIDUAL', 'CORPORATE') AS [ClientType]
        FROM
            [dbo].[tblClientMstr] WITH (NOLOCK)
        WHERE
            [ClientID] = @ClientID;

    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetClientUnitList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetClientUnitList] 'CORP10000001'
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClientUnitList] @ClientID VARCHAR(50) = NULL
AS
BEGIN

    SET NOCOUNT ON;


    SELECT [tblUnitReference].[RecId],
           [tblUnitReference].[UnitNo],
           ISNULL([tblProjectMstr].[ProjectName], '') + '-' + ISNULL([tblProjectMstr].[ProjectType], '') AS [ProjectName],
           ISNULL([tblUnitMstr].[DetailsofProperty], 'N/A') + ' - Type (' + ISNULL([tblUnitMstr].[FloorType], 'N/A')
           + ')' AS [DetailsofProperty],
           IIF(ISNULL([tblUnitMstr].[IsParking], 0) = 1, 'TYPE OF PARKING', 'TYPE OF UNIT') AS [TypeOf],
           case
               when isnull([tblUnitReference].[IsUnitMove], 0) = 0
                    and isnull([tblUnitReference].[IsUnitMoveOut], 0) = 0
                    and isnull([tblUnitReference].[IsSignedContract], 0) = 1 then
                   'RESERVED'
               when isnull([tblUnitReference].[IsSignedContract], 0) = 1
                    and isnull([tblUnitReference].[IsUnitMove], 0) = 1
                    and isnull([tblUnitReference].[IsUnitMoveOut], 0) = 0 then
                   'OCCUPIED'
               when isnull([tblUnitReference].[IsSignedContract], 0) = 1
                    and isnull([tblUnitReference].[IsUnitMove], 0) = 1
                    and isnull([tblUnitReference].[IsUnitMoveOut], 0) = 1
                    and isnull([tblUnitReference].[IsUnitMoveOut], 0) = 0
                    and isnull([tblUnitReference].IsDone, 0) = 0 then
                   'MOVE-OUT'
               when (
                        isnull([tblUnitReference].[IsSignedContract], 0) = 1
                        and isnull([tblUnitReference].[IsUnitMove], 0) = 1
                        and isnull([tblUnitReference].[IsUnitMoveOut], 0) = 1
                        and isnull([tblUnitReference].IsTerminated, 0) = 0
                        and isnull([tblUnitReference].IsDone, 0) = 1
                    )
                    or (
                           isnull([tblUnitReference].[IsSignedContract], 0) = 1
                           and isnull([tblUnitReference].[IsUnitMove], 0) = 1
                           and isnull([tblUnitReference].[IsUnitMoveOut], 0) = 1
                           and isnull([tblUnitReference].IsTerminated, 0) = 1
                           and isnull([tblUnitReference].IsDone, 0) = 1
                       ) then
                   'CLOSE CONTRACT'
               when isnull([tblUnitReference].[IsSignedContract], 0) = 1
                    and isnull([tblUnitReference].[IsUnitMove], 0) = 1
                    and isnull([tblUnitReference].[IsUnitMoveOut], 0) = 1
                    and isnull([tblUnitReference].IsDone, 0) = 0
                    and isnull([tblUnitReference].IsTerminated, 0) = 1 then
                   'EARLY TERMINATION'
               else
                   ''
           end as [UnitStatus]
    FROM [dbo].[tblUnitReference] WITH (NOLOCK)
        LEFT JOIN [dbo].[tblUnitMstr] WITH (NOLOCK)
            ON [tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
        INNER JOIN [dbo].[tblProjectMstr]
            ON [tblUnitReference].[ProjectId] = [tblProjectMstr].[RecId]
    WHERE [tblUnitReference].[ClientID] = @ClientID;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetClosedContracts]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClosedContracts]
-- Add the parameters for the stored procedure here

AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
        SELECT
                [tblUnitReference].[RecId],
                [tblUnitReference].[RefId],
                [tblUnitReference].[ProjectId],
                [tblUnitReference].[InquiringClient],
                [tblUnitReference].[ClientMobile],
                [tblUnitReference].[UnitId],
                [tblUnitReference].[UnitNo],
                [tblUnitReference].[StatDate],
                [tblUnitReference].[FinishDate],
                [tblUnitReference].[TransactionDate],
                [tblUnitReference].[Rental],
                [tblUnitReference].[SecAndMaintenance],
                [tblUnitReference].[TotalRent],
                [tblUnitReference].[AdvancePaymentAmount],
                [tblUnitReference].[SecDeposit],
                [tblUnitReference].[Total],
                [tblUnitReference].[EncodedBy],
                [tblUnitReference].[EncodedDate],
                [tblUnitReference].[LastCHangedBy],
                [tblUnitReference].[LastChangedDate],
                [tblUnitReference].[IsActive],
                [tblUnitReference].[ComputerName],
                [tblUnitReference].[ClientID],
                [tblUnitReference].[IsPaid],
                [tblUnitReference].[IsDone],
                [tblUnitReference].[HeaderRefId],
                [tblUnitReference].[IsSignedContract],
                [tblUnitReference].[IsUnitMove],
                IIF(ISNULL([tblUnitReference].[IsTerminated], 0) = 1, 'EARLY TERMINATION', 'CONTRACT DONE') AS [Contract_Status]
        FROM
                [dbo].[tblUnitReference] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblUnitMstr] WITH (NOLOCK)
                    ON [tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
        WHERE
                ISNULL([tblUnitReference].[IsPaid], 0) = 1
                AND ISNULL([tblUnitReference].[IsDone], 0) = 1
                AND ISNULL([tblUnitReference].[IsSignedContract], 0) = 1
                AND ISNULL([tblUnitReference].[IsUnitMove], 0) = 1
                AND ISNULL([tblUnitReference].[IsUnitMoveOut], 0) = 1
                AND ISNULL([tblUnitReference].[IsPaid], 0) = 1
                AND ISNULL([tblUnitReference].[IsTerminated], 0) = 0
                OR ISNULL([tblUnitReference].[IsTerminated], 0) = 1
                   AND ISNULL([tblUnitReference].[IsPaid], 0) = 1
                   AND ISNULL([tblUnitReference].[IsDone], 0) = 1
                   AND ISNULL([tblUnitReference].[IsSignedContract], 0) = 1
                   AND ISNULL([tblUnitReference].[IsUnitMove], 0) = 1
                   AND ISNULL([tblUnitReference].[IsUnitMoveOut], 0) = 1;



    --and ISNULL(tblUnitMstr.IsParking, 0) = 0
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetCOMMERCIALSettings]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetCOMMERCIALSettings]
AS
BEGIN

    SET NOCOUNT ON;


    SELECT [tblRatesSettings].[ProjectType],
           ISNULL([tblRatesSettings].[GenVat], 0) AS [GenVat],
           ISNULL([tblRatesSettings].[SecurityAndMaintenance], 0) AS [SecurityAndMaintenance],
           ISNULL([tblRatesSettings].[WithHoldingTax], 0) AS [WithHoldingTax],
           ISNULL([tblRatesSettings].[PenaltyPct], 0) AS [PenaltyPct],
           [tblRatesSettings].[EncodedBy],
           [tblRatesSettings].[EncodedDate],
           [tblRatesSettings].[ComputerName]
    FROM [dbo].[tblRatesSettings]
    WHERE [tblRatesSettings].[ProjectType] = 'COMMERCIAL';

END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetCompanyDetails]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_GetCompanyDetails] @RecId AS INT = NULL
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
BEGIN
    SELECT [tblCompany].[RecId],
           [tblCompany].[CompanyName],
           [tblCompany].[CompanyAddress],
           [tblCompany].[CompanyTIN],
           [tblCompany].[CompanyOwnerName],
           [tblCompany].[Status],
           [tblCompany].[EncodedBy],
           [tblCompany].[EncodedDate],
           [tblCompany].[LastChangedBy],
           [tblCompany].[LastChangedDate],
           [tblCompany].[ComputerName]
    FROM [dbo].[tblCompany]
    WHERE [tblCompany].[RecId] = @RecId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetCompanyList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetCompanyList]
AS
BEGIN

    SET NOCOUNT ON;

    SELECT [tblCompany].[RecId],
           [tblCompany].[CompanyName],
           [tblCompany].[CompanyAddress],
           [tblCompany].[CompanyTIN],
           [tblCompany].[CompanyOwnerName],
           [tblCompany].[Status],
           [tblCompany].[EncodedBy],
           [tblCompany].[EncodedDate],
           [tblCompany].[LastChangedBy],
           [tblCompany].[LastChangedDate],
           [tblCompany].[ComputerName],
           IIF(ISNULL([tblCompany].[Status], 0) = 1, 'ACTIVE', 'IN-ACTIVE') AS [Status]
    FROM [dbo].[tblCompany]
    WHERE ISNULL([tblCompany].[Status], 0) = 1;

END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetComputationById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetComputationById] 10000000
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetComputationById] @RecId INT = NULL
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @TotalForPayment AS DECIMAL(18, 2) = 0;
        SELECT
            @TotalForPayment = SUM([tblMonthLedger].[LedgRentalAmount])
        FROM
            [dbo].[tblMonthLedger]
        WHERE
            [tblMonthLedger].[ReferenceID] = @RecId;
        SELECT
                [tblUnitReference].[RecId],
                [tblUnitReference].[RefId],
                ISNULL([tblUnitReference].[ClientID], '')                                    AS [ClientID],
                [tblUnitReference].[ProjectId],
                ISNULL([tblProjectMstr].[ProjectName], '')                                   AS [ProjectName],
                ISNULL([tblProjectMstr].[ProjectAddress], '')                                AS [ProjectAddress],
                ISNULL([tblProjectMstr].[ProjectType], '')                                   AS [ProjectType],
                ISNULL([tblUnitReference].[InquiringClient], '')                             AS [InquiringClient],
                ISNULL([tblUnitReference].[ClientMobile], '')                                AS [ClientMobile],
                [tblUnitReference].[UnitId],
                ISNULL([tblUnitReference].[UnitNo], '')                                      AS [UnitNo],
                ISNULL([tblUnitMstr].[FloorType], '')                                        AS [FloorType],
                ISNULL(CONVERT(VARCHAR(10), [tblUnitReference].[StatDate], 1), '')           AS [StatDate],
                ISNULL(CONVERT(VARCHAR(10), [tblUnitReference].[FinishDate], 1), '')         AS [FinishDate],
                ISNULL(CONVERT(VARCHAR(10), [tblUnitReference].[TransactionDate], 1), '')    AS [TransactionDate],
                CAST(ISNULL([tblUnitReference].[Rental], 0) AS DECIMAL(10, 2))               AS [Rental],
                CAST(ISNULL([tblUnitReference].[SecAndMaintenance], 0) AS DECIMAL(10, 2))    AS [SecAndMaintenance],
                CAST(ISNULL([tblUnitReference].[TotalRent], 0) AS DECIMAL(10, 2))            AS [TotalRent],
                CAST(ISNULL([tblUnitReference].[AdvancePaymentAmount], 0) AS DECIMAL(10, 2)) AS [AdvancePaymentAmount],
                CAST(ISNULL([tblUnitReference].[SecDeposit], 0) AS DECIMAL(10, 2))           AS [SecDeposit],
                CAST(ISNULL([tblUnitReference].[Total], 0) AS DECIMAL(10, 2))                AS [Total],
                [tblUnitReference].[EncodedBy],
                [tblUnitReference].[EncodedDate],
                [tblUnitReference].[IsActive],
                [tblUnitReference].[ComputerName],
                ISNULL([tblUnitReference].[AdvancePaymentAmount], 0)                         AS [TwoMonAdvance],
                IIF(ISNULL([tblUnitReference].[IsFullPayment], 0) = 1,
                    @TotalForPayment + ISNULL([tblUnitReference].[SecDeposit], 0),
                    CAST((ISNULL([tblUnitReference].[AdvancePaymentAmount], 0) + ISNULL([tblUnitReference].[SecDeposit], 0))
                         - IIF(ISNULL([dbo].[tblUnitReference].[FirtsPaymentBalanceAmount], 0) > 0,
                           [PAYMENT].[TotalPayAMount],
                           0) AS DECIMAL(10, 2)))                                            AS [TotalForPayment],
                ISNULL([tblUnitReference].[IsUnitMoveOut], 0)                                AS [IsUnitMoveOut],
                (
                    SELECT
                        IIF(COUNT(*) > 0, 'IN-PROGRESS', 'CLOSED')
                    FROM
                        [dbo].[tblMonthLedger] WITH (NOLOCK)
                    WHERE
                        [tblMonthLedger].[ReferenceID] = @RecId
                        AND ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                )                                                                            AS [PaymentStatus],
                (
                    SELECT TOP 1
                           ISNULL(CONVERT(VARCHAR(10), [tblPayment].[EncodedDate], 1), '')
                    FROM
                           [dbo].[tblPayment] WITH (NOLOCK)
                    WHERE
                           [tblPayment].[RefId] = 'REF' + CONVERT(VARCHAR, @RecId)
                    ORDER BY
                           [tblPayment].[EncodedDate] DESC
                )                                                                            AS [LastPaymentDate],
                IIF(ISNULL([tblUnitReference].[IsSignedContract], 0) = 1, 'DONE', '')        AS [ContractSignStatus],
                ISNULL(CONVERT(VARCHAR(10), [tblUnitReference].[SignedContractDate], 1), '') AS [ContractSignedDate],
                IIF(ISNULL([tblUnitReference].[IsUnitMove], 0) = 1, 'DONE', '')              AS [MoveinStatus],
                ISNULL(CONVERT(VARCHAR(10), [tblUnitReference].[UnitMoveInDate], 1), '')     AS [MoveInDate],
                IIF(ISNULL([tblUnitReference].[IsUnitMoveOut], 0) = 1, 'DONE', '')           AS [MoveOutStatus],
                ISNULL(CONVERT(VARCHAR(10), [tblUnitReference].[UnitMoveOutDate], 1), '')    AS [MoveOutDate],
                IIF(ISNULL([tblUnitReference].[IsTerminated], 0) = 1, 'YES', '')             AS [TerminationStatus],
                ISNULL(CONVERT(VARCHAR(10), [tblUnitReference].[TerminationDate], 1), '')    AS [TerminationDate],
                IIF(ISNULL([tblUnitReference].[IsDone], 0) = 1, 'CLOSED', 'IN-PROGRESS')     AS [ContractStatus],
                ISNULL(CONVERT(VARCHAR(10), [tblUnitReference].[ContactDoneDate], 1), '')    AS [ContractCloseDate],
                CAST(ISNULL([PAYMENT].[TotalPayAMount], 0) AS DECIMAL(18, 2))                AS [TotalPayAMount],
                ISNULL([tblUnitReference].[FirtsPaymentBalanceAmount], 0)                    AS [FirtsPaymentBalanceAmount],
                [dbo].[fnGetUnitCategoryByUnitId]([tblUnitReference].[UnitId])               AS [TypeOf]
        FROM
                [dbo].[tblUnitReference] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblProjectMstr] WITH (NOLOCK)
                    ON [tblUnitReference].[ProjectId] = [tblProjectMstr].[RecId]
            INNER JOIN
                [dbo].[tblUnitMstr] WITH (NOLOCK)
                    ON [tblUnitMstr].[RecId] = [tblUnitReference].[UnitId]
            OUTER APPLY
                (
                    SELECT
                        ISNULL(SUM([tblTransaction].[ReceiveAmount]), 0) AS [TotalPayAMount]
                    FROM
                        [dbo].[tblTransaction]
                    WHERE
                        [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                    GROUP BY
                        [tblTransaction].[RefId]
                ) [PAYMENT]
        WHERE
                [tblUnitReference].[RecId] = @RecId;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetComputationList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- UNION THE SELECT OF PARKING LIST LATER ON
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetComputationList]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    SELECT [tblUnitReference].[RecId],
           [tblUnitReference].[RefId],
           [tblUnitReference].[ProjectId],
           ISNULL([tblProjectMstr].[ProjectName], '') AS [ProjectName],
           ISNULL([tblProjectMstr].[ProjectAddress], '') AS [ProjectAddress],
           ISNULL([tblProjectMstr].[ProjectType], '') AS [ProjectType],
           ISNULL([tblUnitReference].[InquiringClient], '') AS [InquiringClient],
           ISNULL([tblUnitReference].[ClientID], '') AS [ClientID],
           ISNULL([tblUnitReference].[ClientMobile], '') AS [ClientMobile],
           [tblUnitReference].[UnitId],
           ISNULL([tblUnitReference].[UnitNo], '') AS [UnitNo],
           ISNULL([tblUnitMstr].[FloorType], '') AS [FloorType],
           ISNULL(CONVERT(VARCHAR(20), [tblUnitReference].[StatDate], 107), '') AS [StatDate],
           ISNULL(CONVERT(VARCHAR(20), [tblUnitReference].[FinishDate], 107), '') AS [FinishDate],
           ISNULL(CONVERT(VARCHAR(20), [tblUnitReference].[TransactionDate], 107), '') AS [TransactionDate],
           CAST(ISNULL([tblUnitReference].[Rental], 0) AS DECIMAL(10, 2)) AS [Rental],
           CAST(ISNULL([tblUnitReference].[SecAndMaintenance], 0) AS DECIMAL(10, 2)) AS [SecAndMaintenance],
           CAST(ISNULL([tblUnitReference].[TotalRent], 0) AS DECIMAL(10, 2)) AS [TotalRent],
           CAST(ISNULL([tblUnitReference].[AdvancePaymentAmount], 0) AS DECIMAL(10, 2)) AS [AdvancePaymentAmount],
           CAST(ISNULL([tblUnitReference].[SecDeposit], 0) AS DECIMAL(10, 2)) AS [SecDeposit],
           CAST(ISNULL([tblUnitReference].[Total], 0) AS DECIMAL(10, 2)) AS [Total],
           [tblUnitReference].[EncodedBy],
           [tblUnitReference].[EncodedDate],
           [tblUnitReference].[IsActive],
           [tblUnitReference].[ComputerName],
           IIF(ISNULL([tblUnitMstr].[IsParking], 0) = 1, 'TYPE OF PARKING', 'TYPE OF UNIT') AS [TypeOf],
           IIF(ISNULL([tblUnitReference].[IsFullPayment], 0) = 1, 'FULL PAYMENT', 'INSTALLMENT') AS [PaymentCategory],
		   IIF(ISNULL([tblUnitReference].[IsPartialPayment], 0) = 1, 'HOLD - PARTIAL PAYMENT', 'NEW') AS [TranStatus]--this for First Payment Flag AS Partial Payment
    FROM [dbo].[tblUnitReference] WITH (NOLOCK)
        INNER JOIN [dbo].[tblProjectMstr] WITH (NOLOCK)
            ON [tblUnitReference].[ProjectId] = [tblProjectMstr].[RecId]
        INNER JOIN [dbo].[tblUnitMstr] WITH (NOLOCK)
            ON [tblUnitMstr].[RecId] = [tblUnitReference].[UnitId]
    WHERE ISNULL([tblUnitReference].[IsPaid], 0) = 0;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetContractDetailsInquiry]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetComputationById] 10000000
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetContractDetailsInquiry] @RefId VARCHAR(20) = NULL
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;


    SELECT [tblUnitReference].[RecId],
           [tblUnitReference].[RefId],
           ISNULL([tblUnitReference].[ClientID], '') AS [ClientID],
           [tblUnitReference].[ProjectId],
           ISNULL([tblProjectMstr].[ProjectName], '') AS [ProjectName],
           ISNULL([tblProjectMstr].[ProjectAddress], '') AS [ProjectAddress],
           ISNULL([tblProjectMstr].[ProjectType], '') AS [ProjectType],
           ISNULL([tblUnitReference].[InquiringClient], '') AS [InquiringClient],
           ISNULL([tblUnitReference].[ClientMobile], '') AS [ClientMobile],
           [tblUnitReference].[UnitId],
           ISNULL([tblUnitReference].[UnitNo], '') AS [UnitNo],
           ISNULL([tblUnitMstr].[FloorType], '') AS [FloorType],
           ISNULL(CONVERT(VARCHAR(20), [tblUnitReference].[StatDate], 107), '') AS [StatDate],
           ISNULL(CONVERT(VARCHAR(20), [tblUnitReference].[FinishDate], 107), '') AS [FinishDate],
           ISNULL(CONVERT(VARCHAR(20), [tblUnitReference].[TransactionDate],107), '') AS [TransactionDate],
           CAST(ISNULL([tblUnitReference].[Rental], 0) AS DECIMAL(10, 2)) AS [Rental],
           CAST(ISNULL([tblUnitReference].[SecAndMaintenance], 0) AS DECIMAL(10, 2)) AS [SecAndMaintenance],
           CAST(ISNULL([tblUnitReference].[TotalRent], 0) AS DECIMAL(10, 2)) AS [TotalRent],
           CAST(ISNULL([tblUnitReference].[AdvancePaymentAmount], 0) AS DECIMAL(10, 2)) AS [AdvancePaymentAmount],
           CAST(ISNULL([tblUnitReference].[SecDeposit], 0) AS DECIMAL(10, 2)) AS [SecDeposit],
           CAST(ISNULL([tblUnitReference].[Total], 0) AS DECIMAL(10, 2)) AS [Total],
           [tblUnitReference].[EncodedBy],
           [tblUnitReference].[EncodedDate],
           [tblUnitReference].[IsActive],
           [tblUnitReference].[ComputerName],
           ISNULL([tblUnitReference].[AdvancePaymentAmount], 0) AS [TwoMonAdvance],
           ISNULL([tblUnitReference].[IsUnitMoveOut], 0) AS [IsUnitMoveOut],
           --IIF(ISNULL([tblUnitReference].[IsSignedContract], 0) = 1, 'DONE', '') AS [ContractSignStatus],
           --ISNULL(CONVERT(VARCHAR(10), [tblUnitReference].[SignedContractDate], 1), '') AS [ContractSignedDate],
           --IIF(ISNULL([tblUnitReference].[IsUnitMove], 0) = 1, 'DONE', '') AS [MoveinStatus],
           --ISNULL(CONVERT(VARCHAR(10), [tblUnitReference].[UnitMoveInDate], 1), '') AS [MoveInDate],
           --IIF(ISNULL([tblUnitReference].[IsUnitMoveOut], 0) = 1, 'DONE', '') AS [MoveOutStatus],
           --ISNULL(CONVERT(VARCHAR(10), [tblUnitReference].[UnitMoveOutDate], 1), '') AS [MoveOutDate],
           --IIF(ISNULL([tblUnitReference].[IsTerminated], 0) = 1, 'YES', '') AS [TerminationStatus],
           --ISNULL(CONVERT(VARCHAR(10), [tblUnitReference].[TerminationDate], 1), '') AS [TerminationDate],
           --IIF(ISNULL([tblUnitReference].[IsDone], 0) = 1, 'CLOSED', 'IN-PROGRESS') AS [ContractStatus],
           --ISNULL(CONVERT(VARCHAR(10), [tblUnitReference].[ContactDoneDate], 1), '') AS [ContractCloseDate],
		   ISNULL([tblUnitReference].[IsPaid], 0) AS [PaymentStatus],
           ISNULL([tblUnitReference].[IsSignedContract], 0) AS [ContractSignStatus],
           ISNULL([tblUnitReference].[IsUnitMove], 0) AS [MoveinStatus],
           ISNULL([tblUnitReference].[IsUnitMoveOut], 0) AS [MoveOutStatus],
           ISNULL([tblUnitReference].[IsTerminated], 0) AS [TerminationStatus],
           ISNULL([tblUnitReference].[IsDone], 0) AS [ContractStatus],
           [PAYMENT].[TotalPayAMount] AS [TotalPayAMount]
    FROM [dbo].[tblUnitReference] WITH (NOLOCK)
        INNER JOIN [dbo].[tblProjectMstr] WITH (NOLOCK)
            ON [tblUnitReference].[ProjectId] = [tblProjectMstr].[RecId]
        INNER JOIN [dbo].[tblUnitMstr] WITH (NOLOCK)
            ON [tblUnitMstr].[RecId] = [tblUnitReference].[UnitId]
        OUTER APPLY
    (
        SELECT ISNULL(SUM([tblTransaction].[ReceiveAmount]), 0) AS [TotalPayAMount]
        FROM [dbo].[tblTransaction]
        WHERE [tblUnitReference].[RefId] = [tblTransaction].[RefId]
        GROUP BY [tblTransaction].[RefId]
    ) [PAYMENT]
    WHERE [tblUnitReference].[RefId] = @RefId;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetContractList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_GetContractList]
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT
            [tblUnitReference].[RecId],
            [tblUnitReference].[RefId],
            [tblUnitReference].[ProjectId],
            [tblUnitReference].[InquiringClient],
            [tblUnitReference].[ClientMobile],
            [tblUnitReference].[UnitId],
            [tblUnitReference].[UnitNo],
            CONVERT(VARCHAR(10), [tblUnitReference].[StatDate], 101)        AS [StatDate],
            CONVERT(VARCHAR(10), [tblUnitReference].[FinishDate], 101)      AS [FinishDate],
            CONVERT(VARCHAR(10), [tblUnitReference].[TransactionDate], 101) AS [TransactionDate],
            [tblUnitReference].[Rental],
            [tblUnitReference].[SecAndMaintenance],
            [tblUnitReference].[TotalRent],
            [tblUnitReference].[SecDeposit],
            [tblUnitReference].[Total],
            [tblUnitReference].[EncodedBy],
            [tblUnitReference].[EncodedDate],
            [tblUnitReference].[LastCHangedBy],
            [tblUnitReference].[LastChangedDate],
            [tblUnitReference].[IsActive],
            [tblUnitReference].[ComputerName],
            [tblUnitReference].[ClientID],
            [tblUnitReference].[IsPaid],
            [tblUnitReference].[IsDone],
            [tblUnitReference].[HeaderRefId],
            [tblUnitReference].[IsSignedContract],
            [tblUnitReference].[IsUnitMove],
            [tblUnitReference].[IsTerminated],
            [tblUnitReference].[GenVat],
            [tblUnitReference].[WithHoldingTax],
            [tblUnitReference].[IsUnitMoveOut],
            [tblUnitReference].[FirstPaymentDate],
            [tblUnitReference].[ContactDoneDate],
            [tblUnitReference].[SignedContractDate],
            [tblUnitReference].[UnitMoveInDate],
            [tblUnitReference].[UnitMoveOutDate],
            [tblUnitReference].[TerminationDate],
            [tblUnitReference].[AdvancePaymentAmount]
        FROM
            [dbo].[tblUnitReference];
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetControlList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetControlList]
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT
                [tblFormControlsMaster].[ControlId],
                [tblFormControlsMaster].[FormId],
                [tblForm].[FormDescription],
                [tblFormControlsMaster].[MenuId],
                [tblMenu].[MenuName],
                [tblFormControlsMaster].[ControlName],
                [tblFormControlsMaster].[ControlDescription],
                IIF(ISNULL([tblFormControlsMaster].[IsBackRoundControl], 0) = 1, 'YES', 'NO') AS [IsBackRoundControl],
                IIF(ISNULL([tblFormControlsMaster].[IsHeaderControl], 0) = 1, 'YES', 'NO')    AS [IsHeaderControl],
                IIF(ISNULL([tblFormControlsMaster].[IsDelete], 0) = 0, 'ACTIVE', 'IN-ACTIVE') AS [Status]
        FROM
                [dbo].[tblFormControlsMaster]
            INNER JOIN
                [dbo].[tblForm]
                    ON [tblFormControlsMaster].[FormId] = [tblForm].[FormId]
            INNER JOIN
                [dbo].[tblMenu]
                    ON [tblFormControlsMaster].[MenuId] = [tblMenu].[MenuId];

    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetControlListByGroupIdAndMenuId]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetControlListByGroupIdAndMenuId] 1,2
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetControlListByGroupIdAndMenuId]
    @MenuId  INT = NULL,
    @GroupId INT = NULL
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT  DISTINCT
                [tblFormControlsMaster].[ControlId],
                [tblMenu].[MenuName],
                [tblFormControlsMaster].[ControlName],
                [tblFormControlsMaster].[ControlDescription],
                IIF(ISNULL([tblGroupFormControls].[IsVisible], 0) = 1, 'YES', 'NO') AS [IsVisible]
        FROM
                [dbo].[tblGroupFormControls]
            INNER JOIN
                [dbo].[tblFormControlsMaster]
                    ON [tblGroupFormControls].[FormId] = [tblFormControlsMaster].[FormId]
                       AND [tblGroupFormControls].[ControlId] = [tblFormControlsMaster].[ControlId]
            INNER JOIN
                [dbo].[tblMenu]
                    ON [tblFormControlsMaster].[MenuId] = [tblMenu].[MenuId]
        WHERE
                [tblGroupFormControls].[GroupId] = @GroupId
                AND [tblFormControlsMaster].[MenuId] = @MenuId
                AND ISNULL([tblFormControlsMaster].[IsBackRoundControl], 0) = 0;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_getControlPermission]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_getControlPermission] 1
-- =============================================
CREATE PROCEDURE [dbo].[sp_getControlPermission] @GroupId INT = NULL
-- Add the parameters for the stored procedure here

AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
        SELECT
                [tblForm].[FormName],
                [tblFormControlsMaster].[ControlName]         AS [ControlName],
                ISNULL([tblGroupFormControls].[IsVisible], 0) AS [Permission]
        FROM
                [dbo].[tblGroupFormControls]
            INNER JOIN
                [dbo].[tblFormControlsMaster]
                    ON [tblGroupFormControls].[ControlId] = [tblFormControlsMaster].[ControlId]
            INNER JOIN
                [dbo].[tblForm]
                    ON [tblFormControlsMaster].[FormId] = [tblForm].[FormId]
        WHERE
                ISNULL([tblFormControlsMaster].[IsBackRoundControl], 0) = 0
                AND [tblGroupFormControls].[GroupId] = @GroupId;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_getControlPermission_Debug]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_getControlPermission_Debug] 
@GroupId INT =NULL
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		tblForm.FormName,
		tblFormControlsMaster.ControlName AS ControlName,
		ISNULL(tblGroupFormControls.IsVisible,0) AS Permission  
	FROM tblGroupFormControls
		INNER JOIN tblFormControlsMaster
			ON tblGroupFormControls.ControlId = tblFormControlsMaster.ControlId
		INNER JOIN tblForm
			ON tblFormControlsMaster.FormId = tblForm.FormId 
	WHERE ISNULL(tblFormControlsMaster.IsBackRoundControl,0)=0
	AND tblGroupFormControls.GroupId = @GroupId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetFilesByClient]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetFilesByClient] @ClientName VARCHAR(50)
AS
    BEGIN
        SELECT
            [Files].[Id],
            [Files].[FilePath],
            [Files].[FileData],
            [Files].[FileNames],
            [Files].[Notes],
            [Files].[Files]
        FROM
            [dbo].[Files]
        WHERE
            [Files].[ClientName] = @ClientName;
    END;

GO
/****** Object:  StoredProcedure [dbo].[sp_GetFilesByClientAndReference]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetFilesByClientAndReference]
    @ClientName  VARCHAR(50) = NULL,
    @ReferenceID VARCHAR(20) = NULL
AS
    BEGIN
        SELECT
            [Files].[Id],
            [Files].[FilePath],
            [Files].[FileData],
            [Files].[FileNames],
            [Files].[Notes],
            [Files].[Files]
        FROM
            [dbo].[Files]
        WHERE
            [Files].[ClientName] = @ClientName
            AND [Files].[RefId] = @ReferenceID;
    END;

GO
/****** Object:  StoredProcedure [dbo].[sp_GetFirstPaymentByContractIdAndClientNumber]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetFirstPaymentByContractIdAndClientNumber] @ReferenceID =10000000, @ClientID = 'INDV10000000'
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetFirstPaymentByContractIdAndClientNumber]
    @ReferenceID INT,
    @ClientID VARCHAR(50) = NULL
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @RefId AS VARCHAR(30) = '';
    DECLARE @IsFullPayment BIT = 0;
    SELECT @RefId = [tblUnitReference].[RefId],
           @IsFullPayment = [tblUnitReference].[IsFullPayment]
    FROM [dbo].[tblUnitReference] WITH (NOLOCK)
    WHERE [tblUnitReference].[RecId] = @ReferenceID;
    -- Insert statements for procedure here

    CREATE TABLE [#TempLedger]
    (
        [seq] INT,
        [LedgAmount] DECIMAL(18, 2),
        [LedgMonth] VARCHAR(20),
        [Remarks] VARCHAR(500)
    )

    IF @IsFullPayment = 1
    BEGIN
        INSERT INTO [#TempLedger]
        (
            [seq],
            [LedgAmount],
            [LedgMonth],
            [Remarks]
        )
        SELECT 0 AS [seq],
               (
                   SELECT [tblUnitReference].[SecDeposit]
                   FROM [dbo].[tblUnitReference] WITH (NOLOCK)
                   WHERE [tblUnitReference].[RecId] = @ReferenceID
               ) AS [LedgAmount],
               CONVERT(VARCHAR(20), GETDATE(), 107) AS [LedgMonth],
               'FOR SECURITY DEPOSIT' AS [Remarks]
        FROM [dbo].[tblUnitReference] WITH (NOLOCK)
        WHERE [tblUnitReference].[RecId] = @ReferenceID
              AND ISNULL([tblUnitReference].[SecDeposit], 0) > 0
        UNION
        SELECT 0 [seq],
               [tblMonthLedger].[LedgRentalAmount],
               CONVERT(VARCHAR(20), [tblMonthLedger].[LedgMonth], 107) AS [LedgMonth],
               'FOR FULL PAYMENT' AS [Remarks]
        FROM [dbo].[tblMonthLedger] WITH (NOLOCK)
        WHERE [tblMonthLedger].[ReferenceID] = @ReferenceID
              AND [tblMonthLedger].[ClientID] = @ClientID
        --ORDER BY [seq] ASC;
    END;
    ELSE
    BEGIN
        INSERT INTO [#TempLedger]
        (
            [seq],
            [LedgAmount],
            [LedgMonth],
            [Remarks]
        )
        SELECT 0 AS [seq],
               (
                   SELECT [tblUnitReference].[SecDeposit]
                   FROM [dbo].[tblUnitReference] WITH (NOLOCK)
                   WHERE [tblUnitReference].[RecId] = @ReferenceID
               ) AS [LedgAmount],
               CONVERT(VARCHAR(20), GETDATE(), 107) AS [LedgMonth],
               'FOR SECURITY DEPOSIT' AS [Remarks]
        FROM [dbo].[tblUnitReference] WITH (NOLOCK)
        WHERE [tblUnitReference].[RecId] = @ReferenceID
              AND ISNULL([tblUnitReference].[SecDeposit], 0) > 0
        UNION
        SELECT 0 [seq],
               [tblMonthLedger].[LedgRentalAmount],
               CONVERT(VARCHAR(20), [tblMonthLedger].[LedgMonth], 107) AS [LedgMonth],
               IIF(
                   [tblMonthLedger].[LedgMonth] IN
                   (
                       SELECT [tblAdvancePayment].[Months]
                       FROM [dbo].[tblAdvancePayment] WITH (NOLOCK)
                       WHERE [tblAdvancePayment].[RefId] = @RefId
                   ),
                   'FOR ADVANCE PAYMENT',
                   'FOR POST DATED CHECK') AS [Remarks]
        FROM [dbo].[tblMonthLedger] WITH (NOLOCK)
        WHERE [tblMonthLedger].[ReferenceID] = @ReferenceID
              AND [tblMonthLedger].[ClientID] = @ClientID
        --ORDER BY [seq] ASC;
    END;



    SELECT ROW_NUMBER() OVER (ORDER BY CAST([#TempLedger].[LedgMonth] AS DATE) ASC) [seq],
           SUM([#TempLedger].[LedgAmount]) AS [LedgAmount],
           [#TempLedger].[LedgMonth],
           [#TempLedger].[Remarks]
    FROM [#TempLedger]
	WHERE [#TempLedger].[Remarks] NOT IN ('FOR POST DATED CHECK')
    GROUP BY [#TempLedger].[LedgMonth],
             [#TempLedger].[Remarks]
    --ORDER BY [seq] ASC

    DROP TABLE [#TempLedger]
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetFloorTypeBrowse]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_GetFloorTypeBrowse]
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
        SELECT
            ISNULL([tblFloorTypes].[FloorTypesDescription], '') AS [FloorTypeName]
        FROM
            [dbo].[tblFloorTypes]
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetForContractSignedParkingList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetForContractSignedParkingList]
-- Add the parameters for the stored procedure here

AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
        SELECT
                [tblUnitReference].[RecId],
                [tblUnitReference].[RefId],
                [tblUnitReference].[ProjectId],
                [tblUnitReference].[InquiringClient],
                [tblUnitReference].[ClientMobile],
                [tblUnitReference].[UnitId],
                [tblUnitReference].[UnitNo],
                [tblUnitReference].[StatDate],
                [tblUnitReference].[FinishDate],
                [tblUnitReference].[TransactionDate],
                [tblUnitReference].[Rental],
                [tblUnitReference].[SecAndMaintenance],
                [tblUnitReference].[TotalRent],
                [tblUnitReference].[AdvancePaymentAmount],
                [tblUnitReference].[SecDeposit],
                [tblUnitReference].[Total],
                [tblUnitReference].[EncodedBy],
                [tblUnitReference].[EncodedDate],
                [tblUnitReference].[LastCHangedBy],
                [tblUnitReference].[LastChangedDate],
                [tblUnitReference].[IsActive],
                [tblUnitReference].[ComputerName],
                [tblUnitReference].[ClientID],
                [tblUnitReference].[IsPaid],
                [tblUnitReference].[IsDone],
                [tblUnitReference].[HeaderRefId],
                [tblUnitReference].[IsSignedContract],
                [tblUnitReference].[IsUnitMove],
                [tblUnitReference].[IsTerminated]
        FROM
                [dbo].[tblUnitReference] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblUnitMstr] WITH (NOLOCK)
                    ON [tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
        WHERE
                ISNULL([tblUnitReference].[IsPaid], 0) = 1
                AND ISNULL([tblUnitReference].[IsDone], 0) = 0
                AND ISNULL([tblUnitReference].[IsSignedContract], 0) = 0
                AND ISNULL([tblUnitReference].[IsUnitMove], 0) = 0
                AND ISNULL([tblUnitReference].[IsTerminated], 0) = 0
                AND ISNULL([tblUnitMstr].[IsParking], 0) = 1;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetForContractSignedUnitList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetForContractSignedUnitList]
-- Add the parameters for the stored procedure here

AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
        SELECT
                [tblUnitReference].[RecId],
                [tblUnitReference].[RefId],
                [tblUnitReference].[ProjectId],
                [tblUnitReference].[InquiringClient],
                [tblUnitReference].[ClientMobile],
                [tblUnitReference].[UnitId],
                [tblUnitReference].[UnitNo],
                [tblUnitReference].[StatDate],
                [tblUnitReference].[FinishDate],
                [tblUnitReference].[TransactionDate],
                [tblUnitReference].[Rental],
                [tblUnitReference].[SecAndMaintenance],
                [tblUnitReference].[TotalRent],
                [tblUnitReference].[AdvancePaymentAmount],
                [tblUnitReference].[SecDeposit],
                [tblUnitReference].[Total],
                [tblUnitReference].[EncodedBy],
                [tblUnitReference].[EncodedDate],
                [tblUnitReference].[LastCHangedBy],
                [tblUnitReference].[LastChangedDate],
                [tblUnitReference].[IsActive],
                [tblUnitReference].[ComputerName],
                [tblUnitReference].[ClientID],
                [tblUnitReference].[IsPaid],
                [tblUnitReference].[IsDone],
                [tblUnitReference].[HeaderRefId],
                [tblUnitReference].[IsSignedContract],
                [tblUnitReference].[IsUnitMove],
                [tblUnitReference].[IsTerminated]
        FROM
                [dbo].[tblUnitReference] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblUnitMstr] WITH (NOLOCK)
                    ON [tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
        WHERE
                ISNULL([tblUnitReference].[IsPaid], 0) = 1
                AND ISNULL([tblUnitReference].[IsDone], 0) = 0
                AND ISNULL([tblUnitReference].[IsSignedContract], 0) = 0
                AND ISNULL([tblUnitReference].[IsUnitMove], 0) = 0
                AND ISNULL([tblUnitReference].[IsTerminated], 0) = 0
                AND ISNULL([tblUnitMstr].[IsParking], 0) = 0;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetFormList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetFormList]
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT
            [tblForm].[FormId],
            [tblForm].[MenuId],
            [tblForm].[FormName],
            [tblForm].[FormDescription],
            [tblForm].[IsDelete]
        FROM
            [dbo].[tblForm];
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetFormListByGroupId]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetFormListByGroupId] 2
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetFormListByGroupId] @GroupId INT = NULL
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT  DISTINCT
                [tblGroupFormControls].[FormId],
                [tblForm].[FormDescription]
        FROM
                [dbo].[tblGroupFormControls]
            INNER JOIN
                [dbo].[tblForm]
                    ON [tblGroupFormControls].[FormId] = [tblForm].[FormId]
        WHERE
                [tblGroupFormControls].[GroupId] = @GroupId;

    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetForMoveInParkingList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetForMoveInParkingList]
-- Add the parameters for the stored procedure here

AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
        SELECT
                [tblUnitReference].[RecId],
                [tblUnitReference].[RefId],
                [tblUnitReference].[ProjectId],
                [tblUnitReference].[InquiringClient],
                [tblUnitReference].[ClientMobile],
                [tblUnitReference].[UnitId],
                [tblUnitReference].[UnitNo],
                [tblUnitReference].[StatDate],
                [tblUnitReference].[FinishDate],
                [tblUnitReference].[TransactionDate],
                [tblUnitReference].[Rental],
                [tblUnitReference].[SecAndMaintenance],
                [tblUnitReference].[TotalRent],
                [tblUnitReference].[AdvancePaymentAmount],
                [tblUnitReference].[SecDeposit],
                [tblUnitReference].[Total],
                [tblUnitReference].[EncodedBy],
                [tblUnitReference].[EncodedDate],
                [tblUnitReference].[LastCHangedBy],
                [tblUnitReference].[LastChangedDate],
                [tblUnitReference].[IsActive],
                [tblUnitReference].[ComputerName],
                [tblUnitReference].[ClientID],
                [tblUnitReference].[IsPaid],
                [tblUnitReference].[IsDone],
                [tblUnitReference].[HeaderRefId],
                [tblUnitReference].[IsSignedContract],
                [tblUnitReference].[IsUnitMove],
                [tblUnitReference].[IsUnitMoveOut],
                [tblUnitReference].[IsTerminated]
        FROM
                [dbo].[tblUnitReference] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblUnitMstr] WITH (NOLOCK)
                    ON [tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
        WHERE
                ISNULL([tblUnitReference].[IsPaid], 0) = 1
                AND ISNULL([tblUnitReference].[IsDone], 0) = 0
                AND ISNULL([tblUnitReference].[IsSignedContract], 0) = 1
                AND ISNULL([tblUnitReference].[IsUnitMove], 0) = 0
                AND ISNULL([tblUnitReference].[IsUnitMoveOut], 0) = 0
                AND ISNULL([tblUnitReference].[IsTerminated], 0) = 0
                AND ISNULL([tblUnitMstr].[IsParking], 0) = 1;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetForMoveInUnitList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetForMoveInUnitList]
-- Add the parameters for the stored procedure here

AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
        SELECT
                [tblUnitReference].[RecId],
                [tblUnitReference].[RefId],
                [tblUnitReference].[ProjectId],
                [tblUnitReference].[InquiringClient],
                [tblUnitReference].[ClientMobile],
                [tblUnitReference].[UnitId],
                [tblUnitReference].[UnitNo],
                [tblUnitReference].[StatDate],
                [tblUnitReference].[FinishDate],
                [tblUnitReference].[TransactionDate],
                [tblUnitReference].[Rental],
                [tblUnitReference].[SecAndMaintenance],
                [tblUnitReference].[TotalRent],
                [tblUnitReference].[AdvancePaymentAmount],
                [tblUnitReference].[SecDeposit],
                [tblUnitReference].[Total],
                [tblUnitReference].[EncodedBy],
                [tblUnitReference].[EncodedDate],
                [tblUnitReference].[LastCHangedBy],
                [tblUnitReference].[LastChangedDate],
                [tblUnitReference].[IsActive],
                [tblUnitReference].[ComputerName],
                [tblUnitReference].[ClientID],
                [tblUnitReference].[IsPaid],
                [tblUnitReference].[IsDone],
                [tblUnitReference].[HeaderRefId],
                [tblUnitReference].[IsSignedContract],
                [tblUnitReference].[IsUnitMove],
                [tblUnitReference].[IsUnitMoveOut],
                [tblUnitReference].[IsTerminated]
        FROM
                [dbo].[tblUnitReference] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblUnitMstr] WITH (NOLOCK)
                    ON [tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
        WHERE
                ISNULL([tblUnitReference].[IsPaid], 0) = 1
                AND ISNULL([tblUnitReference].[IsDone], 0) = 0
                AND ISNULL([tblUnitReference].[IsSignedContract], 0) = 1
                AND ISNULL([tblUnitReference].[IsUnitMove], 0) = 0
                AND ISNULL([tblUnitReference].[IsUnitMoveOut], 0) = 0
                AND ISNULL([tblUnitReference].[IsTerminated], 0) = 0
                AND ISNULL([tblUnitMstr].[IsParking], 0) = 0;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetForMoveOutParkingList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetForMoveOutParkingList]
-- Add the parameters for the stored procedure here

AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;
        -- Insert statements for procedure here
        SELECT
                [tblUnitReference].[RecId],
                [tblUnitReference].[RefId],
                [tblUnitReference].[ProjectId],
                [tblUnitReference].[InquiringClient],
                [tblUnitReference].[ClientMobile],
                [tblUnitReference].[UnitId],
                [tblUnitReference].[UnitNo],
                [tblUnitReference].[StatDate],
                [tblUnitReference].[FinishDate],
                [tblUnitReference].[TransactionDate],
                [tblUnitReference].[Rental],
                [tblUnitReference].[SecAndMaintenance],
                [tblUnitReference].[TotalRent],
                [tblUnitReference].[AdvancePaymentAmount],
                [tblUnitReference].[SecDeposit],
                [tblUnitReference].[Total],
                [tblUnitReference].[EncodedBy],
                [tblUnitReference].[EncodedDate],
                [tblUnitReference].[LastCHangedBy],
                [tblUnitReference].[LastChangedDate],
                [tblUnitReference].[IsActive],
                [tblUnitReference].[ComputerName],
                [tblUnitReference].[ClientID],
                [tblUnitReference].[IsPaid],
                [tblUnitReference].[IsDone],
                [tblUnitReference].[HeaderRefId],
                [tblUnitReference].[IsSignedContract],
                [tblUnitReference].[IsUnitMove],
                [tblUnitReference].[IsUnitMoveOut],
                [tblUnitReference].[IsTerminated]
        FROM
                [dbo].[tblUnitReference] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblUnitMstr] WITH (NOLOCK)
                    ON [tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
        WHERE
                ISNULL([tblUnitReference].[IsPaid], 0) = 1
                AND ISNULL([tblUnitReference].[IsSignedContract], 0) = 1
                AND ISNULL([tblUnitReference].[IsUnitMove], 0) = 1
                AND ISNULL([tblUnitReference].[IsUnitMoveOut], 0) = 1
                AND ISNULL([tblUnitMstr].[IsParking], 0) = 1
                AND ISNULL([tblUnitReference].[IsDone], 0) = 0
                AND ISNULL([tblUnitReference].[IsTerminated], 0) = 0
                OR ISNULL([tblUnitReference].[IsTerminated], 0) = 1
                   AND ISNULL([tblUnitReference].[IsSignedContract], 0) = 1
                   AND ISNULL([tblUnitReference].[IsUnitMove], 0) = 1
                   AND ISNULL([tblUnitReference].[IsUnitMoveOut], 0) = 1
                   AND ISNULL([tblUnitMstr].[IsParking], 0) = 1
                   AND ISNULL([tblUnitReference].[IsDone], 0) = 0;

    --and
    --(
    --    SELECT COUNT(*)
    --    from tblMonthLedger WITH (NOLOCK)
    --    where ReferenceID = tblUnitReference.RecId
    --          and ISNULL(IsPaid, 0) = 1
    --) > 0
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetForMoveOutUnitList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetForMoveOutUnitList]
-- Add the parameters for the stored procedure here

AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @IsForMoveOut BIT = 0;

        -- Insert statements for procedure here
        SELECT
                [tblUnitReference].[RecId],
                [tblUnitReference].[RefId],
                [tblUnitReference].[ProjectId],
                [tblUnitReference].[InquiringClient],
                [tblUnitReference].[ClientMobile],
                [tblUnitReference].[UnitId],
                [tblUnitReference].[UnitNo],
                [tblUnitReference].[StatDate],
                [tblUnitReference].[FinishDate],
                [tblUnitReference].[TransactionDate],
                [tblUnitReference].[Rental],
                [tblUnitReference].[SecAndMaintenance],
                [tblUnitReference].[TotalRent],
                [tblUnitReference].[AdvancePaymentAmount],
                [tblUnitReference].[SecDeposit],
                [tblUnitReference].[Total],
                [tblUnitReference].[EncodedBy],
                [tblUnitReference].[EncodedDate],
                [tblUnitReference].[LastCHangedBy],
                [tblUnitReference].[LastChangedDate],
                [tblUnitReference].[IsActive],
                [tblUnitReference].[ComputerName],
                [tblUnitReference].[ClientID],
                [tblUnitReference].[IsPaid],
                [tblUnitReference].[IsDone],
                [tblUnitReference].[HeaderRefId],
                [tblUnitReference].[IsSignedContract],
                [tblUnitReference].[IsUnitMove],
                [tblUnitReference].[IsUnitMoveOut],
                [tblUnitReference].[IsTerminated]
        FROM
                [dbo].[tblUnitReference] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblUnitMstr] WITH (NOLOCK)
                    ON [tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
        WHERE
                ISNULL([tblUnitReference].[IsPaid], 0) = 1
                AND ISNULL([tblUnitReference].[IsSignedContract], 0) = 1
                AND ISNULL([tblUnitReference].[IsUnitMove], 0) = 1
                AND ISNULL([tblUnitReference].[IsUnitMoveOut], 0) = 1
                AND ISNULL([tblUnitMstr].[IsParking], 0) = 0
                AND ISNULL([tblUnitReference].[IsDone], 0) = 0
                AND ISNULL([tblUnitReference].[IsTerminated], 0) = 0
                OR ISNULL([tblUnitReference].[IsTerminated], 0) = 1
                   AND ISNULL([tblUnitReference].[IsSignedContract], 0) = 1
                   AND ISNULL([tblUnitReference].[IsUnitMove], 0) = 1
                   AND ISNULL([tblUnitReference].[IsUnitMoveOut], 0) = 1
                   AND ISNULL([tblUnitMstr].[IsParking], 0) = 0
                   AND ISNULL([tblUnitReference].[IsDone], 0) = 0;

    --and
    --(
    --    SELECT COUNT(*)
    --    from tblMonthLedger WITH (NOLOCK)
    --    where ReferenceID = tblUnitReference.RecId
    --          and ISNULL(IsPaid, 0) = 1
    --) > 0
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetGroup]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetGroup] @UserId INT = NULL
AS
    BEGIN

        SELECT
                [tblUser].[UserId],
                [tblUser].[GroupId]    AS [Group_Code],
                [tblGroup].[GroupName] AS [Group_Name]
        FROM
                [dbo].[tblUser]
            INNER JOIN
                [dbo].[tblGroup]
                    ON [tblGroup].[GroupId] = [tblUser].[GroupId]
        WHERE
                [tblUser].[UserId] = @UserId;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetGroupControlInfo]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_GetGroupControlInfo]
    @ControlId AS INT = NULL,
    @GroupId AS INT = NULL,
    @FormId AS INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT [tblGroupFormControls].[GroupControlId],
           [tblGroupFormControls].[FormId],
           [tblGroupFormControls].[ControlId],
           [tblGroupFormControls].[GroupId],
           [tblGroupFormControls].[IsVisible],
           [tblGroupFormControls].[IsDelete]
    FROM [dbo].[tblGroupFormControls]
    WHERE [tblGroupFormControls].[ControlId] = @ControlId
          AND [tblGroupFormControls].[GroupId] = @GroupId
          AND [tblGroupFormControls].[FormId] = @FormId;

END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetGroupList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetGroupList]
AS
BEGIN

    SET NOCOUNT ON;
    MERGE INTO [dbo].[tblGroupFormControls] AS [target]
    USING
    (
        SELECT [tblFormControlsMaster].[FormId],
               [tblFormControlsMaster].[ControlId],
               [tblGroup].[GroupId],
               1 AS [IsVisible],
               0 AS [IsDelete]
        FROM [dbo].[tblFormControlsMaster]
            CROSS JOIN [dbo].[tblGroup]
    ) AS [source]
    ON [target].[FormId] = [source].[FormId]
       AND [target].[ControlId] = [source].[ControlId]
       AND [target].[GroupId] = [source].[GroupId]
    WHEN NOT MATCHED THEN
        INSERT
        (
            [FormId],
            [ControlId],
            [GroupId],
            [IsVisible],
            [IsDelete]
        )
        VALUES
        ([source].[FormId], [source].[ControlId], [source].[GroupId], [source].[IsVisible], [source].[IsDelete]);
    SELECT [tblGroup].[GroupId],
           [tblGroup].[GroupName],
           [tblGroup].[IsDelete]
    FROM [dbo].[tblGroup];

END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetInActiveLocationList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetInActiveLocationList]
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT
            [tblLocationMstr].[RecId],
            [tblLocationMstr].[Descriptions],
            [tblLocationMstr].[LocAddress],
            IIF(ISNULL([tblLocationMstr].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE') AS [IsActive]
        FROM
            [dbo].[tblLocationMstr]
        WHERE
            ISNULL([IsActive], 0) = 0;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetInActiveProjectList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetInActiveProjectList]
AS
    BEGIN

        SET NOCOUNT ON;


        SELECT
                [tblProjectMstr].[RecId],
                [tblProjectMstr].[LocId],
                [tblProjectMstr].[ProjectAddress],
                [tblLocationMstr].[Descriptions]                                       AS [LocationName],
                [tblProjectMstr].[ProjectName],
                [tblProjectMstr].[Descriptions],
                IIF(ISNULL([tblProjectMstr].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE') AS [IsActive]
        FROM
                [dbo].[tblProjectMstr] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblLocationMstr] WITH (NOLOCK)
                    ON [tblLocationMstr].[RecId] = [tblProjectMstr].[LocId]
        WHERE
                ISNULL([tblProjectMstr].[IsActive], 0) = 0;

    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetInActivePurchaseItemList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetInActivePurchaseItemList]
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT
                [tblProjPurchItem].[RecId],
                [tblProjPurchItem].[PurchItemID],
                [tblProjPurchItem].[ProjectId],
                [tblProjectMstr].[ProjectName],
                [tblProjectMstr].[ProjectAddress],
                ISNULL([tblProjPurchItem].[Descriptions], '')                               AS [Descriptions],
                ISNULL(CONVERT(VARCHAR(10), [tblProjPurchItem].[DatePurchase], 103), '')    AS [DatePurchase],
                CAST(ISNULL([tblProjPurchItem].[UnitAmount], 0) AS DECIMAL(10, 2))          AS [UnitAmount],
                CAST(ISNULL([tblProjPurchItem].[Amount], 0) AS DECIMAL(10, 2))              AS [Amount],
                CAST(ISNULL([tblProjPurchItem].[TotalAmount], 0) AS DECIMAL(10, 2))         AS [TotalAmount],
                ISNULL([tblProjPurchItem].[Remarks], '')                                    AS [Remarks],
                IIF(ISNULL([tblProjPurchItem].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE')    AS [IsActive],
                ISNULL([tblProjPurchItem].[EncodedBy], 0)                                   AS [EncodedBy],
                ISNULL(CONVERT(VARCHAR(10), [tblProjPurchItem].[EncodedDate], 103), '')     AS [EncodedDate],
                ISNULL([tblProjPurchItem].[LastChangedBy], 0)                               AS [LastChangedBy],
                ISNULL(CONVERT(VARCHAR(10), [tblProjPurchItem].[LastChangedDate], 103), '') AS [LastChangedDate],
                ISNULL([tblProjPurchItem].[ComputerName], '')                               AS [ComputerName]
        FROM
                [dbo].[tblProjPurchItem]
            INNER JOIN
                [dbo].[tblProjectMstr]
                    ON [tblProjectMstr].[RecId] = [tblProjPurchItem].[ProjectId]
        WHERE
                ISNULL([tblProjPurchItem].[IsActive], 0) = 0;



    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetLatestFile]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetLatestFile]
AS
    BEGIN
        SELECT TOP 1
               [Files].[FilePath],
               [Files].[FileData]
        FROM
               [dbo].[Files]
        ORDER BY
               [Files].[Id] DESC;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetLedgerList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetLedgerList] @ReferenceID =10000000, @ClientID='INDV10000000'
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLedgerList]
    @ReferenceID BIGINT       = NULL,
    @ClientID    VARCHAR(150) = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @TotalRent DECIMAL(18, 2) = NULL
        DECLARE @PenaltyPct DECIMAL(18, 2) = NULL
        DECLARE @RefId VARCHAR(150) = ''

        SELECT
            @RefId =
            (
                SELECT
                    [tblUnitReference].[RefId]
                FROM
                    [dbo].[tblUnitReference]
                WHERE
                    [tblUnitReference].[RecId] = @ReferenceID
            )
        SELECT
            @TotalRent  = [tblUnitReference].[TotalRent],
            @PenaltyPct = [tblUnitReference].[PenaltyPct]
        FROM
            [dbo].[tblUnitReference] WITH (NOLOCK)
        WHERE
            [tblUnitReference].[RecId] = @ReferenceID

        /*Check if the penalty stop when it reach the specific date to penalty*/
        UPDATE
            [dbo].[tblMonthLedger]
        SET
            [tblMonthLedger].[PenaltyAmount] = IIF([tblMonthLedger].[PenaltyAmount] > 0,
                                                   [tblMonthLedger].[PenaltyAmount],
                                                   CASE
                                                       WHEN DATEDIFF(
                                                                        DAY, [tblMonthLedger].[LedgMonth],
                                                                        CAST(GETDATE() AS DATE)
                                                                    ) < 30
                                                           THEN
                                                           0
                                                       WHEN DATEDIFF(
                                                                        DAY, [tblMonthLedger].[LedgMonth],
                                                                        CAST(GETDATE() AS DATE)
                                                                    ) = 30
                                                           THEN
                                                           --CAST(((@TotalRent * @PenaltyPct) / 100) AS DECIMAL(18, 2))
                                                           CAST((([tblMonthLedger].[LedgRentalAmount] * @PenaltyPct)
                                                                 / 100
                                                                ) AS DECIMAL(18, 2))
                                                       WHEN DATEDIFF(
                                                                        DAY, [tblMonthLedger].[LedgMonth],
                                                                        CAST(GETDATE() AS DATE)
                                                                    ) >= 31
                                                            AND DATEDIFF(
                                                                            DAY, [tblMonthLedger].[LedgMonth],
                                                                            CAST(GETDATE() AS DATE)
                                                                        --) <= 31 THEN
                                                                        ) <= 60
                                                           THEN
                                                           --CAST((((@TotalRent * @PenaltyPct) / 100) * 2) AS DECIMAL(18, 2))
                                                           CAST(((([tblMonthLedger].[LedgRentalAmount] * @PenaltyPct)
                                                                  / 100
                                                                 ) * 2
                                                                ) AS DECIMAL(18, 2))
                                                       WHEN DATEDIFF(
                                                                        DAY, [tblMonthLedger].[LedgMonth],
                                                                        CAST(GETDATE() AS DATE)
                                                                    ) = 60
                                                           THEN
                                                           --CAST((((@TotalRent * @PenaltyPct) / 100) * 3) AS DECIMAL(18, 2))
                                                           CAST(((([tblMonthLedger].[LedgRentalAmount] * @PenaltyPct)
                                                                  / 100
                                                                 ) * 3
                                                                ) AS DECIMAL(18, 2))
                                                       WHEN DATEDIFF(
                                                                        DAY, [tblMonthLedger].[LedgMonth],
                                                                        CAST(GETDATE() AS DATE)
                                                                    ) >= 61
                                                           THEN
                                                           --CAST((((@TotalRent * @PenaltyPct) / 100) * 4) AS DECIMAL(18, 2))
                                                           CAST(((([tblMonthLedger].[LedgRentalAmount] * @PenaltyPct)
                                                                  / 100
                                                                 ) * 4
                                                                ) AS DECIMAL(18, 2))
                                                       ELSE
                                                           0
                                                   END)
        WHERE
            [tblMonthLedger].[ReferenceID] = @ReferenceID
            AND
                (
                    ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                    OR ISNULL([tblMonthLedger].[IsHold], 0) = 1
                )
            AND MONTH([tblMonthLedger].[EncodedDate]) > 4
            AND YEAR([tblMonthLedger].[EncodedDate]) = 2024

        UPDATE
            [dbo].[tblMonthLedger]
        SET
            [tblMonthLedger].[ActualAmount] = [tblMonthLedger].[LedgRentalAmount]
                                              + ISNULL([tblMonthLedger].[PenaltyAmount], 0)
        WHERE
            [tblMonthLedger].[ReferenceID] = @ReferenceID
            AND
                (
                    ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                    OR ISNULL([tblMonthLedger].[IsHold], 0) = 1
                )


        SELECT
            ROW_NUMBER() OVER (ORDER BY
                                   [tblMonthLedger].[LedgMonth] ASC
                              )                                                               [seq],
            [tblMonthLedger].[Recid],
            [tblMonthLedger].[ReferenceID],
            [tblMonthLedger].[ClientID],
            --[tblMonthLedger].[LedgAmount]  + ISNULL([tblMonthLedger].[PenaltyAmount], 0) AS [LedgAmount],
            [tblMonthLedger].[LedgRentalAmount] + ISNULL([tblMonthLedger].[PenaltyAmount], 0) AS [LedgAmount],
            ISNULL([tblMonthLedger].[PenaltyAmount], 0)                                       AS [PenaltyAmount],
            ISNULL([tblMonthLedger].[TransactionID], '')                                      AS [TransactionID],
            CONVERT(VARCHAR(20), [tblMonthLedger].[LedgMonth], 107)                           AS [LedgMonth],
            [tblMonthLedger].[Remarks]                                                        AS [Remarks],
            --IIF(ISNULL(IsPaid, 0) = 1,
            --    'PAID',
            --    IIF(CONVERT(VARCHAR(20), LedgMonth, 107) = CONVERT(VARCHAR(20), GETDATE(), 107), 'FOR PAYMENT', 'PENDING')) As PaymentStatus,
            CASE
                WHEN ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                     AND ISNULL([tblMonthLedger].[IsHold], 0) = 0
                    THEN
                    'PAID'
                WHEN ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                     AND ISNULL([tblMonthLedger].[IsHold], 0) = 1
                    THEN
                    'HOLD'
                WHEN [tblMonthLedger].[LedgMonth] IN
                         (
                             SELECT
                                 [tblAdvancePayment].[Months]
                             FROM
                                 [dbo].[tblAdvancePayment]
                             WHERE
                                 [tblAdvancePayment].[RefId] = @RefId
                         )
                     AND ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                     AND ISNULL([tblMonthLedger].[IsHold], 0) = 0
                    THEN
                    'FOR PAYMENT'
                WHEN CONVERT(VARCHAR(20), [tblMonthLedger].[LedgMonth], 107) = CONVERT(VARCHAR(20), GETDATE(), 107)
                     AND ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                     AND ISNULL([tblMonthLedger].[IsHold], 0) = 0
                    THEN
                    'FOR PAYMENT'
                ELSE
                    'PENDING'
            END                                                                               AS [PaymentStatus],
            --IIF(
            --    [tblMonthLedger].[BalanceAmount] <= 0
            --    AND [tblMonthLedger].[IsPaid] = 0,
            --    0,
            --    [tblMonthLedger].[LedgAmount] - [tblMonthLedger].[BalanceAmount]) AS [AmountPaid],
            IIF(
                ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                OR
                    (
                        ISNULL([tblMonthLedger].[IsHold], 0) = 1
                        AND [tblMonthLedger].[BalanceAmount] > 0
                    ),
                ([tblMonthLedger].[ActualAmount]
                 - (ISNULL([tblMonthLedger].[BalanceAmount], 0) + ISNULL([tblMonthLedger].[PenaltyAmount], 0))
                ),
                0)                                                                            AS [AmountPaid],
            CAST(ABS(ISNULL([tblMonthLedger].[BalanceAmount], 0)) AS DECIMAL(18, 2))          AS [BalanceAmount]

        --'0.00' [PenaltyAmount]
        FROM
            [dbo].[tblMonthLedger]
        WHERE
            [tblMonthLedger].[ReferenceID] = @ReferenceID
            AND [tblMonthLedger].[ClientID] = @ClientID
        ORDER BY
            [seq] ASC;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetLedgerListOnQue]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLedgerListOnQue]
    --@ReferenceID BIGINT = NULL,
    --@ClientID VARCHAR(50) = NULL
    @XML XML = NULL
AS
    BEGIN

        SET NOCOUNT ON;

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
            ROW_NUMBER() OVER (ORDER BY
                                   [tblMonthLedger].[LedgMonth] ASC
                              )                                                      [seq],
            [tblMonthLedger].[Recid],
            [tblMonthLedger].[ReferenceID],
            [tblMonthLedger].[ClientID],
            [tblMonthLedger].[LedgRentalAmount]                                      AS [LedgAmount],
            ISNULL([tblMonthLedger].[PenaltyAmount], 0)                              AS [PenaltyAmount],
            ISNULL([tblMonthLedger].[TransactionID], '')                             AS [TransactionID],
            CONVERT(VARCHAR(20), [tblMonthLedger].[LedgMonth], 107)                  AS [LedgMonth],
            ''                                                                       AS [Remarks],
            CASE
                WHEN ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                     AND ISNULL([tblMonthLedger].[IsHold], 0) = 0
                    THEN
                    'PAID'
                WHEN ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                     AND ISNULL([tblMonthLedger].[IsHold], 0) = 1
                    THEN
                    'HOLD'
                WHEN [tblMonthLedger].[LedgMonth] IN
                         (
                             SELECT
                                 [tblAdvancePayment].[Months]
                             FROM
                                 [dbo].[tblAdvancePayment]
                             WHERE
                                 [tblAdvancePayment].[RefId] = 'REF'
                                                               + CAST([tblMonthLedger].[ReferenceID] AS VARCHAR(150))
                         )
                     AND ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                     AND ISNULL([tblMonthLedger].[IsHold], 0) = 0
                    THEN
                    'FOR PAYMENT'
                WHEN CONVERT(VARCHAR(20), [tblMonthLedger].[LedgMonth], 107) = CONVERT(VARCHAR(20), GETDATE(), 107)
                     AND ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                     AND ISNULL([tblMonthLedger].[IsHold], 0) = 0
                    THEN
                    'FOR PAYMENT'
                ELSE
                    'PENDING'
            END                                                                      AS [PaymentStatus],
            IIF(
                ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                OR
                    (
                        ISNULL([tblMonthLedger].[IsHold], 0) = 1
                        AND [tblMonthLedger].[BalanceAmount] > 0
                    ),
                ([tblMonthLedger].[LedgRentalAmount] - ISNULL([tblMonthLedger].[BalanceAmount], 0)),
                0)                                                                   AS [AmountPaid],
            CAST(ABS(ISNULL([tblMonthLedger].[BalanceAmount], 0)) AS DECIMAL(18, 2)) AS [BalanceAmount],
            --ISNULL([tblMonthLedger].[PaymentMode], '') AS [PaymentMode],
            --ISNULL([tblMonthLedger].[RcptID], '') AS [RcptID],
            ISNULL([tblMonthLedger].[CompanyORNo], '')                               AS [CompanyORNo],
            ISNULL([tblMonthLedger].[CompanyPRNo], '')                               AS [CompanyPRNo],
            ISNULL([tblMonthLedger].[REF], '')                                       AS [REF],
            ISNULL([tblMonthLedger].[BNK_ACCT_NAME], '')                             AS [BNK_ACCT_NAME],
            ISNULL([tblMonthLedger].[BNK_ACCT_NUMBER], '')                           AS [BNK_ACCT_NUMBER],
            ISNULL([tblMonthLedger].[BNK_NAME], '')                                  AS [BNK_NAME],
            ISNULL([tblMonthLedger].[SERIAL_NO], '')                                 AS [SERIAL_NO],
            ISNULL([tblMonthLedger].[ModeType], '')                                  AS [ModeType],
            ISNULL([tblMonthLedger].[BankBranch], '')                                AS [BankBranch]
        FROM
            [dbo].[tblMonthLedger]
        WHERE
            [tblMonthLedger].[Recid] IN
                (
                    SELECT
                        [#tblBulkPostdatedMonth].[Recid]
                    FROM
                        [#tblBulkPostdatedMonth]
                )
        ORDER BY
            [seq] ASC


        DROP TABLE [#tblBulkPostdatedMonth]
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetLedgerListOnQueTotalAMount]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLedgerListOnQueTotalAMount] @XML XML = NULL
AS
BEGIN

    SET NOCOUNT ON;
    CREATE TABLE [#tblBulkAmount]
    (
        [LedgAmount] DECIMAL(18, 2)
    )
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
        SELECT [ParaValues].[data].[value]('c1[1]', 'VARCHAR(10)')
        FROM @XML.[nodes]('/Table1') AS [ParaValues]([data])
    END

    INSERT INTO [#tblBulkAmount]
    (
        [LedgAmount]
    )
    SELECT CASE
               WHEN ISNULL([tblMonthLedger].[BalanceAmount], 0) > 0 THEN
                   ISNULL([tblMonthLedger].[BalanceAmount], 0)
               ELSE
        (ISNULL([tblMonthLedger].[LedgRentalAmount],0) + ISNULL([tblMonthLedger].[PenaltyAmount], 0))
           END AS [LedgAmount]
    FROM [dbo].[tblMonthLedger]
    WHERE [tblMonthLedger].[Recid] IN
          (
              SELECT [#tblBulkPostdatedMonth].[Recid] FROM [#tblBulkPostdatedMonth]
          )


    SELECT SUM([#tblBulkAmount].[LedgAmount]) AS [TOTAL_AMOUNT]
    FROM [#tblBulkAmount] 

    DROP TABLE [#tblBulkPostdatedMonth]
    DROP TABLE [#tblBulkAmount]
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetLocationById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLocationById] @RecId INT
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT
            [tblLocationMstr].[RecId],
            [tblLocationMstr].[Descriptions],
            [tblLocationMstr].[LocAddress],
            ISNULL([tblLocationMstr].[IsActive], 0) AS [IsActive]
        FROM
            [dbo].[tblLocationMstr]
        WHERE
            [tblLocationMstr].[RecId] = @RecId
            AND ISNULL([IsActive], 0) = 1;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetLocationList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLocationList]
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT
            [tblLocationMstr].[RecId],
            [tblLocationMstr].[Descriptions],
            [tblLocationMstr].[LocAddress],
            IIF(ISNULL([tblLocationMstr].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE') AS [IsActive]
        FROM
            [dbo].[tblLocationMstr]
        WHERE
            ISNULL([IsActive], 0) = 1;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetMenuList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetMenuList]
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT
            [tblMenu].[MenuId],
            [tblMenu].[MenuHeaderId],
            [tblMenu].[MenuName],
            [tblMenu].[MenuNameDescription],
            [tblMenu].[IsDelete]
        FROM
            [dbo].[tblMenu]
        WHERE
            ISNULL([tblMenu].[MenuHeaderId], 0) = 0;

    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetMenuListByFormId]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetMenuListByFormId] 1
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetMenuListByFormId] @FormId INT = NULL
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT  DISTINCT
                [tblFormControlsMaster].[MenuId],
                [tblMenu].[MenuName]
        FROM
                [dbo].[tblFormControlsMaster]
            INNER JOIN
                [dbo].[tblMenu]
                    ON [tblFormControlsMaster].[MenuId] = [tblMenu].[MenuId]
        WHERE
                [tblFormControlsMaster].[FormId] = @FormId;

    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetMonthLedgerByRefIdAndClientId]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetMonthLedgerByRefIdAndClientId] @ReferenceID =10000000, @ClientID = 'INDV10000000'
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetMonthLedgerByRefIdAndClientId]
    @ReferenceID INT,
    @ClientID VARCHAR(50) = NULL
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @RefId AS VARCHAR(30) = '';
    DECLARE @IsFullPayment BIT = 0;
    SELECT @RefId = [tblUnitReference].[RefId],
           @IsFullPayment = [tblUnitReference].[IsFullPayment]
    FROM [dbo].[tblUnitReference] WITH (NOLOCK)
    WHERE [tblUnitReference].[RecId] = @ReferenceID;
    -- Insert statements for procedure here

    CREATE TABLE [#TempLedger]
    (
        [seq] INT,
        [LedgAmount] DECIMAL(18, 2),
        [LedgMonth] VARCHAR(20),
        [Remarks] VARCHAR(500)
    )

    IF @IsFullPayment = 1
    BEGIN
        INSERT INTO [#TempLedger]
        (
            [seq],
            [LedgAmount],
            [LedgMonth],
            [Remarks]
        )
        SELECT 0 AS [seq],
               (
                   SELECT [tblUnitReference].[SecDeposit]
                   FROM [dbo].[tblUnitReference] WITH (NOLOCK)
                   WHERE [tblUnitReference].[RecId] = @ReferenceID
               ) AS [LedgAmount],
               CONVERT(VARCHAR(20), GETDATE(), 107) AS [LedgMonth],
               'FOR SECURITY DEPOSIT' AS [Remarks]
        FROM [dbo].[tblUnitReference] WITH (NOLOCK)
        WHERE [tblUnitReference].[RecId] = @ReferenceID
              AND ISNULL([tblUnitReference].[SecDeposit], 0) > 0
        UNION
        SELECT 0 [seq],
               [tblMonthLedger].[LedgRentalAmount],
               CONVERT(VARCHAR(20), [tblMonthLedger].[LedgMonth], 107) AS [LedgMonth],
               'FOR FULL PAYMENT' AS [Remarks]
        FROM [dbo].[tblMonthLedger] WITH (NOLOCK)
        WHERE [tblMonthLedger].[ReferenceID] = @ReferenceID
              AND [tblMonthLedger].[ClientID] = @ClientID
        ORDER BY [seq] ASC;
    END;
    ELSE
    BEGIN
        INSERT INTO [#TempLedger]
        (
            [seq],
            [LedgAmount],
            [LedgMonth],
            [Remarks]
        )
        SELECT 0 AS [seq],
               (
                   SELECT [tblUnitReference].[SecDeposit]
                   FROM [dbo].[tblUnitReference] WITH (NOLOCK)
                   WHERE [tblUnitReference].[RecId] = @ReferenceID
               ) AS [LedgAmount],
               CONVERT(VARCHAR(20), GETDATE(), 107) AS [LedgMonth],
               'FOR SECURITY DEPOSIT' AS [Remarks]
        FROM [dbo].[tblUnitReference] WITH (NOLOCK)
        WHERE [tblUnitReference].[RecId] = @ReferenceID
              AND ISNULL([tblUnitReference].[SecDeposit], 0) > 0
        UNION
        SELECT 0 [seq],
               [tblMonthLedger].[LedgRentalAmount],
               CONVERT(VARCHAR(20), [tblMonthLedger].[LedgMonth], 107) AS [LedgMonth],
               IIF(
                   [tblMonthLedger].[LedgMonth] IN
                   (
                       SELECT [tblAdvancePayment].[Months]
                       FROM [dbo].[tblAdvancePayment] WITH (NOLOCK)
                       WHERE [tblAdvancePayment].[RefId] = @RefId
                   ),
                   'FOR ADVANCE PAYMENT',
                   'FOR POST DATED CHECK') AS [Remarks]
        FROM [dbo].[tblMonthLedger] WITH (NOLOCK)
        WHERE [tblMonthLedger].[ReferenceID] = @ReferenceID
              AND [tblMonthLedger].[ClientID] = @ClientID
        ORDER BY [seq] ASC;
    END;



    SELECT ROW_NUMBER() OVER (ORDER BY CAST([#TempLedger].[LedgMonth] AS DATE) ASC) [seq],
           SUM([#TempLedger].[LedgAmount]) AS [LedgAmount],
           [#TempLedger].[LedgMonth],
           [#TempLedger].[Remarks]
    FROM [#TempLedger]
    GROUP BY [#TempLedger].[LedgMonth],
             [#TempLedger].[Remarks]
    ORDER BY [seq] ASC

    DROP TABLE [#TempLedger]
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetNotificationList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_GetNotificationList]

-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
BEGIN

    SELECT [tblClientMstr].[ClientName] AS [Client],
           [tblUnitReference].[ClientID] AS [ClientID],
           [tblUnitReference].[RefId] AS [ContractID],
           CONVERT(VARCHAR(15), [tblMonthLedger].[LedgMonth], 107) AS [ForMonth],
           CAST([tblMonthLedger].[LedgAmount] AS DECIMAL(18, 2)) AS [Amount],
           'HOLD' AS [Status]
    FROM [dbo].[tblUnitReference] WITH (NOLOCK)
        LEFT JOIN [dbo].[tblMonthLedger] WITH (NOLOCK)
            ON [tblUnitReference].[RecId] = [tblMonthLedger].[ReferenceID]
        INNER JOIN [dbo].[tblClientMstr] WITH (NOLOCK)
            ON [tblUnitReference].[ClientID] = [tblClientMstr].[ClientID]
    WHERE ISNULL([tblMonthLedger].[IsHold], 0) = 1
          AND CONVERT(VARCHAR(10), [tblMonthLedger].[LedgMonth], 103) > CONVERT(VARCHAR(10), GETDATE(), 103)
    UNION
    SELECT [tblClientMstr].[ClientName] AS [Client],
           [tblUnitReference].[ClientID] AS [ClientID],
           [tblUnitReference].[RefId] AS [ContractID],
           CONVERT(VARCHAR(15), [tblMonthLedger].[LedgMonth], 107) AS [ForMonth],
           CAST([tblMonthLedger].[LedgAmount] AS DECIMAL(18, 2)) AS [Amount],
           'DUE' AS [Status]
    FROM [dbo].[tblUnitReference] WITH (NOLOCK)
        LEFT JOIN [dbo].[tblMonthLedger] WITH (NOLOCK)
            ON [tblUnitReference].[RecId] = [tblMonthLedger].[ReferenceID]
        INNER JOIN [dbo].[tblClientMstr] WITH (NOLOCK)
            ON [tblUnitReference].[ClientID] = [tblClientMstr].[ClientID]
    WHERE (
              ISNULL([tblMonthLedger].[IsHold], 0) = 1
              AND ISNULL([tblMonthLedger].[IsPaid], 0) = 0
              AND CONVERT(VARCHAR(10), GETDATE(), 103) = CONVERT(VARCHAR(10), [tblMonthLedger].[LedgMonth], 103)
          )
          OR
          (
              ISNULL([tblMonthLedger].[IsHold], 0) = 0
              AND ISNULL([tblMonthLedger].[IsPaid], 0) = 0
              AND CONVERT(VARCHAR(10), GETDATE(), 103) = CONVERT(VARCHAR(10), [tblMonthLedger].[LedgMonth], 103)
          )
    --UNION
    --SELECT [tblClientMstr].[ClientName] AS [Client],
    --       [tblUnitReference].[ClientID] AS [ClientID],
    --       [tblUnitReference].[RefId] AS [ContractID],
    --       CONVERT(VARCHAR(15), [tblMonthLedger].[LedgMonth], 107) AS [ForMonth],
    --       CAST([tblMonthLedger].[LedgAmount] AS DECIMAL(18, 2)) AS [Amount],
    --       'FOR FOLLOW-UP' AS [Status]
    --FROM [dbo].[tblUnitReference] WITH (NOLOCK)
    --    LEFT JOIN [dbo].[tblMonthLedger] WITH (NOLOCK)
    --        ON [tblUnitReference].[RecId] = [tblMonthLedger].[ReferenceID]
    --    INNER JOIN [dbo].[tblClientMstr] WITH (NOLOCK)
    --        ON [tblUnitReference].[ClientID] = [tblClientMstr].[ClientID]
    --WHERE ISNULL([tblMonthLedger].[IsHold], 0) = 0
    --      AND ISNULL([tblMonthLedger].[IsPaid], 0) = 0
    --      AND DATEDIFF(DAY, CONVERT(DATE, GETDATE(), 103), CONVERT(DATE, [tblMonthLedger].[LedgMonth], 103)) < 7
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetParkingAvailableByProjectId]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetUnitAvailableByProjectId] @ProjectId = 1
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetParkingAvailableByProjectId] @ProjectId INT
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT
            [tblUnitMstr].[RecId],
            ISNULL([tblUnitMstr].[UnitNo], '') AS [UnitNo]
        FROM
            [dbo].[tblUnitMstr] WITH (NOLOCK)
        WHERE
            [tblUnitMstr].[ProjectId] = @ProjectId
            AND ISNULL([tblUnitMstr].[IsActive], 0) = 1
            AND [tblUnitMstr].[UnitStatus] = 'VACANT'
            AND ISNULL([tblUnitMstr].[IsParking], 0) = 1
        ORDER BY
            [tblUnitMstr].[UnitSequence] DESC;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetParkingComputationList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- UNION THE SELECT OF PARKING LIST LATER ON
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetParkingComputationList]
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT
                [tblUnitReference].[RecId],
                [tblUnitReference].[RefId],
                [tblUnitReference].[ProjectId],
                ISNULL([tblProjectMstr].[ProjectName], '')                                       AS [ProjectName],
                ISNULL([tblProjectMstr].[ProjectAddress], '')                                    AS [ProjectAddress],
                ISNULL([tblProjectMstr].[ProjectType], '')                                       AS [ProjectType],
                ISNULL([tblUnitReference].[InquiringClient], '')                                 AS [InquiringClient],
                ISNULL([tblUnitReference].[ClientMobile], '')                                    AS [ClientMobile],
                [tblUnitReference].[UnitId],
                ISNULL([tblUnitReference].[UnitNo], '')                                          AS [UnitNo],
                ISNULL([tblUnitMstr].[FloorType], '')                                            AS [FloorType],
                ISNULL(CONVERT(VARCHAR(20), [tblUnitReference].[StatDate], 107), '')             AS [StatDate],
                ISNULL(CONVERT(VARCHAR(20), [tblUnitReference].[FinishDate], 107), '')           AS [FinishDate],
                ISNULL(CONVERT(VARCHAR(20), [tblUnitReference].[TransactionDate], 107), '')      AS [TransactionDate],
                CAST(ISNULL([tblUnitReference].[Rental], 0) AS DECIMAL(10, 2))                   AS [Rental],
                CAST(ISNULL([tblUnitReference].[SecAndMaintenance], 0) AS DECIMAL(10, 2))        AS [SecAndMaintenance],
                CAST(ISNULL([tblUnitReference].[TotalRent], 0) AS DECIMAL(10, 2))                AS [TotalRent],
                CAST(ISNULL([tblUnitReference].[SecDeposit], 0) AS DECIMAL(10, 2))               AS [SecDeposit],
                CAST(ISNULL([tblUnitReference].[Total], 0) AS DECIMAL(10, 2))                    AS [Total],
                [tblUnitReference].[EncodedBy],
                [tblUnitReference].[EncodedDate],
                [tblUnitReference].[IsActive],
                [tblUnitReference].[ComputerName],
                IIF(ISNULL([tblUnitMstr].[IsParking], 0) = 1, 'TYPE OF PARKING', 'TYPE OF UNIT') AS [TypeOf]
        FROM
                [dbo].[tblUnitReference]
            INNER JOIN
                [dbo].[tblProjectMstr]
                    ON [tblUnitReference].[ProjectId] = [tblProjectMstr].[RecId]
            INNER JOIN
                [dbo].[tblUnitMstr]
                    ON [tblUnitMstr].[RecId] = [tblUnitReference].[UnitId]
        WHERE
                ISNULL([tblUnitReference].[IsPaid], 0) = 0
                AND ISNULL([tblUnitMstr].[IsParking], 0) = 1;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPaymentListByReferenceId]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPaymentListByReferenceId] @RefId VARCHAR(50) = NULL
AS
BEGIN

    SET NOCOUNT ON;


    SELECT [tblPayment].[RecId],
           [tblPayment].[PayID],
           [tblPayment].[TranId],
           [tblPayment].[Amount],
           ISNULL(CONVERT(VARCHAR(20), [tblPayment].[ForMonth], 107), '') AS [ForMonth],
           COALESCE([tblPayment].[Notes], [tblPayment].[Remarks]) AS [Remarks],
           [tblPayment].[EncodedBy],
           ISNULL(CONVERT(VARCHAR(20), [tblPayment].[EncodedDate], 107), '') AS [DatePayed],
           [tblPayment].[LastChangedBy],
           [tblPayment].[LastChangedDate],
           [tblPayment].[ComputerName],
           [tblPayment].[IsActive],
           [tblPayment].[RefId]
    FROM [dbo].[tblPayment]
    WHERE [tblPayment].[RefId] = @RefId
    ORDER BY [EncodedDate] ASC
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPenaltyResult]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_GetPenaltyResult] @LedgerId AS INT = NULL
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
BEGIN



    DECLARE @DateHold AS DATE = NULL;
    DECLARE @DayCount AS INT = 0;
    DECLARE @RefRecID AS INT = 0;

    SELECT @DateHold = [tblMonthLedger].[LedgMonth],
           @RefRecID = [tblMonthLedger].[ReferenceID]
    FROM [dbo].[tblMonthLedger]
    WHERE [tblMonthLedger].[Recid] = @LedgerId;
    SELECT @DayCount = DATEDIFF(DAY, @DateHold, CAST(GETDATE() AS DATE));

    IF @DayCount < 30
    BEGIN

        SELECT
            (
                SELECT [tblUnitReference].[TotalRent]
                FROM [dbo].[tblUnitReference]
                WHERE [tblUnitReference].[RecId] = @RefRecID
            ) AS [AmountToPay],
            0.00 AS [PenaltyAmount],
            @DayCount AS [DayCount],
            '(No Penalty)' AS [PenaltyStatus];
    END;
    ELSE IF @DayCount = 30
    BEGIN
        --return total rental plus 3 percent penalty
        SELECT
            (
                SELECT CAST([tblUnitReference].[TotalRent]
                            + (([tblUnitReference].[TotalRent] * [tblUnitReference].[PenaltyPct]) / 100) AS DECIMAL(18, 2))
                FROM [dbo].[tblUnitReference]
                WHERE [tblUnitReference].[RecId] = @RefRecID
            ) AS [AmountToPay],
            (
                SELECT CAST((([tblUnitReference].[TotalRent] * [tblUnitReference].[PenaltyPct]) / 100) AS DECIMAL(18, 2))
                FROM [dbo].[tblUnitReference]
                WHERE [tblUnitReference].[RecId] = @RefRecID
            ) AS [PenaltyAmount],
            @DayCount AS [DayCount],
            'With Penalty:(' + CAST(@DayCount AS VARCHAR(5)) + ') days' AS [PenaltyStatus];
    END;
    ELSE IF @DayCount >= 31 AND @DayCount <= 31
    BEGIN
        --return total rental plus 3 percent x2 penalty
        SELECT
            (
                SELECT CAST([tblUnitReference].[TotalRent]
                            + ((([tblUnitReference].[TotalRent] * [tblUnitReference].[PenaltyPct]) / 100) * 2) AS DECIMAL(18, 2))
                FROM [dbo].[tblUnitReference]
                WHERE [tblUnitReference].[RecId] = @RefRecID
            ) AS [AmountToPay],
            (
                SELECT CAST(((([tblUnitReference].[TotalRent] * [tblUnitReference].[PenaltyPct]) / 100) * 2) AS DECIMAL(18, 2))
                FROM [dbo].[tblUnitReference]
                WHERE [tblUnitReference].[RecId] = @RefRecID
            ) AS [PenaltyAmount],
            @DayCount AS [DayCount],
            'With Penalty x2:(' + CAST(@DayCount AS VARCHAR(5)) + ') days' AS [PenaltyStatus];
    END
    ELSE IF @DayCount = 60
    BEGIN
        --return total rental plus 3 percent x2 penalty
        SELECT
            (
                SELECT CAST([tblUnitReference].[TotalRent]
                            + ((([tblUnitReference].[TotalRent] * [tblUnitReference].[PenaltyPct]) / 100) * 3) AS DECIMAL(18, 2))
                FROM [dbo].[tblUnitReference]
                WHERE [tblUnitReference].[RecId] = @RefRecID
            ) AS [AmountToPay],
            (
                SELECT CAST(((([tblUnitReference].[TotalRent] * [tblUnitReference].[PenaltyPct]) / 100) * 3) AS DECIMAL(18, 2))
                FROM [dbo].[tblUnitReference]
                WHERE [tblUnitReference].[RecId] = @RefRecID
            ) AS [PenaltyAmount],
            @DayCount AS [DayCount],
            'With Penalty x3:(' + CAST(@DayCount AS VARCHAR(5)) + ') days' AS [PenaltyStatus];
    END
    ELSE IF @DayCount >= 61 
    BEGIN
        --return total rental plus 3 percent x2 penalty
        SELECT
            (
                SELECT CAST([tblUnitReference].[TotalRent]
                            + ((([tblUnitReference].[TotalRent] * [tblUnitReference].[PenaltyPct]) / 100) * 4) AS DECIMAL(18, 2))
                FROM [dbo].[tblUnitReference]
                WHERE [tblUnitReference].[RecId] = @RefRecID
            ) AS [AmountToPay],
            (
                SELECT CAST(((([tblUnitReference].[TotalRent] * [tblUnitReference].[PenaltyPct]) / 100) * 4) AS DECIMAL(18, 2))
                FROM [dbo].[tblUnitReference]
                WHERE [tblUnitReference].[RecId] = @RefRecID
            ) AS [PenaltyAmount],
            @DayCount AS [DayCount],
            'With Penalty x4:(' + CAST(@DayCount AS VARCHAR(5)) + ') days' AS [PenaltyStatus];
    END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPostDatedCountMonth]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_GetPostDatedCountMonth]
    -- Add the parameters for the stored procedure here
    @FromDate VARCHAR(10) = NULL,
    @EndDate VARCHAR(10) = NULL,
    @Rental VARCHAR(10) = NULL,
    @SecMainRental VARCHAR(10) = NULL,
    @XML XML
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    CREATE TABLE [#tblAdvancePayment]
    (
        [Months] VARCHAR(10)
    );
    IF (@XML IS NOT NULL)
    BEGIN
        INSERT INTO [#tblAdvancePayment]
        (
            [Months]
        )
        SELECT [ParaValues].[data].[value]('c1[1]', 'VARCHAR(10)')
        FROM @XML.[nodes]('/Table1') AS [ParaValues]([data]);
    END;

    -- Insert statements for procedure here

    DECLARE @MonthsCount INT = DATEDIFF(MONTH, CONVERT(DATE, @FromDate, 101), CONVERT(DATE, @EndDate, 101));

    CREATE TABLE [#GeneratedMonths]
    (
        [Month] DATE
    );
    WITH [MonthsCTE]
    AS (SELECT CONVERT(DATE, @FromDate) AS [Month]
        UNION ALL
        SELECT DATEADD(MONTH, 1, [MonthsCTE].[Month])
        FROM [MonthsCTE]
        WHERE DATEADD(MONTH, 1, [MonthsCTE].[Month]) <= DATEADD(MONTH, @MonthsCount - 1, CONVERT(DATE, @FromDate)))
    INSERT INTO [#GeneratedMonths]
    (
        [Month]
    )
    SELECT [MonthsCTE].[Month]
    FROM [MonthsCTE]
	option (maxrecursion 0);



    DELETE FROM [#GeneratedMonths]
    WHERE [#GeneratedMonths].[Month] IN
          (
              SELECT [#tblAdvancePayment].[Months] FROM [#tblAdvancePayment]
          );
    SELECT ROW_NUMBER() OVER (ORDER BY [#GeneratedMonths].[Month] ASC) [seq],
           CONVERT(VARCHAR(20), [#GeneratedMonths].[Month], 107) AS [Dates],
           @Rental AS [Rental],
           @SecMainRental AS [SecMainRental],
           CAST(@Rental AS DECIMAL(18, 2)) + CAST(@SecMainRental AS DECIMAL(18, 2)) AS [TotalRental]
    FROM [#GeneratedMonths];



    DROP TABLE [#GeneratedMonths];
    DROP TABLE [#tblAdvancePayment];
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPostDatedCountMonthParking]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_GetPostDatedCountMonthParking]
    @FromDate VARCHAR(10) = NULL,
    @EndDate VARCHAR(10) = NULL,
    @Rental VARCHAR(10) = NULL,
    @SecMainRental VARCHAR(10) = NULL,
	    @XML XML
AS
BEGIN

    SET NOCOUNT ON;
	
    CREATE TABLE [#tblAdvancePayment]
    (
        [Months] VARCHAR(10)
    );
    IF (@XML IS NOT NULL)
    BEGIN
        INSERT INTO [#tblAdvancePayment]
        (
            [Months]
        )
        SELECT [ParaValues].[data].[value]('c1[1]', 'VARCHAR(10)')
        FROM @XML.[nodes]('/Table1') AS [ParaValues]([data]);
    END;


    DECLARE @MonthsCount INT = DATEDIFF(MONTH, CONVERT(DATE, @FromDate, 101), CONVERT(DATE, @EndDate, 101));

    CREATE TABLE [#GeneratedMonths]
    (
        [Month] DATE
    );
    WITH [MonthsCTE]
    AS (SELECT CONVERT(DATE, @FromDate) AS [Month]
        UNION ALL
        SELECT DATEADD(MONTH, 1, [MonthsCTE].[Month])
        FROM [MonthsCTE]
        WHERE DATEADD(MONTH, 1, [MonthsCTE].[Month]) <= DATEADD(MONTH, @MonthsCount - 1, CONVERT(DATE, @FromDate)))
    INSERT INTO [#GeneratedMonths]
    (
        [Month]
    )
    SELECT [MonthsCTE].[Month]
    FROM [MonthsCTE]
	OPTION (maxrecursion 0);


	DELETE FROM [#GeneratedMonths]
    WHERE [#GeneratedMonths].[Month] IN
          (
              SELECT [#tblAdvancePayment].[Months] FROM [#tblAdvancePayment]
          );
    SELECT ROW_NUMBER() OVER (ORDER BY [#GeneratedMonths].[Month] ASC) [seq],
           CONVERT(VARCHAR(20), [#GeneratedMonths].[Month], 107) AS [Dates],
           @Rental AS [Rental],
           @SecMainRental AS [SecMainRental],
           CAST(@Rental AS DECIMAL(18, 2)) + CAST(@SecMainRental AS DECIMAL(18, 2)) AS [TotalRental]
    FROM [#GeneratedMonths];

     DROP TABLE [#GeneratedMonths];
    DROP TABLE [#tblAdvancePayment];
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPostDatedMonthList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_GetPostDatedMonthList]
    -- Add the parameters for the stored procedure here
    @FromDate VARCHAR(10) = NULL,
    @EndDate  VARCHAR(10) = NULL,
    --@Rental   VARCHAR(10) = NULL,
    @XML      XML
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        CREATE TABLE [#tblAdvancePayment]
            (
                [Months] VARCHAR(10)
            );
        IF (@XML IS NOT NULL)
            BEGIN
                INSERT INTO [#tblAdvancePayment]
                    (
                        [Months]
                    )
                            SELECT
                                [ParaValues].[data].[value]('c1[1]', 'VARCHAR(10)')
                            FROM
                                @XML.[nodes]('/Table1') AS [ParaValues]([data]);
            END;

        -- Insert statements for procedure here

        DECLARE @MonthsCount INT = DATEDIFF(MONTH, CONVERT(DATE, @FromDate, 101), CONVERT(DATE, @EndDate, 101));

        CREATE TABLE [#GeneratedMonths]
            (
                [Month] DATE
            );
        WITH [MonthsCTE]
        AS (   SELECT
                   CONVERT(DATE, @FromDate) AS [Month]
               UNION ALL
               SELECT
                   DATEADD(MONTH, 1, [MonthsCTE].[Month])
               FROM
                   [MonthsCTE]
               WHERE
                   DATEADD(MONTH, 1, [MonthsCTE].[Month]) <= DATEADD(MONTH, @MonthsCount - 1, CONVERT(DATE, @FromDate)))
        INSERT INTO [#GeneratedMonths]
            (
                [Month]
            )
                    SELECT
                        [MonthsCTE].[Month]
                    FROM
                        [MonthsCTE]
        OPTION (MAXRECURSION 0);



        DELETE FROM
        [#GeneratedMonths]
        WHERE
            [#GeneratedMonths].[Month] IN
                (
                    SELECT
                        [#tblAdvancePayment].[Months]
                    FROM
                        [#tblAdvancePayment]
                );
        SELECT
            ROW_NUMBER() OVER (ORDER BY
                                   [#GeneratedMonths].[Month] ASC
                              )                                   [seq],
            CONVERT(VARCHAR(20), [#GeneratedMonths].[Month], 107) AS [Dates]
        FROM
            [#GeneratedMonths];



        DROP TABLE [#GeneratedMonths];
        DROP TABLE [#tblAdvancePayment];
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProjectById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetProjectById] @RecId INT
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT
                [tblProjectMstr].[RecId],
                [tblProjectMstr].[ProjectType],
                [tblProjectMstr].[ProjectName],
                [tblProjectMstr].[Descriptions],
                [tblProjectMstr].[ProjectAddress],
                ISNULL([tblProjectMstr].[IsActive], 0) AS [IsActive],
                [tblLocationMstr].[Descriptions]       AS [LocationName],
                [tblLocationMstr].[RecId]              AS [LocationId]
        FROM
                [dbo].[tblProjectMstr]
            INNER JOIN
                [dbo].[tblLocationMstr]
                    ON [tblLocationMstr].[RecId] = [tblProjectMstr].[LocId]
        WHERE
                [tblProjectMstr].[RecId] = @RecId;
    END;

    --SELECT
    --    [tblProjectMstr].[RecId],
    --    [tblProjectMstr].[LocId],
    --    [tblProjectMstr].[ProjectName],
    --    [tblProjectMstr].[Descriptions],
    --    [tblProjectMstr].[IsActive],
    --    [tblProjectMstr].[ProjectAddress],
    --    [tblProjectMstr].[ProjectType]
    --FROM
    --    [dbo].[tblProjectMstr];
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProjectList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetProjectList]
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
        SELECT
                [tblProjectMstr].[RecId],
                [tblProjectMstr].[LocId],
                [tblProjectMstr].[ProjectAddress],
                [tblLocationMstr].[Descriptions]                                       AS [LocationName],
                [tblProjectMstr].[ProjectName],
                [tblProjectMstr].[Descriptions],
                IIF(ISNULL([tblProjectMstr].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE') AS [IsActive]
        FROM
                [dbo].[tblProjectMstr]
            INNER JOIN
                [dbo].[tblLocationMstr]
                    ON [tblLocationMstr].[RecId] = [tblProjectMstr].[LocId]
        WHERE
                ISNULL([tblProjectMstr].[IsActive], 0) = 1;

    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProjectStatusCount]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_GetProjectStatusCount]
    @ProjectId AS INT         = NULL,
    @UnitStatus   VARCHAR(15) = NULL,
    @ProjStatus   VARCHAR(15) = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        IF @ProjectId = 0
           AND @ProjStatus = '--ALL--'
           AND
               (
                   @UnitStatus = ''
                   OR @UnitStatus = '--ALL--'
               )
            BEGIN
                SELECT
                    (
                        SELECT
                            COUNT(*)
                        FROM
                            [dbo].[tblUnitMstr]
                        WHERE
                            --[tblUnitMstr].[ProjectId] = @ProjectId
                            ISNULL([tblUnitMstr].[UnitStatus], '') = 'VACANT'
                    ) AS [VACANT_COUNT],
                    (
                        SELECT
                            COUNT(*)
                        FROM
                            [dbo].[tblUnitMstr]
                        WHERE
                            --[tblUnitMstr].[ProjectId] = @ProjectId
                            ISNULL([tblUnitMstr].[UnitStatus], '') = 'MOVE-IN'
                    ) AS [OCCUPIED_COUNT],
                    (
                        SELECT
                            COUNT(*)
                        FROM
                            [dbo].[tblUnitMstr]
                        WHERE
                            --[tblUnitMstr].[ProjectId] = @ProjectId
                            ISNULL([tblUnitMstr].[UnitStatus], '') = 'RESERVED'
                    ) AS [RESERVED_COUNT],
                    (
                        SELECT
                            COUNT(*)
                        FROM
                            [dbo].[tblUnitMstr]
                        WHERE
                            --[tblUnitMstr].[ProjectId] = @ProjectId
                            ISNULL([tblUnitMstr].[UnitStatus], '') = 'NOT AVAILABLE'
                    ) AS [NOT_AVAILABLE_COUNT],
                    (
                        SELECT
                            COUNT(*)
                        FROM
                            [dbo].[tblUnitMstr]
                        WHERE
                            --[tblUnitMstr].[ProjectId] = @ProjectId
                            ISNULL([tblUnitMstr].[UnitStatus], '') = 'HOLD'
                    ) AS [HOLD_COUNT]
            END
        ELSE IF @ProjectId = 0
                AND @ProjStatus = '--ALL--'
                AND @UnitStatus <> '--ALL--'
            BEGIN
                SELECT
                    IIF(@UnitStatus = 'VACANT',
                        (
                            SELECT
                                COUNT(*)
                            FROM
                                [dbo].[tblUnitMstr]
                            WHERE
                                --[tblUnitMstr].[ProjectId] = @ProjectId
                                ISNULL([tblUnitMstr].[UnitStatus], '') = 'VACANT'
                        ),
                        0) AS [VACANT_COUNT],
                    IIF(@UnitStatus = 'MOVE-IN',
                        (
                            SELECT
                                COUNT(*)
                            FROM
                                [dbo].[tblUnitMstr]
                            WHERE
                                --[tblUnitMstr].[ProjectId] = @ProjectId
                                ISNULL([tblUnitMstr].[UnitStatus], '') = 'MOVE-IN'
                        ),
                        0) AS [OCCUPIED_COUNT],
                    IIF(@UnitStatus = 'RESERVED',
                        (
                            SELECT
                                COUNT(*)
                            FROM
                                [dbo].[tblUnitMstr]
                            WHERE
                                --[tblUnitMstr].[ProjectId] = @ProjectId
                                ISNULL([tblUnitMstr].[UnitStatus], '') = 'RESERVED'
                        ),
                        0) AS [RESERVED_COUNT],
                    IIF(@UnitStatus = 'NOT AVAILABLE',
                        (
                            SELECT
                                COUNT(*)
                            FROM
                                [dbo].[tblUnitMstr]
                            WHERE
                                --[tblUnitMstr].[ProjectId] = @ProjectId
                                ISNULL([tblUnitMstr].[UnitStatus], '') = 'NOT AVAILABLE'
                        ),
                        0) AS [NOT_AVAILABLE_COUNT],
                    IIF(@UnitStatus = 'HOLD',
                        (
                            SELECT
                                COUNT(*)
                            FROM
                                [dbo].[tblUnitMstr]
                            WHERE
                                --[tblUnitMstr].[ProjectId] = @ProjectId
                                ISNULL([tblUnitMstr].[UnitStatus], '') = 'HOLD'
                        ),
                        0) AS [HOLD_COUNT]
            END
        ELSE IF @ProjectId > 0
                AND @ProjStatus <> '--ALL--'
                AND
                    (
                        @UnitStatus = ''
                        OR @UnitStatus = '--ALL--'
                    )
            BEGIN
                SELECT
                    (
                        SELECT
                            COUNT(*)
                        FROM
                            [dbo].[tblUnitMstr]
                        WHERE
                            [tblUnitMstr].[ProjectId] = @ProjectId
                            AND ISNULL([tblUnitMstr].[UnitStatus], '') = 'VACANT'
                    ) AS [VACANT_COUNT],
                    (
                        SELECT
                            COUNT(*)
                        FROM
                            [dbo].[tblUnitMstr]
                        WHERE
                            [tblUnitMstr].[ProjectId] = @ProjectId
                            AND ISNULL([tblUnitMstr].[UnitStatus], '') = 'MOVE-IN'
                    ) AS [OCCUPIED_COUNT],
                    (
                        SELECT
                            COUNT(*)
                        FROM
                            [dbo].[tblUnitMstr]
                        WHERE
                            [tblUnitMstr].[ProjectId] = @ProjectId
                            AND ISNULL([tblUnitMstr].[UnitStatus], '') = 'RESERVED'
                    ) AS [RESERVED_COUNT],
                    (
                        SELECT
                            COUNT(*)
                        FROM
                            [dbo].[tblUnitMstr]
                        WHERE
                            [tblUnitMstr].[ProjectId] = @ProjectId
                            AND ISNULL([tblUnitMstr].[UnitStatus], '') = 'NOT AVAILABLE'
                    ) AS [NOT_AVAILABLE_COUNT],
                    (
                        SELECT
                            COUNT(*)
                        FROM
                            [dbo].[tblUnitMstr]
                        WHERE
                            [tblUnitMstr].[ProjectId] = @ProjectId
                            AND ISNULL([tblUnitMstr].[UnitStatus], '') = 'HOLD'
                    ) AS [HOLD_COUNT]
            END
        ELSE IF @ProjectId > 0
                AND @ProjStatus <> '--ALL--'
                AND
                    (
                        @UnitStatus <> ''
                        OR @UnitStatus <> '--ALL--'
                    )
            BEGIN
                SELECT
                    IIF(@UnitStatus = 'VACANT',
                        (
                            SELECT
                                COUNT(*)
                            FROM
                                [dbo].[tblUnitMstr]
                            WHERE
                                [tblUnitMstr].[ProjectId] = @ProjectId
                                AND ISNULL([tblUnitMstr].[UnitStatus], '') = 'VACANT'
                        ),
                        0) AS [VACANT_COUNT],
                    IIF(@UnitStatus = 'MOVE-IN',
                        (
                            SELECT
                                COUNT(*)
                            FROM
                                [dbo].[tblUnitMstr]
                            WHERE
                                [tblUnitMstr].[ProjectId] = @ProjectId
                                AND ISNULL([tblUnitMstr].[UnitStatus], '') = 'MOVE-IN'
                        ),
                        0) AS [OCCUPIED_COUNT],
                    IIF(@UnitStatus = 'RESERVED',
                        (
                            SELECT
                                COUNT(*)
                            FROM
                                [dbo].[tblUnitMstr]
                            WHERE
                                [tblUnitMstr].[ProjectId] = @ProjectId
                                AND ISNULL([tblUnitMstr].[UnitStatus], '') = 'RESERVED'
                        ),
                        0) AS [RESERVED_COUNT],
                    IIF(@UnitStatus = 'NOT AVAILABLE',
                        (
                            SELECT
                                COUNT(*)
                            FROM
                                [dbo].[tblUnitMstr]
                            WHERE
                                [tblUnitMstr].[ProjectId] = @ProjectId
                                AND ISNULL([tblUnitMstr].[UnitStatus], '') = 'NOT AVAILABLE'
                        ),
                        0) AS [NOT_AVAILABLE_COUNT],
                    IIF(@UnitStatus = 'HOLD',
                        (
                            SELECT
                                COUNT(*)
                            FROM
                                [dbo].[tblUnitMstr]
                            WHERE
                                [tblUnitMstr].[ProjectId] = @ProjectId
                                AND ISNULL([tblUnitMstr].[UnitStatus], '') = 'HOLD'
                        ),
                        0) AS [HOLD_COUNT]
            END

    END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProjectTypeById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetProjectTypeById] @RecId INT = NULL
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here

        SELECT
            [tblProjectMstr].[ProjectType]
        FROM
            [dbo].[tblProjectMstr]
        WHERE
            [tblProjectMstr].[RecId] = @RecId
            AND ISNULL([tblProjectMstr].[IsActive], 0) = 1;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPurchaseItemById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC sp_GetPurchaseItemById @RecId = 1002
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPurchaseItemById] @RecId INT
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT
                [tblProjPurchItem].[RecId],
                [tblProjPurchItem].[PurchItemID],
                [tblProjPurchItem].[ProjectId],
                [tblProjectMstr].[ProjectName],
                [tblProjectMstr].[ProjectAddress],
                ISNULL([tblProjPurchItem].[Descriptions], '')                               AS [Descriptions],
                ISNULL(CONVERT(VARCHAR(10), [tblProjPurchItem].[DatePurchase], 103), '')    AS [DatePurchase],
                CAST(ISNULL([tblProjPurchItem].[UnitAmount], 0) AS DECIMAL(10, 2))          AS [UnitAmount],
                CAST(ISNULL([tblProjPurchItem].[Amount], 0) AS DECIMAL(10, 2))              AS [Amount],
                ISNULL([tblProjPurchItem].[Remarks], '')                                    AS [Remarks],
                IIF(ISNULL([tblProjPurchItem].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE')    AS [IsActive],
                ISNULL([tblProjPurchItem].[EncodedBy], 0)                                   AS [EncodedBy],
                ISNULL(CONVERT(VARCHAR(10), [tblProjPurchItem].[EncodedDate], 103), '')     AS [EncodedDate],
                ISNULL([tblProjPurchItem].[LastChangedBy], 0)                               AS [LastChangedBy],
                ISNULL(CONVERT(VARCHAR(10), [tblProjPurchItem].[LastChangedDate], 103), '') AS [LastChangedDate],
                ISNULL([tblProjPurchItem].[ComputerName], '')                               AS [ComputerName]
        FROM
                [dbo].[tblProjPurchItem]
            LEFT JOIN
                [dbo].[tblProjectMstr]
                    ON [tblProjectMstr].[RecId] = [tblProjPurchItem].[ProjectId]
        WHERE
                [tblProjPurchItem].[ProjectId] = @RecId;



    END;

GO
/****** Object:  StoredProcedure [dbo].[sp_GetPurchaseItemInfoById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC sp_GetPurchaseItemInfoById @RecId = 2
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPurchaseItemInfoById] @RecId INT
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT
                [tblProjPurchItem].[RecId],
                [tblProjPurchItem].[PurchItemID],
                [tblProjPurchItem].[ProjectId],
                [tblProjectMstr].[ProjectName],
                [tblProjectMstr].[ProjectAddress],
                ISNULL([tblProjPurchItem].[Descriptions], '')                               AS [Descriptions],
                ISNULL(CONVERT(VARCHAR(10), [tblProjPurchItem].[DatePurchase], 1), '')      AS [DatePurchase],
                ISNULL([tblProjPurchItem].[UnitAmount], 0)                                  AS [UnitAmount],
                CAST(ISNULL([tblProjPurchItem].[Amount], 0) AS DECIMAL(10, 2))              AS [Amount],
                CAST(ISNULL([tblProjPurchItem].[TotalAmount], 0) AS DECIMAL(10, 2))         AS [TotalAmount],
                ISNULL([tblProjPurchItem].[Remarks], '')                                    AS [Remarks],
                IIF(ISNULL([tblProjPurchItem].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE')    AS [IsActive],
                ISNULL([tblProjPurchItem].[EncodedBy], 0)                                   AS [EncodedBy],
                IIF(ISNULL([tblProjPurchItem].[EncodedBy], 0) = 1, 'ADMINISTRATOR', '')     AS [EncodedName],
                ISNULL(CONVERT(VARCHAR(10), [tblProjPurchItem].[EncodedDate], 1), '')       AS [EncodedDate],
                ISNULL([tblProjPurchItem].[LastChangedBy], 0)                               AS [LastChangedBy],
                IIF(ISNULL([tblProjPurchItem].[LastChangedBy], 0) = 1, 'ADMINISTRATOR', '') AS [LastChangedName],
                ISNULL(CONVERT(VARCHAR(10), [tblProjPurchItem].[LastChangedDate], 1), '')   AS [LastChangedDate],
                ISNULL([tblProjPurchItem].[ComputerName], '')                               AS [ComputerName],
                ISNULL([tblProjPurchItem].[UnitNumber], '')                                 AS [UnitNumber],
                ISNULL([tblProjPurchItem].[UnitID], 0)                                      AS [UnitID]
        FROM
                [dbo].[tblProjPurchItem]
            LEFT JOIN
                [dbo].[tblProjectMstr]
                    ON [tblProjectMstr].[RecId] = [tblProjPurchItem].[ProjectId]
        WHERE
                [tblProjPurchItem].[RecId] = @RecId;



    END;

GO
/****** Object:  StoredProcedure [dbo].[sp_GetPurchaseItemList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPurchaseItemList]
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT
                [tblProjPurchItem].[RecId],
                [tblProjPurchItem].[PurchItemID],
                [tblProjPurchItem].[ProjectId],
                [tblProjectMstr].[ProjectName],
                [tblProjectMstr].[ProjectAddress],
                ISNULL([tblProjPurchItem].[Descriptions], '')                               AS [Descriptions],
                ISNULL(CONVERT(VARCHAR(10), [tblProjPurchItem].[DatePurchase], 103), '')    AS [DatePurchase],
                ISNULL([tblProjPurchItem].[UnitAmount], 0)                                  AS [UnitAmount],
                CAST(ISNULL([tblProjPurchItem].[Amount], 0) AS DECIMAL(10, 2))              AS [Amount],
                CAST(ISNULL([tblProjPurchItem].[TotalAmount], 0) AS DECIMAL(10, 2))         AS [TotalAmount],
                ISNULL([tblProjPurchItem].[Remarks], '')                                    AS [Remarks],
                IIF(ISNULL([tblProjPurchItem].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE')    AS [IsActive],
                ISNULL([tblProjPurchItem].[EncodedBy], 0)                                   AS [EncodedBy],
                ISNULL(CONVERT(VARCHAR(10), [tblProjPurchItem].[EncodedDate], 103), '')     AS [EncodedDate],
                ISNULL([tblProjPurchItem].[LastChangedBy], 0)                               AS [LastChangedBy],
                ISNULL(CONVERT(VARCHAR(10), [tblProjPurchItem].[LastChangedDate], 103), '') AS [LastChangedDate],
                ISNULL([tblProjPurchItem].[ComputerName], '')                               AS [ComputerName]
        FROM
                [dbo].[tblProjPurchItem]
            INNER JOIN
                [dbo].[tblProjectMstr]
                    ON [tblProjectMstr].[RecId] = [tblProjPurchItem].[ProjectId]
        WHERE
                ISNULL([tblProjPurchItem].[IsActive], 0) = 1
        ORDER BY
                [EncodedDate] DESC;



    END;

GO
/****** Object:  StoredProcedure [dbo].[sp_GetRateSettingsByType]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetRateSettingsByType] @ProjectType VARCHAR(20) = NULL
AS
BEGIN

    SET NOCOUNT ON;
    DECLARE @BaseWithVatAmount DECIMAL(18, 2) = 0;


    SELECT @BaseWithVatAmount
        = CAST(ISNULL([tblRatesSettings].[SecurityAndMaintenance], 0)
               + (((ISNULL([tblRatesSettings].[SecurityAndMaintenance], 0) * ISNULL([tblRatesSettings].[GenVat], 0))
                   / 100
                  )
                 ) AS DECIMAL(18, 2))
    FROM [dbo].[tblRatesSettings] WITH (NOLOCK)
    WHERE [tblRatesSettings].[ProjectType] = @ProjectType;


    SELECT [tblRatesSettings].[ProjectType],
           ISNULL([tblRatesSettings].[GenVat], 0) AS [GenVat],
           CAST(ISNULL([tblRatesSettings].[SecurityAndMaintenance], 0)
                + (((ISNULL([tblRatesSettings].[SecurityAndMaintenance], 0) * ISNULL([tblRatesSettings].[GenVat], 0))
                    / 100
                   )
                  ) AS DECIMAL(18, 2)) AS [SecurityAndMaintenance],
				  --- ((@BaseWithVatAmount * ISNULL([tblRatesSettings].[WithHoldingTax], 0)) / 100)
           ISNULL([tblRatesSettings].[SecurityAndMaintenanceVat], 0) AS [SecurityAndMaintenanceVat],
           ISNULL([tblRatesSettings].[IsSecAndMaintVat], 0) AS [IsSecAndMaintVat],
           ISNULL([tblRatesSettings].[WithHoldingTax], 0) AS [WithHoldingTax],
           ISNULL([tblRatesSettings].[PenaltyPct], 0) AS [PenaltyPct],
           ISNULL([tblRatesSettings].[EncodedBy], 0) AS [EncodedBy],
           ISNULL([tblRatesSettings].[EncodedDate], '1900-01-01') AS [EncodedDate],
           ISNULL([tblRatesSettings].[ComputerName], '') AS [ComputerName],
           IIF(ISNULL([tblRatesSettings].[GenVat], 0) > 0, 'INCLUSIVE OF VAT', 'EXCLUSIVE OF VAT') AS [labelVat]
    FROM [dbo].[tblRatesSettings] WITH (NOLOCK)
    WHERE [tblRatesSettings].[ProjectType] = @ProjectType;

END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetReceiptByRefId]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE   PROCEDURE [dbo].[sp_GetReceiptByRefId] @RefId AS VARCHAR(50) = NULL
AS
    BEGIN
        SET NOCOUNT ON;

        --SELECT [tblTransaction].[RefId],
        --       [tblTransaction].[TranID],
        --       [tblReceipt].[RcptID],
        --       --[tblPayment].[PayID],
        --       [tblTransaction].[ReceiveAmount] AS [PaidAmount],
        --       CONVERT(VARCHAR(10), [tblTransaction].[EncodedDate], 101) AS [PayDate],
        --       ISNULL([tblReceipt].[CompanyORNo], '') AS [CompanyORNo],
        --       [tblReceipt].[BankAccountName],
        --       [tblReceipt].[BankAccountNumber],
        --       [tblReceipt].[BankName],
        --       [tblReceipt].[SerialNo],
        --       [tblReceipt].[REF],
        --       ISNULL([tblReceipt].[CompanyPRNo], '') AS [CompanyPRNo]
        --FROM [dbo].[tblTransaction]
        --    INNER JOIN [dbo].[tblReceipt]
        --        ON [tblTransaction].[TranID] = [tblReceipt].[TranId]
        --WHERE [tblTransaction].[RefId] = @RefId
        --UNION
        SELECT
                [tblTransaction].[RefId],
                [tblTransaction].[TranID],
                [tblReceipt].[RcptID],
                --[tblPayment].[PayID],
                [tblTransaction].[ReceiveAmount]                                  AS [PaidAmount],
                CONVERT(VARCHAR(10), [tblTransaction].[EncodedDate], 101)         AS [PayDate],
                ISNULL([tblReceipt].[CompanyORNo], '')                            AS [CompanyORNo],
                [tblReceipt].[BankAccountName],
                [tblReceipt].[BankAccountNumber],
                [tblReceipt].[BankName],
                [tblReceipt].[SerialNo],
                [tblReceipt].[REF],
                [tblReceipt].[BankBranch],
                ISNULL(CONVERT(VARCHAR(10), [tblReceipt].[ReceiptDate], 101), '') AS [ReceiptDate],
                ISNULL([tblReceipt].[CompanyPRNo], '')                            AS [CompanyPRNo],
                [tblReceipt].[BankBranch]                                         AS [BankBranch],
                [tblReceipt].[Description]
        FROM
                [dbo].[tblTransaction]
            --    OUTER APPLY
            --(
            --    SELECT SUM([tblPayment].[Amount]) AS [Amount],
            --           [tblPayment].[TranId],
            --           [tblPayment].[EncodedDate]
            --    FROM [dbo].[tblPayment]
            --    WHERE [tblTransaction].[TranID] = [tblPayment].[TranId]
            --    GROUP BY [tblPayment].[TranId],
            --             [tblPayment].[EncodedDate]
            --) [PAYMENT]
            INNER JOIN
                [dbo].[tblReceipt]
                    ON [tblTransaction].[TranID] = [tblReceipt].[TranId]
        WHERE
                [tblTransaction].[RefId] = @RefId
        ORDER BY
                [tblTransaction].[EncodedDate]

    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetReferenceByClientID]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetReferenceByClientID] 'INDV10000002'
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetReferenceByClientID]
    -- Add the parameters for the stored procedure here
    @ClientID VARCHAR(50) = NULL
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
        SELECT
            [tblUnitReference].[RecId],
            [tblUnitReference].[RefId],
            [tblUnitReference].[ProjectId],
            [tblUnitReference].[InquiringClient],
            [tblUnitReference].[ClientMobile],
            [tblUnitReference].[UnitId],
            [tblUnitReference].[UnitNo],
            [tblUnitReference].[StatDate],
            [tblUnitReference].[FinishDate],
            [tblUnitReference].[TransactionDate],
            [tblUnitReference].[Rental],
            [tblUnitReference].[SecAndMaintenance],
            [tblUnitReference].[TotalRent],
            [tblUnitReference].[AdvancePaymentAmount],
            [tblUnitReference].[SecDeposit],
            [tblUnitReference].[Total],
            [tblUnitReference].[EncodedBy],
            [tblUnitReference].[EncodedDate],
            [tblUnitReference].[LastCHangedBy],
            [tblUnitReference].[LastChangedDate],
            [tblUnitReference].[IsActive],
            [tblUnitReference].[ComputerName],
            [tblUnitReference].[ClientID],
            [tblUnitReference].[IsPaid],
            [tblUnitReference].[IsDone],
            [tblUnitReference].[HeaderRefId],
            [tblUnitReference].[IsSignedContract],
            [tblUnitReference].[IsUnitMove],
            CASE
                --when ISNULL(IsSignedContract, 0) = 1  and ISNULL(IsUnitMove, 0) = 0 and  ISNULL(IsDone, 0) = 0 and  ISNULL(IsTerminated, 0) = 0 then
                --    'CONTRACT SIGNED'
                --when ISNULL(IsUnitMove, 0) = 1 and ISNULL(IsSignedContract, 0) = 1  and  ISNULL(IsDone, 0) = 0 and  ISNULL(IsTerminated, 0) = 0 then
                --    'MOVE-IN'
                WHEN ISNULL([tblUnitReference].[IsDone], 0) = 1
                     AND ISNULL([tblUnitReference].[IsTerminated], 0) = 0
                    THEN
                    'CONTRACT DONE'
                WHEN ISNULL([tblUnitReference].[IsTerminated], 0) = 1
                     AND ISNULL([tblUnitReference].[IsDone], 0) = 1
                    THEN
                    'CONTRACT TERMINATED'
                ELSE
                    'ON-GOING'
            END                 AS [CLientReferenceStatus],
            IIF(
                ISNULL([tblUnitReference].[AdvancePaymentAmount], 0) = 0
                AND ISNULL([tblUnitReference].[SecDeposit], 0) = 0,
                'TYPE OF PARKING',
                'TYPE OF UNIT') AS [TypeOf]
        FROM
            [dbo].[tblUnitReference]
        WHERE
            [tblUnitReference].[ClientID] = @ClientID;
    --and ISNULL(IsPaid, 0) = 1
    --and ISNULL(IsTerminated, 0) = 0
    --and ISNULL(IsDone, 0) = 0
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetReferenceByClientIDpaid]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetReferenceByClientID] 'INDV10000002'
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetReferenceByClientIDpaid]
    -- Add the parameters for the stored procedure here
    @ClientID VARCHAR(50) = NULL
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
        SELECT
            [tblUnitReference].[RecId],
            [tblUnitReference].[RefId],
            [tblUnitReference].[ProjectId],
            [tblUnitReference].[InquiringClient],
            [tblUnitReference].[ClientMobile],
            [tblUnitReference].[UnitId],
            [tblUnitReference].[UnitNo],
            [tblUnitReference].[StatDate],
            [tblUnitReference].[FinishDate],
            CONVERT(VARCHAR(20), [tblUnitReference].[TransactionDate], 107) as [TransactionDate],
            [tblUnitReference].[Rental],
            [tblUnitReference].[SecAndMaintenance],
            [tblUnitReference].[TotalRent],
            [tblUnitReference].[AdvancePaymentAmount],
            [tblUnitReference].[SecDeposit],
            [tblUnitReference].[Total],
            [tblUnitReference].[EncodedBy],
            [tblUnitReference].[EncodedDate],
            [tblUnitReference].[LastCHangedBy],
            [tblUnitReference].[LastChangedDate],
            [tblUnitReference].[IsActive],
            [tblUnitReference].[ComputerName],
            [tblUnitReference].[ClientID],
            [tblUnitReference].[IsPaid],
            [tblUnitReference].[IsDone],
            [tblUnitReference].[HeaderRefId],
            [tblUnitReference].[IsSignedContract],
            [tblUnitReference].[IsUnitMove],
            [tblUnitReference].[IsUnitMoveOut],
            CASE
                WHEN ISNULL([tblUnitReference].[IsDone], 0) = 1
                     AND ISNULL([tblUnitReference].[IsTerminated], 0) = 0
                    THEN
                    'CONTRACT DONE'
                WHEN ISNULL([tblUnitReference].[IsTerminated], 0) = 1
                     AND ISNULL([tblUnitReference].[IsDone], 0) = 1
                    THEN
                    'CONTRACT TERMINATED'
                ELSE
                    'ON-GOING'
            END                                                                                                       AS [CLientReferenceStatus],
            IIF(ISNULL([tblUnitReference].[SecDeposit], 0) = 0, 'TYPE OF PARKING', 'TYPE OF UNIT') AS [TypeOf]
        FROM
            [dbo].[tblUnitReference]
        WHERE
            [tblUnitReference].[ClientID] = @ClientID
            AND ISNULL([tblUnitReference].[IsSignedContract], 0) = 1
            AND ISNULL([tblUnitReference].[IsUnitMove], 0) = 1
            AND ISNULL([tblUnitReference].[IsTerminated], 0) = 0
            AND ISNULL([tblUnitReference].[IsDone], 0) = 0
            AND ISNULL([tblUnitReference].[IsUnitMoveOut], 0) = 0
            AND ISNULL([tblUnitReference].[IsPaid], 0) = 1;

    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetRESIDENTIALSettings]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetRESIDENTIALSettings]
AS
BEGIN

    SET NOCOUNT ON;


    SELECT [tblRatesSettings].[ProjectType],
           ISNULL([tblRatesSettings].[GenVat], 0) AS [GenVat],
           ISNULL([tblRatesSettings].[SecurityAndMaintenance], 0) AS [SecurityAndMaintenance],
           ISNULL([tblRatesSettings].[WithHoldingTax], 0) AS [WithHoldingTax],
           ISNULL([tblRatesSettings].[PenaltyPct], 0) AS [PenaltyPct],
           [tblRatesSettings].[EncodedBy],
           [tblRatesSettings].[EncodedDate],
           [tblRatesSettings].[ComputerName]
    FROM [dbo].[tblRatesSettings]
    WHERE [tblRatesSettings].[ProjectType] = 'RESIDENTIAL';

END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSelecClient]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetSelecClient]
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;
        SELECT
            -1           AS [RecId],
            '--SELECT--' AS [ClientName]
        UNION
        SELECT
            [tblClientMstr].[RecId],
            ISNULL([tblClientMstr].[ClientName], '') AS [ClientName]
        FROM
            [dbo].[tblClientMstr] WITH (NOLOCK)
        WHERE
            ISNULL([tblClientMstr].[IsMap], 0) = 0;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSelectCompany]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_GetSelectCompany]
AS
BEGIN

    SELECT -1 AS [RecId],
           '--SELECT--' AS [CompanyName]
    UNION
    SELECT [tblCompany].[RecId],
           [tblCompany].[CompanyName]
    FROM [dbo].[tblCompany]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetTotalCountLabel]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_GetTotalCountLabel]

-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
BEGIN

    SELECT
        (
            SELECT COUNT(*)FROM [dbo].[tblLocationMstr]
       ) AS [TotalLocation],
        (
            SELECT COUNT(*)FROM [dbo].[tblProjectMstr]
        ) AS [TotalProject],
        (
            SELECT COUNT(*)FROM [dbo].[tblClientMstr]
        ) AS [TotalClient],
        (
            SELECT COUNT(*)
            FROM [dbo].[tblUnitReference]
            WHERE ISNULL([tblUnitReference].[IsDone], 0) = 0
        ) AS [TotalActiveContract];
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUnitAvailableById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetUnitAvailableById] 1
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUnitAvailableById] @UnitNo INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    --DECLARE @BaseWithVatAmount DECIMAL(18, 2) = 0;
    --DECLARE @OrignalAmount DECIMAL(18, 2) = 0;


    --SELECT @BaseWithVatAmount
    --    = CAST(ISNULL([tblUnitMstr].[BaseRental], 0)
    --           + (((ISNULL([tblUnitMstr].[BaseRental], 0) * ISNULL([tblRatesSettings].[GenVat], 0)) / 100)) AS DECIMAL(18, 2))
    --FROM [dbo].[tblUnitMstr] WITH (NOLOCK)
    --    LEFT JOIN [dbo].[tblProjectMstr] WITH (NOLOCK)
    --        ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
    --    LEFT JOIN [dbo].[tblRatesSettings] WITH (NOLOCK)
    --        ON [tblProjectMstr].[ProjectType] = [tblRatesSettings].[ProjectType]
    --WHERE [tblUnitMstr].[RecId] = @UnitNo
    --      AND ISNULL([tblUnitMstr].[IsActive], 0) = 1
    --      AND [tblUnitMstr].[UnitStatus] = 'VACANT';

    --SELECT @OrignalAmount = ISNULL([tblUnitMstr].[BaseRental], 0)
    --FROM [dbo].[tblUnitMstr] WITH (NOLOCK)
    --    LEFT JOIN [dbo].[tblProjectMstr] WITH (NOLOCK)
    --        ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
    --    LEFT JOIN [dbo].[tblRatesSettings] WITH (NOLOCK)
    --        ON [tblProjectMstr].[ProjectType] = [tblRatesSettings].[ProjectType]
    --WHERE [tblUnitMstr].[RecId] = @UnitNo
    --      AND ISNULL([tblUnitMstr].[IsActive], 0) = 1
    --      AND [tblUnitMstr].[UnitStatus] = 'VACANT';


    SELECT [tblProjectMstr].[ProjectName],
           [tblProjectMstr].[ProjectType],
           [tblUnitMstr].[RecId],
           IIF([tblUnitMstr].[FloorType] = '--SELECT--', '', ISNULL([tblUnitMstr].[FloorType], '')) AS [FloorType],
          -- CAST((@OrignalAmount - ((@OrignalAmount * ISNULL([tblRatesSettings].[WithHoldingTax], 0)) / 100))
          --  + ((ISNULL([tblUnitMstr].[BaseRental], 0) * ISNULL([tblRatesSettings].[GenVat], 0)) / 100)
          --AS DECIMAL(18,2) ) AS [BaseRental]
		  [tblUnitMstr].[SecAndMainWithVatAmount] AS [SecurityAndMaintenance],
		  [tblUnitMstr].[BaseRentalWithVatAmount] AS [BaseRental]

    --CAST(ISNULL([tblUnitMstr].[BaseRental], 0)
    --     + (((ISNULL([tblUnitMstr].[BaseRental], 0) * ISNULL([tblRatesSettings].[GenVat], 0)) / 100)
    --        - ((@BaseWithVatAmount * ISNULL([tblRatesSettings].[WithHoldingTax], 0)) / 100)
    --       ) AS DECIMAL(18, 2)) AS [BaseRental]
    FROM [dbo].[tblUnitMstr] WITH (NOLOCK)
        LEFT JOIN [dbo].[tblProjectMstr] WITH (NOLOCK)
            ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
        LEFT JOIN [dbo].[tblRatesSettings] WITH (NOLOCK)
            ON [tblProjectMstr].[ProjectType] = [tblRatesSettings].[ProjectType]
    WHERE [tblUnitMstr].[RecId] = @UnitNo
          AND ISNULL([tblUnitMstr].[IsActive], 0) = 1
          AND [tblUnitMstr].[UnitStatus] = 'VACANT'
    ORDER BY [tblUnitMstr].[UnitSequence] DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUnitAvailableByProjectId]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetUnitAvailableByProjectId] @ProjectId = 1
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUnitAvailableByProjectId] @ProjectId INT
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        SELECT
            [tblUnitMstr].[RecId],
            ISNULL([tblUnitMstr].[UnitNo], '') AS [UnitNo]
        FROM
            [dbo].[tblUnitMstr]
        WHERE
            [tblUnitMstr].[ProjectId] = @ProjectId
            AND ISNULL([tblUnitMstr].[IsActive], 0) = 1
            AND [tblUnitMstr].[UnitStatus] = 'VACANT'
            AND ISNULL([tblUnitMstr].[IsParking], 0) = 0
        ORDER BY
            [tblUnitMstr].[UnitSequence] DESC;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUnitById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUnitById] @RecId INT
AS
BEGIN

    SET NOCOUNT ON;

    SELECT [tblUnitMstr].[RecId],
           [tblUnitMstr].[ProjectId],
           ISNULL([tblProjectMstr].[ProjectName], '') AS [ProjectName],
           [tblUnitMstr].[UnitDescription],
           ISNULL([tblUnitMstr].[FloorNo], 0) AS [FloorNo],
           ISNULL([tblUnitMstr].[AreaSqm], 0) AS [AreaSqm],
           ISNULL([tblUnitMstr].[AreaRateSqm], 0) AS [AreaRateSqm],
            ISNULL([tblUnitMstr].[AreaTotalAmount] , 0) AS [AreaTotalAmount],
           ISNULL([tblUnitMstr].[FloorType], '') AS [FloorType],
           ISNULL([tblUnitMstr].[BaseRental], 0) AS [BaseRental],
           [tblUnitMstr].[GenVat],
           [tblUnitMstr].[SecurityAndMaintenance],
           [tblUnitMstr].[SecurityAndMaintenanceVat],
           ISNULL([tblUnitMstr].[UnitStatus], '') AS [UnitStatus],
           ISNULL([tblUnitMstr].[DetailsofProperty], '') AS [DetailsofProperty],
           ISNULL([tblUnitMstr].[UnitNo], '') AS [UnitNo],
           ISNULL([tblUnitMstr].[UnitSequence], 0) AS [UnitSequence],
           [tblUnitMstr].[clientID],
           [tblUnitMstr].[Tennant],
           ISNULL([tblUnitMstr].[IsParking],0) AS [IsParking],
           IIF(ISNULL([tblUnitMstr].[IsParking], 0) = 1, 'PARKING', 'UNIT') AS [UnitDescription],
           [tblUnitMstr].[IsNonVat],
           [tblUnitMstr].[BaseRentalVatAmount],
           [tblUnitMstr].[BaseRentalWithVatAmount],
           [tblUnitMstr].[BaseRentalTax],
           [tblUnitMstr].[TotalRental],
           [tblUnitMstr].[SecAndMainAmount],
           [tblUnitMstr].[SecAndMainVatAmount],
           [tblUnitMstr].[SecAndMainWithVatAmount],
           COALESCE([tblUnitMstr].[Vat],'') AS [Vat],
           [tblUnitMstr].[Tax],
           [tblUnitMstr].[TaxAmount],
           [tblProjectMstr].[RecId],
           [tblProjectMstr].[LocId],
           [tblProjectMstr].[ProjectName],
           [tblProjectMstr].[Descriptions],
           IIF(ISNULL([tblUnitMstr].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE') AS [IsActive],
           [tblProjectMstr].[ProjectAddress],
           [tblProjectMstr].[ProjectType],
           [tblProjectMstr].[CompanyId]
    FROM [dbo].[tblUnitMstr]
        INNER JOIN [dbo].[tblProjectMstr]
            ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
    WHERE [tblUnitMstr].[RecId] = @RecId
    ORDER BY [tblUnitMstr].[FloorNo],
             [tblUnitMstr].[UnitSequence] DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUnitByProjectId]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUnitByProjectId] @ProjectId INT
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT  DISTINCT
                [tblUnitMstr].[RecId],
                [tblUnitMstr].[ProjectId],
                ISNULL([tblProjectMstr].[ProjectName], '')                                       AS [ProjectName],
                IIF(ISNULL([tblUnitMstr].[IsParking], 0) = 1, 'TYPE OF PARKING', 'TYPE OF UNIT') AS [UnitDescription],
                ISNULL([tblUnitMstr].[FloorNo], 0)                                               AS [FloorNo],
                ISNULL([tblUnitMstr].[AreaSqm], 0)                                               AS [AreaSqm],
                ISNULL([tblUnitMstr].[AreaRateSqm], 0)                                           AS [AreaRateSqm],
                ISNULL([tblUnitMstr].[FloorType], '')                                            AS [FloorType],
                ISNULL([tblUnitMstr].[BaseRental], 0)                                            AS [BaseRental],
                CASE
                    WHEN ISNULL([tblUnitMstr].[UnitStatus], '') = 'RESERVED'
                        THEN
                        ISNULL([tblUnitMstr].[UnitStatus], '') + ' TO : '
                        + ISNULL(CAST([tblUnitReference].[ClientID] AS VARCHAR(20)), '') + ' - '
                        + [tblUnitReference].[InquiringClient]
                    WHEN ISNULL([tblUnitMstr].[UnitStatus], '') = 'MOVE-IN'
                        THEN
                        ISNULL([tblUnitMstr].[UnitStatus], '') + '  : '
                        + ISNULL(CAST([tblUnitReference].[ClientID] AS VARCHAR(20)), '') + ' - '
                        + [tblUnitReference].[InquiringClient]
                    ELSE
                        ISNULL([tblUnitMstr].[UnitStatus], '')
                END                                                                          AS [UnitStatus],
                ISNULL([tblUnitMstr].[UnitStatus], '')                                           AS [UnitStat],
                ISNULL([tblUnitMstr].[DetailsofProperty], '')                                    AS [DetailsofProperty],
                ISNULL([tblUnitMstr].[UnitNo], '')                                               AS [UnitNo],
                IIF(ISNULL([tblUnitMstr].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE')              AS [IsActive]
        FROM
                [dbo].[tblUnitMstr] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblProjectMstr] WITH (NOLOCK)
                    ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
            LEFT JOIN
                [dbo].[tblUnitReference] WITH (NOLOCK)
                    ON [tblUnitMstr].[RecId] = [tblUnitReference].[UnitId]
        WHERE
                [tblUnitMstr].[ProjectId] = @ProjectId;

    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUnitComputationList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- UNION THE SELECT OF PARKING LIST LATER ON
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUnitComputationList]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    SELECT [tblUnitReference].[RecId],
           [tblUnitReference].[RefId],
           [tblUnitReference].[ProjectId],
           ISNULL([tblProjectMstr].[ProjectName], '') AS [ProjectName],
           ISNULL([tblProjectMstr].[ProjectAddress], '') AS [ProjectAddress],
           ISNULL([tblProjectMstr].[ProjectType], '') AS [ProjectType],
           ISNULL([tblUnitReference].[InquiringClient], '') AS [InquiringClient],
           ISNULL([tblUnitReference].[ClientMobile], '') AS [ClientMobile],
           [tblUnitReference].[UnitId],
           ISNULL([tblUnitReference].[UnitNo], '') AS [UnitNo],
           ISNULL([tblUnitMstr].[FloorType], '') AS [FloorType],
           ISNULL(CONVERT(VARCHAR(20), [tblUnitReference].[StatDate], 107), '') AS [StatDate],
           ISNULL(CONVERT(VARCHAR(20), [tblUnitReference].[FinishDate], 107), '') AS [FinishDate],
           ISNULL(CONVERT(VARCHAR(20), [tblUnitReference].[TransactionDate], 107), '') AS [TransactionDate],
           CAST(ISNULL([tblUnitReference].[Rental], 0) AS DECIMAL(10, 2)) AS [Rental],
           CAST(ISNULL([tblUnitReference].[SecAndMaintenance], 0) AS DECIMAL(10, 2)) AS [SecAndMaintenance],
           CAST(ISNULL([tblUnitReference].[TotalRent], 0) AS DECIMAL(10, 2)) AS [TotalRent],
           CAST(ISNULL([tblUnitReference].[AdvancePaymentAmount], 0) AS DECIMAL(10, 2)) AS [AdvancePaymentAmount],
           CAST(ISNULL([tblUnitReference].[SecDeposit], 0) AS DECIMAL(10, 2)) AS [SecDeposit],
           CAST(ISNULL([tblUnitReference].[Total], 0) AS DECIMAL(10, 2)) AS [Total],
           [tblUnitReference].[EncodedBy],
           [tblUnitReference].[EncodedDate],
           [tblUnitReference].[IsActive],
           [tblUnitReference].[ComputerName],
           IIF(ISNULL([tblUnitMstr].[IsParking], 0) = 1, 'TYPE OF PARKING', 'TYPE OF UNIT') AS [TypeOf],
           IIF(ISNULL([tblUnitReference].[IsPartialPayment], 0) = 1, 'HOLD - PARTIAL PAYMENT', 'NEW') AS [TranStatus] --this for First Payment Flag AS Partial Payment
    FROM [dbo].[tblUnitReference]
        INNER JOIN [dbo].[tblProjectMstr]
            ON [tblUnitReference].[ProjectId] = [tblProjectMstr].[RecId]
        INNER JOIN [dbo].[tblUnitMstr]
            ON [tblUnitMstr].[RecId] = [tblUnitReference].[UnitId]
    WHERE ISNULL([tblUnitReference].[IsPaid], 0) = 0
          AND ISNULL([tblUnitMstr].[IsParking], 0) = 0;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUnitList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUnitList]
AS
BEGIN

    SET NOCOUNT ON;

    SELECT DISTINCT
           [tblUnitMstr].[RecId],
           [tblUnitMstr].[ProjectId],
           ISNULL([tblProjectMstr].[ProjectName], '') AS [ProjectName],
           IIF(ISNULL([tblUnitMstr].[IsParking], 0) = 1, 'TYPE OF PARKING', 'TYPE OF UNIT') AS [UnitDescription],
           ISNULL([tblUnitMstr].[FloorNo], 0) AS [FloorNo],
           ISNULL([tblUnitMstr].[AreaSqm], 0) AS [AreaSqm],
           ISNULL([tblUnitMstr].[AreaRateSqm], 0) AS [AreaRateSqm],
           ISNULL([tblUnitMstr].[FloorType], '') AS [FloorType],
           ISNULL([tblUnitMstr].[TotalRental], 0) AS [TotalMonthlyRental],
           CASE
               WHEN ISNULL([tblUnitMstr].[UnitStatus], '') = 'RESERVED' THEN
                   ISNULL([tblUnitMstr].[UnitStatus], '') + ' TO : '
                   + ISNULL(CAST([tblUnitReference].[ClientID] AS VARCHAR(20)), '') + ' - '
                   + [tblUnitReference].[InquiringClient]
               WHEN ISNULL([tblUnitMstr].[UnitStatus], '') = 'MOVE-IN' THEN
                   ISNULL([tblUnitMstr].[UnitStatus], '') + '  : '
                   + ISNULL(CAST([tblUnitReference].[ClientID] AS VARCHAR(20)), '') + ' - '
                   + [tblUnitReference].[InquiringClient]
               ELSE
                   ISNULL([tblUnitMstr].[UnitStatus], '')
           END AS [UnitStatus],
           ISNULL([tblUnitMstr].[UnitStatus], '') AS [UnitStat],
           ISNULL([tblUnitMstr].[DetailsofProperty], '') AS [DetailsofProperty],
           ISNULL([tblUnitMstr].[UnitNo], '') AS [UnitNo],
           IIF(ISNULL([tblUnitMstr].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE') AS [IsActive],
           [tblUnitReference].[ClientID]
    FROM [dbo].[tblUnitMstr]
        INNER JOIN [dbo].[tblProjectMstr]
            ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
        LEFT JOIN [dbo].[tblUnitReference]
            ON [tblUnitMstr].[RecId] = [tblUnitReference].[UnitId];

END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUnitListByProjectAndStatus]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_GetUnitListByProjectAndStatus]
    @ProjectId  INT         = NULL,
    @UnitStatus VARCHAR(15) = NULL,
    @ProjStatus VARCHAR(15) = NULL
AS
    BEGIN

        SET NOCOUNT ON;


        IF @ProjectId = 0
           AND @ProjStatus <> '--ALL--'
           AND
               (
                   @UnitStatus = ''
                   OR @UnitStatus = '--ALL--'
               )
            BEGIN
                SELECT  DISTINCT
                        [tblUnitMstr].[RecId],
                        [tblUnitMstr].[ProjectId],
                        ISNULL([tblProjectMstr].[ProjectName], '')                                               AS [ProjectName],
                        CAST(ISNULL([tblUnitMstr].[TotalRental], 0) AS VARCHAR(150))                             AS [TotalMonthlyRental],
                        ISNULL([tblUnitMstr].[FloorNo], 0)                                                       AS [FloorNo],
                        ISNULL([tblUnitMstr].[AreaSqm], 0)                                                       AS [AreaSqm],
                        ISNULL([tblUnitMstr].[AreaRateSqm], 0)                                                   AS [AreaRateSqm],
                        IIF([tblUnitMstr].[FloorType] = '--SELECT--', '', ISNULL([tblUnitMstr].[FloorType], '')) AS [FloorType],
                        ISNULL([tblUnitMstr].[BaseRental], 0)                                                    AS [BaseRental],
                        CASE
                            WHEN ISNULL([tblUnitMstr].[UnitStatus], '') = 'RESERVED'
                                THEN
                                ISNULL([tblUnitMstr].[UnitStatus], '') + ' TO : '
                                + ISNULL(CAST([tblUnitReference].[ClientID] AS VARCHAR(20)), '') + ' - '
                                + [tblUnitReference].[InquiringClient]
                            WHEN ISNULL([tblUnitMstr].[UnitStatus], '') = 'MOVE-IN'
                                THEN
                                ISNULL([tblUnitMstr].[UnitStatus], '') + '  : '
                                + ISNULL(CAST([tblUnitReference].[ClientID] AS VARCHAR(20)), '') + ' - '
                                + [tblUnitReference].[InquiringClient]
                            ELSE
                                ISNULL([tblUnitMstr].[UnitStatus], '')
                        END                                                                                      AS [UnitStatus],
                        ISNULL([tblUnitMstr].[UnitStatus], '')                                                   AS [UnitStat],
                        ISNULL([tblUnitMstr].[DetailsofProperty], '')                                            AS [DetailsofProperty],
                        ISNULL([tblUnitMstr].[UnitNo], '')                                                       AS [UnitNo],
                        IIF(ISNULL([tblUnitMstr].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE')                      AS [IsActive],
                        [tblUnitReference].[ClientID]
                FROM
                        [dbo].[tblUnitMstr] WITH (NOLOCK)
                    INNER JOIN
                        [dbo].[tblProjectMstr] WITH (NOLOCK)
                            ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
                    LEFT JOIN
                        [dbo].[tblUnitReference] WITH (NOLOCK)
                            ON [tblUnitMstr].[RecId] = [tblUnitReference].[UnitId]
                WHERE
                        [tblProjectMstr].[RecId] = @ProjectId
                        AND [tblUnitMstr].[UnitStatus] <> 'DISABLED'

            END
        ELSE IF @ProjectId = 0
                AND @ProjStatus = '--ALL--'
                AND
                    (
                        @UnitStatus = ''
                        OR @UnitStatus = '--ALL--'
                    )
            BEGIN
                SELECT  DISTINCT
                        [tblUnitMstr].[RecId],
                        [tblUnitMstr].[ProjectId],
                        ISNULL([tblProjectMstr].[ProjectName], '')                                               AS [ProjectName],
                        CAST(ISNULL([tblUnitMstr].[TotalRental], 0) AS VARCHAR(150))                             AS [TotalMonthlyRental],
                        ISNULL([tblUnitMstr].[FloorNo], 0)                                                       AS [FloorNo],
                        ISNULL([tblUnitMstr].[AreaSqm], 0)                                                       AS [AreaSqm],
                        ISNULL([tblUnitMstr].[AreaRateSqm], 0)                                                   AS [AreaRateSqm],
                        IIF([tblUnitMstr].[FloorType] = '--SELECT--', '', ISNULL([tblUnitMstr].[FloorType], '')) AS [FloorType],
                        ISNULL([tblUnitMstr].[BaseRental], 0)                                                    AS [BaseRental],
                        CASE
                            WHEN ISNULL([tblUnitMstr].[UnitStatus], '') = 'RESERVED'
                                THEN
                                ISNULL([tblUnitMstr].[UnitStatus], '') + ' TO : '
                                + ISNULL(CAST([tblUnitReference].[ClientID] AS VARCHAR(20)), '') + ' - '
                                + [tblUnitReference].[InquiringClient]
                            WHEN ISNULL([tblUnitMstr].[UnitStatus], '') = 'MOVE-IN'
                                THEN
                                ISNULL([tblUnitMstr].[UnitStatus], '') + '  : '
                                + ISNULL(CAST([tblUnitReference].[ClientID] AS VARCHAR(20)), '') + ' - '
                                + [tblUnitReference].[InquiringClient]
                            ELSE
                                ISNULL([tblUnitMstr].[UnitStatus], '')
                        END                                                                                      AS [UnitStatus],
                        ISNULL([tblUnitMstr].[UnitStatus], '')                                                   AS [UnitStat],
                        ISNULL([tblUnitMstr].[DetailsofProperty], '')                                            AS [DetailsofProperty],
                        ISNULL([tblUnitMstr].[UnitNo], '')                                                       AS [UnitNo],
                        IIF(ISNULL([tblUnitMstr].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE')                      AS [IsActive],
                        [tblUnitReference].[ClientID]
                FROM
                        [dbo].[tblUnitMstr] WITH (NOLOCK)
                    INNER JOIN
                        [dbo].[tblProjectMstr] WITH (NOLOCK)
                            ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
                    LEFT JOIN
                        [dbo].[tblUnitReference] WITH (NOLOCK)
                            ON [tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
                --WHERE
                --        [tblProjectMstr].[RecId] = @ProjectId
                --        AND [tblUnitMstr].[UnitStatus] = @UnitStatus
                ORDER BY
                        [tblUnitMstr].[ProjectId]
            END
        ELSE IF @ProjectId = 0
                AND @ProjStatus = '--ALL--'
                AND @UnitStatus <> '--ALL--'
            BEGIN
                SELECT  DISTINCT
                        [tblUnitMstr].[RecId],
                        [tblUnitMstr].[ProjectId],
                        ISNULL([tblProjectMstr].[ProjectName], '')                                               AS [ProjectName],
                        CAST(ISNULL([tblUnitMstr].[TotalRental], 0) AS VARCHAR(150))                             AS [TotalMonthlyRental],
                        ISNULL([tblUnitMstr].[FloorNo], 0)                                                       AS [FloorNo],
                        ISNULL([tblUnitMstr].[AreaSqm], 0)                                                       AS [AreaSqm],
                        ISNULL([tblUnitMstr].[AreaRateSqm], 0)                                                   AS [AreaRateSqm],
                        IIF([tblUnitMstr].[FloorType] = '--SELECT--', '', ISNULL([tblUnitMstr].[FloorType], '')) AS [FloorType],
                        ISNULL([tblUnitMstr].[BaseRental], 0)                                                    AS [BaseRental],
                        CASE
                            WHEN ISNULL([tblUnitMstr].[UnitStatus], '') = 'RESERVED'
                                THEN
                                ISNULL([tblUnitMstr].[UnitStatus], '') + ' TO : '
                                + ISNULL(CAST([tblUnitReference].[ClientID] AS VARCHAR(20)), '') + ' - '
                                + [tblUnitReference].[InquiringClient]
                            WHEN ISNULL([tblUnitMstr].[UnitStatus], '') = 'MOVE-IN'
                                THEN
                                ISNULL([tblUnitMstr].[UnitStatus], '') + '  : '
                                + ISNULL(CAST([tblUnitReference].[ClientID] AS VARCHAR(20)), '') + ' - '
                                + [tblUnitReference].[InquiringClient]
                            ELSE
                                ISNULL([tblUnitMstr].[UnitStatus], '')
                        END                                                                                      AS [UnitStatus],
                        ISNULL([tblUnitMstr].[UnitStatus], '')                                                   AS [UnitStat],
                        ISNULL([tblUnitMstr].[DetailsofProperty], '')                                            AS [DetailsofProperty],
                        ISNULL([tblUnitMstr].[UnitNo], '')                                                       AS [UnitNo],
                        IIF(ISNULL([tblUnitMstr].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE')                      AS [IsActive],
                        [tblUnitReference].[ClientID]
                FROM
                        [dbo].[tblUnitMstr] WITH (NOLOCK)
                    INNER JOIN
                        [dbo].[tblProjectMstr] WITH (NOLOCK)
                            ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
                    LEFT JOIN
                        [dbo].[tblUnitReference] WITH (NOLOCK)
                            ON [tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
                WHERE
                        [tblUnitMstr].[UnitStatus] = @UnitStatus
            END
        ELSE IF @ProjectId > 0
                AND @ProjStatus <> '--ALL--'
                AND(@UnitStatus ='' OR @UnitStatus = '--ALL--') 
            BEGIN
                SELECT  DISTINCT
                        [tblUnitMstr].[RecId],
                        [tblUnitMstr].[ProjectId],
                        ISNULL([tblProjectMstr].[ProjectName], '')                                               AS [ProjectName],
                        CAST(ISNULL([tblUnitMstr].[TotalRental], 0) AS VARCHAR(150))                             AS [TotalMonthlyRental],
                        ISNULL([tblUnitMstr].[FloorNo], 0)                                                       AS [FloorNo],
                        ISNULL([tblUnitMstr].[AreaSqm], 0)                                                       AS [AreaSqm],
                        ISNULL([tblUnitMstr].[AreaRateSqm], 0)                                                   AS [AreaRateSqm],
                        IIF([tblUnitMstr].[FloorType] = '--SELECT--', '', ISNULL([tblUnitMstr].[FloorType], '')) AS [FloorType],
                        ISNULL([tblUnitMstr].[BaseRental], 0)                                                    AS [BaseRental],
                        CASE
                            WHEN ISNULL([tblUnitMstr].[UnitStatus], '') = 'RESERVED'
                                THEN
                                ISNULL([tblUnitMstr].[UnitStatus], '') + ' TO : '
                                + ISNULL(CAST([tblUnitReference].[ClientID] AS VARCHAR(20)), '') + ' - '
                                + [tblUnitReference].[InquiringClient]
                            WHEN ISNULL([tblUnitMstr].[UnitStatus], '') = 'MOVE-IN'
                                THEN
                                ISNULL([tblUnitMstr].[UnitStatus], '') + '  : '
                                + ISNULL(CAST([tblUnitReference].[ClientID] AS VARCHAR(20)), '') + ' - '
                                + [tblUnitReference].[InquiringClient]
                            ELSE
                                ISNULL([tblUnitMstr].[UnitStatus], '')
                        END                                                                                      AS [UnitStatus],
                        ISNULL([tblUnitMstr].[UnitStatus], '')                                                   AS [UnitStat],
                        ISNULL([tblUnitMstr].[DetailsofProperty], '')                                            AS [DetailsofProperty],
                        ISNULL([tblUnitMstr].[UnitNo], '')                                                       AS [UnitNo],
                        IIF(ISNULL([tblUnitMstr].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE')                      AS [IsActive],
                        [tblUnitReference].[ClientID]
                FROM
                        [dbo].[tblUnitMstr] WITH (NOLOCK)
                    INNER JOIN
                        [dbo].[tblProjectMstr] WITH (NOLOCK)
                            ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
                    LEFT JOIN
                        [dbo].[tblUnitReference] WITH (NOLOCK)
                            ON [tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
                WHERE
                        [tblProjectMstr].[RecId] = @ProjectId

            END
        ELSE
            BEGIN
                SELECT  DISTINCT
                        [tblUnitMstr].[RecId],
                        [tblUnitMstr].[ProjectId],
                        ISNULL([tblProjectMstr].[ProjectName], '')                                               AS [ProjectName],
                        CAST(ISNULL([tblUnitMstr].[TotalRental], 0) AS VARCHAR(150))                             AS [TotalMonthlyRental],
                        ISNULL([tblUnitMstr].[FloorNo], 0)                                                       AS [FloorNo],
                        ISNULL([tblUnitMstr].[AreaSqm], 0)                                                       AS [AreaSqm],
                        ISNULL([tblUnitMstr].[AreaRateSqm], 0)                                                   AS [AreaRateSqm],
                        IIF([tblUnitMstr].[FloorType] = '--SELECT--', '', ISNULL([tblUnitMstr].[FloorType], '')) AS [FloorType],
                        ISNULL([tblUnitMstr].[BaseRental], 0)                                                    AS [BaseRental],
                        CASE
                            WHEN ISNULL([tblUnitMstr].[UnitStatus], '') = 'RESERVED'
                                THEN
                                ISNULL([tblUnitMstr].[UnitStatus], '') + ' TO : '
                                + ISNULL(CAST([tblUnitReference].[ClientID] AS VARCHAR(20)), '') + ' - '
                                + [tblUnitReference].[InquiringClient]
                            WHEN ISNULL([tblUnitMstr].[UnitStatus], '') = 'MOVE-IN'
                                THEN
                                ISNULL([tblUnitMstr].[UnitStatus], '') + '  : '
                                + ISNULL(CAST([tblUnitReference].[ClientID] AS VARCHAR(20)), '') + ' - '
                                + [tblUnitReference].[InquiringClient]
                            ELSE
                                ISNULL([tblUnitMstr].[UnitStatus], '')
                        END                                                                                      AS [UnitStatus],
                        ISNULL([tblUnitMstr].[UnitStatus], '')                                                   AS [UnitStat],
                        ISNULL([tblUnitMstr].[DetailsofProperty], '')                                            AS [DetailsofProperty],
                        ISNULL([tblUnitMstr].[UnitNo], '')                                                       AS [UnitNo],
                        IIF(ISNULL([tblUnitMstr].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE')                      AS [IsActive],
                        [tblUnitReference].[ClientID]
                FROM
                        [dbo].[tblUnitMstr] WITH (NOLOCK)
                    INNER JOIN
                        [dbo].[tblProjectMstr] WITH (NOLOCK)
                            ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
                    LEFT JOIN
                        [dbo].[tblUnitReference] WITH (NOLOCK)
                            ON [tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
                WHERE
                        [tblProjectMstr].[RecId] = @ProjectId
                        AND [tblUnitMstr].[UnitStatus] = @UnitStatus
            END
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUserGroupList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_GetUserGroupList]
  

AS
BEGIN
    SET NOCOUNT ON

	SELECT [tblGroup].[GroupId],
       [tblGroup].[GroupName],
       [tblGroup].[IsDelete]
FROM [dbo].[tblGroup];

END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUserInfo]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC [sp_GetUserInfo] @UserId = 100000
CREATE PROCEDURE [dbo].[sp_GetUserInfo] @UserId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT [tblUser].[GroupId],
           [dbo].[fn_GetUserGroupName]([tblUser].[UserId]) AS [GroupName],
           [tblUser].[StaffName],
           [tblUser].[Middlename],
           [tblUser].[Lastname],
           [tblUser].[EmailAddress],
           [tblUser].[Phone],
           [tblUser].[UserPassword],
           [tblUser].[UserName],
           IIF(ISNULL([tblUser].[IsDelete], 0) = 0, 'ACTIVE', 'IN-ACTIVE') AS [UserStatus]
    FROM [dbo].[tblUser]
    WHERE [tblUser].[UserId] = @UserId;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUserList]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetUserList]
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
            [tblUser].[UserId],
            [tblUser].[GroupId],
            [tblUser].[UserName],
            [tblUser].[UserPassword],
            [tblUser].[UserPasswordIncrypt],
            [tblUser].[StaffName],
            [tblUser].[Middlename],
            [tblUser].[Lastname],
            [tblUser].[EmailAddress],
            [tblUser].[Phone],
            IIF(ISNULL([tblUser].[IsDelete],0)=1,'ACTIVE','IN-ACTIVE') AS UserStatus
        FROM
            [dbo].[tblUser];
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUserPassword]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetUserPassword] @UserId VARCHAR(20) = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT
            [tblUser].[UserId],
            [tblUser].[GroupId],
            [tblUser].[UserName],
            [tblUser].[UserPassword],
            [tblUser].[UserPasswordIncrypt],
            UPPER([tblUser].[StaffName]) AS [StaffName],
            [tblUser].[Middlename],
            [tblUser].[Lastname],
            [tblUser].[EmailAddress],
            [tblUser].[Phone],
            ISNULL([tblUser].[IsDelete], 0) AS [UserStatus]
        FROM
            [dbo].[tblUser]
        WHERE
            [tblUser].[UserName] = @UserId;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetWAREHOUSESettings]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetWAREHOUSESettings]
AS
BEGIN

    SET NOCOUNT ON;


    SELECT [tblRatesSettings].[ProjectType],
           ISNULL([tblRatesSettings].[GenVat], 0) AS [GenVat],
           ISNULL([tblRatesSettings].[SecurityAndMaintenance], 0) AS [SecurityAndMaintenance],
           ISNULL([tblRatesSettings].[WithHoldingTax], 0) AS [WithHoldingTax],
           ISNULL([tblRatesSettings].[PenaltyPct], 0) AS [PenaltyPct],
           [tblRatesSettings].[EncodedBy],
           [tblRatesSettings].[EncodedDate],
           [tblRatesSettings].[ComputerName]
    FROM [dbo].[tblRatesSettings]
    WHERE [tblRatesSettings].[ProjectType] = 'WAREHOUSE';

END;
GO
/****** Object:  StoredProcedure [dbo].[sp_HoldPayment]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_HoldPayment]
    @ReferenceID VARCHAR(50) = NULL,
    @Recid       INT         = NULL
AS
    BEGIN TRY

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';
        BEGIN TRANSACTION
        UPDATE
            [dbo].[tblMonthLedger]
        SET
            [tblMonthLedger].[IsHold] = 1
        WHERE
            [Recid] = @Recid
            AND [tblMonthLedger].[ReferenceID] =
                (
                    SELECT
                        [tblUnitReference].[RecId]
                    FROM
                        [dbo].[tblUnitReference]
                    WHERE
                        [tblUnitReference].[RefId] = @ReferenceID
                );

        IF (@@ROWCOUNT > 0)
            BEGIN
                SET @Message_Code = 'SUCCESS'
                SET @ErrorMessage = N''
            END;

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];


        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        SET @Message_Code = 'ERROR'
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [ErrorMessage],
                [LogDateTime]
            )
        VALUES
            (
                'sp_HoldPayment', @ErrorMessage, GETDATE()
            );

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_HoldPDCPayment]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_HoldPDCPayment]
    @CompanyORNo       VARCHAR(30)  = NULL,
    @CompanyPRNo       VARCHAR(30)  = NULL,
    @BankAccountName   VARCHAR(30)  = NULL,
    @BankAccountNumber VARCHAR(30)  = NULL,
    @BankName          VARCHAR(30)  = NULL,
    @SerialNo          VARCHAR(30)  = NULL,
    @PaymentRemarks    VARCHAR(100) = NULL,
    @REF               VARCHAR(100) = NULL,
    @BankBranch        VARCHAR(100) = NULL,
    @ModeType          VARCHAR(20)  = NULL,
    @XML               XML
AS
    BEGIN TRY

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';
        BEGIN TRANSACTION
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

        -- Insert statements for procedure here
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
            [tblMonthLedger].[BankBranch] = @BankBranch
        WHERE
            [tblMonthLedger].[Recid] IN
                (
                    SELECT
                        [#tblBulkPostdatedMonth].[Recid]
                    FROM
                        [#tblBulkPostdatedMonth] WITH (NOLOCK)
                )


        IF (@@ROWCOUNT > 0)
            BEGIN
                SET @Message_Code = 'SUCCESS'
                SET @ErrorMessage = N''
            END;

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];


        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        SET @Message_Code = 'ERROR'
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [ErrorMessage],
                [LogDateTime]
            )
        VALUES
            (
                'sp_HoldPDCPayment', @ErrorMessage, GETDATE()
            );

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END CATCH
    DROP TABLE [#tblBulkPostdatedMonth]
GO
/****** Object:  StoredProcedure [dbo].[sp_LogError]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_LogError]
    @ProcedureName NVARCHAR(255) = NULL,
    @frmName       NVARCHAR(255) = NULL,
    @FormName      NVARCHAR(255) = NULL,
    @ErrorMessage  NVARCHAR(MAX) = NULL,
    @LogDateTime   DATETIME      = NULL,
    @UserId        INT           = NULL
AS
    BEGIN
        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [frmName],
                [FormName],
                [Category],
                [ErrorMessage],
                [UserId],
                [LogDateTime]
            )
        VALUES
            (
                @ProcedureName, @frmName, @FormName, 'APP', @ErrorMessage, @UserId, @LogDateTime
            );
    END;


GO
/****** Object:  StoredProcedure [dbo].[sp_LogEvent]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_LogEvent]
    @EventType    VARCHAR(150)  = NULL,
    @EventMessage NVARCHAR(MAX) = NULL,
    @UserId       INT           = NULL,
    @ComputerName NVARCHAR(150) = NULL
AS
    BEGIN
        INSERT INTO [dbo].[LoggingEvent]
            (
                [EventDateTime],
                [EventType],
                [EventMessage],
                [UserId],
                [ComputerName]
            )
        VALUES
            (
                GETDATE(),     -- EventDateTime - datetime
                @EventType,    -- EventType - nvarchar(500)
                @EventMessage, -- EventMessage - nvarchar(max),
                @UserId,       -- UserId - int
                @ComputerName  -- ComputerName nvarchar(150)
            )
    END;


GO
/****** Object:  StoredProcedure [dbo].[sp_MovedIn]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_MovedIn]
    -- Add the parameters for the stored procedure here
    @ReferenceID VARCHAR(20) = NULL
AS
    BEGIN TRY

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';
        BEGIN TRANSACTION
        UPDATE
            [dbo].[tblUnitReference]
        SET
            [tblUnitReference].[IsUnitMove] = 1,
            [tblUnitReference].[UnitMoveInDate] = GETDATE()
        WHERE
            [tblUnitReference].[RefId] = @ReferenceID;
        -- Log a success event    
        IF (@@ROWCOUNT > 0)
            BEGIN


                SET @Message_Code = 'SUCCESS'
                SET @ErrorMessage = N''

            END;


        UPDATE
            [dbo].[tblUnitMstr]
        SET
            [tblUnitMstr].[UnitStatus] = 'MOVE-IN'
        WHERE
            [RecId] =
            (
                SELECT
                    [tblUnitReference].[UnitId]
                FROM
                    [dbo].[tblUnitReference]
                WHERE
                    [tblUnitReference].[RefId] = @ReferenceID
            );
        -- Log a success event    
        IF (@@ROWCOUNT > 0)
            BEGIN

                SET @Message_Code = 'SUCCESS'
                SET @ErrorMessage = N''
            END;



        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];


        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        SET @Message_Code = 'ERROR'
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [ErrorMessage],
                [LogDateTime]
            )
        VALUES
            (
                'sp_MovedIn', @ErrorMessage, GETDATE()
            );

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END CATCH

GO
/****** Object:  StoredProcedure [dbo].[sp_MovedOut]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_MovedOut]
    -- Add the parameters for the stored procedure here
    @ReferenceID VARCHAR(20) = NULL
AS
    BEGIN TRY

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';
        BEGIN TRANSACTION
        UPDATE
            [dbo].[tblUnitReference]
        SET
            [tblUnitReference].[IsUnitMoveOut] = 1,
            [tblUnitReference].[UnitMoveOutDate] = GETDATE()
        WHERE
            [tblUnitReference].[RefId] = @ReferenceID;
        -- Log a success event    
        IF (@@ROWCOUNT > 0)
            BEGIN


                SET @Message_Code = 'SUCCESS'
                SET @ErrorMessage = N''
            END;


        UPDATE
            [dbo].[tblUnitMstr]
        SET
            [tblUnitMstr].[UnitStatus] = 'HOLD'
        WHERE
            [RecId] =
            (
                SELECT
                    [tblUnitReference].[UnitId]
                FROM
                    [dbo].[tblUnitReference]
                WHERE
                    [tblUnitReference].[RefId] = @ReferenceID
            );
        -- Log a success event    
        IF (@@ROWCOUNT > 0)
            BEGIN

                SET @Message_Code = N'SUCCESS';
            END;
        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];


        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        SET @Message_Code = 'ERROR'
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [ErrorMessage],
                [LogDateTime]
            )
        VALUES
            (
                'sp_MovedOut', @ErrorMessage, GETDATE()
            );

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_MoveInAuthorization]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_MoveInAuthorization] @RefId AS VARCHAR(50) = NULL
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
BEGIN
    SET NOCOUNT ON;

    CREATE TABLE [#tblTemp]
    (
        [DatePrint] VARCHAR(10),
        [ProjectName] VARCHAR(100),
        [ProjectAddress] VARCHAR(1000),
        [UnitNo] VARCHAR(50),
        [TenantName] VARCHAR(50),
        [Taddress] VARCHAR(1000),
        [MoveInDate] VARCHAR(10),
        [leasingStaff] VARCHAR(50),
        [leasingManager] VARCHAR(50),
        [Remakrs] VARCHAR(500),
    );

    INSERT INTO [#tblTemp]
    (
        [DatePrint],
        [ProjectName],
        [ProjectAddress],
        [UnitNo],
        [TenantName],
        [Taddress],
        [MoveInDate],
        [leasingStaff],
        [leasingManager],
        [Remakrs]
    )
    SELECT CONVERT(VARCHAR(10), GETDATE(), 111),                                -- DatePrint - varchar(10)
           ISNULL([tblProjectMstr].[ProjectName], '') AS [ProjectName],         -- ProjectName - varchar(100)
           'occupy Unit ' + ISNULL([tblUnitMstr].[UnitNo], '') + ' located at '
           + ISNULL([tblProjectMstr].[ProjectAddress], '') AS [ProjectAddress], -- ProjectAddress - varchar(1000)
           ISNULL([tblUnitMstr].[UnitNo], '') AS [UnitNo],                      -- UnitNo - varchar(50)
           ISNULL([tblClientMstr].[ClientName], '') AS [ClientName],            -- TenantName - varchar(50)
           ISNULL([tblClientMstr].[PostalAddress], '') AS [PostalAddress],      -- Taddress - varchar(1000)
           CONVERT(VARCHAR(10), GETDATE(), 111),                                -- MoveInDate - varchar(10)
           '',                                                                  -- leasingStaff - varchar(50)
           '',                                                                  -- leasingManager - varchar(50)
           ''                                                                   -- Remakrs - varchar(500)
    FROM [dbo].[tblUnitReference]
        INNER JOIN [dbo].[tblProjectMstr]
            ON [dbo].[tblUnitReference].[ProjectId] = [dbo].[tblProjectMstr].[RecId]
        INNER JOIN [dbo].[tblUnitMstr]
            ON [dbo].[tblUnitReference].[UnitId] = [dbo].[tblUnitMstr].[RecId]
        INNER JOIN [dbo].[tblClientMstr]
            ON [tblUnitReference].[ClientID] = [tblClientMstr].[ClientID]
    WHERE [tblUnitReference].[RefId] = @RefId;

    SELECT [#tblTemp].[DatePrint],
           [#tblTemp].[ProjectName],
           [#tblTemp].[ProjectAddress],
           [#tblTemp].[UnitNo],
           [#tblTemp].[TenantName],
           [#tblTemp].[Taddress],
           [#tblTemp].[MoveInDate],
           [#tblTemp].[leasingStaff],
           [#tblTemp].[leasingManager],
           [#tblTemp].[Remakrs]
    FROM [#tblTemp];
END;

DROP TABLE IF EXISTS [#tblTemp];
GO
/****** Object:  StoredProcedure [dbo].[sp_Nature_OR_Report]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
--EXEC [sp_Nature_OR_Report] @TranID = 'TRN10000007',@Mode = 'ADV',@PaymentLevel = 'FIRST'
--EXEC [sp_Nature_OR_Report] @TranID = 'TRN10000007',@Mode = 'SEC',@PaymentLevel = 'FIRST'
--EXEC [sp_Nature_OR_Report] @TranID = 'TRN10000007',@Mode = 'REN',@PaymentLevel = 'SECOND'
--EXEC [sp_Nature_OR_Report] @TranID = 'TRN10000007',@Mode = 'MAIN',@PaymentLevel = 'SECOND'
--TRUNCATE TABLE [dbo].[tblRecieptReport]
CREATE   PROCEDURE [dbo].[sp_Nature_OR_Report]
    @TranID       VARCHAR(20) = NULL,
    @Mode         VARCHAR(50) = NULL,
    @PaymentLevel VARCHAR(50) = NULL
AS
    BEGIN
        SET NOCOUNT ON;



        CREATE TABLE [#tblRecieptReport]
            (
                [client_no]          [VARCHAR](500)  NULL,
                [client_Name]        [VARCHAR](500)  NULL,
                [client_Address]     [VARCHAR](5000) NULL,
                [PR_No]              [VARCHAR](500)  NULL,
                [OR_No]              [VARCHAR](500)  NULL,
                [TIN_No]             [VARCHAR](500)  NULL,
                [TransactionDate]    [DATETIME]      NULL,
                [AmountInWords]      [VARCHAR](5000) NULL,
                [PaymentFor]         [VARCHAR](500)  NULL,
                [TotalAmountInDigit] [VARCHAR](100)  NULL,
                [RENTAL]             [VARCHAR](500)  NULL,
                [VAT]                [VARCHAR](500)  NULL,
                [VATPct]             [VARCHAR](500)  NULL,
                [TOTAL]              [VARCHAR](500)  NULL,
                [LESSWITHHOLDING]    [VARCHAR](500)  NULL,
                [TOTALAMOUNTDUE]     [VARCHAR](500)  NULL,
                [BANKNAME]           [VARCHAR](500)  NULL,
                [PDCCHECKSERIALNO]   [VARCHAR](500)  NULL,
                [USER]               [VARCHAR](500)  NULL,
                [EncodedDate]        [DATETIME]      NULL,
                [TRANID]             [VARCHAR](500)  NULL,
                [Mode]               [VARCHAR](500)  NULL,
                [PaymentLevel]       [VARCHAR](100)  NULL,
                [UnitNo]             [VARCHAR](150)  NULL,
                [ProjectName]        [VARCHAR](150)  NULL,
                [BankBranch]         [VARCHAR](150)  NULL,
                [RENTAL_LESS_VAT]    [VARCHAR](150)  NULL,
                [RENTAL_LESS_TAX]    [VARCHAR](150)  NULL
            )
        DECLARE @RentalSandMLabel VARCHAR(150) = ''
        DECLARE @UnitCategory VARCHAR(150) = ''
        DECLARE @combinedString VARCHAR(MAX);
        DECLARE @IsFullPayment BIT = 0;
        DECLARE @RefId VARCHAR(100) = '';

        SELECT
            @UnitCategory = [dbo].[fnGetUnitCategoryByUnitId]([tblUnitReference].[UnitId])
        FROM
            [dbo].[tblUnitReference]
        WHERE
            [tblUnitReference].[RefId] =
            (
                SELECT
                    [tblTransaction].[RefId]
                FROM
                    [dbo].[tblTransaction]
                WHERE
                    [tblTransaction].[TranID] = @TranID
            )

        BEGIN
            SELECT
                @IsFullPayment = ISNULL([tblUnitReference].[IsFullPayment], 0),
                @RefId         = [tblUnitReference].[RefId]
            FROM
                [dbo].[tblUnitReference]
            WHERE
                [tblUnitReference].[RefId] =
                (
                    SELECT TOP 1
                           [tblTransaction].[RefId]
                    FROM
                           [dbo].[tblTransaction]
                    WHERE
                           [tblTransaction].[TranID] = @TranID
                );

            IF @IsFullPayment = 0
                BEGIN
                    IF
                        (
                            SELECT
                                COUNT(*)
                            FROM
                                [dbo].[tblPayment]
                            WHERE
                                [tblPayment].[TranId] = @TranID
                                AND [tblPayment].[Remarks] NOT IN (
                                                                      'SECURITY DEPOSIT'
                                                                  )
                        ) > 5
                        BEGIN
                            IF @Mode = 'REN'
                               AND @PaymentLevel = 'SECOND'
                                BEGIN
                                    SET @RentalSandMLabel = 'RENTAL'
                                    SELECT
                                        @combinedString
                                        = 'RENTAL FOR '
                                          +
                                        (
                                            SELECT  TOP 1
                                                    UPPER(DATENAME(MONTH, MIN([tblPayment].[ForMonth]))) + ' '
                                                    + CAST(YEAR(MIN([tblPayment].[ForMonth])) AS VARCHAR(4))
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'RENTAL NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        ) + ' TO '
                                          +
                                        (
                                            SELECT  TOP 1
                                                    UPPER(DATENAME(MONTH, MAX([tblPayment].[ForMonth]))) + ' '
                                                    + CAST(YEAR(MAX([tblPayment].[ForMonth])) AS VARCHAR(4))
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'RENTAL NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        )
                                END

                            IF @Mode = 'MAIN'
                               AND @PaymentLevel = 'SECOND'
                                BEGIN
                                    SET @RentalSandMLabel = 'S&M'
                                    SELECT
                                        @combinedString
                                        = 'SECURITY & MAINTENANCE FOR'
                                          +
                                        (
                                            SELECT  TOP 1
                                                    UPPER(DATENAME(MONTH, MIN([tblPayment].[ForMonth]))) + ' '
                                                    + CAST(YEAR(MIN([tblPayment].[ForMonth])) AS VARCHAR(4))
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'SECURITY AND MAINTENANCE NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        ) + ' TO '
                                          +
                                        (
                                            SELECT  TOP 1
                                                    UPPER(DATENAME(MONTH, MAX([tblPayment].[ForMonth]))) + ' '
                                                    + CAST(YEAR(MAX([tblPayment].[ForMonth])) AS VARCHAR(4))
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'SECURITY AND MAINTENANCE NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        )
                                END

                        END
                    ELSE
                        BEGIN
                            IF @Mode = 'SEC'
                               AND @PaymentLevel = 'FIRST'
                                BEGIN
                                    SET @RentalSandMLabel = 'RENTAL'
                                    SELECT
                                        --@combinedString
                                        --= '('
                                        --  + CAST(CAST([dbo].[fnGetTotalSecDepositAmountCount](@RefId) AS INT) AS VARCHAR(50))
                                        --  + ')MONTH-SECURITY DEPOSIT'
                                        @combinedString = ' SECURITY DEPOSIT '

                                END
                            ELSE IF @Mode = 'ADV'
                                    AND @PaymentLevel = 'FIRST'
                                BEGIN
                                    --SELECT @combinedString = 'ADVANCE PAYMENT'
                                    BEGIN
                                        SELECT
                                            @combinedString
                                            = COALESCE(@combinedString + '-', '')
                                              + UPPER(DATENAME(MONTH, [tblPayment].[ForMonth])) + ' '
                                              + CAST(YEAR([tblPayment].[ForMonth]) AS VARCHAR(4))
                                        FROM
                                            [dbo].[tblPayment]
                                        WHERE
                                            [tblPayment].[TranId] = @TranID
                                            AND [tblPayment].[Remarks] = 'MONTHS ADVANCE'
                                            AND ISNULL([tblPayment].[Notes], '') = ''


                                    END
                                END
                            ELSE
                                BEGIN

                                    IF @Mode = 'REN'
                                       AND @PaymentLevel = 'SECOND'
                                        BEGIN
                                            SET @RentalSandMLabel = 'RENTAL'
                                            SELECT
                                                    @combinedString
                                                = IIF(@UnitCategory = 'PARKING', 'PS RENTAL FOR', 'RENTAL FOR ')
                                                  --+ COALESCE(@combinedString + '-', '')
                                                  + UPPER(DATENAME(MONTH, [tblPayment].[ForMonth])) + ' '
                                                  + CAST(YEAR([tblPayment].[ForMonth]) AS VARCHAR(4))
                                                  + IIF(ISNULL([tblMonthLedger].[IsHold], 0) = 1, '(PARTIAL)', '')
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'RENTAL NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        END
                                    IF @Mode = 'MAIN'
                                       AND @PaymentLevel = 'SECOND'
                                        BEGIN
                                            SET @RentalSandMLabel = 'S&M'
                                            SELECT
                                                    @combinedString
                                                = 'SECURITY & MAINTENANCE FOR '
                                                  --+ COALESCE(@combinedString + '-', '')
                                                  + UPPER(DATENAME(MONTH, [tblPayment].[ForMonth])) + ' '
                                                  + CAST(YEAR([tblPayment].[ForMonth]) AS VARCHAR(4))
                                                  + IIF(ISNULL([tblMonthLedger].[IsHold], 0) = 1, '(PARTIAL)', '')
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'SECURITY AND MAINTENANCE NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        END


                                END
                        END
                END;


            IF @Mode = 'ADV'
               AND @PaymentLevel = 'FIRST'
                BEGIN
                    INSERT INTO [#tblRecieptReport]
                        (
                            [client_no],
                            [client_Name],
                            [client_Address],
                            [PR_No],
                            [OR_No],
                            [TIN_No],
                            [TransactionDate],
                            [AmountInWords],
                            [PaymentFor],      --PAYMENT DESCRIPTION
                            [TotalAmountInDigit],
                            [RENTAL],
                            [VAT],             --VAT AMOUNT
                            [VATPct],
                            [TOTAL],
                            [LESSWITHHOLDING], --TAX AMOUNT
                            [TOTALAMOUNTDUE],
                            [BANKNAME],
                            [PDCCHECKSERIALNO],
                            [USER],
                            [EncodedDate],
                            [TRANID],
                            [Mode],
                            [PaymentLevel],
                            [UnitNo],
                            [ProjectName],
                            [BankBranch],
                            [RENTAL_LESS_VAT],
                            [RENTAL_LESS_TAX]
                        )
                                SELECT
                                    [CLIENT].[client_no]                                                                                                  AS [client_no],
                                    [CLIENT].[client_Name]                                                                                                AS [client_Name],
                                    [CLIENT].[client_Address]                                                                                             AS [client_Address],
                                    [RECEIPT].[PR_No]                                                                                                     AS [PR_No],
                                    [RECEIPT].[OR_No]                                                                                                     AS [OR_No],
                                    [CLIENT].[TIN_No]                                                                                                     AS [TIN_No],
                                    [RECEIPT].[TransactionDate]                                                                                           AS [TransactionDate],
                                    UPPER([dbo].[fnNumberToWordsWithDecimal](IIF(@IsFullPayment = 0,
                                                                                 [tblUnitReference].[AdvancePaymentAmount],
                                                                                 [tblUnitReference].[Total])
                                                                            )
                                         )                                                                                                                AS [AmountInWords],
                                    [PAYMENT].[PAYMENT_FOR]                                                                                               AS [PaymentFor],
                                    IIF(@IsFullPayment = 0,
                                        [tblUnitReference].[AdvancePaymentAmount],
                                        [tblUnitReference].[Total])                                                                                       AS [TotalAmountInDigit],
                                    IIF(@IsFullPayment = 0,
                                        [tblUnitReference].[AdvancePaymentAmount],
                                        [tblUnitReference].[Total])
                                    - (([tblUnitReference].[Unit_BaseRentalVatAmount]
                                        + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                       )
                                       * CAST([dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2))
                                      )                                                                                                                   AS [RENTAL],
                                    CAST(([tblUnitReference].[Unit_BaseRentalVatAmount]
                                          + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                         )
                                         * CAST([dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))      AS [VAT_AMOUNT],
                                    CAST(CAST([tblUnitReference].[Unit_Vat] AS INT) AS VARCHAR(10)) + '% VAT'                                             AS [VATPct],
                                    IIF(@IsFullPayment = 0,
                                        [tblUnitReference].[AdvancePaymentAmount],
                                        [tblUnitReference].[Total])                                                                                       AS [TOTAL],
                                    IIF([tblUnitReference].[Unit_Tax] = 0,
                                        '',
                                        CAST([tblUnitReference].[Unit_BaseRentalTax]
                                             * CAST([dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))) AS [LESSWITHHOLDING],
                                    [tblUnitReference].[AdvancePaymentAmount]                                                                             AS [TOTALAMOUNTDUE],
                                    [RECEIPT].[BankName]                                                                                                  AS [BANKNAME],
                                    [RECEIPT].[PDC_CHECK_SERIAL]                                                                                          AS [PDCCHECKSERIALNO],
                                    [TRANSACTION].[USER]                                                                                                  AS [USER],
                                    GETDATE()                                                                                                             AS [EncodedDate],
                                    @TranID                                                                                                               AS [TRANID],
                                    @Mode                                                                                                                 AS [Mode],
                                    @PaymentLevel                                                                                                         AS [PaymentLevel],
                                    [tblUnitReference].[UnitNo]                                                                                           AS [UnitNo],
                                    [dbo].[fnGetProjectNameById]([tblUnitReference].[ProjectId])                                                          AS [ProjectName],
                                    [RECEIPT].[BankBranch]                                                                                                AS [BankBranch],
                                    CAST(CAST(IIF(@IsFullPayment = 0,
                                                  IIF([tblUnitReference].[Unit_Tax] > 0,
                                                      ([tblUnitReference].[AdvancePaymentAmount]
                                                       + CAST([tblUnitReference].[Unit_BaseRentalTax]
                                                              * [dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2))
                                                      ),
                                                      [tblUnitReference].[AdvancePaymentAmount]),
                                                  [tblUnitReference].[Total]) AS DECIMAL(18, 2))
                                         - CAST(([dbo].[tblUnitReference].[Unit_BaseRentalVatAmount]
                                                 + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                                )
                                                * [dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))    AS [RENTAL_LESS_VAT],
                                    CAST(IIF(@IsFullPayment = 0,
                                             [tblUnitReference].[AdvancePaymentAmount],
                                             [tblUnitReference].[Total]) AS VARCHAR(150))                                                                 AS [RENTAL_LESS_TAX]
                                FROM
                                    [dbo].[tblUnitReference]
                                    CROSS APPLY
                                    (
                                        SELECT
                                            [tblClientMstr].[ClientID]      AS [client_no],
                                            [tblClientMstr].[ClientName]    AS [client_Name],
                                            [tblClientMstr].[PostalAddress] AS [client_Address],
                                            [tblClientMstr].[TIN_No]        AS [TIN_No]
                                        FROM
                                            [dbo].[tblClientMstr]
                                        WHERE
                                            [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
                                    ) [CLIENT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblTransaction].[EncodedDate],
                                            [tblTransaction].[TranID],
                                            ISNULL([dbo].[fn_GetUserName]([tblTransaction].[EncodedBy]), '') AS [USER],
                                            [tblTransaction].[ReceiveAmount]
                                        FROM
                                            [dbo].[tblTransaction]
                                        WHERE
                                            [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                                    ) [TRANSACTION]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblReceipt].[CompanyPRNo] AS [PR_No],
                                            [tblReceipt].[CompanyORNo] AS [OR_No],
                                            [tblReceipt].[Amount]      AS [TOTAL],
                                            [tblReceipt].[BankName]    AS [BankName],
                                            [tblReceipt].[BankBranch]  AS [BankBranch],
                                            [tblReceipt].[REF]         AS [PDC_CHECK_SERIAL],
                                            [tblReceipt].[TranId],
                                            [tblReceipt].[ReceiptDate] AS [TransactionDate]
                                        FROM
                                            [dbo].[tblReceipt]
                                        WHERE
                                            [TRANSACTION].[TranID] = [tblReceipt].[TranId]
                                    ) [RECEIPT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            IIF(@IsFullPayment = 1, 'FULL PAYMENT', @combinedString) AS [PAYMENT_FOR]
                                    ) [PAYMENT]
                                WHERE
                                    [TRANSACTION].[TranID] = @TranID


                END
            IF @Mode = 'SEC'
               AND @PaymentLevel = 'FIRST'
                BEGIN
                    INSERT INTO [#tblRecieptReport]
                        (
                            [client_no],
                            [client_Name],
                            [client_Address],
                            [PR_No],
                            [OR_No],
                            [TIN_No],
                            [TransactionDate],
                            [AmountInWords],
                            [PaymentFor],
                            [TotalAmountInDigit],
                            [RENTAL],
                            [VAT],
                            [VATPct],
                            [TOTAL],
                            [LESSWITHHOLDING],
                            [TOTALAMOUNTDUE],
                            [BANKNAME],
                            [PDCCHECKSERIALNO],
                            [USER],
                            [EncodedDate],
                            [TRANID],
                            [Mode],
                            [PaymentLevel],
                            [UnitNo],
                            [ProjectName],
                            [BankBranch],
                            [RENTAL_LESS_VAT],
                            [RENTAL_LESS_TAX]
                        )
                                SELECT
                                    [CLIENT].[client_no]                                                                                                           AS [client_no],
                                    [CLIENT].[client_Name]                                                                                                         AS [client_Name],
                                    [CLIENT].[client_Address]                                                                                                      AS [client_Address],
                                    [RECEIPT].[PR_No]                                                                                                              AS [PR_No],
                                    [RECEIPT].[OR_No]                                                                                                              AS [OR_No],
                                    [CLIENT].[TIN_No]                                                                                                              AS [TIN_No],
                                    [RECEIPT].[TransactionDate]                                                                                                    AS [TransactionDate],
                                    UPPER([dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[SecDeposit]))                                                     AS [AmountInWords],
                                    [PAYMENT].[PAYMENT_FOR]                                                                                                        AS [PaymentFor],
                                    [tblUnitReference].[SecDeposit]                                                                                                AS [TotalAmountInDigit],
                                    [tblUnitReference].[SecDeposit]
                                    - CAST(([tblUnitReference].[Unit_BaseRentalVatAmount]
                                            + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                           )
                                           * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2))                          AS [RENTAL],
                                    CAST(CAST(([tblUnitReference].[Unit_BaseRentalVatAmount]
                                               + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                              )
                                              * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))      AS [VAT],
                                    CAST(CAST([tblUnitReference].[Unit_Vat] AS INT) AS VARCHAR(10)) + '% VAT'                                                      AS [VATPct],
                                    [tblUnitReference].[SecDeposit]                                                                                                AS [TOTAL],
                                    IIF([tblUnitReference].[Unit_Tax] = 0,
                                        '',
                                        CAST(CAST([tblUnitReference].[Unit_TaxAmount]
                                                  * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))) AS [LESSWITHHOLDING],
                                    [tblUnitReference].[SecDeposit]                                                                                                AS [TOTALAMOUNTDUE],
                                    [RECEIPT].[BankName]                                                                                                           AS [BANKNAME],
                                    [RECEIPT].[PDC_CHECK_SERIAL]                                                                                                   AS [PDCCHECKSERIALNO],
                                    [TRANSACTION].[USER]                                                                                                           AS [USER],
                                    GETDATE()                                                                                                                      AS [EncodedDate],
                                    @TranID                                                                                                                        AS [TRANID],
                                    @Mode                                                                                                                          AS [Mode],
                                    @PaymentLevel                                                                                                                  AS [PaymentLevel],
                                    [tblUnitReference].[UnitNo]                                                                                                    AS [UnitNo],
                                    [dbo].[fnGetProjectNameById]([tblUnitReference].[ProjectId])                                                                   AS [ProjectName],
                                    [RECEIPT].[BankBranch]                                                                                                         AS [BankBranch],
                                    CAST(CAST(IIF([tblUnitReference].[Unit_Tax] > 0,
                                                  ([tblUnitReference].[SecDeposit]
                                                   + CAST([tblUnitReference].[Unit_BaseRentalTax]
                                                          * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2))
                                                  ),
                                                  0) AS DECIMAL(18, 2))
                                         - CAST(([tblUnitReference].[Unit_BaseRentalVatAmount]
                                                 + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                                )
                                                * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))    AS [RENTAL_LESS_VAT],
                                    CAST(CAST([tblUnitReference].[SecDeposit] AS DECIMAL(18, 2)) AS VARCHAR(150))                                                  AS [RENTAL_LESS_TAX]
                                FROM
                                    [dbo].[tblUnitReference]
                                    CROSS APPLY
                                    (
                                        SELECT
                                            [tblClientMstr].[ClientID]      AS [client_no],
                                            [tblClientMstr].[ClientName]    AS [client_Name],
                                            [tblClientMstr].[PostalAddress] AS [client_Address],
                                            [tblClientMstr].[TIN_No]        AS [TIN_No]
                                        FROM
                                            [dbo].[tblClientMstr]
                                        WHERE
                                            [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
                                    ) [CLIENT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblTransaction].[EncodedDate],
                                            [tblTransaction].[TranID],
                                            ISNULL([dbo].[fn_GetUserName]([tblTransaction].[EncodedBy]), '') AS [USER],
                                            [tblTransaction].[ReceiveAmount]
                                        FROM
                                            [dbo].[tblTransaction]
                                        WHERE
                                            [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                                    ) [TRANSACTION]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblReceipt].[CompanyPRNo] AS [PR_No],
                                            [tblReceipt].[CompanyORNo] AS [OR_No],
                                            [tblReceipt].[Amount]      AS [TOTAL],
                                            [tblReceipt].[BankName]    AS [BankName],
                                            [tblReceipt].[BankBranch]  AS [BankBranch],
                                            [tblReceipt].[REF]         AS [PDC_CHECK_SERIAL],
                                            [tblReceipt].[TranId],
                                            [tblReceipt].[ReceiptDate] AS [TransactionDate]
                                        FROM
                                            [dbo].[tblReceipt]
                                        WHERE
                                            [TRANSACTION].[TranID] = [tblReceipt].[TranId]
                                    ) [RECEIPT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            IIF(@IsFullPayment = 1, 'FULL PAYMENT', @combinedString) AS [PAYMENT_FOR]
                                    ) [PAYMENT]
                                WHERE
                                    [TRANSACTION].[TranID] = @TranID


                END



            IF @Mode = 'REN'
               AND @PaymentLevel = 'SECOND'
                BEGIN
                    INSERT INTO [#tblRecieptReport]
                        (
                            [client_no],
                            [client_Name],
                            [client_Address],
                            [PR_No],
                            [OR_No],
                            [TIN_No],
                            [TransactionDate],
                            [AmountInWords],
                            [PaymentFor],
                            [TotalAmountInDigit],
                            [RENTAL],
                            [VAT],
                            [VATPct],
                            [TOTAL],
                            [LESSWITHHOLDING],
                            [TOTALAMOUNTDUE],
                            [BANKNAME],
                            [PDCCHECKSERIALNO],
                            [USER],
                            [EncodedDate],
                            [TRANID],
                            [Mode],
                            [PaymentLevel],
                            [UnitNo],
                            [ProjectName],
                            [BankBranch],
                            [RENTAL_LESS_VAT],
                            [RENTAL_LESS_TAX]
                        )
                                SELECT
                                    [CLIENT].[client_no]                                                      AS [client_no],
                                    [CLIENT].[client_Name]                                                    AS [client_Name],
                                    [CLIENT].[client_Address]                                                 AS [client_Address],
                                    [RECEIPT].[PR_No]                                                         AS [PR_No],
                                    [RECEIPT].[OR_No]                                                         AS [OR_No],
                                    [CLIENT].[TIN_No]                                                         AS [TIN_No],
                                    [RECEIPT].[TransactionDate]                                               AS [TransactionDate],
                                    UPPER([dbo].[fnNumberToWordsWithDecimal]([TRANSACTION].[ReceiveAmount]))  AS [AmountInWords],
                                    [PAYMENT].[PAYMENT_FOR]                                                   AS [PaymentFor],
                                    [TRANSACTION].[ReceiveAmount]                                             AS [TotalAmountInDigit],
                                    [TRANSACTION].[ReceiveAmount]
                                    - [dbo].[fnGetBaseRentalTotalVatAmount](
                                                                               [dbo].[tblUnitReference].[RefId],
                                                                               [TRANSACTION].[AmountToPay],
                                                                               [TRANSACTION].[ReceiveAmount]
                                                                           )                                  AS [RENTAL],
                                    --CAST(CAST((([tblUnitReference].[Unit_Vat] * [TRANSACTION].[ReceiveAmount])
                                    --           / 100
                                    --          ) AS DECIMAL(18, 2)) AS VARCHAR(30))                           AS [VAT],
                                    CAST([dbo].[fnGetBaseRentalTotalVatAmount](
                                                                                  [dbo].[tblUnitReference].[RefId],
                                                                                  [TRANSACTION].[AmountToPay],
                                                                                  [TRANSACTION].[ReceiveAmount]
                                                                              ) AS VARCHAR(150))              AS [VAT],
                                    CAST(CAST([tblUnitReference].[Unit_Vat] AS INT) AS VARCHAR(10)) + '% VAT' AS [VATPct],
                                    [TRANSACTION].[ReceiveAmount]                                             AS [TOTAL],
                                    --IIF([tblUnitReference].[Unit_Tax] > 0,
                                    --    CAST(CAST((([tblUnitReference].[Unit_Tax] * [TRANSACTION].[ReceiveAmount])
                                    --               / 100
                                    --              ) AS DECIMAL(18, 2)) AS VARCHAR(30)),
                                    --    '0.00')                                                              AS [LESSWITHHOLDING],

                                    IIF([tblUnitReference].[Unit_Tax] = 0,
                                        '',
                                        CAST([dbo].[fnGetBaseRentalTotalTaxAmount](
                                                                                      [dbo].[tblUnitReference].[RefId],
                                                                                      [TRANSACTION].[AmountToPay],
                                                                                      [TRANSACTION].[ReceiveAmount]
                                                                                  ) AS VARCHAR(150)))         AS [LESSWITHHOLDING],
                                    [TRANSACTION].[ReceiveAmount]                                             AS [TOTALAMOUNTDUE],
                                    [RECEIPT].[BankName]                                                      AS [BANKNAME],
                                    [RECEIPT].[PDC_CHECK_SERIAL]                                              AS [PDCCHECKSERIALNO],
                                    [TRANSACTION].[USER]                                                      AS [USER],
                                    GETDATE()                                                                 AS [EncodedDate],
                                    @TranID                                                                   AS [TRANID],
                                    @Mode                                                                     AS [Mode],
                                    @PaymentLevel                                                             AS [PaymentLevel],
                                    [tblUnitReference].[UnitNo]                                               AS [UnitNo],
                                    [dbo].[fnGetProjectNameById]([tblUnitReference].[ProjectId])              AS [ProjectName],
                                    [RECEIPT].[BankBranch]                                                    AS [BankBranch],
                                    '0'                                                                       AS [RENTAL_LESS_VAT],
                                    '0'                                                                       AS [RENTAL_LESS_TAX]
                                FROM
                                    [dbo].[tblUnitReference]
                                    CROSS APPLY
                                    (
                                        SELECT
                                            [tblClientMstr].[ClientID]      AS [client_no],
                                            [tblClientMstr].[ClientName]    AS [client_Name],
                                            [tblClientMstr].[PostalAddress] AS [client_Address],
                                            [tblClientMstr].[TIN_No]        AS [TIN_No]
                                        FROM
                                            [dbo].[tblClientMstr]
                                        WHERE
                                            [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
                                    ) [CLIENT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                                [tblTransaction].[EncodedDate],
                                                [tblTransaction].[TranID],
                                                SUM([tblMonthLedger].[LedgRentalAmount])                         AS [AmountToPay],
                                                ISNULL([dbo].[fn_GetUserName]([tblTransaction].[EncodedBy]), '') AS [USER],
                                                SUM([tblPayment].[Amount])                                       AS [ReceiveAmount]
                                        FROM
                                                [dbo].[tblTransaction]
                                            INNER JOIN
                                                [dbo].[tblPayment]
                                                    ON [tblPayment].[TranId] = [tblTransaction].[TranID]
                                            INNER JOIN
                                                [dbo].[tblMonthLedger]
                                                    ON [tblMonthLedger].[Recid] = [tblPayment].[LedgeRecid]
                                        WHERE
                                                [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                                                AND [tblPayment].[Notes] = 'RENTAL NET OF VAT'
                                        GROUP BY
                                                [tblTransaction].[EncodedDate],
                                                [tblTransaction].[TranID],
                                                [tblTransaction].[EncodedBy],
                                                [tblPayment].[Amount],
                                                [tblTransaction].[PaidAmount]
                                    ) [TRANSACTION]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblReceipt].[CompanyPRNo] AS [PR_No],
                                            [tblReceipt].[CompanyORNo] AS [OR_No],
                                            [tblReceipt].[Amount]      AS [TOTAL],
                                            [tblReceipt].[Amount]      AS [TotalAmountInDigit],
                                            [tblReceipt].[BankName]    AS [BankName],
                                            [tblReceipt].[BankBranch]  AS [BankBranch],
                                            [tblReceipt].[REF]         AS [PDC_CHECK_SERIAL],
                                            [tblReceipt].[TranId],
                                            [tblReceipt].[ReceiptDate] AS [TransactionDate]
                                        FROM
                                            [dbo].[tblReceipt]
                                        WHERE
                                            [TRANSACTION].[TranID] = [tblReceipt].[TranId]
                                    ) [RECEIPT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            IIF(@IsFullPayment = 1, 'FULL PAYMENT', @combinedString) AS [PAYMENT_FOR]
                                    ) [PAYMENT]
                                WHERE
                                    [TRANSACTION].[TranID] = @TranID;
                END
            IF @Mode = 'MAIN'
               AND @PaymentLevel = 'SECOND'
                BEGIN
                    INSERT INTO [#tblRecieptReport]
                        (
                            [client_no],
                            [client_Name],
                            [client_Address],
                            [PR_No],
                            [OR_No],
                            [TIN_No],
                            [TransactionDate],
                            [AmountInWords],
                            [PaymentFor],
                            [TotalAmountInDigit],
                            [RENTAL],
                            [VAT],
                            [VATPct],
                            [TOTAL],
                            [LESSWITHHOLDING],
                            [TOTALAMOUNTDUE],
                            [BANKNAME],
                            [PDCCHECKSERIALNO],
                            [USER],
                            [EncodedDate],
                            [TRANID],
                            [Mode],
                            [PaymentLevel],
                            [UnitNo],
                            [ProjectName],
                            [BankBranch],
                            [RENTAL_LESS_VAT],
                            [RENTAL_LESS_TAX]
                        )
                                SELECT
                                    [CLIENT].[client_no]                                                                                                 AS [client_no],
                                    [CLIENT].[client_Name]                                                                                               AS [client_Name],
                                    [CLIENT].[client_Address]                                                                                            AS [client_Address],
                                    [RECEIPT].[PR_No]                                                                                                    AS [PR_No],
                                    [RECEIPT].[OR_No]                                                                                                    AS [OR_No],
                                    [CLIENT].[TIN_No]                                                                                                    AS [TIN_No],
                                    [RECEIPT].[TransactionDate]                                                                                          AS [TransactionDate],
                                    UPPER([dbo].[fnNumberToWordsWithDecimal]([TRANSACTION].[ReceiveAmount]))                                             AS [AmountInWords],
                                    [PAYMENT].[PAYMENT_FOR]                                                                                              AS [PaymentFor],
                                    [TRANSACTION].[ReceiveAmount]                                                                                        AS [TotalAmountInDigit],
                                    [TRANSACTION].[ReceiveAmount]
                                    - CAST((([tblUnitReference].[Unit_Vat] * [TRANSACTION].[ReceiveAmount]) / 100) AS DECIMAL(18, 2))                    AS [RENTAL],
                                    CAST(CAST((([tblUnitReference].[Unit_Vat] * [TRANSACTION].[ReceiveAmount]) / 100) AS DECIMAL(18, 2)) AS VARCHAR(30)) AS [VAT], --TAX WILL FOLLOW
                                    CAST(CAST([tblUnitReference].[Unit_Vat] AS INT) AS VARCHAR(10)) + '% VAT'                                            AS [VATPct],
                                    [TRANSACTION].[ReceiveAmount]                                                                                        AS [TOTAL],
                                    IIF([tblUnitReference].[Unit_Tax] > 0,
                                        CAST(CAST((([tblUnitReference].[Unit_Tax] * [TRANSACTION].[ReceiveAmount])
                                                   / 100
                                                  ) AS DECIMAL(18, 2)) AS VARCHAR(30)),
                                        '')                                                                                                              AS [LESSWITHHOLDING],
                                    [TRANSACTION].[ReceiveAmount]                                                                                        AS [TOTALAMOUNTDUE],
                                    [RECEIPT].[BankName]                                                                                                 AS [BANKNAME],
                                    [RECEIPT].[PDC_CHECK_SERIAL]                                                                                         AS [PDCCHECKSERIALNO],
                                    [TRANSACTION].[USER]                                                                                                 AS [USER],
                                    GETDATE()                                                                                                            AS [EncodedDate],
                                    @TranID                                                                                                              AS [TRANID],
                                    @Mode                                                                                                                AS [Mode],
                                    @PaymentLevel                                                                                                        AS [PaymentLevel],
                                    [tblUnitReference].[UnitNo]                                                                                          AS [UnitNo],
                                    [dbo].[fnGetProjectNameById]([tblUnitReference].[ProjectId])                                                         AS [ProjectName],
                                    [RECEIPT].[BankBranch]                                                                                               AS [BankBranch],
                                    '0'                                                                                                                  AS [RENTAL_LESS_VAT],
                                    '0'                                                                                                                  AS [RENTAL_LESS_TAX]
                                FROM
                                    [dbo].[tblUnitReference]
                                    CROSS APPLY
                                    (
                                        SELECT
                                            [tblClientMstr].[ClientID]      AS [client_no],
                                            [tblClientMstr].[ClientName]    AS [client_Name],
                                            [tblClientMstr].[PostalAddress] AS [client_Address],
                                            [tblClientMstr].[TIN_No]        AS [TIN_No]
                                        FROM
                                            [dbo].[tblClientMstr]
                                        WHERE
                                            [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
                                    ) [CLIENT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                                [tblTransaction].[EncodedDate],
                                                [tblTransaction].[TranID],
                                                ISNULL([dbo].[fn_GetUserName]([tblTransaction].[EncodedBy]), '') AS [USER],
                                                SUM([tblPayment].[Amount])                                       AS [ReceiveAmount]
                                        FROM
                                                [dbo].[tblTransaction]
                                            INNER JOIN
                                                [dbo].[tblPayment]
                                                    ON [tblPayment].[TranId] = [tblTransaction].[TranID]
                                        WHERE
                                                [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                                                AND [tblPayment].[Notes] = 'SECURITY AND MAINTENANCE NET OF VAT'
                                        GROUP BY
                                                [tblTransaction].[EncodedDate],
                                                [tblTransaction].[TranID],
                                                [tblTransaction].[EncodedBy],
                                                [tblPayment].[Amount]
                                    ) [TRANSACTION]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblReceipt].[CompanyPRNo] AS [PR_No],
                                            [tblReceipt].[CompanyORNo] AS [OR_No],
                                            [tblReceipt].[Amount]      AS [TOTAL],
                                            [tblReceipt].[Amount]      AS [TotalAmountInDigit],
                                            [tblReceipt].[BankName]    AS [BankName],
                                            [tblReceipt].[BankBranch]  AS [BankBranch],
                                            [tblReceipt].[REF]         AS [PDC_CHECK_SERIAL],
                                            [tblReceipt].[TranId],
                                            [tblReceipt].[ReceiptDate] AS [TransactionDate]
                                        FROM
                                            [dbo].[tblReceipt]
                                        WHERE
                                            [TRANSACTION].[TranID] = [tblReceipt].[TranId]
                                    ) [RECEIPT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            IIF(@IsFullPayment = 1, 'FULL PAYMENT', @combinedString) AS [PAYMENT_FOR]
                                    ) [PAYMENT]
                                WHERE
                                    [TRANSACTION].[TranID] = @TranID;
                END





        END


        SELECT
            @RentalSandMLabel                                                                      AS [RentalSandMLabel],
            [#tblRecieptReport].[client_no],
            [#tblRecieptReport].[client_Name],
            [#tblRecieptReport].[client_Address],
            [#tblRecieptReport].[PR_No],
            [#tblRecieptReport].[OR_No],
            [#tblRecieptReport].[TIN_No],
            CAST(CONVERT(VARCHAR(15), [#tblRecieptReport].[TransactionDate], 107) AS VARCHAR(150)) AS [TransactionDate],
            [#tblRecieptReport].[AmountInWords],
            ISNULL([#tblRecieptReport].[PaymentFor], '')                                           AS [PaymentFor],
            --FORMAT(CAST([#TMP].[TotalAmountInDigit] AS DECIMAL(18, 2)), 'C', 'en-PH') AS [TotalAmountInDigit],
            FORMAT(CAST([#tblRecieptReport].[TotalAmountInDigit] AS DECIMAL(18, 2)), 'N')          AS [TotalAmountInDigit],
            --FORMAT(CAST([#TMP].[RENTAL] AS DECIMAL(18, 2)), 'C', 'en-PH') AS [RENTAL],
            FORMAT(CAST([#tblRecieptReport].[RENTAL] AS DECIMAL(18, 2)), 'C', 'en-PH')             AS [RENTAL],
            FORMAT(CAST([#tblRecieptReport].[VAT] AS DECIMAL(18, 2)), 'C', 'en-PH')                AS [VAT],
            [#tblRecieptReport].[VATPct],
            FORMAT(CAST([#tblRecieptReport].[RENTAL] AS DECIMAL(18, 2)), 'C', 'en-PH')             AS [TOTAL],
            --FORMAT(CAST([tblRecieptReport].[LESSWITHHOLDING] AS DECIMAL(18, 2)), 'C', 'en-PH') AS [LESSWITHHOLDING],
            [#tblRecieptReport].[LESSWITHHOLDING]                                                  AS [LESSWITHHOLDING],
            IIF([#tblRecieptReport].[LESSWITHHOLDING] <> '', 'LESS WITHHOLDING', '')               AS [LESSWITHHOLDING_label],
            --[#TMP].[LESSWITHHOLDING] AS [LESSWITHHOLDING],
            FORMAT(CAST([#tblRecieptReport].[TOTALAMOUNTDUE] AS DECIMAL(18, 2)), 'C', 'en-PH')     AS [TOTALAMOUNTDUE],
            [#tblRecieptReport].[BANKNAME],
            [#tblRecieptReport].[PDCCHECKSERIALNO],
            [#tblRecieptReport].[USER],
            [#tblRecieptReport].[Mode],
            [#tblRecieptReport].[UnitNo],
            [#tblRecieptReport].[ProjectName],
            [#tblRecieptReport].[BankBranch],
            ''                                                                                     AS [BankCheckDate],
            ''                                                                                     AS [BankCheckAmount],
            [#tblRecieptReport].[RENTAL_LESS_VAT],
            [#tblRecieptReport].[RENTAL_LESS_TAX]
        FROM
            [#tblRecieptReport]
        --WHERE
        --       [tblRecieptReport].[TRANID] = @TranID
        --       AND [tblRecieptReport].[Mode] = @Mode
        --       AND [tblRecieptReport].[PaymentLevel] = @PaymentLevel
        ORDER BY
            [#tblRecieptReport].[EncodedDate]

    END;

    DROP TABLE [#tblRecieptReport]
GO
/****** Object:  StoredProcedure [dbo].[sp_Nature_PR_Report]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE    PROCEDURE [dbo].[sp_Nature_PR_Report]
    @TranID       VARCHAR(20) = NULL,
    @Mode         VARCHAR(50) = NULL,
    @PaymentLevel VARCHAR(50) = NULL
AS
     BEGIN
        SET NOCOUNT ON;



        CREATE TABLE [#tblRecieptReport]
            (
                [client_no]          [VARCHAR](500)  NULL,
                [client_Name]        [VARCHAR](500)  NULL,
                [client_Address]     [VARCHAR](5000) NULL,
                [PR_No]              [VARCHAR](500)  NULL,
                [OR_No]              [VARCHAR](500)  NULL,
                [TIN_No]             [VARCHAR](500)  NULL,
                [TransactionDate]    [DATETIME]      NULL,
                [AmountInWords]      [VARCHAR](5000) NULL,
                [PaymentFor]         [VARCHAR](500)  NULL,
                [TotalAmountInDigit] [VARCHAR](100)  NULL,
                [RENTAL]             [VARCHAR](500)  NULL,
                [VAT]                [VARCHAR](500)  NULL,
                [VATPct]             [VARCHAR](500)  NULL,
                [TOTAL]              [VARCHAR](500)  NULL,
                [LESSWITHHOLDING]    [VARCHAR](500)  NULL,
                [TOTALAMOUNTDUE]     [VARCHAR](500)  NULL,
                [BANKNAME]           [VARCHAR](500)  NULL,
                [PDCCHECKSERIALNO]   [VARCHAR](500)  NULL,
                [USER]               [VARCHAR](500)  NULL,
                [EncodedDate]        [DATETIME]      NULL,
                [TRANID]             [VARCHAR](500)  NULL,
                [Mode]               [VARCHAR](500)  NULL,
                [PaymentLevel]       [VARCHAR](100)  NULL,
                [UnitNo]             [VARCHAR](150)  NULL,
                [ProjectName]        [VARCHAR](150)  NULL,
                [BankBranch]         [VARCHAR](150)  NULL,
                [RENTAL_LESS_VAT]    [VARCHAR](150)  NULL,
                [RENTAL_LESS_TAX]    [VARCHAR](150)  NULL
            )

        DECLARE @UnitCategory VARCHAR(150) = ''
        DECLARE @combinedString VARCHAR(MAX);
        DECLARE @IsFullPayment BIT = 0;
        DECLARE @RefId VARCHAR(100) = '';

        SELECT
            @UnitCategory = [dbo].[fnGetUnitCategoryByUnitId]([tblUnitReference].[UnitId])
        FROM
            [dbo].[tblUnitReference]
        WHERE
            [tblUnitReference].[RefId] =
            (
                SELECT
                    [tblTransaction].[RefId]
                FROM
                    [dbo].[tblTransaction]
                WHERE
                    [tblTransaction].[TranID] = @TranID
            )

        BEGIN
            SELECT
                @IsFullPayment = ISNULL([tblUnitReference].[IsFullPayment], 0),
                @RefId         = [tblUnitReference].[RefId]
            FROM
                [dbo].[tblUnitReference]
            WHERE
                [tblUnitReference].[RefId] =
                (
                    SELECT TOP 1
                           [tblTransaction].[RefId]
                    FROM
                           [dbo].[tblTransaction]
                    WHERE
                           [tblTransaction].[TranID] = @TranID
                );

            IF @IsFullPayment = 0
                BEGIN
                    IF
                        (
                            SELECT
                                COUNT(*)
                            FROM
                                [dbo].[tblPayment]
                            WHERE
                                [tblPayment].[TranId] = @TranID
                                AND [tblPayment].[Remarks] NOT IN (
                                                                      'SECURITY DEPOSIT'
                                                                  )
                        ) > 5
                        BEGIN
                            IF @Mode = 'REN'
                               AND @PaymentLevel = 'SECOND'
                                BEGIN
                                    SELECT
                                        @combinedString
                                        = 'RENTAL FOR '
                                          +
                                        (
                                            SELECT  TOP 1
                                                    UPPER(DATENAME(MONTH, MIN([tblPayment].[ForMonth]))) + ' '
                                                    + CAST(YEAR(MIN([tblPayment].[ForMonth])) AS VARCHAR(4))
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'RENTAL NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        ) + ' TO '
                                          +
                                        (
                                            SELECT  TOP 1
                                                    UPPER(DATENAME(MONTH, MAX([tblPayment].[ForMonth]))) + ' '
                                                    + CAST(YEAR(MAX([tblPayment].[ForMonth])) AS VARCHAR(4))
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'RENTAL NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        )
                                END

                            IF @Mode = 'MAIN'
                               AND @PaymentLevel = 'SECOND'
                                BEGIN

                                    SELECT
                                        @combinedString
                                        = 'SECURITY & MAINTENANCE FOR'
                                          +
                                        (
                                            SELECT  TOP 1
                                                    UPPER(DATENAME(MONTH, MIN([tblPayment].[ForMonth]))) + ' '
                                                    + CAST(YEAR(MIN([tblPayment].[ForMonth])) AS VARCHAR(4))
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'SECURITY AND MAINTENANCE NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        ) + ' TO '
                                          +
                                        (
                                            SELECT  TOP 1
                                                    UPPER(DATENAME(MONTH, MAX([tblPayment].[ForMonth]))) + ' '
                                                    + CAST(YEAR(MAX([tblPayment].[ForMonth])) AS VARCHAR(4))
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'SECURITY AND MAINTENANCE NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        )
                                END

                        END
                    ELSE
                        BEGIN
                            IF @Mode = 'SEC'
                               AND @PaymentLevel = 'FIRST'
                                BEGIN
                                    SELECT
                                        --@combinedString
                                        --= '('
                                        --  + CAST(CAST([dbo].[fnGetTotalSecDepositAmountCount](@RefId) AS INT) AS VARCHAR(50))
                                        --  + ')MONTH-SECURITY DEPOSIT'
                                        @combinedString = ' SECURITY DEPOSIT '

                                END
                            ELSE IF @Mode = 'ADV'
                                    AND @PaymentLevel = 'FIRST'
                                BEGIN
                                    --SELECT @combinedString = 'ADVANCE PAYMENT'
                                    BEGIN
                                        SELECT
                                            @combinedString
                                            = COALESCE(@combinedString + '-', '')
                                              + UPPER(DATENAME(MONTH, [tblPayment].[ForMonth])) + ' '
                                              + CAST(YEAR([tblPayment].[ForMonth]) AS VARCHAR(4))
                                        FROM
                                            [dbo].[tblPayment]
                                        WHERE
                                            [tblPayment].[TranId] = @TranID
                                            AND [tblPayment].[Remarks] = 'MONTHS ADVANCE'
                                            AND ISNULL([tblPayment].[Notes], '') = ''


                                    END
                                END
                            ELSE
                                BEGIN

                                    IF @Mode = 'REN'
                                       AND @PaymentLevel = 'SECOND'
                                        BEGIN
                                            SELECT
                                                    @combinedString
                                                = IIF(@UnitCategory = 'PARKING', 'PS RENTAL FOR', 'RENTAL FOR ')
                                                  --+ COALESCE(@combinedString + '-', '')
                                                  + UPPER(DATENAME(MONTH, [tblPayment].[ForMonth])) + ' '
                                                  + CAST(YEAR([tblPayment].[ForMonth]) AS VARCHAR(4))
                                                  + IIF(ISNULL([tblMonthLedger].[IsHold], 0) = 1, '(PARTIAL)', '')
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'RENTAL NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        END
                                    IF @Mode = 'MAIN'
                                       AND @PaymentLevel = 'SECOND'
                                        BEGIN
                                            SELECT
                                                    @combinedString
                                                = 'SECURITY & MAINTENANCE FOR '
                                                  --+ COALESCE(@combinedString + '-', '')
                                                  + UPPER(DATENAME(MONTH, [tblPayment].[ForMonth])) + ' '
                                                  + CAST(YEAR([tblPayment].[ForMonth]) AS VARCHAR(4))
                                                  + IIF(ISNULL([tblMonthLedger].[IsHold], 0) = 1, '(PARTIAL)', '')
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'SECURITY AND MAINTENANCE NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        END


                                END
                        END
                END;


            IF @Mode = 'ADV'
               AND @PaymentLevel = 'FIRST'
                BEGIN
                    INSERT INTO [#tblRecieptReport]
                        (
                            [client_no],
                            [client_Name],
                            [client_Address],
                            [PR_No],
                            [OR_No],
                            [TIN_No],
                            [TransactionDate],
                            [AmountInWords],
                            [PaymentFor],      --PAYMENT DESCRIPTION
                            [TotalAmountInDigit],
                            [RENTAL],
                            [VAT],             --VAT AMOUNT
                            [VATPct],
                            [TOTAL],
                            [LESSWITHHOLDING], --TAX AMOUNT
                            [TOTALAMOUNTDUE],
                            [BANKNAME],
                            [PDCCHECKSERIALNO],
                            [USER],
                            [EncodedDate],
                            [TRANID],
                            [Mode],
                            [PaymentLevel],
                            [UnitNo],
                            [ProjectName],
                            [BankBranch],
                            [RENTAL_LESS_VAT],
                            [RENTAL_LESS_TAX]
                        )
                                SELECT
                                    [CLIENT].[client_no]                                                                                                  AS [client_no],
                                    [CLIENT].[client_Name]                                                                                                AS [client_Name],
                                    [CLIENT].[client_Address]                                                                                             AS [client_Address],
                                    [RECEIPT].[PR_No]                                                                                                     AS [PR_No],
                                    [RECEIPT].[OR_No]                                                                                                     AS [OR_No],
                                    [CLIENT].[TIN_No]                                                                                                     AS [TIN_No],
                                    [RECEIPT].[TransactionDate]                                                                                           AS [TransactionDate],
                                    UPPER([dbo].[fnNumberToWordsWithDecimal](IIF(@IsFullPayment = 0,
                                                                                 [tblUnitReference].[AdvancePaymentAmount],
                                                                                 [tblUnitReference].[Total])
                                                                            )
                                         )                                                                                                                AS [AmountInWords],
                                    [PAYMENT].[PAYMENT_FOR]                                                                                               AS [PaymentFor],
                                    IIF(@IsFullPayment = 0,
                                        [tblUnitReference].[AdvancePaymentAmount],
                                        [tblUnitReference].[Total])                                                                                       AS [TotalAmountInDigit],
                                    IIF(@IsFullPayment = 0,
                                        [tblUnitReference].[AdvancePaymentAmount],
                                        [tblUnitReference].[Total])
                                    - (([tblUnitReference].[Unit_BaseRentalVatAmount]
                                        + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                       )
                                       * CAST([dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2))
                                      )                                                                                                                   AS [RENTAL],
                                    CAST(([tblUnitReference].[Unit_BaseRentalVatAmount]
                                          + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                         )
                                         * CAST([dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))      AS [VAT_AMOUNT],
                                    CAST(CAST([tblUnitReference].[Unit_Vat] AS INT) AS VARCHAR(10)) + '% VAT'                                             AS [VATPct],
                                    IIF(@IsFullPayment = 0,
                                        [tblUnitReference].[AdvancePaymentAmount],
                                        [tblUnitReference].[Total])                                                                                       AS [TOTAL],
                                    IIF([tblUnitReference].[Unit_Tax] = 0,
                                        '',
                                        CAST([tblUnitReference].[Unit_BaseRentalTax]
                                             * CAST([dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))) AS [LESSWITHHOLDING],
                                    [tblUnitReference].[AdvancePaymentAmount]                                                                             AS [TOTALAMOUNTDUE],
                                    [RECEIPT].[BankName]                                                                                                  AS [BANKNAME],
                                    [RECEIPT].[PDC_CHECK_SERIAL]                                                                                          AS [PDCCHECKSERIALNO],
                                    [TRANSACTION].[USER]                                                                                                  AS [USER],
                                    GETDATE()                                                                                                             AS [EncodedDate],
                                    @TranID                                                                                                               AS [TRANID],
                                    @Mode                                                                                                                 AS [Mode],
                                    @PaymentLevel                                                                                                         AS [PaymentLevel],
                                    [tblUnitReference].[UnitNo]                                                                                           AS [UnitNo],
                                    [dbo].[fnGetProjectNameById]([tblUnitReference].[ProjectId])                                                          AS [ProjectName],
                                    [RECEIPT].[BankBranch]                                                                                                AS [BankBranch],
                                    CAST(CAST(IIF(@IsFullPayment = 0,
                                                  IIF([tblUnitReference].[Unit_Tax] > 0,
                                                      ([tblUnitReference].[AdvancePaymentAmount]
                                                       + CAST([tblUnitReference].[Unit_BaseRentalTax]
                                                              * [dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2))
                                                      ),
                                                      [tblUnitReference].[AdvancePaymentAmount]),
                                                  [tblUnitReference].[Total]) AS DECIMAL(18, 2))
                                         - CAST(([dbo].[tblUnitReference].[Unit_BaseRentalVatAmount]
                                                 + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                                )
                                                * [dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))    AS [RENTAL_LESS_VAT],
                                    CAST(IIF(@IsFullPayment = 0,
                                             [tblUnitReference].[AdvancePaymentAmount],
                                             [tblUnitReference].[Total]) AS VARCHAR(150))                                                                 AS [RENTAL_LESS_TAX]
                                FROM
                                    [dbo].[tblUnitReference]
                                    CROSS APPLY
                                    (
                                        SELECT
                                            [tblClientMstr].[ClientID]      AS [client_no],
                                            [tblClientMstr].[ClientName]    AS [client_Name],
                                            [tblClientMstr].[PostalAddress] AS [client_Address],
                                            [tblClientMstr].[TIN_No]        AS [TIN_No]
                                        FROM
                                            [dbo].[tblClientMstr]
                                        WHERE
                                            [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
                                    ) [CLIENT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblTransaction].[EncodedDate],
                                            [tblTransaction].[TranID],
                                            ISNULL([dbo].[fn_GetUserName]([tblTransaction].[EncodedBy]), '') AS [USER],
                                            [tblTransaction].[ReceiveAmount]
                                        FROM
                                            [dbo].[tblTransaction]
                                        WHERE
                                            [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                                    ) [TRANSACTION]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblReceipt].[CompanyPRNo] AS [PR_No],
                                            [tblReceipt].[CompanyORNo] AS [OR_No],
                                            [tblReceipt].[Amount]      AS [TOTAL],
                                            [tblReceipt].[BankName]    AS [BankName],
                                            [tblReceipt].[BankBranch]  AS [BankBranch],
                                            [tblReceipt].[REF]         AS [PDC_CHECK_SERIAL],
                                            [tblReceipt].[TranId],
                                            [tblReceipt].[ReceiptDate] AS [TransactionDate]
                                        FROM
                                            [dbo].[tblReceipt]
                                        WHERE
                                            [TRANSACTION].[TranID] = [tblReceipt].[TranId]
                                    ) [RECEIPT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            IIF(@IsFullPayment = 1, 'FULL PAYMENT', @combinedString) AS [PAYMENT_FOR]
                                    ) [PAYMENT]
                                WHERE
                                    [TRANSACTION].[TranID] = @TranID


                END
            IF @Mode = 'SEC'
               AND @PaymentLevel = 'FIRST'
                BEGIN
                    INSERT INTO [#tblRecieptReport]
                        (
                            [client_no],
                            [client_Name],
                            [client_Address],
                            [PR_No],
                            [OR_No],
                            [TIN_No],
                            [TransactionDate],
                            [AmountInWords],
                            [PaymentFor],
                            [TotalAmountInDigit],
                            [RENTAL],
                            [VAT],
                            [VATPct],
                            [TOTAL],
                            [LESSWITHHOLDING],
                            [TOTALAMOUNTDUE],
                            [BANKNAME],
                            [PDCCHECKSERIALNO],
                            [USER],
                            [EncodedDate],
                            [TRANID],
                            [Mode],
                            [PaymentLevel],
                            [UnitNo],
                            [ProjectName],
                            [BankBranch],
                            [RENTAL_LESS_VAT],
                            [RENTAL_LESS_TAX]
                        )
                                SELECT
                                    [CLIENT].[client_no]                                                                                                           AS [client_no],
                                    [CLIENT].[client_Name]                                                                                                         AS [client_Name],
                                    [CLIENT].[client_Address]                                                                                                      AS [client_Address],
                                    [RECEIPT].[PR_No]                                                                                                              AS [PR_No],
                                    [RECEIPT].[OR_No]                                                                                                              AS [OR_No],
                                    [CLIENT].[TIN_No]                                                                                                              AS [TIN_No],
                                    [RECEIPT].[TransactionDate]                                                                                                    AS [TransactionDate],
                                    UPPER([dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[SecDeposit]))                                                     AS [AmountInWords],
                                    [PAYMENT].[PAYMENT_FOR]                                                                                                        AS [PaymentFor],
                                    [tblUnitReference].[SecDeposit]                                                                                                AS [TotalAmountInDigit],
                                    [tblUnitReference].[SecDeposit]
                                    - CAST(([tblUnitReference].[Unit_BaseRentalVatAmount]
                                            + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                           )
                                           * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2))                          AS [RENTAL],
                                    CAST(CAST(([tblUnitReference].[Unit_BaseRentalVatAmount]
                                               + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                              )
                                              * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))      AS [VAT],
                                    CAST(CAST([tblUnitReference].[Unit_Vat] AS INT) AS VARCHAR(10)) + '% VAT'                                                      AS [VATPct],
                                    [tblUnitReference].[SecDeposit]                                                                                                AS [TOTAL],
                                    IIF([tblUnitReference].[Unit_Tax] = 0,
                                        '',
                                        CAST(CAST([tblUnitReference].[Unit_TaxAmount]
                                                  * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))) AS [LESSWITHHOLDING],
                                    [tblUnitReference].[SecDeposit]                                                                                                AS [TOTALAMOUNTDUE],
                                    [RECEIPT].[BankName]                                                                                                           AS [BANKNAME],
                                    [RECEIPT].[PDC_CHECK_SERIAL]                                                                                                   AS [PDCCHECKSERIALNO],
                                    [TRANSACTION].[USER]                                                                                                           AS [USER],
                                    GETDATE()                                                                                                                      AS [EncodedDate],
                                    @TranID                                                                                                                        AS [TRANID],
                                    @Mode                                                                                                                          AS [Mode],
                                    @PaymentLevel                                                                                                                  AS [PaymentLevel],
                                    [tblUnitReference].[UnitNo]                                                                                                    AS [UnitNo],
                                    [dbo].[fnGetProjectNameById]([tblUnitReference].[ProjectId])                                                                   AS [ProjectName],
                                    [RECEIPT].[BankBranch]                                                                                                         AS [BankBranch],
                                    CAST(CAST(IIF([tblUnitReference].[Unit_Tax] > 0,
                                                  ([tblUnitReference].[SecDeposit]
                                                   + CAST([tblUnitReference].[Unit_BaseRentalTax]
                                                          * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2))
                                                  ),
                                                  0) AS DECIMAL(18, 2))
                                         - CAST(([tblUnitReference].[Unit_BaseRentalVatAmount]
                                                 + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                                )
                                                * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))    AS [RENTAL_LESS_VAT],
                                    CAST(CAST([tblUnitReference].[SecDeposit] AS DECIMAL(18, 2)) AS VARCHAR(150))                                                  AS [RENTAL_LESS_TAX]
                                FROM
                                    [dbo].[tblUnitReference]
                                    CROSS APPLY
                                    (
                                        SELECT
                                            [tblClientMstr].[ClientID]      AS [client_no],
                                            [tblClientMstr].[ClientName]    AS [client_Name],
                                            [tblClientMstr].[PostalAddress] AS [client_Address],
                                            [tblClientMstr].[TIN_No]        AS [TIN_No]
                                        FROM
                                            [dbo].[tblClientMstr]
                                        WHERE
                                            [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
                                    ) [CLIENT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblTransaction].[EncodedDate],
                                            [tblTransaction].[TranID],
                                            ISNULL([dbo].[fn_GetUserName]([tblTransaction].[EncodedBy]), '') AS [USER],
                                            [tblTransaction].[ReceiveAmount]
                                        FROM
                                            [dbo].[tblTransaction]
                                        WHERE
                                            [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                                    ) [TRANSACTION]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblReceipt].[CompanyPRNo] AS [PR_No],
                                            [tblReceipt].[CompanyORNo] AS [OR_No],
                                            [tblReceipt].[Amount]      AS [TOTAL],
                                            [tblReceipt].[BankName]    AS [BankName],
                                            [tblReceipt].[BankBranch]  AS [BankBranch],
                                            [tblReceipt].[REF]         AS [PDC_CHECK_SERIAL],
                                            [tblReceipt].[TranId],
                                            [tblReceipt].[ReceiptDate] AS [TransactionDate]
                                        FROM
                                            [dbo].[tblReceipt]
                                        WHERE
                                            [TRANSACTION].[TranID] = [tblReceipt].[TranId]
                                    ) [RECEIPT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            IIF(@IsFullPayment = 1, 'FULL PAYMENT', @combinedString) AS [PAYMENT_FOR]
                                    ) [PAYMENT]
                                WHERE
                                    [TRANSACTION].[TranID] = @TranID


                END



            IF @Mode = 'REN'
               AND @PaymentLevel = 'SECOND'
                BEGIN
                    INSERT INTO [#tblRecieptReport]
                        (
                            [client_no],
                            [client_Name],
                            [client_Address],
                            [PR_No],
                            [OR_No],
                            [TIN_No],
                            [TransactionDate],
                            [AmountInWords],
                            [PaymentFor],
                            [TotalAmountInDigit],
                            [RENTAL],
                            [VAT],
                            [VATPct],
                            [TOTAL],
                            [LESSWITHHOLDING],
                            [TOTALAMOUNTDUE],
                            [BANKNAME],
                            [PDCCHECKSERIALNO],
                            [USER],
                            [EncodedDate],
                            [TRANID],
                            [Mode],
                            [PaymentLevel],
                            [UnitNo],
                            [ProjectName],
                            [BankBranch],
                            [RENTAL_LESS_VAT],
                            [RENTAL_LESS_TAX]
                        )
                                SELECT
                                    [CLIENT].[client_no]                                                      AS [client_no],
                                    [CLIENT].[client_Name]                                                    AS [client_Name],
                                    [CLIENT].[client_Address]                                                 AS [client_Address],
                                    [RECEIPT].[PR_No]                                                         AS [PR_No],
                                    [RECEIPT].[OR_No]                                                         AS [OR_No],
                                    [CLIENT].[TIN_No]                                                         AS [TIN_No],
                                    [RECEIPT].[TransactionDate]                                               AS [TransactionDate],
                                    UPPER([dbo].[fnNumberToWordsWithDecimal]([TRANSACTION].[ReceiveAmount]))  AS [AmountInWords],
                                    [PAYMENT].[PAYMENT_FOR]                                                   AS [PaymentFor],
                                    [TRANSACTION].[ReceiveAmount]                                             AS [TotalAmountInDigit],
                                    [TRANSACTION].[ReceiveAmount]
                                    - [dbo].[fnGetBaseRentalTotalVatAmount](
                                                                               [dbo].[tblUnitReference].[RefId],
                                                                               [TRANSACTION].[AmountToPay],
                                                                               [TRANSACTION].[ReceiveAmount]
                                                                           )                                  AS [RENTAL],
                                    --CAST(CAST((([tblUnitReference].[Unit_Vat] * [TRANSACTION].[ReceiveAmount])
                                    --           / 100
                                    --          ) AS DECIMAL(18, 2)) AS VARCHAR(30))                           AS [VAT],
                                    CAST([dbo].[fnGetBaseRentalTotalVatAmount](
                                                                                  [dbo].[tblUnitReference].[RefId],
                                                                                  [TRANSACTION].[AmountToPay],
                                                                                  [TRANSACTION].[ReceiveAmount]
                                                                              ) AS VARCHAR(150))              AS [VAT],
                                    CAST(CAST([tblUnitReference].[Unit_Vat] AS INT) AS VARCHAR(10)) + '% VAT' AS [VATPct],
                                    [TRANSACTION].[ReceiveAmount]                                             AS [TOTAL],
                                    --IIF([tblUnitReference].[Unit_Tax] > 0,
                                    --    CAST(CAST((([tblUnitReference].[Unit_Tax] * [TRANSACTION].[ReceiveAmount])
                                    --               / 100
                                    --              ) AS DECIMAL(18, 2)) AS VARCHAR(30)),
                                    --    '0.00')                                                              AS [LESSWITHHOLDING],

                                    IIF([tblUnitReference].[Unit_Tax] = 0,
                                        '',
                                        CAST([dbo].[fnGetBaseRentalTotalTaxAmount](
                                                                                      [dbo].[tblUnitReference].[RefId],
                                                                                      [TRANSACTION].[AmountToPay],
                                                                                      [TRANSACTION].[ReceiveAmount]
                                                                                  ) AS VARCHAR(150)))         AS [LESSWITHHOLDING],
                                    [TRANSACTION].[ReceiveAmount]                                             AS [TOTALAMOUNTDUE],
                                    [RECEIPT].[BankName]                                                      AS [BANKNAME],
                                    [RECEIPT].[PDC_CHECK_SERIAL]                                              AS [PDCCHECKSERIALNO],
                                    [TRANSACTION].[USER]                                                      AS [USER],
                                    GETDATE()                                                                 AS [EncodedDate],
                                    @TranID                                                                   AS [TRANID],
                                    @Mode                                                                     AS [Mode],
                                    @PaymentLevel                                                             AS [PaymentLevel],
                                    [tblUnitReference].[UnitNo]                                               AS [UnitNo],
                                    [dbo].[fnGetProjectNameById]([tblUnitReference].[ProjectId])              AS [ProjectName],
                                    [RECEIPT].[BankBranch]                                                    AS [BankBranch],
                                    '0'                                                                       AS [RENTAL_LESS_VAT],
                                    '0'                                                                       AS [RENTAL_LESS_TAX]
                                FROM
                                    [dbo].[tblUnitReference]
                                    CROSS APPLY
                                    (
                                        SELECT
                                            [tblClientMstr].[ClientID]      AS [client_no],
                                            [tblClientMstr].[ClientName]    AS [client_Name],
                                            [tblClientMstr].[PostalAddress] AS [client_Address],
                                            [tblClientMstr].[TIN_No]        AS [TIN_No]
                                        FROM
                                            [dbo].[tblClientMstr]
                                        WHERE
                                            [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
                                    ) [CLIENT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                                [tblTransaction].[EncodedDate],
                                                [tblTransaction].[TranID],
                                                SUM([tblMonthLedger].[LedgRentalAmount])                         AS [AmountToPay],
                                                ISNULL([dbo].[fn_GetUserName]([tblTransaction].[EncodedBy]), '') AS [USER],
                                                SUM([tblPayment].[Amount])                                       AS [ReceiveAmount]
                                        FROM
                                                [dbo].[tblTransaction]
                                            INNER JOIN
                                                [dbo].[tblPayment]
                                                    ON [tblPayment].[TranId] = [tblTransaction].[TranID]
                                            INNER JOIN
                                                [dbo].[tblMonthLedger]
                                                    ON [tblMonthLedger].[Recid] = [tblPayment].[LedgeRecid]
                                        WHERE
                                                [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                                                AND [tblPayment].[Notes] = 'RENTAL NET OF VAT'
                                        GROUP BY
                                                [tblTransaction].[EncodedDate],
                                                [tblTransaction].[TranID],
                                                [tblTransaction].[EncodedBy],
                                                [tblPayment].[Amount],
                                                [tblTransaction].[PaidAmount]
                                    ) [TRANSACTION]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblReceipt].[CompanyPRNo] AS [PR_No],
                                            [tblReceipt].[CompanyORNo] AS [OR_No],
                                            [tblReceipt].[Amount]      AS [TOTAL],
                                            [tblReceipt].[Amount]      AS [TotalAmountInDigit],
                                            [tblReceipt].[BankName]    AS [BankName],
                                            [tblReceipt].[BankBranch]  AS [BankBranch],
                                            [tblReceipt].[REF]         AS [PDC_CHECK_SERIAL],
                                            [tblReceipt].[TranId],
                                            [tblReceipt].[ReceiptDate] AS [TransactionDate]
                                        FROM
                                            [dbo].[tblReceipt]
                                        WHERE
                                            [TRANSACTION].[TranID] = [tblReceipt].[TranId]
                                    ) [RECEIPT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            IIF(@IsFullPayment = 1, 'FULL PAYMENT', @combinedString) AS [PAYMENT_FOR]
                                    ) [PAYMENT]
                                WHERE
                                    [TRANSACTION].[TranID] = @TranID;
                END
            IF @Mode = 'MAIN'
               AND @PaymentLevel = 'SECOND'
                BEGIN
                    INSERT INTO [#tblRecieptReport]
                        (
                            [client_no],
                            [client_Name],
                            [client_Address],
                            [PR_No],
                            [OR_No],
                            [TIN_No],
                            [TransactionDate],
                            [AmountInWords],
                            [PaymentFor],
                            [TotalAmountInDigit],
                            [RENTAL],
                            [VAT],
                            [VATPct],
                            [TOTAL],
                            [LESSWITHHOLDING],
                            [TOTALAMOUNTDUE],
                            [BANKNAME],
                            [PDCCHECKSERIALNO],
                            [USER],
                            [EncodedDate],
                            [TRANID],
                            [Mode],
                            [PaymentLevel],
                            [UnitNo],
                            [ProjectName],
                            [BankBranch],
                            [RENTAL_LESS_VAT],
                            [RENTAL_LESS_TAX]
                        )
                                SELECT
                                    [CLIENT].[client_no]                                                                                                 AS [client_no],
                                    [CLIENT].[client_Name]                                                                                               AS [client_Name],
                                    [CLIENT].[client_Address]                                                                                            AS [client_Address],
                                    [RECEIPT].[PR_No]                                                                                                    AS [PR_No],
                                    [RECEIPT].[OR_No]                                                                                                    AS [OR_No],
                                    [CLIENT].[TIN_No]                                                                                                    AS [TIN_No],
                                    [RECEIPT].[TransactionDate]                                                                                          AS [TransactionDate],
                                    UPPER([dbo].[fnNumberToWordsWithDecimal]([TRANSACTION].[ReceiveAmount]))                                             AS [AmountInWords],
                                    [PAYMENT].[PAYMENT_FOR]                                                                                              AS [PaymentFor],
                                    [TRANSACTION].[ReceiveAmount]                                                                                        AS [TotalAmountInDigit],
                                    [TRANSACTION].[ReceiveAmount]
                                    - CAST((([tblUnitReference].[Unit_Vat] * [TRANSACTION].[ReceiveAmount]) / 100) AS DECIMAL(18, 2))                    AS [RENTAL],
                                    CAST(CAST((([tblUnitReference].[Unit_Vat] * [TRANSACTION].[ReceiveAmount]) / 100) AS DECIMAL(18, 2)) AS VARCHAR(30)) AS [VAT], --TAX WILL FOLLOW
                                    CAST(CAST([tblUnitReference].[Unit_Vat] AS INT) AS VARCHAR(10)) + '% VAT'                                            AS [VATPct],
                                    [TRANSACTION].[ReceiveAmount]                                                                                        AS [TOTAL],
                                    IIF([tblUnitReference].[Unit_Tax] > 0,
                                        CAST(CAST((([tblUnitReference].[Unit_Tax] * [TRANSACTION].[ReceiveAmount])
                                                   / 100
                                                  ) AS DECIMAL(18, 2)) AS VARCHAR(30)),
                                        '')                                                                                                              AS [LESSWITHHOLDING],
                                    [TRANSACTION].[ReceiveAmount]                                                                                        AS [TOTALAMOUNTDUE],
                                    [RECEIPT].[BankName]                                                                                                 AS [BANKNAME],
                                    [RECEIPT].[PDC_CHECK_SERIAL]                                                                                         AS [PDCCHECKSERIALNO],
                                    [TRANSACTION].[USER]                                                                                                 AS [USER],
                                    GETDATE()                                                                                                            AS [EncodedDate],
                                    @TranID                                                                                                              AS [TRANID],
                                    @Mode                                                                                                                AS [Mode],
                                    @PaymentLevel                                                                                                        AS [PaymentLevel],
                                    [tblUnitReference].[UnitNo]                                                                                          AS [UnitNo],
                                    [dbo].[fnGetProjectNameById]([tblUnitReference].[ProjectId])                                                         AS [ProjectName],
                                    [RECEIPT].[BankBranch]                                                                                               AS [BankBranch],
                                    '0'                                                                                                                  AS [RENTAL_LESS_VAT],
                                    '0'                                                                                                                  AS [RENTAL_LESS_TAX]
                                FROM
                                    [dbo].[tblUnitReference]
                                    CROSS APPLY
                                    (
                                        SELECT
                                            [tblClientMstr].[ClientID]      AS [client_no],
                                            [tblClientMstr].[ClientName]    AS [client_Name],
                                            [tblClientMstr].[PostalAddress] AS [client_Address],
                                            [tblClientMstr].[TIN_No]        AS [TIN_No]
                                        FROM
                                            [dbo].[tblClientMstr]
                                        WHERE
                                            [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
                                    ) [CLIENT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                                [tblTransaction].[EncodedDate],
                                                [tblTransaction].[TranID],
                                                ISNULL([dbo].[fn_GetUserName]([tblTransaction].[EncodedBy]), '') AS [USER],
                                                SUM([tblPayment].[Amount])                                       AS [ReceiveAmount]
                                        FROM
                                                [dbo].[tblTransaction]
                                            INNER JOIN
                                                [dbo].[tblPayment]
                                                    ON [tblPayment].[TranId] = [tblTransaction].[TranID]
                                        WHERE
                                                [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                                                AND [tblPayment].[Notes] = 'SECURITY AND MAINTENANCE NET OF VAT'
                                        GROUP BY
                                                [tblTransaction].[EncodedDate],
                                                [tblTransaction].[TranID],
                                                [tblTransaction].[EncodedBy],
                                                [tblPayment].[Amount]
                                    ) [TRANSACTION]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblReceipt].[CompanyPRNo] AS [PR_No],
                                            [tblReceipt].[CompanyORNo] AS [OR_No],
                                            [tblReceipt].[Amount]      AS [TOTAL],
                                            [tblReceipt].[Amount]      AS [TotalAmountInDigit],
                                            [tblReceipt].[BankName]    AS [BankName],
                                            [tblReceipt].[BankBranch]  AS [BankBranch],
                                            [tblReceipt].[REF]         AS [PDC_CHECK_SERIAL],
                                            [tblReceipt].[TranId],
                                            [tblReceipt].[ReceiptDate] AS [TransactionDate]
                                        FROM
                                            [dbo].[tblReceipt]
                                        WHERE
                                            [TRANSACTION].[TranID] = [tblReceipt].[TranId]
                                    ) [RECEIPT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            IIF(@IsFullPayment = 1, 'FULL PAYMENT', @combinedString) AS [PAYMENT_FOR]
                                    ) [PAYMENT]
                                WHERE
                                    [TRANSACTION].[TranID] = @TranID;
                END





        END


        SELECT
            [#tblRecieptReport].[client_no],
            [#tblRecieptReport].[client_Name],
            [#tblRecieptReport].[client_Address],
            [#tblRecieptReport].[PR_No],
            [#tblRecieptReport].[OR_No],
            [#tblRecieptReport].[TIN_No],
            CAST(CONVERT(VARCHAR(15), [#tblRecieptReport].[TransactionDate], 107) AS VARCHAR(150)) AS [TransactionDate],
            [#tblRecieptReport].[AmountInWords],
            ISNULL([#tblRecieptReport].[PaymentFor], '')                                           AS [PaymentFor],
            --FORMAT(CAST([#TMP].[TotalAmountInDigit] AS DECIMAL(18, 2)), 'C', 'en-PH') AS [TotalAmountInDigit],
            FORMAT(CAST([#tblRecieptReport].[TotalAmountInDigit] AS DECIMAL(18, 2)), 'N')          AS [TotalAmountInDigit],
            --FORMAT(CAST([#TMP].[RENTAL] AS DECIMAL(18, 2)), 'C', 'en-PH') AS [RENTAL],
            FORMAT(CAST([#tblRecieptReport].[RENTAL] AS DECIMAL(18, 2)), 'C', 'en-PH')             AS [RENTAL],
            FORMAT(CAST([#tblRecieptReport].[VAT] AS DECIMAL(18, 2)), 'C', 'en-PH')                AS [VAT],
            [#tblRecieptReport].[VATPct],
            FORMAT(CAST([#tblRecieptReport].[RENTAL] AS DECIMAL(18, 2)), 'C', 'en-PH')             AS [TOTAL],
            --FORMAT(CAST([tblRecieptReport].[LESSWITHHOLDING] AS DECIMAL(18, 2)), 'C', 'en-PH') AS [LESSWITHHOLDING],
            [#tblRecieptReport].[LESSWITHHOLDING]                                                  AS [LESSWITHHOLDING],
            IIF([#tblRecieptReport].[LESSWITHHOLDING] <> '', 'LESS WITHHOLDING', '')               AS [LESSWITHHOLDING_label],
            --[#TMP].[LESSWITHHOLDING] AS [LESSWITHHOLDING],
            FORMAT(CAST([#tblRecieptReport].[TOTALAMOUNTDUE] AS DECIMAL(18, 2)), 'C', 'en-PH')     AS [TOTALAMOUNTDUE],
            [#tblRecieptReport].[BANKNAME],
            [#tblRecieptReport].[PDCCHECKSERIALNO],
            [#tblRecieptReport].[USER],
            [#tblRecieptReport].[Mode],
            [#tblRecieptReport].[UnitNo],
            [#tblRecieptReport].[ProjectName],
            [#tblRecieptReport].[BankBranch],
            ''                                                                                     AS [BankCheckDate],
            ''                                                                                     AS [BankCheckAmount],
            [#tblRecieptReport].[RENTAL_LESS_VAT],
            [#tblRecieptReport].[RENTAL_LESS_TAX]
        FROM
            [#tblRecieptReport]
        --WHERE
        --       [tblRecieptReport].[TRANID] = @TranID
        --       AND [tblRecieptReport].[Mode] = @Mode
        --       AND [tblRecieptReport].[PaymentLevel] = @PaymentLevel
        ORDER BY
            [#tblRecieptReport].[EncodedDate]

    END;

    DROP TABLE [#tblRecieptReport]
GO
/****** Object:  StoredProcedure [dbo].[sp_Ongching_OR_Report]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE   PROCEDURE [dbo].[sp_Ongching_OR_Report]
     @TranID       VARCHAR(20) = NULL,
    @Mode         VARCHAR(50) = NULL,
    @PaymentLevel VARCHAR(50) = NULL
AS
    BEGIN
        SET NOCOUNT ON;



        CREATE TABLE [#tblRecieptReport]
            (
                [client_no]          [VARCHAR](500)  NULL,
                [client_Name]        [VARCHAR](500)  NULL,
                [client_Address]     [VARCHAR](5000) NULL,
                [PR_No]              [VARCHAR](500)  NULL,
                [OR_No]              [VARCHAR](500)  NULL,
                [TIN_No]             [VARCHAR](500)  NULL,
                [TransactionDate]    [DATETIME]      NULL,
                [AmountInWords]      [VARCHAR](5000) NULL,
                [PaymentFor]         [VARCHAR](500)  NULL,
                [TotalAmountInDigit] [VARCHAR](100)  NULL,
                [RENTAL]             [VARCHAR](500)  NULL,
                [VAT]                [VARCHAR](500)  NULL,
                [VATPct]             [VARCHAR](500)  NULL,
                [TOTAL]              [VARCHAR](500)  NULL,
                [LESSWITHHOLDING]    [VARCHAR](500)  NULL,
                [TOTALAMOUNTDUE]     [VARCHAR](500)  NULL,
                [BANKNAME]           [VARCHAR](500)  NULL,
                [PDCCHECKSERIALNO]   [VARCHAR](500)  NULL,
                [USER]               [VARCHAR](500)  NULL,
                [EncodedDate]        [DATETIME]      NULL,
                [TRANID]             [VARCHAR](500)  NULL,
                [Mode]               [VARCHAR](500)  NULL,
                [PaymentLevel]       [VARCHAR](100)  NULL,
                [UnitNo]             [VARCHAR](150)  NULL,
                [ProjectName]        [VARCHAR](150)  NULL,
                [BankBranch]         [VARCHAR](150)  NULL,
                [RENTAL_LESS_VAT]    [VARCHAR](150)  NULL,
                [RENTAL_LESS_TAX]    [VARCHAR](150)  NULL
            )

        DECLARE @UnitCategory VARCHAR(150) = ''
        DECLARE @combinedString VARCHAR(MAX);
        DECLARE @IsFullPayment BIT = 0;
        DECLARE @RefId VARCHAR(100) = '';

        SELECT
            @UnitCategory = [dbo].[fnGetUnitCategoryByUnitId]([tblUnitReference].[UnitId])
        FROM
            [dbo].[tblUnitReference]
        WHERE
            [tblUnitReference].[RefId] =
            (
                SELECT
                    [tblTransaction].[RefId]
                FROM
                    [dbo].[tblTransaction]
                WHERE
                    [tblTransaction].[TranID] = @TranID
            )

        BEGIN
            SELECT
                @IsFullPayment = ISNULL([tblUnitReference].[IsFullPayment], 0),
                @RefId         = [tblUnitReference].[RefId]
            FROM
                [dbo].[tblUnitReference]
            WHERE
                [tblUnitReference].[RefId] =
                (
                    SELECT TOP 1
                           [tblTransaction].[RefId]
                    FROM
                           [dbo].[tblTransaction]
                    WHERE
                           [tblTransaction].[TranID] = @TranID
                );

            IF @IsFullPayment = 0
                BEGIN
                    IF
                        (
                            SELECT
                                COUNT(*)
                            FROM
                                [dbo].[tblPayment]
                            WHERE
                                [tblPayment].[TranId] = @TranID
                                AND [tblPayment].[Remarks] NOT IN (
                                                                      'SECURITY DEPOSIT'
                                                                  )
                        ) > 5
                        BEGIN
                            IF @Mode = 'REN'
                               AND @PaymentLevel = 'SECOND'
                                BEGIN
                                    SELECT
                                        @combinedString
                                        = 'RENTAL FOR '
                                          +
                                        (
                                            SELECT  TOP 1
                                                    UPPER(DATENAME(MONTH, MIN([tblPayment].[ForMonth]))) + ' '
                                                    + CAST(YEAR(MIN([tblPayment].[ForMonth])) AS VARCHAR(4))
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'RENTAL NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        ) + ' TO '
                                          +
                                        (
                                            SELECT  TOP 1
                                                    UPPER(DATENAME(MONTH, MAX([tblPayment].[ForMonth]))) + ' '
                                                    + CAST(YEAR(MAX([tblPayment].[ForMonth])) AS VARCHAR(4))
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'RENTAL NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        )
                                END

                            IF @Mode = 'MAIN'
                               AND @PaymentLevel = 'SECOND'
                                BEGIN

                                    SELECT
                                        @combinedString
                                        = 'SECURITY & MAINTENANCE FOR'
                                          +
                                        (
                                            SELECT  TOP 1
                                                    UPPER(DATENAME(MONTH, MIN([tblPayment].[ForMonth]))) + ' '
                                                    + CAST(YEAR(MIN([tblPayment].[ForMonth])) AS VARCHAR(4))
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'SECURITY AND MAINTENANCE NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        ) + ' TO '
                                          +
                                        (
                                            SELECT  TOP 1
                                                    UPPER(DATENAME(MONTH, MAX([tblPayment].[ForMonth]))) + ' '
                                                    + CAST(YEAR(MAX([tblPayment].[ForMonth])) AS VARCHAR(4))
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'SECURITY AND MAINTENANCE NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        )
                                END

                        END
                    ELSE
                        BEGIN
                            IF @Mode = 'SEC'
                               AND @PaymentLevel = 'FIRST'
                                BEGIN
                                    SELECT
                                        --@combinedString
                                        --= '('
                                        --  + CAST(CAST([dbo].[fnGetTotalSecDepositAmountCount](@RefId) AS INT) AS VARCHAR(50))
                                        --  + ')MONTH-SECURITY DEPOSIT'
                                        @combinedString = ' SECURITY DEPOSIT '

                                END
                            ELSE IF @Mode = 'ADV'
                                    AND @PaymentLevel = 'FIRST'
                                BEGIN
                                    --SELECT @combinedString = 'ADVANCE PAYMENT'
                                    BEGIN
                                        SELECT
                                            @combinedString
                                            = COALESCE(@combinedString + '-', '')
                                              + UPPER(DATENAME(MONTH, [tblPayment].[ForMonth])) + ' '
                                              + CAST(YEAR([tblPayment].[ForMonth]) AS VARCHAR(4))
                                        FROM
                                            [dbo].[tblPayment]
                                        WHERE
                                            [tblPayment].[TranId] = @TranID
                                            AND [tblPayment].[Remarks] = 'MONTHS ADVANCE'
                                            AND ISNULL([tblPayment].[Notes], '') = ''


                                    END
                                END
                            ELSE
                                BEGIN

                                    IF @Mode = 'REN'
                                       AND @PaymentLevel = 'SECOND'
                                        BEGIN
                                            SELECT
                                                    @combinedString
                                                = IIF(@UnitCategory = 'PARKING', 'PS RENTAL FOR', 'RENTAL FOR ')
                                                  --+ COALESCE(@combinedString + '-', '')
                                                  + UPPER(DATENAME(MONTH, [tblPayment].[ForMonth])) + ' '
                                                  + CAST(YEAR([tblPayment].[ForMonth]) AS VARCHAR(4))
                                                  + IIF(ISNULL([tblMonthLedger].[IsHold], 0) = 1, '(PARTIAL)', '')
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'RENTAL NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        END
                                    IF @Mode = 'MAIN'
                                       AND @PaymentLevel = 'SECOND'
                                        BEGIN
                                            SELECT
                                                    @combinedString
                                                = 'SECURITY & MAINTENANCE FOR '
                                                  --+ COALESCE(@combinedString + '-', '')
                                                  + UPPER(DATENAME(MONTH, [tblPayment].[ForMonth])) + ' '
                                                  + CAST(YEAR([tblPayment].[ForMonth]) AS VARCHAR(4))
                                                  + IIF(ISNULL([tblMonthLedger].[IsHold], 0) = 1, '(PARTIAL)', '')
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'SECURITY AND MAINTENANCE NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        END


                                END
                        END
                END;


            IF @Mode = 'ADV'
               AND @PaymentLevel = 'FIRST'
                BEGIN
                    INSERT INTO [#tblRecieptReport]
                        (
                            [client_no],
                            [client_Name],
                            [client_Address],
                            [PR_No],
                            [OR_No],
                            [TIN_No],
                            [TransactionDate],
                            [AmountInWords],
                            [PaymentFor],      --PAYMENT DESCRIPTION
                            [TotalAmountInDigit],
                            [RENTAL],
                            [VAT],             --VAT AMOUNT
                            [VATPct],
                            [TOTAL],
                            [LESSWITHHOLDING], --TAX AMOUNT
                            [TOTALAMOUNTDUE],
                            [BANKNAME],
                            [PDCCHECKSERIALNO],
                            [USER],
                            [EncodedDate],
                            [TRANID],
                            [Mode],
                            [PaymentLevel],
                            [UnitNo],
                            [ProjectName],
                            [BankBranch],
                            [RENTAL_LESS_VAT],
                            [RENTAL_LESS_TAX]
                        )
                                SELECT
                                    [CLIENT].[client_no]                                                                                                  AS [client_no],
                                    [CLIENT].[client_Name]                                                                                                AS [client_Name],
                                    [CLIENT].[client_Address]                                                                                             AS [client_Address],
                                    [RECEIPT].[PR_No]                                                                                                     AS [PR_No],
                                    [RECEIPT].[OR_No]                                                                                                     AS [OR_No],
                                    [CLIENT].[TIN_No]                                                                                                     AS [TIN_No],
                                    [RECEIPT].[TransactionDate]                                                                                           AS [TransactionDate],
                                    UPPER([dbo].[fnNumberToWordsWithDecimal](IIF(@IsFullPayment = 0,
                                                                                 [tblUnitReference].[AdvancePaymentAmount],
                                                                                 [tblUnitReference].[Total])
                                                                            )
                                         )                                                                                                                AS [AmountInWords],
                                    [PAYMENT].[PAYMENT_FOR]                                                                                               AS [PaymentFor],
                                    IIF(@IsFullPayment = 0,
                                        [tblUnitReference].[AdvancePaymentAmount],
                                        [tblUnitReference].[Total])                                                                                       AS [TotalAmountInDigit],
                                    IIF(@IsFullPayment = 0,
                                        [tblUnitReference].[AdvancePaymentAmount],
                                        [tblUnitReference].[Total])
                                    - (([tblUnitReference].[Unit_BaseRentalVatAmount]
                                        + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                       )
                                       * CAST([dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2))
                                      )                                                                                                                   AS [RENTAL],
                                    CAST(([tblUnitReference].[Unit_BaseRentalVatAmount]
                                          + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                         )
                                         * CAST([dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))      AS [VAT_AMOUNT],
                                    CAST(CAST([tblUnitReference].[Unit_Vat] AS INT) AS VARCHAR(10)) + '% VAT'                                             AS [VATPct],
                                    IIF(@IsFullPayment = 0,
                                        [tblUnitReference].[AdvancePaymentAmount],
                                        [tblUnitReference].[Total])                                                                                       AS [TOTAL],
                                    IIF([tblUnitReference].[Unit_Tax] = 0,
                                        '',
                                        CAST([tblUnitReference].[Unit_BaseRentalTax]
                                             * CAST([dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))) AS [LESSWITHHOLDING],
                                    [tblUnitReference].[AdvancePaymentAmount]                                                                             AS [TOTALAMOUNTDUE],
                                    [RECEIPT].[BankName]                                                                                                  AS [BANKNAME],
                                    [RECEIPT].[PDC_CHECK_SERIAL]                                                                                          AS [PDCCHECKSERIALNO],
                                    [TRANSACTION].[USER]                                                                                                  AS [USER],
                                    GETDATE()                                                                                                             AS [EncodedDate],
                                    @TranID                                                                                                               AS [TRANID],
                                    @Mode                                                                                                                 AS [Mode],
                                    @PaymentLevel                                                                                                         AS [PaymentLevel],
                                    [tblUnitReference].[UnitNo]                                                                                           AS [UnitNo],
                                    [dbo].[fnGetProjectNameById]([tblUnitReference].[ProjectId])                                                          AS [ProjectName],
                                    [RECEIPT].[BankBranch]                                                                                                AS [BankBranch],
                                    CAST(CAST(IIF(@IsFullPayment = 0,
                                                  IIF([tblUnitReference].[Unit_Tax] > 0,
                                                      ([tblUnitReference].[AdvancePaymentAmount]
                                                       + CAST([tblUnitReference].[Unit_BaseRentalTax]
                                                              * [dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2))
                                                      ),
                                                      [tblUnitReference].[AdvancePaymentAmount]),
                                                  [tblUnitReference].[Total]) AS DECIMAL(18, 2))
                                         - CAST(([dbo].[tblUnitReference].[Unit_BaseRentalVatAmount]
                                                 + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                                )
                                                * [dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))    AS [RENTAL_LESS_VAT],
                                    CAST(IIF(@IsFullPayment = 0,
                                             [tblUnitReference].[AdvancePaymentAmount],
                                             [tblUnitReference].[Total]) AS VARCHAR(150))                                                                 AS [RENTAL_LESS_TAX]
                                FROM
                                    [dbo].[tblUnitReference]
                                    CROSS APPLY
                                    (
                                        SELECT
                                            [tblClientMstr].[ClientID]      AS [client_no],
                                            [tblClientMstr].[ClientName]    AS [client_Name],
                                            [tblClientMstr].[PostalAddress] AS [client_Address],
                                            [tblClientMstr].[TIN_No]        AS [TIN_No]
                                        FROM
                                            [dbo].[tblClientMstr]
                                        WHERE
                                            [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
                                    ) [CLIENT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblTransaction].[EncodedDate],
                                            [tblTransaction].[TranID],
                                            ISNULL([dbo].[fn_GetUserName]([tblTransaction].[EncodedBy]), '') AS [USER],
                                            [tblTransaction].[ReceiveAmount]
                                        FROM
                                            [dbo].[tblTransaction]
                                        WHERE
                                            [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                                    ) [TRANSACTION]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblReceipt].[CompanyPRNo] AS [PR_No],
                                            [tblReceipt].[CompanyORNo] AS [OR_No],
                                            [tblReceipt].[Amount]      AS [TOTAL],
                                            [tblReceipt].[BankName]    AS [BankName],
                                            [tblReceipt].[BankBranch]  AS [BankBranch],
                                            [tblReceipt].[REF]         AS [PDC_CHECK_SERIAL],
                                            [tblReceipt].[TranId],
                                            [tblReceipt].[ReceiptDate] AS [TransactionDate]
                                        FROM
                                            [dbo].[tblReceipt]
                                        WHERE
                                            [TRANSACTION].[TranID] = [tblReceipt].[TranId]
                                    ) [RECEIPT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            IIF(@IsFullPayment = 1, 'FULL PAYMENT', @combinedString) AS [PAYMENT_FOR]
                                    ) [PAYMENT]
                                WHERE
                                    [TRANSACTION].[TranID] = @TranID


                END
            IF @Mode = 'SEC'
               AND @PaymentLevel = 'FIRST'
                BEGIN
                    INSERT INTO [#tblRecieptReport]
                        (
                            [client_no],
                            [client_Name],
                            [client_Address],
                            [PR_No],
                            [OR_No],
                            [TIN_No],
                            [TransactionDate],
                            [AmountInWords],
                            [PaymentFor],
                            [TotalAmountInDigit],
                            [RENTAL],
                            [VAT],
                            [VATPct],
                            [TOTAL],
                            [LESSWITHHOLDING],
                            [TOTALAMOUNTDUE],
                            [BANKNAME],
                            [PDCCHECKSERIALNO],
                            [USER],
                            [EncodedDate],
                            [TRANID],
                            [Mode],
                            [PaymentLevel],
                            [UnitNo],
                            [ProjectName],
                            [BankBranch],
                            [RENTAL_LESS_VAT],
                            [RENTAL_LESS_TAX]
                        )
                                SELECT
                                    [CLIENT].[client_no]                                                                                                           AS [client_no],
                                    [CLIENT].[client_Name]                                                                                                         AS [client_Name],
                                    [CLIENT].[client_Address]                                                                                                      AS [client_Address],
                                    [RECEIPT].[PR_No]                                                                                                              AS [PR_No],
                                    [RECEIPT].[OR_No]                                                                                                              AS [OR_No],
                                    [CLIENT].[TIN_No]                                                                                                              AS [TIN_No],
                                    [RECEIPT].[TransactionDate]                                                                                                    AS [TransactionDate],
                                    UPPER([dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[SecDeposit]))                                                     AS [AmountInWords],
                                    [PAYMENT].[PAYMENT_FOR]                                                                                                        AS [PaymentFor],
                                    [tblUnitReference].[SecDeposit]                                                                                                AS [TotalAmountInDigit],
                                    [tblUnitReference].[SecDeposit]
                                    - CAST(([tblUnitReference].[Unit_BaseRentalVatAmount]
                                            + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                           )
                                           * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2))                          AS [RENTAL],
                                    CAST(CAST(([tblUnitReference].[Unit_BaseRentalVatAmount]
                                               + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                              )
                                              * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))      AS [VAT],
                                    CAST(CAST([tblUnitReference].[Unit_Vat] AS INT) AS VARCHAR(10)) + '% VAT'                                                      AS [VATPct],
                                    [tblUnitReference].[SecDeposit]                                                                                                AS [TOTAL],
                                    IIF([tblUnitReference].[Unit_Tax] = 0,
                                        '',
                                        CAST(CAST([tblUnitReference].[Unit_TaxAmount]
                                                  * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))) AS [LESSWITHHOLDING],
                                    [tblUnitReference].[SecDeposit]                                                                                                AS [TOTALAMOUNTDUE],
                                    [RECEIPT].[BankName]                                                                                                           AS [BANKNAME],
                                    [RECEIPT].[PDC_CHECK_SERIAL]                                                                                                   AS [PDCCHECKSERIALNO],
                                    [TRANSACTION].[USER]                                                                                                           AS [USER],
                                    GETDATE()                                                                                                                      AS [EncodedDate],
                                    @TranID                                                                                                                        AS [TRANID],
                                    @Mode                                                                                                                          AS [Mode],
                                    @PaymentLevel                                                                                                                  AS [PaymentLevel],
                                    [tblUnitReference].[UnitNo]                                                                                                    AS [UnitNo],
                                    [dbo].[fnGetProjectNameById]([tblUnitReference].[ProjectId])                                                                   AS [ProjectName],
                                    [RECEIPT].[BankBranch]                                                                                                         AS [BankBranch],
                                    CAST(CAST(IIF([tblUnitReference].[Unit_Tax] > 0,
                                                  ([tblUnitReference].[SecDeposit]
                                                   + CAST([tblUnitReference].[Unit_BaseRentalTax]
                                                          * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2))
                                                  ),
                                                  0) AS DECIMAL(18, 2))
                                         - CAST(([tblUnitReference].[Unit_BaseRentalVatAmount]
                                                 + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                                )
                                                * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))    AS [RENTAL_LESS_VAT],
                                    CAST(CAST([tblUnitReference].[SecDeposit] AS DECIMAL(18, 2)) AS VARCHAR(150))                                                  AS [RENTAL_LESS_TAX]
                                FROM
                                    [dbo].[tblUnitReference]
                                    CROSS APPLY
                                    (
                                        SELECT
                                            [tblClientMstr].[ClientID]      AS [client_no],
                                            [tblClientMstr].[ClientName]    AS [client_Name],
                                            [tblClientMstr].[PostalAddress] AS [client_Address],
                                            [tblClientMstr].[TIN_No]        AS [TIN_No]
                                        FROM
                                            [dbo].[tblClientMstr]
                                        WHERE
                                            [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
                                    ) [CLIENT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblTransaction].[EncodedDate],
                                            [tblTransaction].[TranID],
                                            ISNULL([dbo].[fn_GetUserName]([tblTransaction].[EncodedBy]), '') AS [USER],
                                            [tblTransaction].[ReceiveAmount]
                                        FROM
                                            [dbo].[tblTransaction]
                                        WHERE
                                            [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                                    ) [TRANSACTION]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblReceipt].[CompanyPRNo] AS [PR_No],
                                            [tblReceipt].[CompanyORNo] AS [OR_No],
                                            [tblReceipt].[Amount]      AS [TOTAL],
                                            [tblReceipt].[BankName]    AS [BankName],
                                            [tblReceipt].[BankBranch]  AS [BankBranch],
                                            [tblReceipt].[REF]         AS [PDC_CHECK_SERIAL],
                                            [tblReceipt].[TranId],
                                            [tblReceipt].[ReceiptDate] AS [TransactionDate]
                                        FROM
                                            [dbo].[tblReceipt]
                                        WHERE
                                            [TRANSACTION].[TranID] = [tblReceipt].[TranId]
                                    ) [RECEIPT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            IIF(@IsFullPayment = 1, 'FULL PAYMENT', @combinedString) AS [PAYMENT_FOR]
                                    ) [PAYMENT]
                                WHERE
                                    [TRANSACTION].[TranID] = @TranID


                END



            IF @Mode = 'REN'
               AND @PaymentLevel = 'SECOND'
                BEGIN
                    INSERT INTO [#tblRecieptReport]
                        (
                            [client_no],
                            [client_Name],
                            [client_Address],
                            [PR_No],
                            [OR_No],
                            [TIN_No],
                            [TransactionDate],
                            [AmountInWords],
                            [PaymentFor],
                            [TotalAmountInDigit],
                            [RENTAL],
                            [VAT],
                            [VATPct],
                            [TOTAL],
                            [LESSWITHHOLDING],
                            [TOTALAMOUNTDUE],
                            [BANKNAME],
                            [PDCCHECKSERIALNO],
                            [USER],
                            [EncodedDate],
                            [TRANID],
                            [Mode],
                            [PaymentLevel],
                            [UnitNo],
                            [ProjectName],
                            [BankBranch],
                            [RENTAL_LESS_VAT],
                            [RENTAL_LESS_TAX]
                        )
                                SELECT
                                    [CLIENT].[client_no]                                                      AS [client_no],
                                    [CLIENT].[client_Name]                                                    AS [client_Name],
                                    [CLIENT].[client_Address]                                                 AS [client_Address],
                                    [RECEIPT].[PR_No]                                                         AS [PR_No],
                                    [RECEIPT].[OR_No]                                                         AS [OR_No],
                                    [CLIENT].[TIN_No]                                                         AS [TIN_No],
                                    [RECEIPT].[TransactionDate]                                               AS [TransactionDate],
                                    UPPER([dbo].[fnNumberToWordsWithDecimal]([TRANSACTION].[ReceiveAmount]))  AS [AmountInWords],
                                    [PAYMENT].[PAYMENT_FOR]                                                   AS [PaymentFor],
                                    [TRANSACTION].[ReceiveAmount]                                             AS [TotalAmountInDigit],
                                    [TRANSACTION].[ReceiveAmount]
                                    - [dbo].[fnGetBaseRentalTotalVatAmount](
                                                                               [dbo].[tblUnitReference].[RefId],
                                                                               [TRANSACTION].[AmountToPay],
                                                                               [TRANSACTION].[ReceiveAmount]
                                                                           )                                  AS [RENTAL],
                                    --CAST(CAST((([tblUnitReference].[Unit_Vat] * [TRANSACTION].[ReceiveAmount])
                                    --           / 100
                                    --          ) AS DECIMAL(18, 2)) AS VARCHAR(30))                           AS [VAT],
                                    CAST([dbo].[fnGetBaseRentalTotalVatAmount](
                                                                                  [dbo].[tblUnitReference].[RefId],
                                                                                  [TRANSACTION].[AmountToPay],
                                                                                  [TRANSACTION].[ReceiveAmount]
                                                                              ) AS VARCHAR(150))              AS [VAT],
                                    CAST(CAST([tblUnitReference].[Unit_Vat] AS INT) AS VARCHAR(10)) + '% VAT' AS [VATPct],
                                    [TRANSACTION].[ReceiveAmount]                                             AS [TOTAL],
                                    --IIF([tblUnitReference].[Unit_Tax] > 0,
                                    --    CAST(CAST((([tblUnitReference].[Unit_Tax] * [TRANSACTION].[ReceiveAmount])
                                    --               / 100
                                    --              ) AS DECIMAL(18, 2)) AS VARCHAR(30)),
                                    --    '0.00')                                                              AS [LESSWITHHOLDING],

                                    IIF([tblUnitReference].[Unit_Tax] = 0,
                                        '',
                                        CAST([dbo].[fnGetBaseRentalTotalTaxAmount](
                                                                                      [dbo].[tblUnitReference].[RefId],
                                                                                      [TRANSACTION].[AmountToPay],
                                                                                      [TRANSACTION].[ReceiveAmount]
                                                                                  ) AS VARCHAR(150)))         AS [LESSWITHHOLDING],
                                    [TRANSACTION].[ReceiveAmount]                                             AS [TOTALAMOUNTDUE],
                                    [RECEIPT].[BankName]                                                      AS [BANKNAME],
                                    [RECEIPT].[PDC_CHECK_SERIAL]                                              AS [PDCCHECKSERIALNO],
                                    [TRANSACTION].[USER]                                                      AS [USER],
                                    GETDATE()                                                                 AS [EncodedDate],
                                    @TranID                                                                   AS [TRANID],
                                    @Mode                                                                     AS [Mode],
                                    @PaymentLevel                                                             AS [PaymentLevel],
                                    [tblUnitReference].[UnitNo]                                               AS [UnitNo],
                                    [dbo].[fnGetProjectNameById]([tblUnitReference].[ProjectId])              AS [ProjectName],
                                    [RECEIPT].[BankBranch]                                                    AS [BankBranch],
                                    '0'                                                                       AS [RENTAL_LESS_VAT],
                                    '0'                                                                       AS [RENTAL_LESS_TAX]
                                FROM
                                    [dbo].[tblUnitReference]
                                    CROSS APPLY
                                    (
                                        SELECT
                                            [tblClientMstr].[ClientID]      AS [client_no],
                                            [tblClientMstr].[ClientName]    AS [client_Name],
                                            [tblClientMstr].[PostalAddress] AS [client_Address],
                                            [tblClientMstr].[TIN_No]        AS [TIN_No]
                                        FROM
                                            [dbo].[tblClientMstr]
                                        WHERE
                                            [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
                                    ) [CLIENT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                                [tblTransaction].[EncodedDate],
                                                [tblTransaction].[TranID],
                                                SUM([tblMonthLedger].[LedgRentalAmount])                         AS [AmountToPay],
                                                ISNULL([dbo].[fn_GetUserName]([tblTransaction].[EncodedBy]), '') AS [USER],
                                                SUM([tblPayment].[Amount])                                       AS [ReceiveAmount]
                                        FROM
                                                [dbo].[tblTransaction]
                                            INNER JOIN
                                                [dbo].[tblPayment]
                                                    ON [tblPayment].[TranId] = [tblTransaction].[TranID]
                                            INNER JOIN
                                                [dbo].[tblMonthLedger]
                                                    ON [tblMonthLedger].[Recid] = [tblPayment].[LedgeRecid]
                                        WHERE
                                                [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                                                AND [tblPayment].[Notes] = 'RENTAL NET OF VAT'
                                        GROUP BY
                                                [tblTransaction].[EncodedDate],
                                                [tblTransaction].[TranID],
                                                [tblTransaction].[EncodedBy],
                                                [tblPayment].[Amount],
                                                [tblTransaction].[PaidAmount]
                                    ) [TRANSACTION]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblReceipt].[CompanyPRNo] AS [PR_No],
                                            [tblReceipt].[CompanyORNo] AS [OR_No],
                                            [tblReceipt].[Amount]      AS [TOTAL],
                                            [tblReceipt].[Amount]      AS [TotalAmountInDigit],
                                            [tblReceipt].[BankName]    AS [BankName],
                                            [tblReceipt].[BankBranch]  AS [BankBranch],
                                            [tblReceipt].[REF]         AS [PDC_CHECK_SERIAL],
                                            [tblReceipt].[TranId],
                                            [tblReceipt].[ReceiptDate] AS [TransactionDate]
                                        FROM
                                            [dbo].[tblReceipt]
                                        WHERE
                                            [TRANSACTION].[TranID] = [tblReceipt].[TranId]
                                    ) [RECEIPT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            IIF(@IsFullPayment = 1, 'FULL PAYMENT', @combinedString) AS [PAYMENT_FOR]
                                    ) [PAYMENT]
                                WHERE
                                    [TRANSACTION].[TranID] = @TranID;
                END
            IF @Mode = 'MAIN'
               AND @PaymentLevel = 'SECOND'
                BEGIN
                    INSERT INTO [#tblRecieptReport]
                        (
                            [client_no],
                            [client_Name],
                            [client_Address],
                            [PR_No],
                            [OR_No],
                            [TIN_No],
                            [TransactionDate],
                            [AmountInWords],
                            [PaymentFor],
                            [TotalAmountInDigit],
                            [RENTAL],
                            [VAT],
                            [VATPct],
                            [TOTAL],
                            [LESSWITHHOLDING],
                            [TOTALAMOUNTDUE],
                            [BANKNAME],
                            [PDCCHECKSERIALNO],
                            [USER],
                            [EncodedDate],
                            [TRANID],
                            [Mode],
                            [PaymentLevel],
                            [UnitNo],
                            [ProjectName],
                            [BankBranch],
                            [RENTAL_LESS_VAT],
                            [RENTAL_LESS_TAX]
                        )
                                SELECT
                                    [CLIENT].[client_no]                                                                                                 AS [client_no],
                                    [CLIENT].[client_Name]                                                                                               AS [client_Name],
                                    [CLIENT].[client_Address]                                                                                            AS [client_Address],
                                    [RECEIPT].[PR_No]                                                                                                    AS [PR_No],
                                    [RECEIPT].[OR_No]                                                                                                    AS [OR_No],
                                    [CLIENT].[TIN_No]                                                                                                    AS [TIN_No],
                                    [RECEIPT].[TransactionDate]                                                                                          AS [TransactionDate],
                                    UPPER([dbo].[fnNumberToWordsWithDecimal]([TRANSACTION].[ReceiveAmount]))                                             AS [AmountInWords],
                                    [PAYMENT].[PAYMENT_FOR]                                                                                              AS [PaymentFor],
                                    [TRANSACTION].[ReceiveAmount]                                                                                        AS [TotalAmountInDigit],
                                    [TRANSACTION].[ReceiveAmount]
                                    - CAST((([tblUnitReference].[Unit_Vat] * [TRANSACTION].[ReceiveAmount]) / 100) AS DECIMAL(18, 2))                    AS [RENTAL],
                                    CAST(CAST((([tblUnitReference].[Unit_Vat] * [TRANSACTION].[ReceiveAmount]) / 100) AS DECIMAL(18, 2)) AS VARCHAR(30)) AS [VAT], --TAX WILL FOLLOW
                                    CAST(CAST([tblUnitReference].[Unit_Vat] AS INT) AS VARCHAR(10)) + '% VAT'                                            AS [VATPct],
                                    [TRANSACTION].[ReceiveAmount]                                                                                        AS [TOTAL],
                                    IIF([tblUnitReference].[Unit_Tax] > 0,
                                        CAST(CAST((([tblUnitReference].[Unit_Tax] * [TRANSACTION].[ReceiveAmount])
                                                   / 100
                                                  ) AS DECIMAL(18, 2)) AS VARCHAR(30)),
                                        '')                                                                                                              AS [LESSWITHHOLDING],
                                    [TRANSACTION].[ReceiveAmount]                                                                                        AS [TOTALAMOUNTDUE],
                                    [RECEIPT].[BankName]                                                                                                 AS [BANKNAME],
                                    [RECEIPT].[PDC_CHECK_SERIAL]                                                                                         AS [PDCCHECKSERIALNO],
                                    [TRANSACTION].[USER]                                                                                                 AS [USER],
                                    GETDATE()                                                                                                            AS [EncodedDate],
                                    @TranID                                                                                                              AS [TRANID],
                                    @Mode                                                                                                                AS [Mode],
                                    @PaymentLevel                                                                                                        AS [PaymentLevel],
                                    [tblUnitReference].[UnitNo]                                                                                          AS [UnitNo],
                                    [dbo].[fnGetProjectNameById]([tblUnitReference].[ProjectId])                                                         AS [ProjectName],
                                    [RECEIPT].[BankBranch]                                                                                               AS [BankBranch],
                                    '0'                                                                                                                  AS [RENTAL_LESS_VAT],
                                    '0'                                                                                                                  AS [RENTAL_LESS_TAX]
                                FROM
                                    [dbo].[tblUnitReference]
                                    CROSS APPLY
                                    (
                                        SELECT
                                            [tblClientMstr].[ClientID]      AS [client_no],
                                            [tblClientMstr].[ClientName]    AS [client_Name],
                                            [tblClientMstr].[PostalAddress] AS [client_Address],
                                            [tblClientMstr].[TIN_No]        AS [TIN_No]
                                        FROM
                                            [dbo].[tblClientMstr]
                                        WHERE
                                            [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
                                    ) [CLIENT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                                [tblTransaction].[EncodedDate],
                                                [tblTransaction].[TranID],
                                                ISNULL([dbo].[fn_GetUserName]([tblTransaction].[EncodedBy]), '') AS [USER],
                                                SUM([tblPayment].[Amount])                                       AS [ReceiveAmount]
                                        FROM
                                                [dbo].[tblTransaction]
                                            INNER JOIN
                                                [dbo].[tblPayment]
                                                    ON [tblPayment].[TranId] = [tblTransaction].[TranID]
                                        WHERE
                                                [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                                                AND [tblPayment].[Notes] = 'SECURITY AND MAINTENANCE NET OF VAT'
                                        GROUP BY
                                                [tblTransaction].[EncodedDate],
                                                [tblTransaction].[TranID],
                                                [tblTransaction].[EncodedBy],
                                                [tblPayment].[Amount]
                                    ) [TRANSACTION]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblReceipt].[CompanyPRNo] AS [PR_No],
                                            [tblReceipt].[CompanyORNo] AS [OR_No],
                                            [tblReceipt].[Amount]      AS [TOTAL],
                                            [tblReceipt].[Amount]      AS [TotalAmountInDigit],
                                            [tblReceipt].[BankName]    AS [BankName],
                                            [tblReceipt].[BankBranch]  AS [BankBranch],
                                            [tblReceipt].[REF]         AS [PDC_CHECK_SERIAL],
                                            [tblReceipt].[TranId],
                                            [tblReceipt].[ReceiptDate] AS [TransactionDate]
                                        FROM
                                            [dbo].[tblReceipt]
                                        WHERE
                                            [TRANSACTION].[TranID] = [tblReceipt].[TranId]
                                    ) [RECEIPT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            IIF(@IsFullPayment = 1, 'FULL PAYMENT', @combinedString) AS [PAYMENT_FOR]
                                    ) [PAYMENT]
                                WHERE
                                    [TRANSACTION].[TranID] = @TranID;
                END





        END


        SELECT
            [#tblRecieptReport].[client_no],
            [#tblRecieptReport].[client_Name],
            [#tblRecieptReport].[client_Address],
            [#tblRecieptReport].[PR_No],
            [#tblRecieptReport].[OR_No],
            [#tblRecieptReport].[TIN_No],
            CAST(CONVERT(VARCHAR(15), [#tblRecieptReport].[TransactionDate], 107) AS VARCHAR(150)) AS [TransactionDate],
            [#tblRecieptReport].[AmountInWords],
            ISNULL([#tblRecieptReport].[PaymentFor], '')                                           AS [PaymentFor],
            --FORMAT(CAST([#TMP].[TotalAmountInDigit] AS DECIMAL(18, 2)), 'C', 'en-PH') AS [TotalAmountInDigit],
            FORMAT(CAST([#tblRecieptReport].[TotalAmountInDigit] AS DECIMAL(18, 2)), 'N')          AS [TotalAmountInDigit],
            --FORMAT(CAST([#TMP].[RENTAL] AS DECIMAL(18, 2)), 'C', 'en-PH') AS [RENTAL],
            FORMAT(CAST([#tblRecieptReport].[RENTAL] AS DECIMAL(18, 2)), 'C', 'en-PH')             AS [RENTAL],
            FORMAT(CAST([#tblRecieptReport].[VAT] AS DECIMAL(18, 2)), 'C', 'en-PH')                AS [VAT],
            [#tblRecieptReport].[VATPct],
            FORMAT(CAST([#tblRecieptReport].[RENTAL] AS DECIMAL(18, 2)), 'C', 'en-PH')             AS [TOTAL],
            --FORMAT(CAST([tblRecieptReport].[LESSWITHHOLDING] AS DECIMAL(18, 2)), 'C', 'en-PH') AS [LESSWITHHOLDING],
            [#tblRecieptReport].[LESSWITHHOLDING]                                                  AS [LESSWITHHOLDING],
            IIF([#tblRecieptReport].[LESSWITHHOLDING] <> '', 'LESS WITHHOLDING', '')               AS [LESSWITHHOLDING_label],
            --[#TMP].[LESSWITHHOLDING] AS [LESSWITHHOLDING],
            FORMAT(CAST([#tblRecieptReport].[TOTALAMOUNTDUE] AS DECIMAL(18, 2)), 'C', 'en-PH')     AS [TOTALAMOUNTDUE],
            [#tblRecieptReport].[BANKNAME],
            [#tblRecieptReport].[PDCCHECKSERIALNO],
            [#tblRecieptReport].[USER],
            [#tblRecieptReport].[Mode],
            [#tblRecieptReport].[UnitNo],
            [#tblRecieptReport].[ProjectName],
            [#tblRecieptReport].[BankBranch],
            ''                                                                                     AS [BankCheckDate],
            ''                                                                                     AS [BankCheckAmount],
            [#tblRecieptReport].[RENTAL_LESS_VAT],
            [#tblRecieptReport].[RENTAL_LESS_TAX]
        FROM
            [#tblRecieptReport]
        --WHERE
        --       [tblRecieptReport].[TRANID] = @TranID
        --       AND [tblRecieptReport].[Mode] = @Mode
        --       AND [tblRecieptReport].[PaymentLevel] = @PaymentLevel
        ORDER BY
            [#tblRecieptReport].[EncodedDate]

    END;

    DROP TABLE [#tblRecieptReport]
GO
/****** Object:  StoredProcedure [dbo].[sp_Ongching_PR_Report]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE   PROCEDURE [dbo].[sp_Ongching_PR_Report]
   @TranID       VARCHAR(20) = NULL,
    @Mode         VARCHAR(50) = NULL,
    @PaymentLevel VARCHAR(50) = NULL
AS
     BEGIN
        SET NOCOUNT ON;



        CREATE TABLE [#tblRecieptReport]
            (
                [client_no]          [VARCHAR](500)  NULL,
                [client_Name]        [VARCHAR](500)  NULL,
                [client_Address]     [VARCHAR](5000) NULL,
                [PR_No]              [VARCHAR](500)  NULL,
                [OR_No]              [VARCHAR](500)  NULL,
                [TIN_No]             [VARCHAR](500)  NULL,
                [TransactionDate]    [DATETIME]      NULL,
                [AmountInWords]      [VARCHAR](5000) NULL,
                [PaymentFor]         [VARCHAR](500)  NULL,
                [TotalAmountInDigit] [VARCHAR](100)  NULL,
                [RENTAL]             [VARCHAR](500)  NULL,
                [VAT]                [VARCHAR](500)  NULL,
                [VATPct]             [VARCHAR](500)  NULL,
                [TOTAL]              [VARCHAR](500)  NULL,
                [LESSWITHHOLDING]    [VARCHAR](500)  NULL,
                [TOTALAMOUNTDUE]     [VARCHAR](500)  NULL,
                [BANKNAME]           [VARCHAR](500)  NULL,
                [PDCCHECKSERIALNO]   [VARCHAR](500)  NULL,
                [USER]               [VARCHAR](500)  NULL,
                [EncodedDate]        [DATETIME]      NULL,
                [TRANID]             [VARCHAR](500)  NULL,
                [Mode]               [VARCHAR](500)  NULL,
                [PaymentLevel]       [VARCHAR](100)  NULL,
                [UnitNo]             [VARCHAR](150)  NULL,
                [ProjectName]        [VARCHAR](150)  NULL,
                [BankBranch]         [VARCHAR](150)  NULL,
                [RENTAL_LESS_VAT]    [VARCHAR](150)  NULL,
                [RENTAL_LESS_TAX]    [VARCHAR](150)  NULL
            )

        DECLARE @UnitCategory VARCHAR(150) = ''
        DECLARE @combinedString VARCHAR(MAX);
        DECLARE @IsFullPayment BIT = 0;
        DECLARE @RefId VARCHAR(100) = '';

        SELECT
            @UnitCategory = [dbo].[fnGetUnitCategoryByUnitId]([tblUnitReference].[UnitId])
        FROM
            [dbo].[tblUnitReference]
        WHERE
            [tblUnitReference].[RefId] =
            (
                SELECT
                    [tblTransaction].[RefId]
                FROM
                    [dbo].[tblTransaction]
                WHERE
                    [tblTransaction].[TranID] = @TranID
            )

        BEGIN
            SELECT
                @IsFullPayment = ISNULL([tblUnitReference].[IsFullPayment], 0),
                @RefId         = [tblUnitReference].[RefId]
            FROM
                [dbo].[tblUnitReference]
            WHERE
                [tblUnitReference].[RefId] =
                (
                    SELECT TOP 1
                           [tblTransaction].[RefId]
                    FROM
                           [dbo].[tblTransaction]
                    WHERE
                           [tblTransaction].[TranID] = @TranID
                );

            IF @IsFullPayment = 0
                BEGIN
                    IF
                        (
                            SELECT
                                COUNT(*)
                            FROM
                                [dbo].[tblPayment]
                            WHERE
                                [tblPayment].[TranId] = @TranID
                                AND [tblPayment].[Remarks] NOT IN (
                                                                      'SECURITY DEPOSIT'
                                                                  )
                        ) > 5
                        BEGIN
                            IF @Mode = 'REN'
                               AND @PaymentLevel = 'SECOND'
                                BEGIN
                                    SELECT
                                        @combinedString
                                        = 'RENTAL FOR '
                                          +
                                        (
                                            SELECT  TOP 1
                                                    UPPER(DATENAME(MONTH, MIN([tblPayment].[ForMonth]))) + ' '
                                                    + CAST(YEAR(MIN([tblPayment].[ForMonth])) AS VARCHAR(4))
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'RENTAL NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        ) + ' TO '
                                          +
                                        (
                                            SELECT  TOP 1
                                                    UPPER(DATENAME(MONTH, MAX([tblPayment].[ForMonth]))) + ' '
                                                    + CAST(YEAR(MAX([tblPayment].[ForMonth])) AS VARCHAR(4))
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'RENTAL NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        )
                                END

                            IF @Mode = 'MAIN'
                               AND @PaymentLevel = 'SECOND'
                                BEGIN

                                    SELECT
                                        @combinedString
                                        = 'SECURITY & MAINTENANCE FOR'
                                          +
                                        (
                                            SELECT  TOP 1
                                                    UPPER(DATENAME(MONTH, MIN([tblPayment].[ForMonth]))) + ' '
                                                    + CAST(YEAR(MIN([tblPayment].[ForMonth])) AS VARCHAR(4))
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'SECURITY AND MAINTENANCE NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        ) + ' TO '
                                          +
                                        (
                                            SELECT  TOP 1
                                                    UPPER(DATENAME(MONTH, MAX([tblPayment].[ForMonth]))) + ' '
                                                    + CAST(YEAR(MAX([tblPayment].[ForMonth])) AS VARCHAR(4))
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'SECURITY AND MAINTENANCE NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        )
                                END

                        END
                    ELSE
                        BEGIN
                            IF @Mode = 'SEC'
                               AND @PaymentLevel = 'FIRST'
                                BEGIN
                                    SELECT
                                        --@combinedString
                                        --= '('
                                        --  + CAST(CAST([dbo].[fnGetTotalSecDepositAmountCount](@RefId) AS INT) AS VARCHAR(50))
                                        --  + ')MONTH-SECURITY DEPOSIT'
                                        @combinedString = ' SECURITY DEPOSIT '

                                END
                            ELSE IF @Mode = 'ADV'
                                    AND @PaymentLevel = 'FIRST'
                                BEGIN
                                    --SELECT @combinedString = 'ADVANCE PAYMENT'
                                    BEGIN
                                        SELECT
                                            @combinedString
                                            = COALESCE(@combinedString + '-', '')
                                              + UPPER(DATENAME(MONTH, [tblPayment].[ForMonth])) + ' '
                                              + CAST(YEAR([tblPayment].[ForMonth]) AS VARCHAR(4))
                                        FROM
                                            [dbo].[tblPayment]
                                        WHERE
                                            [tblPayment].[TranId] = @TranID
                                            AND [tblPayment].[Remarks] = 'MONTHS ADVANCE'
                                            AND ISNULL([tblPayment].[Notes], '') = ''


                                    END
                                END
                            ELSE
                                BEGIN

                                    IF @Mode = 'REN'
                                       AND @PaymentLevel = 'SECOND'
                                        BEGIN
                                            SELECT
                                                    @combinedString
                                                = IIF(@UnitCategory = 'PARKING', 'PS RENTAL FOR', 'RENTAL FOR ')
                                                  --+ COALESCE(@combinedString + '-', '')
                                                  + UPPER(DATENAME(MONTH, [tblPayment].[ForMonth])) + ' '
                                                  + CAST(YEAR([tblPayment].[ForMonth]) AS VARCHAR(4))
                                                  + IIF(ISNULL([tblMonthLedger].[IsHold], 0) = 1, '(PARTIAL)', '')
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'RENTAL NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        END
                                    IF @Mode = 'MAIN'
                                       AND @PaymentLevel = 'SECOND'
                                        BEGIN
                                            SELECT
                                                    @combinedString
                                                = 'SECURITY & MAINTENANCE FOR '
                                                  --+ COALESCE(@combinedString + '-', '')
                                                  + UPPER(DATENAME(MONTH, [tblPayment].[ForMonth])) + ' '
                                                  + CAST(YEAR([tblPayment].[ForMonth]) AS VARCHAR(4))
                                                  + IIF(ISNULL([tblMonthLedger].[IsHold], 0) = 1, '(PARTIAL)', '')
                                            FROM
                                                    [dbo].[tblPayment]
                                                INNER JOIN
                                                    [dbo].[tblMonthLedger]
                                                        ON [tblMonthLedger].[LedgMonth] = [tblPayment].[ForMonth]
                                                           AND [tblMonthLedger].[Remarks] = [tblPayment].[Notes]
                                                           AND [tblMonthLedger].[TransactionID] = [tblPayment].[TranId]
                                            WHERE
                                                    [tblPayment].[TranId] = @TranID
                                                    AND [tblPayment].[Remarks] NOT IN (
                                                                                          'SECURITY DEPOSIT'
                                                                                      )
                                                    AND [tblPayment].[Notes] = 'SECURITY AND MAINTENANCE NET OF VAT'
                                                    AND ISNULL([tblMonthLedger].[IsPaid], 0) = 1
                                        END


                                END
                        END
                END;


            IF @Mode = 'ADV'
               AND @PaymentLevel = 'FIRST'
                BEGIN
                    INSERT INTO [#tblRecieptReport]
                        (
                            [client_no],
                            [client_Name],
                            [client_Address],
                            [PR_No],
                            [OR_No],
                            [TIN_No],
                            [TransactionDate],
                            [AmountInWords],
                            [PaymentFor],      --PAYMENT DESCRIPTION
                            [TotalAmountInDigit],
                            [RENTAL],
                            [VAT],             --VAT AMOUNT
                            [VATPct],
                            [TOTAL],
                            [LESSWITHHOLDING], --TAX AMOUNT
                            [TOTALAMOUNTDUE],
                            [BANKNAME],
                            [PDCCHECKSERIALNO],
                            [USER],
                            [EncodedDate],
                            [TRANID],
                            [Mode],
                            [PaymentLevel],
                            [UnitNo],
                            [ProjectName],
                            [BankBranch],
                            [RENTAL_LESS_VAT],
                            [RENTAL_LESS_TAX]
                        )
                                SELECT
                                    [CLIENT].[client_no]                                                                                                  AS [client_no],
                                    [CLIENT].[client_Name]                                                                                                AS [client_Name],
                                    [CLIENT].[client_Address]                                                                                             AS [client_Address],
                                    [RECEIPT].[PR_No]                                                                                                     AS [PR_No],
                                    [RECEIPT].[OR_No]                                                                                                     AS [OR_No],
                                    [CLIENT].[TIN_No]                                                                                                     AS [TIN_No],
                                    [RECEIPT].[TransactionDate]                                                                                           AS [TransactionDate],
                                    UPPER([dbo].[fnNumberToWordsWithDecimal](IIF(@IsFullPayment = 0,
                                                                                 [tblUnitReference].[AdvancePaymentAmount],
                                                                                 [tblUnitReference].[Total])
                                                                            )
                                         )                                                                                                                AS [AmountInWords],
                                    [PAYMENT].[PAYMENT_FOR]                                                                                               AS [PaymentFor],
                                    IIF(@IsFullPayment = 0,
                                        [tblUnitReference].[AdvancePaymentAmount],
                                        [tblUnitReference].[Total])                                                                                       AS [TotalAmountInDigit],
                                    IIF(@IsFullPayment = 0,
                                        [tblUnitReference].[AdvancePaymentAmount],
                                        [tblUnitReference].[Total])
                                    - (([tblUnitReference].[Unit_BaseRentalVatAmount]
                                        + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                       )
                                       * CAST([dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2))
                                      )                                                                                                                   AS [RENTAL],
                                    CAST(([tblUnitReference].[Unit_BaseRentalVatAmount]
                                          + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                         )
                                         * CAST([dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))      AS [VAT_AMOUNT],
                                    CAST(CAST([tblUnitReference].[Unit_Vat] AS INT) AS VARCHAR(10)) + '% VAT'                                             AS [VATPct],
                                    IIF(@IsFullPayment = 0,
                                        [tblUnitReference].[AdvancePaymentAmount],
                                        [tblUnitReference].[Total])                                                                                       AS [TOTAL],
                                    IIF([tblUnitReference].[Unit_Tax] = 0,
                                        '',
                                        CAST([tblUnitReference].[Unit_BaseRentalTax]
                                             * CAST([dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))) AS [LESSWITHHOLDING],
                                    [tblUnitReference].[AdvancePaymentAmount]                                                                             AS [TOTALAMOUNTDUE],
                                    [RECEIPT].[BankName]                                                                                                  AS [BANKNAME],
                                    [RECEIPT].[PDC_CHECK_SERIAL]                                                                                          AS [PDCCHECKSERIALNO],
                                    [TRANSACTION].[USER]                                                                                                  AS [USER],
                                    GETDATE()                                                                                                             AS [EncodedDate],
                                    @TranID                                                                                                               AS [TRANID],
                                    @Mode                                                                                                                 AS [Mode],
                                    @PaymentLevel                                                                                                         AS [PaymentLevel],
                                    [tblUnitReference].[UnitNo]                                                                                           AS [UnitNo],
                                    [dbo].[fnGetProjectNameById]([tblUnitReference].[ProjectId])                                                          AS [ProjectName],
                                    [RECEIPT].[BankBranch]                                                                                                AS [BankBranch],
                                    CAST(CAST(IIF(@IsFullPayment = 0,
                                                  IIF([tblUnitReference].[Unit_Tax] > 0,
                                                      ([tblUnitReference].[AdvancePaymentAmount]
                                                       + CAST([tblUnitReference].[Unit_BaseRentalTax]
                                                              * [dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2))
                                                      ),
                                                      [tblUnitReference].[AdvancePaymentAmount]),
                                                  [tblUnitReference].[Total]) AS DECIMAL(18, 2))
                                         - CAST(([dbo].[tblUnitReference].[Unit_BaseRentalVatAmount]
                                                 + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                                )
                                                * [dbo].[fnGetAdvanceMonthCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))    AS [RENTAL_LESS_VAT],
                                    CAST(IIF(@IsFullPayment = 0,
                                             [tblUnitReference].[AdvancePaymentAmount],
                                             [tblUnitReference].[Total]) AS VARCHAR(150))                                                                 AS [RENTAL_LESS_TAX]
                                FROM
                                    [dbo].[tblUnitReference]
                                    CROSS APPLY
                                    (
                                        SELECT
                                            [tblClientMstr].[ClientID]      AS [client_no],
                                            [tblClientMstr].[ClientName]    AS [client_Name],
                                            [tblClientMstr].[PostalAddress] AS [client_Address],
                                            [tblClientMstr].[TIN_No]        AS [TIN_No]
                                        FROM
                                            [dbo].[tblClientMstr]
                                        WHERE
                                            [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
                                    ) [CLIENT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblTransaction].[EncodedDate],
                                            [tblTransaction].[TranID],
                                            ISNULL([dbo].[fn_GetUserName]([tblTransaction].[EncodedBy]), '') AS [USER],
                                            [tblTransaction].[ReceiveAmount]
                                        FROM
                                            [dbo].[tblTransaction]
                                        WHERE
                                            [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                                    ) [TRANSACTION]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblReceipt].[CompanyPRNo] AS [PR_No],
                                            [tblReceipt].[CompanyORNo] AS [OR_No],
                                            [tblReceipt].[Amount]      AS [TOTAL],
                                            [tblReceipt].[BankName]    AS [BankName],
                                            [tblReceipt].[BankBranch]  AS [BankBranch],
                                            [tblReceipt].[REF]         AS [PDC_CHECK_SERIAL],
                                            [tblReceipt].[TranId],
                                            [tblReceipt].[ReceiptDate] AS [TransactionDate]
                                        FROM
                                            [dbo].[tblReceipt]
                                        WHERE
                                            [TRANSACTION].[TranID] = [tblReceipt].[TranId]
                                    ) [RECEIPT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            IIF(@IsFullPayment = 1, 'FULL PAYMENT', @combinedString) AS [PAYMENT_FOR]
                                    ) [PAYMENT]
                                WHERE
                                    [TRANSACTION].[TranID] = @TranID


                END
            IF @Mode = 'SEC'
               AND @PaymentLevel = 'FIRST'
                BEGIN
                    INSERT INTO [#tblRecieptReport]
                        (
                            [client_no],
                            [client_Name],
                            [client_Address],
                            [PR_No],
                            [OR_No],
                            [TIN_No],
                            [TransactionDate],
                            [AmountInWords],
                            [PaymentFor],
                            [TotalAmountInDigit],
                            [RENTAL],
                            [VAT],
                            [VATPct],
                            [TOTAL],
                            [LESSWITHHOLDING],
                            [TOTALAMOUNTDUE],
                            [BANKNAME],
                            [PDCCHECKSERIALNO],
                            [USER],
                            [EncodedDate],
                            [TRANID],
                            [Mode],
                            [PaymentLevel],
                            [UnitNo],
                            [ProjectName],
                            [BankBranch],
                            [RENTAL_LESS_VAT],
                            [RENTAL_LESS_TAX]
                        )
                                SELECT
                                    [CLIENT].[client_no]                                                                                                           AS [client_no],
                                    [CLIENT].[client_Name]                                                                                                         AS [client_Name],
                                    [CLIENT].[client_Address]                                                                                                      AS [client_Address],
                                    [RECEIPT].[PR_No]                                                                                                              AS [PR_No],
                                    [RECEIPT].[OR_No]                                                                                                              AS [OR_No],
                                    [CLIENT].[TIN_No]                                                                                                              AS [TIN_No],
                                    [RECEIPT].[TransactionDate]                                                                                                    AS [TransactionDate],
                                    UPPER([dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[SecDeposit]))                                                     AS [AmountInWords],
                                    [PAYMENT].[PAYMENT_FOR]                                                                                                        AS [PaymentFor],
                                    [tblUnitReference].[SecDeposit]                                                                                                AS [TotalAmountInDigit],
                                    [tblUnitReference].[SecDeposit]
                                    - CAST(([tblUnitReference].[Unit_BaseRentalVatAmount]
                                            + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                           )
                                           * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2))                          AS [RENTAL],
                                    CAST(CAST(([tblUnitReference].[Unit_BaseRentalVatAmount]
                                               + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                              )
                                              * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))      AS [VAT],
                                    CAST(CAST([tblUnitReference].[Unit_Vat] AS INT) AS VARCHAR(10)) + '% VAT'                                                      AS [VATPct],
                                    [tblUnitReference].[SecDeposit]                                                                                                AS [TOTAL],
                                    IIF([tblUnitReference].[Unit_Tax] = 0,
                                        '',
                                        CAST(CAST([tblUnitReference].[Unit_TaxAmount]
                                                  * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))) AS [LESSWITHHOLDING],
                                    [tblUnitReference].[SecDeposit]                                                                                                AS [TOTALAMOUNTDUE],
                                    [RECEIPT].[BankName]                                                                                                           AS [BANKNAME],
                                    [RECEIPT].[PDC_CHECK_SERIAL]                                                                                                   AS [PDCCHECKSERIALNO],
                                    [TRANSACTION].[USER]                                                                                                           AS [USER],
                                    GETDATE()                                                                                                                      AS [EncodedDate],
                                    @TranID                                                                                                                        AS [TRANID],
                                    @Mode                                                                                                                          AS [Mode],
                                    @PaymentLevel                                                                                                                  AS [PaymentLevel],
                                    [tblUnitReference].[UnitNo]                                                                                                    AS [UnitNo],
                                    [dbo].[fnGetProjectNameById]([tblUnitReference].[ProjectId])                                                                   AS [ProjectName],
                                    [RECEIPT].[BankBranch]                                                                                                         AS [BankBranch],
                                    CAST(CAST(IIF([tblUnitReference].[Unit_Tax] > 0,
                                                  ([tblUnitReference].[SecDeposit]
                                                   + CAST([tblUnitReference].[Unit_BaseRentalTax]
                                                          * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2))
                                                  ),
                                                  0) AS DECIMAL(18, 2))
                                         - CAST(([tblUnitReference].[Unit_BaseRentalVatAmount]
                                                 + [tblUnitReference].[Unit_SecAndMainVatAmount]
                                                )
                                                * [dbo].[fnGetTotalSecDepositAmountCount]([dbo].[tblUnitReference].[RefId]) AS DECIMAL(18, 2)) AS VARCHAR(150))    AS [RENTAL_LESS_VAT],
                                    CAST(CAST([tblUnitReference].[SecDeposit] AS DECIMAL(18, 2)) AS VARCHAR(150))                                                  AS [RENTAL_LESS_TAX]
                                FROM
                                    [dbo].[tblUnitReference]
                                    CROSS APPLY
                                    (
                                        SELECT
                                            [tblClientMstr].[ClientID]      AS [client_no],
                                            [tblClientMstr].[ClientName]    AS [client_Name],
                                            [tblClientMstr].[PostalAddress] AS [client_Address],
                                            [tblClientMstr].[TIN_No]        AS [TIN_No]
                                        FROM
                                            [dbo].[tblClientMstr]
                                        WHERE
                                            [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
                                    ) [CLIENT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblTransaction].[EncodedDate],
                                            [tblTransaction].[TranID],
                                            ISNULL([dbo].[fn_GetUserName]([tblTransaction].[EncodedBy]), '') AS [USER],
                                            [tblTransaction].[ReceiveAmount]
                                        FROM
                                            [dbo].[tblTransaction]
                                        WHERE
                                            [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                                    ) [TRANSACTION]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblReceipt].[CompanyPRNo] AS [PR_No],
                                            [tblReceipt].[CompanyORNo] AS [OR_No],
                                            [tblReceipt].[Amount]      AS [TOTAL],
                                            [tblReceipt].[BankName]    AS [BankName],
                                            [tblReceipt].[BankBranch]  AS [BankBranch],
                                            [tblReceipt].[REF]         AS [PDC_CHECK_SERIAL],
                                            [tblReceipt].[TranId],
                                            [tblReceipt].[ReceiptDate] AS [TransactionDate]
                                        FROM
                                            [dbo].[tblReceipt]
                                        WHERE
                                            [TRANSACTION].[TranID] = [tblReceipt].[TranId]
                                    ) [RECEIPT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            IIF(@IsFullPayment = 1, 'FULL PAYMENT', @combinedString) AS [PAYMENT_FOR]
                                    ) [PAYMENT]
                                WHERE
                                    [TRANSACTION].[TranID] = @TranID


                END



            IF @Mode = 'REN'
               AND @PaymentLevel = 'SECOND'
                BEGIN
                    INSERT INTO [#tblRecieptReport]
                        (
                            [client_no],
                            [client_Name],
                            [client_Address],
                            [PR_No],
                            [OR_No],
                            [TIN_No],
                            [TransactionDate],
                            [AmountInWords],
                            [PaymentFor],
                            [TotalAmountInDigit],
                            [RENTAL],
                            [VAT],
                            [VATPct],
                            [TOTAL],
                            [LESSWITHHOLDING],
                            [TOTALAMOUNTDUE],
                            [BANKNAME],
                            [PDCCHECKSERIALNO],
                            [USER],
                            [EncodedDate],
                            [TRANID],
                            [Mode],
                            [PaymentLevel],
                            [UnitNo],
                            [ProjectName],
                            [BankBranch],
                            [RENTAL_LESS_VAT],
                            [RENTAL_LESS_TAX]
                        )
                                SELECT
                                    [CLIENT].[client_no]                                                      AS [client_no],
                                    [CLIENT].[client_Name]                                                    AS [client_Name],
                                    [CLIENT].[client_Address]                                                 AS [client_Address],
                                    [RECEIPT].[PR_No]                                                         AS [PR_No],
                                    [RECEIPT].[OR_No]                                                         AS [OR_No],
                                    [CLIENT].[TIN_No]                                                         AS [TIN_No],
                                    [RECEIPT].[TransactionDate]                                               AS [TransactionDate],
                                    UPPER([dbo].[fnNumberToWordsWithDecimal]([TRANSACTION].[ReceiveAmount]))  AS [AmountInWords],
                                    [PAYMENT].[PAYMENT_FOR]                                                   AS [PaymentFor],
                                    [TRANSACTION].[ReceiveAmount]                                             AS [TotalAmountInDigit],
                                    [TRANSACTION].[ReceiveAmount]
                                    - [dbo].[fnGetBaseRentalTotalVatAmount](
                                                                               [dbo].[tblUnitReference].[RefId],
                                                                               [TRANSACTION].[AmountToPay],
                                                                               [TRANSACTION].[ReceiveAmount]
                                                                           )                                  AS [RENTAL],
                                    --CAST(CAST((([tblUnitReference].[Unit_Vat] * [TRANSACTION].[ReceiveAmount])
                                    --           / 100
                                    --          ) AS DECIMAL(18, 2)) AS VARCHAR(30))                           AS [VAT],
                                    CAST([dbo].[fnGetBaseRentalTotalVatAmount](
                                                                                  [dbo].[tblUnitReference].[RefId],
                                                                                  [TRANSACTION].[AmountToPay],
                                                                                  [TRANSACTION].[ReceiveAmount]
                                                                              ) AS VARCHAR(150))              AS [VAT],
                                    CAST(CAST([tblUnitReference].[Unit_Vat] AS INT) AS VARCHAR(10)) + '% VAT' AS [VATPct],
                                    [TRANSACTION].[ReceiveAmount]                                             AS [TOTAL],
                                    --IIF([tblUnitReference].[Unit_Tax] > 0,
                                    --    CAST(CAST((([tblUnitReference].[Unit_Tax] * [TRANSACTION].[ReceiveAmount])
                                    --               / 100
                                    --              ) AS DECIMAL(18, 2)) AS VARCHAR(30)),
                                    --    '0.00')                                                              AS [LESSWITHHOLDING],

                                    IIF([tblUnitReference].[Unit_Tax] = 0,
                                        '',
                                        CAST([dbo].[fnGetBaseRentalTotalTaxAmount](
                                                                                      [dbo].[tblUnitReference].[RefId],
                                                                                      [TRANSACTION].[AmountToPay],
                                                                                      [TRANSACTION].[ReceiveAmount]
                                                                                  ) AS VARCHAR(150)))         AS [LESSWITHHOLDING],
                                    [TRANSACTION].[ReceiveAmount]                                             AS [TOTALAMOUNTDUE],
                                    [RECEIPT].[BankName]                                                      AS [BANKNAME],
                                    [RECEIPT].[PDC_CHECK_SERIAL]                                              AS [PDCCHECKSERIALNO],
                                    [TRANSACTION].[USER]                                                      AS [USER],
                                    GETDATE()                                                                 AS [EncodedDate],
                                    @TranID                                                                   AS [TRANID],
                                    @Mode                                                                     AS [Mode],
                                    @PaymentLevel                                                             AS [PaymentLevel],
                                    [tblUnitReference].[UnitNo]                                               AS [UnitNo],
                                    [dbo].[fnGetProjectNameById]([tblUnitReference].[ProjectId])              AS [ProjectName],
                                    [RECEIPT].[BankBranch]                                                    AS [BankBranch],
                                    '0'                                                                       AS [RENTAL_LESS_VAT],
                                    '0'                                                                       AS [RENTAL_LESS_TAX]
                                FROM
                                    [dbo].[tblUnitReference]
                                    CROSS APPLY
                                    (
                                        SELECT
                                            [tblClientMstr].[ClientID]      AS [client_no],
                                            [tblClientMstr].[ClientName]    AS [client_Name],
                                            [tblClientMstr].[PostalAddress] AS [client_Address],
                                            [tblClientMstr].[TIN_No]        AS [TIN_No]
                                        FROM
                                            [dbo].[tblClientMstr]
                                        WHERE
                                            [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
                                    ) [CLIENT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                                [tblTransaction].[EncodedDate],
                                                [tblTransaction].[TranID],
                                                SUM([tblMonthLedger].[LedgRentalAmount])                         AS [AmountToPay],
                                                ISNULL([dbo].[fn_GetUserName]([tblTransaction].[EncodedBy]), '') AS [USER],
                                                SUM([tblPayment].[Amount])                                       AS [ReceiveAmount]
                                        FROM
                                                [dbo].[tblTransaction]
                                            INNER JOIN
                                                [dbo].[tblPayment]
                                                    ON [tblPayment].[TranId] = [tblTransaction].[TranID]
                                            INNER JOIN
                                                [dbo].[tblMonthLedger]
                                                    ON [tblMonthLedger].[Recid] = [tblPayment].[LedgeRecid]
                                        WHERE
                                                [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                                                AND [tblPayment].[Notes] = 'RENTAL NET OF VAT'
                                        GROUP BY
                                                [tblTransaction].[EncodedDate],
                                                [tblTransaction].[TranID],
                                                [tblTransaction].[EncodedBy],
                                                [tblPayment].[Amount],
                                                [tblTransaction].[PaidAmount]
                                    ) [TRANSACTION]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblReceipt].[CompanyPRNo] AS [PR_No],
                                            [tblReceipt].[CompanyORNo] AS [OR_No],
                                            [tblReceipt].[Amount]      AS [TOTAL],
                                            [tblReceipt].[Amount]      AS [TotalAmountInDigit],
                                            [tblReceipt].[BankName]    AS [BankName],
                                            [tblReceipt].[BankBranch]  AS [BankBranch],
                                            [tblReceipt].[REF]         AS [PDC_CHECK_SERIAL],
                                            [tblReceipt].[TranId],
                                            [tblReceipt].[ReceiptDate] AS [TransactionDate]
                                        FROM
                                            [dbo].[tblReceipt]
                                        WHERE
                                            [TRANSACTION].[TranID] = [tblReceipt].[TranId]
                                    ) [RECEIPT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            IIF(@IsFullPayment = 1, 'FULL PAYMENT', @combinedString) AS [PAYMENT_FOR]
                                    ) [PAYMENT]
                                WHERE
                                    [TRANSACTION].[TranID] = @TranID;
                END
            IF @Mode = 'MAIN'
               AND @PaymentLevel = 'SECOND'
                BEGIN
                    INSERT INTO [#tblRecieptReport]
                        (
                            [client_no],
                            [client_Name],
                            [client_Address],
                            [PR_No],
                            [OR_No],
                            [TIN_No],
                            [TransactionDate],
                            [AmountInWords],
                            [PaymentFor],
                            [TotalAmountInDigit],
                            [RENTAL],
                            [VAT],
                            [VATPct],
                            [TOTAL],
                            [LESSWITHHOLDING],
                            [TOTALAMOUNTDUE],
                            [BANKNAME],
                            [PDCCHECKSERIALNO],
                            [USER],
                            [EncodedDate],
                            [TRANID],
                            [Mode],
                            [PaymentLevel],
                            [UnitNo],
                            [ProjectName],
                            [BankBranch],
                            [RENTAL_LESS_VAT],
                            [RENTAL_LESS_TAX]
                        )
                                SELECT
                                    [CLIENT].[client_no]                                                                                                 AS [client_no],
                                    [CLIENT].[client_Name]                                                                                               AS [client_Name],
                                    [CLIENT].[client_Address]                                                                                            AS [client_Address],
                                    [RECEIPT].[PR_No]                                                                                                    AS [PR_No],
                                    [RECEIPT].[OR_No]                                                                                                    AS [OR_No],
                                    [CLIENT].[TIN_No]                                                                                                    AS [TIN_No],
                                    [RECEIPT].[TransactionDate]                                                                                          AS [TransactionDate],
                                    UPPER([dbo].[fnNumberToWordsWithDecimal]([TRANSACTION].[ReceiveAmount]))                                             AS [AmountInWords],
                                    [PAYMENT].[PAYMENT_FOR]                                                                                              AS [PaymentFor],
                                    [TRANSACTION].[ReceiveAmount]                                                                                        AS [TotalAmountInDigit],
                                    [TRANSACTION].[ReceiveAmount]
                                    - CAST((([tblUnitReference].[Unit_Vat] * [TRANSACTION].[ReceiveAmount]) / 100) AS DECIMAL(18, 2))                    AS [RENTAL],
                                    CAST(CAST((([tblUnitReference].[Unit_Vat] * [TRANSACTION].[ReceiveAmount]) / 100) AS DECIMAL(18, 2)) AS VARCHAR(30)) AS [VAT], --TAX WILL FOLLOW
                                    CAST(CAST([tblUnitReference].[Unit_Vat] AS INT) AS VARCHAR(10)) + '% VAT'                                            AS [VATPct],
                                    [TRANSACTION].[ReceiveAmount]                                                                                        AS [TOTAL],
                                    IIF([tblUnitReference].[Unit_Tax] > 0,
                                        CAST(CAST((([tblUnitReference].[Unit_Tax] * [TRANSACTION].[ReceiveAmount])
                                                   / 100
                                                  ) AS DECIMAL(18, 2)) AS VARCHAR(30)),
                                        '')                                                                                                              AS [LESSWITHHOLDING],
                                    [TRANSACTION].[ReceiveAmount]                                                                                        AS [TOTALAMOUNTDUE],
                                    [RECEIPT].[BankName]                                                                                                 AS [BANKNAME],
                                    [RECEIPT].[PDC_CHECK_SERIAL]                                                                                         AS [PDCCHECKSERIALNO],
                                    [TRANSACTION].[USER]                                                                                                 AS [USER],
                                    GETDATE()                                                                                                            AS [EncodedDate],
                                    @TranID                                                                                                              AS [TRANID],
                                    @Mode                                                                                                                AS [Mode],
                                    @PaymentLevel                                                                                                        AS [PaymentLevel],
                                    [tblUnitReference].[UnitNo]                                                                                          AS [UnitNo],
                                    [dbo].[fnGetProjectNameById]([tblUnitReference].[ProjectId])                                                         AS [ProjectName],
                                    [RECEIPT].[BankBranch]                                                                                               AS [BankBranch],
                                    '0'                                                                                                                  AS [RENTAL_LESS_VAT],
                                    '0'                                                                                                                  AS [RENTAL_LESS_TAX]
                                FROM
                                    [dbo].[tblUnitReference]
                                    CROSS APPLY
                                    (
                                        SELECT
                                            [tblClientMstr].[ClientID]      AS [client_no],
                                            [tblClientMstr].[ClientName]    AS [client_Name],
                                            [tblClientMstr].[PostalAddress] AS [client_Address],
                                            [tblClientMstr].[TIN_No]        AS [TIN_No]
                                        FROM
                                            [dbo].[tblClientMstr]
                                        WHERE
                                            [tblClientMstr].[ClientID] = [tblUnitReference].[ClientID]
                                    ) [CLIENT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                                [tblTransaction].[EncodedDate],
                                                [tblTransaction].[TranID],
                                                ISNULL([dbo].[fn_GetUserName]([tblTransaction].[EncodedBy]), '') AS [USER],
                                                SUM([tblPayment].[Amount])                                       AS [ReceiveAmount]
                                        FROM
                                                [dbo].[tblTransaction]
                                            INNER JOIN
                                                [dbo].[tblPayment]
                                                    ON [tblPayment].[TranId] = [tblTransaction].[TranID]
                                        WHERE
                                                [tblUnitReference].[RefId] = [tblTransaction].[RefId]
                                                AND [tblPayment].[Notes] = 'SECURITY AND MAINTENANCE NET OF VAT'
                                        GROUP BY
                                                [tblTransaction].[EncodedDate],
                                                [tblTransaction].[TranID],
                                                [tblTransaction].[EncodedBy],
                                                [tblPayment].[Amount]
                                    ) [TRANSACTION]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            [tblReceipt].[CompanyPRNo] AS [PR_No],
                                            [tblReceipt].[CompanyORNo] AS [OR_No],
                                            [tblReceipt].[Amount]      AS [TOTAL],
                                            [tblReceipt].[Amount]      AS [TotalAmountInDigit],
                                            [tblReceipt].[BankName]    AS [BankName],
                                            [tblReceipt].[BankBranch]  AS [BankBranch],
                                            [tblReceipt].[REF]         AS [PDC_CHECK_SERIAL],
                                            [tblReceipt].[TranId],
                                            [tblReceipt].[ReceiptDate] AS [TransactionDate]
                                        FROM
                                            [dbo].[tblReceipt]
                                        WHERE
                                            [TRANSACTION].[TranID] = [tblReceipt].[TranId]
                                    ) [RECEIPT]
                                    OUTER APPLY
                                    (
                                        SELECT
                                            IIF(@IsFullPayment = 1, 'FULL PAYMENT', @combinedString) AS [PAYMENT_FOR]
                                    ) [PAYMENT]
                                WHERE
                                    [TRANSACTION].[TranID] = @TranID;
                END





        END


        SELECT
            [#tblRecieptReport].[client_no],
            [#tblRecieptReport].[client_Name],
            [#tblRecieptReport].[client_Address],
            [#tblRecieptReport].[PR_No],
            [#tblRecieptReport].[OR_No],
            [#tblRecieptReport].[TIN_No],
            CAST(CONVERT(VARCHAR(15), [#tblRecieptReport].[TransactionDate], 107) AS VARCHAR(150)) AS [TransactionDate],
            [#tblRecieptReport].[AmountInWords],
            ISNULL([#tblRecieptReport].[PaymentFor], '')                                           AS [PaymentFor],
            --FORMAT(CAST([#TMP].[TotalAmountInDigit] AS DECIMAL(18, 2)), 'C', 'en-PH') AS [TotalAmountInDigit],
            FORMAT(CAST([#tblRecieptReport].[TotalAmountInDigit] AS DECIMAL(18, 2)), 'N')          AS [TotalAmountInDigit],
            --FORMAT(CAST([#TMP].[RENTAL] AS DECIMAL(18, 2)), 'C', 'en-PH') AS [RENTAL],
            FORMAT(CAST([#tblRecieptReport].[RENTAL] AS DECIMAL(18, 2)), 'C', 'en-PH')             AS [RENTAL],
            FORMAT(CAST([#tblRecieptReport].[VAT] AS DECIMAL(18, 2)), 'C', 'en-PH')                AS [VAT],
            [#tblRecieptReport].[VATPct],
            FORMAT(CAST([#tblRecieptReport].[RENTAL] AS DECIMAL(18, 2)), 'C', 'en-PH')             AS [TOTAL],
            --FORMAT(CAST([tblRecieptReport].[LESSWITHHOLDING] AS DECIMAL(18, 2)), 'C', 'en-PH') AS [LESSWITHHOLDING],
            [#tblRecieptReport].[LESSWITHHOLDING]                                                  AS [LESSWITHHOLDING],
            IIF([#tblRecieptReport].[LESSWITHHOLDING] <> '', 'LESS WITHHOLDING', '')               AS [LESSWITHHOLDING_label],
            --[#TMP].[LESSWITHHOLDING] AS [LESSWITHHOLDING],
            FORMAT(CAST([#tblRecieptReport].[TOTALAMOUNTDUE] AS DECIMAL(18, 2)), 'C', 'en-PH')     AS [TOTALAMOUNTDUE],
            [#tblRecieptReport].[BANKNAME],
            [#tblRecieptReport].[PDCCHECKSERIALNO],
            [#tblRecieptReport].[USER],
            [#tblRecieptReport].[Mode],
            [#tblRecieptReport].[UnitNo],
            [#tblRecieptReport].[ProjectName],
            [#tblRecieptReport].[BankBranch],
            ''                                                                                     AS [BankCheckDate],
            ''                                                                                     AS [BankCheckAmount],
            [#tblRecieptReport].[RENTAL_LESS_VAT],
            [#tblRecieptReport].[RENTAL_LESS_TAX]
        FROM
            [#tblRecieptReport]
        --WHERE
        --       [tblRecieptReport].[TRANID] = @TranID
        --       AND [tblRecieptReport].[Mode] = @Mode
        --       AND [tblRecieptReport].[PaymentLevel] = @PaymentLevel
        ORDER BY
            [#tblRecieptReport].[EncodedDate]

    END;

    DROP TABLE [#tblRecieptReport]
GO
/****** Object:  StoredProcedure [dbo].[sp_ProjectAddress]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProjectAddress] @projectId INT
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here


        SELECT
            [tblProjectMstr].[ProjectAddress],
            [tblProjectMstr].[ProjectType]
        FROM
            [dbo].[tblProjectMstr]
        WHERE
            ISNULL([tblProjectMstr].[IsActive], 0) = 1
            AND [tblProjectMstr].[RecId] = @projectId;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_RefreshUpdatesGroupControls]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_RefreshUpdatesGroupControls]
AS
BEGIN

    SET NOCOUNT ON;
    MERGE INTO [dbo].[tblGroupFormControls] AS [target]
    USING
    (
        SELECT [tblFormControlsMaster].[FormId],
               [tblFormControlsMaster].[ControlId],
               [tblGroup].[GroupId],
               1 AS [IsVisible],
               0 AS [IsDelete]
        FROM [dbo].[tblFormControlsMaster]
            CROSS JOIN [dbo].[tblGroup]
    ) AS [source]
    ON [target].[FormId] = [source].[FormId]
       AND [target].[ControlId] = [source].[ControlId]
       AND [target].[GroupId] = [source].[GroupId]
    WHEN NOT MATCHED THEN
        INSERT
        (
            [FormId],
            [ControlId],
            [GroupId],
            [IsVisible],
            [IsDelete]
        )
        VALUES
        ([source].[FormId], [source].[ControlId], [source].[GroupId], [source].[IsVisible], [source].[IsDelete]);
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveBankName]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SaveBankName] @BankName VARCHAR(50) = NULL
AS
    BEGIN TRY

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';

        BEGIN TRANSACTION
        IF NOT EXISTS
            (
                SELECT
                    [tblBankName].[BankName]
                FROM
                    [dbo].[tblBankName]
                WHERE
                    [tblBankName].[BankName] = @BankName
            )
            BEGIN
                INSERT INTO [dbo].[tblBankName]
                    (
                        [BankName]
                    )
                VALUES
                    (
                        UPPER(@BankName)
                    );
                IF (@@ROWCOUNT > 0)
                    BEGIN
                        SET @Message_Code = 'SUCCESS'
                        SET @ErrorMessage = N''
                    END
            END
        ELSE
            BEGIN

                SET @Message_Code = 'THIS BANK IS ALREADy EXISTST!'
                SET @ErrorMessage = N''

            END

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION

        SET @Message_Code = 'ERROR'
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [ErrorMessage],
                [LogDateTime]
            )
        VALUES
            (
                'sp_SaveBankName', @ErrorMessage, GETDATE()
            );

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveClient]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_SaveClient]
    --@ClientType        VARCHAR(50),
    --@ClientName        VARCHAR(100),
    --@Age               INT            = 0,
    --@PostalAddress     VARCHAR(100)   = NULL,
    --@DateOfBirth       DATE           = NULL,
    --@TelNumber         VARCHAR(20)    = NULL,
    --@Gender            BIT            = NULL,
    --@Nationality       VARCHAR(50)    = NULL,
    --@Occupation        VARCHAR(100)   = NULL,
    --@AnnualIncome      DECIMAL(18, 2) = 0,
    --@EmployerName      VARCHAR(100)   = NULL,
    --@EmployerAddress   VARCHAR(200)   = NULL,
    --@SpouseName        VARCHAR(100)   = NULL,
    --@ChildrenNames     VARCHAR(500)   = NULL,
    --@TotalPersons      INT            = 0,
    --@MaidName          VARCHAR(100)   = NULL,
    --@DriverName        VARCHAR(100)   = NULL,
    --@VisitorsPerDay    INT            = 0,
    --@BuildingSecretary INT            = 0,
    --@EncodedBy         INT            = 0,
    --@ComputerName      VARCHAR(50)    = NULL,
    --@TIN_No            VARCHAR(50)    = NULL,
    @XML XML = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';

        IF (@XML IS NOT NULL)
            BEGIN
                INSERT INTO [dbo].[tblClientMstr]
                    (
                        [ClientType],
                        [ClientName],
                        [Age],
                        [PostalAddress],
                        [DateOfBirth],
                        [TelNumber],
                        [Gender],
                        [Nationality],
                        [Occupation],
                        [AnnualIncome],
                        [EmployerName],
                        [EmployerAddress],
                        [SpouseName],
                        [ChildrenNames],
                        [TotalPersons],
                        [MaidName],
                        [DriverName],
                        [VisitorsPerDay],
                        [BuildingSecretary],
                        [EncodedDate],
                        [EncodedBy],
                        [IsActive],
                        [ComputerName],
                        [TIN_No]
                    )
                            SELECT
                                [ParaValues].[data].[value]('c1[1]', 'VARCHAR(50)'),
                                [ParaValues].[data].[value]('c2[1]', 'VARCHAR(100)'),
                                [ParaValues].[data].[value]('c3[1]', 'INT'),
                                [ParaValues].[data].[value]('c4[1]', 'VARCHAR(100)'),
                                [ParaValues].[data].[value]('c5[1]', 'DATE'),
                                [ParaValues].[data].[value]('c6[1]', 'VARCHAR(20)'),
                                [ParaValues].[data].[value]('c7[1]', 'BIT'),
                                [ParaValues].[data].[value]('c8[1]', 'VARCHAR(50)'),
                                [ParaValues].[data].[value]('c9[1]', 'VARCHAR(100)'),
                                [ParaValues].[data].[value]('c10[1]', 'DECIMAL(18,2)'),
                                [ParaValues].[data].[value]('c11[1]', 'VARCHAR(100)'),
                                [ParaValues].[data].[value]('c12[1]', 'VARCHAR(200)'),
                                [ParaValues].[data].[value]('c13[1]', 'VARCHAR(100)'),
                                [ParaValues].[data].[value]('c14[1]', 'VARCHAR(500)'),
                                [ParaValues].[data].[value]('c15[1]', 'INT'),
                                [ParaValues].[data].[value]('c16[1]', 'VARCHAR(100)'),
                                [ParaValues].[data].[value]('c17[1]', 'VARCHAR(100)'),
                                [ParaValues].[data].[value]('c18[1]', 'INT'),
                                [ParaValues].[data].[value]('c19[1]', 'INT'),
								GETDATE(),
                                [ParaValues].[data].[value]('c20[1]', 'INT'),
								1,
                                [ParaValues].[data].[value]('c21[1]', 'VARCHAR(50)'),
                                [ParaValues].[data].[value]('c22[1]', 'VARCHAR(50)')
                            FROM
                                @XML.[nodes]('/Table1') AS [ParaValues]([data]);
            --VALUES
            --    (
            --        @ClientType, @ClientName, @Age, @PostalAddress, @DateOfBirth, @TelNumber, @Gender, @Nationality,
            --        @Occupation, @AnnualIncome, @EmployerName, @EmployerAddress, @SpouseName, @ChildrenNames,
            --        @TotalPersons, @MaidName, @DriverName, @VisitorsPerDay, @BuildingSecretary, GETDATE(), @EncodedBy, 1,
            --        @ComputerName, @TIN_No
            --    );
            END;

        IF (@@ROWCOUNT > 0)
            BEGIN
                SET @Message_Code = 'SUCCESS'
            END;


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
                        'sp_SaveClient', @ErrorMessage, GETDATE()
                    );
            END
        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveCompany]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE   PROCEDURE [dbo].[sp_SaveCompany]
    @CompanyName      VARCHAR(200) = NULL,
    @CompanyAddress   VARCHAR(500) = NULL,
    @CompanyTIN       VARCHAR(20)  = NULL,
    @CompanyOwnerName VARCHAR(100) = NULL,
    @ComputerName     VARCHAR(100) = NULL,
    @EncodedBy        INT          = NULL
AS
    BEGIN TRY
        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';
        BEGIN TRANSACTION
        IF NOT EXISTS
            (
                SELECT
                    1
                FROM
                    [dbo].[tblCompany]
                WHERE
                    [tblCompany].[CompanyName] = UPPER(@CompanyName)
            )
            BEGIN

                INSERT INTO [dbo].[tblCompany]
                    (
                        [CompanyName],
                        [CompanyAddress],
                        [CompanyTIN],
                        [CompanyOwnerName],
                        [EncodedBy],
                        [EncodedDate],
                        [ComputerName],
                        [Status]
                    )
                VALUES
                    (
                        UPPER(@CompanyName),      -- CompanyName - varchar(200)
                        @CompanyAddress,          -- CompanyAddress - varchar(500)
                        @CompanyTIN,              -- CompanyTIN - varchar(20)
                        UPPER(@CompanyOwnerName), -- CompanyOwnerName - varchar(100)
                        @EncodedBy,               -- EncodedBy - int
                        GETDATE(),                -- EncodedDate - datetime      
                        @ComputerName,            -- ComputerName - varchar(20),
                        1
                    )

                IF @@ROWCOUNT > 0
                    BEGIN
                        SET @Message_Code = 'SUCCESS'
                        SET @ErrorMessage = N''
                    END

            END
        ELSE
            BEGIN
                SET @Message_Code = 'COMPANY ALREADY EXIST';
                SET @ErrorMessage = N''
            END

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION

        SET @Message_Code = 'ERROR'
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [ErrorMessage],
                [LogDateTime]
            )
        VALUES
            (
                'sp_SaveCompany', @ErrorMessage, GETDATE()
            );

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveComputation]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_SaveComputation]
    @ProjectId            INT,
    @InquiringClient      VARCHAR(500),
    @ClientMobile         VARCHAR(50),
    @UnitId               INT,
    @UnitNo               VARCHAR(50),
    @StatDate             VARCHAR(10),
    @FinishDate           VARCHAR(10),
    @Rental               DECIMAL(18, 2) NULL,
    @SecAndMaintenance    DECIMAL(18, 2),
    @TotalRent            DECIMAL(18, 2),
    @SecDeposit           DECIMAL(18, 2),
    @Total                DECIMAL(18, 2),
    @EncodedBy            INT,
    @ComputerName         VARCHAR(30),
    @ClientID             VARCHAR(50),
    @XML                  XML,
    @AdvancePaymentAmount DECIMAL(18, 2),
    @IsFullPayment        BIT = 0,
    @IsRenewal            BIT = 0
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';

        DECLARE @ComputationID AS INT = 0;
        DECLARE @ProjectType AS VARCHAR(20) = '';
        DECLARE @GenVat AS DECIMAL(18, 2) = 0;
        DECLARE @WithHoldingTax AS DECIMAL(18, 2) = 0;
        DECLARE @PenaltyPct AS DECIMAL(18, 2) = 0;
        DECLARE @RefId AS VARCHAR(30) = '';
        DECLARE @Unit_IsParking AS BIT = 0;
        DECLARE @Unit_IsNonVat AS BIT = 0;
        DECLARE @Unit_AreaSqm AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_AreaRateSqm AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_AreaTotalAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_BaseRentalVatAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_BaseRentalWithVatAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_BaseRentalTax AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_TotalRental AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_SecAndMainAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_SecAndMainVatAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_SecAndMainWithVatAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_Vat AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_Tax AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_TaxAmount AS DECIMAL(18, 2) = 0;
    
        CREATE TABLE [#tblAdvancePayment]
            (
                [Months] VARCHAR(10)
            );
        IF (@XML IS NOT NULL)
            BEGIN
                INSERT INTO [#tblAdvancePayment]
                    (
                        [Months]
                    )
                            SELECT
                                [ParaValues].[data].[value]('c1[1]', 'VARCHAR(10)')
                            FROM
                                @XML.[nodes]('/Table1') AS [ParaValues]([data]);
            END;

        SELECT
                @ProjectType                  = [tblProjectMstr].[ProjectType],
                @Unit_IsParking               = [tblUnitMstr].[IsParking],
                @Unit_IsNonVat                = [tblUnitMstr].[IsNonVat],
                @Unit_AreaSqm                 = [tblUnitMstr].[AreaSqm],
                @Unit_AreaRateSqm             = [tblUnitMstr].[AreaRateSqm],
                @Unit_AreaTotalAmount         = [tblUnitMstr].[AreaTotalAmount],
                @Unit_BaseRentalVatAmount     = [tblUnitMstr].[BaseRentalVatAmount],
                @Unit_BaseRentalWithVatAmount = [tblUnitMstr].[BaseRentalWithVatAmount],
                @Unit_BaseRentalTax           = [tblUnitMstr].[BaseRentalTax],
                @Unit_TotalRental             = [tblUnitMstr].[TotalRental],
                @Unit_SecAndMainAmount        = [tblUnitMstr].[SecAndMainAmount],
                @Unit_SecAndMainVatAmount     = [tblUnitMstr].[SecAndMainVatAmount],
                @Unit_SecAndMainWithVatAmount = [tblUnitMstr].[SecAndMainWithVatAmount],
                @Unit_Vat                     = [tblUnitMstr].[Vat],
                @Unit_Tax                     = [tblUnitMstr].[Tax],
                @Unit_TaxAmount               = [tblUnitMstr].[TaxAmount]
        FROM
                [dbo].[tblUnitMstr] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblProjectMstr] WITH (NOLOCK)
                    ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
        WHERE
                [tblUnitMstr].[RecId] = @UnitId;


        SELECT
            @GenVat         = [tblRatesSettings].[GenVat],
            @WithHoldingTax = [tblRatesSettings].[WithHoldingTax],
            @PenaltyPct     = [tblRatesSettings].[PenaltyPct]
        FROM
            [dbo].[tblRatesSettings] WITH (NOLOCK)
        WHERE
            [tblRatesSettings].[ProjectType] = @ProjectType;


        UPDATE
            [dbo].[tblUnitMstr]
        SET
            [tblUnitMstr].[UnitStatus] = 'RESERVED'
        WHERE
            [tblUnitMstr].[RecId] = @UnitId;

        -- Insert the record into tblClientMstr
        INSERT INTO [dbo].[tblUnitReference]
            (
                [ProjectId],
                [InquiringClient],
                [ClientMobile],
                [UnitId],
                [UnitNo],
                [StatDate],
                [FinishDate],
                [TransactionDate],
                [Rental],
                [SecAndMaintenance],
                [TotalRent],
                [SecDeposit],
                [Total],
                [EncodedBy],
                [EncodedDate],
                [IsActive],
                [ComputerName],
                [ClientID],
                [GenVat],
                [WithHoldingTax],
                [PenaltyPct],
                [AdvancePaymentAmount],
                [IsFullPayment],
                [Unit_IsNonVat],
                [Unit_AreaSqm],
                [Unit_AreaRateSqm],
                [Unit_AreaTotalAmount],
                [Unit_BaseRentalVatAmount],
                [Unit_BaseRentalWithVatAmount],
                [Unit_BaseRentalTax],
                [Unit_TotalRental],
                [Unit_SecAndMainAmount],
                [Unit_SecAndMainVatAmount],
                [Unit_SecAndMainWithVatAmount],
                [Unit_Vat],
                [Unit_Tax],
                [Unit_TaxAmount],
                [Unit_IsParking],
                [Unit_ProjectType],
                [IsRenewal]
            )
        VALUES
            (
                @ProjectId, @InquiringClient, @ClientMobile, @UnitId, @UnitNo, @StatDate, @FinishDate, GETDATE(),
                @Rental, @SecAndMaintenance, @TotalRent, @SecDeposit, @Total, @EncodedBy, GETDATE(), 1, @ComputerName,
                @ClientID, @GenVat, @WithHoldingTax, @PenaltyPct, @AdvancePaymentAmount, @IsFullPayment,
                @Unit_IsNonVat, @Unit_AreaSqm, @Unit_AreaRateSqm, @Unit_AreaTotalAmount, @Unit_BaseRentalVatAmount,
                @Unit_BaseRentalWithVatAmount, @Unit_BaseRentalTax, @Unit_TotalRental, @Unit_SecAndMainAmount,
                @Unit_SecAndMainVatAmount, @Unit_SecAndMainWithVatAmount, @Unit_Vat, @Unit_Tax, @Unit_TaxAmount,
                @Unit_IsParking, @ProjectType, @IsRenewal
            );
        SET @ComputationID = SCOPE_IDENTITY();

        IF (@@ROWCOUNT > 0)
            BEGIN
                SELECT
                    @RefId = [tblUnitReference].[RefId]
                FROM
                    [dbo].[tblUnitReference]
                WHERE
                    [tblUnitReference].[RecId] = @ComputationID;
                INSERT INTO [dbo].[tblAdvancePayment]
                    (
                        [Months],
                        [RefId],
                        [Amount]
                    )
                            SELECT
                                CONVERT(DATE, [#tblAdvancePayment].[Months]),
                                @RefId,
                                @TotalRent
                            FROM
                                [#tblAdvancePayment];



             

                SET @Message_Code = 'SUCCESS'
              

        
            END

			   EXEC [dbo].[sp_GenerateLedger]
                    @FromDate = @StatDate,
                    @EndDate = @FinishDate,
                    @LedgAmount = @TotalRent,
                    @Rental = @Rental,
                    @SecAndMaintenance = @SecAndMaintenance,
                    @ComputationID = @ComputationID,
                    @ClientID = @ClientID,
                    @EncodedBy = @EncodedBy,
                    @ComputerName = @ComputerName,
                    @UnitId = @UnitId,
                    @IsRenewal = @IsRenewal;


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
                        'sp_SaveComputation', @ErrorMessage, GETDATE()
                    );

               
            END

			 SELECT
                    @ErrorMessage AS [ErrorMessage],
                    @Message_Code AS [Message_Code];

        DROP TABLE [#tblAdvancePayment];
    END


GO
/****** Object:  StoredProcedure [dbo].[sp_SaveComputationParking]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_SaveComputationParking]
    @ProjectId            INT,
    @InquiringClient      VARCHAR(500),
    @ClientMobile         VARCHAR(50),
    @UnitId               INT,
    @UnitNo               VARCHAR(50),
    @StatDate             VARCHAR(10),
    @FinishDate           VARCHAR(10),
    @Rental               DECIMAL(18, 2) NULL,
    @TotalRent            DECIMAL(18, 2),
    @Total                DECIMAL(18, 2),
    @EncodedBy            INT,
    @ComputerName         VARCHAR(30),
    @ClientID             VARCHAR(50),
    @XML                  XML,
    @AdvancePaymentAmount DECIMAL(18, 2),
    @IsFullPayment        BIT = 0,
    @IsRenewal            BIT = 0
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';

        DECLARE @ComputationID AS INT = 0;
        DECLARE @ProjectType AS VARCHAR(20) = '';
        DECLARE @GenVat AS DECIMAL(18, 2) = 0;
        DECLARE @WithHoldingTax AS DECIMAL(18, 2) = 0;
        DECLARE @PenaltyPct AS DECIMAL(18, 2) = 0;
        DECLARE @RefId AS VARCHAR(30) = '';
        DECLARE @Unit_IsParking AS BIT = 0;
        DECLARE @Unit_IsNonVat AS BIT = 0;
        DECLARE @Unit_AreaSqm AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_AreaRateSqm AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_AreaTotalAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_BaseRentalVatAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_BaseRentalWithVatAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_BaseRentalTax AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_TotalRental AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_SecAndMainAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_SecAndMainVatAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_SecAndMainWithVatAmount AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_Vat AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_Tax AS DECIMAL(18, 2) = 0;
        DECLARE @Unit_TaxAmount AS DECIMAL(18, 2) = 0;


        CREATE TABLE [#tblAdvancePayment]
            (
                [Months] VARCHAR(10)
            );
        IF (@XML IS NOT NULL)
            BEGIN
                INSERT INTO [#tblAdvancePayment]
                    (
                        [Months]
                    )
                            SELECT
                                [ParaValues].[data].[value]('c1[1]', 'VARCHAR(10)')
                            FROM
                                @XML.[nodes]('/Table1') AS [ParaValues]([data]);
            END;

        SELECT
                @ProjectType                  = [tblProjectMstr].[ProjectType],
                @Unit_IsParking               = [tblUnitMstr].[IsParking],
                @Unit_IsNonVat                = [tblUnitMstr].[IsNonVat],
                @Unit_AreaSqm                 = [tblUnitMstr].[AreaSqm],
                @Unit_AreaRateSqm             = [tblUnitMstr].[AreaRateSqm],
                @Unit_AreaTotalAmount         = [tblUnitMstr].[AreaTotalAmount],
                @Unit_BaseRentalVatAmount     = [tblUnitMstr].[BaseRentalVatAmount],
                @Unit_BaseRentalWithVatAmount = [tblUnitMstr].[BaseRentalWithVatAmount],
                @Unit_BaseRentalTax           = [tblUnitMstr].[BaseRentalTax],
                @Unit_TotalRental             = [tblUnitMstr].[TotalRental],
                @Unit_SecAndMainAmount        = [tblUnitMstr].[SecAndMainAmount],
                @Unit_SecAndMainVatAmount     = [tblUnitMstr].[SecAndMainVatAmount],
                @Unit_SecAndMainWithVatAmount = [tblUnitMstr].[SecAndMainWithVatAmount],
                @Unit_Vat                     = [tblUnitMstr].[Vat],
                @Unit_Tax                     = [tblUnitMstr].[Tax],
                @Unit_TaxAmount               = [tblUnitMstr].[TaxAmount]
        FROM
                [dbo].[tblUnitMstr] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblProjectMstr] WITH (NOLOCK)
                    ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
        WHERE
                [tblUnitMstr].[RecId] = @UnitId;


        SELECT
            @GenVat         = [tblRatesSettings].[GenVat],
            @WithHoldingTax = [tblRatesSettings].[WithHoldingTax],
            @PenaltyPct     = [tblRatesSettings].[PenaltyPct]
        FROM
            [dbo].[tblRatesSettings] WITH (NOLOCK)
        WHERE
            [tblRatesSettings].[ProjectType] = @ProjectType;

        UPDATE
            [dbo].[tblUnitMstr]
        SET
            [tblUnitMstr].[UnitStatus] = 'RESERVED'
        WHERE
            [tblUnitMstr].[RecId] = @UnitId;

        -- Insert the record into tblClientMstr
        INSERT INTO [dbo].[tblUnitReference]
            (
                [ProjectId],
                [InquiringClient],
                [ClientMobile],
                [UnitId],
                [UnitNo],
                [StatDate],
                [FinishDate],
                [TransactionDate],
                [Rental],
                [TotalRent],
                [Total],
                [EncodedBy],
                [EncodedDate],
                [IsActive],
                [ComputerName],
                [ClientID],
                [GenVat],
                [WithHoldingTax],
                [PenaltyPct],
                [AdvancePaymentAmount],
                [IsFullPayment],
                [Unit_IsNonVat],
                [Unit_AreaSqm],
                [Unit_AreaRateSqm],
                [Unit_AreaTotalAmount],
                [Unit_BaseRentalVatAmount],
                [Unit_BaseRentalWithVatAmount],
                [Unit_BaseRentalTax],
                [Unit_TotalRental],
                [Unit_SecAndMainAmount],
                [Unit_SecAndMainVatAmount],
                [Unit_SecAndMainWithVatAmount],
                [Unit_Vat],
                [Unit_Tax],
                [Unit_TaxAmount],
                [Unit_IsParking],
                [Unit_ProjectType],
                [IsRenewal]
            )
        VALUES
            (
                @ProjectId, @InquiringClient, @ClientMobile, @UnitId, @UnitNo, @StatDate, @FinishDate, GETDATE(),
                @Rental, @TotalRent, @Total, @EncodedBy, GETDATE(), 1, @ComputerName, @ClientID, @GenVat,
                @WithHoldingTax, @PenaltyPct, @AdvancePaymentAmount, @IsFullPayment, @Unit_IsNonVat, @Unit_AreaSqm,
                @Unit_AreaRateSqm, @Unit_AreaTotalAmount, @Unit_BaseRentalVatAmount, @Unit_BaseRentalWithVatAmount,
                @Unit_BaseRentalTax, @Unit_TotalRental, @Unit_SecAndMainAmount, @Unit_SecAndMainVatAmount,
                @Unit_SecAndMainWithVatAmount, @Unit_Vat, @Unit_Tax, @Unit_TaxAmount, @Unit_IsParking, @ProjectType,
                @IsRenewal
            );
        SET @ComputationID = SCOPE_IDENTITY();
        IF (@@ROWCOUNT > 0)
            BEGIN

                SELECT
                    @RefId = [tblUnitReference].[RefId]
                FROM
                    [dbo].[tblUnitReference]
                WHERE
                    [tblUnitReference].[RecId] = @ComputationID;
                INSERT INTO [dbo].[tblAdvancePayment]
                    (
                        [Months],
                        [RefId],
                        [Amount]
                    )
                            SELECT
                                CONVERT(DATE, [#tblAdvancePayment].[Months]),
                                @RefId,
                                @TotalRent
                            FROM
                                [#tblAdvancePayment];

                EXEC [dbo].[sp_GenerateLedger]
                    @FromDate = @StatDate,
                    @EndDate = @FinishDate,
                    @LedgAmount = @TotalRent,
                    @Rental = @Rental,
                    @ComputationID = @ComputationID,
                    @ClientID = @ClientID,
                    @EncodedBy = @EncodedBy,
                    @ComputerName = @ComputerName,
                    @UnitId = @UnitId,
                    @IsRenewal = @IsRenewal;

                SET @Message_Code = 'SUCCESS'

            END;

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
                        'sp_SaveComputationParking', @ErrorMessage, GETDATE()
                    );
            END
        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];


        DROP TABLE [#tblAdvancePayment];
    END
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveFile]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_SaveFile]
    @FilePath         NVARCHAR(MAX),
    @FileData         VARBINARY(MAX),
    @ClientName       VARCHAR(100),
    @FileNames        VARCHAR(100),
    @Files            VARCHAR(200),
    @Notes            VARCHAR(500) = NULL,
    @ReferenceId      VARCHAR(500) = NULL,
    @IsSignedContract BIT          = 0
AS
    BEGIN TRY
        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';

        BEGIN TRANSACTION
        INSERT INTO [dbo].[Files]
            (
                [ClientName],
                [FilePath],
                [FileData],
                [FileNames],
                [Notes],
                [Files],
                [RefId]
            )
        VALUES
            (
                @ClientName, @FilePath, @FileData, @FileNames, @Notes, @Files, @ReferenceId
            );

        -- Log a success event    
        IF (@@ROWCOUNT > 0)
            BEGIN
                SET @Message_Code = 'SUCCESS'
                SET @ErrorMessage = N''
            END;

        -- Update the flag in tblUnitReference
        IF (@IsSignedContract = 1)
            BEGIN
                UPDATE
                    [dbo].[tblUnitReference]
                SET
                    [tblUnitReference].[IsSignedContract] = 1,
                    [tblUnitReference].[SignedContractDate] = GETDATE()
                WHERE
                    [tblUnitReference].[RefId] = @ReferenceId;

                IF (@@ROWCOUNT > 0)
                    BEGIN
                        SET @Message_Code = 'SUCCESS'
                        SET @ErrorMessage = N''
                    END

            END

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION

        SET @Message_Code = 'ERROR'
        SET @ErrorMessage = ERROR_MESSAGE()


        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [ErrorMessage],
                [LogDateTime]
            )
        VALUES
            (
                'sp_SaveFile', @ErrorMessage, GETDATE()
            );

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveFloorType]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_SaveFloorType] @TypeName VARCHAR(50) = NULL
AS
    BEGIN TRY

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';

        BEGIN TRANSACTION
        IF NOT EXISTS
            (
                SELECT
                    [tblFloorTypes].[FloorTypesDescription]
                FROM
                    [dbo].[tblFloorTypes]
                WHERE
                    [tblFloorTypes].[FloorTypesDescription] = @TypeName
            )
            BEGIN
                INSERT INTO [dbo].[tblFloorTypes]
                    (
                        [FloorTypesDescription]
                    )
                VALUES
                    (
                        UPPER(@TypeName)
                    );
                IF (@@ROWCOUNT > 0)
                    BEGIN
                        SET @Message_Code = 'SUCCESS'
                        SET @ErrorMessage = N''
                    END
            END
        ELSE
            BEGIN

                SET @Message_Code = 'THIS FLOOR TYPE IS ALREADY EXISTST!'
                SET @ErrorMessage = N''

            END

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION

        SET @Message_Code = 'ERROR'
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [ErrorMessage],
                [LogDateTime]
            )
        VALUES
            (
                'sp_SaveFloorType', @ErrorMessage, GETDATE()
            );

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveFormControls]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_SaveFormControls]
    @FormId             INT         = NULL,
    @MenuId             INT         = NULL,
    @ControlName        VARCHAR(50) = NULL,
    @ControlDescription VARCHAR(50) = NULL,
    @IsBackRoundControl BIT         = 0,
    @IsHeaderControl    BIT         = 0
AS
    BEGIN TRY

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';
        BEGIN TRANSACTION
        IF NOT EXISTS
            (
                SELECT
                    [tblFormControlsMaster].[ControlName]
                FROM
                    [dbo].[tblFormControlsMaster] WITH (NOLOCK)
                WHERE
                    [tblFormControlsMaster].[ControlName] = @ControlName
                    AND [tblFormControlsMaster].[FormId] = @FormId
                    AND [tblFormControlsMaster].[MenuId] = @MenuId
            )
            BEGIN
                INSERT INTO [dbo].[tblFormControlsMaster]
                    (
                        [FormId],
                        [MenuId],
                        [ControlName],
                        [ControlDescription],
                        [IsBackRoundControl],
                        [IsHeaderControl],
                        [IsDelete]
                    )
                VALUES
                    (
                        @FormId, @MenuId, @ControlName, @ControlDescription, @IsBackRoundControl, @IsHeaderControl, 0
                    );
                IF (@@ROWCOUNT > 0)
                    BEGIN
                        SET @Message_Code = 'SUCCESS'
                        SET @ErrorMessage = N''
                    END;
            END;
        ELSE
            BEGIN
                SET @Message_Code = N'CONTROL NAME ALREADY EXISTS';
                SET @ErrorMessage = N''
            END;

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];


        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        SET @Message_Code = 'ERROR'
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [ErrorMessage],
                [LogDateTime]
            )
        VALUES
            (
                'sp_SaveFormControls', @ErrorMessage, GETDATE()
            );

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveLocation]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SaveLocation]
    @Description VARCHAR(50)  = NULL,
    @LocAddress  VARCHAR(500) = NULL
AS
    BEGIN TRY

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';
        BEGIN TRANSACTION
        INSERT INTO [dbo].[tblLocationMstr]
            (
                [Descriptions],
                [LocAddress],
                [IsActive]
            )
        VALUES
            (
                @Description, @LocAddress, 1
            );

        IF (@@ROWCOUNT > 0)
            BEGIN
                SET @Message_Code = 'SUCCESS'
                SET @ErrorMessage = N''
            END;

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];


        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        SET @Message_Code = 'ERROR'
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [ErrorMessage],
                [LogDateTime]
            )
        VALUES
            (
                'sp_SaveLocation', @ErrorMessage, GETDATE()
            );

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveNewtUnit]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SaveNewtUnit]
    @ProjectId               INT            = NULL,
    @IsParking               BIT            = NULL,
    @FloorNo                 INT            = NULL,
    @AreaSqm                 DECIMAL(18, 2) = NULL,
    @AreaRateSqm             DECIMAL(18, 2) = NULL,
    @AreaTotalAmount         DECIMAL(18, 2) = NULL,
    @FloorType               VARCHAR(50)    = NULL,
    @BaseRental              DECIMAL(18, 2) = NULL,
    @DetailsofProperty       VARCHAR(300)   = NULL,
    @UnitNo                  VARCHAR(20)    = NULL,
    @UnitSequence            INT            = NULL,
    @BaseRentalVatAmount     DECIMAL(18, 2) = NULL,
    @BaseRentalWithVatAmount DECIMAL(18, 2) = NULL,
    @BaseRentalTax           DECIMAL(18, 2) = NULL,
    @IsNonVat                BIT            = NULL,
    @TotalRental             DECIMAL(18, 2) = NULL,
    @SecAndMainAmount        DECIMAL(18, 2) = NULL,
    @SecAndMainVatAmount     DECIMAL(18, 2) = NULL,
    @SecAndMainWithVatAmount DECIMAL(18, 2) = NULL,
    @Vat                     DECIMAL(18, 2) = NULL,
    @Tax                     DECIMAL(18, 2) = NULL,
    @TaxAmount               DECIMAL(18, 2) = NULL,
    @EndodedBy               INT            = NULL,
    @ComputerName            VARCHAR(20)    = NULL
AS
    BEGIN TRY

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';
        BEGIN TRANSACTION
        IF NOT EXISTS
            (
                SELECT
                    1
                FROM
                    [dbo].[tblUnitMstr]
                WHERE
                    [tblUnitMstr].[ProjectId] = @ProjectId
                    AND [tblUnitMstr].[UnitNo] = @UnitNo
                    AND [tblUnitMstr].[FloorType] = @FloorType
                    AND [tblUnitMstr].[IsParking] = @IsParking
            )
            BEGIN
                INSERT INTO [dbo].[tblUnitMstr]
                    (
                        [ProjectId],
                        [IsParking],
                        [FloorNo],
                        [AreaSqm],
                        [AreaRateSqm],
                        [AreaTotalAmount],
                        [FloorType],
                        [BaseRental],
                        [UnitStatus],
                        [DetailsofProperty],
                        [UnitNo],
                        [UnitSequence],
                        [EndodedBy],
                        [EndodedDate],
                        [IsActive],
                        [ComputerName],
                        [BaseRentalVatAmount],
                        [BaseRentalWithVatAmount],
                        [BaseRentalTax],
                        [IsNonVat],
                        [TotalRental],
                        [SecAndMainAmount],
                        [SecAndMainVatAmount],
                        [SecAndMainWithVatAmount],
                        [Vat],
                        [Tax],
                        [TaxAmount]
                    )
                VALUES
                    (
                        @ProjectId, @IsParking, @FloorNo, @AreaSqm, @AreaRateSqm, @AreaTotalAmount, @FloorType,
                        @BaseRental, 'VACANT', @DetailsofProperty, @UnitNo, @UnitSequence, @EndodedBy, GETDATE(), 1,
                        @ComputerName, @BaseRentalVatAmount, @BaseRentalWithVatAmount, @BaseRentalTax, @IsNonVat,
                        @TotalRental, @SecAndMainAmount, @SecAndMainVatAmount, @SecAndMainWithVatAmount, @Vat, @Tax,
                        @TaxAmount
                    );

                IF (@@ROWCOUNT > 0)
                    BEGIN
                        SET @Message_Code = 'SUCCESS'
                        SET @ErrorMessage = N''
                    END;
            END;
        ELSE
            BEGIN
                SET @Message_Code = 'UNIT NUMBER ALREADY TAKEN.';
                SET @ErrorMessage = N''
            END;


        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];


        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        SET @Message_Code = 'ERROR'
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [ErrorMessage],
                [LogDateTime]
            )
        VALUES
            (
                'sp_SaveNewtUnit', @ErrorMessage, GETDATE()
            );

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveProject]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SaveProject]
    @ProjectType    VARCHAR(50)  = NULL,
    @LocId          INT          = NULL,
    @ProjectName    VARCHAR(50)  = NULL,
    @Descriptions   VARCHAR(50)  = NULL,
    @ProjectAddress VARCHAR(500) = NULL,
    @CompanyId      INT          = NULL
AS
    BEGIN TRY

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';
        BEGIN TRANSACTION

        IF NOT EXISTS
            (
                SELECT
                    [tblProjectMstr].[ProjectName]
                FROM
                    [dbo].[tblProjectMstr]
                WHERE
                    [tblProjectMstr].[ProjectName] = @ProjectName
            )
            BEGIN
                INSERT INTO [dbo].[tblProjectMstr]
                    (
                        [ProjectType],
                        [LocId],
                        [ProjectName],
                        [Descriptions],
                        [ProjectAddress],
                        [IsActive],
                        [CompanyId]
                    )
                VALUES
                    (
                        @ProjectType, @LocId, @ProjectName, @Descriptions, @ProjectAddress, 1, @CompanyId
                    );

                IF (@@ROWCOUNT > 0)
                    BEGIN
                        SET @Message_Code = 'SUCCESS'
                        SET @ErrorMessage = N''
                    END;
            END;
        ELSE
            BEGIN
                SELECT
                    'PROJECT NAME ALREADY EXISTS' AS [Message_Code];
                SET @ErrorMessage = N''
            END;
        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];


        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        SET @Message_Code = 'ERROR'
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [ErrorMessage],
                [LogDateTime]
            )
        VALUES
            (
                'sp_SaveProject', @ErrorMessage, GETDATE()
            );

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END CATCH

GO
/****** Object:  StoredProcedure [dbo].[sp_SavePurchaseItem]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SavePurchaseItem]
    @ProjectId    INT            = NULL,
    @Descriptions VARCHAR(200)   = NULL,
    @DatePurchase DATETIME       = NULL,
    @UnitAmount   INT            = NULL,
    @Amount       DECIMAL(18, 2) = NULL,
    @TotalAmount  DECIMAL(18, 2) = NULL,
    @Remarks      VARCHAR(200)   = NULL,
    @UnitNumber   VARCHAR(50)    = NULL,
    @UnitID       INT            = NULL,
    @EncodedBy    INT            = NULL,
    @ComputerName VARCHAR(50)    = NULL
AS
    BEGIN TRY

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';
        BEGIN TRANSACTION

        IF NOT EXISTS
            (
                SELECT
                    *
                FROM
                    [dbo].[tblProjPurchItem]
                WHERE
                    [tblProjPurchItem].[Descriptions] = @Descriptions
                    AND [tblProjPurchItem].[ProjectId] = @ProjectId
            )
            BEGIN
                INSERT INTO [dbo].[tblProjPurchItem]
                    (
                        [ProjectId],
                        [Descriptions],
                        [DatePurchase],
                        [UnitAmount],
                        [Amount],
                        [TotalAmount],
                        [Remarks],
                        [UnitNumber],
                        [UnitID],
                        [EncodedBy],
                        [EncodedDate],
                        [ComputerName],
                        [IsActive]
                    )
                VALUES
                    (
                        @ProjectId, @Descriptions, @DatePurchase, @UnitAmount, @Amount, @TotalAmount, @Remarks,
                        @UnitNumber, @UnitID, @EncodedBy, GETDATE(), @ComputerName, 1
                    );

                IF (@@ROWCOUNT > 0)
                    BEGIN

                        SET @Message_Code = 'SUCCESS'
                        SET @ErrorMessage = N''
                    END;
            END;
        ELSE
            BEGIN

                SET @Message_Code = 'PROJECT NAME ALREADY EXISTS'
                SET @ErrorMessage = N''
            END;
        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];


        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        SET @Message_Code = 'ERROR'
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [ErrorMessage],
                [LogDateTime]
            )
        VALUES
            (
                'sp_SavePurchaseItem', @ErrorMessage, GETDATE()
            );

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveUser]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_SaveUser]
    @GroupId AS      INT           = NULL,
    @UserId AS       INT           = NULL,
    @UserPassword AS NVARCHAR(MAX) = NULL,
    @UserName AS     VARCHAR(200)  = NULL,
    @StaffName AS    VARCHAR(200)  = NULL,
    @Middlename AS   VARCHAR(50)   = NULL,
    @Lastname AS     VARCHAR(50)   = NULL,
    @EmailAddress AS VARCHAR(100)  = NULL,
    @Phone AS        VARCHAR(20)   = NULL,
    @Mode AS         VARCHAR(20)   = NULL
AS
    BEGIN TRY

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';
        BEGIN TRANSACTION

        IF @Mode = 'NEW'
            BEGIN

                IF NOT EXISTS
                    (
                        SELECT
                            [tblUser].[UserName]
                        FROM
                            [dbo].[tblUser]
                        WHERE
                            [tblUser].[UserName] = @UserName
                            AND [tblUser].[GroupId] = @GroupId
                    )
                    BEGIN
                        INSERT INTO [dbo].[tblUser]
                            (
                                [GroupId],
                                [UserName],
                                [UserPassword],
                                [UserPasswordIncrypt],
                                [StaffName],
                                [Middlename],
                                [Lastname],
                                [EmailAddress],
                                [Phone],
                                [IsDelete]
                            )
                        VALUES
                            (
                                @GroupId,      -- GroupId - int
                                @UserName,     -- UserName - varchar(100)
                                @UserPassword, -- UserPassword - nvarchar(max)
                                NULL,          -- UserPasswordIncrypt - varchar(200)
                                @StaffName,    -- StaffName - varchar(200)
                                @Middlename,   -- Middlename - varchar(50)
                                @Lastname,     -- Lastname - varchar(50)
                                @EmailAddress, -- EmailAddress - varchar(100)
                                @Phone,        -- Phone - varchar(20)
                                0              -- IsDelete - bit
                            );


                        IF (@@ROWCOUNT > 0)
                            BEGIN

                                SET @Message_Code = 'SUCCESS'
                                SET @ErrorMessage = N''
                            END;
                    END;
                ELSE
                    BEGIN
                        SET @Message_Code = N'User Name is already associate to other Group';
                        SET @ErrorMessage = N''
                    END;

            END;
        ELSE IF @Mode = 'EDIT'
            BEGIN
                UPDATE
                    [dbo].[tblUser]
                SET
                    [tblUser].[GroupId] = @GroupId,
                    [tblUser].[UserPassword] = @UserPassword,
                    [tblUser].[UserName] = @UserName,
                    [tblUser].[StaffName] = @StaffName,
                    [tblUser].[Lastname] = @Lastname,
                    [tblUser].[Middlename] = @Middlename,
                    [tblUser].[EmailAddress] = @EmailAddress,
                    [tblUser].[Phone] = @Phone
                WHERE
                    [tblUser].[UserId] = @UserId;

                IF (@@ROWCOUNT > 0)
                    BEGIN

                        SET @Message_Code = 'SUCCESS'
                        SET @ErrorMessage = N''
                    END;



            END;

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];


        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        SET @Message_Code = 'ERROR'
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [ErrorMessage],
                [LogDateTime]
            )
        VALUES
            (
                'sp_SaveUser', @ErrorMessage, GETDATE()
            );

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveUserGroup]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_SaveUserGroup] @GroupName AS VARCHAR(50) = NULL
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
    BEGIN TRY

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';
        BEGIN TRANSACTION
        IF NOT EXISTS
            (
                SELECT
                    [tblGroup].[GroupName]
                FROM
                    [dbo].[tblGroup]
                WHERE
                    [tblGroup].[GroupName] = @GroupName
            )
            BEGIN


                INSERT INTO [dbo].[tblGroup]
                    (
                        [GroupName],
                        [IsDelete]
                    )
                VALUES
                    (
                        UPPER(@GroupName), -- GroupName - varchar(50)
                        0                  -- IsDelete - bit
                    );
                IF (@@ROWCOUNT > 0)
                    BEGIN
                        MERGE INTO [dbo].[tblGroupFormControls] AS [target]
                        USING
                            (
                                SELECT
                                               [tblFormControlsMaster].[FormId],
                                               [tblFormControlsMaster].[ControlId],
                                               [tblGroup].[GroupId],
                                               1 AS [IsVisible],
                                               0 AS [IsDelete]
                                FROM
                                               [dbo].[tblFormControlsMaster]
                                    CROSS JOIN [dbo].[tblGroup]
                            ) AS [source]
                        ON [target].[FormId] = [source].[FormId]
                           AND [target].[ControlId] = [source].[ControlId]
                           AND [target].[GroupId] = [source].[GroupId]
                        WHEN NOT MATCHED
                            THEN INSERT
                                     (
                                         [FormId],
                                         [ControlId],
                                         [GroupId],
                                         [IsVisible],
                                         [IsDelete]
                                     )
                                 VALUES
                                     (
                                         [source].[FormId], [source].[ControlId], [source].[GroupId],
                                         [source].[IsVisible], [source].[IsDelete]
                                     );
                        SET @Message_Code = 'SUCCESS'
                        SET @ErrorMessage = N''
                    END;
            END;
        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];


        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        SET @Message_Code = 'ERROR'
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [ErrorMessage],
                [LogDateTime]
            )
        VALUES
            (
                'sp_SaveUserGroup', @ErrorMessage, GETDATE()
            );

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END CATCH

GO
/****** Object:  StoredProcedure [dbo].[sp_SelectBankName]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SelectBankName]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT ISNULL([tblBankName].[BankName], '') AS [BankName]
    FROM [dbo].[tblBankName]
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectFloorTypes]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SelectFloorTypes]
-- Add the parameters for the stored procedure here

AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
        SELECT
            -1           AS [RecId],
            '--SELECT--' AS [FloorTypesDescription]
        UNION
        SELECT
            [tblFloorTypes].[RecId],
            [tblFloorTypes].[FloorTypesDescription]
        FROM
            [dbo].[tblFloorTypes];
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectLocation]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SelectLocation]
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
        SELECT
            [tblLocationMstr].[RecId],
            [tblLocationMstr].[Descriptions]
        FROM
            [dbo].[tblLocationMstr]
        UNION
        SELECT
            -1,
            '--SELECT--';
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectPaymentMode]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_SelectPaymentMode]
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;


        --SELECT -1 AS ModeType,'--SELECT--' AS Mode
        --UNION
        SELECT
            'PDC' AS [ModeType],
            'PDC' AS [Mode]
        UNION
        SELECT
            'BANK' AS [ModeType],
            'BANK' AS [Mode]
        UNION
        SELECT
            'CASH' AS [ModeType],
            'CASH' AS [Mode]
        UNION
        SELECT
            'DC' AS [ModeType],
            'DC' AS [Mode]
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectProject]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SelectProject]
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here

        SELECT
            -1           AS [RecId],
            '--SELECT--' AS [ProjectName]
        UNION
        SELECT
            [tblProjectMstr].[RecId],
            [tblProjectMstr].[ProjectName]
        FROM
            [dbo].[tblProjectMstr]
        WHERE
            ISNULL([tblProjectMstr].[IsActive], 0) = 1;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectProjectAll]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_SelectProjectAll]
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here

        SELECT
            0        AS [RecId],
            '--ALL--' AS [ProjectName]
        UNION
        SELECT
            [tblProjectMstr].[RecId],
            [tblProjectMstr].[ProjectName]
        FROM
            [dbo].[tblProjectMstr]
        WHERE
            ISNULL([tblProjectMstr].[IsActive], 0) = 1;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectProjectType]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SelectProjectType]
-- Add the parameters for the stored procedure here

AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
        SELECT
            -1           AS [Recid],
            '--SELECT--' AS [ProjectTypeName]
        UNION
        SELECT
            [tblProjectType].[Recid],
            [tblProjectType].[ProjectTypeName]
        FROM
            [dbo].[tblProjectType] WITH (NOLOCK);



    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_TEMPLATE]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_TEMPLATE]
AS
    BEGIN

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';
        BEGIN TRANSACTION

        IF (@@ROWCOUNT > 0)
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
                        'sp_TEMPLATE', @ErrorMessage, GETDATE()
                    );


            END
        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END





--SELECT
--       @ErrorMessage AS [ErrorMessage],
--       @Message_Code AS [Message_Code],
--       @RcptID       AS [ReceiptID],
--       @TranID       AS [TranID]







GO
/****** Object:  StoredProcedure [dbo].[sp_TerminateContract]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_TerminateContract]
    @ReferenceID  VARCHAR(50) = NULL,
    @EncodedBy    INT         = NULL,
    @ComputerName VARCHAR(20) = NULL
AS
    BEGIN TRY

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';
        BEGIN TRANSACTION
        UPDATE
            [dbo].[tblUnitReference]
        SET
            [tblUnitReference].[IsTerminated] = 1,
            [tblUnitReference].[IsUnitMoveOut] = 1,
            [tblUnitReference].[LastCHangedBy] = @EncodedBy,
            [tblUnitReference].[UnitMoveOutDate] = GETDATE(),
            [tblUnitReference].[TerminationDate] = GETDATE()
        WHERE
            [tblUnitReference].[RefId] = @ReferenceID;

        IF (@@ROWCOUNT > 0)
            BEGIN

                SET @Message_Code = 'SUCCESS'
                SET @ErrorMessage = N''
            END;


        UPDATE
            [dbo].[tblUnitMstr]
        SET
            [tblUnitMstr].[UnitStatus] = 'HOLD'
        --LastCHangedBy = @EncodedBy,
        --ComputerName = @ComputerName,
        --LastChangedDate = GETDATE()
        WHERE
            [RecId] =
            (
                SELECT
                    [tblUnitReference].[UnitId]
                FROM
                    [dbo].[tblUnitReference]
                WHERE
                    [tblUnitReference].[RefId] = @ReferenceID
            );

        IF (@@ROWCOUNT > 0)
            BEGIN


                SET @Message_Code = 'SUCCESS'
                SET @ErrorMessage = N''
            END;

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];


        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        SET @Message_Code = 'ERROR'
        SET @ErrorMessage = ERROR_MESSAGE()

        INSERT INTO [dbo].[ErrorLog]
            (
                [ProcedureName],
                [ErrorMessage],
                [LogDateTime]
            )
        VALUES
            (
                'sp_TerminateContract', @ErrorMessage, GETDATE()
            );

        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];
    END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateAnnouncement]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_UpdateAnnouncement] @Message AS NVARCHAR(MAX) = ''
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
BEGIN
    UPDATE [dbo].[tblAnnouncement]
    SET [tblAnnouncement].[AnnounceMessage] = @Message

	IF @@ROWCOUNT > 0
	BEGIN
	SELECT 'SUCCESS' AS Message_Code
	END

END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateClient]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_UpdateClient]
    @ClientID          VARCHAR(50),
    @ClientType        VARCHAR(50),
    @ClientName        VARCHAR(100),
    @Age               INT            = 0,
    @PostalAddress     VARCHAR(100)   = NULL,
    @DateOfBirth       DATE           = NULL,
    @TelNumber         VARCHAR(20)    = NULL,
    @Gender            BIT            = NULL,
    @Nationality       VARCHAR(50)    = NULL,
    @Occupation        VARCHAR(100)   = NULL,
    @AnnualIncome      DECIMAL(18, 2) = 0,
    @EmployerName      VARCHAR(100)   = NULL,
    @EmployerAddress   VARCHAR(200)   = NULL,
    @SpouseName        VARCHAR(100)   = NULL,
    @ChildrenNames     VARCHAR(500)   = NULL,
    @TotalPersons      INT            = 0,
    @MaidName          VARCHAR(100)   = NULL,
    @DriverName        VARCHAR(100)   = NULL,
    @VisitorsPerDay    INT            = 0,
    @BuildingSecretary INT            = 0,
    @EncodedBy         INT            = 0,
    @ComputerName      VARCHAR(50)    = NULL,
    @TIN_No            VARCHAR(50)    = NULL,
    @IsActive          BIT            = NULL
AS
    BEGIN

        SET NOCOUNT ON;
        DECLARE @Message_Code VARCHAR(MAX) = '';
        DECLARE @ErrorMessage NVARCHAR(MAX) = N'';

        UPDATE
            [dbo].[tblClientMstr]
        SET
            [tblClientMstr].[ClientType] = @ClientType,
            [tblClientMstr].[ClientName] = @ClientName,
            [tblClientMstr].[Age] = @Age,
            [tblClientMstr].[PostalAddress] = @PostalAddress,
            [tblClientMstr].[DateOfBirth] = @DateOfBirth,
            [tblClientMstr].[TelNumber] = @TelNumber,
            [tblClientMstr].[Gender] = @Gender,
            [tblClientMstr].[Nationality] = @Nationality,
            [tblClientMstr].[Occupation] = @Occupation,
            [tblClientMstr].[AnnualIncome] = @AnnualIncome,
            [tblClientMstr].[EmployerName] = @EmployerName,
            [tblClientMstr].[EmployerAddress] = @EmployerAddress,
            [tblClientMstr].[SpouseName] = @SpouseName,
            [tblClientMstr].[ChildrenNames] = @ChildrenNames,
            [tblClientMstr].[TotalPersons] = @TotalPersons,
            [tblClientMstr].[MaidName] = @MaidName,
            [tblClientMstr].[DriverName] = @DriverName,
            [tblClientMstr].[VisitorsPerDay] = @VisitorsPerDay,
            [tblClientMstr].[BuildingSecretary] = @BuildingSecretary,
            [tblClientMstr].[LastChangedDate] = GETDATE(),
            [tblClientMstr].[LastChangedBy] = @EncodedBy,
            --[IsActive]= @IsActive,
            [tblClientMstr].[ComputerName] = @ComputerName,
            [tblClientMstr].[TIN_No] = @TIN_No
        WHERE
            [tblClientMstr].[ClientID] = @ClientID


        IF (@@ROWCOUNT > 0)
            BEGIN
                SET @Message_Code = 'SUCCESS'
            END;

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
                        'sp_UpdateClient', @ErrorMessage, GETDATE()
                    );
            END
        SELECT
            @ErrorMessage AS [ErrorMessage],
            @Message_Code AS [Message_Code];

    END

GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateCOMMERCIALSettings]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateCOMMERCIALSettings]
    @GenVat DECIMAL(18, 2) = NULL,
    @SecurityAndMaintenance DECIMAL(18, 2) = NULL,
    @WithHoldingTax DECIMAL(18, 2) = NULL,
    @PenaltyPct DECIMAL(18, 2) = NULL,
    @LastChangedBy INT = NULL
AS
BEGIN

    SET NOCOUNT ON;


    UPDATE [dbo].[tblRatesSettings]
    SET [tblRatesSettings].[GenVat] = @GenVat,
        [tblRatesSettings].[SecurityAndMaintenance] = @SecurityAndMaintenance,
        [tblRatesSettings].[WithHoldingTax] = @WithHoldingTax,
        [tblRatesSettings].[PenaltyPct] = @PenaltyPct,
        [tblRatesSettings].[LastChangedBy] = @LastChangedBy,
        [tblRatesSettings].[LastChangedDate] = GETDATE()
    WHERE [tblRatesSettings].[ProjectType] = 'COMMERCIAL';

    IF (@@ROWCOUNT > 0)
    BEGIN
        SELECT 'SUCCESS' AS [Message_Code];
    END;
    ELSE
    BEGIN
        SELECT ERROR_MESSAGE() AS [Message_Code];
    END;


END;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateCompany]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_UpdateCompany]
    @RecId INT = NULL,
    @CompanyName VARCHAR(200) = NULL,
    @CompanyAddress VARCHAR(500) = NULL,
    @CompanyTIN VARCHAR(20) = NULL,
    @CompanyOwnerName VARCHAR(100) = NULL,
    @ComputerName VARCHAR(100) = NULL,
    @EncodedBy INT = NULL
AS
BEGIN
    DECLARE @Message_Code VARCHAR(MAX) = ''

    IF EXISTS
    (
        SELECT 1
        FROM [dbo].[tblCompany]
        WHERE [tblCompany].[CompanyName] = UPPER(@CompanyName)
    )
    BEGIN

        UPDATE [dbo].[tblCompany]
        SET [tblCompany].[CompanyName] = UPPER(@CompanyName),
            [tblCompany].[CompanyAddress] = @CompanyAddress,
            [tblCompany].[CompanyTIN] = @CompanyTIN,
            [tblCompany].[CompanyOwnerName] = UPPER(@CompanyOwnerName),
            [tblCompany].[LastChangedBy] = @EncodedBy,
            [tblCompany].[LastChangedDate] = GETDATE(),
            [tblCompany].[ComputerName] = @ComputerName
        WHERE [tblCompany].[RecId] = @RecId
        IF @@ROWCOUNT > 0
        BEGIN
            SET @Message_Code = 'SUCCESS'
        END
        ELSE
        BEGIN
            SET @Message_Code = ERROR_MESSAGE();
        END
    END
    ELSE
    BEGIN
        SET @Message_Code = 'COMPANY NOT EXIST';
    END

    SELECT @Message_Code AS [Message_Code]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateGroupFormControls]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_UpdateGroupFormControls]
    @FormId AS    INT = NULL,
    @ControlId AS INT = NULL,
    @GroupId AS   INT = NULL,
    @IsVisible AS BIT = NULL
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @Message_Code AS NVARCHAR(MAX) = N'';
        UPDATE
            [dbo].[tblGroupFormControls]
        SET
            [tblGroupFormControls].[IsVisible] = @IsVisible
        WHERE
            [tblGroupFormControls].[FormId] = @FormId
            AND [tblGroupFormControls].[ControlId] = @ControlId
            AND [tblGroupFormControls].[GroupId] = @GroupId;


        IF (@@ROWCOUNT > 0)
            BEGIN
                SET @Message_Code = N'SUCCESS';
            END;
        ELSE
            BEGIN
                SET @Message_Code = ERROR_MESSAGE();
            END;
        SELECT
            @Message_Code AS [Message_Code];
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateLocationById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateLocationById]
    @RecId        INT,
    @Descriptions VARCHAR(50)  = NULL,
    @LocAddress   VARCHAR(500) = NULL
--@IsActive bit = NULL

AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;


        UPDATE
            [dbo].[tblLocationMstr]
        SET
            [tblLocationMstr].[Descriptions] = @Descriptions,
            [tblLocationMstr].[LocAddress] = @LocAddress
        WHERE
            [tblLocationMstr].[RecId] = @RecId;

        IF (@@ROWCOUNT > 0)
            BEGIN

                SELECT
                    'SUCCESS' AS [Message_Code];

            END;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateORNumber]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_UpdateORNumber]
    @RcptID AS VARCHAR(20) = NULL,
    @CompanyORNo AS VARCHAR(20) = NULL,
    @EncodedBy AS INT = NULL
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
BEGIN
    UPDATE [dbo].[tblReceipt]
    SET [tblReceipt].[CompanyORNo] = @CompanyORNo,
        [tblReceipt].[EncodedBy] = @EncodedBy,
        [tblReceipt].[EncodedDate] = GETDATE()
    WHERE [tblReceipt].[RcptID] = @RcptID;
    UPDATE [dbo].[tblPaymentMode]
    SET [tblPaymentMode].[CompanyORNo] = @CompanyORNo
    WHERE [tblPaymentMode].[RcptID] = @RcptID;

    IF @@ROWCOUNT > 0
    BEGIN
        SELECT 'SUCCESS' AS Message_Code;

    END;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateProjectById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateProjectById]
    @RecId          INT,
    @ProjectType    VARCHAR(50)  = NULL,
    @LocId          INT,
    @ProjectName    VARCHAR(50)  = NULL,
    @Descriptions   VARCHAR(500) = NULL,
    @ProjectAddress VARCHAR(500) = NULL
AS
    BEGIN

        SET NOCOUNT ON;


        UPDATE
            [dbo].[tblProjectMstr]
        SET
            [tblProjectMstr].[LocId] = @LocId,
            [tblProjectMstr].[Descriptions] = @Descriptions,
            [tblProjectMstr].[ProjectName] = @ProjectName,
            [tblProjectMstr].[ProjectType] = @ProjectType,
            [tblProjectMstr].[ProjectAddress] = @ProjectAddress
        WHERE
            [tblProjectMstr].[RecId] = @RecId;

        IF (@@ROWCOUNT > 0)
            BEGIN

                SELECT
                    'SUCCESS' AS [Message_Code];

            END;
    END;

GO
/****** Object:  StoredProcedure [dbo].[sp_UpdatePurchaseItemById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdatePurchaseItemById]
    @RecId         INT,
    @ProjectId     INT,
    @Descriptions  VARCHAR(50)    = NULL,
    @DatePurchase  VARCHAR(500)   = NULL,
    @UnitAmount    DECIMAL(18, 2) = NULL,
    @Amount        DECIMAL(18, 2) = NULL,
    @TotalAmount   DECIMAL(18, 2) = NULL,
    @Remarks       VARCHAR(200)   = NULL,
    @UnitNumber    VARCHAR(50)    = NULL,
    @UnitID        INT            = NULL,
    @LastChangedBy INT            = NULL,
    @ComputerName  VARCHAR(50)    = NULL
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        IF EXISTS
            (
                SELECT
                    *
                FROM
                    [dbo].[tblProjPurchItem]
                WHERE
                    [tblProjPurchItem].[RecId] = @RecId
            )
            BEGIN

                UPDATE
                    [dbo].[tblProjPurchItem]
                SET
                    [tblProjPurchItem].[ProjectId] = @ProjectId,
                    [tblProjPurchItem].[Descriptions] = @Descriptions,
                    [tblProjPurchItem].[DatePurchase] = @DatePurchase,
                    [tblProjPurchItem].[UnitAmount] = @UnitAmount,
                    [tblProjPurchItem].[Amount] = @Amount,
                    [tblProjPurchItem].[TotalAmount] = @TotalAmount,
                    [tblProjPurchItem].[Remarks] = @Remarks,
                    [tblProjPurchItem].[UnitNumber] = @UnitNumber,
                    [tblProjPurchItem].[UnitID] = @UnitID,
                    [tblProjPurchItem].[LastChangedBy] = @LastChangedBy,
                    [tblProjPurchItem].[LastChangedDate] = GETDATE(),
                    [tblProjPurchItem].[ComputerName] = @ComputerName
                WHERE
                    [tblProjPurchItem].[RecId] = @RecId;

                IF (@@ROWCOUNT > 0)
                    BEGIN

                        SELECT
                            'SUCCESS' AS [Message_Code];

                    END;
            END;
        ELSE
            BEGIN

                SELECT
                    'NOT EXISTS' AS [Message_Code];

            END;
    END;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateRESIDENTIALSettings]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateRESIDENTIALSettings]
    @GenVat DECIMAL(18, 2) = NULL,
    @SecurityAndMaintenance DECIMAL(18, 2) = NULL,
    @PenaltyPct DECIMAL(18, 2) = NULL,
    @LastChangedBy INT = NULL
AS
BEGIN

    SET NOCOUNT ON;


    UPDATE [dbo].[tblRatesSettings]
    SET [tblRatesSettings].[GenVat] = @GenVat,
        [tblRatesSettings].[SecurityAndMaintenance] = @SecurityAndMaintenance,
        [tblRatesSettings].[PenaltyPct] = @PenaltyPct,
        [tblRatesSettings].[LastChangedBy] = @LastChangedBy,
        [tblRatesSettings].[LastChangedDate] = GETDATE()
    WHERE [tblRatesSettings].[ProjectType] = 'RESIDENTIAL';

    IF (@@ROWCOUNT > 0)
    BEGIN
        SELECT 'SUCCESS' AS [Message_Code];
    END;
    ELSE
    BEGIN
        SELECT ERROR_MESSAGE() AS [Message_Code];
    END;

END;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateUnitById]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE     PROCEDURE [dbo].[sp_UpdateUnitById]
    @RecId                   INT,
    @ProjectId               INT            = NULL,
    @IsParking               BIT            = NULL,
    @FloorNo                 INT            = NULL,
    @AreaSqm                 DECIMAL(18, 2) = NULL,
    @AreaRateSqm             DECIMAL(18, 2) = NULL,
    @AreaTotalAmount         DECIMAL(18, 2) = NULL,
    @FloorType               VARCHAR(50)    = NULL,
    @BaseRental              DECIMAL(18, 2) = NULL,
    @DetailsofProperty       VARCHAR(300)   = NULL,
    @UnitNo                  VARCHAR(20)    = NULL,
    @UnitSequence            INT            = NULL,
    @BaseRentalVatAmount     DECIMAL(18, 2) = NULL,
    @BaseRentalWithVatAmount DECIMAL(18, 2) = NULL,
    @BaseRentalTax           DECIMAL(18, 2) = NULL,
    @IsNonVat                BIT            = NULL,
    @TotalRental             DECIMAL(18, 2) = NULL,
    @SecAndMainAmount        DECIMAL(18, 2) = NULL,
    @SecAndMainVatAmount     DECIMAL(18, 2) = NULL,
    @SecAndMainWithVatAmount DECIMAL(18, 2) = NULL,
    @Vat                     DECIMAL(18, 2) = NULL,
    @Tax                     DECIMAL(18, 2) = NULL,
    @TaxAmount               DECIMAL(18, 2) = NULL,
    @LastChangedBy           INT            = NULL,
    @ComputerName            VARCHAR(20)    = NULL,
    @UnitStatus              VARCHAR(300)   = NULL
AS
    BEGIN
        DECLARE @Message_Code VARCHAR(100) = '';
        UPDATE
            [dbo].[tblUnitMstr]
        SET
            [tblUnitMstr].[ProjectId] = @ProjectId,
            [tblUnitMstr].[IsParking] = @IsParking,
            [tblUnitMstr].[FloorNo] = @FloorNo,
            [tblUnitMstr].[AreaSqm] = @AreaSqm,
            [tblUnitMstr].[AreaRateSqm] = @AreaRateSqm,
            [tblUnitMstr].[AreaTotalAmount] = @AreaTotalAmount,
            [tblUnitMstr].[FloorType] = @FloorType,
            [tblUnitMstr].[BaseRental] = @BaseRental,
            [tblUnitMstr].[DetailsofProperty] = @DetailsofProperty,
            [tblUnitMstr].[UnitNo] = @UnitNo,
            [tblUnitMstr].[UnitSequence] = @UnitSequence,
            [tblUnitMstr].[BaseRentalVatAmount] = @BaseRentalVatAmount,
            [tblUnitMstr].[BaseRentalWithVatAmount] = @BaseRentalWithVatAmount,
            [tblUnitMstr].[BaseRentalTax] = @BaseRentalTax,
            [tblUnitMstr].[IsNonVat] = @IsNonVat,
            [tblUnitMstr].[TotalRental] = @TotalRental,
            [tblUnitMstr].[SecAndMainAmount] = @SecAndMainAmount,
            [tblUnitMstr].[SecAndMainVatAmount] = @SecAndMainVatAmount,
            [tblUnitMstr].[SecAndMainWithVatAmount] = @SecAndMainWithVatAmount,
            [tblUnitMstr].[Vat] = @Vat,
            [tblUnitMstr].[Tax] = @Tax,
            [tblUnitMstr].[TaxAmount] = @TaxAmount,
            [tblUnitMstr].[LastChangedBy] = @LastChangedBy,
            [tblUnitMstr].[LastChangedDate] = GETDATE(),
            [tblUnitMstr].[ComputerName] = @ComputerName,
            [tblUnitMstr].[UnitStatus] = @UnitStatus
        WHERE
            [tblUnitMstr].[RecId] = @RecId
            AND [tblUnitMstr].[UnitStatus] = 'VACANT'

        IF (@@ROWCOUNT > 0)
            BEGIN
                SET @Message_Code = 'SUCCESS';
            END
        ELSE
            BEGIN
                SET @Message_Code = 'THIS UNIT CURRENTLY OPEN IN CONTRACT, MODIFICATION IS NOT PERMITTED';
            END
        SELECT
            @Message_Code AS [Message_Code];
    END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateUserInfo]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[sp_UpdateUserInfo]
    @UserId AS INT,
    @UserName VARCHAR(50),
    @UserPassword NVARCHAR(50),
    @StaffName VARCHAR(100),
    @Middlename VARCHAR(50),
    @Lastname VARCHAR(50),
    @EmailAddress VARCHAR(50),
    @Phone VARCHAR(20)
AS
BEGIN
    DECLARE @Message_Code VARCHAR(100) = '';
    IF EXISTS
    (
        SELECT 1
        FROM [dbo].[tblUser]
        WHERE [tblUser].[UserId] = @UserId
    )
    BEGIN
        UPDATE [dbo].[tblUser]
        SET [tblUser].[UserName] = @UserName,
            [tblUser].[UserPassword] = @UserPassword,
            [tblUser].[StaffName] = @StaffName,
            [tblUser].[Middlename] = @Middlename,
            [tblUser].[Lastname] = @Lastname,
            [tblUser].[EmailAddress] = @EmailAddress,
            [tblUser].[Phone] = @Phone;

        IF @@ROWCOUNT > 0
        BEGIN
            SET @Message_Code = 'SUCCESS';
        END;
    END;
    ELSE
    BEGIN
        SET @Message_Code = 'User not exixt';
    END;

    SELECT @Message_Code AS [Message_Code];
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateWAREHOUSESettings]    Script Date: 7/3/2024 10:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateWAREHOUSESettings]
    @GenVat DECIMAL(18, 2) = NULL,
    @SecurityAndMaintenance DECIMAL(18, 2) = NULL,
    @WithHoldingTax DECIMAL(18, 2) = NULL,
    @PenaltyPct DECIMAL(18, 2) = NULL,
    @LastChangedBy INT = NULL
AS
BEGIN

    SET NOCOUNT ON;


    UPDATE [dbo].[tblRatesSettings]
    SET [tblRatesSettings].[GenVat] = @GenVat,
        [tblRatesSettings].[SecurityAndMaintenance] = @SecurityAndMaintenance,
        [tblRatesSettings].[WithHoldingTax] = @WithHoldingTax,
        [tblRatesSettings].[PenaltyPct] = @PenaltyPct,
        [tblRatesSettings].[LastChangedBy] = @LastChangedBy,
        [tblRatesSettings].[LastChangedDate] = GETDATE()
    WHERE [tblRatesSettings].[ProjectType] = 'WAREHOUSE';

    IF (@@ROWCOUNT > 0)
    BEGIN
        SELECT 'SUCCESS' AS [Message_Code];
    END;
    ELSE
    BEGIN
        SELECT ERROR_MESSAGE() AS [Message_Code];
    END;


END;
GO
