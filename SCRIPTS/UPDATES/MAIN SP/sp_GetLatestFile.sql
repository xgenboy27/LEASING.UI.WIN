USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_GetLatestFile]    Script Date: 11/9/2023 9:59:07 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
ALTER PROCEDURE [dbo].[sp_GetLatestFile]
AS
    BEGIN
        SELECT TOP 1
               [Files].[FilePath],
               [Files].[FileData]
        FROM
               [dbo].[Files]
        ORDER BY
               [Files].[Id] DESC;
    END;
