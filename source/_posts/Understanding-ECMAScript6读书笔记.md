---
title: Understanding ECMAScript6读书笔记
date: 2016-08-08 18:50:38
tags: 读书
---

# 关于`const`和`let`
* 没有变量声明提升， 存在TDZ，因此下列情况下会报错（使用`typeof`大多不会报错， 但是`const`和`let`是个例外）
<!-- more -->
```js
function say () {
  console.log(typeof name);// Uncaught ReferenceError: name is not defined
  const name = 123;
}
say();
```
* 不能在同一作用域内重复声明
* 在`for...in`和`for...of`循环里面， 每次的循环都会重新绑定上下文， 所以此时的变量声明应该用`const`来代替`let`，但是在`for`循环里就行不通了。
```js
const obj = {
  name: 'Jason',
  age: 22
}；
for (const key in obj) {
  console.log(obj[key]);
}
const arr = [1, 2, 3, 4, 5];
for (let i = 0, len = arr.length; i < len; i++) {
  console.log(arr[i]);
}
```
* 关于使用块级作用域的最佳实践就是默认使用`const`， 只有在你知道这个变量有可能发生变化的时候， 才使用`let`

# 关于字符串和正则表达式
* 涉及到`UTF-16`部分的知识， 因为用得很少， 所以就直接略过了。
* 正则表达式新增`u`标记， 用来表明进行`unicode`匹配?? 要检测浏览器是否支持该标记， 应该使用正则表达式的构造函数。
```js
function isSupportUFlag () {
  try {
    var re = new RegExp('.', 'u');
    return true;
  } catch (e) {
    return false;
  }
}
```
* 字符串新增检测方法
  * `includes` 注意是`includes`而不是`include` . 检测字符串是否包含指定字符
  * `startsWith` 注意是`startsWith`而不是`startWith`, 检测字符串是否以指定字符开始
  * `endsWith`注意是`endsWith`而不是`endWith`, 检测字符串是否以指定字符结束
  * 以上三种方法都接受两个参数， 第一个参数为字符串（注意：不能是正则表达式），第二个参数为开始的位置
  * 当第二个参数的值大于字符串长度的时候， 可以理解为将会忽略该参数（实际上此时`startsWith`和`includes`将会从字符串开始处进行查找， 而`endsWith`会从结尾处开始查找， 所以其实也是差不多的）。
* 字符串重复方法`repeat`, 参数为期待重复次数（重复为0的时候字符串为空）
* 正则表达式的`y`标识， 告诉引擎从指定的`lastIndex`开始进行匹配（应该是需要其每个都匹配，而不是跳跃性匹配）， 如果找不到匹配项， 将会停止匹配。
```js
var re = /hello\d\s?/y;
var str = 'hello1 hello2 hello3';
re.exec(str); // ["hello1 "]
re.lastIndex = 1; // 指定从字符串索引为1的位置开始进行匹配
re.exec(str);// null
```
* 正则表达式新增特性
  * 当使用正则表达式字面量来作为`new RegExp`的第一个参数的时候， 在`ES5`下， 第二个参数不能够为标识符， 但是在`ES6`下， 是可以的。但是要注意的是， 这样得到的正则表达式， 其标识符将完全由指定的第二个参数决定， 与原来的字面量无关。

  ```js
  var re = /hello/y;
  var _re = new RegExp(re, 'ig');
  console.log(_re); // /hello/gi // 注意这里排序了的， 另外， 其原有的y标识没了
  ```
  * 新增正则表达式的`flags`属性， 用于返回正则表达式的标识符

* 模板字符串
  * 在模板字符串里使用未经定义的变量的话会报错
  * 关于标签
    - 使用一个函数来定义标签
    - 使用的时候直接使用函数名``模板字符串即可

    ```js
    var test = (...args) => console.log(args);
    test`hello world`; // [Array[1]]
    ```
    - 该标签函数的第一个参数为字符串数组， 其每一项为模板字符串所用变量切割后组成的字符串， 其他参数则依次为由变量所解析出来的结果。
    - 书上面说的使用模板字符串可以实现转义效果，但是自己试了并不行， 不知道为什么。
    ```js
    String.raw`Multiline\nstring`; // 书上的结果是"Multiline\\nstring", 但是自己得到的结果还是"Multiline\nstring"
    ```

