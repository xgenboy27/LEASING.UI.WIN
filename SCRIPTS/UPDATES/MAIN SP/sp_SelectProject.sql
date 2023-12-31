USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectProject]    Script Date: 11/9/2023 10:05:12 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_SelectProject]
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here

        SELECT
            -1           AS [RecId],
            '--SELECT--' AS [ProjectName]
        UNION
        SELECT
            [tblProjectMstr].[RecId],
            [tblProjectMstr].[ProjectName]
        FROM
            [dbo].[tblProjectMstr]
        WHERE
            ISNULL([tblProjectMstr].[IsActive], 0) = 1;
    END;
