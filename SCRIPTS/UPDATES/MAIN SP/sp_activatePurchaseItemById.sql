USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_activatePurchaseItemById]    Script Date: 11/9/2023 9:53:54 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC sp_GetPurchaseItemInfoById @RecId = 2
-- =============================================
ALTER PROCEDURE [dbo].[sp_activatePurchaseItemById] @RecId INT
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

