# kde-plasma-backup

Usage: kde-plasma-backup.sh ACTION [OPTION]
Description: Script for make a backup or restore KDE Plasma environment configuration.
             
ACTIONS:                                                                                                      
                                                                  
  backup        make a backup of specific user home configuration     
  restore       restore the environment configuration from backup file
  help          print this help message
                                               
OPTIONS:       
                                                
  backup:                                                              
    -o <directory>    output directory where it will be created the backup file. Default value is /tmp
                                                                                                
  restore:                              
    -f <file>         file to use for restoring KDE configuration environment                  
                                                                                   
NOTES:                    
                                                                                                                                                              
The restore must be executed from SSH or TTY directly, without any open user session, because when the system runs the logout process, some of the actual configuration of plasmashell and KDE is writed to disk, overwritting the settings that were been applied with the restore.