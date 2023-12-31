USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveNewtUnit]    Script Date: 11/9/2023 10:04:18 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_SaveNewtUnit]
    @ProjectId         INT            = NULL,
    @IsParking         BIT            = NULL,
    @FloorNo           INT            = NULL,
    @AreaSqm           DECIMAL(18, 2) = NULL,
    @AreaRateSqm       DECIMAL(18, 2) = NULL,
    @FloorType         VARCHAR(50)    = NULL,
    @BaseRental        DECIMAL(18, 2) = NULL,
    --@UnitStatus VARCHAR(50) = NULL,
    @DetailsofProperty VARCHAR(300)   = NULL,
    @UnitNo            VARCHAR(20)    = NULL,
    @UnitSequence      INT            = NULL,
    @EndodedBy         INT            = NULL,
    @ComputerName      VARCHAR(20)    = NULL
AS
    BEGIN
        INSERT INTO [dbo].[tblUnitMstr]
            (
                [ProjectId],
                [IsParking],
                [FloorNo],
                [AreaSqm],
                [AreaRateSqm],
                [FloorType],
                [BaseRental],
                [UnitStatus],
                [DetailsofProperty],
                [UnitNo],
                [UnitSequence],
                [EndodedBy],
                [EndodedDate],
                [IsActive],
                [ComputerName]
            )
        VALUES
            (
                @ProjectId, @IsParking, @FloorNo, @AreaSqm, @AreaRateSqm, @FloorType, @BaseRental, 'VACANT',
                @DetailsofProperty, @UnitNo, @UnitSequence, @EndodedBy, GETDATE(), 1, @ComputerName
            );

        IF (@@ROWCOUNT > 0)
            BEGIN
                SELECT
                    'SUCCESS' AS [Message_Code];
            END;
    END;
