---
title: GitHub仓库绑定二级域名
date: 2016-06-03 13:04:53
tags: GitHub Pages
---
1. 在仓库创建`gh-pages`分支

2. 在该分支根目录下添加`CNAME`文件，文件内容是你希望指向的域名，需要注意的是不需要加协议，如期望网址是`http://algorithms.noteawesome.com`的话， 就直接写`algorithms.noteawesome.com`.
<!-- more -->
![创建CNAME文件](http://o869zxhjd.bkt.clouddn.com/QQ%E5%9B%BE%E7%89%8720160603130619.png)
在完成创建之后可以前往仓库设置查看是否设置成功
![检验是否设置成功](http://o869zxhjd.bkt.clouddn.com/QQ%E5%9B%BE%E7%89%8720160603131423.png)

3. 前往域名控制中心添加域名解析
![添加解析](http://o869zxhjd.bkt.clouddn.com/QQ%E5%9B%BE%E7%89%8720160603131304.png)

4. 慢慢等， 也可以用`ping 'your site'`来查看是否成功设置
![是否解析成功](http://o869zxhjd.bkt.clouddn.com/QQ%E5%9B%BE%E7%89%8720160603131646.png)