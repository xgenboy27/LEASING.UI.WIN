USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_GetParkingAvailableByProjectId]    Script Date: 11/9/2023 9:59:53 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetUnitAvailableByProjectId] @ProjectId = 1
-- =============================================
ALTER PROCEDURE [dbo].[sp_GetParkingAvailableByProjectId] @ProjectId INT
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
