#! /bin/bash
# Directory
alias ls='ls -G';
alias ll='ls -lh';
alias la='ls -a';
alias ld='ll | grep "^d"';
alias ..='cd ..';
alias ....='cd ../../';
alias grep='grep --color=auto';

# Editor
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl';
alias vi=vim;

# Open project with sublime
alias sr='co && subl rishiqing-front';
alias sw='co && subl webpage';
alias sb='co && subl rishiqing-blog';
alias st='pe && subl just-some-tips';


# File  -- OPEN OR VIEW
alias bashrc='subl ~/.bash_profile ~/.aliases.sh ~/.functions.sh';
alias nconf='subl /usr/local/nginx/conf/nginx.conf';
alias naccess='ng && tail logs/access.log && cd -';
alias nerror='ng && tail logs/error.log && cd -';
alias clog='ng && cat /dev/null > logs/error.log && cd -';

# Folder
alias ng='cd /usr/local/nginx';
alias pe='cd ~/project/personal';
alias co='cd ~/project/company';
alias r='co && cd ./rishiqing-front';
alias b='co && cd ./rishiqing-blog';
# The command `w` will show the current login users.
alias we='co && cd ./webpage';
alias tip='pe && cd ./just-some-tips';

# Command
alias fpm='sudo php-fpm';
alias stopfpm='sudo pkill php-fpm';
alias server='fpm && startng';
alias stopserver='stopfpm && stopng';
alias startng='sudo /usr/local/nginx/sbin/nginx';
alias stopng='sudo /usr/local/nginx/sbin/nginx -s stop';
alias nginx='stopserver 2> /dev/null && server';
# Toggle the proxy server
alias toggle='stopng && bash ~/bin/toggle.sh && startng';
alias lint='[ -r lint.sh ] && bash lint.sh';
alias s='npm start';

# Git
alias gs="git status";
alias br='git branch';
alias ck='git checkout';
alias delbr='git branch -D';
alias all='bash ~/bin/commit.sh';

# Common
# Show your internal ip address
alias ip='ifconfig | grep 192';
# output the counts of the current given process
alias is="ps aux | grep  -v \"grep\" | grep  -c  $1";
alias xxnet='/Users/Jason/Downloads/XX-Net/start';
# Use this cmd to avoid type too many letters after each time you update bashrc 
alias reload='source ~/.bash_profile';

# PATH
export="/usr/local/sbin:$PATH"; 
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/dist;
# export NVM_NODEJS_ORG_MIRROR="https://npm.taobao.org/mirrors/node"；
export NVM_DIR="/Users/Jason/.nvm";
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh";
nvm use system;
eval $(thefuck --alias);