# 函数
* 函数默认参数。 只有在调用函数的时候没有在指定位置传递参数的情况下才会使用默认参数， 这个判断过程可以认为是通过`typeof`来判断的。也就是说， 只有在参数值为`undefined`的时候才会使用（特别指定为`undefined`或者说没有传递该参数的时候）默认参数。
```js
function test (a = 1, b = 2, c = 3) {
  console.log(a, b, c);
}
test(undefined, null, 0); // 1 null 0
```
* ES6下对函数参数的重赋值不会反映到函数的`arguments`对象上(自己试了下， 只有在严格模式下才不会)
* 函数的默认参数也存在TDZ， 也就是说， 在他们被初始化之前， 是不能够被访问的， 因此在函数参数里面， 一个参数只具有对其前面位置的参数的访问权限， 如果尝试访问后面的参数的时候， 就会报错。
```js
function add(first = second, second) {
  return first + second;
}
console.log(add(1, 1)); // 2
console.log(add(1)); // 书上的这里写了throws error ， 但是实际上这里不应该会报错的， 因为指定了第一个参数， 那么就不会调用first = second. 所以也就不会访问第二个参数， 因此第二个参数是undefined， 所以最后的结果应该是NaN， 实际上检测出来的也是这种情况。
console.log(add(undefined, 1)); // 要想触发报错的话， 可以手动指定第一个参数为undefined， 所以， 感觉上这种情况应该会比较少
```
* `rest`参数
  * `rest`只能有一个， 并且必须在最后
  * 在对象字面量的`setter`里面是不能够使用`rest`参数的（书上是这样写的， 但是自己尝试了以后发现是可以的）， 因为`setter`函数被限制为只能够接受1个参数。 PS: 方式不对
  ```js
  // 错误的方式
  var obj = {
    set (...rest) {
      console.log(rest); // 这里set只是其一个方法， 并没有涉及到setter
    }
  }
  // 正确的报错打开方式
  class A {
    set name (...rest) { // 此时才算是调用了setter
      // Setter function argument must not be a rest parameter
      this.name = rest;
    }
  }
  ```
  * `spread`可以用于将数组内容展开。
  ```js
  var arr = [1, 2, 3, 4, 5, 6];
  Math.max(...arr); // 相当于是把数组两遍的方括号去掉
  ```
* 函数的`name`属性
  * 如果函数有name(`function`关键字后面的词)， 则其name属性为其name， 若有函数名， 则为函数名
  * 匿名函数的name在没有指定name的情况下为`anonymous function`
  * 使用`bind`绑定了上下文的函数其name属性会被添加`bound `前缀
  * name属性只是起到一个标识的作用以便于调试， 并不能够通过name来获取到一个函数的引用。
* 函数调用的两种方法
  * 在调用函数的时候如果使用了`new`操作符， 那么就会调用函数的[[construct]]方法
  * 如果没有使用`new`操作符， 那么将会调用函数的[[call]]方法。
  * 箭头函数不能用作构造函数， 也就是说不能够使用`new`操作符
  * `new.target`: 在使用了new操作符的时候，`new.target`的将会指向这个函数， 否则将会是`udnefined`.
  * 在函数体外面使用`new.target`将会抛出语法错误
