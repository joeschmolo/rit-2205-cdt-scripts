#!/bin/sh
#
# Author: Joe Schultz (jxs6799@rit.edu)
#
# Description:  Set correct permissions on certain system/user
#               files (/etc/passwd, /etc/shadow, $HOME, etc.).
#               REMOVES .ssh FOLDERS in HOME DIRS
#
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

echo "Current permissions on /etc/passwd (Should be rw-r-r- root:root):"
ls -lA /etc/passwd
echo "Setting correct permissions on /etc/passwd..."
sudo chown root:root /etc/passwd
sudo chmod 644 /etc/passwd
echo

echo "Current permissions on /etc/shadow (Should be rw-r--- root:shadow):"
ls -lA /etc/shadow
echo "Setting correct permissions on /etc/shadow..."
sudo chown root:shadow /etc/shadow
sudo chmod 640 /etc/shadow
echo

echo "Setting correct permissions for users with home directory set to /home/user..."
for userselect in `cut -d: -f1 /etc/passwd`
    # Test for user's directory existance
	if [ -d /home/$userselect ]; then
        echo "/home/$userselect"
        chown -R $userselect:$userselect /home/$userselect
		chmod 755 /home/$userselect
        if [ -d /home/$userselect/.ssh ]; then
            echo "/home/$userselect/.ssh FOUND! Possible keys stored.  Deleting folder..."
            rm -rf /home/$userselect/.ssh
        fi
		chmod 700 /home/$userselect/*
        echo "Permissions have been corrected for user $userselect"
	fi
done
echo "done"
