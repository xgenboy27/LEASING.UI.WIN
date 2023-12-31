USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_GenerateLedger]    Script Date: 11/9/2023 9:56:25 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
--EXEC [sp_GenerateLedger] 
ALTER PROCEDURE [dbo].[sp_GenerateLedger]
    @FromDate      VARCHAR(10)    = NULL,
    @EndDate       VARCHAR(10)    = NULL,
    @LedgAmount    DECIMAL(18, 2) = NULL,
    @ComputationID INT            = NULL,
    @ClientID      VARCHAR(30)    = NULL,
    @EncodedBy     INT            = NULL,
    @ComputerName  VARCHAR(30)    = NULL
AS
    BEGIN

        --DECLARE @StartDate VARCHAR(10) = '08/02/2023';
        --DECLARE @EndDate VARCHAR(10) = '05/02/2024';
        --SELECT DATEDIFF(MONTH, CONVERT(DATE, @StartDate, 101), CONVERT(DATE, @EndDate, 101)) AS NumberOfMonths;

        DECLARE @MonthsCount INT = DATEDIFF(MONTH, CONVERT(DATE, @FromDate, 101), CONVERT(DATE, @EndDate, 101));

        CREATE TABLE [#GeneratedMonths]
            (
                [Month] DATE
            );
        WITH [MonthsCTE]
        AS (   SELECT
                   CONVERT(DATE, @FromDate) AS [Month]
               UNION ALL
               SELECT
                   DATEADD(MONTH, 1, [MonthsCTE].[Month])
               FROM
                   [MonthsCTE]
               WHERE
                   DATEADD(MONTH, 1, [MonthsCTE].[Month]) <= DATEADD(MONTH, @MonthsCount - 1, CONVERT(DATE, @FromDate)))
        INSERT INTO [#GeneratedMonths]
            (
                [Month]
            )
                    SELECT
                        [MonthsCTE].[Month]
                    FROM
                        [MonthsCTE];



        INSERT INTO [dbo].[tblMonthLedger]
            (
                [LedgMonth],
                [LedgAmount],
                [ReferenceID],
                [ClientID],
                [IsPaid],
                [EncodedBy],
                [EncodedDate],
                [ComputerName]
            )
                    SELECT
                        [#GeneratedMonths].[Month],
                        @LedgAmount,
                        @ComputationID,
                        @ClientID,
                        0,
                        @EncodedBy,
                        GETDATE(),
                        @ComputerName
                    FROM
                        [#GeneratedMonths];

        IF (@@ROWCOUNT > 0)
            BEGIN
                UPDATE
                    [dbo].[tblUnitReference]
                SET
                    [tblUnitReference].[ClientID] = @ClientID,
                    [tblUnitReference].[LastCHangedBy] = @EncodedBy,
                    [tblUnitReference].[LastChangedDate] = GETDATE(),
                    [tblUnitReference].[ComputerName] = @ComputerName
                WHERE
                    [tblUnitReference].[RecId] = @ComputationID;


                SELECT
                    'SUCCESS' AS [Message_Code];
            END;

        DROP TABLE [#GeneratedMonths];


    END;
