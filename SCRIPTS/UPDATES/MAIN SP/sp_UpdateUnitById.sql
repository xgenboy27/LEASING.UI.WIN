USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateUnitById]    Script Date: 11/9/2023 10:06:13 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_UpdateUnitById]
    @RecId             INT,
    --@UnitDescription VARCHAR(300)= null,
    @FloorNo           INT            = NULL,
    @AreaSqm           DECIMAL(18, 2) = NULL,
    @AreaRateSqm       DECIMAL(18, 2) = NULL,
    @FloorType         VARCHAR(50)    = NULL,
    @BaseRental        DECIMAL(18, 2) = NULL,
    @UnitStatus        VARCHAR(50)    = NULL,
    @DetailsofProperty VARCHAR(300)   = NULL,
    @UnitNo            VARCHAR(20)    = NULL,
    @UnitSequence      INT            = NULL,
    @LastChangedBy     INT            = NULL,
    @ComputerName      VARCHAR(20)    = NULL
AS
    BEGIN
        UPDATE
            [dbo].[tblUnitMstr]
        SET
            [tblUnitMstr].[FloorNo] = @FloorNo,
            [tblUnitMstr].[AreaSqm] = @AreaSqm,
            [tblUnitMstr].[AreaRateSqm] = @AreaRateSqm,
            [tblUnitMstr].[FloorType] = @FloorType,
            [tblUnitMstr].[BaseRental] = @BaseRental,
            [tblUnitMstr].[UnitStatus] = @UnitStatus,
            [tblUnitMstr].[DetailsofProperty] = @DetailsofProperty,
            [tblUnitMstr].[UnitNo] = @UnitNo,
            [tblUnitMstr].[UnitSequence] = @UnitSequence,
            [tblUnitMstr].[LastChangedBy] = @LastChangedBy,
            [tblUnitMstr].[LastChangedDate] = GETDATE(),
            [tblUnitMstr].[ComputerName] = @ComputerName
        WHERE
            [tblUnitMstr].[RecId] = @RecId;

        IF (@@ROWCOUNT > 0)
            BEGIN
                SELECT
                    'SUCCESS' AS [Message_Code];
            END;
    END;
