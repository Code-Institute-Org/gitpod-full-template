#!/bin/bash
# Post update script, add in changes to init_tasks.sh
# that won't take effect in an upgraded workspace

echo 'alias heroku_config=". $GITPOD_REPO_ROOT/.vscode/heroku_config.sh"' >> ~/.bashrc

echo Post-upgrade changes applied
