---
title: 聊一聊 Proxy
date: 2019-12-27 15:02:26
tags: 每天学习一丢丢~
---
> 给我一个万能的对象吧，她要能唱歌会跳舞，卖萌一级棒，会写代码还没有bug
> 咦，走错片儿场了，重新来
> 给我一个万能的对象吧，它能无限层次地随便访问属性，能当函数调用，还永远不会报错~


本周做了一个需求，扫描负责仓库下所用到的接口。通常来讲，这样的需求通过简单的查找就能完成，然而实际操作中存在以下问题：

<!-- more --> 

- 请求方式不一致 —— 通常来讲，大多数url的前缀都是一致的，因此为了便于后面的修改，我们可能会对这些一致的前缀进行抽象提取处理，而具体的抽象方式又不一致，比如以下几种：
  - 使用字符串拼接
  - 使用函数封装返回一个字符串

因此，直接通过关键字过滤的方法来扫描接口，基本上是不可行的。

既然每个文件最后都会export 一个方法，于是便想到了直接获取指定项目下的所有文件，通过动态require的方式，获取他们的exports，通过参数注入的方法，注入自定义的 request，从而进行扫描记录。

然而这样又会有一个问题，我们的项目中，对于一个请求，通常都会直接从state中获取相应的请求参数，如下所示：
```javascript
export const getUser = () => (dispatch, getState, { request }) => {
	const { userId } = getState().location.query;
  return request(uri, { query: { userId } })
}
```

在这个实例方法里，函数体内部会从 state 中获取location.query.userId，因此，getState函数就需要我们返回一个对象，该对象需要能够确保这一次state的访问能够成功 —— 如果报错的话，后面的request就不能执行，也就没法记录相应的url了。

针对这样一个单独的方法，我们可以返回相应的符合状态的对象，如：

```javascript
const getState = () => ({
	location: {
  	query: {
    	userId: 111
    }
  }
})
```

然而实际上，我们一个文件中可能是10+甚至更多的 export，而这样的文件也可能又数十上百个，如果再单独针对每一种场景都去这样处理的话，那通过工具扫描代码以便于节省人力的意义就没有了 —— 毕竟有这精力还不如直接一个接口一个接口的进行统计。

那么我们需要的是一个什么样的东西呢？

由于最终我们要解决的问题是需要确保函数体内的属性访问、方法调用都不会报错，从而使得函数能够执行到最后 —— 调用request方法，因此实际上我们需要的就是这样一个对象 —— 我可以任意地访问它的属性，以及访问它返回的属性的属性却不会报错，甚至能够安全地不受限制地进行访问。

一般来讲，针对一个对象而言，我们对它进行访问的时候，直接访问它的属性 —— 当然，这是废话，可是 ES5 告诉我们可以通过 Object.defineProperty 对对象的属性访问进行劫持，返回我们想让它返回的东西。而一旦聊到劫持，大概率我们会想到 Vue，以及 Vue 3.0 使用 Proxy 进行数据劫持。因此，答案也就呼之欲出了，使用 Proxy 应该是可行的。

考虑到我们的返回应该是可无限链式调用的对象，那么很明显，除了对于一开始的对象我们需要劫持，对于后续我们返回的对象，也是需要劫持的，因此代码可以这样写：

```javascript
const gen = (config) => new Proxy({}, {
	get(target, key) {
  	return gen(config)
  }
})
console.log(gen().name.age.gender.hobby)
```
执行代码一看，果然可行耶，也不会报错
<img align=left height=140 width=249 src="https://cdn.nlark.com/yuque/0/2019/png/434020/1577461305404-c61c44bd-eaae-4d1c-88dc-5a9f4dfbe99e.png" style="margin: 0 10px 0 0;" referrerpolicy="no-referrer" />

直到遇上了这段代码：

```javascript
const state = gen()

Number(state.userId)
```

然后报了这个错：
<img align=left height=89 width=464 src="https://cdn.nlark.com/yuque/0/2019/png/434020/1577461389240-4a835bc3-6818-450a-a762-bcdc2bc24edb.png" style="margin: 0 10px 0 0;" referrerpolicy="no-referrer" />

错误信息告诉我们 object is not a function ，可是找遍了整段代码，没有见到 object 啊，那是什么问题呢？

