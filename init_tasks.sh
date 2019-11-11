#!/bin/bash

# Creates a user record for the current Cloud9 user
# Gives a personalised greeting
# Upgrades pip
# Author: Matt Rudge

echo "Setting the greeting"
sed -i "s/USER_NAME/$GITPOD_GIT_USER_NAME/g" ${GITPOD_REPO_ROOT}/README.md
echo "Creating the ${C9_USER} user in MySQL"
mysql -e "CREATE USER '${C9_USER}'@'%' IDENTIFIED BY '';"
echo "Granting privileges"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${C9_USER}'@'%' WITH GRANT OPTION;"
echo "Creating .sqliterc file"
echo ".headers on" > ~/.sqliterc
echo ".mode column" >> ~/.sqliterc
echo "Adding run aliases"
echo 'alias run="python3 $GITPOD_REPO_ROOT/manage.py runserver 0.0.0.0:8000"' >> ~/.bashrc
echo "Checking for pip upgrade"
pip3 install --upgrade pip
echo "Done"
source ~/.bashrc
rm $GITPOD_REPO_ROOT/.gitpod*
rm $GITPOD_REPO_ROOT/init_tasks.sh
