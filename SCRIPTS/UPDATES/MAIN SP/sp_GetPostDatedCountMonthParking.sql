USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPostDatedCountMonthParking]    Script Date: 11/9/2023 10:00:30 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_GetPostDatedCountMonthParking]
    @FromDate VARCHAR(10) = NULL,
    @EndDate  VARCHAR(10) = NULL,
    @Rental   VARCHAR(10) = NULL
AS
    BEGIN

        SET NOCOUNT ON;



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


        SELECT
            ROW_NUMBER() OVER (ORDER BY
                                   [#GeneratedMonths].[Month] ASC
                              )                                   [seq],
            CONVERT(VARCHAR(20), [#GeneratedMonths].[Month], 107) AS [Dates],
            @Rental                                               AS [Rental]
        FROM
            [#GeneratedMonths];

        DROP TABLE [#GeneratedMonths];
    END;
