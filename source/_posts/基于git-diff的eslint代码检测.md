---
title: 基于git diff的eslint代码检测
date: 2016-08-15 09:32:54
tags: nodejs
---
# 基于git diff进行的eslint代码检测

随着代码的不断增加， eslint进行代码检测的时间也越来越久。每次检测的时候， 需要检测的文件和实际检测的文件极度不对称，所以便基于`git diff`写了这样一个小工具。
<!-- more -->
## 源代码
* 启动脚本(`lint.sh`)

```bash
#!/bin/bash
INFO='\033[36m';
NOR='\033[0m';
ERR='\033[31m';
br='dev';
if [ ! -z $1 ]; then
  br=$1;
fi;
echo -e "${INFO}run lint now ... just wait a moment ...${NOR}";
git diff origin/${br} > diff.log;
log=`cat diff.log | grep 'diff --git a/src'`;
if [[ -z ${log} ]]; then
  echo -e "${INFO}没有文件发生变化${NOR}";
else echo '';
  node ./lint-by-diff.js;
  echo -e "${INFO}done ...${NOR}";
fi;
rm diff.log change.log 2> /dev/null;
read;

```

* 检测工具(`lint-by-diff.js`)

```js
'use strict';
const fs = require('fs');
const shelljs = require('shelljs');

const jsFiles = [],
  LOG__PATH   = './diff.log',
  FILE = /diff --git a([\s\S]*?) /g,
  data = fs.readFileSync(LOG__PATH).toString(),
  _files = data.match(FILE),
  len = _files.length;

let i = 0;
while (i < len) {
  const _item = _files[i++].trim();
  if (!/.js$/.test(_item)) continue;
  const item = './' + _item.slice(13);
  if (!/^\.\/src\//.test(item)) continue; // src为项目需要进行eslint检测的目录
  if (!fs.existsSync(item)) continue;
  jsFiles.push(item);
}
console.log('------------------------------');
console.log('     以下文件发生改变： ');
console.log(jsFiles.join('\n'));
console.log('------------------------------');
shelljs.exec('node ./node_modules/eslint/bin/eslint.js ' + jsFiles.join(' '));
```

## 原理
通过`git diff origin/branch`获取到和指定分支的不同， 从而知道哪些文件需要进行代码检测（dev上的是通过检测的）， 然后运行eslint的时候就指定这部分文件。

## 使用
在项目根目录下输入`./lint.sh`或者`bash ./lint.sh`, 默认分支为`dev`分支， 如果需要指定其他分支， 可以在运行的时候传入参数， 如： `bash ./lint.sh master`.

## 不足
* 使用了bash导致这个看起来有点不伦不类， 使用纯js也许会更好， 但是我毕竟半吊子， 写不出来→＿←

* 没有对`error`进行高亮显示， 所以看起来会比较费力

