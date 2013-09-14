deploy_destination		= "@DEPLOYDESTINATION@"
deploy_backup			= "@DEPLOYBACKUP@"
deploy_offline_file		= "Resources/app_offline.htm"
deploy_skip_folders		= [ "App_Data" ]
deplay_skip_files		= []
deploy_custom_action	= null
deploy_custom_complete	= null

def InitializeDeployVariables():
	if (deploy_destination == "@DEPLOYDESTINATION@"):
		raise "You must change the deploy_destination to something"
	if (deploy_backup == "@DEPLOYBACKUP@"):
		raise "You must change the deploy_backup to something"
	if (File.Exists(deploy_offline_file) == false):
		raise "The file " + deploy_offline_file + " does not exist"
		
def CopyRecursive(source as DirectoryInfo,target as DirectoryInfo):
	if (Directory.Exists(target.FullName) == false):
		Directory.CreateDirectory(target.FullName)
		
	for file in source.GetFiles():
		file.CopyTo(Path.Combine(target.FullName, file.Name),true)
		print "Copied ${file.Name} to ${target.FullName}"
		
	for directory in source.GetDirectories():
		nextTarget = DirectoryInfo(Path.Combine(target.FullName,directory.Name))
		if (nextTarget.Exists == false):
			nextTarget.Create()
			
		CopyRecursive(directory,nextTarget)

target deploy:
	try:
		InitializeDeployVariables()

		if (Directory.Exists(deploy_backup) == false):
			Directory.CreateDirectory(deploy_backup)
		if (Directory.Exists(deploy_destination) == false):
			Directory.CreateDirectory(deploy_destination)
			
		# backup files
		zip(deploy_destination, Path.Combine(deploy_backup,DateTime.Now.ToString("yyyyMMddHHmmss")+".zip"))
		
		startTime = DateTime.Now

		deploy_destination_offline = Path.Combine(deploy_destination, "app_offline.htm")
		if (File.Exists(deploy_destination_offline) == false):
			cp deploy_offline_file, deploy_destination_offline
			
		# delete
		for file in DirectoryInfo(deploy_destination).GetFiles():
			if (file.Name == "app_offline.htm"):
				print "Leaving file '${file.Name}'"
			else:
				print "Deleting file '${file.Name}'"
				file.Delete()
				
		for file in DirectoryInfo(deploy_destination).GetDirectories():
			if deploy_skip_folders.Contains(file.Name):
				print "Leaving directory '${file.FullName}'"
			else:
				rm(file.FullName)

		if (deploy_custom_action != null):
			func = deploy_custom_action as callable
			func()

		# deploy
		CopyRecursive(DirectoryInfo(package_dir),DirectoryInfo(deploy_destination))
		
		if (File.Exists(deploy_destination_offline)):
			rm deploy_destination_offline
			
		endTime = DateTime.Now
		print "The deployment took ${endTime.Subtract(startTime).TotalSeconds} seconds"
			
		if (deploy_custom_complete != null):
			func = deploy_custom_complete as callable
			func()
	except e:
		print e.Message