include "BuildTools/Global.boo"
include "BuildTools/Database.boo"
include "BuildTools/Deploy.boo"

# Project Information
title                 = "LittleBanking"
company               = "Apsure"
version_major         = 1
version_minor         = 0
version_build         = 0
version_revision      = 0
repository_url        = ""
repository_type       = "git"
solution_file         = "LittleBanking.sln"
project_type          = "web"
project_dir           = "LittleBanking"

# Database Information
database_dir          = "Libraries\\Aplite\\Database"
database_custom_dir   = "Database"
database_server       = ".\\SQLEXPRESS"
database_name         = "LittleBanking"
database_trusted      = true
database_username     = ""
database_password     = ""

# Custom
google_analytics_account = ""

# Targets
desc "Default target"
target default:
  try:
    call update
    call compile
    call test
    call package
    call poke
    call zip
  except e:
    print e
    
target update:
  try:
    exec(".\\ExternalProjects\\Aplite\\Tools\\NuGet.exe install .\\Source\\LittleBanking\\packages.config -OutputDirectory .\\Libraries")
    exec(".\\ExternalProjects\\Aplite\\Tools\\NuGet.exe install .\\Source\\LittleBanking.Core\\packages.config -OutputDirectory .\\Libraries")
  except e:
    print e
    
target poke:
  package_dir = "Build/Release/PackageWeb"
  
  with xmlpoke():
    .file="${package_dir}/Web.config"
    .xpath="/configuration/connectionStrings/add[@name = 'DatabaseConnectionString']/@connectionString"
    .value="Data Source=???.???.???.???;Initial Catalog=${database_name};Persist Security Info=True;User ID=${database_username};Password=${database_password}"    
    
  with xmlpoke():
    .file="${package_dir}/Web.config"
    .xpath="/configuration/appSettings/add[@key = 'GoogleAnalyticsAccount']/@value"
    .value=google_analytics_account
    
  with xmlpoke():
    .file="${package_dir}/Web.config"
    .xpath="/configuration/system.web/compilation/@debug"
    .value="true"
    
  with xmlpoke():
    .file="${package_dir}/Web.config"
    .xpath="/configuration/system.web/customErrors/@mode"
    .value="On"
    
  with xmlpoke():
    .file="${package_dir}/Web.config"
    .xpath="/configuration/dotless/@minifyCss"
    .value="true"
    
  with xmlpoke():
    .file="${package_dir}/Web.config"
    .xpath="/configuration/dotless/@cache"
    .value="true"
