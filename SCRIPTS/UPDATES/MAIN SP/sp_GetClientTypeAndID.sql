USE [LEASINGDB];
GO
/****** Object:  StoredProcedure [dbo].[sp_GetClientTypeAndID]    Script Date: 11/9/2023 9:57:21 PM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_GetClientTypeAndID] @ClientID VARCHAR(50) = NULL
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT
            ISNULL([tblClientMstr].[ClientID], '')                                           AS [ClientID],
            IIF(ISNULL([tblClientMstr].[ClientType], '') = 'INV', 'INDIVIDUAL', 'CORPORATE') AS [ClientType]
        FROM
            [dbo].[tblClientMstr] WITH (NOLOCK)
        WHERE
            [ClientID] = @ClientID;

    END;
