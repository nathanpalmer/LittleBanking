import tasks from FtpUploadTask

ftp_server          = "@FTPSERVER@"
ftp_username        = "@FTPUSERNAME@"
ftp_password        = "@FTPPASSWORD"
ftp_backupDirectory = "@FTPBACKUPDIRECTORY@"
ftp_publicDirectory = "@FTPPUBLICDIRECTORY@"

target publish:
  with ftppublish():
    .server=ftp_server
    .username=ftp_username
    .password=ftp_password
    .backupDirectory=ftp_backupDirectory
    .publicDirectory=ftp_publicDirectory
    .publishDirectory=package_dir
    .backupRemote=false
    .deleteRemote=true
    .debug=false
    .appOfflineFile="Resources/app_offline.htm"