USE [LEASINGDB]


MERGE INTO [dbo].[tblGroupFormControls] AS [target]
USING
    (
        SELECT
                       [tblFormControlsMaster].[FormId],
                       [tblFormControlsMaster].[ControlId],
                       [tblGroup].[GroupId],
                       1 AS [IsVisible],
                       0 AS [IsDelete]
        FROM
                       [dbo].[tblFormControlsMaster]
            CROSS JOIN [dbo].[tblGroup]
    ) AS [source]
ON [target].[FormId] = [source].[FormId]
   AND [target].[ControlId] = [source].[ControlId]
   AND [target].[GroupId] = [source].[GroupId]
WHEN NOT MATCHED
    THEN INSERT
             (
                 [FormId],
                 [ControlId],
                 [GroupId],
                 [IsVisible],
                 [IsDelete]
             )
         VALUES
             (
                 [source].[FormId], [source].[ControlId], [source].[GroupId], [source].[IsVisible], [source].[IsDelete]
             );