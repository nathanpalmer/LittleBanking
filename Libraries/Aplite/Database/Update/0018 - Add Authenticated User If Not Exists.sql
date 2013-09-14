IF NOT EXISTS ( SELECT null FROM tbmRole WHERE Title = 'Authenticated User' )
BEGIN
	INSERT INTO tbmRole ( Title )
	VALUES ( 'Authenticated User' )
END