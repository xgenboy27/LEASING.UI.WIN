USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_GetFilesByClient]    Script Date: 11/9/2023 9:58:18 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
ALTER PROCEDURE [dbo].[sp_GetFilesByClient] @ClientName VARCHAR(50)
AS
    BEGIN
        SELECT
            [Files].[Id],
            [Files].[FilePath],
            [Files].[FileData],
            [Files].[FileNames],
            [Files].[Notes],
            [Files].[Files]
        FROM
            [dbo].[Files]
        WHERE
            [Files].[ClientName] = @ClientName;
    END;

