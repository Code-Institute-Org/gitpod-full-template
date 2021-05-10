#!/bin/bash
# Script to allow Heroku API key to be pasted
# exported as an environment variable
#
# Matt Rudge, May 2021

echo Heroku authentication configuration script
echo Code Institute, 2021
echo

if [[ -z "${HEROKU_API_KEY}" ]]; then
   echo Paste your Heroku API key here:
   read apikey
   echo export HEROKU_API_KEY=${apikey} >> ~/.bashrc
   echo Added the export. Refreshing the terminal.
   . ~/.bashrc > /dev/null
   echo Done!
else
   echo API key is already set. Exiting
fi
