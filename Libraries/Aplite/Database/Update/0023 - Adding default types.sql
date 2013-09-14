IF NOT EXISTS ( SELECT null FROM tbmType WHERE TypeID = 1 AND Name = 'blog' )
	INSERT INTO tbmType ( TypeID, Name, Description )
	VALUES ( 1, 'blog', 'A blog is a regularly updated journal or diary made up of individual posts shown in reversed chronological order. Each member of the site may create and maintain a blog.')
	
IF NOT EXISTS ( SELECT null FROM tbmType WHERE TypeID = 3 AND Name = 'page' )
	INSERT INTO tbmType ( TypeID, Name, Description )
	VALUES ( 3, 'page', 'If you want to add a static page, like a contact page or an about page, use a page.')
	
IF NOT EXISTS ( SELECT null FROM tbmType WHERE TypeID = 4 AND Name = 'radio' )
	INSERT INTO tbmType ( TypeID, Name, Description )
	VALUES ( 4, 'radio', 'Manages radio streams and archives from blog talk radio.')
	
IF NOT EXISTS ( SELECT null FROM tbmType WHERE TypeID = 5 AND Name = 'sitebanner' )
	INSERT INTO tbmType ( TypeID, Name, Description )
	VALUES ( 5, 'sitebanner', 'A banner call-out for the front-page.')	
	
IF NOT EXISTS ( SELECT null FROM tbmType WHERE TypeID = 6 AND Name = 'story' )
	INSERT INTO tbmType ( TypeID, Name, Description )
	VALUES ( 6, 'story', 'Stories are articles in their simplest form: they have a title, a teaser and a body, but can be extended by other modules. The teaser is part of the body too. Stories may be used as a personal blog or for news articles.')
	
IF NOT EXISTS ( SELECT null FROM tbmType WHERE TypeID = 7 AND Name = 'topic' )
	INSERT INTO tbmType ( TypeID, Name, Description )
	VALUES ( 7, 'topic', 'Forum')	

IF NOT EXISTS ( SELECT null FROM tbmType WHERE TypeID = 8 )
	INSERT INTO tbmType ( TypeID, Name, Description )
	VALUES ( 8, 'song', 'song')
ELSE
	UPDATE tbmType
	SET Name = 'song', Description = 'song'
	WHERE TypeID = 8