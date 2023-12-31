USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUnitById]    Script Date: 11/9/2023 10:02:32 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_GetUnitById] @RecId INT
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT
                [tblUnitMstr].[RecId],
                [tblUnitMstr].[ProjectId],
                ISNULL([tblProjectMstr].[ProjectName], '')                          AS [ProjectName],
                IIF(ISNULL([tblUnitMstr].[IsParking], 0) = 1, 'PARKING', 'UNIT')    AS [UnitDescription],
                ISNULL([tblUnitMstr].[FloorNo], 0)                                  AS [FloorNo],
                ISNULL([tblUnitMstr].[AreaSqm], 0)                                  AS [AreaSqm],
                ISNULL([tblUnitMstr].[AreaRateSqm], 0)                              AS [AreaRateSqm],
                ISNULL([tblUnitMstr].[FloorType], '')                               AS [FloorType],
                ISNULL([tblUnitMstr].[BaseRental], 0)                               AS [BaseRental],
                ISNULL([tblUnitMstr].[UnitStatus], '')                              AS [UnitStatus],
                ISNULL([tblUnitMstr].[DetailsofProperty], '')                       AS [DetailsofProperty],
                ISNULL([tblUnitMstr].[UnitNo], '')                                  AS [UnitNo],
                ISNULL([tblUnitMstr].[UnitSequence], 0)                         AS [UnitSequence],
                IIF(ISNULL([tblUnitMstr].[IsActive], 0) = 1, 'ACTIVE', 'IN-ACTIVE') AS [IsActive]
        FROM
                [dbo].[tblUnitMstr]
            INNER JOIN
                [dbo].[tblProjectMstr]
                    ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
        WHERE
                [tblUnitMstr].[RecId] = @RecId
        ORDER BY
                [tblUnitMstr].[UnitSequence] DESC;
    END;
