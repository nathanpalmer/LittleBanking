Update tbeFormat 
set Name = 'PlainText'
where FormatID = 2
go

IF NOT EXISTs(SELECT null from tbeFormat where FormatID = 6)
BEGIN
	INSERT INTO tbeFormat (FormatID , Name)
	values (6, 'MarkDown')
END 
