USE [LEASINGDB]
GO
/****** Object:  Table [dbo].[demoTable]    Script Date: 1/8/2024 3:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[demoTable](
	[ID] [int] IDENTITY(1000,1) NOT NULL,
	[GeneratedString]  AS (('CORP'+CONVERT([varchar](10),[ID]))+right('0000'+CONVERT([varchar](10),abs(checksum(newid()))%(10000)),(4))),
	[names] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ErrorLog]    Script Date: 1/8/2024 3:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[ProcedureName] [nvarchar](255) NOT NULL,
	[ErrorMessage] [nvarchar](max) NOT NULL,
	[LogDateTime] [datetime] NOT NULL,
	[frmName] [varchar](200) NULL,
	[FormName] [varchar](200) NULL,
	[Category] [varchar](10) NULL,
	[UserId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Files]    Script Date: 1/8/2024 3:22:24 PM ******/
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
/****** Object:  Table [dbo].[LoggingEvent]    Script Date: 1/8/2024 3:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoggingEvent](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[EventDateTime] [datetime] NOT NULL,
	[EventType] [nvarchar](50) NOT NULL,
	[EventMessage] [nvarchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sample_table]    Script Date: 1/8/2024 3:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sample_table](
	[Month] [date] NULL,
	[data] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAdvancePayment]    Script Date: 1/8/2024 3:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAdvancePayment](
	[RecId] [int] IDENTITY(1,1) NOT NULL,
	[RefId] [varchar](20) NULL,
	[Months] [date] NULL,
	[Amount] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblBankName]    Script Date: 1/8/2024 3:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblBankName](
	[RecId] [int] IDENTITY(1,1) NOT NULL,
	[BankName] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblClientMstr]    Script Date: 1/8/2024 3:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblClientMstr](
	[RecId] [int] IDENTITY(10000000,1) NOT NULL,
	[ClientID]  AS ([ClientType]+CONVERT([varchar](10),[RecId])),
	[ClientType] [varchar](50) NULL,
	[ClientName] [varchar](100) NULL,
	[Age] [int] NULL,
	[PostalAddress] [varchar](1000) NULL,
	[DateOfBirth] [date] NULL,
	[Gender] [bit] NULL,
	[TelNumber] [varchar](20) NULL,
	[Nationality] [varchar](50) NULL,
	[Occupation] [varchar](100) NULL,
	[AnnualIncome] [decimal](18, 2) NULL,
	[EmployerName] [varchar](100) NULL,
	[EmployerAddress] [varchar](200) NULL,
	[SpouseName] [varchar](100) NULL,
	[ChildrenNames] [varchar](500) NULL,
	[TotalPersons] [int] NULL,
	[MaidName] [varchar](100) NULL,
	[DriverName] [varchar](100) NULL,
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
	[ComputerName] [varchar](50) NULL,
	[IsMap] [bit] NULL,
	[TIN_No] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblFloorTypes]    Script Date: 1/8/2024 3:22:24 PM ******/
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
/****** Object:  Table [dbo].[tblForm]    Script Date: 1/8/2024 3:22:24 PM ******/
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
/****** Object:  Table [dbo].[tblFormControlsMaster]    Script Date: 1/8/2024 3:22:24 PM ******/
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
/****** Object:  Table [dbo].[tblGroup]    Script Date: 1/8/2024 3:22:24 PM ******/
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
/****** Object:  Table [dbo].[tblGroupFormControls]    Script Date: 1/8/2024 3:22:24 PM ******/
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
/****** Object:  Table [dbo].[tblLocationMstr]    Script Date: 1/8/2024 3:22:24 PM ******/
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
/****** Object:  Table [dbo].[tblMenu]    Script Date: 1/8/2024 3:22:24 PM ******/
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
/****** Object:  Table [dbo].[tblMonthLedger]    Script Date: 1/8/2024 3:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblMonthLedger](
	[Recid] [int] IDENTITY(1,1) NOT NULL,
	[ReferenceID] [int] NULL,
	[ClientID] [varchar](50) NULL,
	[LedgMonth] [date] NULL,
	[LedgAmount] [decimal](18, 2) NULL,
	[IsPaid] [bit] NULL,
	[EncodedBy] [int] NULL,
	[EncodedDate] [datetime] NULL,
	[ComputerName] [varchar](30) NULL,
	[TransactionID] [varchar](50) NULL,
	[IsHold] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPayment]    Script Date: 1/8/2024 3:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPayment](
	[RecId] [int] IDENTITY(10000000,1) NOT NULL,
	[PayID]  AS ('PAY'+CONVERT([varchar](10),[RecId])),
	[TranId] [varchar](50) NULL,
	[Amount] [decimal](18, 2) NULL,
	[ForMonth] [date] NULL,
	[Remarks] [varchar](500) NULL,
	[EncodedBy] [int] NULL,
	[EncodedDate] [datetime] NULL,
	[LastChangedBy] [int] NULL,
	[LastChangedDate] [datetime] NULL,
	[ComputerName] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[RefId] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPaymentMode]    Script Date: 1/8/2024 3:22:24 PM ******/
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
PRIMARY KEY CLUSTERED 
(
	[RecId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPermission]    Script Date: 1/8/2024 3:22:24 PM ******/
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
/****** Object:  Table [dbo].[tblProjectMstr]    Script Date: 1/8/2024 3:22:24 PM ******/
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
	[ProjectType] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProjectType]    Script Date: 1/8/2024 3:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProjectType](
	[Recid] [int] IDENTITY(1,1) NOT NULL,
	[ProjectTypeName] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProjPurchItem]    Script Date: 1/8/2024 3:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProjPurchItem](
	[RecId] [int] IDENTITY(10000000,1) NOT NULL,
	[PurchItemID]  AS ('PURCH'+CONVERT([varchar](10),[RecId])),
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
/****** Object:  Table [dbo].[tblRatesSettings]    Script Date: 1/8/2024 3:22:24 PM ******/
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
/****** Object:  Table [dbo].[tblReceipt]    Script Date: 1/8/2024 3:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblReceipt](
	[RecId] [int] IDENTITY(10000000,1) NOT NULL,
	[RcptID]  AS ('RCPT'+CONVERT([varchar](10),[RecId])),
	[TranId] [varchar](50) NULL,
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
	[CompanyORNo] [varchar](50) NULL,
	[BankAccountName] [varchar](50) NULL,
	[BankAccountNumber] [varchar](50) NULL,
	[BankName] [varchar](50) NULL,
	[SerialNo] [varchar](50) NULL,
	[REF] [varchar](50) NULL,
	[CompanyPRNo] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTransaction]    Script Date: 1/8/2024 3:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTransaction](
	[RecId] [int] IDENTITY(10000000,1) NOT NULL,
	[TranID]  AS ('TRAN'+CONVERT([varchar](10),[RecId])),
	[RefId] [varchar](50) NULL,
	[PaidAmount] [decimal](18, 2) NULL,
	[ReceiveAmount] [decimal](18, 2) NULL,
	[ChangeAmount] [decimal](18, 2) NULL,
	[Remarks] [varchar](500) NULL,
	[EncodedBy] [int] NULL,
	[EncodedDate] [datetime] NULL,
	[LastChangedBy] [int] NULL,
	[LastChangedDate] [datetime] NULL,
	[ComputerName] [varchar](50) NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUnitMstr]    Script Date: 1/8/2024 3:22:24 PM ******/
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
	[IsParking] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUnitReference]    Script Date: 1/8/2024 3:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUnitReference](
	[RecId] [int] IDENTITY(10000000,1) NOT NULL,
	[RefId]  AS ('REF'+CONVERT([varchar](max),[RecId])),
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
	[PenaltyPct] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUser]    Script Date: 1/8/2024 3:22:24 PM ******/
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
