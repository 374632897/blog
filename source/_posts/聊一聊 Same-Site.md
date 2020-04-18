---
title: 聊一聊 Same-Site
date: 2020-04-01 12:52:06
tags: 每天学习一丢丢~
---


<a name="xYJLg"></a>
## 什么是SameSite?


>    A request is "same-site" if its target's URI's origin's registrable

<!-- more --> 
>    domain is an exact match for the request's client's "site for
>    cookies", or if the request has no client.  The request is otherwise

>    "cross-site".

> 


>    For a given request ("request"), the following algorithm returns

>    "same-site" or "cross-site":

> 


>    1.  If "request"'s client is "null", return "same-site".

> 


>        Note that this is the case for navigation triggered by the user

>        directly (e.g. by typing directly into a user agent's address

>        bar).

> 


>    2.  Let "site" be "request"'s client's "site for cookies" (as defined

>        in the following sections).

> 


>    3.  Let "target" be the registrable domain of "request"'s current

>        url.
>    4.  If "site" is an exact match for "target", return "same-site".

> 


>    5.  Return "cross-site".

> 


>    The request's client's "site for cookies" is calculated depending

>    upon its client's type, as described in the following subsections:



如上文所示，只有当请求的站点的 origin 和 当前浏览器站点地址origin 完全匹配时，才叫做 same-site，具体采用以下策略：

- request client 为null（如用户直接在浏览器中输入url），则为same-site





<a name="caR0y"></a>
### 请求类型


<a name="9HzOh"></a>
#### 文档请求（Document-based requests）
只有用户自己输入的URL才是暴露给用户的唯一安全的上下文。该URL对应的domain也应该是用户信任的站点。我们将其标记为 top-level-site。


因此，对于这样的请求，其 “site for cookies” 可以认为就是 top-level-site。


对于top-level-site中嵌套的上下文，只有当每一个文档及其祖先文档的origin与当前top-level-site相同时，site-for-cookies才等于top-level-site，否则则为空字符串。




<a name="HJ9BT"></a>
#### Worker 请求


<a name="P3k1S"></a>
##### 专用以及共享的worker
专用的worker都绑定了唯一的文档，因此这种类型的worker发出的请求（importScripts、XHR、fetch等）其site-for-cookies 就是绑定文档的site。


共享的worker可能一次性绑定了多个文档，这些文档的 “site-for-cookies”值可能都不一致，在这种情况下，最后会返回一个空字符串，当所有值都相同的时候，则返回相同的这个值。


简而言之，只要有一个文档的 document-site 和 worker 注册的site 不一致，那么就返回空字符串。




<a name="rarjN"></a>
##### ServiceWorker
返回注册 worker 的 origin 的host






从 Chrome 51 开始，浏览器的 Cookie 新增加了一个SameSite属性，用来防止 CSRF 攻击和用户追踪。


`**Set-Cookie: CookieName=CookieValue; SameSite=Strict;**` 


该属性有三个值：Strict、Lax、None




<a name="S1loy"></a>
## 值




<a name="zlrzJ"></a>
### Strict
只有在第一方（宿主）上下文才会发送Cookie。第三方站点初始化的请求都不会携带Cookie。包含从宿主环境打开的链接 —— 如在a.b.com打开了，a.c.com的页面，那么在刚刚打开的这个页面中， SameSite 为 Strict 的 Cookie也不会被发送， 因为它是由B打开的。只有用户主动输入a.c.com的链接的情况下，SameSite 为 Strict 的Cookie才会被发送。
> 不确定是否是根据document.referrer判断的，因为该属性为只读属性





<a name="AjbJH"></a>
### Lax
TOP-LEVEL NAVIGATIONS 下的请求允许发送Cookie；以及被第三方站点初始化的get请求（导航到目标网址的 Get 请求）也允许发送 Cookie；现代浏览器默认为它。
<img align=left height=673 width=1920 src="https://cdn.nlark.com/yuque/0/2020/png/434020/1585746235216-bb779b81-b398-4299-a233-f0bf550bf837.png" style="margin: 0 10px 0 0;" referrerpolicy="no-referrer" />




<a name="TNDSs"></a>
### None
在所有的上下文当中 Cookie 都允许被发送，跨域也允许。
None 值在以前作为浏览器的默认值，但是在最近浏览器默认值变为了Lax，以防范CSRF攻击。
最新的浏览器要求在指定SameSite为None的同时，要求指定Secure属性；




<a name="ljITx"></a>
## 备注

- Node 要发送多个相同名称的Header（如Set Cookie）的haul，需要使用 `res.setHeader(headerName, valueArray)` 的方式，并且如果后续调用writeHead的话，不能重复添加相应的Header


<a name="xsiL8"></a>
### 示例代码：
```javascript
const http = require('http')
const content = require('fs').readFileSync('./index.html', 'utf-8')
const body = ``

http.createServer((req, res) => {
  console.log(req.headers)
  res.setHeader('Set-Cookie', ['lax=lax; SameSite=Lax', 'strict=strict; SameSite=Strict', 'uid5555=100;domain=.com;'])
  res.writeHead(200, {
    'Content-Type': 'application/json',
    // 请求携带凭据的时候，这里不能为*
    'Access-Control-Allow-Origin': 'http://a.b.com',
    // 当没有该请求头，但是实际请求发生的时候携带了凭证的话，也会报错
    'Access-Control-Allow-Credentials': true,
    'Access-Control-Allow-Methods': 'GET,POST',
    // allow-headers 非必须；传递了也不会有影响；
    // 'Access-Control-Allow-Headers': 'content-type,x-requested-with', /
    // 'Set-Cookie': ,
  })
  res.end(JSON.stringify({ status: 'ok' }))
}).listen(3002)

```


```javascript
const http = require('http')
const content = require('fs').readFileSync('./index.html', 'utf-8')
const body = ``

http.createServer((req, res) => {
  console.log('here......')
  // res.statusCode = 301
  // res.setHeader('Location', 'http://localhost')
  res.statusCode = 200;
  require('fs').createReadStream('./index.html').pipe(res)
  // res.end(content)
}).listen(3000)

```


```html
<!DOCTYPE html>
<html>
<head>
  <title>测试跨域233</title>
  <meta charset="utf-8">
</head>
<body>
<button id="btn"> 点我跨域</button>
<button id="post"> 点我跨域POST</button>
<a href="http://a.meituan.com/c/age">这是一个标签</a>

<script type="text/javascript">
  document.getElementById('btn').onclick = () => {
    fetch('http://a.meituan.com/getUser', {
      credentials: 'include',
    })
  }
  document.getElementById('post').onclick = () => {
    fetch('http://a.meituan.com/getUser', {
      method: 'post',
      credentials: 'include',
    })
  }
</script>
</body>
</html>

```


参考文档：

- [SameSite](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Set-Cookie/SameSite)

