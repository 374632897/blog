#! /bin/bash
cp ~/{.aliases,.functions}.sh ~/.bash_profile .;
git add .
git commit -m 'auto-copy from home directory';
git push