* 块级函数
```js
console.log(typeof s1ayName);// undefined;
if (true) {
  console.log(typeof sayName); // function
  function s1ayName () {}
}
console.log(typeof s1ayName); // 在严格模式下， 这里是undefined, 非严格模式下这里是function
```
* 箭头函数
  * 没有`this`, `super`, `arguments`, `new.target`绑定。 箭头函数内的这些值都由距离该函数最近且包含该函数的非箭头函数所决定。
  * 不能对箭头函数使用`new`操作符（箭头函数不具有`[[construct]]`方法）
  * 没有原型对象（prototype）。
  * 不能改变this（普通函数作为构造函数的时候其this是指向新构建的对象的）
  * 没有arguments对象作为函数参数列表
  * 没有重复命名参数（No duplicate named arguments）， 这个不大懂
  * 箭头函数语法上需要注意的一些地方
    - 箭头函数里的花括号主要用于标识函数体， 当你希望返回一个对象的时候， 需要将该对象用圆括号包裹。

    ```js
    var get = id => ({ name: 'Jason', age: 22 });
    ```
    - 对箭头函数使用自调用立即执行函数表达式（IIFE -- imediately invoked function expressions）的时候， 需要使用圆括号将函数体包裹起来。
* 尾调用优化（Tail call Optimization）
  * 尾调用的函数不会访问当前调用栈中的变量， 也就是说当前的函数不是一个闭包
  * 在尾调用执行后没有其他操作
  * 尾调用的值会作为函数值返回（需要有return）
  * 例如， 以下情况下不会有尾调用优化：
    - 函数尾调用另一个函数的时候没有返回该函数执行结果的值
    - `return`语句里有除了函数调用之外的其他操作
    - 另外， 在把一个函数的执行结果保存为变量，然后再返回这个变量的话， 也不会有尾调用优化（尾调用函数的结果需要立即返回）
    - 闭包
* 怎样管理尾调用优化
  * 尾调用优化常用于函数递归

# 对象函数展开式
* 对象简写 --- 可以使用`super`, 非简写形式不行。 此外， 简写形式下不能使用bind

