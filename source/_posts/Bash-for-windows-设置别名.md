---
title: git bash 设置别名
date: 2016-08-09 18:42:22
tags: git
---
平时在windows上做开发的时候， 总觉得其命令行不好用， 所以使用命令行的时候， 都是用的`git bash`。然后每次需要提交代码的时候， 总是会`git add . `, `git commit -m '..'` , `git push`, 至少都要输入这么三条命令，实在是麻烦。 那么有没有什么办法可以简化操作呢？
<!-- more -->
最开始的时候我用的`shell`， 在每个仓库的根目录下都建立一个`all.sh`， 长相大概就是这样：

```sh
#!/bin/bash
dm=':smirk:';
if [ ! -z $1 ]; then
  dm=$1;
fi;
git add --all;
git commit -m "$dm";
git push;
```
然后每次提交的时候直接运行`bash ./all.sh`就行了， 那么问题来了， 这样一来的话， 每次创建一个仓库， 就要复制一下这个文件，还是麻烦。

`linux`下可以给`bash`设置别名， 比如通过修改`/etc/.bashrc`， 但是在`bash for windows`下应该怎么做呢？

其实吧。。 `bash for windows`也是有类似的文件的， 只不过不叫`.bashrc`而是`bash.bashrc`, 位置在`/etc/bash.bashrc`那里，当然， 具体的位置可能会因为git版本的不同而有所不同， windows下没有`etc` ? 没事儿， 在bash下直接cd就进去了。

然后就加了别名



```sh
# alias

alias ls='ls --color=auto';
alias ll='ls -lh';
alias all='git add --all && git commit -m ":smirk:" && git push';
alias ..='cd ..';
alias ....='cd ../../';
alias ld='ll | grep "^d"';
alias psw='ps -a --windows';
alias vi='vim';

# 以下是cygwin下针对快速切换到挂载目录设置的别名
alias d='cd /cygdrive/d';
alias ng='cd /cygdrive/d/nginx-1.6.0';
alias gi='cd /cygdrive/d/JGX/GitHub';

```
重启下bash , 然后就能够使用了。

虽然`git bash`用着也还行， 不过还是对不少的linux命令没有提供支持， 另外一个软件`cygwin`也挺不错， 支持也挺多的， 如果安装`cygwin`的话， 需要注意一点， 也就是它默认不会安装`vim`， 所以在选择软件的时候需要留意一下。另外， `git bash`好像会比`cygwin`快一点， `cygwin`在运行未运行过的程序的时候， 反应会比较慢（查找去了？）， 另外， 关于`git`, 在`cygwin`下好像也需要重新配置。

