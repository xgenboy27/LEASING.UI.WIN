USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_GetGroupList]    Script Date: 1/8/2024 4:52:12 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_GetGroupList]
AS
BEGIN

    SET NOCOUNT ON;
    MERGE INTO [dbo].[tblGroupFormControls] AS [target]
    USING
    (
        SELECT [tblFormControlsMaster].[FormId],
               [tblFormControlsMaster].[ControlId],
               [tblGroup].[GroupId],
               1 AS [IsVisible],
               0 AS [IsDelete]
        FROM [dbo].[tblFormControlsMaster]
            CROSS JOIN [dbo].[tblGroup]
    ) AS [source]
    ON [target].[FormId] = [source].[FormId]
       AND [target].[ControlId] = [source].[ControlId]
       AND [target].[GroupId] = [source].[GroupId]
    WHEN NOT MATCHED THEN
        INSERT
        (
            [FormId],
            [ControlId],
            [GroupId],
            [IsVisible],
            [IsDelete]
        )
        VALUES
        ([source].[FormId], [source].[ControlId], [source].[GroupId], [source].[IsVisible], [source].[IsDelete]);
    SELECT [tblGroup].[GroupId],
           [tblGroup].[GroupName],
           [tblGroup].[IsDelete]
    FROM [dbo].[tblGroup];

END;
