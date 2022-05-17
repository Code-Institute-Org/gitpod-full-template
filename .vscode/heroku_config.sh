#!/bin/bash
# Script to allow Heroku API key to be pasted
# exported as an environment variable
#
# Matt Rudge, May 2021

echo Heroku authentication configuration script
echo Code Institute, 2021
echo
echo Get your Heroku API key by going to https://dashboard.heroku.com
echo Go to Account Settings and click on Reveal to view your Heroku API key
echo 

if [[ -z "${HEROKU_API_KEY}" ]]; then
   echo Paste your Heroku API key here or press Enter to quit:
   read apikey
   if [[ -z "${apikey}" ]]; then
      return 0
   fi
   echo export HEROKU_API_KEY=${apikey} >> ~/.bashrc
   echo Added the export. Refreshing the terminal.
   . ~/.bashrc > /dev/null
   echo Done!
else
   echo API key is already set.
   echo
   echo In the event of an error with the API key, use the following command:
   echo
   echo unset HEROKU_API_KEY
   echo
   echo This will clear the API key and allow you to run heroku_config again.
   echo Exiting with existing API key set.
fi
