USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_DeActivatePojectById]    Script Date: 11/9/2023 9:54:33 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_DeActivatePojectById] @RecId INT
AS
    BEGIN

        SET NOCOUNT ON;

        UPDATE
            [dbo].[tblProjectMstr]
        SET
            [tblProjectMstr].[IsActive] = 0
        WHERE
            [tblProjectMstr].[RecId] = @RecId;

        IF (@@ROWCOUNT > 0)
            BEGIN

                SELECT
                    'SUCCESS' AS [Message_Code];

            END;
    END;
