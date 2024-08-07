CREATE TABLE [dbo].[tblFloorTypes]
(
[RecId] [int] NOT NULL IDENTITY(1, 1),
[FloorTypesDescription] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IdxtblFloorTypes_IsActive] ON [dbo].[tblFloorTypes] ([IsActive]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IdxtblFloorTypes_RecId] ON [dbo].[tblFloorTypes] ([RecId]) ON [PRIMARY]
GO
