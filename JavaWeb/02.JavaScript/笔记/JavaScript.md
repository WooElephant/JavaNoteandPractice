# JavaScript

## JavaScript介绍

> * Javascript 语言诞生主要是完成页面的数据验证。因此它运行在客户端，需要运行浏览器来解析执行JavaScript 代码
> * JS 是Netscape 网景公司的产品，最早取名为LiveScript;为了吸引更多java 程序员。更名为JavaScript
> * JS 是弱类型，Java 是强类型

> 1. 交互性（它可以做的就是信息的动态交互）
>
> 2. 安全性（不允许直接访问本地硬盘）
> 3. 跨平台性（只要是可以解释JS 的浏览器都可以执行，和平台无关）



## JavaScript和HTML代码结合

### 方式一

> 在head标签中，或者在body标签中，使用script标签来书写JavaScript代码

```html
<script type="application/javascript">
    alert("hello javaScript");
</script>
```

### 方式二

> 使用script标签引入单独的JavaScript代码文件

```js
//1.js
alert("hello！")
```

```html
<script type="application/javascript" src="1.js"></script>
```

> 以上两种方法二选一使用，不能同时使用

```html
<script type="application/javascript" src="1.js"></script>
<script type="application/javascript">
    alert("hello 2")
</script>
```

> 或者写两个script标签



## 变量

> * 数值类型：number
> * 字符串类型：string
> * 对象类型：object
> * 布尔类型：boolean
> * 函数类型：function

### 特殊值

> undefined：未定义，所有js变量未赋予初始值的时候，默认值都是undefined
>
> null：空值
>
> NAN：not a number 非数字，非数值

### 定义变量

```js
var 变量名；
var 变量名 = 值；
```

```js
var i;
alert(i);//undefined
i = 12;
alert(i);//12
alert(typeof (i));//number
i = "abc";
alert(typeof (i));//string

var a = 12;
var b = "abc";
alert( a * b );//NaN
```

### 关系运算

> 有两个跟Java中不一样的运算符
>
> 等于：== 做字面值的比较
>
> 全等于：=== 除了做字面值的比较，还会比较变量的数据类型

```js
var a = "12";
var b = 12;
alert( a == b );//true
alert( a === b ); //false
```

### 逻辑运算

> 在JavaScript语言中，所有的变量，都可以作为一个boolean类型的变量去使用
>
> 0、null、undefined、“”（空字符串） 都认为是false

```js
var a = 0;
if (a) {
    alert("0为真");
}else {
    alert("0为假");
}

var b = null;
if (b) {
    alert("null为真");
}else {
    alert("null为假");
}

var c = undefined;
if (c) {
    alert("undefined为真");
}else {
    alert("undefined为假");
}

var d = "";
if (d) {
    alert("空串为真");
}else {
    alert("空串为假");
}
```

> && 与运算
>
> 1. 当表达式全为真，返回最后一个表达式的值
> 2. 当表达式有一个为假，返回第一个为假的表达式的值

```js
var a = "abc";
var b = true;
var c = null;
var d = false;

alert( a && b );//true
alert( b && a );//abc

alert( a && d );//false
alert( a && c );//null
alert( a && d && c );//false
```

> || 或运算
>
> 1. 当表达式全为假时，返回最后一个表达式的值
> 2. 只要有一个表达式为真，返回第一个为真的表达式的值

```js
var a = "abc";
var b = true;
var c = null;
var d = false;

alert( d || c );//null
alert( c || d );//false

alert( a || c );//abc
alert( b || c );//true
```



## 数组 （重点）

### 定义

```js
var 数组名 = [];
var 数组名 = [1,'abc',true];
```

```js
var arr = [];
alert( arr.length );//0

arr[0] = 12;
alert( arr[0] );//12
alert(arr.length);//1

arr[2] = "abc";
alert(arr[2]);//abc
alert(arr.length);//3

alert(arr[1]);//undefined
```

> 在JS中
>
> 只要我们通过下标赋值，那么最大的下标值就会自动给数组扩容



### 遍历

```js
for (var i = 0; i < arr.length; i++) {
    alert(arr[i]);
}
```



## 函数 （重点）

### 定义

#### 第一种

> 使用function关键字定义函数

```js
function 函数名(形参列表){
    函数体
}
```

```js
function fun(){
    alert("无参函数被调用了");
}
fun();

function fun2(a,b){
    alert("有参函数被调用了 a=" +a+ " b=" +b);
}
fun2(1,"a");

function sum(a,b){
    var result = a + b;
    return result;
}
alert( sum(1,2) );
```

