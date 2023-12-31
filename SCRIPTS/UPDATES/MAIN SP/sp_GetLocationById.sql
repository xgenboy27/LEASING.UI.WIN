USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_GetLocationById]    Script Date: 11/9/2023 9:59:25 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_GetLocationById] @RecId INT
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
