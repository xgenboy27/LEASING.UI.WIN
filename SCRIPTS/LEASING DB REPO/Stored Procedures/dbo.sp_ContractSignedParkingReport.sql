SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_ContractSignedParkingReport] @RefId AS VARCHAR(20) = NULL
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT
                DAY([dbo].[tblUnitReference].[EncodedDate])                                                                                                     AS [ThisDayOf],
                DATENAME(MONTH, [dbo].[tblUnitReference].[EncodedDate])                                                                                         AS [InMonth],
                DATENAME(YEAR, [dbo].[tblUnitReference].[EncodedDate])                                                                                          AS [OfYear],
                CONVERT(VARCHAR(10), [tblUnitReference].[StatDate], 103) + ' - '
                + CONVERT(VARCHAR(10), [tblUnitReference].[FinishDate], 103)                                                                                    AS [ByAndBetween],
                UPPER([tblCompany].[CompanyName])                                                                                                               AS [CompanyName],
                [tblCompany].[CompanyAddress]                                                                                                                   AS [CompanyAddress],
                [tblCompany].[CompanyOwnerName]                                                                                                                 AS [CompanyOwnerName],
                [tblClientMstr].[ClientName]                                                                                                                    AS [LesseeName],            ---CLIENT NAME
                'Under The Trade Name Of'                                                                                                                       AS [UnderTheTradeNameOf],   ---CLIENT UNDER OF?
                [tblClientMstr].[PostalAddress]                                                                                                                 AS [LesseeAddress],         ---CLIENT ADDRESS

                UPPER([tblProjectMstr].[ProjectName])                                                                                                           AS [TheLessorIsTheOwnerOf], ---PROJECT NAME
                [tblProjectMstr].[ProjectAddress]                                                                                                               AS [Situated],              ---PROJECT ADDRESS

                [tblUnitMstr].[UnitNo]                                                                                                                          AS [LeasedUnit],            ---UNIT NUMBER
                [tblUnitMstr].[AreaSqm]                                                                                                                         AS [AreaOf],                ---UNIT AREA

                [dbo].[fn_GetDateFullName]([tblUnitReference].[StatDate])                                                                                       AS [YearStarting],
                [dbo].[fn_GetDateFullName]([tblUnitReference].[FinishDate])                                                                                     AS [YearEnding],
                [dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[Unit_BaseRentalWithVatAmount]) + '('
                + CAST([tblUnitReference].[Unit_BaseRentalWithVatAmount] AS VARCHAR(100)) + ')'                                                                 AS [RentalForLeased_AmountInWords],
                [dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[Unit_SecAndMainWithVatAmount]) + '('
                + CAST([tblUnitReference].[Unit_SecAndMainWithVatAmount] AS VARCHAR(100)) + ')'                                                                 AS [AsShareInSecAndMaint_AmountInWords],
                [dbo].[fnNumberToWordsWithDecimal]([tblUnitReference].[TotalRent]) + '('
                + CAST([tblUnitReference].[TotalRent] AS VARCHAR(100)) + ')'                                                                                    AS [TotalAmountInYear_AmountInWords],
                CAST([tblUnitReference].[GenVat] AS VARCHAR(100)) + ' %'                                                                                        AS [VatPercentage_WithWords],
                [tblClientMstr].[ClientName]                                                                                                                    AS [Lessee],
                [dbo].[fnGetClientIsRenewal]([dbo].[tblUnitReference].[ClientID], [dbo].[tblUnitReference].[ProjectId])
                + '(' + 'PARKING' + ')'                                                                                                                         AS [ContractTitle],
                CAST(CONCAT(
                               CONVERT(VARCHAR(10), [tblUnitReference].[StatDate], 101), '-',
                               CONVERT(VARCHAR(10), [tblUnitReference].[FinishDate], 101)
                           ) AS VARCHAR(150))                                                                                                                   AS [TPeriodCoverd],
                CAST(CAST([tblUnitReference].[Unit_BaseRentalWithVatAmount] - [tblUnitReference].[Unit_BaseRentalVatAmount] AS DECIMAL(18, 2)) AS VARCHAR(150)) AS [TMonthlyRental],
                CAST([tblUnitReference].[Unit_SecAndMainAmount] AS VARCHAR(150))                                                                                AS [TSecurityandMaintenance],
                CONCAT(CAST([tblUnitReference].[Unit_Vat] AS VARCHAR(150)), ' % VAT')                                                                           AS [TLableVAT],
                CAST(CAST([tblUnitReference].[Unit_BaseRentalVatAmount] + [tblUnitReference].[Unit_SecAndMainVatAmount] AS DECIMAL(18, 2)) AS VARCHAR(150))     AS [TVAT],
                CAST([tblUnitReference].[Unit_TotalRental] AS VARCHAR(150))                                                                                     AS [TTotalMonthlyRental],
                CAST(DATENAME(DAY, [tblUnitReference].[StatDate]) AS VARCHAR(150))                                                                              AS [DayOfMonth]
        FROM
                [dbo].[tblUnitReference] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblProjectMstr] WITH (NOLOCK)
                    ON [dbo].[tblUnitReference].[ProjectId] = [tblProjectMstr].[RecId]
            INNER JOIN
                [dbo].[tblCompany] WITH (NOLOCK)
                    ON [tblProjectMstr].[CompanyId] = [tblCompany].[RecId]
            INNER JOIN
                [dbo].[tblClientMstr] WITH (NOLOCK)
                    ON [tblUnitReference].[ClientID] = [tblClientMstr].[ClientID]
            INNER JOIN
                [dbo].[tblUnitMstr] WITH (NOLOCK)
                    ON [dbo].[tblUnitReference].[UnitId] = [tblUnitMstr].[RecId]
        WHERE
                [tblUnitReference].[RefId] = @RefId


    END;
GO
