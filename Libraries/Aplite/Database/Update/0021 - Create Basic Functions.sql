CREATE FUNCTION [dbo].[ufRPad] ( @Data varchar(500), @Length int, @Character varchar(1))
	RETURNS varchar(500)
AS
BEGIN
	IF @Character = '' or @Character IS NULL
		SET @Character = ' '

	RETURN LEFT(ltrim(rtrim(@Data)) + REPLICATE(@Character, @Length), @Length)
END

GO
CREATE FUNCTION [dbo].[ufLPad] ( @Data varchar(500), @Length int, @Character varchar(1))
	RETURNS varchar(500)
AS
BEGIN
	IF @Character = ''
		SET @Character = ' '

	RETURN right(REPLICATE(@Character, @Length) + ltrim(rtrim(@Data)), @Length)
END

GO

CREATE FUNCTION [dbo].[ufSplit] (@List varchar(512), @Char char(1))
RETURNS TABLE
AS
RETURN
(
	WITH Pieces(Number, Start, Stop) AS (
      SELECT 1, 1, CHARINDEX(@Char, @List)
      UNION ALL
      SELECT Number + 1, Stop + 1, CHARINDEX(@Char, @List, Stop + 1)
      FROM Pieces
      WHERE Stop > 0
    )
    SELECT Number,
      SUBSTRING(@List, Start, CASE WHEN Stop > 0 THEN Stop-Start ELSE 512 END) AS Item
    FROM Pieces
)

GO

CREATE FUNCTION [dbo].[ufTitleCase]
               (@TextIn NVARCHAR(4000))
RETURNS NVARCHAR(512)
AS
  BEGIN
	IF @TextIn IS NULL
		RETURN @TextIn

    DECLARE  @TitleCase NVARCHAR(256)
    
    DECLARE  @TextInGrid  TABLE
	(
        TextInput NVARCHAR(4000)    NOT NULL
    )
    
    DECLARE  @Delimiters  TABLE
	(
	    Delimiter CHAR(1)    NOT NULL
    )

    DECLARE  @WordExclusion  TABLE
	(
		Modifiers VARCHAR(20)    NOT NULL
    )
    
    INSERT @TextInGrid
    VALUES(@TextIn)
    
    INSERT @WordExclusion
          (Modifiers)
    SELECT ' the '
    UNION
    SELECT ' a '
    UNION
    SELECT ' an '
    UNION
    SELECT ' and '
    UNION
    SELECT ' with '
    UNION
    SELECT ' from '
    UNION
    SELECT ' off '
    UNION
    SELECT ' in '
    UNION
    SELECT ' on '
    UNION
    SELECT ' as '
    UNION
    SELECT ' into '
    UNION
    SELECT ' of '
    UNION
    SELECT ' to '
	UNION
	SELECT ' that '
    
    INSERT @Delimiters
          (Delimiter)
    SELECT ' '
    UNION
    SELECT '-'
    UNION
    SELECT ''''
    
    SELECT @TitleCase = REPLACE(REPLACE((SELECT CASE
                                            WHEN number = 1
                                                  OR (SUBSTRING(n.TextInput,number - 1,1) IN (SELECT Delimiter
                                                                                             FROM   @Delimiters)
                                                      AND NOT EXISTS (SELECT *
                                                                      FROM   @WordExclusion e
                                                                      WHERE  Modifiers = SUBSTRING(n.TextInput,number - 1,LEN(Modifiers) + 1))) THEN UPPER(SUBSTRING(n.TextInput,number,1))
                                            ELSE LOWER(SUBSTRING(n.TextInput,number,1))
                                          END AS [text()]
                                 FROM     dbo.ufSPFNumbers(LEN(@TextIn))
                                 WHERE    number <= LEN(n.TextInput)
                                 ORDER BY number
                                 FOR XML PATH( '' )),'&#x20;',' '),'&amp;', '&')
    FROM   @TextInGrid n
    
    RETURN @TitleCase
  END 

GO

CREATE FUNCTION [dbo].[ufNumbers] ( @TotalRows int )
RETURNS TABLE
AS
RETURN
	(
		WITH Numbers(number)
		AS
		(
		SELECT 1 AS number
		UNION ALL
		SELECT (number + 1) AS number
		FROM Numbers
		WHERE
		number < @TotalRows
		)		
		SELECT number from Numbers 
	) 
GO

