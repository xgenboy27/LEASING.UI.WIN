SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
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
