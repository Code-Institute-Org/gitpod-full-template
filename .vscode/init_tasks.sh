#!/bin/bash

# Creates a user record for the current Cloud9 user
# Gives a personalised greeting
# Adds configuration options for SQLite
# Creates run aliases
# Author: Matt Rudge

echo "Setting the greeting"
sed -i "s/USER_NAME/$GITPOD_GIT_USER_NAME/g" ${GITPOD_REPO_ROOT}/README.md
echo "Creating the ${C9_USER} user in MySQL"
RESULT="$(mysql -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '${C9_USER}')")"
if [ "$RESULT" = 1 ]; then
  echo "${C9_USER} already exists"
else
  mysql -e "CREATE USER '${C9_USER}'@'%' IDENTIFIED BY '';" -u root
  echo "Granting privileges"
  mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${C9_USER}'@'%' WITH GRANT OPTION;" -u root
fi
echo "Creating .sqliterc file"
echo ".headers on" > ~/.sqliterc
echo ".mode column" >> ~/.sqliterc
echo "Adding run aliases"
echo 'alias run="python3 $GITPOD_REPO_ROOT/manage.py runserver 0.0.0.0:8000"' >> ~/.bashrc
echo 'alias heroku_config=". $GITPOD_REPO_ROOT/.vscode/heroku_config.sh"' >> ~/.bashrc
echo 'alias python=python3' >> ~/.bashrc
echo 'alias pip=pip3' >> ~/.bashrc
echo "Your workspace is ready to use. Happy coding!"
source ~/.bashrc