#### 第二种

```js
var 函数名 = function(形参列表){函数体}
```

```js
var f1 = function () {
    alert("f1")
}
f1();

var f2 = function (a, b) {
    alert("a=" + a + " b=" + b);
}
f2(1,2);

var f3 = function (a,b){
    return a + b;
}
alert(f3(1,2));
```

#### 注意

> 在Java中允许函数重载
>
> 但是在JS中，函数重载会覆盖掉上一次的定义

```js
function f1(a,b) {
    alert("a="+a+" b="+b)
}
function f1(){
    alert("f1")
}
f1(1,2);//f1
```

#### arguments隐形参数

> 在函数中不需要定义，但却可以直接用来获取所有参数的变量

```js
function f1(){
    alert(arguments.length);
    
    alert(arguments[0]);
    alert(arguments[1]);
    
    for (var i = 0; i < arguments.length; i++) {
        alert(arguments[i]);
    }
}
f1(1,2);
```

## 自定义对象

### Object形式

```js
var 变量名 = new Object();
变量名.属性名 = 值;
变量名.函数名 = function(){}
```

```js
var o1 = new Object();
o1.name = "张三";
o1.age = 18;
o1.f1 = function (){
    alert("姓名："+this.name+" 年龄："+this.age);
}

alert(o1.name);
alert(o1.age);
o1.f1();
```

### {}形式

```js
var 变量名 = {
    属性：值，
    属性：值，
    函数名：function(){},
    ...
};
```

```js
var o1 = {};
o1.name = "张三";
o1.age = 18;
o1.f1 = function (){
    alert("姓名："+this.name+" 年龄："+this.age);
}

alert(o1.name);
alert(o1.age);
o1.f1();
```

```js
var o1 = {
    name : "张三",
    age : 18,
    f1 : function (){
        alert("姓名："+this.name+" 年龄："+this.age);
    }
};

alert(o1.name);
alert(o1.age);
o1.f1();
```



## 事件

> 电脑输入设备与页面进行交互的响应，我们称之为事件



### 常用的事件

> * onload 加载完成事件： 页面加载完成之后，常用于做页面js 代码初始化操作
> * onclick 单击事件： 常用于按钮的点击响应操作
> * onblur 失去焦点事件： 常用用于输入框失去焦点后验证其输入内容是否合法
> * onchange 内容发生改变事件： 常用于下拉列表和输入框内容发生改变后操作
> * onsubmit 表单提交事件： 常用于表单提交前，验证所有表单项是否合法



### 事件注册

> 告诉浏览器，当事件响应后要执行哪些操作代码，叫事件注册或事件绑定

#### 静态注册事件

> 通过html 标签的事件属性直接赋于事件响应后的代码，这种方式我们叫静态注册

```html
<body onload="alert('静态注册onload事件')">
</body>

<!--或者包装成一个方法-->
    <script type="application/javascript">
        function onloadFun(){
            alert("onload事件");
        }
    </script>
</head>
<body onload="onloadFun()">
```

> 静态注册onload事件
>
> 是浏览器解析完页面之后，就会自动触发

#### 动态注册事件

> 是指先通过js 代码得到标签的dom 对象
>
> 然后再通过dom 对象.事件名= function(){} 
>
> 赋于事件响应后的代码，叫动态注册

```js
window.onload = function (){
    alert("动态注册onload事件")
}
```



### onclick事件

```html
    <script type="application/javascript">
        function onclickFun(){
            alert("静态注册onclick事件")
        }

        window.onload = function () {
            //    获取标签对象
            var btnObj = document.getElementById("btn02");
            //    通过标签对象注册事件
            btnObj.onclick = function () {
                alert("动态注册onclick事件")
            }
        }


    </script>
</head>
<body>
    <button onclick="onclickFun()">按钮1</button>
    <button id="btn02">按钮2</button>
```

> document是JS提供的一个对象，表示整个页面



### onblur事件

```html
    <script type="application/javascript">
        function onblurFun(){
            console.log("静态失焦方法");
        }

        window.onload = function (){
            var pswd = document.getElementById("pswd");
            pswd.onblur = function (){
                console.log("动态失焦方法");
            }
        }
    </script>
</head>
<body>
    用户名：<input type="text" onblur="onblurFun()"><br/>
    密码：<input type="text" id="pswd"><br/>
```

> console 是控制台对象
>
> 是由JavaScript 语言提供，专门用来向浏览器的控制器打印输出， 用于测试使用



### onchange事件

