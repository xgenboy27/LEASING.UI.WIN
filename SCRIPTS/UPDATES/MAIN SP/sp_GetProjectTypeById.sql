USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProjectTypeById]    Script Date: 11/9/2023 10:00:57 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_GetProjectTypeById] @RecId INT = NULL
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here

        SELECT
            [tblProjectMstr].[ProjectType]
        FROM
            [dbo].[tblProjectMstr]
        WHERE
            [tblProjectMstr].[RecId] = @RecId
            AND ISNULL([tblProjectMstr].[IsActive], 0) = 1;
    END;
