USE [LEASINGDB]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetContratBrowseByClientID]    Script Date: 12/2/2024 5:38:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[sp_GetContratBrowseByClientID] @ClientID AS VARCHAR(150) = NULL
AS
    BEGIN
        SET NOCOUNT ON
        SELECT
            [tblUnitReference].[RecId],
            [tblUnitReference].[RefId],
            [tblUnitReference].[ProjectId],
            [tblUnitReference].[InquiringClient],
            [tblUnitReference].[ClientMobile],
            [tblUnitReference].[UnitId],
            [tblUnitReference].[UnitNo],
            [tblUnitReference].[StatDate],
            [tblUnitReference].[FinishDate],
            CONVERT(VARCHAR(150), [tblUnitReference].[TransactionDate], 103) AS [TransactionDate],
            [tblUnitReference].[Rental],
            [tblUnitReference].[SecAndMaintenance],
            [tblUnitReference].[TotalRent],
            [tblUnitReference].[SecDeposit],
            [tblUnitReference].[Total],
            [tblUnitReference].[EncodedBy],
            [tblUnitReference].[EncodedDate],
            [tblUnitReference].[LastCHangedBy],
            [tblUnitReference].[LastChangedDate],
            [tblUnitReference].[IsActive],
            [tblUnitReference].[ComputerName],
            [tblUnitReference].[ClientID],
            [tblUnitReference].[IsPaid],
            [tblUnitReference].[IsDone],
            [tblUnitReference].[HeaderRefId],
            [tblUnitReference].[IsSignedContract],
            [tblUnitReference].[IsUnitMove],
            [tblUnitReference].[IsTerminated],
            [tblUnitReference].[GenVat],
            [tblUnitReference].[WithHoldingTax],
            [tblUnitReference].[IsUnitMoveOut],
            [tblUnitReference].[FirstPaymentDate],
            [tblUnitReference].[ContactDoneDate],
            [tblUnitReference].[SignedContractDate],
            [tblUnitReference].[UnitMoveInDate],
            [tblUnitReference].[UnitMoveOutDate],
            [tblUnitReference].[TerminationDate],
            [tblUnitReference].[AdvancePaymentAmount],
            [tblUnitReference].[IsFullPayment],
            [tblUnitReference].[PenaltyPct],
            [tblUnitReference].[IsPartialPayment],
            [tblUnitReference].[FirtsPaymentBalanceAmount],
            [tblUnitReference].[Unit_IsNonVat],
            [tblUnitReference].[Unit_BaseRentalVatAmount],
            [tblUnitReference].[Unit_BaseRentalWithVatAmount],
            [tblUnitReference].[Unit_BaseRentalTax],
            [tblUnitReference].[Unit_TotalRental],
            [tblUnitReference].[Unit_SecAndMainAmount],
            [tblUnitReference].[Unit_SecAndMainVatAmount],
            [tblUnitReference].[Unit_SecAndMainWithVatAmount],
            [tblUnitReference].[Unit_Vat],
            [tblUnitReference].[Unit_Tax],
            [tblUnitReference].[Unit_TaxAmount],
            [tblUnitReference].[Unit_IsParking],
            [tblUnitReference].[Unit_ProjectType],
            [tblUnitReference].[Unit_AreaTotalAmount],
            [tblUnitReference].[Unit_AreaSqm],
            [tblUnitReference].[Unit_AreaRateSqm],
            [tblUnitReference].[IsRenewal]
        FROM
            [dbo].[tblUnitReference]
        WHERE
            [tblUnitReference].[ClientID] = @ClientID
            AND ISNULL([tblUnitReference].[IsDeclineUnit], 0) = 0
    END
