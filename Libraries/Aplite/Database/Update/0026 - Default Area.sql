IF EXISTS ( SELECT null FROM tbdArea WHERE Name = 'Test Area' )
	UPDATE tbdArea SET Name = 'Default' WHERE Name = 'Test Area'
	
IF NOT EXISTS ( SELECT null FROM tbdArea )
	INSERT INTO tbdArea ( 
		Tier, [Order], Name, Description, DescriptionRaw, PreCache, Tracking, StateAreaID, 
		AreaRoleIDView, AreaRoleIDAdmin, 
		PostRoleIDView, PostRoleIDCreate, PostRoleIDModerate, PostRoleIDDelete,
		CommentRoleIDView, CommentRoleIDCreate, CommentRoleIDModerate, CommentRoleIDDelete,
		DateLastAction
	)
	VALUES (
		0, 0, 'Default', 'Default', 'Default', 0, 0, 0, 
		1, 1, 
		1, 1, 1, 1, 
		1, 1, 1, 1,
		GETUTCDATE()
	)