```js
var obj = {
  sayName () {
    return "Jason";
  }
}
```
* 改变对象原型
  * 通常情况下， 对象的原型会在对象创建的时候通过构造器或者Object.create()方法来指定
  * `Object.setPrototypeOf(object, prototype)` 方法允许你通过给定的对象来改变原型(将prototype设为object的原型对象）
  * 对象的原型对象保存在内部属性[[prototype]]中

* 使用超类（super）引用进行更简单的原型对象访问
  * 最简单的使用便是通过super来访问当前对象的原型对象

  ```js
  var base = {
    say () {
      console.log('base');
    }
  };
  var c = {
    say () {
      super.say();
      console.log('c')
    }
  };
  Object.setPrototypeOf(c, base);
  c.say();
  // 'base'
  // 'c'


  // var friend = {
  //  say () {
  //    return super.say(); // 类似于Object.getPrototypeOf(this).say.call(this)；
  //  }
  //}；
  ```
  * 对象的方法仅仅是使用函数来代替数据作为对象属性值。 ES6定义了一个内部属性[[HomeObject]]来指明对象方法的归属。
  * 当函数并非一个对象的方法的时候， 不能够使用super

* 对象解构
  * 在不使用声明的方式而是直接重新解构赋值的时候， 需要用圆括号包裹解构部分`({ type, name } = node);`(用于告诉引擎这部分并不是块级语句， 只是一个表达式)
  * 在解构的时候如果表达式右边是`null`或者`undefined`， 则会报错
  * 一个值得注意的问题， 看下面的代码

  ```js
  var node = {
    type : 'Identifier',
    name: 'foo'
  }, type = 'Literal', name = 5;
  function outputInfo(value) {
    console.log(value === node)
  }
  outputInfo({ type, name } = node) // true // 这里对type和name进行了重赋值， 所以下文的也有改变
  type // Idetifier
  name // foo
  ```
  * 可以通过使用`=`来指定默认参数， 默认参数只有在缺少该参数， 或者参数值为`undefined`的时候才会被调用
  * 指定变量名 + 默认值

  ```js
  var node = {
    type: 'Identifier'
  };
  var { type: lcoalType, name: localName = 'bar' } = node;
  localName // bar
  ```
  * 在解构中， 有冒号的地方， 就表示冒号后面的部分为其对应值的展开式（冒号右边即为对应值）
  * 在解构中， 空的花括号是合法的， 但是使用这个并不会有任何效果

  ```js
  var { loc: {} } = node; // 没有任何一个变量被声明。
  ```
* 数组解构
  * 最常用的一个便是交换变量值

  ```js
  var a = 1, b = 2;
  [a, b] = [b, a];
  a // 2
  b // 1
  ```
  * 数组的复制

  ```js
  var arr = [1, 2, 3, 4, 5];
  // 以前
  var arr2 = arr.concat();
  // 现在可以这样写
  var arr3 = [...arr];
  ```
  * Rest参数必须要在数组解构的最后， 并且后面不能跟逗号， 否则抛出语法错误

* 函数参数解构
  * 111

# Symbols
* Symbol是一种原始数据类型， 并且是唯一一种没有字面量的原始数据类型
* 因为Symbol是原始类型，所以调用的时候如果使用了new操作符， 将会报错
* Symbol接受一个参数来作为其描述， 该参数本身并不能作为属性访问器， 主要用于阅读及调试的便利（作为标识符）
* 作为原始类型， Symbol是可以使用typeof 操作符来判断类型的
* 不能对Symbol进行数学运算， 否则会报错， 但是可以对其使用逻辑操作符， 此时， symbol会被转化为true
* Symbol不会通过Object.keys()来返回， 可以通过Object.getOwnProperyNames()来获取
* 当你要创建一个可共享的Symbol的时候， 可以使用Symbol.for()， 它接受唯一的字符串参数作为其标识符。 当使用这个的时候， 会首先查找全局Symbol查看是否注册， 如果注册了， 则直接返回该Symbol， 否则， 则创建一个并注册。
```js
var s1 = Symbol.for('1');
var s2 = Symbol.for(1);
s1 === s2 // true  注意，因为Symbol接受的参数为字符串， 所以传递数值的时候被转化为字符串了
Symbol.keyFor(s1); // '1'
Symbol.keyFor(s2); // '1' // 字符串
```
* 知名Symbols (well-known symbols)（@@create => Symbol.create）
  * @@hasInstance -- instanceof   `obj instanceof Array => Array[Symbol.hasInstance](obj)`;
  * @@isConcatSpreadable  --- Array.prototype.concat()   `此属性用于表明对象作为concat()方法的参数的时候， 是否把里面的每一项作为单独元素添加进目标数组里`

  ```js
  var col = {
    0: 'hello',
    1: 'world',
    length: 2
  }, c = ['hi'];
  c.concat(col); // ["hi", Object]
  col[Symbol.isConcatSpreadable] = true;
  c.concat(col); // ["hi", "hello", "world"]
  ```
  * @@iterator --- 返回一个迭代器
  * @@match --- String.prototype.match()  --- 接受字符串参数， 有匹配则返回数组， 否则返回null
  * @@replace --- String.prototype.repalce() --- P149
  * @@species --- 决定一个对象应该怎么生成的构造器
  * @@split --- String.prototype.split();
  * @@toPrimitive --- 返回对象原始值的方法, 接受一个参数`hint`用来表明应该返回哪种数据类型（三种模式： string, number, default --- 在对对象使用 '=='或者'+'的时候， 使用默认模式）

  ```js
  var B = function (age) {
    this.age = age;
  };
  B.prototype[Symbol.toPrimitive] = function (hint) {
    switch (hint) {
      case 'number':
        return this.age;
      case 'string':
        return this.age + '';
     default:
       return this.age + 'years old';
   }
  };
  var b = new B();
  +b; // 12
  '' + b; // "12years old"
  String(b); // '12'
  ```
  * @@toStringTag --- 使用Object.prototype.toString.call()或者String.prototype.toString()时返回对象描述

  ```js
  function Person (name) { this.name = name}
  var  p = new Person('Jason');
  Person.prototype[Symbol.toStringTag] = 'Person';
  Object.prototype.toString.call(p); // "[object Person]"
  p.toString(); // "[object Person]"
  ```
  * @@unsopables --- an object whose properties are the names of object properties that should not be included in a with statement.  主要针对 `with`语句。 P157
  * 重写由well-known symbols定义的方法， 可以将普通对象改变为外来对象从而改变内部默认行为
  * 重写方法需要使用`Object.defineProperty()`

# Sets And Maps
* Set是一个不包含重复值的列表
* Map是一个包含键值对的集合
* `Object.create(null)`得到的对象是没有原型对象的（原型为null
* Set
  * 如果多次给Set添加重复值， 那么第一次之后的行为将会被忽略
  * 可以在new Set的时候传递一个数组来对Set进行初始化
  * 方法： add, delete, clear,has,forEach(三个参数： item, index, Set本身， 第一个参数和第二个参数是相同的)
  * forEach可以接受第二个参数作为回调函数里的this
  * 将set转化为数组： var arr = [...set]
* WeakSet
  * WeakSet只存储弱对象引用（也就是说， 如果除weakSet之外， 没有其他地方引用到该对象的话， 那么weakSet将会删除它）， 不能用于存储原始类型的值。
  * 只有三种方法： add, delete, has
* Map
  * 方法： delete, has, get, set, forEach, clear
  * 初始化： 接受一个数组， 数组里的每一项也是一个数组， 子数组的第一项为key, 第二项为value
* WeakMap
  * 键（key）必须为非null对象， 不能是原始值
  * 这里碰到一个问题

  ```js
  var t = new WeakMap();
  var o = {};
  t.set(o, 'test');
  o = null;
  // 按照道理来说， o的引用被删除之后， t的对应键值也应该被删除啊
  // 原来是因为垃圾收集的周期性， 当解除引用之后， 只有在下一次垃圾收集的时候才会被删除， 这个可以通过手动调用垃圾收集来查看
  t; // WeakMap {Object {} => "test"}
  ```
  * Set和Map的实例有size属性， 但是WeakSet和WeakMap的实例是没有该属性的。
* 私有对象数据
```js
var Person = (function () {
  var privateData = new WeakMap();
  function Person (name) {
    privateData.set(this, {name: name})

  }
  Person.prototype.getName = function () {
    return privateData.get(this).name
  }
  return Person
})();
```
* 使用`Map`还是`WeakMap`
  * 需要使用对象作为键名的时候最佳选择是`WeakMap`
  * 优先使用`WeakMap`， 因为它会优化你的内存使用和避免在一个数据不再访问的情况下出现内存泄露的问题。
  * `WeakMap`的内容拥有非常小的可见性， 因为它只能通过get方法来访问， 而不具有forEach, clear()， size等方法或者属性来管理内容， 如果你需要知道他们的容量的话， 那么`Map`会更加合适， 但是此时需要注意内存的使用情况
  * 如果你需要使用非对象作为键名的话， 那么两者之间你只能选择`Map`
* `Set`, `Map`, `WeakSet`, `WeakMap`判断是否是根据`Object.is`来判断是重复键的

# 迭代器(Iterator)和生成器(Generator)
* 迭代器
* 生成器
  * 生成器是一种能够返回迭代器的特殊函数
  * 在`function`关键字的后面使用星号来进行标识
  * `yield`关键字可以指定每次迭代器应该返回的值。
  * 每次执行完一次`yield`之后， 函数都会停止执行， 在下一次next()的时候， 再恢复执行
  * 生成器表达式：
  ```js
  var g = function *(items) {
    for (var i = 0, len = items.length; i < len; i++) {
      yield items[i];
    }
  };
  ```
  * 不能使用箭头函数创建生成器
* for of
  * 该语句将会着眼于集合内容而非索引(for key of arr, 那么key则为索引上的那个值， 而非索引本身)
  * 对于没有实现iterator接口， 及null, undefined使用for..of将会报错
* 访问默认迭代器
```js
var arr = [1`,2, 3, 4, 5, 6];
var i = arr[Symbol.iterator]();
i.next(); // Object {value: 1, done: false}
```
* 检测是否实现iterator接口
```js
function isIterable (obj) {
  return typeof obj[Symbol.iterator] === 'function';
}
```
* 创建iterable
```js
var collection = {
  items: [1,2,3,4,5,6],
  * [Symbol.iterator] () { // 注意星号和方括号
    for (let item of this.items) {
      yield item;
    }
  }
};
for (let value of collection) console.log(value);
// 1 2 3 4 5 6
```
* 集合的Iterator
  * Array, Map, Set的实例是默认实现了Iterator接口的
  * 上述三种类型都有三种相同的内置迭代器
  * entries()  --- 返回键值对
  * values()  --- 返回值
  * keys() --- 返回键
  * 使用的时候都是`for (let item of arr.entries())
  * 每一种集合都有一种默认的迭代器， Array和Set的是values(), Map的是entries()`
  * 字符串迭代器
  * NodeList迭代器
* 给迭代器传递参数
```js
function *add () {
  let first = yield 1;
  let second = yield first + 2;
  yield second + 3;
}
var a = add();
a.next(); // Object {value: 1, done: false}
a.next(4); // Object {value: 6, done: false}
a.next(5); // Object {value: 8, done: false}
```

**但是第一次迭代的时候给next()传递参数是无效的**
在生成器里面， 第一次迭代之后yield的返回值由调用next()的时候传递的参数决定。

* 迭代器错误这里还有点问题 --- P202
* 生成器里的return语句
生成器里一旦包含return语句， 那么在到达那里的时候， 就会直接结束迭代器的迭代状态， 也就是说，在这次的产出值里， done的值为true, 无论迭代是否完成， 如果return 提供了值， 那么value将会是该值， 否则为undefined
使用return指定的值只能使用1次， 下次调用next()方法的时候， 其值会被重置成undefined;

**所有被return指定的值都不会出现在for...of和扩展操作符中， 因为此时的done的状态是true, 而一旦done为true， 他们就不会读取value**

* 生成器代理
  * 在一个生成器里yield 另外一个生成器， 注意的是， yield的后面也要跟星号。
  * 此时他们会按照次序依次执行。
  * 此时， 子生成器里的return的值会作为yield该生成器的值
  * Generator Task Runner P212

# Class
* class的contructor方法等价于构造器
* class只是一颗语法糖
* class声明不同于函数声明， 没有声明提升， 它类似于let声明（所以重复声明会报错）
* class里的代码都会运行于严格模式下
* 所有的方法都是不可枚举的。
* 所有的方法都不具有[[construct]]内部属性， 所以不能使用new操作符
* 对使用class声明的构造器， 没有使用new操作符， 会报错
* 在class内部方法内重写class的名称将会抛出错误
* 含有name属性的class
其name属性只能在class内部方法内使用
* 访问器属性
  * 私有属性应该在constructor里面创建， 同时也可以在原型上定义访问器属性。
  * 要创建getter， 使用关键字get， 后面跟上空格 ， 再加上标识符, getter属性是不可枚举的
* class 里面使用生成器
```js
var Col = class {
  constructor () {
    this.items = [];
  }
  * [Symbol.iterator] () {
    yield *this.items.values();
  }
};
var c = new Col();
c.items.push(1,2,3,4);
[...c]; // [1, 2, 3, 4]
```
* 静态成员
  * 使用static, 静态成员是直接定义在构造器上的方法， 与不受实例影响， 通常情况下， 一个构造器里可能调用， 但是和实例没有直接关系的方法， 就可以使用静态方法。
  * 静态成员不能被实例访问， 只能直接在class内部访问静态成员
* 继承
  * 类通过使用相似的`extends`关键字来实现从指定的构造器继承 。 通过在constructor里使用super()关键字， 可以访问基类。
  * 在继承当中， 如果没有指定constructor ， 那么super()将会自动调用
* 使用super的时候需要注意西夏几点：
  * 只能在派生类（继承）当中使用super
  * 在constructor里面使用this之前，必须先调用super()以初始化this
  * 避免调用suepr的唯一方法就是在constructor里面返回一个对象。

* 重写父类方法
  * 通过在子类中使用与父类相同的方法名， 就可以重写父类的方法
  * 可以通过super来访问父类的方法，如： `super.getName()`
