USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteUnitReferenceById]    Script Date: 11/9/2023 9:55:50 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_DeleteUnitReferenceById]
    @RecId  INT,
    @UnitId INT
AS
    BEGIN

        SET NOCOUNT ON;

        UPDATE
            [dbo].[tblUnitMstr]
        SET
            [tblUnitMstr].[UnitStatus] = 'VACANT'
        WHERE
            [tblUnitMstr].[RecId] = @UnitId;
        DELETE FROM
        [dbo].[tblUnitReference]
        WHERE
            [tblUnitReference].[RecId] = @RecId;

        IF (@@ROWCOUNT > 0)
            BEGIN

                SELECT
                    'SUCCESS' AS [Message_Code];

            END;
    END;
