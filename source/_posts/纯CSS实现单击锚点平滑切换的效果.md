---
title: 纯CSS实现单击锚点平滑切换的效果
date: 2016-05-10 14:36:25
tags: css
---

有时想实现一个功能，比如想让页面不出现滚动条，但是却能装下更多的东西，这个时候我们会对某个容器设 置`overflow: hidden`，然后通过锚点来实现单击切换页面（其实只是控制显示的内容）的效果。但是通过锚点来跳到指定内容的不足之处在于，没有什么过渡效果，很突兀的就跳到了目标点。当然，也可以通过JS或者jQuery来实现自己想要的动态切换效果，这一类的文章一搜一大堆，这里就不赘述了。
<!-- more -->
但是在一些个人主页中，比如github的个人主页（只是主页而已，也就是username.github.io）上会禁止JS脚本的运行，这个时候如果还是想通过单击锚点平滑切换的功能的话，应该怎么办呢？

原谅我是一个前端初学者，傻想了很久也想不到什么办法，然后就百度谷歌了。

后来找到了一些方法，比如用radio配合他的check属性来实现，[文章在这里](http://tympanus.net/codrops/2012/06/12/css-only-responsive-layout-with-smooth-transitions/),关于这个方法，[慕课](http://www.imooc.com/view/252)上也有专门的教程，大家也可以去看看。

但是可不可以不插入radio就实现对应的效果呢？ 答案是有的。

那就是利用[:target](https://developer.mozilla.org/en-US/docs/Web/CSS/%3Atarget)伪类，这个选择器可以选择当前活动的锚点,那么利用这个属性我们就可以实现自己想要的效果了。

代码如下：

```html
<a href="#tag1">Tag1</a>
<a href="#tag2">Tag2</a>
<a href="#tag3">Tag3</a>

<div id="container">
  <div id="tag1"></div>
  <div id="tag2"></div>
  <div id="tag3"></div>
</div>

```

```css

div {
  width: 100px;
  height: 100px;
  border-radius: 50%;
}
#container {
  margin-top: 10px;
  outline: 1px solid red;
  position: relative;
}
#tag1, #tag2, #tag3 {
  transition: all ease-out .2s;
  position: absolute;
  top:0
  left:0;
  right:0;
  bottom:0;
  opacity: 0;
  
}
#tag1 {
  background: #f66;
  opacity: 1;
  z-index: 1;
}
#tag2 {
  background: orange;
}
#tag3 {
  background: gray;
}
#container > div:target {
  z-index: 1000;
  opacity: 1;
}
```

[查看DEMO](https://jsfiddle.net/243kjL60/2/)

上面的例子是通过绝对定位配合z-index和透明度来实现的动态效果。先将所有的元素的opacity设为0，然后为了默认显示出来第一个元素，所以第一个元素的opacity为1，z-index为1。然后单击就可以实现动态切换了。

其实我最先尝试的是通过给```#container```设置```overflow: hidden;```, 为它的子元素设置```height:100%;```，然后给target设置margin-top为负的百分比值来实现相应效果的，毕竟比较喜欢这种从下往上冒或者从上往下掉的感觉嘛。。。但是在实现过程中遇到了一点小问题，那就是当Tag2和Tag3相互切换的时候，居然只会移动到一半就不再动了，如果把```overflow: hidden```去掉，显示的就是自己期望的效果。[一个有问题的DEMO](https://jsfiddle.net/bezbu3j2/) 

后来自己想到了解决的办法，那就是给container包裹一个div，然后把```overflow: hidden```设置在这个元素身上，再把container的overflow去掉，设置高度为它子元素的高度，这样就能显示正常了。 [DEMO在这里](https://jsfiddle.net/dc3svdvf/4/).

虽然找到了解决办法，但是对于[问题DEMO](https://jsfiddle.net/bezbu3j2/) 里的这种怪异行为真的不理解，如果各位谁知道的话，还请告知，谢谢。

参见：
[stackoverflow - 纯CSS滚动效果](http://stackoverflow.com/questions/17631417/css-pure-css-scroll-animation)