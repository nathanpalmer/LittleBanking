IF NOT EXISTS ( SELECT null FROM tbmRole WHERE Title = 'Anonymous User' )
	INSERT INTO tbmRole ( Title )
	VALUES ( 'Anonymous User' )
	
IF NOT EXISTS ( SELECT null FROM tbmRole WHERE Title = 'Authenticated User' )
	INSERT INTO tbmRole ( Title )
	VALUES ( 'Authenticated User' )	