#!/bin/bash

echo "Adding run aliases"
echo 'alias run="python3 $GITPOD_REPO_ROOT/manage.py runserver 0.0.0.0:8000"' >> ~/.bashrc
echo 'alias heroku_config=". $GITPOD_REPO_ROOT/.vscode/heroku_config.sh"' >> ~/.bashrc
echo 'alias python=python3' >> ~/.bashrc
echo 'alias pip=pip3' >> ~/.bashrc
echo 'python3 $GITPOD_REPO_ROOT/.vscode/font_fix.py' >> ~/.bashrc
echo "Your workspace is ready to use. Happy coding!"
