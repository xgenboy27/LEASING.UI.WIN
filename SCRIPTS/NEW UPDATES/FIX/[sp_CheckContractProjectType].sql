USE [LEASINGDB]
GO
/****** Object:  StoredProcedure [dbo].[sp_CheckContractProjectType]    Script Date: 12/2/2024 5:23:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE OR ALTER PROCEDURE [dbo].[sp_CheckContractProjectType] @RefId AS VARCHAR(20) = NULL
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
                [tblUnitReference].[RefId],
                [tblUnitReference].[UnitId],
                [tblUnitMstr].[UnitNo],
                [tblUnitMstr].[FloorType],
                IIF(ISNULL([tblUnitReference].[Unit_IsParking], 0) = 1, 'PARKING', 'UNIT') AS [UnitType],
                [tblProjectMstr].[ProjectType]
        FROM
                [dbo].[tblUnitReference]
            INNER JOIN
                [dbo].[tblUnitMstr]
                    ON [tblUnitMstr].[RecId] = [tblUnitReference].[UnitId]
            INNER JOIN
                [dbo].[tblProjectMstr]
                    ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
        WHERE
                [tblUnitReference].[RefId] = @RefId
                AND ISNULL([tblUnitReference].[IsDeclineUnit], 0) = 0
    END;
