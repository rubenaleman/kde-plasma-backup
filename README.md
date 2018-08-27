# kde-plasma-backup

This script was made to have a simple way to backup and restore KDE Plasma Desktop environment configuration when moving to other computer.

- [Syntax](#syntax)
- [Actions](#actions)
- [Options](#options)
    - [backup](#backup)
    - [restore](#restore)
- [Requirements](#requirements)
- [Examples](#examples)

## Syntax

The usage of the script is simple: it only needs to get the action that must execute, with some mandatory or optional options:

```
kde-plasma-backup.sh action [options]
```

## Actions

The actions that supports for the moment are the next ones:

- `backup`: The backup is made in a compressed `.tgz` file including all the user specific configuration files from home directory. The default output directory of the backup is `/tmp` but you can change it with `-o` option. The script also can upload the backup file to a Dropbox account.
- `restore`: Once one backup is made, we can restore it with this action. The `-f` option is required to specify the input backup from which we want to restore the KDE Plasma configuration made in the previous action.
- `help`: Print the help message with all actions and options.

## Options

#### backup

```
-o <directory>   #  output directory where it will be created the backup file. Default value is /tmp
-d               #  uploads the backup file generated to the Dropbox account configured
```

#### restore

```
-f <file>        #  file to use for restoring KDE configuration environment
```

## Requirements

### Restore process

The restore must be executed from SSH or TTY directly, without any open user session, because when the system runs the logout process, some of the actual configuration of plasmashell and KDE is writed to disk, overwritting the settings that were been applied with the restore.

### Upload backup file to Dropbox account

The upload of the backup file to the Dropbox account needs a valid access token from an user or app access privileges. The token needs to be configured in the `dropbox.properties` file replacing the value of `DROPBOX_TOKEN` variable with the value of the valid access token. This variable can also be configured in our shell environment (like `.zshrc` or `.bashrc` files for example), to have always our dropbox access token configured separated from the script directory.

## Examples

```
kde-plasma-backup.sh backup
kde-plasma-backup.sh backup -o /tmp/tmp
kde-plasma-backup.sh backup -d
kde-plasma-backup.sh restore -f /path/to/file
```
