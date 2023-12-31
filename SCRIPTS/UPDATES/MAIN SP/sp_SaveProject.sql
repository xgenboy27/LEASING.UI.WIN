USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveProject]    Script Date: 11/9/2023 10:04:26 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_SaveProject]
    @ProjectType    VARCHAR(50)  = NULL,
    @LocId          INT          = NULL,
    @ProjectName    VARCHAR(50)  = NULL,
    @Descriptions   VARCHAR(50)  = NULL,
    @ProjectAddress VARCHAR(500) = NULL
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here

        IF NOT EXISTS
            (
                SELECT
                    [tblProjectMstr].[ProjectName]
                FROM
                    [dbo].[tblProjectMstr]
                WHERE
                    [tblProjectMstr].[ProjectName] = @ProjectName
            )
            BEGIN
                INSERT INTO [dbo].[tblProjectMstr]
                    (
                        [ProjectType],
                        [LocId],
                        [ProjectName],
                        [Descriptions],
                        [ProjectAddress],
                        [IsActive]
                    )
                VALUES
                    (
                        @ProjectType, @LocId, @ProjectName, @Descriptions, @ProjectAddress, 1
                    );

                IF (@@ROWCOUNT > 0)
                    BEGIN
                        SELECT
                            'SUCCESS' AS [Message_Code];
                    END;
            END;
        ELSE
            BEGIN
                SELECT
                    'PROJECT NAME ALREADY EXISTS' AS [Message_Code];
            END;
    END;


