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

