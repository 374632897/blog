---
title: 对象URL
date: 2019-12-21 08:46:19
tags: 每天学习一丢丢~
---
学习地址：[https://developer.mozilla.org/zh-CN/docs/Web/API/URL](https://developer.mozilla.org/zh-CN/docs/Web/API/URL)

<!-- more --> 
实例代码地址：[GitHub](https://github.com/374632897/demos/blob/master/html/object-url/compare.html)、[CodePen](https://codepen.io/374632897/pen/RwNpXPd?editors=1111)

URL 为 window 的一个属性， 具有三种用法：

- URL 作为构造函数使用 - new URL(url, [base])
- URL.createObjectURL(blob)
- URL.revokeObjectURL(objectURL)



<a name="1H2Qi"></a>
### 构造器
作为构造器使用时，可接收两个参数，第一个参数为url，如果url为绝对路径，则第二个参数会被忽略；如果url为相对路径，则需要第二个参数，若缺少第二个参数，那么会报错Invalid URL。
<img align=left height=244 width=666 src="https://cdn.nlark.com/yuque/0/2019/png/434020/1576918708879-8233bb2f-a0ed-4971-91c5-14601026c194.png" style="margin: 0 10px 0 0;" referrerpolicy="no-referrer" />

如果要获取 query 值，可以通过url.searchParams.get来获取
<img align=left height=38 width=217 src="https://cdn.nlark.com/yuque/0/2019/png/434020/1576918754116-0d34cee7-5cca-4d8c-a5fb-0f8220577ee6.png" style="margin: 0 10px 0 0;" referrerpolicy="no-referrer" />

其兼容性如下所示：
<img align=left height=403 width=1045 src="https://cdn.nlark.com/yuque/0/2019/png/434020/1576918817459-618f459b-c4cf-4206-835b-11f99b5ec447.png" style="margin: 0 10px 0 0;" referrerpolicy="no-referrer" />
可以看到， IE 系列的浏览器是不支持该属性的。



<a name="00O9z"></a>
### URL.createObjectURL(blob)
通常来讲， 需要使用本方法的时候是手动在前端进行了文件上传，并且希望及时的进行预览。除了本方法之外，在用户选择文件之后，可以通过FileReader对文件进行阅读， 使用readAsDataURL的方式，将文件内容转换为base64的形式，并将其作为img 的 src 以进行展示。然而该方法具有以下问题：

- 需要先使用FileReader对文件进行读取到JavaScript中，当文件内容比较大的时候，中间的时间难以保证（参见[DEMO](https://codepen.io/374632897/pen/RwNpXPd?editors=1111)，针对4M的文件， base64比object url 慢了10倍左右 )
- 生成的base64字符串可能会十分庞大，插入到DOM以后会多了很多无意义的内容
- 使用 base64 会占用对应的堆空间（参见[DEMO](https://codepen.io/374632897/pen/RwNpXPd?editors=1111)）

因此，针对需要在前端进行展示的场景，应尽可能地使用URL.createObjectURL()的方式来进行展示，而不是使用base64。通过该方式，最后获取到的是一个指向内存的相应地址，因为该字符串是一个URL，因此可以直接在DOM中使用，同时，也不用先将文件读取到JavaScript中。

兼容性如下：
<img align=left height=413 width=1031 src="https://cdn.nlark.com/yuque/0/2019/png/434020/1576922437474-6d9e345f-cce9-4f8f-b93d-7c49717d55fc.png" style="margin: 0 10px 0 0;" referrerpolicy="no-referrer" />
可以看到，IE10以上的浏览器均兼容。



<a name="vCnoF"></a>
### URL.revokeObjectURL()
**`URL.revokeObjectURL()` **静态方法用来释放一个之前已经存在的、通过调用 [`URL.createObjectURL()`](https://developer.mozilla.org/zh-CN/docs/Web/API/URL/createObjectURL) 创建的 URL 对象。当你结束使用某个 URL 对象之后，应该通过调用这个方法来让浏览器知道**不用在内存中继续保留对这个文件的引用了**。
你可以在 `sourceopen` 被处理之后的任何时候调用 `revokeObjectURL()`。这是因为 `createObjectURL()` 仅仅意味着将一个媒体元素的 `src` 属性关联到一个 [`MediaSource`](https://developer.mozilla.org/zh-CN/docs/Web/API/MediaSource) 对象上去。调用`revokeObjectURL()` 使这个潜在的对象回到原来的地方，允许平台在合适的时机进行垃圾收集。