我们看一下当调用Number方法的时候会发生什么(参见[ECMA-262](http://www.ecma-international.org/ecma-262/9.0/index.html#sec-number-constructor-number-value))
<img align=left height=269 width=911 src="https://cdn.nlark.com/yuque/0/2019/png/434020/1577462030678-0bcae900-2f5b-47df-95cd-a3554ac8c42c.png" style="margin: 0 10px 0 0;" referrerpolicy="no-referrer" />
<img align=left height=583 width=830 src="https://cdn.nlark.com/yuque/0/2019/png/434020/1577462057147-e08b4edb-173c-45af-9571-b38017c02e3a.png" style="margin: 0 10px 0 0;" referrerpolicy="no-referrer" />
<img align=left height=558 width=937 src="https://cdn.nlark.com/yuque/0/2019/png/434020/1577462251462-c544cf2c-70fd-4394-9c58-8cfac22c5f01.png" style="margin: 0 10px 0 0;" referrerpolicy="no-referrer" />
规范告诉我们，当我们调用Number()方法，并且传递了一个对象的时候，会执行以下步骤：

- 通过toPrimitive(argument, hintNumber)方法，获取到 primValue
  - 这里是对象，所以最后会通过输入参数的toPrimitive方法来获取到一个返回值
- 返回toNumber(primValue)

而 toPrimitive 方法是一个内部方法，它使用了Symbol来定义了一个单独的变量作为方法名，通常情况下我们是无法获取到它的。

因此，我们需要hack一下，以便于获取到这个内部值

```javascript
const PrimitiveSymbol = getPrimitiveValue()

function getPrimitiveValue() {
  let toPrimitiveValue
  try {
    Number(
      new Proxy({}, {
        get(target, key) {
          if (typeof key === 'symbol') {
            PrimitiveSymbol = key
          }
        }
      })
    )
  } catch(e) {}
  return PrimitiveSymbol
}
```

接下来再对之前的代码进行一番改造：

```javascript

const PrimitiveSymbol = getPrimitiveValue()

const gen = (config) => {
  const ret = new Proxy({}, {
    get(target, key) {
      if (key === toPrimitiveSymbol) {
        return () => '111'
      }
      return ret;
    }
  })
  return ret;
}

const state = gen()

console.log(state.name.age.feature.log.info.error.cheese)

isNaN(state)
Number(state)
state / 2
state + 2;

/123/.exec(state)

parseInt(state, 2)
parseFloat(state)

state >>> 12
state | 123
state & 999

function getPrimitiveValue() {
  let PrimitiveSymbol
  try {
    Number(
      new Proxy({}, {
        get(target, key) {
          if (typeof key === 'symbol') {
            PrimitiveSymbol = key
          }
        }
      })
    )
  } catch(e) {}
  return PrimitiveSymbol
}

```

再执行一次，发现无错通过~

直到遇见了下面的代码

```javascript
export const createUser => () => (dispatch, getState) => {
  const { getUser } = getState()
  const user = getUser()
  // ....
}
```

于是又悲剧的报错了

<img align=left height=71 width=486 src="https://cdn.nlark.com/yuque/0/2019/png/434020/1577463103252-8b7385e5-eb75-4982-8390-a7c678441f05.png" style="margin: 0 10px 0 0;" referrerpolicy="no-referrer" />

我们万能的对象随便访问属性是可以的，然而当我把它当成函数调用的时候，就又报错啦
state 不是用来存放数据的吗， 为什么会有人在里面放函数？鬼知道为什么 - -
我们控制不了函数内部的调用，那就只好自己去适配了，那该怎么配呢 o(╯□╰)o

似乎一开始代理的就不应该只是一个单纯的对象，它应该是一个函数对象。
```javascript
const gen = (config) => {
  const ret = new Proxy(function(){}, {
    get(target, key) {
      if (key === PrimitiveSymbol) {
        return () => '111'
      }
      return ret;
    }
  })
  return ret;
}
```

然后我们的目的就达到了， 应该可以随便扫代码了。。。 吧。。

后记：
-今天每日阅读的两篇文章大概率是完不成了o(╯□╰)o

-其实Proxy的应用场景还是挺多的，这不 Vue 3.0 也快出了吗，用的 Proxy，我想知道应用到底创建了多少个 Proxy 应该怎么办呢？
```javascript
const OriginalProxy = Proxy;

let instances = 0
window.Proxy = new OriginalProxy(Proxy, {
  construct(...args) {
    instances++
    return Reflect.construct(...args)
  }
})

console.log(instances)
```


