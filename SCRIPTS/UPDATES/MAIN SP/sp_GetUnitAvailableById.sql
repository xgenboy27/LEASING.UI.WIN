USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUnitAvailableById]    Script Date: 11/9/2023 10:02:12 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetUnitAvailableById] 1
-- =============================================
ALTER PROCEDURE [dbo].[sp_GetUnitAvailableById] @UnitNo INT
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;
        DECLARE @BaseWithVatAmount DECIMAL(18, 2) = 0;


        SELECT
                @BaseWithVatAmount
            = CAST(ISNULL([tblUnitMstr].[BaseRental], 0)
                   + (((ISNULL([tblUnitMstr].[BaseRental], 0) * ISNULL([tblRatesSettings].[GenVat], 0)) / 100)) AS DECIMAL(18, 2))
        FROM
                [dbo].[tblUnitMstr] WITH (NOLOCK)
            LEFT JOIN
                [dbo].[tblProjectMstr] WITH (NOLOCK)
                    ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
            LEFT JOIN
                [dbo].[tblRatesSettings] WITH (NOLOCK)
                    ON [tblProjectMstr].[ProjectType] = [tblRatesSettings].[ProjectType]
        WHERE
                [tblUnitMstr].[RecId] = @UnitNo
                AND ISNULL([tblUnitMstr].[IsActive], 0) = 1
                AND [tblUnitMstr].[UnitStatus] = 'VACANT';


        SELECT
                [tblProjectMstr].[ProjectName],
                [tblProjectMstr].[ProjectType],
                [tblUnitMstr].[RecId],
                ISNULL([tblUnitMstr].[FloorType], '') AS [FloorType],
                CAST(ISNULL([tblUnitMstr].[BaseRental], 0)
                     + (((ISNULL([tblUnitMstr].[BaseRental], 0) * ISNULL([tblRatesSettings].[GenVat], 0)) / 100)
                        - ((@BaseWithVatAmount * ISNULL([tblRatesSettings].[WithHoldingTax], 0)) / 100)
                       ) AS DECIMAL(18, 2))       AS [BaseRental]
        FROM
                [dbo].[tblUnitMstr] WITH (NOLOCK)
            LEFT JOIN
                [dbo].[tblProjectMstr] WITH (NOLOCK)
                    ON [tblUnitMstr].[ProjectId] = [tblProjectMstr].[RecId]
            LEFT JOIN
                [dbo].[tblRatesSettings] WITH (NOLOCK)
                    ON [tblProjectMstr].[ProjectType] = [tblRatesSettings].[ProjectType]
        WHERE
                [tblUnitMstr].[RecId] = @UnitNo
                AND ISNULL([tblUnitMstr].[IsActive], 0) = 1
                AND [tblUnitMstr].[UnitStatus] = 'VACANT'
        ORDER BY
                [tblUnitMstr].[UnitSequence] DESC;
    END;
