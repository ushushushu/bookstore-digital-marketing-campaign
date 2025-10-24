/*
-- Drop the function INITCAP() if it already exists
IF OBJECT_ID('silver.INITCAP', 'FN') IS NOT NULL
    DROP FUNCTION silver.INITCAP;
GO
-- Create the function INITCAP() which capitalizes the first letter of each word
CREATE FUNCTION silver.INITCAP(@input NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF @input IS NULL
        RETURN NULL;
    
    DECLARE @result NVARCHAR(MAX) = '';
    DECLARE @i INT = 1;
    DECLARE @len INT = LEN(@input);
    DECLARE @char NCHAR(1);
    DECLARE @prevChar NCHAR(1) = ' ';
    DECLARE @shouldCapitalize BIT = 1;
    
    -- Preserve leading/trailing spaces by using DATALENGTH instead of LEN
    SET @len = DATALENGTH(@input) / 2; -- Divide by 2 for NVARCHAR
    
    WHILE @i <= @len
    BEGIN
        SET @char = SUBSTRING(@input, @i, 1);
        
        -- Check if previous character was a space or special character
        IF @shouldCapitalize = 1 AND @char LIKE '[a-zA-Z]'
        BEGIN
            SET @result = @result + UPPER(@char);
            SET @shouldCapitalize = 0;
        END
        ELSE
        BEGIN
            SET @result = @result + LOWER(@char);
        END
        
        -- Determine if next character should be capitalized
        -- Capital after: space, punctuation, or any non-alphanumeric
        IF @char LIKE '[^a-zA-Z0-9]' OR @char = ' '
            SET @shouldCapitalize = 1;
        ELSE
            SET @shouldCapitalize = 0;
        
        SET @i = @i + 1;
    END
    
    RETURN @result;
END;
GO

-- Drop the function SPLIT_PART() if it already exists
IF OBJECT_ID('silver.SPLIT_PART', 'FN') IS NOT NULL
    DROP FUNCTION silver.SPLIT_PART;
GO
-- Create the function SPLIT_PART() splits the string into separate words based on a delimiter & extracts a specific word based on the word position
CREATE FUNCTION silver.SPLIT_PART (
    @input NVARCHAR(MAX),
    @delimiter CHAR(1),
    @position INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @start INT = 1;
    DECLARE @end INT;
    DECLARE @i INT = 1;
    DECLARE @result NVARCHAR(MAX) = '';

    WHILE @i < @position
    BEGIN
        SET @start = CHARINDEX(@delimiter, @input, @start) + 1;
        IF @start = 0 
        BEGIN
            RETURN ''; -- Position exceeds number of parts
        END
        SET @i = @i + 1;
    END

    SET @end = CHARINDEX(@delimiter, @input, @start);
    IF @end = 0 
    BEGIN
        SET @end = LEN(@input) + 1; -- Last word or no trailing delimiter
    END

    SET @result = SUBSTRING(@input, @start, @end - @start);
    RETURN @result;
END;
GO

-- Drop if the function EXTRACT_BASE_NUMBER() exists
IF OBJECT_ID('silver.EXTRACT_BASE_NUMBER', 'FN') IS NOT NULL
    DROP FUNCTION silver.EXTRACT_BASE_NUMBER;
GO
-- Create the function EXTRACT_BASE_NUMBER(), which the base numbers in a string
-- e.g. 1000 will get extracted from 'CUST00001000'
CREATE FUNCTION silver.EXTRACT_BASE_NUMBER (
    @input NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @raw NVARCHAR(MAX) = '';
    DECLARE @char CHAR(1);
    DECLARE @i INT = 1;

    -- Step 1: Extract digits only
    WHILE @i <= LEN(@input)
    BEGIN
        SET @char = SUBSTRING(@input, @i, 1);
        IF @char LIKE '[0-9]'
            SET @raw += @char;
        SET @i += 1;
    END

    -- Step 2: Trim leading zeros but preserve internal ones
    DECLARE @first_nonzero INT = PATINDEX('%[^0]%', @raw);
    IF @first_nonzero = 0
        RETURN ''; -- All zeros or no digits
    RETURN SUBSTRING(@raw, @first_nonzero, LEN(@raw));
END;
GO
*/

