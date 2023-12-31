USE [LEASINGDB]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetUserCompleteName]    Script Date: 1/8/2024 3:23:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_GetUserCompleteName]
    (
        -- Add the parameters for the function here
        @UserId INT
    )
RETURNS VARCHAR(100)
AS
    BEGIN
        -- Declare the return variable here
        DECLARE @UserName VARCHAR(100);

        -- Add the T-SQL statements to compute the return value here
        SELECT
            @UserName = [tblUser].[StaffName] + ' ' + [tblUser].[Middlename] + ' ' + [tblUser].[Lastname]
        FROM
            [dbo].[tblUser]
        WHERE
            [tblUser].[UserId] = @UserId;

        -- Return the result of the function
        RETURN @UserName;

    END;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetUserGroupName]    Script Date: 1/8/2024 3:23:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_GetUserGroupName]
    (
        -- Add the parameters for the function here
        @UserId INT
    )
RETURNS VARCHAR(100)
AS
    BEGIN
        -- Declare the return variable here
        DECLARE @GroupName VARCHAR(100);

        -- Add the T-SQL statements to compute the return value here
        SELECT
                @GroupName = [tblGroup].[GroupName]
        FROM
                [dbo].[tblUser] WITH (NOLOCK)
            INNER JOIN
                [dbo].[tblGroup] WITH (NOLOCK)
                    ON [tblUser].[GroupId] = [tblGroup].[GroupId]
        WHERE
                [tblUser].[UserId] = @UserId;

        -- Return the result of the function
        RETURN @GroupName;

    END;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetUserName]    Script Date: 1/8/2024 3:23:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_GetUserName]
    (
        -- Add the parameters for the function here
        @UserId INT
    )
RETURNS VARCHAR(100)
AS
    BEGIN
        -- Declare the return variable here
        DECLARE @UserName VARCHAR(100);

        -- Add the T-SQL statements to compute the return value here
        SELECT
            @UserName = [tblUser].[StaffName]
        FROM
            [dbo].[tblUser]
        WHERE
            [tblUser].[UserId] = @UserId;

        -- Return the result of the function
        RETURN @UserName;

    END;
