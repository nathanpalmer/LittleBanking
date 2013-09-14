import System
import System.IO

# Project Information
title = "@TITLE@"
company = "@COMPANY@"
version_major    = 1
version_minor    = 0
version_build    = 0
version_revision = 0
repository_url = "@URL@"
repository_type = "svn"
project_type     = "library"
project_dir      = "@PROJECTDIR@"
package_dir      = "@PACKAGEDIR@"

# Build Information
solution_folder = "Source"
solution_file = "@SOLUTION@"
configuration = "Release"
dotnet_version = "4.0"
build_directory = DirectoryInfo("Build/${configuration}")

# Includes
include "Versioners/Subversion.boo"
include "Versioners/Mercurial.boo"

# Functions
def Initialize():
  if (title == "@TITLE@"):
    raise "You must change title to something custom for your project"
    
  if (company == "@COMPANY@"):
    raise "You must change company to something custom for your project"

  if (repository_url == "@URL@"):
    raise "You must change repository_url to be something custom for your project"

  if (solution_file == "@SOLUTION@"):
    raise "You must change solution_file to be something custom for your project"

# Targets
desc "Removes the build directory"
target clean:
  Initialize()
  rmdir("Build")
  
desc "Compiles the solution"
target compile, (clean, assemblyInfo):
  print "Compiling ${solution_file}"
  with msbuild():
    .file = Path.Combine(solution_folder, solution_file)
    .configuration = configuration
    .version = dotnet_version
    .properties = { 'OutDir': build_directory.FullName+"/" }
    
  # Building twice so that the files are generated for publish
  if (project_type == "web"):
    with msbuild():
      .file = Path.Combine(solution_folder, solution_file)
      .configuration = configuration
      .version = dotnet_version
    
target getRevision:
  #int.TryParse(env("build.vcs.number"), version_revision)
  #if (version_revision > 0):
  #  return
    
  if (repository_type == "svn"):
    version_revision = getRevisionSubversion(repository_url)
  elif (repository_type == "hg"):
    version_revision = getRevisionMercurial(repository_url)
    
  if (version_revision > 0):
    return
  else:
    raise "Unable to determine repository revision"
    
desc "Create the assembly info"
target assemblyInfo, (getRevision):
  print "Generating SolutionVersion.cs"
  with generate_assembly_info():
    .file = "${solution_folder}/SolutionVersion.cs"
    .version = String.Format("{0}.{1}.{2}.{3}", version_major, version_minor, version_build, version_revision)
    .fileVersion = String.Format("{0}.{1}.{2}.{3}", version_major, version_minor, version_build, version_revision)
    .title = title
    .description  = String.Format("{0} is a product of {1}", title, company)
    .copyright = String.Format("Copyright {0} {1}", DateTime.Now.Year, company)
    .comVisible = false
    .companyName = company
    .productName = title    
      
desc "Executes tests"
target test:
  with FileList(build_directory.FullName):
    .Include("*Test*.dll")
    .ForEach def(file):
      print "Running unit tests for ${file.Name}"
      with nunit():
        .assembly = file.FullName
        .toolPath = "BuildTools/Tools/NUnit/nunit-console.exe"
        .version = "2.5.5"
        .dotnet_version = dotnet_version

desc "Creates a zip file"
target package:
  package_dir = "Build/${configuration}"
  
  if (project_type == "web"):
    package_dir = Path.Combine(build_directory.FullName, "PackageWeb")
    with FileList("Source/${project_dir}"):
      .Exclude("obj/**")
      .Exclude("CodeTemplates/**")
      .Exclude("App_Data/error*.xml")
      .Exclude("App_Data/**")
      .Exclude("Logs/**")
      .Exclude("**/*.user")
      .Exclude("**/*.dtd")
      .Exclude("**/*.tt")
      .Exclude("**/*.cs")
      .Exclude("**/*.csproj")
      .Exclude("**/*.Publish.xml")
      .Exclude("hibernate.cfg.xml")
      .Exclude("**/*.pdb")
      .Exclude("video/**")
      .Include("**/**")
      .ForEach def(file):
        file.CopyToDirectory(package_dir)
        
target zip:
  zip(package_dir, String.Format("Build/{4}-{0}.{1}.{2}.{3}.zip", version_major, version_minor, version_build, version_revision, title))