class Etl:
  _configuration as string
  _basePath as string
  
  def constructor(basePath as string, configuration as string):
    _basePath = basePath
    _configuration = configuration
    
  def Run(script as string):
    command = "Rhino.Etl.Cmd.exe" + " -c:" + _configuration + " -f:" + _basePath + script
    print "Executing " + script
    exec command, { 'WorkingDir': """BuildTools\Tools\RhinoEtl\""" }