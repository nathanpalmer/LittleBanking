def getRevisionMercurial(repository_url):
  exec("hg summary", { 'Output': '_summary.txt' })
  
  file = StreamReader("_summary.txt")
  line = file.ReadLine()
  file.Close()
  file.Dispose()
  
  rm("_summary.txt")
  
  parts = line.Split(char(':'))
  
  revision = 0
  if (int.TryParse(parts[1].Trim(),revision)):
    return revision
  
  return 0