USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_GetInActiveProjectList]    Script Date: 11/9/2023 9:58:50 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_GetInActiveProjectList]
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
