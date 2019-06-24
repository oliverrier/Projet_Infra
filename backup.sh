#!/bin/bash

action=$1
save_name=$2
path=$3


# Making sure backup file exist
if test -d /shared_folder
    then
    if sudo test -f /shared_folder/config
        then
        echo Rappel: vos backups sont enregistrés dans /shared_folder
        echo ''
    else 
        echo Vos backups seront enregistrés dans /shared_folder
        echo ''
        sudo borg init -e none /shared_folder
    fi
else
    echo Vos backups seront enregistrés dans /shared_folder
    echo ''
    sudo borg init -e none /shared_folder
fi


#action based on parmaeters

if test "$action" = "save"
    then
    echo Saving...
    sudo borg create /shared_folder::$save_name $path
    echo Save Done !

elif test "$action" = "list"
    then
    sudo borg $action /shared_folder

elif test "$action" = "extract"
    then
    echo Extracting backup content \"$save_name\"...
    sudo borg $action /shared_folder::$save_name
    echo Extract Done !

elif test "$action" = "delete"
    then

    if test "$save_name" = "all"
        then
        echo Deleting...
        sudo borg $action /shared_folder
        echo Your backups have been successfully deleted !

    else
        echo Deleting...
        sudo borg $action /shared_folder::$save_name
        echo Your backups \"$nomSauvegarde\" has been deleted !
    fi

elif test "$action" = "-h" || test "$action" = "--help"
    then 
    echo -e "\n To do a backup: "
    echo "/backup.sh save backup_name backup_path "
    echo -e "\n To list your backup:"
    echo "/backup.sh list "
    echo -e "\n To extract your backup in your current folder:"
    echo "/backup.sh extract backup_name"
    echo -e "\n To delete a backup:"
    echo "/backup.sh delete backup_name"
    echo -e "\n To delete all your backups:"
    echo "/backup.sh delete all "
else
    echo Error: No expected arguments found. Type -h or --help to get more information. 
fi
