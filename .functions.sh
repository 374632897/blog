#! /bin/bash
clone () {
  git clone $1 && cd $(basename ${1%.*}) && yarn install;
  # echo 'I will clone a remote repo. ';
}
md () {
  mkdir "$1" && cd "$1";
}
clr () {
  cat /dev/null > "$1";
}

export clone;
export md;
export cl;
