USE [LEASINGDB]
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_SaveComputation]
    @ProjectId                     INT,
    @InquiringClient               VARCHAR(500),
    @ClientMobile                  VARCHAR(50),
    @UnitId                        INT,
    @UnitNo                        VARCHAR(50),
    @StatDate                      VARCHAR(10),
    @FinishDate                    VARCHAR(10),
    @Rental                        DECIMAL(18, 2) NULL,
    @SecAndMaintenance             DECIMAL(18, 2),
    @TotalRent                     DECIMAL(18, 2),
    @SecDeposit                    DECIMAL(18, 2),
    @WaterAndElectricityDeposit    DECIMAL(18, 2),
    @Total                         DECIMAL(18, 2),
    @EncodedBy                     INT,
    @ComputerName                  VARCHAR(30),
    @ClientID                      VARCHAR(50),
    @XML                           XML,
    @AdvancePaymentAmount          DECIMAL(18, 2),
    @IsFullPayment                 BIT = 0,
    @IsRenewal                     BIT = 0,
    @DiscountAmount                DECIMAL(18, 2),
    @IsDiscounted                  BIT = 0,
    @IsContractApplyMonthlyPenalty BIT = 0
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
                [Months] VARCHAR(10),
                [Amount] DECIMAL(18, 2)
            );
        IF (@XML IS NOT NULL)
            BEGIN
                INSERT INTO [#tblAdvancePayment]
                    (
                        [Months],
                        [Amount]
                    )
                            SELECT
                                [ParaValues].[data].[value]('c1[1]', 'VARCHAR(10)'),
                                [ParaValues].[data].[value]('c2[1]', 'DECIMAL(18,2)')
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
                [WaterAndElectricityDeposit],
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
                [IsRenewal],
                [DiscountAmount],
                [IsDiscounted],
                [IsContractApplyMonthlyPenalty]
            )
        VALUES
            (
                @ProjectId, @InquiringClient, @ClientMobile, @UnitId, @UnitNo, @StatDate, @FinishDate, GETDATE(),
                @Rental, @SecAndMaintenance, @TotalRent, @SecDeposit, @WaterAndElectricityDeposit, @Total, @EncodedBy,
                GETDATE(), 1, @ComputerName, @ClientID, @GenVat, @WithHoldingTax, @PenaltyPct, @AdvancePaymentAmount,
                @IsFullPayment, @Unit_IsNonVat, @Unit_AreaSqm, @Unit_AreaRateSqm, @Unit_AreaTotalAmount,
                @Unit_BaseRentalVatAmount, @Unit_BaseRentalWithVatAmount, @Unit_BaseRentalTax, @Unit_TotalRental,
                @Unit_SecAndMainAmount, @Unit_SecAndMainVatAmount, @Unit_SecAndMainWithVatAmount, @Unit_Vat, @Unit_Tax,
                @Unit_TaxAmount, @Unit_IsParking, @ProjectType, @IsRenewal, @DiscountAmount, @IsDiscounted,
                @IsContractApplyMonthlyPenalty
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
                                [#tblAdvancePayment].[Amount]
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


        UPDATE
                [dbo].[tblMonthLedger]
        SET
                [tblMonthLedger].[IsAdvanceMonth] = 1,
                [tblMonthLedger].[IsFreeMonth] = IIF([tblAdvancePayment].[Amount] > 0, 0, 1),
                [tblMonthLedger].[AdvanceMonthAmount] = [tblAdvancePayment].[Amount]
        FROM
                [dbo].[tblMonthLedger]
            INNER JOIN
                [dbo].[tblAdvancePayment]
                    ON CONCAT('REF', CAST([tblMonthLedger].[ReferenceID] AS VARCHAR(150))) = [tblAdvancePayment].[RefId]
                       AND [tblMonthLedger].[LedgMonth] = [tblAdvancePayment].[Months]

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

