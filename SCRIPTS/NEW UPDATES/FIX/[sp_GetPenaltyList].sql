USE [LEASINGDB]
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
--EXEC [sp_GetPenaltyList] 10000000
CREATE OR ALTER PROCEDURE [sp_GetPenaltyList] @ReferenceID AS BIGINT
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
    BEGIN


        SELECT
            [tblMonthLedger].[Recid]                                                     AS [LedgRecId],
            CONVERT(VARCHAR(20), [tblMonthLedger].[LedgMonth], 107)                      AS [LedgeMonth],
            COALESCE([tblMonthLedger].[LedgRentalAmount], [tblMonthLedger].[LedgAmount]) AS [PenaltyAmount],
            CONVERT(VARCHAR(20), [tblMonthLedger].[EncodedDate], 107)                    AS [DateGenerated]
        FROM
            [dbo].[tblMonthLedger]
        WHERE
            [tblMonthLedger].[ReferenceID] = @ReferenceID
            AND [tblMonthLedger].[Remarks] = 'PENALTY'
            AND
                (
                    ISNULL([tblMonthLedger].[IsPaid], 0) = 0
                    OR ISNULL([tblMonthLedger].[IsHold], 0) = 0
                )

    END
GO
