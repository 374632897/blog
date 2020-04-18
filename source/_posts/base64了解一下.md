---
title: base64了解一下
date: 2019-12-22 02:33:14
tags: 每天学习一丢丢~
---
代码：[https://github.com/374632897/demos/blob/master/encrypt/base64.js](https://github.com/374632897/demos/blob/master/encrypt/base64.js)

<!-- more --> 

在平时的工作中，base64使用场景比较多，比如文件上传。那么，base64到底是个什么东西？

通常来讲，我们平时使用的字符集是utf-8，而对于JavaScript中的binary string 而言，其使用的是ASCII扩展字符集。标准的ASCII字符集只有128个字符（2^7），而ASCII扩展字符集则包含了256个字符。

使用String.prototype.charCodeAt 方法，可以获取到相应字符的码点。

而base64，其字面意思就是使用64个字符来对输入内容进行描述（实际上应该是65个字符，A-Za-z0-9，以及+/总共64个字符，但是最后可能还需要使用=进行补位）。对于二进制字符串来说，可能包含256个字符，所以当使用base64来对二进制字符串进行编码的时候，就需要将256个字符描述的内容使用64个字符来进行描述。

简单来讲，就是**把3个8bit的数据用4个6bit的数据来进行表示。**

我们知道， 256 = 2 ^8，64 = 2 ^6, 因此当我们把二进制字符串的每个字符使用二进制来进行描述，并确保其填充到8位之后，再将相应的字符串以6位为单位进行分组，针对分组后的字符串再进行填充，填充到8位，这样就可以用64位字符编码来对其进行描述了。

**在电子邮件中，每隔76个字符，还需要添加一个回车来进行换行。**

以下以字符串“He”为模板进行步骤描述：

1. 输入字符串 'He'
1. 针对每个字符串，调用`String.prototype.charCodeAt`方法，获取其码点   
```javascript
const charsCode = 'He'.split('').map(item => item.charCodeAt(0))
// [72, 101]
```

3. 将获取到的码点用二进制来表示，并填充成8位
```javascript
const binaryAry = charsCode.map(item => item.toString(2))
// ["1001000", "1100101"]
// ["01001000", "01100101"]
```

4. 将获得的二进制字符串数组进行合并并以6个为单位进行分组，在这里需要注意的是，**如果合并后的二进制字符串不是3的整数的话，那么需要在末尾用0来进行填充**
```javascript
["01001000", "01100101"]
'0100100001100101'.length // 16
'010010000110010100' // 末尾填充
// 010010 000110 010100
```

5. ~~针对分组后的字符串，使用0将其填充到8位~~
```javascript
// 010010 000110 010100
// 00010010 00000110 00010100
```

6. 将最后得到的二进制字符串转换为十进制
```javascript
// 010010 000110 010100
'010010 000110 010100'.split(' ').map(item => parseInt(item, 2))
// [18, 6, 20]
```

7. 将得到的十进制数字从base64字母表中进行查找，得到对应的字符
```javascript
a.map(item => b64Ary[item])
// ["S", "G", "U"]
```

8. **判断得到的结果是否为4的倍数，如果不是，使用=号进行补位 或者说 原数据的长度是否为3的倍数，如果不是则补位（为1，则为两个==，为2则为1个=）**
```javascript
// ["S", "G", "U"]
// SGU
// SGU=
```

最后，转换完成，将 He 转换为了 SGU=

从上面的步骤来看，可能我们会有以下疑问：

- 第4步中为什么合并后的字符串需要是3的倍数？

因为需要将3个字节编码为4个字节

- 第8步中为什么最后的base64字符串需要为4的倍数？

同上，最后一段base64编码代表的是若干个字符，而编码规则便是以4为单位的

- 以上考虑的是针对二进制的，那么针对utf-8的字符串，要做base64处理的话，应该怎么做呢？

**在使用base64编码后，编码后的数据相比于原数据会多出大概1/3的内容，因为原本的3个字符变成了4个字符，因此（4 - 3）/ 3 = 1/3**
**
另外一种实现方式：[https://github.com/mathiasbynens/base64/blob/master/src/base64.js](https://github.com/mathiasbynens/base64/blob/master/src/base64.js)
[带注释的版本](https://en.wikibooks.org/wiki/Algorithm_Implementation/Miscellaneous/Base64#Javascript)
```javascript
var encode = function(input) {
		input = String(input);
		if (/[^\0-\xFF]/.test(input)) {
			// Note: no need to special-case astral symbols here, as surrogates are
			// matched, and the input is supposed to only contain ASCII anyway.
			error(
				'The string to be encoded contains characters outside of the ' +
				'Latin1 range.'
			);
		}
		var padding = input.length % 3;
		var output = '';
		var position = -1;
		var a;
		var b;
		var c;
		var buffer;
		// Make sure any padding is handled outside of the loop.
		var length = input.length - padding;

		while (++position < length) {
			// Read three bytes, i.e. 24 bits.
			a = input.charCodeAt(position) << 16;
			b = input.charCodeAt(++position) << 8;
			c = input.charCodeAt(++position);
			buffer = a + b + c;
			// Turn the 24 bits into four chunks of 6 bits each, and append the
			// matching character for each of them to the output.
			output += (
				TABLE.charAt(buffer >> 18 & 0x3F) +
				TABLE.charAt(buffer >> 12 & 0x3F) +
				TABLE.charAt(buffer >> 6 & 0x3F) +
				TABLE.charAt(buffer & 0x3F)
			);
		}

		if (padding == 2) {
			a = input.charCodeAt(position) << 8;
			b = input.charCodeAt(++position);
			buffer = a + b;
			output += (
				TABLE.charAt(buffer >> 10) +
				TABLE.charAt((buffer >> 4) & 0x3F) +
				TABLE.charAt((buffer << 2) & 0x3F) +
				'='
			);
		} else if (padding == 1) {
			buffer = input.charCodeAt(position);
			output += (
				TABLE.charAt(buffer >> 2) +
				TABLE.charAt((buffer << 4) & 0x3F) +
				'=='
			);
		}

		return output;
	};
```

参考：

- [维基百科 - Base64](https://zh.wikipedia.org/wiki/Base64)

