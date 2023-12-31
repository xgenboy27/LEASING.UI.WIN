USE [LEASINGDB]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUserPassword]    Script Date: 1/5/2024 7:50:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_GetUserPassword] @UserId VARCHAR(20) = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT
            [tblUser].[UserId],
            [tblUser].[GroupId],
            [tblUser].[UserName],
            [tblUser].[UserPassword],
            [tblUser].[UserPasswordIncrypt],
            UPPER([tblUser].[StaffName]) AS [StaffName],
            [tblUser].[Middlename],
            [tblUser].[Lastname],
            [tblUser].[EmailAddress],
            [tblUser].[Phone],
            ISNULL([tblUser].[IsDelete], 0) AS [UserStatus]
        FROM
            [dbo].[tblUser]
        WHERE
            [tblUser].[UserName] = @UserId;
    END;
