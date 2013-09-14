process SeedTag:

	operation:
		yield Row (
			Name: "Tag 1", 
			Description: "Tag 1" 
		)

		yield Row (
			Name: "Tag 2", 
			Description: "Tag 2" 
		)
		
	sqlBulkInsert "SQL", "tbmTag":
		map "Name"
		map "Description"