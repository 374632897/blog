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

# open project with sublime
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
# The command w will show the login users.
alias we='co && cd ./webpage';
alias tip='pe && cd ./just-some-tips';

# Command
alias fpm='sudo php-fpm -D';
alias stopfpm='sudo pkill php-fpm';
alias server='fpm && startng';
alias stopserver='stopfpm && stopng';
alias startng='sudo /usr/local/nginx/sbin/nginx';
alias stopng='sudo /usr/local/nginx/sbin/nginx -s stop';
alias nginx='stopserver 2> /dev/null && server';
alias toggle='stopng && bash ~/bin/toggle.sh && startng';
alias lint='[ -r lint.sh ] && bash lint.sh';
alias s='npm start';
alias s1='r && nvm use 4.5 && s';
alias s2='b && nvm use 4.2 && s';
alias pserver='python -m SimpleHTTPServer';
# alias r1='stopserver && server && is "nginx"';
alias r1='stopng && startng';

# Git
alias gs="git status";
alias br='git branch';
alias ck='git checkout';
alias delbr='git branch -D';
alias all='bash ~/bin/commit.sh';
alias pn='git push --set-upstream origin';
alias pu='git push';
alias cm='git commit';
alias ss='git diff origin/dev --shortstat';
alias sn='git diff origin/dev --name-only';

# Common
alias ip='ifconfig | grep 192';
# output the counts of the current given process
alias is="ps aux | grep  -v \"grep\" | grep  -c  $1";
alias xxnet='/Users/Jason/Downloads/XX-Net/start';
alias reload='source ~/.bash_profile';

# java-algs4
alias j='java-algs4';
alias jc='javac-algs4';

# proxy
alias proxy='export http_proxy=127.0.0.1:8087; export https_proxy=127.0.0.1:8087';

# docker
alias d='docker';
alias di='docker images';
alias db='docker build';
alias dr='docker run -it';
alias rm_docker_container='docker rm `docker ps -aq`';
alias rm_docker_images='docker rmi `docker images -qf dangling=true`';
alias d_c='docker-compose';

# PATH
export="/usr/local/sbin:$PATH";
export PATH="$PATH:$HOME/.yarn/bin:$HOME/.yarn-config/global/node_modules/.bin";
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/dist;
# export NVM_NODEJS_ORG_MIRROR="https://npm.taobao.org/mirrors/node"；
#
export PS1='\H:\W \u\$ ';
export NVM_DIR="/Users/Jason/.nvm";
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh";
nvm use system;
eval $(thefuck --alias);
# java
JAVA_HOME=`/usr/libexec/java_home`;
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar;
PATH=$JAVA_HOME/bin:$PATH:/usr/local/bin:`yarn global bin`;
