USE [LEASINGDB]
GO
/****** Object:  Trigger [dbo].[tr_tblTransaction_TranID]    Script Date: 3/25/2024 12:14:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER TRIGGER [dbo].[tr_tblTransaction_TranID]
ON [dbo].[tblTransaction]
FOR INSERT
AS
BEGIN

    UPDATE [dbo].[tblTransaction]
    SET [tblTransaction].[TranID] = 'TRN' + CONVERT([VARCHAR](5000), [Inserted].[RecId])
    FROM [dbo].[tblTransaction]
        INNER JOIN [Inserted]
            ON [Inserted].[RecId] = [tblTransaction].[RecId]
    WHERE [Inserted].[RecId] = [tblTransaction].[RecId]

END