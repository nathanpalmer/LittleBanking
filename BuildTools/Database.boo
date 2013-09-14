import tasks from Tarantino.DatabaseManager.Tasks

# Database Information
database_dir          = "Database"
database_custom_dir   = "@DATABASECUSTOM@"
database_server       = ".\\SQLEXPRESS"
database_name         = "@DATABASENAME@"
database_trusted      = true
database_username     = ""
database_password     = ""
database_action       = RequestedDatabaseAction.Update

def InitializeDatabaseVariables():
  if (database_name == "@DATABASENAME@"):
    raise "You must change database_name to something"
    
target updateDatabase:
  database_action = RequestedDatabaseAction.Update
  call manageDatabase
  if (database_custom_dir != "@DATABASECUSTOM@"):
    database_dir = database_custom_dir
    call manageDatabase

target dropDatabase:
  database_action = RequestedDatabaseAction.Drop
  call manageDatabase
  
target createDatabase:
  database_action = RequestedDatabaseAction.Create
  call manageDatabase  
  if (database_custom_dir != "@DATABASECUSTOM@"):
    database_action = RequestedDatabaseAction.Update
    database_dir = database_custom_dir
    call manageDatabase

target manageDatabase:
  InitializeDatabaseVariables()
  with manageSqlDatabase():
    .scriptDirectory=DirectoryInfo(database_dir)
    .action= database_action
    .server= database_server
    .database= database_name
    .integratedAuthentication=database_trusted
    .username=database_username
    .password=database_password