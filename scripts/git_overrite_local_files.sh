#!/usr/bin/env bash

echo  https://stackoverflow.com/questions/1125968/how-do-i-force-git-pull-to-overwrite-local-files

git fetch --all

#Backup your current branch (e.g. master):

#git branch backup-master
#Jump to the latest commit on origin/master and checkout those files:

git reset --hard origin/main
