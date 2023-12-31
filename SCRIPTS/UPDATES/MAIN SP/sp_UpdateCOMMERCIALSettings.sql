USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateCOMMERCIALSettings]    Script Date: 11/9/2023 10:05:31 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_UpdateCOMMERCIALSettings]
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
