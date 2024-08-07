USE [LEASINGDB]
GO
/****** Object:  StoredProcedure [dbo].[pr_BlankAllTransactionRecords]    Script Date: 5/28/2024 1:54:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
	EXEC [pr_BlankAllTransactionRecords]
*/
CREATE OR ALTER   PROC [dbo].[pr_BlankAllTransactionRecords]
AS
    BEGIN


       TRUNCATE TABLE 
        [dbo].[tblUnitReference]
        --DBCC CHECKIDENT('[tblUnitReference]', RESEED, 0);

       TRUNCATE TABLE 
        [dbo].[tblTransaction]
        --DBCC CHECKIDENT('[tblTransaction]', RESEED, 0);

        TRUNCATE TABLE 
        [dbo].[tblMonthLedger]
        --DBCC CHECKIDENT('[tblMonthLedger]', RESEED, 0);

        TRUNCATE TABLE 
        [dbo].[tblReceipt]
        --DBCC CHECKIDENT('[tblReceipt]', RESEED, 0);

        TRUNCATE TABLE 
        [dbo].[tblPayment]
        --DBCC CHECKIDENT('[tblPayment]', RESEED, 0);

        TRUNCATE TABLE 
        [dbo].[tblAdvancePayment]
        --DBCC CHECKIDENT('[tblAdvancePayment]', RESEED, 0);

       TRUNCATE TABLE 
        [dbo].[tblPaymentMode]
        --DBCC CHECKIDENT('[tblPaymentMode]', RESEED, 0);

        TRUNCATE TABLE 
        [dbo].[LoggingEvent]
        --DBCC CHECKIDENT('[LoggingEvent]', RESEED, 0);

        TRUNCATE TABLE 
        [dbo].[ErrorLog]
        --DBCC CHECKIDENT('[ErrorLog]', RESEED, 0);

        UPDATE
            [dbo].[tblUnitMstr]
        SET
            [tblUnitMstr].[UnitStatus] = 'VACANT'
    END













