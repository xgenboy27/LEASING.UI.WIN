USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPaymentListByReferenceId]    Script Date: 11/9/2023 10:00:12 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_GetPaymentListByReferenceId] @RefId VARCHAR(50) = NULL
AS
    BEGIN

        SET NOCOUNT ON;


        SELECT
            [tblPayment].[RecId],
            [tblPayment].[PayID],
            [tblPayment].[TranId],
            [tblPayment].[Amount],
            ISNULL(CONVERT(VARCHAR(20), [tblPayment].[ForMonth], 107), '')    AS [ForMonth],
            [tblPayment].[Remarks],
            [tblPayment].[EncodedBy],
            ISNULL(CONVERT(VARCHAR(20), [tblPayment].[EncodedDate], 107), '') AS [DatePayed],
            [tblPayment].[LastChangedBy],
            [tblPayment].[LastChangedDate],
            [tblPayment].[ComputerName],
            [tblPayment].[IsActive],
            [tblPayment].[RefId]
        FROM
            [dbo].[tblPayment]
        WHERE
            [tblPayment].[RefId] = @RefId;
    END;
