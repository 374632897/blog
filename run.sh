#! /bin/bash
cp ~/{.aliases,.functions}.sh ~/.bash_profile .;
git commit -am 'auto-copy from the home directory';
git push
