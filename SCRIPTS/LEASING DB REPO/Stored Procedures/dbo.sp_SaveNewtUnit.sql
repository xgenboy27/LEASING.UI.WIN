SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SaveNewtUnit]
    @ProjectId INT = NULL,
    @IsParking BIT = NULL,
    @FloorNo INT = NULL,
    @AreaSqm DECIMAL(18, 2) = NULL,
    @AreaRateSqm DECIMAL(18, 2) = NULL,
    @FloorType VARCHAR(50) = NULL,
    @BaseRental DECIMAL(18, 2) = NULL,
    --@UnitStatus VARCHAR(50) = NULL,
    @DetailsofProperty VARCHAR(300) = NULL,
    @UnitNo VARCHAR(20) = NULL,
    @UnitSequence INT = NULL,
    @EndodedBy INT = NULL,
    @ComputerName VARCHAR(20) = NULL,
    @BaseRentalVatAmount DECIMAL(18, 2) = NULL,
    @BaseRentalWithVatAmount DECIMAL(18, 2) = NULL,
    @BaseRentalTax DECIMAL(18, 2) = NULL,
    @IsNonVat BIT = NULL,
    @TotalRental DECIMAL(18, 2) = NULL,
    @SecAndMainAmount DECIMAL(18, 2) = NULL,
    @SecAndMainVatAmount DECIMAL(18, 2) = NULL,
    @SecAndMainWithVatAmount DECIMAL(18, 2) = NULL,
    @Vat DECIMAL(18, 2) = NULL,
    @Tax DECIMAL(18, 2) = NULL,
    @TaxAmount DECIMAL(18, 2) = NULL
AS
BEGIN
    DECLARE @Message_Code VARCHAR(100) = '';
    IF NOT EXISTS
    (
        SELECT 1
        FROM [dbo].[tblUnitMstr]
        WHERE [tblUnitMstr].[ProjectId] = @ProjectId
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
        (@ProjectId, @IsParking, @FloorNo, @AreaSqm, @AreaRateSqm, @FloorType, @BaseRental, 'VACANT',
         @DetailsofProperty, @UnitNo, @UnitSequence, @EndodedBy, GETDATE(), 1, @ComputerName, @BaseRentalVatAmount,
         @BaseRentalWithVatAmount, @BaseRentalTax, @IsNonVat, @TotalRental, @SecAndMainAmount, @SecAndMainVatAmount,
         @SecAndMainWithVatAmount, @Vat, @Tax, @TaxAmount);

        IF (@@ROWCOUNT > 0)
        BEGIN
            SET @Message_Code = 'SUCCESS';
        END;
    END;
    ELSE
    BEGIN
        SET @Message_Code = 'UNIT NUMBER ALREADY TAKEN.';
    END;


    SELECT @Message_Code AS [Message_Code];
END;
GO
