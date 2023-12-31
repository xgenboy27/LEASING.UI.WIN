USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteLocationById]    Script Date: 11/9/2023 9:55:17 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_DeleteLocationById] @RecId INT
AS
    BEGIN

        SET NOCOUNT ON;


        DELETE FROM
        [dbo].[tblLocationMstr]
        WHERE
            [tblLocationMstr].[RecId] = @RecId;

        IF (@@ROWCOUNT > 0)
            BEGIN

                SELECT
                    'SUCCESS' AS [Message_Code];

            END;
    END;
