---
title: 设置text-overflow為ellipsis后引起的文本对齐问题
date: 2016-05-10 15:16:23
tags: css
---

最近在做网页的时候用到了文本溢出隐藏的功能，但是出现了一些小问题，下面先放上示例代码吧。
<!-- more -->
```html
<p>
  <span class="left">Hello Hello Hello</span>
  <span class="right">xhaha</span>
</p>
```

```css
p {
  width: 40%;
  margin: 20px auto;
  font-size: 50px;
}
span {
  display: inline-block;
}
.left {
  width:40%;
  text-overflow: ellipsis;
  white-space: nowrap;
  overflow: hidden;
}
.right{
  /* overflow: hidden; */
}
```
[查看DEMO](https://jsfiddle.net/pskpcfc8/1/)

按以上代码最后得到的显示效果是，`span.left`和`span.right`没有对齐。右边的会沉下去点，这个在demo里面可以看到。

然后我就想这是什么原因造成的，在调试器里勾选掉`.left`的`overflow: hidden`后，就显示正常了（当然，省略号儿也没了），然后我就捉摸着这是不是BFC的问题，因为平时自己清除浮动什么的，都喜欢用`overflow:hidden`来触发BFC，以便包裹元素的来着。当然了，给.right设置`overflow: hidden`或者`float: right`之后，也确实会显示正常（`float: right`会让文字右浮动，不过对齐的效果确实是达到了)，之后我就在BFC的问题上纠结了好久，因为[MDN](https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Block_formatting_context)上说了，`inline-block`元素本身就是会触发BFC的，那么前面所说的和BFC有关，就不那么准确了。

后来在stackoverflow上得到了答案，对`span`加上一个`vertical-align: top`然后就会对齐了。

至于原因，是因为`inline-block`元素默认的对齐方式是基线对齐，那么基线是什么呢？　如果一个`inline-block`盒子是空的，或者说他的`overflow`属性不为`visible`, 那么他的基线就是其下边距边缘，否则的话，就是其内部最后一个内联元素的基线（文字就是内联元素咯。。）

如下所示：

![](http://images2015.cnblogs.com/blog/852232/201601/852232-20160106180012621-339338620.png)

> The baseline of an ‘inline-block’ is the baseline of its last line box in the normal flow, unless it has either no in-flow line boxes or if its ‘overflow’ property has a computed value other than ‘visible’, in which case the baseline is the bottom margin edge.

那么，span.left的基线就是那个背景色的最下边，而右边span.right的基线，就是字符x的底部，基线对齐的意思，就是这两条线是在同一水平线上的，所以，右边的元素为了对齐，就要往下沉咯。现在我们目测的话，也是这两条线貌似也确实是在一条水平线上的。

所以，设置了`vertical-align: top`之后，改变了其默认对齐方式，所以就对齐咯。

然后使用右浮动之后，因为浮动会使盒子的`display`属性变为`block`，所以就不是`inline-block`元素，自然就不会受到前面的规则的影响了。

之后是使用`overflow: hidden`，这个属性使得inline-block元素的基线发生了改变，变得和左边元素一样，所以也能对齐。

最后来个小总结吧： 好的文章一定要多读几遍，每一遍都会有所收获。

参见： 
[stackoverflow- inline-block元素垂直对齐问题](http://stackoverflow.com/questions/12950479/why-does-inline-block-element-having-content-not-vertically-aligned)
[张鑫旭-CSS深入理解vertical-align和line-height的基友关系](http://www.zhangxinxu.com/wordpress/2015/08/css-deep-understand-vertical-align-and-line-height/)