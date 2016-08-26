---
title: JS控制光标移动
date: 2016-07-04 09:11:41
tags: js
---
网上的那些人也真的是够了， 复制粘贴什么的都习以为常， 就算是抄一个东西， 难道不也该先验证一下人家的是不是对的么， 走网上搜一个光标移动位置的问题， 搜索结果一帕拉， 而且都是惊人地相似， 但是放到浏览器里面， 根本就不能够跑！！！！！！！！！！！！！！
<!-- more -->
然后自己最后还是老老实实地看书， 恩， 找到了一个方法哈。

```js
const sel = window.getSelection(),
  range = document.createRange(),
  div = $('div');

range.selectNodeContents(div);
sel.addRange(range);
sel.collapseToEnd();
```


这个针对`contenteditable`元素是有效的， 但是在`textarea`下， 使用`range`好像选不了其范围， 所以不能够操作， 不知道是不是方法错了， 不过在选中了文本框文本的情况下， 还是可以移动光标的。

```js
const textarea = $('textarea');
textarea.select();
// 也可以使用这段代码来设置选中范围， 然后就方便控制其光标位置了。
// textarea.setSelectionRange(0, 12); // 选中文本框内容的0, 12
window.getSelection().collapseToStart(); // 光标移动到开始位置
```
