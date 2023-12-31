USE [LEASINGDB]

INSERT INTO tblRatesSettings
(
    ProjectType,
    GenVat,
    SecurityAndMaintenance,
    SecurityAndMaintenanceVat,
    IsSecAndMaintVat,
    WithHoldingTax,
    EncodedBy,
    EncodedDate,
    ComputerName
)
VALUES
('RESIDENTIAL', 0, 0, 0, 0, 0, 1, GETDATE(), HOST_NAME())
INSERT INTO tblRatesSettings
(
    ProjectType,
    GenVat,
    SecurityAndMaintenance,
    SecurityAndMaintenanceVat,
    IsSecAndMaintVat,
    WithHoldingTax,
    EncodedBy,
    EncodedDate,
    ComputerName
)
VALUES
('COMMERCIAL', 0, 0, 0, 0, 0, 1, GETDATE(), HOST_NAME())
INSERT INTO tblRatesSettings
(
    ProjectType,
    GenVat,
    SecurityAndMaintenance,
    SecurityAndMaintenanceVat,
    IsSecAndMaintVat,
    WithHoldingTax,
    EncodedBy,
    EncodedDate,
    ComputerName
)
VALUES
('WAREHOUSE', 0, 0, 0, 0, 0, 1, GETDATE(), HOST_NAME())

