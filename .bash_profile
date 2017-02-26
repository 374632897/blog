for file in ~/.{aliases,functions}.sh;do
  [ -r $file ] && source $file
done;

# iterm2
CLICOLOR=1
LSCOLORS=gxfxcxdxbxegedabagacad
exportPS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\$ '
