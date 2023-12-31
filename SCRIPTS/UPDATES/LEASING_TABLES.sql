USE [LEASINGDB]
GO
/****** Object:  Table [dbo].[Files]    Script Date: 11/7/2023 5:13:28 AM ******/
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
	[Files] [varchar](200) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblClientMstr]    Script Date: 11/7/2023 5:13:28 AM ******/
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
	[IsMap] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblFloorTypes]    Script Date: 11/7/2023 5:13:28 AM ******/
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
/****** Object:  Table [dbo].[tblLocationMstr]    Script Date: 11/7/2023 5:13:28 AM ******/
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
/****** Object:  Table [dbo].[tblMonthLedger]    Script Date: 11/7/2023 5:13:28 AM ******/
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
/****** Object:  Table [dbo].[tblPayment]    Script Date: 11/7/2023 5:13:28 AM ******/
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
/****** Object:  Table [dbo].[tblProjectMstr]    Script Date: 11/7/2023 5:13:28 AM ******/
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
/****** Object:  Table [dbo].[tblProjectType]    Script Date: 11/7/2023 5:13:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProjectType](
	[Recid] [int] IDENTITY(1,1) NOT NULL,
	[ProjectTypeName] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProjPurchItem]    Script Date: 11/7/2023 5:13:28 AM ******/
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
/****** Object:  Table [dbo].[tblRatesSettings]    Script Date: 11/7/2023 5:13:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRatesSettings](
	[RecId] [int] IDENTITY(1,1) NOT NULL,
	[ProjectType] [varchar](50) NULL,
	[GenVat] [int] NULL,
	[SecurityAndMaintenance] [decimal](18, 2) NULL,
	[SecurityAndMaintenanceVat] [int] NULL,
	[IsSecAndMaintVat] [bit] NULL,
	[WithHoldingTax] [int] NULL,
	[EncodedBy] [int] NULL,
	[EncodedDate] [datetime] NULL,
	[LastChangedBy] [int] NULL,
	[LastChangedDate] [datetime] NULL,
	[ComputerName] [varchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblReceipt]    Script Date: 11/7/2023 5:13:28 AM ******/
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
	[SerialNo] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTransaction]    Script Date: 11/7/2023 5:13:28 AM ******/
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
/****** Object:  Table [dbo].[tblUnitMstr]    Script Date: 11/7/2023 5:13:28 AM ******/
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
/****** Object:  Table [dbo].[tblUnitReference]    Script Date: 11/7/2023 5:13:28 AM ******/
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
	[Advancemonths1] [decimal](18, 2) NULL,
	[Advancemonths2] [decimal](18, 2) NULL,
	[SecDeposit] [decimal](18, 2) NULL,
	[Total] [decimal](18, 2) NULL,
	[EncodedBy] [int] NULL,
	[EncodedDate] [datetime] NULL,
	[LastCHangedBy] [int] NULL,
	[LastChangedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[ComputerName] [varchar](30) NULL,
	[ClientID] [varchar](50) NULL,
	[Applicabledate1] [date] NULL,
	[Applicabledate2] [date] NULL,
	[IsPaid] [bit] NULL,
	[IsDone] [bit] NULL
) ON [PRIMARY]
GO
