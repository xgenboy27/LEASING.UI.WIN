USE [LEASINGDB]
GO
/****** Object:  Table [dbo].[ErrorLog]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorLog](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProcedureName] [nvarchar](255) NOT NULL,
	[ErrorMessage] [nvarchar](max) NOT NULL,
	[LogDateTime] [datetime] NOT NULL,
	[frmName] [varchar](500) NULL,
	[FormName] [varchar](500) NULL,
	[Category] [varchar](500) NULL,
	[UserId] [int] NULL,
	[ComputerName] [varchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Files]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Files](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FilePath] [nvarchar](max) NULL,
	[FileData] [varbinary](max) NULL,
	[ClientName] [varchar](100) NULL,
	[FileNames] [varchar](500) NULL,
	[Notes] [varchar](500) NULL,
	[Files] [varchar](200) NULL,
	[RefId] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoggingEvent]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoggingEvent](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[EventDateTime] [datetime] NOT NULL,
	[EventType] [nvarchar](500) NOT NULL,
	[EventMessage] [nvarchar](max) NOT NULL,
	[UserId] [int] NULL,
	[ComputerName] [nvarchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAdvancePayment]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAdvancePayment](
	[RecId] [bigint] IDENTITY(1,1) NOT NULL,
	[RefId] [varchar](500) NULL,
	[Months] [date] NULL,
	[Amount] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAnnouncement]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAnnouncement](
	[AnnounceMessage] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblBankName]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblBankName](
	[RecId] [int] IDENTITY(1,1) NOT NULL,
	[BankName] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblClientMstr]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblClientMstr](
	[RecId] [bigint] IDENTITY(10000000,1) NOT NULL,
	[ClientID] [varchar](500) NULL,
	[ClientType] [varchar](250) NULL,
	[ClientName] [varchar](500) NULL,
	[Age] [int] NULL,
	[PostalAddress] [varchar](1000) NULL,
	[DateOfBirth] [date] NULL,
	[Gender] [bit] NULL,
	[TelNumber] [varchar](250) NULL,
	[Nationality] [varchar](250) NULL,
	[Occupation] [varchar](250) NULL,
	[AnnualIncome] [decimal](18, 2) NULL,
	[EmployerName] [varchar](250) NULL,
	[EmployerAddress] [varchar](250) NULL,
	[SpouseName] [varchar](250) NULL,
	[ChildrenNames] [varchar](500) NULL,
	[TotalPersons] [int] NULL,
	[MaidName] [varchar](250) NULL,
	[DriverName] [varchar](250) NULL,
	[VisitorsPerDay] [int] NULL,
	[IsTwoMonthAdvanceRental] [bit] NULL,
	[IsThreeMonthSecurityDeposit] [bit] NULL,
	[Is10PostDatedChecks] [bit] NULL,
	[IsPhotoCopyValidID] [bit] NULL,
	[Is2X2Picture] [bit] NULL,
	[BuildingSecretary] [int] NULL,
	[EncodedDate] [datetime] NULL,
	[EncodedBy] [int] NULL,
	[LastChangedBy] [int] NULL,
	[LastChangedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[ComputerName] [varchar](250) NULL,
	[IsMap] [bit] NULL,
	[TIN_No] [varchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCompany]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompany](
	[RecId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [varchar](200) NULL,
	[CompanyAddress] [varchar](500) NULL,
	[CompanyTIN] [varchar](20) NULL,
	[CompanyOwnerName] [varchar](100) NULL,
	[Status] [bit] NULL,
	[EncodedBy] [int] NULL,
	[EncodedDate] [datetime] NULL,
	[LastChangedBy] [int] NULL,
	[LastChangedDate] [datetime] NULL,
	[ComputerName] [varchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblFloorTypes]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblFloorTypes](
	[RecId] [int] IDENTITY(1,1) NOT NULL,
	[FloorTypesDescription] [varchar](100) NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblForm]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblForm](
	[FormId] [int] IDENTITY(1,1) NOT NULL,
	[MenuId] [int] NULL,
	[FormName] [varchar](200) NULL,
	[FormDescription] [varchar](200) NULL,
	[IsDelete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[FormId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblFormControlsMaster]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblFormControlsMaster](
	[ControlId] [int] IDENTITY(1,1) NOT NULL,
	[FormId] [int] NULL,
	[MenuId] [int] NULL,
	[ControlName] [varchar](200) NULL,
	[ControlDescription] [varchar](200) NULL,
	[IsBackRoundControl] [bit] NULL,
	[IsHeaderControl] [bit] NULL,
	[IsDelete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ControlId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblGroup]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblGroup](
	[GroupId] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [varchar](50) NULL,
	[IsDelete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblGroupFormControls]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblGroupFormControls](
	[GroupControlId] [int] IDENTITY(1,1) NOT NULL,
	[FormId] [int] NULL,
	[ControlId] [int] NULL,
	[GroupId] [int] NULL,
	[IsVisible] [bit] NULL,
	[IsDelete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[GroupControlId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblLocationMstr]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblLocationMstr](
	[RecId] [int] IDENTITY(1,1) NOT NULL,
	[Descriptions] [varchar](50) NULL,
	[LocAddress] [varchar](500) NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblMenu]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblMenu](
	[MenuId] [int] IDENTITY(1,1) NOT NULL,
	[MenuHeaderId] [int] NULL,
	[MenuName] [varchar](200) NULL,
	[MenuNameDescription] [varchar](200) NULL,
	[IsDelete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[MenuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblMonthLedger]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblMonthLedger](
	[Recid] [bigint] IDENTITY(1,1) NOT NULL,
	[ReferenceID] [bigint] NULL,
	[ClientID] [varchar](500) NULL,
	[LedgMonth] [date] NULL,
	[LedgAmount] [decimal](18, 2) NULL,
	[IsPaid] [bit] NULL,
	[EncodedBy] [int] NULL,
	[EncodedDate] [datetime] NULL,
	[ComputerName] [varchar](30) NULL,
	[TransactionID] [varchar](500) NULL,
	[IsHold] [bit] NULL,
	[BalanceAmount] [decimal](18, 2) NULL,
	[PenaltyAmount] [decimal](18, 2) NULL,
	[ActualAmount] [decimal](18, 2) NULL,
	[LedgRentalAmount] [decimal](18, 2) NULL,
	[Remarks] [varchar](500) NULL,
	[Unit_ProjectType] [varchar](150) NULL,
	[Unit_IsNonVat] [bit] NULL,
	[Unit_BaseRentalVatAmount] [decimal](18, 2) NULL,
	[Unit_BaseRentalWithVatAmount] [decimal](18, 2) NULL,
	[Unit_BaseRentalTax] [decimal](18, 2) NULL,
	[Unit_TotalRental] [decimal](18, 2) NULL,
	[Unit_SecAndMainAmount] [decimal](18, 2) NULL,
	[Unit_SecAndMainVatAmount] [decimal](18, 2) NULL,
	[Unit_SecAndMainWithVatAmount] [decimal](18, 2) NULL,
	[Unit_Vat] [decimal](18, 2) NULL,
	[Unit_Tax] [decimal](18, 2) NULL,
	[Unit_TaxAmount] [decimal](18, 2) NULL,
	[Unit_IsParking] [bit] NULL,
	[Unit_AreaTotalAmount] [decimal](18, 2) NULL,
	[Unit_AreaSqm] [decimal](18, 2) NULL,
	[Unit_AreaRateSqm] [decimal](18, 2) NULL,
	[IsRenewal] [bit] NULL,
	[CompanyORNo] [varchar](200) NULL,
	[REF] [varchar](200) NULL,
	[BNK_ACCT_NAME] [varchar](200) NULL,
	[BNK_ACCT_NUMBER] [varchar](200) NULL,
	[BNK_NAME] [varchar](200) NULL,
	[SERIAL_NO] [varchar](200) NULL,
	[ModeType] [varchar](20) NULL,
	[CompanyPRNo] [varchar](50) NULL,
	[BankBranch] [varchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPayment]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPayment](
	[RecId] [bigint] IDENTITY(10000000,1) NOT NULL,
	[PayID] [varchar](500) NULL,
	[TranId] [varchar](500) NULL,
	[Amount] [decimal](18, 2) NULL,
	[ForMonth] [date] NULL,
	[Remarks] [varchar](500) NULL,
	[EncodedBy] [int] NULL,
	[EncodedDate] [datetime] NULL,
	[LastChangedBy] [int] NULL,
	[LastChangedDate] [datetime] NULL,
	[ComputerName] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[RefId] [varchar](500) NULL,
	[Notes] [varchar](200) NULL,
	[LedgeRecid] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPaymentMode]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPaymentMode](
	[RecId] [int] IDENTITY(1,1) NOT NULL,
	[RcptID] [varchar](100) NULL,
	[CompanyORNo] [varchar](200) NULL,
	[REF] [varchar](200) NULL,
	[BNK_ACCT_NAME] [varchar](200) NULL,
	[BNK_ACCT_NUMBER] [varchar](200) NULL,
	[BNK_NAME] [varchar](200) NULL,
	[SERIAL_NO] [varchar](200) NULL,
	[ModeType] [varchar](20) NULL,
	[CompanyPRNo] [varchar](50) NULL,
	[BankBranch] [varchar](250) NULL,
	[ReceiptDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[RecId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPermission]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPermission](
	[PermissionId] [int] IDENTITY(1,1) NOT NULL,
	[GroupId] [int] NULL,
	[IsCLIENT] [bit] NULL,
	[IsAdd_New_CLient] [bit] NULL,
	[IsClient_Information] [bit] NULL,
	[IsCONTRACTS] [bit] NULL,
	[IsUnit_Contracts] [bit] NULL,
	[IsParking_Contracts] [bit] NULL,
	[IsDelete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[PermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProjectMstr]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProjectMstr](
	[RecId] [int] IDENTITY(1,1) NOT NULL,
	[LocId] [int] NULL,
	[ProjectName] [varchar](50) NULL,
	[Descriptions] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[ProjectAddress] [varchar](500) NULL,
	[ProjectType] [varchar](50) NULL,
	[CompanyId] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProjectType]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProjectType](
	[Recid] [int] IDENTITY(1,1) NOT NULL,
	[ProjectTypeName] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProjPurchItem]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProjPurchItem](
	[RecId] [bigint] IDENTITY(10000000,1) NOT NULL,
	[PurchItemID] [varchar](150) NULL,
	[ProjectId] [int] NULL,
	[Descriptions] [varchar](200) NULL,
	[DatePurchase] [datetime] NULL,
	[UnitAmount] [int] NULL,
	[Amount] [money] NULL,
	[Remarks] [varchar](200) NULL,
	[EncodedBy] [int] NULL,
	[EncodedDate] [datetime] NULL,
	[LastChangedBy] [int] NULL,
	[LastChangedDate] [datetime] NULL,
	[ComputerName] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[TotalAmount] [decimal](18, 2) NULL,
	[UnitNumber] [varchar](50) NULL,
	[UnitID] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblRatesSettings]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRatesSettings](
	[RecId] [int] IDENTITY(1,1) NOT NULL,
	[ProjectType] [varchar](50) NULL,
	[GenVat] [decimal](18, 2) NULL,
	[SecurityAndMaintenance] [decimal](18, 2) NULL,
	[SecurityAndMaintenanceVat] [int] NULL,
	[IsSecAndMaintVat] [bit] NULL,
	[WithHoldingTax] [decimal](18, 2) NULL,
	[EncodedBy] [int] NULL,
	[EncodedDate] [datetime] NULL,
	[LastChangedBy] [int] NULL,
	[LastChangedDate] [datetime] NULL,
	[ComputerName] [varchar](20) NULL,
	[PenaltyPct] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblReceipt]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblReceipt](
	[RecId] [bigint] IDENTITY(10000000,1) NOT NULL,
	[RcptID] [varchar](500) NULL,
	[TranId] [varchar](500) NULL,
	[Amount] [decimal](18, 2) NULL,
	[Description] [varchar](500) NULL,
	[Remarks] [varchar](500) NULL,
	[EncodedBy] [int] NULL,
	[EncodedDate] [datetime] NULL,
	[LastChangedBy] [int] NULL,
	[LastChangedDate] [datetime] NULL,
	[ComputerName] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[PaymentMethod] [varchar](20) NULL,
	[CompanyORNo] [varchar](150) NULL,
	[BankAccountName] [varchar](150) NULL,
	[BankAccountNumber] [varchar](150) NULL,
	[BankName] [varchar](150) NULL,
	[SerialNo] [varchar](150) NULL,
	[REF] [varchar](150) NULL,
	[CompanyPRNo] [varchar](150) NULL,
	[Category] [varchar](20) NULL,
	[BankBranch] [varchar](250) NULL,
	[RefId] [varchar](150) NULL,
	[ReceiptDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblRecieptReport]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRecieptReport](
	[client_no] [varchar](500) NULL,
	[client_Name] [varchar](500) NULL,
	[client_Address] [varchar](5000) NULL,
	[PR_No] [varchar](500) NULL,
	[OR_No] [varchar](500) NULL,
	[TIN_No] [varchar](500) NULL,
	[TransactionDate] [varchar](500) NULL,
	[AmountInWords] [varchar](5000) NULL,
	[PaymentFor] [varchar](500) NULL,
	[TotalAmountInDigit] [varchar](100) NULL,
	[RENTAL] [varchar](500) NULL,
	[VAT] [varchar](500) NULL,
	[VATPct] [varchar](500) NULL,
	[TOTAL] [varchar](500) NULL,
	[LESSWITHHOLDING] [varchar](500) NULL,
	[TOTALAMOUNTDUE] [varchar](500) NULL,
	[BANKNAME] [varchar](500) NULL,
	[PDCCHECKSERIALNO] [varchar](500) NULL,
	[USER] [varchar](500) NULL,
	[EncodedDate] [datetime] NULL,
	[TRANID] [varchar](500) NULL,
	[Mode] [varchar](500) NULL,
	[PaymentLevel] [varchar](100) NULL,
	[UnitNo] [varchar](150) NULL,
	[ProjectName] [varchar](150) NULL,
	[BankBranch] [varchar](150) NULL,
	[RENTAL_LESS_VAT] [varchar](150) NULL,
	[RENTAL_LESS_TAX] [varchar](150) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTransaction]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTransaction](
	[RecId] [bigint] IDENTITY(10000000,1) NOT NULL,
	[TranID] [varchar](500) NULL,
	[RefId] [varchar](500) NULL,
	[PaidAmount] [decimal](18, 2) NULL,
	[ReceiveAmount] [decimal](18, 2) NULL,
	[ChangeAmount] [decimal](18, 2) NULL,
	[Remarks] [varchar](500) NULL,
	[EncodedBy] [int] NULL,
	[EncodedDate] [datetime] NULL,
	[LastChangedBy] [int] NULL,
	[LastChangedDate] [datetime] NULL,
	[ComputerName] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[ActualAmountPaid] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUnitMstr]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUnitMstr](
	[RecId] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NULL,
	[UnitDescription] [varchar](300) NULL,
	[FloorNo] [int] NULL,
	[AreaSqm] [decimal](18, 2) NULL,
	[AreaRateSqm] [decimal](18, 2) NULL,
	[FloorType] [varchar](50) NULL,
	[BaseRental] [decimal](18, 2) NULL,
	[GenVat] [int] NULL,
	[SecurityAndMaintenance] [decimal](18, 2) NULL,
	[SecurityAndMaintenanceVat] [int] NULL,
	[UnitStatus] [varchar](50) NULL,
	[DetailsofProperty] [varchar](300) NULL,
	[UnitNo] [varchar](20) NULL,
	[UnitSequence] [int] NULL,
	[EndodedBy] [int] NULL,
	[EndodedDate] [datetime] NULL,
	[LastChangedBy] [int] NULL,
	[LastChangedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[ComputerName] [varchar](20) NULL,
	[clientID] [int] NULL,
	[Tennant] [varchar](200) NULL,
	[IsParking] [bit] NULL,
	[IsNonVat] [bit] NULL,
	[BaseRentalVatAmount] [decimal](18, 2) NULL,
	[BaseRentalWithVatAmount] [decimal](18, 2) NULL,
	[BaseRentalTax] [decimal](18, 2) NULL,
	[TotalRental] [decimal](18, 2) NULL,
	[SecAndMainAmount] [decimal](18, 2) NULL,
	[SecAndMainVatAmount] [decimal](18, 2) NULL,
	[SecAndMainWithVatAmount] [decimal](18, 2) NULL,
	[Vat] [decimal](18, 2) NULL,
	[Tax] [decimal](18, 2) NULL,
	[TaxAmount] [decimal](18, 2) NULL,
	[AreaTotalAmount] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUnitReference]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUnitReference](
	[RecId] [bigint] IDENTITY(10000000,1) NOT NULL,
	[RefId] [varchar](150) NULL,
	[ProjectId] [int] NULL,
	[InquiringClient] [varchar](500) NULL,
	[ClientMobile] [varchar](50) NULL,
	[UnitId] [int] NULL,
	[UnitNo] [varchar](50) NULL,
	[StatDate] [date] NULL,
	[FinishDate] [date] NULL,
	[TransactionDate] [date] NULL,
	[Rental] [decimal](18, 2) NULL,
	[SecAndMaintenance] [decimal](18, 2) NULL,
	[TotalRent] [decimal](18, 2) NULL,
	[SecDeposit] [decimal](18, 2) NULL,
	[Total] [decimal](18, 2) NULL,
	[EncodedBy] [int] NULL,
	[EncodedDate] [datetime] NULL,
	[LastCHangedBy] [int] NULL,
	[LastChangedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[ComputerName] [varchar](30) NULL,
	[ClientID] [varchar](50) NULL,
	[IsPaid] [bit] NULL,
	[IsDone] [bit] NULL,
	[HeaderRefId] [varchar](50) NULL,
	[IsSignedContract] [bit] NULL,
	[IsUnitMove] [bit] NULL,
	[IsTerminated] [bit] NULL,
	[GenVat] [decimal](18, 2) NULL,
	[WithHoldingTax] [decimal](18, 2) NULL,
	[IsUnitMoveOut] [bit] NULL,
	[FirstPaymentDate] [datetime] NULL,
	[ContactDoneDate] [datetime] NULL,
	[SignedContractDate] [datetime] NULL,
	[UnitMoveInDate] [datetime] NULL,
	[UnitMoveOutDate] [datetime] NULL,
	[TerminationDate] [datetime] NULL,
	[AdvancePaymentAmount] [decimal](18, 2) NULL,
	[IsFullPayment] [bit] NULL,
	[PenaltyPct] [decimal](18, 2) NULL,
	[IsPartialPayment] [bit] NULL,
	[FirtsPaymentBalanceAmount] [decimal](18, 2) NULL,
	[Unit_IsNonVat] [bit] NULL,
	[Unit_BaseRentalVatAmount] [decimal](18, 2) NULL,
	[Unit_BaseRentalWithVatAmount] [decimal](18, 2) NULL,
	[Unit_BaseRentalTax] [decimal](18, 2) NULL,
	[Unit_TotalRental] [decimal](18, 2) NULL,
	[Unit_SecAndMainAmount] [decimal](18, 2) NULL,
	[Unit_SecAndMainVatAmount] [decimal](18, 2) NULL,
	[Unit_SecAndMainWithVatAmount] [decimal](18, 2) NULL,
	[Unit_Vat] [decimal](18, 2) NULL,
	[Unit_Tax] [decimal](18, 2) NULL,
	[Unit_TaxAmount] [decimal](18, 2) NULL,
	[Unit_IsParking] [bit] NULL,
	[Unit_ProjectType] [varchar](150) NULL,
	[Unit_AreaTotalAmount] [decimal](18, 2) NULL,
	[Unit_AreaSqm] [decimal](18, 2) NULL,
	[Unit_AreaRateSqm] [decimal](18, 2) NULL,
	[IsRenewal] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUser]    Script Date: 7/3/2024 10:57:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUser](
	[UserId] [int] IDENTITY(100000,1) NOT NULL,
	[GroupId] [int] NULL,
	[UserName] [varchar](100) NULL,
	[UserPassword] [nvarchar](max) NULL,
	[UserPasswordIncrypt] [varchar](200) NULL,
	[StaffName] [varchar](200) NULL,
	[Middlename] [varchar](50) NULL,
	[Lastname] [varchar](50) NULL,
	[EmailAddress] [varchar](100) NULL,
	[Phone] [varchar](20) NULL,
	[IsDelete] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ErrorLog] ADD  DEFAULT (getdate()) FOR [LogDateTime]
GO
ALTER TABLE [dbo].[LoggingEvent] ADD  DEFAULT (getdate()) FOR [EventDateTime]
GO
