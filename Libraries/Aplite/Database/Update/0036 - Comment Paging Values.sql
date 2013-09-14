UPDATE tbdArea
SET
	PostPerPage = 10
GO

UPDATE c
SET 
	c.Page = 
		COALESCE(CEILING(
		(
			SELECT
				CAST(CASE WHEN COUNT(CommentID) = 0 THEN null ELSE COUNT(CommentID) END as decimal)
			FROM tbdComment
			WHERE 
				PostID = c.PostID
			AND StateContentID NOT IN (1,2,3)
			AND DateCreated <=
			( 
				SELECT DateCreated
				FROM tbdComment
				WHERE 
					PostID = c.PostID
				AND CommentID = c.CommentID
			)
		) / a.PostPerPage),1)
FROM tbdComment c
	JOIN tbdPost p on c.PostID = p.PostID
	JOIN tbdArea a on p.AreaID = a.AreaID
GO