```html
    <script type="application/javascript">
        function onchangeFun(){
            alert("女神已经改变了");
        }

        window.onload = function (){
            var sel = document.getElementById("sel01");
            sel.onchange = function (){
                alert("男神已经改变了");
            }
        }

    </script>
</head>
<body>
    请选择你心中的女神：
    <select onchange="onchangeFun()">
        <option>--女神--</option>
        <option>芳芳</option>
        <option>佳佳</option>
        <option>环环</option>
    </select>

    请选择你心中的男神：
    <select id="sel01">
        <option>--男神--</option>
        <option>华仔</option>
        <option>富成</option>
        <option>润发</option>
    </select>
```



### onsubmit事件

```html
    <script type="application/javascript">
        function onsubmitFun(){
            alert("发现不合法");
            return false;
        }
        window.onload = function (){
            var form01 = document.getElementById("form01");
            form01.onsubmit = function (){
                alert("发现不合法");
                return false;
            }
        }

    </script>
</head>
<body>
    <form action="http://localhost:8080" method="get" onsubmit="return onsubmitFun();">
        <input type="submit" value="静态注册">
    </form>
    <form id="form01" action="http://localhost:8080" method="get">
        <input type="submit" value="动态注册">
    </form>
```

> return false可以阻止表单提交
>
> 静态注册时要注意：onsubmitFun()的返回值是false，还要加一个return



## DOM模型

> DOM 全称是Document Object Model 文档对象模型
>
> 就是把文档中的标签，属性，文本，转换成为对象来管理



### Document对象（重点）

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\JavaWeb\JavaScript\笔记\document.jpg)

> 1. Document 它管理了所有的HTML 文档内容
> 2. document 它是一种树结构的文档。有层级关系
> 3. 它让我们把所有的标签都对象化
> 4. 我们可以通过document 访问所有的标签对象



### Document对象中的方法（重点）

> * `document.getElementById(elementId)`
>
>   通过标签的id 属性查找标签dom 对象，elementId 是标签的id 属性值
>
> * `document.getElementsByName(elementName)`
>
>   通过标签的name 属性查找标签dom 对象，elementName 标签的name 属性值
>
> * `document.getElementsByTagName(tagname)`
>
>   通过标签名查找标签dom 对象。tagname 是标签名
>
> * `document.createElement( tagName)`
>
>   方法，通过给定的标签名，创建一个标签对象。tagName 是要创建的标签名

#### getElementById

> 当用户点击了校验按钮，取出输入框中的内容，验证其是否合法
>
> 规则是：有数字，字幕，下划线组成。长度5-12位

```html
    <script type="application/javascript">
        function onclickFun(){
            var username = document.getElementById("username");
            var value = username.value;
            var patt = /^\w{5,12}$/;
            if (patt.test(value)){
                alert("用户名合法")
            } else {
                alert("用户名不合法")
            }
        }
    </script>
</head>
<body>
    用户名：<input type="text" id="username">
    <button onclick="onclickFun()">校验</button>
```

> 但是没有网站会弹窗提示不合法
>
> 一般都是在旁边提示不合法

```html
    <script type="application/javascript">
        function onclickFun(){
            var username = document.getElementById("username");
            var value = username.value;
            var patt = /^\w{5,12}$/;

            var span = document.getElementById("span");

            if (patt.test(value)){
                span.style = "color: green";
                span.innerHTML = "用户名合法";
            } else {
                span.style = "color: red";
                span.innerHTML = "用户名不合法";
            }
        }

    </script>
</head>
<body>
    用户名：<input type="text" id="username">
    <span id="span"></span><br/>
    <button onclick="onclickFun()">校验</button>
```

> 也可以通过图片来提示

```html
    <script type="application/javascript">
        function onclickFun(){
            var username = document.getElementById("username");
            var value = username.value;
            var patt = /^\w{5,12}$/;

            var span = document.getElementById("span");

            if (patt.test(value)){
                span.innerHTML = "<img src=\"right.png\" width=\"18\" height=\"18\"/>";
            } else {
                span.style = "color: red";
                span.innerHTML = "<img src=\"wrong.png\" width=\"18\" height=\"18\"/>";
            }
        }

    </script>
</head>
<body>
    用户名：<input type="text" id="username">
    <span id="span"></span><br/>
    <button onclick="onclickFun()">校验</button>
```

#### getElementsByName