GO
/****** Object:  UserDefinedFunction [dbo].[fnNumberToWords]    Script Date: 1/8/2024 3:23:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnNumberToWords](@Number DECIMAL(17,2))
RETURNS NVARCHAR(MAX)
AS 
BEGIN
	SET @Number = ABS(@Number)
	DECLARE @vResult NVARCHAR(MAX) = ''

	-- pre-data
	DECLARE @tDict		TABLE (Num INT NOT NULL, Nam NVARCHAR(255) NOT NULL)
	INSERT 
	INTO	@tDict (Num, Nam)
	VALUES	(1,'one'),(2,'two'),(3,'three'),(4,'four'),(5,'five'),(6,'six'),(7,'seven'),(8,'eight'),(9,'nine'),
			(10,'ten'),(11,'eleven'),(12,'twelve'),(13,'thirteen'),(14,'fourteen'),(15,'fifteen'),(16,'sixteen'),(17,'seventeen'),(18,'eighteen'),(19,'nineteen'),
			(20,'twenty'),(30,'thirty'),(40,'fourty'),(50,'fifty'),(60,'sixty'),(70,'seventy'),(80,'eighty'),(90,'ninety')
	
	DECLARE @ZeroWord		NVARCHAR(10) = 'zero'
	DECLARE @DotWord		NVARCHAR(10) = 'point'
	DECLARE @AndWord		NVARCHAR(10) = 'and'
	DECLARE @HundredWord	NVARCHAR(10) = 'hundred'
	DECLARE @ThousandWord	NVARCHAR(10) = 'thousand'
	DECLARE @MillionWord	NVARCHAR(10) = 'million'
	DECLARE @BillionWord	NVARCHAR(10) = 'billion'
	DECLARE @TrillionWord	NVARCHAR(10) = 'trillion'

	-- decimal number	
	DECLARE @vDecimalNum INT = (@Number - FLOOR(@Number)) * 100
	DECLARE @vLoop SMALLINT = CONVERT(SMALLINT, SQL_VARIANT_PROPERTY(@Number, 'Scale'))
	DECLARE @vSubDecimalResult	NVARCHAR(MAX) = N''
	IF @vDecimalNum > 0
	BEGIN
		WHILE @vLoop > 0
		BEGIN
			IF @vDecimalNum % 10 = 0
				SET @vSubDecimalResult = FORMATMESSAGE('%s %s', @ZeroWord, @vSubDecimalResult)
			ELSE
				SELECT	@vSubDecimalResult = FORMATMESSAGE('%s %s', Nam, @vSubDecimalResult)
				FROM	@tDict
				WHERE	Num = @vDecimalNum%10

			SET @vDecimalNum = FLOOR(@vDecimalNum/10)
			SET @vLoop = @vLoop - 1
		END
	END
	
	-- main number
	SET @Number = FLOOR(@Number)
	IF @Number = 0
		SET @vResult = @ZeroWord
	ELSE
	BEGIN
		DECLARE @vSubResult	NVARCHAR(MAX) = ''
		DECLARE @v000Num DECIMAL(15,0) = 0
		DECLARE @v00Num DECIMAL(15,0) = 0
		DECLARE @v0Num DECIMAL(15,0) = 0
		DECLARE @vIndex SMALLINT = 0
		
		WHILE @Number > 0
		BEGIN
			-- from right to left: take first 000
			SET @v000Num = @Number % 1000
			SET @v00Num = @v000Num % 100
			SET @v0Num = @v00Num % 10
			IF @v000Num = 0
			BEGIN
				SET @vSubResult = ''
			END
			ELSE 
			BEGIN 
				--00
				IF @v00Num < 20
				BEGIN
					-- less than 20
					SELECT @vSubResult = Nam FROM @tDict WHERE Num = @v00Num
					IF @v00Num < 10 AND @v00Num > 0 AND (@v000Num > 99 OR FLOOR(@Number / 1000) > 0)--e.g 1 001: 1000 AND 1; or 201 000: (200 AND 1) 000
						SET @vSubResult = FORMATMESSAGE('%s %s', @AndWord, @vSubResult)
				END
				ELSE 
				BEGIN
					-- greater than or equal 20
					SELECT @vSubResult = Nam FROM @tDict WHERE Num = @v0Num 
					SET @v00Num = FLOOR(@v00Num/10)*10
					SELECT @vSubResult = FORMATMESSAGE('%s-%s', Nam, @vSubResult) FROM @tDict WHERE Num = @v00Num 
				END

				--000
				IF @v000Num > 99
					SELECT @vSubResult = FORMATMESSAGE('%s %s %s', Nam, @HundredWord, @vSubResult) FROM @tDict WHERE Num = CONVERT(INT,@v000Num / 100)
			END
			
			--000xxx
			IF @vSubResult <> ''
			BEGIN

				SET @vSubResult = FORMATMESSAGE('%s %s', @vSubResult, CASE 
																		WHEN @vIndex=1 THEN @ThousandWord
																		WHEN @vIndex=2 THEN @MillionWord
																		WHEN @vIndex=3 THEN @BillionWord
																		WHEN @vIndex=4 THEN @TrillionWord
																		WHEN @vIndex>3 AND @vIndex%3=2 THEN @MillionWord + ' ' + LTRIM(REPLICATE(@BillionWord + ' ',@vIndex%3))
																		WHEN @vIndex>3 AND @vIndex%3=0 THEN LTRIM(REPLICATE(@BillionWord + ' ',@vIndex%3))
																		ELSE ''
																	END)

				SET @vResult = FORMATMESSAGE('%s %s', @vSubResult, @vResult)
			END

			-- next 000 (to left)
			SET @vIndex = @vIndex + 1
			SET @Number = FLOOR(@Number / 1000)
		END
	END

	SET @vResult = FORMATMESSAGE('%s %s', LTRIM(@vResult), COALESCE(@DotWord + ' ' + NULLIF(@vSubDecimalResult,''), ''))
	
	-- result
    RETURN @vResult
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnNumberToWordsWithDecimal]    Script Date: 1/8/2024 3:23:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnNumberToWordsWithDecimal](@Number AS DECIMAL(18,2))
    RETURNS VARCHAR(2048)
AS
BEGIN
    DECLARE @Below20 TABLE (ID INT IDENTITY(0,1), Word VARCHAR(32))
    DECLARE @Below100 TABLE (ID INT IDENTITY(2,1), Word VARCHAR(32))

    INSERT @Below20 (Word) VALUES
        ('Zero'), ('One'), ('Two'), ('Three'),
        ('Four'), ('Five'), ('Six'), ('Seven'),
        ('Eight'), ('Nine'), ('Ten'), ('Eleven'),
        ('Twelve'), ('Thirteen'), ('Fourteen'),
        ('Fifteen'), ('Sixteen'), ('Seventeen'),
        ('Eighteen'), ('Nineteen')

    INSERT @Below100 VALUES ('Twenty'), ('Thirty'), ('Forty'), ('Fifty'),
                            ('Sixty'), ('Seventy'), ('Eighty'), ('Ninety')

    DECLARE @English VARCHAR(2048) = ''

    IF @Number = 0
        RETURN 'Zero'

    DECLARE @IntegerPart INT = CONVERT(INT, FLOOR(@Number))
    DECLARE @DecimalPart INT = CONVERT(INT, (@Number - @IntegerPart) * 100)

    IF @IntegerPart > 0
    BEGIN
        IF @IntegerPart BETWEEN 1 AND 19
            SET @English = (SELECT Word FROM @Below20 WHERE ID = @IntegerPart)
        ELSE IF @IntegerPart BETWEEN 20 AND 99
            SET @English = (SELECT Word FROM @Below100 WHERE ID = @IntegerPart / 10) + '-' + dbo.fnNumberToWords(@IntegerPart % 10)
        ELSE
            SET @English = dbo.fnNumberToWords(@IntegerPart)
    END

    IF @DecimalPart > 0
    BEGIN
        SET @English = @English + ' Point '
                      + (CASE
                            WHEN @DecimalPart BETWEEN 1 AND 19
                                THEN (SELECT Word FROM @Below20 WHERE ID = @DecimalPart)
                            WHEN @DecimalPart BETWEEN 20 AND 99
                                THEN (SELECT Word FROM @Below100 WHERE ID = @DecimalPart / 10) + '-' + dbo.fnNumberToWords(@DecimalPart % 10)
                            ELSE dbo.fnNumberToWords(@DecimalPart)
                        END)
    END

    RETURN @English
END
GO
/****** Object:  UserDefinedFunction [dbo].[NumberToWords]    Script Date: 1/8/2024 3:23:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[NumberToWords](@Number DECIMAL(17,2))
RETURNS NVARCHAR(MAX)
AS 
BEGIN
	SET @Number = ABS(@Number)
	DECLARE @vResult NVARCHAR(MAX) = ''

	-- pre-data
	DECLARE @tDict		TABLE (Num INT NOT NULL, Nam NVARCHAR(255) NOT NULL)
	INSERT 
	INTO	@tDict (Num, Nam)
	VALUES	(1,'one'),(2,'two'),(3,'three'),(4,'four'),(5,'five'),(6,'six'),(7,'seven'),(8,'eight'),(9,'nine'),
			(10,'ten'),(11,'eleven'),(12,'twelve'),(13,'thirteen'),(14,'fourteen'),(15,'fifteen'),(16,'sixteen'),(17,'seventeen'),(18,'eighteen'),(19,'nineteen'),
			(20,'twenty'),(30,'thirty'),(40,'fourty'),(50,'fifty'),(60,'sixty'),(70,'seventy'),(80,'eighty'),(90,'ninety')
	
	DECLARE @ZeroWord		NVARCHAR(10) = 'zero'
	DECLARE @DotWord		NVARCHAR(10) = 'point'
	DECLARE @AndWord		NVARCHAR(10) = 'and'
	DECLARE @HundredWord	NVARCHAR(10) = 'hundred'
	DECLARE @ThousandWord	NVARCHAR(10) = 'thousand'
	DECLARE @MillionWord	NVARCHAR(10) = 'million'
	DECLARE @BillionWord	NVARCHAR(10) = 'billion'
	DECLARE @TrillionWord	NVARCHAR(10) = 'trillion'

	-- decimal number	
	DECLARE @vDecimalNum INT = (@Number - FLOOR(@Number)) * 100
	DECLARE @vLoop SMALLINT = CONVERT(SMALLINT, SQL_VARIANT_PROPERTY(@Number, 'Scale'))
	DECLARE @vSubDecimalResult	NVARCHAR(MAX) = N''
	IF @vDecimalNum > 0
	BEGIN
		WHILE @vLoop > 0
		BEGIN
			IF @vDecimalNum % 10 = 0
				SET @vSubDecimalResult = FORMATMESSAGE('%s %s', @ZeroWord, @vSubDecimalResult)
			ELSE
				SELECT	@vSubDecimalResult = FORMATMESSAGE('%s %s', Nam, @vSubDecimalResult)
				FROM	@tDict
				WHERE	Num = @vDecimalNum%10

			SET @vDecimalNum = FLOOR(@vDecimalNum/10)
			SET @vLoop = @vLoop - 1
		END
	END
	
	-- main number
	SET @Number = FLOOR(@Number)
	IF @Number = 0
		SET @vResult = @ZeroWord
	ELSE
	BEGIN
		DECLARE @vSubResult	NVARCHAR(MAX) = ''
		DECLARE @v000Num DECIMAL(15,0) = 0
		DECLARE @v00Num DECIMAL(15,0) = 0
		DECLARE @v0Num DECIMAL(15,0) = 0
		DECLARE @vIndex SMALLINT = 0
		
		WHILE @Number > 0
		BEGIN
			-- from right to left: take first 000
			SET @v000Num = @Number % 1000
			SET @v00Num = @v000Num % 100
			SET @v0Num = @v00Num % 10
			IF @v000Num = 0
			BEGIN
				SET @vSubResult = ''
			END
			ELSE 
			BEGIN 
				--00
				IF @v00Num < 20
				BEGIN
					-- less than 20
					SELECT @vSubResult = Nam FROM @tDict WHERE Num = @v00Num
					IF @v00Num < 10 AND @v00Num > 0 AND (@v000Num > 99 OR FLOOR(@Number / 1000) > 0)--e.g 1 001: 1000 AND 1; or 201 000: (200 AND 1) 000
						SET @vSubResult = FORMATMESSAGE('%s %s', @AndWord, @vSubResult)
				END
				ELSE 
				BEGIN
					-- greater than or equal 20
					SELECT @vSubResult = Nam FROM @tDict WHERE Num = @v0Num 
					SET @v00Num = FLOOR(@v00Num/10)*10
					SELECT @vSubResult = FORMATMESSAGE('%s-%s', Nam, @vSubResult) FROM @tDict WHERE Num = @v00Num 
				END

				--000
				IF @v000Num > 99
					SELECT @vSubResult = FORMATMESSAGE('%s %s %s', Nam, @HundredWord, @vSubResult) FROM @tDict WHERE Num = CONVERT(INT,@v000Num / 100)
			END
			
			--000xxx
			IF @vSubResult <> ''
			BEGIN

				SET @vSubResult = FORMATMESSAGE('%s %s', @vSubResult, CASE 
																		WHEN @vIndex=1 THEN @ThousandWord
																		WHEN @vIndex=2 THEN @MillionWord
																		WHEN @vIndex=3 THEN @BillionWord
																		WHEN @vIndex=4 THEN @TrillionWord
																		WHEN @vIndex>3 AND @vIndex%3=2 THEN @MillionWord + ' ' + LTRIM(REPLICATE(@BillionWord + ' ',@vIndex%3))
																		WHEN @vIndex>3 AND @vIndex%3=0 THEN LTRIM(REPLICATE(@BillionWord + ' ',@vIndex%3))
																		ELSE ''
																	END)

				SET @vResult = FORMATMESSAGE('%s %s', @vSubResult, @vResult)
			END

			-- next 000 (to left)
			SET @vIndex = @vIndex + 1
			SET @Number = FLOOR(@Number / 1000)
		END
	END

	SET @vResult = FORMATMESSAGE('%s %s', LTRIM(@vResult), COALESCE(@DotWord + ' ' + NULLIF(@vSubDecimalResult,''), ''))
	
	-- result
    RETURN @vResult
END
GO
