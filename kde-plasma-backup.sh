#!/bin/bash

## Define global variables

SHARE_FILES=("color-schemes" "knewstuff3" "konsole" "kxmlgui5" "plasma" "aurorae" "themes")
CONFIG_FILES=("dolphinrc" "k*" "plasma*" "powerdevilrc" "powermanagementprofilesrc" "startupconfig" "startupconfigkeys" "systemsettingsrc" "touchpadrc" "gtk-2.0" "gtk-3.0" "gtk-4.0")
OUTPUT_DIR="/tmp"
BACKUP_DIR="/tmp/kde-configuration-backup"
RESTORE_DIR="/tmp/kde-configuration-restore"

## Define functions

help(){
    echo "Usage: kde-plasma-backup.sh ACTION [OPTION]
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

The restore must be executed from SSH or TTY directly, without any open user session,
because when the system runs the logout process, some of the actual configuration of 
plasmashell and KDE is writed to disk, overwritting the settings that were been applied 
with the restore.
"
}

backup(){
    echo "[*][INFO] Creating backup temporary directory."
    if [ ! -d $BACKUP_DIR ]; then
        mkdir $BACKUP_DIR
    else
        rm -rf $BACKUP_DIR
        mkdir $BACKUP_DIR
    fi
    
echo "[*][INFO] Doing backup of KDE environment configuration files."
    for file in ${SHARE_FILES[@]}; do
        rsync -aqR ${HOME}/./.local/share/${file} $BACKUP_DIR
    done
    
    for file in ${CONFIG_FILES[@]}; do
        rsync -aqR ${HOME}/./.config/${file} $BACKUP_DIR
    done

    rsync -aqR ${HOME}/./.gtkrc-2.0 $BACKUP_DIR
    
    echo "[*][INFO] Compresing backed up files."
    tar czf ${OUTPUT_DIR}/kde-configuration-backup.tgz -C $BACKUP_DIR .

    echo "[*][INFO] Cleaning temporary directory."
    rm -rf $BACKUP_DIR

    echo "[*][SUCCESS] KDE environment backup file generated in ${OUTPUT_DIR}"
}

restore(){
    echo "[*][INFO] Creating restore temporary directory."
    if [ ! -d $RESTORE_DIR ]; then
        mkdir $RESTORE_DIR
    else
        rm -rf $RESTORE_DIR
        mkdir $RESTORE_DIR
    fi

    echo "[*][INFO] Extracting restore file."
    tar xzf $RESTORE_FILE -C $RESTORE_DIR &> /dev/null

    echo "[*][INFO] Restoring KDE environment configuration files."
    for item in .config .local .gtkrc-2.0 ; do
        rsync -aqR --no-owner --no-group ${RESTORE_DIR}/./${item} ${HOME}/
    done

    echo "[*][INFO] Cleaning temporary directory."
    rm -rf $RESTORE_DIR

    echo "[*][SUCCESS] KDE environmente configuration files had been successfully restored from $RESTORE_FILE"
}

## Main

case "$1" in 
    backup)
        shift
        while getopts ":o:" opt; do
            case $opt in
                o)
                    OUTPUT_DIR="$OPTARG"
                    if [ -d $OUTPUT_DIR ]; then
                        echo "[*][INFO] Changed output directory to: ${OUTPUT_DIR}"
                    else
                          echo "[*][FAILURE] Directory ${OUTPUT_DIR} does not exists. Please, create it and run again the script or select another directory."
                        exit 1
                    fi
                ;;
                \?)
                    echo "[*][FAILURE] Invalid option: -$OPTARG"
                    echo "See kde-plasma-backup.sh help for more information."
                    exit 1
                ;;
                :)
                    echo "[*][FAILURE] Option -$OPTARG requires an argument."
                    echo "See kde-plasma-backup.sh help for more information."
                    exit 1
                ;;
            esac
        done

        backup
    ;;
    restore)
        shift
        if [ $# -eq 0 ]; then
            echo "[*][FAILURE] No file for restore was specified."
            echo "See kde-plasma-backup.sh help for more information."
            exit 1
        fi
        case "$1" in
            -f)
                shift
                RESTORE_FILE="$1"
                if [ ! -z "$RESTORE_FILE" ] && [ -s "$RESTORE_FILE" ]; then
                    echo "[*][INFO] Using file ${RESTORE_FILE} for restoring KDE configuration."
                else
                    echo "[*][FAILURE] File ${RESTORE_FILE} does not exist or it is not valid."
                    echo "See kde-plasma-backup.sh help for more information."
                    exit 1
                fi
                shift
            ;;
            *)
                echo "[*][FAILURE] Invalid option: $1"
                echo "See kde-plasma-backup.sh help for more information."
                exit 1
            ;;
        esac
        
        restore
    ;;
    *)
        help
        exit 1
    ;;
esac