```html
    <script type="application/javascript">
        function checkAll(){
            var hobbies = document.getElementsByName("hobby");
            for (var i = 0; i < hobbies.length; i++) {
                hobbies[i].checked = true;
            }
        }
        function checkNone(){
            var hobbies = document.getElementsByName("hobby");
            for (var i = 0; i < hobbies.length; i++) {
                hobbies[i].checked = false;
            }
        }
        function checkReverse(){
            var hobbies = document.getElementsByName("hobby");
            for (var i = 0; i < hobbies.length; i++) {
                hobbies[i].checked = !hobbies[i].checked;
            }
        }

    </script>
</head>
<body>
    兴趣爱好：
    <input type="checkbox" name="hobby" value="cpp">C++
    <input type="checkbox" name="hobby" value="java">Java
    <input type="checkbox" name="hobby" value="js">JavaScript
    <br/>
    <button onclick="checkAll()">全选</button>
    <button onclick="checkNone()">全不选</button>
    <button onclick="checkReverse()">反选</button>
```



#### getElementsByTagName

```html
    <script type="application/javascript">
        function checkAll(){
            var inputs = document.getElementsByTagName("input");
            for (var i = 0; i < inputs.length; i++) {
                inputs[i].checked = true;
            }
        }

    </script>
</head>
<body>
    兴趣爱好：
    <input type="checkbox" value="cpp">C++
    <input type="checkbox" value="java">Java
    <input type="checkbox" value="js">JavaScript
    <br/>
    <button onclick="checkAll()">全选</button>
```

#### 注意事项

> * document 对象的三个查询方法，如果有id 属性，优先使用getElementById 方法来进行查询
>
> * 如果没有id 属性，则优先使用getElementsByName 方法来进行查询
>
> * 如果id 属性和name 属性都没有最后再按标签名查getElementsByTagName
>
> 以上三个方法，一定要在页面加载完成之后执行，才能查询到标签对象



#### creatElement

```html
<script type="application/javascript">
    window.onload = function (){
        var div = document.createElement("div");
        div.innerHTML = "hello js";
        document.body.appendChild(div);
    }
</script>
```



### 节点的常用属性和方法

> 节点就是标签对象

> * `getElementsByTagName()`
>
>   获取当前节点的指定标签名孩子节点
>
> * `appendChild( oChildNode )`
>
>   可以添加一个子节点，oChildNode 是要添加的孩子节点

> * `childNodes`
>
>   获取当前节点的所有子节点
>
> * `firstChild`
>
>   获取当前节点的第一个子节点
>
> * `lastChild`
>
>   获取当前节点的最后一个子节点
>
> * `parentNode`
>
>   获取当前节点的父节点
>
> * `nextSibling`
>
>   获取当前节点的下一个节点
>
> * `previousSibling`
>
>   获取当前节点的上一个节点
>
> * `className`
>
>   用于获取或设置标签的class 属性值
>
> * `innerHTML`
>
>   表示获取/设置起始标签和结束标签中的内容
>
> * `innerText`
>
>   表示获取/设置起始标签和结束标签中的文本



## 正则表达式

```js
// 表示要求字符串中，是否包含字母e
// var patt = new RegExp("e");
// var patt = /e/; // 也是正则表达式对象

// 表示要求字符串中，是否包含字母a或b或c
// var patt = /[abc]/;

// 表示要求字符串，是否包含小写字母
// var patt = /[a-z]/;

// 表示要求字符串，是否包含任意大写字母
// var patt = /[A-Z]/;

// 表示要求字符串，是否包含任意数字
// var patt = /[0-9]/;

// 表示要求字符串，是否包含字母，数字，下划线
// var patt = /\w/;

// 表示要求 字符串中是否包含至少一个a
// var patt = /a+/;

// 表示要求 字符串中是否 *包含* 零个 或 多个a
// var patt = /a*/;

// 表示要求 字符串是否包含一个或零个a
// var patt = /a?/;

// 表示要求 字符串是否包含连续三个a
// var patt = /a{3}/;

// 表示要求 字符串是否包 至少3个连续的a，最多5个连续的a
// var patt = /a{3,5}/;

// 表示要求 字符串是否包含 至少3个连续的a，
// var patt = /a{3,}/;

// 表示要求 字符串必须以a结尾
// var patt = /a$/;

// 表示要求 字符串必须以a打头
// var patt = /^a/;



// 要求字符串中是否*包含* 至少3个连续的a
// var patt = /a{3,5}/;
// 要求字符串，从头到尾都必须完全匹配
// var patt = /^a{3,5}$/;

var patt = /^\w{5,12}$/;

var str = "wzg168[[[";

alert( patt.test(str) );
```

