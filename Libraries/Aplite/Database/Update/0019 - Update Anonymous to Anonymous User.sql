IF EXISTS ( SELECT null FROM tbmRole WHERE Title = 'Anonymous' )
BEGIN
	UPDATE tbmRole
	SET Title = 'Anonymous User'
	WHERE Title = 'Anonymous'
END