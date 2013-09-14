import tasks from CloudFrontDistribution

# Amazon Information
amazon_access_key = "@ACCESSKEY@"
amazon_secret_key = "@SECRETKEY@"
amazon_bucket     = "@BUCKET@"
amazon_folder     = "@FOLDER@"
amazon_basekey    = "@BASEKEY@"

def InitializeAmazonVariables():
  if (amazon_access_key == "@ACCESSKEY@"):
    raise "You must change the amazon_access_key to something"
  if (amazon_secret_key == "@SECRETKEY@"):
    raise "You must change the amazon_secret_key to something"
  if (amazon_bucket == "@BUCKET@"):
    raise "You must change the amazon_bucket to something"
  if (amazon_folder == "@FOLDER@"):
    raise "You must change the amazon_folder to something"
  if (amazon_basekey == "@BASEKEY@"):
    raise "You must change the amazon_basekey to something"
    
target uploadToAmazon:
  InitializeAmazonVariables()
  with CloudFront():
    .Debug = false
    .AccessKey = amazon_access_key
    .SecretAccessKey = amazon_secret_key
    .Bucket = amazon_bucket
    .Folder = amazon_folder
    .BaseKey = amazon_basekey
