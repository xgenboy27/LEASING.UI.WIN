USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_GetLocationList]    Script Date: 11/9/2023 9:59:34 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_GetLocationList]
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
