SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE OR ALTER   PROCEDURE [dbo].[sp_SelectPaymentMode]
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

