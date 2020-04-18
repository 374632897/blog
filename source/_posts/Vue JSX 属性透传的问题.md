---
title: Vue JSX 属性透传的问题
date: 2020-03-13 03:15:34
tags: 每天学习一丢丢~
---
参见以下代码：

```javascript
function createButtons = (h, buttons) => props => {
	return (
    <span style="display: flex; justify-content: space-between;">

<!-- more --> 
      {buttons.map((item, index) => (
        <mtd-button
          {...{ attrs: item }}
          key={index}
          onClick={() => item.onClick(props)}
          disabled={item.__disabled}
        >
          {item.text}
        </mtd-button>
      ))}
    </span>
  )
}

```

```javascript
createButtons(this.$createElement, [
  {
    text: '修改',
    onClick: this.handleModify,
    size: 'small',
    disabled: props => {
      return auditStatus.isOffline(props.row.status)
    },
  },
])
```

编译后

```javascript
renderedButtons.forEach(function (item) {
      if (typeof item.disabled === 'function') {
        item.__disabled = item.disabled(props);
      } else if (typeof item.disabled === 'boolean') {
        item.__disabled = item.disabled;
      }
    });
    return h("span", {
      "style": "display: flex; justify-content: space-between;"
    }, [renderedButtons.map(function (item, index) {
      return h("mtd-button", {
        "attrs": _objectSpread({}, item, {
          "disabled": item.__disabled
        }),
        "key": index,
        "on": {
          "click": function click() {
            if (typeof item.onClick === 'function') {
              item.onClick(props);
            }
          }
        }
      }, [item.text]);
    })]);
```

最后，在我们点击修改按钮的时候，控制台报错：
<img align=left height=44 width=661 src="https://cdn.nlark.com/yuque/0/2020/png/434020/1584069608768-4858754d-5ab5-49f5-9d04-4e7c7f806705.png" style="margin: 0 10px 0 0;" referrerpolicy="no-referrer" />

```javascript
Uncaught SyntaxError: Function statements require a function name
```

在这里createButtons 中的某一项传递了onClick这个参数，那么在对应的渲染函数里面，最后传递给组件的是什么样的呢？

<img align=left height=236 width=458 src="https://cdn.nlark.com/yuque/0/2020/png/434020/1584069494907-9d16d049-804e-4233-aee2-cd6089530db5.png" style="margin: 0 10px 0 0;" referrerpolicy="no-referrer" />

handleModify 很好理解，就是我们希望绑定的事件，但是在上面的listeners里面，还添加了click事件，其对应的函数为
<img align=left height=183 width=358 src="https://cdn.nlark.com/yuque/0/2020/png/434020/1584069576328-6b080a8d-1272-44ed-b2fa-6549000dbc63.png" style="margin: 0 10px 0 0;" referrerpolicy="no-referrer" />

因此，上面的方式，最后会把 onClick 封装到 attrs里面。

在 Vue 组件挂载会后，首次更新时，Vue 会把相应的属性更新到 DOM 上.
<img align=left height=566 width=1243 src="https://cdn.nlark.com/yuque/0/2020/png/434020/1584094932644-aef4e315-6d46-4990-a672-57ceadae838a.png" style="margin: 0 10px 0 0;" referrerpolicy="no-referrer" />

因此，最后会调用 ele.setAttribute(key, value) 来设置组件的属性。这里的key value 都应该是一个[DOM String](https://developer.mozilla.org/zh-CN/docs/Web/API/DOMString)。在这里的场景下， key 是对应的 onClick 字符串，而 value 是一个函数，它被定义为了 Vue 组件上的一个方法。而 Vue 在实例化组件的时候，通过initMethods方法，把对应的 method 通过bind 的方式绑定了vm的上下文。因此，这里的 value，最后是一个Bound function。因此这里会把相应的函数转换为DOM String，具体的转换方法没有找到相应的文档，但是从转换结果来看，是调用了函数的toString方法。而bind返回的函数，它的toString方法，最后会返回一个表示native代码的字符串，也就是

```javascript
function () { [native code] }
```

因此，最后输出到html里的就变成了以下内容：

```html
<button onclick="function () { [native code] }">测试</button>
```

我们知道，在一个元素定义了onclick属性的情况下，点击的时候，会将其属性值当作js脚本来执行。因此，当我们点击按钮的时候，会执行上面的脚本

```javascript
function () { [native code] }
```

然而这个脚本是非法的，不说函数体，定义一个函数有函数表达式和函数声明两种方式，而上面的这种方式只能作为匿名函数被调用，在这里被当成了函数声明，因此就报错了。
<img align=left height=33 width=721 src="https://cdn.nlark.com/yuque/0/2020/png/434020/1584096578955-c936ce31-0948-4739-84c2-f977fa0a900a.png" style="margin: 0 10px 0 0;" referrerpolicy="no-referrer" />
Vue updateAttrs 
el.setAttribute(key, value)

总结：
当出现问题并且不知道导致问题发生的因素时，应先通过**二分法**快速定位到导致问题的代码，然后通过**控制变量，减少场景的影响因子，在控制变量的时候，更需要注意双边其他因子的一致性，**找到问题出现的原因，待解决问题后，再寻根溯源，找到产生问题的根本因素。

参考： 

- [https://html.spec.whatwg.org/multipage/webappapis.html#handler-onclick](https://html.spec.whatwg.org/multipage/webappapis.html#handler-onclick)
- [https://w3c.github.io/uievents/#event-type-click](https://w3c.github.io/uievents/#event-type-click)