INSERT INTO tblFloorTypes(FloorTypesDescription,IsActive)VALUES('1 Bedroom / 1T&B',1)
INSERT INTO tblFloorTypes(FloorTypesDescription,IsActive)VALUES('Studio / 1T&B',1)
INSERT INTO tblFloorTypes(FloorTypesDescription,IsActive)VALUES('2 Bedroom / 1T&B',1)
GO
/****** Object:  StoredProcedure [dbo].[GenerateInsertsMomths]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--EXEC [GenerateInsertsMomths] @StartDate = '07/31/2023',@MonthsCount = 3
CREATE PROCEDURE [dbo].[GenerateInsertsMomths]
    @StartDate DATE,
    @MonthsCount INT
AS
BEGIN

CREATE TABLE #GeneratedMonths (
    [Month] DATE
);
    WITH MonthsCTE AS (
        SELECT @StartDate AS [Month]
        UNION ALL
        SELECT DATEADD(MONTH, 1, [Month])
        FROM MonthsCTE
        WHERE DATEADD(MONTH, 1, [Month]) <= DATEADD(MONTH, @MonthsCount - 1, @StartDate)
    )
    INSERT INTO #GeneratedMonths ([Month])
    SELECT [Month] FROM MonthsCTE;

    -- Insert data into sample_table based on the generated months
    --INSERT INTO sample_table ([Month], [data])
    --SELECT FORMAT([Month], 'MMMM'),'test' 
    --FROM #GeneratedMonths;
   INSERT INTO sample_table ([Month], [data])
    SELECT [Month], 'test'
    FROM #GeneratedMonths;
    -- Clean up the temporary table
    DROP TABLE #GeneratedMonths;
	
END;




--CREATE TABLE tblMonthLedger (

--Recid INT IDENTITY(1,1),
--ReferenceID INT,
--ClientID VARCHAR(50),
--LedgMonth DATE,
--LedgAmount DECIMAL(18,2)
--)

--CREATE TABLE tblUnitReference(
--	RecId INT IDENTITY(1,1),
--	RefId  AS ('REF'+CONVERT(VARCHAR(MAX),RecId)),
--	ProjectId int,
--	InquiringClient VARCHAR(500),
--	ClientMobile VARCHAR(50),
--	UnitId INT,
--	UnitNo VARCHAR(50),
--	StatDate DATE,
--	FinishDate DATE,
--	TransactionDate DATE,
--	Rental DECIMAL(18,2),
--	SecAndMaintenance DECIMAL(18,2),
--	TotalRent DECIMAL(18,2),
--	Advancemonths1 DECIMAL(18,2),
--	Advancemonths2 DECIMAL(18,2),
--	SecDeposit DECIMAL(18,2),
--	Total DECIMAL (18,2),
--	EncodedBy INT,
--	EncodedDate DATETIME,
--	LastCHangedBy INT,
--	LastChangedDate DATETIME,
--	IsActive BIT,
--	ComputerName VARCHAR(30)
--)
GO
/****** Object:  StoredProcedure [dbo].[sp_ActivateLocationById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ActivateLocationById] 
					@RecId INT
					
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--DELETE FROM tblLocationMstr WHERE RecId = @RecId

	UPDATE tblLocationMstr SET IsActive = 1 WHERE RecId = @RecId

	if(@@ROWCOUNT > 0)
	BEGIN

	SELECT 'SUCCESS' AS Message_Code

	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ActivatePojectById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ActivatePojectById] 
					@RecId INT
					
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--DELETE FROM tblProjectMstr WHERE RecId = @RecId


	UPDATE tblProjectMstr SEt IsActive = 1 WHERE RecId = @RecId

	if(@@ROWCOUNT > 0)
	BEGIN

	SELECT 'SUCCESS' AS Message_Code

	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_activatePurchaseItemById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC sp_GetPurchaseItemInfoById @RecId = 2
-- =============================================
CREATE PROCEDURE [dbo].[sp_activatePurchaseItemById]
@RecId INT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--RecId INT IDENTITY(1,1), ProjectId INT,Descriptions VARCHAR(200), DatePurchase DateTime,UnitAmount MONEY,Amount Money,Remarks VARCHAR(200)
	--ADD EncodedBy INT,EncodedDate DATETIME,LastChangedBy INT,LastChangedDate DATETIME,ComputerName VARCHAR(50),IsActive BIT
    -- Insert statements for procedure here
	UPDATE tblProjPurchItem SET IsActive = 1 WHERE RecId = @RecId


	if(@@ROWCOUNT > 0)
		BEGIN
			SELECT 'SUCCESS' AS Message_Code
		END
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_DeActivateLocationById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeActivateLocationById] 
					@RecId INT
					
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--DELETE FROM tblLocationMstr WHERE RecId = @RecId

	UPDATE tblLocationMstr SET IsActive = 0 WHERE RecId = @RecId

	if(@@ROWCOUNT > 0)
	BEGIN

	SELECT 'SUCCESS' AS Message_Code

	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeActivatePojectById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeActivatePojectById] 
					@RecId INT
					
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--DELETE FROM tblProjectMstr WHERE RecId = @RecId


	UPDATE tblProjectMstr SEt IsActive = 0 WHERE RecId = @RecId

	if(@@ROWCOUNT > 0)
	BEGIN

	SELECT 'SUCCESS' AS Message_Code

	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeactivatePurchaseItemById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC sp_GetPurchaseItemInfoById @RecId = 2
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeactivatePurchaseItemById]
@RecId INT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--RecId INT IDENTITY(1,1), ProjectId INT,Descriptions VARCHAR(200), DatePurchase DateTime,UnitAmount MONEY,Amount Money,Remarks VARCHAR(200)
	--ADD EncodedBy INT,EncodedDate DATETIME,LastChangedBy INT,LastChangedDate DATETIME,ComputerName VARCHAR(50),IsActive BIT
    -- Insert statements for procedure here
	UPDATE tblProjPurchItem SET IsActive = 0 WHERE RecId = @RecId


	if(@@ROWCOUNT > 0)
		BEGIN
			SELECT 'SUCCESS' AS Message_Code
		END
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteFile]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_DeleteFile]
    @FilePath NVARCHAR(500)
AS
BEGIN
    DELETE FROM Files
    WHERE FilePath = @FilePath;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteLocationById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeleteLocationById] 
					@RecId INT
					
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DELETE FROM tblLocationMstr WHERE RecId = @RecId

	if(@@ROWCOUNT > 0)
	BEGIN

	SELECT 'SUCCESS' AS Message_Code

	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeletePojectById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeletePojectById] 
					@RecId INT
					
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DELETE FROM tblProjectMstr WHERE RecId = @RecId

	if(@@ROWCOUNT > 0)
	BEGIN

	SELECT 'SUCCESS' AS Message_Code

	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeletePurchaseItemById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeletePurchaseItemById] 
					@RecId INT
					
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DELETE FROM tblProjPurchItem WHERE RecId = @RecId

	if(@@ROWCOUNT > 0)
	BEGIN

	SELECT 'SUCCESS' AS Message_Code

	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteUnitReferenceById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeleteUnitReferenceById] 
					@RecId INT,
					@UnitId INT
					
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	update tblUnitMstr SET UnitStatus = 'VACANT' WHERE RecId = @UnitId
	DELETE FROM tblUnitReference WHERE RecId = @RecId

	if(@@ROWCOUNT > 0)
	BEGIN

	SELECT 'SUCCESS' AS Message_Code

	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GenerateFirstPayment]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GenerateFirstPayment] 
	-- Add the parameters for the stored procedure here
	@RefId VARCHAR(50)=NULL,
	@PaidAmount DECIMAL(18,2) = NULL,
	@ReceiveAmount DECIMAL(18,2)=NULL,
	@ChangeAmount DECIMAL(18,2)=NULL,
	@SecAmountADV DECIMAL(18,2)=NULL,
	@EncodedBy INT =NULL,
	@ComputerName VARCHAR(30)=NULL,
	@PaymentMethod VARCHAR(30)=NULL,
	@CompanyORNo VARCHAR(30)=NULL,
	@BankAccountName VARCHAR(30)=NULL,
	@BankAccountNumber VARCHAR(30)=NULL,
	@BankName VARCHAR(30)=NULL,
	@SerialNo VARCHAR(30)=NULL,
	@PaymentRemarks  VARCHAR(100)=NULL
	

	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE @TranRecId BIGINT = 0
DECLARE @TranID VARCHAR(50) = ''
DECLARE @ApplicableMonth1 DATE = NULL
DECLARE @ApplicableMonth2 DATE = NULL
-- Insert statements for procedure here


SELECT @ApplicableMonth1 = Applicabledate1,
       @ApplicableMonth2 = Applicabledate2
FROM tblUnitReference
WHERE RefId = @RefId

INSERT INTO tblTransaction
(
    RefId,
    PaidAmount,
    ReceiveAmount,
    ChangeAmount,
    Remarks,
    EncodedBy,
    EncodedDate,
    ComputerName,
    IsActive
)
VALUES
(@RefId, @PaidAmount, @ReceiveAmount, @ChangeAmount, 'FIRST PAYMENT', @EncodedBy, GETDATE(), @ComputerName, 1)

SET @TranRecId = @@IDENTITY
SELECT @TranID = TranID
FROM tblTransaction
WHERE RecId = @TranRecId





INSERT INTO tblPayment
(
    TranId,
    RefId,
    Amount,
    ForMonth,
    Remarks,
    EncodedBy,
    EncodedDate,
    ComputerName,
    IsActive
)
SELECT @TranID AS TranId,
       @RefId AS RefId,
       LedgAmount as Amount,
       LedgMonth as ForMonth,
       'TWO MONTHS ADVANCE' as Remarks,
       @EncodedBy,
       GETDATE(),--Dated payed
       @ComputerName,
       1
FROM tblMonthLedger
WHERE ReferenceID =
(
    SELECT Recid FROM tblUnitReference WHERE RefId = @RefId
)
      and LedgMonth IN ( @ApplicableMonth1, @ApplicableMonth2 )
UNION
SELECT @TranID AS TranId,
       @RefId AS RefId,
       @SecAmountADV as Amount,
       CONVERT(DATE, GETDATE()) as ForMonth,
       'THREE MONTHS SECURITY DEPOSIT' as Remarks,
       @EncodedBy,
       GETDATE(),
       @ComputerName,
       1


UPDATE tblUnitReference
SET IsPaid = 1
WHERE RefId = @RefId
UPDATE tblMonthLedger
SET IsPaid = 1,
    TransactionID = @TranID
WHERE LedgMonth IN ( @ApplicableMonth1, @ApplicableMonth2 )


INSERT INTO tblReceipt (
TranId
,Amount
,[Description]
,Remarks
,EncodedBy
,EncodedDate
,ComputerName
,IsActive
,PaymentMethod
,CompanyORNo
,BankAccountName
,BankAccountNumber
,BankName
,SerialNo)
VALUES (
@TranID 
,@PaidAmount
,'FIRST PAYMENT' 
,@PaymentRemarks
,@EncodedBy
,GETDATE()
,@ComputerName
,1
,@PaymentMethod
,@CompanyORNo
,@BankAccountName
,@BankAccountNumber
,@BankName
,@SerialNo)

if (@TranID <> '' AND @@ROWCOUNT > 0)
BEGIN
    SELECT 'SUCCESS' AS Message_Code
END
ELSE
BEGIN
    SELECT ERROR_MESSAGE() AS Message_Code
END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GenerateLedger]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC [GenerateInsertsMomths] @StartDate = '07/31/2023',@MonthsCount = 3
CREATE PROCEDURE [dbo].[sp_GenerateLedger]
    --@StartDate DATE,--Start of Post Dated Checks
     @FromDate VARCHAR(10) = NULL,
	 @EndDate VARCHAR(10) = NULL,
	 @LedgAmount DECIMAL(18,2)=NULL,
	 @ComputationID INT = NULL,
	 @ClientID VARCHAR(30)=NULL,
	 @EncodedBy INT = NULL,
	 @ComputerName VARCHAR(30)=NULL
AS
BEGIN

--DECLARE @StartDate VARCHAR(10) = '08/02/2023';
--DECLARE @EndDate VARCHAR(10) = '05/02/2024';
--SELECT DATEDIFF(MONTH, CONVERT(DATE, @StartDate, 101), CONVERT(DATE, @EndDate, 101)) AS NumberOfMonths;

DECLARE @MonthsCount INT = DATEDIFF(MONTH, CONVERT(DATE, @FromDate, 101), CONVERT(DATE, @EndDate, 101))

CREATE TABLE #GeneratedMonths (
    [Month] DATE
);
    WITH MonthsCTE AS (
        SELECT CONVERT(DATE,@FromDate) AS [Month]
        UNION ALL
        SELECT DATEADD(MONTH, 1, [Month])
        FROM MonthsCTE
        WHERE DATEADD(MONTH, 1, [Month]) <= DATEADD(MONTH, @MonthsCount -1, CONVERT(DATE,@FromDate))
    )
    INSERT INTO #GeneratedMonths ([Month])
    SELECT [Month] FROM MonthsCTE

 --DELETE FROM #GeneratedMonths where [Month] BETWEEN @ApplicableDate1 and @ApplicableDate2 

   INSERT INTO tblMonthLedger (LedgMonth, LedgAmount,ReferenceID,ClientID,IsPaid,EncodedBy,EncodedDate,ComputerName)
    SELECT  [Month], @LedgAmount,@ComputationID,@ClientID,0,@EncodedBy,GETDATE(),@ComputerName
    FROM #GeneratedMonths

	IF (@@ROWCOUNT > 0)
	BEGIN
	UPDATE tblUnitReference SET ClientID = @ClientID,LastCHangedBy =@EncodedBy,LastChangedDate = GETDATE(),ComputerName = @ComputerName  WHERE RecId = @ComputationID

	--No need for IsMap
	--UPDATE tblClientMstr SET IsMap = 1 WHERE RecId = @ClientID

	--no need only in generate transaction once paid will flag the unit as OCCUPIED
	--update tblUnitMstr set UnitStatus = 'OCCUPIED',clientID = @ClientID WHERE RecId =(SELECT UnitId FROM tblUnitReference WHERE RecId = @ComputationID)

		SELECT 'SUCCESS' AS Message_Code
	END
    -- Clean up the temporary table
    DROP TABLE #GeneratedMonths
	
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetClientById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClientById] 
@ClientID VARCHAR(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT 
	ClientID,
	IIF(ISNULL(ClientType,'') ='INDV', 'INDIVIDUAL','CORPORATE') AS ClientType,
    ISNULL(ClientName,'') AS ClientName,
    ISNULL(Age,0) AS Age,
    ISNULL(PostalAddress,'') AS PostalAddress,
    ISNULL(convert(VARCHAR(10),DateOfBirth,103),'') AS DateOfBirth,
    ISNULL(TelNumber,0) AS TelNumber,
    IIF(ISNULL(Gender,0)= 1 ,'MALE','FEMALE') AS Gender,
    ISNULL(Nationality,'') AS Nationality,
    ISNULL(Occupation,'') AS Occupation,
    ISNULL(AnnualIncome,0) AS AnnualIncome,
    ISNULL(EmployerName,'') AS EmployerName,
    ISNULL(EmployerAddress,'') AS EmployerAddress,
    ISNULL(SpouseName,'') AS SpouseName,
    ISNULL(ChildrenNames,'') AS ChildrenNames,
    ISNULL(TotalPersons,0) AS TotalPersons,
    ISNULL(MaidName,'') AS MaidName,
    ISNULL(DriverName,'') AS DriverName,
    ISNULL(VisitorsPerDay,0) AS VisitorsPerDay,
    ISNULL(IsTwoMonthAdvanceRental,0) AS IsTwoMonthAdvanceRental,
    ISNULL(IsThreeMonthSecurityDeposit,0) AS IsThreeMonthSecurityDeposit,
    ISNULL(Is10PostDatedChecks,0) AS Is10PostDatedChecks,
    ISNULL(IsPhotoCopyValidID,0) AS IsPhotoCopyValidID,
    ISNULL(Is2X2Picture,0) AS Is2X2Picture,
    ISNULL(BuildingSecretary,0) AS BuildingSecretary,
    ISNULL(EncodedDate,'') AS EncodedDate,
    ISNULL(EncodedBy,0) AS EncodedBy,    
    ISNULL(ComputerName,'') AS ComputerName,
  IIF(ISNULL(IsActive,0) = 1,'ACTIVE','IN-ACTIVE') AS IsActive FROM tblClientMstr WHERE ClientID = @ClientID
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetClientFileByFileId]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetClientFileByFileId]
    @ClientName VARCHAR(50),
	@Id INT
AS
BEGIN
    SELECT Id,FilePath, FileData,FileNames,Notes,Files
    FROM Files
    WHERE ClientName = @ClientName and Id = @Id
END



--TRUNCATE TABLE Files
SELECT * FROM Files

GO
/****** Object:  StoredProcedure [dbo].[sp_GetClientID]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClientID] 
@ClientID VARCHAR(50) = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

IF EXISTS(SELECT 1 FROM tblClientMstr WHERE ClientID = @ClientID)
	BEGIN
	  SELECT 
		ClientID,
		'' AS Message_Code
	 FROM tblClientMstr WITH(NOLOCK) WHERE ISNULL(ClientID,'') = @ClientID
	END
ELSE
	BEGIN

	  SELECT 
	   '' AS ClientID,
		'THIS ID IS NOT EXIST ' AS Message_Code
	END


END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetClientList]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClientList] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT 
	ISNULL(ClientID,'') AS ClientID,
	IIF(ISNULL(ClientType,'') ='INDV', 'INDIVIDUAL','CORPORATE') AS ClientType,
    ISNULL(ClientName,'') AS ClientName,
    ISNULL(Age,0) AS Age,
    ISNULL(PostalAddress,'') AS PostalAddress,
    ISNULL(convert(VARCHAR(10),DateOfBirth,103),'') AS DateOfBirth,
    ISNULL(TelNumber,0) AS TelNumber,
    IIF(ISNULL(Gender,0)= 1 ,'MALE','FEMALE') AS Gender,
    ISNULL(Nationality,'') AS Nationality,
    ISNULL(Occupation,'') AS Occupation,
    ISNULL(AnnualIncome,0) AS AnnualIncome,
    ISNULL(EmployerName,'') AS EmployerName,
    ISNULL(EmployerAddress,'') AS EmployerAddress,
    ISNULL(SpouseName,'') AS SpouseName,
    ISNULL(ChildrenNames,'') AS ChildrenNames,
    ISNULL(TotalPersons,0) AS TotalPersons,
    ISNULL(MaidName,'') AS MaidName,
    ISNULL(DriverName,'') AS DriverName,
    ISNULL(VisitorsPerDay,0) AS VisitorsPerDay,
    ISNULL(IsTwoMonthAdvanceRental,0) AS IsTwoMonthAdvanceRental,
    ISNULL(IsThreeMonthSecurityDeposit,0) AS IsThreeMonthSecurityDeposit,
    ISNULL(Is10PostDatedChecks,0) AS Is10PostDatedChecks,
    ISNULL(IsPhotoCopyValidID,0) AS IsPhotoCopyValidID,
    ISNULL(Is2X2Picture,0) AS Is2X2Picture,
    ISNULL(BuildingSecretary,0) AS BuildingSecretary,
    ISNULL(EncodedDate,'') AS EncodedDate,
    ISNULL(EncodedBy,0) AS EncodedBy,    
    ISNULL(ComputerName,'') AS ComputerName,
  IIF(ISNULL(IsActive,0) = 1,'ACTIVE','IN-ACTIVE') AS IsActive FROM tblClientMstr
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetClientTypeAndID]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClientTypeAndID] 
     @ClientID VARCHAR(50)=NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT 
	ISNULL(ClientID,'') AS ClientID,
    IIF(ISNULL(ClientType,'')='INV','INDIVIDUAL','CORPORATE') AS ClientType
 FROM tblClientMstr with(nolock) where ClientID = @ClientID
 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetClientUnitList]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetClientUnitList]
	-- Add the parameters for the stored procedure here
	@ClientID VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
tblUnitReference.RecId,
tblUnitReference.UnitNo,
ISNULL(tblProjectMstr.ProjectName,'') +'-'+ ISNULL(tblProjectMstr.ProjectType,'') as ProjectName,
ISNULL(tblUnitMstr.DetailsofProperty,'N/A') +  ' - Type (' + ISNULL(tblUnitMstr.FloorType,'N/A') + ')' AS DetailsofProperty,
IIF(ISNULL(tblUnitMstr.IsParking,0)=1,'TYPE OF PARKING','TYPE OF UNIT') AS TypeOf
FROm tblUnitReference WITH(NOLOCK)
INNER JOIN tblUnitMstr WITH(NOLOCK)
ON tblUnitReference.UnitId = tblUnitMstr.RecId
INNER JOIN tblProjectMstr 
ON tblUnitReference.ProjectId = tblProjectMstr.RecId
	
	WHERE tblUnitReference.ClientID = @ClientID
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetCOMMERCIALSettings]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetCOMMERCIALSettings] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT 
			ProjectType,
			ISNULL(GenVat,0) AS GenVat,
			ISNULL(SecurityAndMaintenance,0) AS SecurityAndMaintenance,
			--ISNULL(SecurityAndMaintenanceVat,0) AS SecurityAndMaintenanceVat,
			--ISNULL(IsSecAndMaintVat,0) AS IsSecAndMaintVat,
			ISNULL(WithHoldingTax,0) AS WithHoldingTax,
			EncodedBy,
			EncodedDate,
			ComputerName
		FROM tblRatesSettings WHERE ProjectType = 'COMMERCIAL'

END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetComputationById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetComputationById] 
	@RecId INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT 
	tblUnitReference.RecId,
	tblUnitReference.RefId,
	ISNULL(tblUnitReference.ClientID,'') AS ClientID,
	tblUnitReference.ProjectId,
	ISNULL(tblProjectMstr.ProjectName,'') AS ProjectName,
	ISNULL(tblProjectMstr.ProjectAddress,'') AS ProjectAddress,
	ISNULL(tblProjectMstr.ProjectType,'') AS ProjectType,
	ISNULL(tblUnitReference.InquiringClient,'') AS InquiringClient,
	ISNULL(tblUnitReference.ClientMobile,'')  AS ClientMobile,
	tblUnitReference.UnitId,
	ISNULL(tblUnitReference.UnitNo,'') AS UnitNo,
	ISNULL(tblUnitMstr.FloorType,'') AS FloorType,
	ISNULL(CONVERT(VARCHAR(10),tblUnitReference.StatDate,1),'')  AS StatDate,
	ISNULL(CONVERT(VARCHAR(10),tblUnitReference.FinishDate,1),'') AS  FinishDate,
	ISNULL(CONVERT(VARCHAR(10),tblUnitReference.TransactionDate,1),'') AS  TransactionDate,
	ISNULL(CONVERT(VARCHAR(10),tblUnitReference.Applicabledate1,1),'')  AS Applicabledate1,
	ISNULL(CONVERT(VARCHAR(10),tblUnitReference.Applicabledate2,1),'') AS  Applicabledate2,
	CAST(ISNULL(tblUnitReference.Rental,0) AS DECIMAL(10,2)) AS Rental,
	CAST(ISNULL(tblUnitReference.SecAndMaintenance,0) AS DECIMAL(10,2)) AS SecAndMaintenance ,
	CAST(ISNULL(tblUnitReference.TotalRent,0) AS DECIMAL(10,2)) AS TotalRent,
	CAST(ISNULL(tblUnitReference.Advancemonths1,0) AS DECIMAL(10,2)) AS Advancemonths1,
	CAST(ISNULL(tblUnitReference.Advancemonths2,0) AS DECIMAL(10,2)) AS  Advancemonths2,
	CAST(ISNULL(tblUnitReference.SecDeposit,0) AS DECIMAL(10,2)) AS SecDeposit,
	CAST(ISNULL(tblUnitReference.Total,0) AS DECIMAL(10,2)) AS Total,
	tblUnitReference.EncodedBy,
	tblUnitReference.EncodedDate,
	tblUnitReference.IsActive,
	tblUnitReference.ComputerName,
	ISNULL(tblUnitReference.Advancemonths1,0) + ISNULL(tblUnitReference.Advancemonths2,0) as TwoMonAdvance,
	CAST(ISNULL(tblUnitReference.Advancemonths1,0) + ISNULL(tblUnitReference.Advancemonths2,0) + ISNULL(tblUnitReference.SecDeposit,0) AS DECIMAL(10,2)) as TotalForPayment
  FROm tblUnitReference  WITH(NOLOCK)
  INNER JOIN tblProjectMstr WITH(NOLOCK)
  ON tblUnitReference.ProjectId = tblProjectMstr.RecId
  INNER JOIN tblUnitMstr WITH(NOLOCK)
  ON tblUnitMstr.RecId = tblUnitReference.UnitId
  WHERE tblUnitReference.RecId = @RecId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetComputationList]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- UNION THE SELECT OF PARKING LIST LATER ON
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetComputationList] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT 
	 tblUnitReference.RecId,
	tblUnitReference.RefId,
	tblUnitReference.ProjectId,
	ISNULL(tblProjectMstr.ProjectName,'') AS ProjectName,
	ISNULL(tblProjectMstr.ProjectAddress,'') AS ProjectAddress,
	ISNULL(tblProjectMstr.ProjectType,'') AS ProjectType,
	ISNULL(tblUnitReference.InquiringClient,'') AS InquiringClient,
	ISNULL(tblUnitReference.ClientMobile,'')  AS ClientMobile,
	tblUnitReference.UnitId,
	ISNULL(tblUnitReference.UnitNo,'') AS UnitNo,
	ISNULL(tblUnitMstr.FloorType,'') AS FloorType,
	ISNULL(CONVERT(VARCHAR(20),tblUnitReference.StatDate,107),'')  AS StatDate,
	ISNULL(CONVERT(VARCHAR(20),tblUnitReference.FinishDate,107),'') AS  FinishDate,
	ISNULL(CONVERT(VARCHAR(20),tblUnitReference.TransactionDate,107),'') AS  TransactionDate,
	CAST(ISNULL(tblUnitReference.Rental,0) AS DECIMAL(10,2)) AS Rental,
	CAST(ISNULL(tblUnitReference.SecAndMaintenance,0) AS DECIMAL(10,2)) AS SecAndMaintenance ,
	CAST(ISNULL(tblUnitReference.TotalRent,0) AS DECIMAL(10,2)) AS TotalRent,
	CAST(ISNULL(tblUnitReference.Advancemonths1,0) AS DECIMAL(10,2)) AS Advancemonths1,
	CAST(ISNULL(tblUnitReference.Advancemonths2,0) AS DECIMAL(10,2)) AS  Advancemonths2,
	CAST(ISNULL(tblUnitReference.SecDeposit,0) AS DECIMAL(10,2)) AS SecDeposit,
	CAST(ISNULL(tblUnitReference.Total,0) AS DECIMAL(10,2)) AS Total,
	tblUnitReference.EncodedBy,
	tblUnitReference.EncodedDate,
	tblUnitReference.IsActive,
	tblUnitReference.ComputerName,
	'TYPE OF UNIT' as TypeOf
  FROm tblUnitReference 
  INNER JOIN tblProjectMstr 
  ON tblUnitReference.ProjectId = tblProjectMstr.RecId
  INNER JOIN tblUnitMstr 
  ON tblUnitMstr.RecId = tblUnitReference.UnitId
  WHERE ISNULL(tblUnitReference.IsPaid,0) = 0
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetFilesByClient]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetFilesByClient]
    @ClientName VARCHAR(50)
AS
BEGIN
    SELECT Id,FilePath, FileData,FileNames,Notes,Files
    FROM Files
    WHERE ClientName = @ClientName;
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetInActiveLocationList]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetInActiveLocationList] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT RecId,Descriptions,LocAddress,IIF(ISNULL(IsActive,0) = 1,'ACTIVE','IN-ACTIVE') AS IsActive  FROM tblLocationMstr WHERE ISNULL(IsActive,0) = 0
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetInActiveProjectList]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetInActiveProjectList]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT tblProjectMstr.RecId,
	tblProjectMstr.LocId,
	tblProjectMstr.ProjectAddress,
	tblLocationMstr.Descriptions AS LocationName,
	tblProjectMstr.ProjectName,
	tblProjectMstr.Descriptions,
	IIF(ISNULL(tblProjectMstr.IsActive,0) = 1,'ACTIVE','IN-ACTIVE') AS IsActive 
	FROM tblProjectMstr WITh(NOLOCK)
	INNER JOIN tblLocationMstr WITh(NOLOCK)
	ON tblLocationMstr.RecId = tblProjectMstr.LocId
	WHERE ISNULL(tblProjectMstr.IsActive,0) = 0
	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetInActivePurchaseItemList]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetInActivePurchaseItemList]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--RecId INT IDENTITY(1,1), ProjectId INT,Descriptions VARCHAR(200), DatePurchase DateTime,UnitAmount MONEY,Amount Money,Remarks VARCHAR(200)
	--ADD EncodedBy INT,EncodedDate DATETIME,LastChangedBy INT,LastChangedDate DATETIME,ComputerName VARCHAR(50),IsActive BIT
    -- Insert statements for procedure here
	SELECT 
	tblProjPurchItem.RecId,
	tblProjPurchItem.PurchItemID,
	tblProjPurchItem.ProjectId,
	tblProjectMstr.ProjectName,
	tblProjectMstr.ProjectAddress,
	ISNULL(tblProjPurchItem.Descriptions,'') AS Descriptions,
	ISNULL(CONVERT(VARCHAR(10),tblProjPurchItem.DatePurchase,103),'') AS DatePurchase,
	CAST(ISNULL(tblProjPurchItem.UnitAmount,0) AS DECIMAL(10,2)) AS UnitAmount,
	CAST(ISNULL(tblProjPurchItem.Amount,0) AS DECIMAL(10,2)) AS Amount,
		CAST(ISNULL(tblProjPurchItem.TotalAmount,0) AS DECIMAL(10,2)) AS TotalAmount,
	ISNULL(tblProjPurchItem.Remarks,'') AS Remarks,
	IIF(ISNULL(tblProjPurchItem.IsActive,0) = 1,'ACTIVE','IN-ACTIVE') AS IsActive ,
	ISNULL(tblProjPurchItem.EncodedBy,0) AS EncodedBy,
	ISNULL(CONVERT(VARCHAR(10),tblProjPurchItem.EncodedDate,103),'') AS EncodedDate,
	ISNULL(tblProjPurchItem.LastChangedBy,0) AS LastChangedBy,
	ISNULL(CONVERT(VARCHAR(10),tblProjPurchItem.LastChangedDate,103),'') AS LastChangedDate,
	ISNULL(tblProjPurchItem.ComputerName,'') AS ComputerName
	FROM tblProjPurchItem
	INNER JOIN tblProjectMstr
	ON tblProjectMstr.RecId = tblProjPurchItem.ProjectId 
	WHERE ISNULL(tblProjPurchItem.IsActive,0) = 0
	
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetLatestFile]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetLatestFile]
AS
BEGIN
    SELECT TOP 1 FilePath, FileData
    FROM Files
    ORDER BY Id DESC
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetLedgerList]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLedgerList]	
		@ReferenceID BIGINT = NULL,
		@ClientID VARCHAR(50) = NULL
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
--	Select 0 as seq,
--       (
--           SELECT SecDeposit
--           FROM tblUnitReference WITH (NOLOCK)
--           WHERE RecId = @ReferenceID
--       ) as LedgAmount,
--       CONVERT(VARCHAR(20), GETDATE(), 107) as LedgMonth,
--       'FOR 3 MONTHS SECURITY DEPOSIT' as Remarks
--UNION
	SELECT ROW_NUMBER() OVER (ORDER BY LedgMonth ASC) seq,
       Recid,
       ReferenceID,
       ClientID,
       LedgAmount,
       CONVERT(VARCHAR(20), LedgMonth, 107) AS LedgMonth,
       '' AS Remarks,
       --IIF(ISNULL(IsPaid, 0) = 1,
       --    'PAID',
       --    IIF(CONVERT(VARCHAR(20), LedgMonth, 107) = CONVERT(VARCHAR(20), GETDATE(), 107), 'FOR PAYMENT', 'PENDING')) As PaymentStatus,
       case
           when ISNULL(IsPaid, 0) = 1 and ISNULL(IsHold, 0) = 0 then
               'PAID'
           when ISNULL(IsPaid, 0) = 0 and ISNULL(IsHold, 0) = 1 then
               'HOLD'
           when CONVERT(VARCHAR(20), LedgMonth, 107) = CONVERT(VARCHAR(20), GETDATE(), 107) then
               'FOR PAYMENT'
           else
               'PENDING'
       end as PaymentStatus
FROM tblMonthLedger
WHERE ReferenceID = @ReferenceID
      AND ClientID = @ClientID
order by seq ASC
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetLocationById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLocationById] 
					@RecId INT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT RecId,Descriptions,LocAddress,ISNULL(IsActive,0) AS IsActive  FROM tblLocationMstr WHERE RecId = @RecId AND ISNULL(IsActive,0) = 1
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetLocationList]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLocationList] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT RecId,Descriptions,LocAddress,IIF(ISNULL(IsActive,0) = 1,'ACTIVE','IN-ACTIVE') AS IsActive  FROM tblLocationMstr WHERE ISNULL(IsActive,0) = 1
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetMonthLedgerByRefIdAndClientId]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetMonthLedgerByRefIdAndClientId]
			@ReferenceID INT ,
			@ClientID  VARCHAR(50) = NULL,
			@Advancemonths1  VARCHAR(50) = NULL,
			@Advancemonths2  VARCHAR(50) = NULL
		
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
Select 0 as seq,
       (
           SELECT SecDeposit
           FROM tblUnitReference WITH (NOLOCK)
           WHERE RecId = @ReferenceID
       ) as LedgAmount,
       CONVERT(VARCHAR(20), GETDATE(), 107) as LedgMonth,
       'FOR 3 MONTHS SECURITY DEPOSIT' as Remarks
UNION
SELECT ROW_NUMBER() OVER (ORDER BY LedgMonth ASC) seq,
       LedgAmount,
       CONVERT(VARCHAR(20), LedgMonth, 107) AS LedgMonth,
       IIF(LedgMonth IN( @Advancemonths1 , @Advancemonths2), 'FOR ADVANCE PAYMENT', 'FOR POST DATED CHECK') AS Remarks
FROM tblMonthLedger WITH (NOLOCK)
WHERE ReferenceID = @ReferenceID
      AND ClientID = @ClientID
order by seq ASC
	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPaymentListByReferenceId]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPaymentListByReferenceId]
	-- Add the parameters for the stored procedure here
	@RefId VARCHAR(50) = NULL 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
RecId
,PayID
,TranId
,Amount
,ISNULL(CONVERT(VARCHAR(20),ForMonth,107),'') AS ForMonth
,Remarks
,EncodedBy
,ISNULL(CONVERT(VARCHAR(20),EncodedDate,107),'') AS DatePayed
,LastChangedBy
,LastChangedDate
,ComputerName
,IsActive
,RefId
FROm tblPayment WHERE RefId = @RefId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPostDatedCountMonth]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPostDatedCountMonth] 
	-- Add the parameters for the stored procedure here
			@FromDate VARCHAR(10) = NULL,
			@EndDate VARCHAR(10) = NULL,
			@ApplicableDate1 VARCHAR(10) = NULL,
			@ApplicableDate2 VARCHAR(10) = NULL,
			@Rental VARCHAR(10) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
DECLARE @MonthsCount INT = DATEDIFF(MONTH, CONVERT(DATE, @FromDate, 101), CONVERT(DATE, @EndDate, 101))

CREATE TABLE #GeneratedMonths (
    [Month] DATE
);
    WITH MonthsCTE AS (
        SELECT CONVERT(DATE,@FromDate) AS [Month]
        UNION ALL
        SELECT DATEADD(MONTH, 1, [Month])
        FROM MonthsCTE
        WHERE DATEADD(MONTH, 1, [Month]) <= DATEADD(MONTH, @MonthsCount - 1, CONVERT(DATE,@FromDate))
    )
    INSERT INTO #GeneratedMonths ([Month])
    SELECT [Month]  FROM MonthsCTE



DELETE FROM #GeneratedMonths WHERE [Month] IN( @ApplicableDate1,@ApplicableDate2)
SELECT 
ROW_NUMBER() OVER (

ORDER BY Month ASC

) seq,CONVERT(VARCHAR(20),[Month],107) as [Dates],@Rental as Rental FROm #GeneratedMonths

DROP TABLE #GeneratedMonths;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProjectById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetProjectById] 
					@RecId INT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT 
  tblProjectMstr.RecId,
  tblProjectMstr.ProjectType,
  tblProjectMstr.ProjectName,
  tblProjectMstr.Descriptions,
  tblProjectMstr.ProjectAddress,
  ISNULL(tblProjectMstr.IsActive,0) AS IsActive ,
  tblLocationMstr.Descriptions AS LocationName,
  tblLocationMstr.RecId AS LocationId
  FROM tblProjectMstr 
  INNER JOIN tblLocationMstr
  ON tblLocationMstr.RecId = tblProjectMstr.LocId
  WHERE tblProjectMstr.RecId = @RecId
END

SELECT * FROm tblProjectMstr
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProjectList]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetProjectList]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT tblProjectMstr.RecId,
	tblProjectMstr.LocId,
	tblProjectMstr.ProjectAddress,
	tblLocationMstr.Descriptions AS LocationName,
	tblProjectMstr.ProjectName,
	tblProjectMstr.Descriptions,
	IIF(ISNULL(tblProjectMstr.IsActive,0) = 1,'ACTIVE','IN-ACTIVE') AS IsActive 
	FROM tblProjectMstr
	INNER JOIN tblLocationMstr
	ON tblLocationMstr.RecId = tblProjectMstr.LocId
	WHERE ISNULL(tblProjectMstr.IsActive,0) = 1
	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProjectTypeById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetProjectTypeById]
	@RecId INT = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
SELECT ProjectType FROM	tblProjectMstr where RecId = @RecId and ISNULL(IsActive,0) = 1
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPurchaseItemById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC sp_GetPurchaseItemById @RecId = 1002
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPurchaseItemById]
@RecId INT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--RecId INT IDENTITY(1,1), ProjectId INT,Descriptions VARCHAR(200), DatePurchase DateTime,UnitAmount MONEY,Amount Money,Remarks VARCHAR(200)
	--ADD EncodedBy INT,EncodedDate DATETIME,LastChangedBy INT,LastChangedDate DATETIME,ComputerName VARCHAR(50),IsActive BIT
    -- Insert statements for procedure here
	SELECT 
	tblProjPurchItem.RecId,
	tblProjPurchItem.PurchItemID,
	tblProjPurchItem.ProjectId,
	tblProjectMstr.ProjectName,
	tblProjectMstr.ProjectAddress,
	ISNULL(tblProjPurchItem.Descriptions,'') AS Descriptions,
	ISNULL(CONVERT(VARCHAR(10),tblProjPurchItem.DatePurchase,103),'') AS DatePurchase,
	CAST(ISNULL(tblProjPurchItem.UnitAmount,0) AS DECIMAL(10,2)) AS UnitAmount,
	CAST(ISNULL(tblProjPurchItem.Amount,0) AS DECIMAL(10,2)) AS Amount,
	ISNULL(tblProjPurchItem.Remarks,'') AS Remarks,
	IIF(ISNULL(tblProjPurchItem.IsActive,0) = 1,'ACTIVE','IN-ACTIVE') AS IsActive ,
	ISNULL(tblProjPurchItem.EncodedBy,0) AS EncodedBy,
	ISNULL(CONVERT(VARCHAR(10),tblProjPurchItem.EncodedDate,103),'') AS EncodedDate,
	ISNULL(tblProjPurchItem.LastChangedBy,0) AS LastChangedBy,
	ISNULL(CONVERT(VARCHAR(10),tblProjPurchItem.LastChangedDate,103),'') AS LastChangedDate,
	ISNULL(tblProjPurchItem.ComputerName,'') AS ComputerName
	FROM tblProjPurchItem
	LEFT JOIN tblProjectMstr
	ON tblProjectMstr.RecId = tblProjPurchItem.ProjectId
	WHERE tblProjPurchItem.ProjectId = @RecId
	
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetPurchaseItemInfoById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC sp_GetPurchaseItemInfoById @RecId = 2
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPurchaseItemInfoById]
@RecId INT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--RecId INT IDENTITY(1,1), ProjectId INT,Descriptions VARCHAR(200), DatePurchase DateTime,UnitAmount MONEY,Amount Money,Remarks VARCHAR(200)
	--ADD EncodedBy INT,EncodedDate DATETIME,LastChangedBy INT,LastChangedDate DATETIME,ComputerName VARCHAR(50),IsActive BIT
    -- Insert statements for procedure here
	SELECT 
	tblProjPurchItem.RecId,
	tblProjPurchItem.PurchItemID,
	tblProjPurchItem.ProjectId,
	tblProjectMstr.ProjectName,
	tblProjectMstr.ProjectAddress,
	ISNULL(tblProjPurchItem.Descriptions,'') AS Descriptions,
	ISNULL(CONVERT(VARCHAR(10),tblProjPurchItem.DatePurchase,1),'') AS DatePurchase,
	ISNULL(tblProjPurchItem.UnitAmount,0) AS UnitAmount,
	CAST(ISNULL(tblProjPurchItem.Amount,0) AS DECIMAL(10,2)) AS Amount,
	CAST(ISNULL(tblProjPurchItem.TotalAmount,0) AS DECIMAL(10,2)) AS TotalAmount,
	ISNULL(tblProjPurchItem.Remarks,'') AS Remarks,
	IIF(ISNULL(tblProjPurchItem.IsActive,0) = 1,'ACTIVE','IN-ACTIVE') AS IsActive ,
	ISNULL(tblProjPurchItem.EncodedBy,0) AS EncodedBy,
	IIF(ISNULL(tblProjPurchItem.EncodedBy,0)=1,'ADMINISTRATOR','') AS EncodedName,
	ISNULL(CONVERT(VARCHAR(10),tblProjPurchItem.EncodedDate,1),'') AS EncodedDate,
	ISNULL(tblProjPurchItem.LastChangedBy,0) AS LastChangedBy,
	IIF(ISNULL(tblProjPurchItem.LastChangedBy,0)=1,'ADMINISTRATOR','') AS LastChangedName,
	ISNULL(CONVERT(VARCHAR(10),tblProjPurchItem.LastChangedDate,1),'') AS LastChangedDate,
	ISNULL(tblProjPurchItem.ComputerName,'') AS ComputerName,
	ISNULL(tblProjPurchItem.UnitNumber,'') AS UnitNumber,
	ISNULL(tblProjPurchItem.UnitID,0) AS UnitID
	FROM tblProjPurchItem
	LEFT JOIN tblProjectMstr
	ON tblProjectMstr.RecId = tblProjPurchItem.ProjectId
	WHERE tblProjPurchItem.RecId = @RecId
	
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetPurchaseItemList]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPurchaseItemList]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--RecId INT IDENTITY(1,1), ProjectId INT,Descriptions VARCHAR(200), DatePurchase DateTime,UnitAmount MONEY,Amount Money,Remarks VARCHAR(200)
	--ADD EncodedBy INT,EncodedDate DATETIME,LastChangedBy INT,LastChangedDate DATETIME,ComputerName VARCHAR(50),IsActive BIT
    -- Insert statements for procedure here
	SELECT 
	tblProjPurchItem.RecId,
	tblProjPurchItem.PurchItemID,
	tblProjPurchItem.ProjectId,
	tblProjectMstr.ProjectName,
	tblProjectMstr.ProjectAddress,
	ISNULL(tblProjPurchItem.Descriptions,'') AS Descriptions,
	ISNULL(CONVERT(VARCHAR(10),tblProjPurchItem.DatePurchase,103),'') AS DatePurchase,
	ISNULL(tblProjPurchItem.UnitAmount,0) AS UnitAmount,
	CAST(ISNULL(tblProjPurchItem.Amount,0) AS DECIMAL(10,2)) AS Amount,
	CAST(ISNULL(tblProjPurchItem.TotalAmount,0) AS DECIMAL(10,2)) AS TotalAmount,
	ISNULL(tblProjPurchItem.Remarks,'') AS Remarks,
	IIF(ISNULL(tblProjPurchItem.IsActive,0) = 1,'ACTIVE','IN-ACTIVE') AS IsActive ,
	ISNULL(tblProjPurchItem.EncodedBy,0) AS EncodedBy,
	ISNULL(CONVERT(VARCHAR(10),tblProjPurchItem.EncodedDate,103),'') AS EncodedDate,
	ISNULL(tblProjPurchItem.LastChangedBy,0) AS LastChangedBy,
	ISNULL(CONVERT(VARCHAR(10),tblProjPurchItem.LastChangedDate,103),'') AS LastChangedDate,
	ISNULL(tblProjPurchItem.ComputerName,'') AS ComputerName
	FROM tblProjPurchItem
	INNER JOIN tblProjectMstr
	ON tblProjectMstr.RecId = tblProjPurchItem.ProjectId 
	WHERE ISNULL(tblProjPurchItem.IsActive,0) = 1 ORDER BY EncodedDate DESC
	
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetRateSettingsByType]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetRateSettingsByType] 
					@ProjectType VARCHAR(20) = NULL
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @BaseWithVatAmount DECIMAL(18, 2) = 0


    SELECT @BaseWithVatAmount
        = CAST(ISNULL(tblRatesSettings.SecurityAndMaintenance, 0)
               + (((ISNULL(tblRatesSettings.SecurityAndMaintenance, 0) * ISNULL(tblRatesSettings.GenVat, 0)) / 100)) AS DECIMAL(18, 2))
    FROM tblRatesSettings WITH (NOLOCK)
    WHERE ProjectType = @ProjectType

    -- Insert statements for procedure here
    SELECT tblRatesSettings.ProjectType,
           ISNULL(tblRatesSettings.GenVat, 0) AS GenVat,
           CAST(ISNULL(tblRatesSettings.SecurityAndMaintenance, 0)
                + (((ISNULL(tblRatesSettings.SecurityAndMaintenance, 0) * ISNULL(tblRatesSettings.GenVat, 0)) / 100)
                   - ((@BaseWithVatAmount * ISNULL(tblRatesSettings.WithHoldingTax, 0)) / 100)
                  ) AS DECIMAL(18, 2)) AS SecurityAndMaintenance,
           ISNULL(tblRatesSettings.SecurityAndMaintenanceVat, 0) AS SecurityAndMaintenanceVat,
           ISNULL(tblRatesSettings.IsSecAndMaintVat, 0) AS IsSecAndMaintVat,
           ISNULL(tblRatesSettings.WithHoldingTax, 0) AS WithHoldingTax,
           ISNULL(tblRatesSettings.EncodedBy, 0) as EncodedBy,
           ISNULL(tblRatesSettings.EncodedDate, '1900-01-01') AS EncodedDate,
           ISNULL(tblRatesSettings.ComputerName, '') AS ComputerName,
           IIF(ISNULL(GenVat, 0) > 0, 'INCLUSIVE OF VAT', 'EXCLUSIVE OF VAT') AS labelVat
    FROM tblRatesSettings WITH (NOLOCK)
    WHERE ProjectType = @ProjectType

END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetReferenceByClientID]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetReferenceByClientID]
	-- Add the parameters for the stored procedure here
	@ClientID VARCHAR(50) = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM tblUnitReference WHERE ClientID = @ClientID
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetRESIDENTIALSettings]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetRESIDENTIALSettings] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT 
			ProjectType,
			ISNULL(GenVat,0) AS GenVat,
			ISNULL(SecurityAndMaintenance,0) AS SecurityAndMaintenance,
			--ISNULL(SecurityAndMaintenanceVat,0) AS SecurityAndMaintenanceVat,
			--ISNULL(IsSecAndMaintVat,0) AS IsSecAndMaintVat,
			ISNULL(WithHoldingTax,0) AS WithHoldingTax,
			EncodedBy,
			EncodedDate,
			ComputerName
		FROM tblRatesSettings WHERE ProjectType = 'RESIDENTIAL'

END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSelecClient]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetSelecClient] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 SELECT -1 AS RecId ,'--SELECT--' AS ClientName
	UNION
  SELECT 
	RecId,
    ISNULL(ClientName,'') AS ClientName
 FROM tblClientMstr WITH(NOLOCK) WHERE ISNULL(IsMap,0) = 0
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUnitAvailableById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetUnitAvailableById] 1
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUnitAvailableById] 
				@UnitNo INT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @BaseWithVatAmount DECIMAL(18, 2) = 0


    SELECT @BaseWithVatAmount
        = CAST(ISNULL(tblUnitMstr.BaseRental, 0)
               + (((ISNULL(tblUnitMstr.BaseRental, 0) * ISNULL(tblRatesSettings.GenVat, 0)) / 100)) AS DECIMAL(18, 2))
    from tblUnitMstr WITH (NOLOCK)
        left join tblProjectMstr WITH (NOLOCK)
            on tblUnitMstr.ProjectId = tblProjectMstr.RecId
        left join tblRatesSettings WITH (NOLOCK)
            on tblProjectMstr.ProjectType = tblRatesSettings.ProjectType
    WHERE tblUnitMstr.RecId = @UnitNo
          AND ISNULL(tblUnitMstr.IsActive, 0) = 1
          and tblUnitMstr.UnitStatus = 'VACANT'


    select tblProjectMstr.ProjectName,
           tblProjectMstr.ProjectType,
           tblUnitMstr.RecId,
           ISNULL(tblUnitMstr.FloorType, '') AS FloorType,
           CAST(ISNULL(tblUnitMstr.BaseRental, 0)
                + (((ISNULL(tblUnitMstr.BaseRental, 0) * ISNULL(tblRatesSettings.GenVat, 0)) / 100)
                   - ((@BaseWithVatAmount * ISNULL(tblRatesSettings.WithHoldingTax, 0)) / 100)
                  ) AS DECIMAL(18, 2)) as BaseRental
    from tblUnitMstr WITH (NOLOCK)
        left join tblProjectMstr WITH (NOLOCK)
            on tblUnitMstr.ProjectId = tblProjectMstr.RecId
        left join tblRatesSettings WITH (NOLOCK)
            on tblProjectMstr.ProjectType = tblRatesSettings.ProjectType
    WHERE tblUnitMstr.RecId = @UnitNo
          AND ISNULL(tblUnitMstr.IsActive, 0) = 1
          and tblUnitMstr.UnitStatus = 'VACANT'
    ORDER BY tblUnitMstr.UnitSequence DESC
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUnitAvailableByProjectId]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--EXEC [sp_GetUnitAvailableByProjectId] @ProjectId = 1
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUnitAvailableByProjectId] 
			@ProjectId INT 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT 
		RecId
		,ISNULL(UnitNo,'') AS UnitNo
  FROm tblUnitMstr 
  WHERE ProjectId = @ProjectId
  AND ISNULL(IsActive,0) = 1 and UnitStatus = 'VACANT' AND ISNULL(IsParking,0) = 0
  ORDER BY tblUnitMstr.UnitSequence DESC
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUnitById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUnitById] 
			@RecId INT 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT 
		tblUnitMstr.RecId
		,tblUnitMstr.ProjectId
		,ISNULL(tblProjectMstr.ProjectName,'') AS ProjectName
		,IIF(ISNULL(tblUnitMstr.IsParking,0)=1,'PARKING','UNIT') AS UnitDescription
		,ISNULL(tblUnitMstr.FloorNo,0) AS FloorNo
		,ISNULL(tblUnitMstr.AreaSqm,0) AS AreaSqm
		,ISNULL(tblUnitMstr.AreaRateSqm,0) AS AreaRateSqm
		,ISNULL(tblUnitMstr.FloorType,'') AS FloorType
		,ISNULL(tblUnitMstr.BaseRental,0) AS BaseRental
		--,GenVat
		--,SecurityAndMaintenance
		--,SecurityAndMaintenanceVat
		,ISNULL(tblUnitMstr.UnitStatus,'') AS UnitStatus
		,ISNULL(tblUnitMstr.DetailsofProperty,'') as DetailsofProperty
		,ISNULL(tblUnitMstr.UnitNo,'') AS UnitNo
		,ISNULL(UnitSequence,0) AS UnitSequence
		--,EndodedBy
		--,EndodedDate
		--,LastChangedBy
		--,LastChangedDate
		,IIF(ISNULL(tblUnitMstr.IsActive,0)= 1,'ACTIVE','IN-ACTIVE') AS IsActive
		--,ComputerName
		--,clientID
		--,Tennant
  
  
  FROm tblUnitMstr 
  INNER JOIN tblProjectMstr
  ON tblUnitMstr.ProjectId = tblProjectMstr.RecId
  WHERE tblUnitMstr.RecId = @RecId
  ORDER BY tblUnitMstr.UnitSequence DESC
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUnitByProjectId]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUnitByProjectId] 
			@ProjectId INT 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT tblUnitMstr.RecId,
       tblUnitMstr.ProjectId,
       ISNULL(tblProjectMstr.ProjectName, '') AS ProjectName,
       IIF(ISNULL(tblUnitMstr.IsParking, 0) = 1, 'TYPE OF PARKING', 'TYPE OF UNIT') AS UnitDescription,
       ISNULL(tblUnitMstr.FloorNo, 0) AS FloorNo,
       ISNULL(tblUnitMstr.AreaSqm, 0) AS AreaSqm,
       ISNULL(tblUnitMstr.AreaRateSqm, 0) AS AreaRateSqm,
       ISNULL(tblUnitMstr.FloorType, '') AS FloorType,
       ISNULL(tblUnitMstr.BaseRental, 0) AS BaseRental,
       --,GenVat
       --,SecurityAndMaintenance
       --,SecurityAndMaintenanceVat
       IIF(ISNULL(tblUnitMstr.UnitStatus, '') <> 'RESERVED',
           ISNULL(tblUnitMstr.UnitStatus, ''),
           ISNULL(tblUnitMstr.UnitStatus, '') + ' TO : ' + ISNULL(CAST(tblUnitReference.ClientID as VARCHAR(20)), '')
           + ' - ' + tblUnitReference.InquiringClient) AS UnitStatus,
       ISNULL(tblUnitMstr.UnitStatus, '') AS UnitStat,
       ISNULL(tblUnitMstr.DetailsofProperty, '') as DetailsofProperty,
       ISNULL(tblUnitMstr.UnitNo, '') AS UnitNo,
       --,UnitSequence
       --,EndodedBy
       --,EndodedDate
       --,LastChangedBy
       --,LastChangedDate
       IIF(ISNULL(tblUnitMstr.IsActive, 0) = 1, 'ACTIVE', 'IN-ACTIVE') AS IsActive
--,ComputerName
--,clientID
--,Tennant


FROm tblUnitMstr WITH (NOLOCK)
    INNER JOIN tblProjectMstr WITH (NOLOCK)
        ON tblUnitMstr.ProjectId = tblProjectMstr.RecId
    LEFT JOIN tblUnitReference WITH (NOLOCK)
        ON tblUnitMstr.RecId = tblUnitReference.UnitId
WHERE tblUnitMstr.ProjectId = @ProjectId
      and ISNULL(tblUnitReference.IsDone, 0) = 0
ORDER BY tblProjectMstr.ProjectName,
         tblUnitMstr.UnitSequence DESC
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUnitList]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUnitList] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT tblUnitMstr.RecId,
       tblUnitMstr.ProjectId,
       ISNULL(tblProjectMstr.ProjectName, '') AS ProjectName,
       IIF(ISNULL(tblUnitMstr.IsParking, 0) = 1, 'TYPE OF PARKING', 'TYPE OF UNIT') AS UnitDescription,
       ISNULL(tblUnitMstr.FloorNo, 0) AS FloorNo,
       ISNULL(tblUnitMstr.AreaSqm, 0) AS AreaSqm,
       ISNULL(tblUnitMstr.AreaRateSqm, 0) AS AreaRateSqm,
       ISNULL(tblUnitMstr.FloorType, '') AS FloorType,
       ISNULL(tblUnitMstr.BaseRental, 0) AS BaseRental,
       --,GenVat
       --,SecurityAndMaintenance
       --,SecurityAndMaintenanceVat
       IIF(ISNULL(tblUnitMstr.UnitStatus, '') <> 'RESERVED',
           ISNULL(tblUnitMstr.UnitStatus, ''),
           ISNULL(tblUnitMstr.UnitStatus, '') + ' TO : ' + ISNULL(CAST(tblUnitReference.ClientID as VARCHAR(20)), '')
           + ' - ' + tblUnitReference.InquiringClient) AS UnitStatus,
       ISNULL(tblUnitMstr.UnitStatus, '') AS UnitStat,
       ISNULL(tblUnitMstr.DetailsofProperty, '') as DetailsofProperty,
       ISNULL(tblUnitMstr.UnitNo, '') AS UnitNo,
       --,UnitSequence
       --,EndodedBy
       --,EndodedDate
       --,LastChangedBy
       --,LastChangedDate
       IIF(ISNULL(tblUnitMstr.IsActive, 0) = 1, 'ACTIVE', 'IN-ACTIVE') AS IsActive
--,ComputerName
--,clientID
--,Tennant


FROm tblUnitMstr
    INNER JOIN tblProjectMstr
        ON tblUnitMstr.ProjectId = tblProjectMstr.RecId
    LEFT JOIN tblUnitReference
        ON tblUnitMstr.RecId = tblUnitReference.UnitId
WHERE ISNULL(tblUnitReference.IsDone, 0) = 0
ORDER BY tblProjectMstr.ProjectName,
         tblUnitMstr.UnitSequence DESC
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetWAREHOUSESettings]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetWAREHOUSESettings] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT 
			ProjectType,
			ISNULL(GenVat,0) AS GenVat,
			ISNULL(SecurityAndMaintenance,0) AS SecurityAndMaintenance,
			--ISNULL(SecurityAndMaintenanceVat,0) AS SecurityAndMaintenanceVat,
			--ISNULL(IsSecAndMaintVat,0) AS IsSecAndMaintVat,
			ISNULL(WithHoldingTax,0) AS WithHoldingTax,
			EncodedBy,
			EncodedDate,
			ComputerName
		FROM tblRatesSettings WHERE ProjectType = 'WAREHOUSE'

END
GO
/****** Object:  StoredProcedure [dbo].[sp_ProjectAddress]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProjectAddress]
     @projectId INT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		

	select ProjectAddress,ProjectType FROM tblProjectMstr

	WHERE ISNULL(IsActive,0) = 1 and RecId = @projectId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveClient]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_SaveClient]
    @ClientType VARCHAR(50),
    @ClientName VARCHAR(100),
    @Age INT= 0,
    @PostalAddress VARCHAR(100)= null,
    @DateOfBirth DATE= null,
    @TelNumber VARCHAR(20)= null,
    @Gender BIT= null,
    @Nationality VARCHAR(50)= null,
    @Occupation VARCHAR(100)= null,
    @AnnualIncome DECIMAL(18, 2)= 0,
    @EmployerName VARCHAR(100)= null,
    @EmployerAddress VARCHAR(200)= null,
    @SpouseName VARCHAR(100)= null,
    @ChildrenNames VARCHAR(500)= null,
    @TotalPersons INT= 0,
    @MaidName VARCHAR(100)= null,
    @DriverName VARCHAR(100)= null,
    @VisitorsPerDay INT= 0,
    --@IsTwoMonthAdvanceRental BIT = null,
    --@IsThreeMonthSecurityDeposit BIT = null,
    --@Is10PostDatedChecks BIT = null,
    --@IsPhotoCopyValidID BIT = null,
    --@Is2X2Picture BIT = null,
    @BuildingSecretary INT= 0,
    @EncodedBy INT= 0,
    @ComputerName VARCHAR(50)= null
AS
BEGIN
    SET NOCOUNT ON;


    -- Insert the record into tblClientMstr
    INSERT INTO tblClientMstr
    (
      
        ClientType,
        ClientName,
        Age,
        PostalAddress,
        DateOfBirth,
        TelNumber,
        Gender,
        Nationality,
        Occupation,
        AnnualIncome,
        EmployerName,
        EmployerAddress,
        SpouseName,
        ChildrenNames,
        TotalPersons,
        MaidName,
        DriverName,
        VisitorsPerDay,
        --IsTwoMonthAdvanceRental,
        --IsThreeMonthSecurityDeposit,
        --Is10PostDatedChecks,
        --IsPhotoCopyValidID,
        --Is2X2Picture,
        BuildingSecretary,
        EncodedDate,
        EncodedBy,    
		IsActive,
        ComputerName
    )
    VALUES
    (
       
        @ClientType,
        @ClientName,
        @Age,
        @PostalAddress,
        @DateOfBirth,
        @TelNumber,
        @Gender,
        @Nationality,
        @Occupation,
        @AnnualIncome,
        @EmployerName,
        @EmployerAddress,
        @SpouseName,
        @ChildrenNames,
        @TotalPersons,
        @MaidName,
        @DriverName,
        @VisitorsPerDay,
        --@IsTwoMonthAdvanceRental,
        --@IsThreeMonthSecurityDeposit,
        --@Is10PostDatedChecks,
        --@IsPhotoCopyValidID,
        --@Is2X2Picture,
        @BuildingSecretary,
        GETDATE(),
        @EncodedBy,
		1,
		@ComputerName
		)

		if(@@ROWCOUNT > 0)
		BEGIN
			SELECT 'SUCCESS' AS Message_Code
		END
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveComputation]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_SaveComputation]
	@ProjectId int,
	@InquiringClient varchar(500),
	@ClientMobile varchar(50),
	@UnitId int,
	@UnitNo varchar(50),
	@StatDate VARCHAR(10),
	@FinishDate VARCHAR(10),
	@Applicabledate1 VARCHAR(10),
	@Applicabledate2 VARCHAR(10),
	@Rental decimal(18, 2) NULL,
	@SecAndMaintenance decimal(18, 2),
	@TotalRent decimal(18, 2),
	@Advancemonths1 decimal(18, 2),
	@Advancemonths2 decimal(18, 2),
	@SecDeposit decimal(18, 2),
	@Total decimal(18, 2),
	@EncodedBy int,	
	@ComputerName varchar(30),
	@ClientID varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @ComputationID AS INT = 0

	update tblUnitMstr set UnitStatus = 'RESERVED' WHERE RecId = @UnitId

    -- Insert the record into tblClientMstr
    INSERT INTO tblUnitReference
    (
      
	[ProjectId],
	[InquiringClient],
	[ClientMobile] ,
	[UnitId] ,
	[UnitNo] ,
	[StatDate] ,
	[FinishDate] ,
	[TransactionDate],
	[Applicabledate1],
	[Applicabledate2],
	[Rental],
	[SecAndMaintenance] ,
	[TotalRent] ,
	[Advancemonths1],
	[Advancemonths2] ,
	[SecDeposit] ,
	[Total],
	[EncodedBy] ,
	[EncodedDate],
	[IsActive],
	[ComputerName],
	[ClientID]
    )
    VALUES
    (
       
    @ProjectId,
	@InquiringClient,
	@ClientMobile,
	@UnitId,
	@UnitNo,
	@StatDate,
	@FinishDate,
	GETDATE(),
	@Applicabledate1,
	@Applicabledate2,
	@Rental,
	@SecAndMaintenance,
	@TotalRent,
	@Advancemonths1,
	@Advancemonths2,
	@SecDeposit,
	@Total,
	@EncodedBy,
	GETDATE(),
	1,
	@ComputerName,
	@ClientID
		)
		SET  @ComputationID = SCOPE_IDENTITY();
		if(@@ROWCOUNT > 0)
		BEGIN

	EXEC [sp_GenerateLedger] 

			@FromDate =			@StatDate,
			@EndDate =			@FinishDate,
			@LedgAmount =		@TotalRent,
			@ComputationID =	@ComputationID,
			@ClientID =			@ClientID,
			@EncodedBy  =		@EncodedBy,
			@ComputerName  =	@ComputerName

			SELECT 'SUCCESS' AS Message_Code
		END
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveFile]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_SaveFile]
    @FilePath NVARCHAR(MAX),
    @FileData VARBINARY(MAX),
	@ClientName VARCHAR(100),
	@FileNames VARCHAR(100),
	@Files VARCHAR(200),
	@Notes VARCHAR(500) = NULL
AS
BEGIN
    INSERT INTO Files (ClientName,FilePath, FileData,FileNames,Notes,Files)
    VALUES (@ClientName,@FilePath, @FileData,@FileNames,@Notes,@Files)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveLocation]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SaveLocation] 
	@Description varchar(50) = null,
	@LocAddress varchar(500) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO tblLocationMstr (Descriptions,LocAddress,IsActive)VALUES  (@Description,@LocAddress,1)

	if(@@ROWCOUNT > 0)
		BEGIN
			SELECT 'SUCCESS' AS Message_Code
		END
	ELSE
		BEGIN
			SELECT 'FAIL' AS Message_Code
		END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveNewtUnit]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SaveNewtUnit]
    @ProjectId INT= NULL,
    @IsParking BIT= NULL,
    @FloorNo INT= NULL,
    @AreaSqm DECIMAL(18, 2)= NULL,
    @AreaRateSqm DECIMAL(18, 2)= NULL,
    @FloorType VARCHAR(50)= NULL,
    @BaseRental DECIMAL(18, 2)= NULL,
    --@UnitStatus VARCHAR(50) = NULL,
    @DetailsofProperty VARCHAR(300) = NULL,
    @UnitNo VARCHAR(20) = NULL,
    @UnitSequence INT = NULL, 
    @EndodedBy INT = NULL,
    @ComputerName VARCHAR(20) = NULL

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
        @ProjectId,
        @IsParking,
        @FloorNo,
        @AreaSqm,
        @AreaRateSqm,
        @FloorType,
        @BaseRental,
        'VACANT',
        @DetailsofProperty,
        @UnitNo,
        @UnitSequence,
        @EndodedBy,
		GETDATE(),
        1,
        @ComputerName 
    )

	if(@@ROWCOUNT > 0)
	BEGIN
	SELECT 'SUCCESS' AS Message_Code
	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SaveProject]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SaveProject]
@ProjectType VARCHAR(50) = NULL,
@LocId INT = NULL,
@ProjectName VARCHAR(50) = NULL,
@Descriptions VARCHAR(50) = NULL,
@ProjectAddress VARCHAR(500) = NULL

	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	IF NOT EXISTS (SELECT ProjectName FROM tblProjectMstr WHERE ProjectName = @ProjectName)
		BEGIN
			INSERT INTO tblProjectMstr (ProjectType,LocId,ProjectName,Descriptions,ProjectAddress,IsActive)VALUES(@ProjectType,@LocId,@ProjectName,@Descriptions,@ProjectAddress,1)

			IF(@@ROWCOUNT > 0)
				BEGIN
					SELECT 'SUCCESS' AS Message_Code
				END
		END
	ELSE
		BEGIN
			SELECT 'PROJECT NAME ALREADY EXISTS' AS Message_Code
		END
END


GO
/****** Object:  StoredProcedure [dbo].[sp_SavePurchaseItem]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SavePurchaseItem]
@ProjectId INT = NULL,
@Descriptions VARCHAR(200) = NULL,
@DatePurchase DateTime = NULL,
@UnitAmount INT = NULL,
@Amount DECIMAL(18,2) = NULL,
@TotalAmount DECIMAL(18,2) = NULL,
@Remarks VARCHAR(200) = NULL,
@UnitNumber VARCHAR(50) = NULL,
@UnitID INT = NULL,
@EncodedBy INT = NULL,
@ComputerName VARCHAR(50) = NULL

	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--CREATE TABLE tblProjPurchItem (RecId INT IDENTITY(1,1), ProjectId INT,Descriptions VARCHAR(200), DatePurchase DateTime,UnitAmount MONEY,Amount Money,Remarks VARCHAR(200))
--ALTER TABLE tblProjPurchItem ADD EncodedBy INT,EncodedDate DATETIME,LastChangedBy INT,LastChangedDate DATETIME,ComputerName VARCHAR(50),IsActive BIT

	IF NOT EXISTS (SELECT * FROM tblProjPurchItem WHERE Descriptions = @Descriptions and ProjectId = @ProjectId)
		BEGIN
			INSERT INTO tblProjPurchItem(ProjectId,Descriptions,DatePurchase,UnitAmount,Amount,TotalAmount,Remarks,UnitNumber,UnitID,EncodedBy,EncodedDate,ComputerName,IsActive)
			VALUES
			(@ProjectId,@Descriptions,@DatePurchase,@UnitAmount,@Amount,@TotalAmount,@Remarks,@UnitNumber,@UnitID,@EncodedBy,GETDATE(),@ComputerName,1)

			IF(@@ROWCOUNT > 0)
				BEGIN
					SELECT 'SUCCESS' AS Message_Code
				END
		END
	ELSE
		BEGIN
			SELECT 'PROJECT NAME ALREADY EXISTS' AS Message_Code
		END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectFloorTypes]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SelectFloorTypes]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT -1 AS RecId,'--SELECT--' AS FloorTypesDescription
	UNION
SELECT RecId,FloorTypesDescription FROM	tblFloorTypes
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectLocation]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SelectLocation]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select RecId,Descriptions FROM tblLocationMstr
	UNION
	SELECT -1,'--SELECT--'  
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectProject]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SelectProject]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		
	SELECT -1 AS RecId,'--SELECT--'  AS ProjectName 
	UNION
	select RecId,ProjectName FROM tblProjectMstr

	WHERE ISNULL(IsActive,0) = 1
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SelectProjectType]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SelectProjectType]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT
-1 AS Recid, 
'--SELECT--' AS ProjectTypeName
UNION
SELECT 
Recid ,
ProjectTypeName 
FROM tblProjectType WITH(NOLOCK)



END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateCOMMERCIALSettings]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateCOMMERCIALSettings] 
				@GenVat INT = NULL,
				@SecurityAndMaintenance DECIMAL(18,2) = NULL,
				@SecurityAndMaintenanceVat INT = 0,
				@IsSecAndMaintVat BIT = 0,
				@WithHoldingTax INT = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	UPDATE tblRatesSettings 
	SET GenVat = @GenVat,
	SecurityAndMaintenance = @SecurityAndMaintenance,
	--SecurityAndMaintenanceVat = @SecurityAndMaintenanceVat,
	--IsSecAndMaintVat = @IsSecAndMaintVat ,
	WithHoldingTax = @WithHoldingTax
	WHERE ProjectType = 'COMMERCIAL'

	IF(@@ROWCOUNT > 0)
	BEGIN
		SELECT 'SUCCESS' AS Message_Code
	END
    -- Insert statements for procedure here
		--SELECT 
		--	ProjectType,
		--	ISNULL(GenVat,0) AS GenVat,
		--	ISNULL(SecurityAndMaintenance,0) AS SecurityAndMaintenance,
		--	ISNULL(SecurityAndMaintenanceVat,0) AS SecurityAndMaintenanceVat,
		--	ISNULL(IsSecAndMaintVat,0) AS IsSecAndMaintVat,
		--	ISNULL(WithHoldingTax,0) AS WithHoldingTax,
		--	EncodedBy,
		--	EncodedDate,
		--	ComputerName
		--FROM tblRatesSettings WHERE ProjectType = 'RESIDENTIAL'

END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateLocationById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateLocationById] 
					@RecId INT,
					@Descriptions VARCHAR(50) = NULL,
					@LocAddress VARCHAR(500) = NULL
					--@IsActive bit = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	UPDATE tblLocationMstr SET Descriptions = @Descriptions,LocAddress = @LocAddress WHERE RecId = @RecId

	if(@@ROWCOUNT > 0)
	BEGIN

	SELECT 'SUCCESS' AS Message_Code

	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateProjectById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateProjectById] 
					@RecId INT,
					@ProjectType VARCHAR(50) = NULL,
					@LocId INT,
					@ProjectName VARCHAR(50) = NULL,
					@Descriptions VARCHAR(500) = NULL,
					--@IsActive bit = NULL,
					@ProjectAddress VARCHAR(500) = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	UPDATE tblProjectMstr 
	SET LocId = @LocId,
		Descriptions = @Descriptions,
		ProjectName = @ProjectName,
		ProjectType = @ProjectType,
		--IsActive = @IsActive ,
		ProjectAddress = @ProjectAddress 
	WHERE RecId = @RecId

	if(@@ROWCOUNT > 0)
	BEGIN

	SELECT 'SUCCESS' AS Message_Code

	END
END

GO
/****** Object:  StoredProcedure [dbo].[sp_UpdatePurchaseItemById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdatePurchaseItemById] 
					@RecId INT,
					@ProjectId INT,
					@Descriptions VARCHAR(50) = NULL,
					@DatePurchase VARCHAR(500) = NULL,
					@UnitAmount DECIMAL(18,2) = NULL,
					@Amount DECIMAL(18,2) = NULL,
					@TotalAmount DECIMAL(18,2) = NULL,
					@Remarks VARCHAR(200) = NULL,
					@UnitNumber VARCHAR(50) = NULL,
					@UnitID INT = NULL,
					@LastChangedBy int = NULL,
					@ComputerName VARCHAR(50) = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if  EXISTS(SELECT * FROM tblProjPurchItem WHERE RecId = @RecId)
		BEGIN

			UPDATE tblProjPurchItem SET ProjectId = @ProjectId,
			Descriptions = @Descriptions,
			DatePurchase = @DatePurchase,
			UnitAmount = @UnitAmount,
			Amount = @Amount,
			TotalAmount = @TotalAmount,
			Remarks = @Remarks,
			UnitNumber = @UnitNumber,
			UnitID = @UnitID,
			LastChangedBy=@LastChangedBy,
			LastChangedDate=GETDATE(),
			ComputerName=@ComputerName 
			WHERE RecId = @RecId

			if(@@ROWCOUNT > 0)
				BEGIN

					SELECT 'SUCCESS' AS Message_Code

				END
		END
	ELSE
				BEGIN

					SELECT 'NOT EXISTS' AS Message_Code

				END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateRESIDENTIALSettings]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateRESIDENTIALSettings] 
				@GenVat INT = NULL,
				@SecurityAndMaintenance DECIMAL(18,2) = NULL,
				@SecurityAndMaintenanceVat INT = 0,
				@IsSecAndMaintVat BIT = 0
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	UPDATE tblRatesSettings 
	SET GenVat = @GenVat,
	SecurityAndMaintenance = @SecurityAndMaintenance
	--SecurityAndMaintenanceVat = @SecurityAndMaintenanceVat,
	--IsSecAndMaintVat = @IsSecAndMaintVat 
	WHERE ProjectType = 'RESIDENTIAL'

	IF(@@ROWCOUNT > 0)
	BEGIN
		SELECT 'SUCCESS' AS Message_Code
	END
    -- Insert statements for procedure here
		--SELECT 
		--	ProjectType,
		--	ISNULL(GenVat,0) AS GenVat,
		--	ISNULL(SecurityAndMaintenance,0) AS SecurityAndMaintenance,
		--	ISNULL(SecurityAndMaintenanceVat,0) AS SecurityAndMaintenanceVat,
		--	ISNULL(IsSecAndMaintVat,0) AS IsSecAndMaintVat,
		--	ISNULL(WithHoldingTax,0) AS WithHoldingTax,
		--	EncodedBy,
		--	EncodedDate,
		--	ComputerName
		--FROM tblRatesSettings WHERE ProjectType = 'RESIDENTIAL'

END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateUnitById]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateUnitById]
    @RecId INT,
    --@UnitDescription VARCHAR(300)= null,
    @FloorNo INT= null,
    @AreaSqm DECIMAL(18, 2)= null,
    @AreaRateSqm DECIMAL(18, 2)= null,
    @FloorType VARCHAR(50)= null,
    @BaseRental DECIMAL(18, 2)= null,
	--This will update during the generation of Transaction and set uisng the Rate settings table
    --@GenVat INT = null this ,
    --@SecurityAndMaintenance DECIMAL(18, 2)= null,
    --@SecurityAndMaintenanceVat INT = null,
    @UnitStatus VARCHAR(50)= null,
    @DetailsofProperty VARCHAR(300)= null,
    @UnitNo VARCHAR(20)= null,
    @UnitSequence INT= null,
    @LastChangedBy INT= null,
    --@IsActive BIT,
    @ComputerName VARCHAR(20)= null
    --@ClientID INT= null,
    --@Tenant VARCHAR(200)= null
AS
BEGIN
    UPDATE [dbo].[tblUnitMstr]
    SET
       
        --[UnitDescription] = @UnitDescription,
        [FloorNo] = @FloorNo,
        [AreaSqm] = @AreaSqm,
        [AreaRateSqm] = @AreaRateSqm,
        [FloorType] = @FloorType,
        [BaseRental] = @BaseRental,
        --[GenVat] = @GenVat,
        --[SecurityAndMaintenance] = @SecurityAndMaintenance,
        --[SecurityAndMaintenanceVat] = @SecurityAndMaintenanceVat,
        [UnitStatus] = @UnitStatus,
        [DetailsofProperty] = @DetailsofProperty,
        [UnitNo] = @UnitNo,
        [UnitSequence] = @UnitSequence,
        [LastChangedBy] = @LastChangedBy,
        [LastChangedDate] = GETDATE(),
        --[IsActive] = @IsActive,
        [ComputerName] = @ComputerName
        --[clientID] = @ClientID,
        --[Tennant] = @Tenant
    WHERE
        [RecId] = @RecId

		if(@@ROWCOUNT > 0)
		BEGIN
		SELECT 'SUCCESS' AS Message_Code
		END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateWAREHOUSESettings]    Script Date: 11/7/2023 5:14:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateWAREHOUSESettings] 
				@GenVat INT = NULL,
				@SecurityAndMaintenance DECIMAL(18,2) = NULL,
				@SecurityAndMaintenanceVat INT = 0,
				@IsSecAndMaintVat BIT = 0,
				@WithHoldingTax INT = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	UPDATE tblRatesSettings 
	SET GenVat = @GenVat,
	SecurityAndMaintenance = @SecurityAndMaintenance,
	--SecurityAndMaintenanceVat = @SecurityAndMaintenanceVat,
	--IsSecAndMaintVat = @IsSecAndMaintVat ,
	WithHoldingTax = @WithHoldingTax
	WHERE ProjectType = 'WAREHOUSE'

	IF(@@ROWCOUNT > 0)
	BEGIN
		SELECT 'SUCCESS' AS Message_Code
	END
    -- Insert statements for procedure here
		--SELECT 
		--	ProjectType,
		--	ISNULL(GenVat,0) AS GenVat,
		--	ISNULL(SecurityAndMaintenance,0) AS SecurityAndMaintenance,
		--	ISNULL(SecurityAndMaintenanceVat,0) AS SecurityAndMaintenanceVat,
		--	ISNULL(IsSecAndMaintVat,0) AS IsSecAndMaintVat,
		--	ISNULL(WithHoldingTax,0) AS WithHoldingTax,
		--	EncodedBy,
		--	EncodedDate,
		--	ComputerName
		--FROM tblRatesSettings WHERE ProjectType = 'RESIDENTIAL'

END
GO
