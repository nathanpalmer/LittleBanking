def getRevisionSubversion(repository_url):
  revision = 0
  
  if (File.Exists("C:/Program Files/TortoiseSVN/bin/SubWCRev.exe")):
    sw = StreamWriter("_revision.txt.tmp")
    sw.Write("$WCREV$")
    sw.Close()
    sw.Dispose()
    
    exec("\"C:/Program Files/TortoiseSVN/bin/SubWCRev.exe\" . _revision.txt.tmp _revision.txt")
    
    sr = StreamReader("_revision.txt")
    string_revision = sr.ReadLine()
    sr.Close()
    sr.Dispose()
    
    rm("_revision.txt")
    rm("_revision.txt.tmp")
    
    int.TryParse(string_revision, revision)
    
    if (revision > 0):
      return revision    
    
  exec("svn info . --xml", { 'Output': '_revision.xml', 'IgnoreNonZeroExitCode': true })
  string_revision = xmlpeek('_revision.xml', '/info/entry/commit/@revision', 'version.revision')
  int.TryParse(string_revision, revision)
  
  if (revision > 0):
    rm('_revision.xml')
    return revision
    
  exec("svn info ${repository_url} --xml", { 'Output': '_revision.xml', 'IgnoreNonZeroExitCode': true })
  string_revision = xmlpeek('_revision.xml', '/info/entry/commit/@revision', 'version.revision')
  int.TryParse(string_revision, revision)
  rm('_revision.xml')
  
  if (revision > 0):
    return revision
  else:
    return 0

