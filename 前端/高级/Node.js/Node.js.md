# Node.js

> Node.js是一个能在服务器端运行的JavaScript的开放源代码，跨平台JavaScript运行环境



## 模块

> CommonJS规范的提出，主要是弥补当前JavaScript没有标准的缺陷

> 在Node中，一个JS文件就是一个模块

```js
var x = require("./01");
```



### 模块引入

> 使用require引入别的模块（JS文件）
>
> 必须以 . 或 .. 开头
>
> 其返回值就是调用的JS文件



### 访问其他模块数据

> 在Node中，每一个JS文件中的代码，都是独立运行在一个函数中
>
> 可以理解为整个文件被一个自调用函数包裹
>
> 所以一个模块中的变量和函数，无法在其他模块中访问

```js
exports.a = "01";
```

```js
var x = require("./01");
console.log(x.a);
```

> 如果想向外部暴露属性，需要将属性或方法设置为exports的属性



### 模块分类

> 模块分为两大类
>
> 核心模块：由node提供的模块，导入时直接使用名字即可
>
> 文件模块：自己创建的模块，导入时需要使用相对路径

```js
var fs = require("fs");     //核心模块
var x = require("./01");    //文件模块
```



### 全局对象

> 在node中有一个全局对象global，它的作用和网页中window类似
>
> 在全局中创建的变量，都会作为global的属性
>
> 在全局中创建的函数，都会作为global的函数

```js
var a = 10;

console.log(arguments.callee + "");
```

```js
function (exports, require, module, __filename, __dirname) {
    var a = 10;
    console.log(arguments.callee + "");
}
```

> 这样能看到我们的代码确实是运行在一个函数中的

> exports：该对象用来将变量和函数暴露到外部
>
> require：用来引入外部模块
>
> module：代表当前模块本身，exports就是module的一个属性
>
> \__filename：代表当前模块的绝对路径
>
> __dirname：代表当前模块所在文件夹的绝对路径



### model.exports

```js
module.exports = {
    name : "张三",
    age : 18,
    sayName : function () {
        console.log("我是张三")
    }
}
```

```js
var p = require("./01");
p.sayName();
```

> 这样是可以调用的

```js
exports = {
    name : "张三",
    age : 18,
    sayName : function () {
        console.log("我是张三")
    }
}
```

> 但我们把01的 model. 去掉就会调用失败

> exports只能通过 . 的方式向外暴露
>
> 而model.exports，既可以通过 . 的方式么也可以直接赋值



## 包

> CommonJS的包规范，允许我们将一组相关的模块组合到一起，形成一组完整的工具

> 包由包结构和包描述文件组成
>
> 包结构：用于组织包中各种文件
>
> 包描述文件：描述包相关信息，以供外部读取

> 包实际上就是一个压缩文件，解压后为原目录
>
> 包应该包含以下文件：
>
> package.json	描述文件
>
> bin	可执行二进制文件
>
> lib	js代码
>
> doc	文档
>
> test	单元测试



### npm

> Node Package Manager
>
> 对于Node而言，NPM帮助其完成了第三方模块的发布，安装，依赖等

> 调用npm init可以有向导来初始化当前目录，创建package.json
>
> 然后可以使用npm install安装需要的包
>
> 然后在index.js中可以使用下载包中的内容

> 常用命令
>
> npm -v：查看版本
>
> npm：帮助说明
>
> npm search 包名：搜索包
>
> npm install 包名：在当前目录安装包
>
> npm install 包名 -g：全局模式安装包（一般都是一些工具）
>
> npm remove 包名：删除包
>
> **npm install 包名 --save：安装包，并添加到依赖**
>
> npm install：下载当前包所需要的依赖

> 通过npm下载的包，直接通过包名引入就可以了



### cnpm

> 通过淘宝的镜像站下载包

```sh
npm install -g cnpm --registry=https://registry.npm.taobao.org
```

> 之后就可以使用cnpm代替npm



### 搜索包流程

> 如果当前项目中node_models中没有这个包
>
> 则会在上层目录中找，层层往上找，直到磁盘根目录



## Buffer

> 数组中不能存储二进制文件，Buffer就是专门用来存储二进制数据的

```js
var buf = Buffer.alloc(10);
```

> 创建一个10个字节的buffer

```js
buf[0] = 88;
buf[1] = 255;
console.log(buf);
```

> 操作buffer与数组基本一样



## 文件系统

> 通过Node操作系统中的文件
>
> 使用文件系统要先引入fs模块

> fs中的方法都有两种形式，同步和异步

### 同步文件写入

#### 打开文件

```js
var fd = fs.openSync("hello.txt","w");
```

> 该方法有三个参数
>
> 第一个是文件路径
>
> 第二个是我们要对文件进行的操作类型，常见的有r和w，写和读
>
> 第三个是文件操作权限，一般不写

> 该方法会有一个返回值，描述结果
>
> 我们可以通过该描述，来对文件进行操作

#### 写入内容

```js
fs.writeSync(fd,"Hello");
```

> 该方法有四个参数
>
> 第一个是文件描述符
>
> 第二个是写入的内容
>
> 第三个是从哪个位置开始写
>
> 第四个是编码格式
>
> 第三个和第四个一般不写

#### 关闭文件

```js
fs.closeSync(fd);
```

> 只有一个参数，要关闭的文件描述符



### 异步文件写入

#### 打开文件

```js
fs.open("hello2.txt","w",function (err,fd) {
    if (!err){

    } else {
        console.log(err);
    }
});
```

> 这个方法基本与同步一致，不过多了个参数，用来定义回调函数
>
> 异步调用方法，结果是通过回调函数来返回的
>
> 回调函数有两个参数
>
> err	错误对象，如果没有错误则为null
>
> fd	文件描述符

#### 写入内容

```js
fs.open("hello2.txt","w",function (err,fd) {
    if (!err){
        fs.write(fd,"异步写入的内容",function (err) {
            if (!err){
                console.log("写入成功！")
            }
        })
    } else {
        console.log(err);
    }
});
```

> 同样，写入也多了个回调函数

#### 关闭文件

```js
fs.open("hello2.txt","w",function (err,fd) {
    if (!err){
        fs.write(fd,"异步写入的内容",function (err) {
            if (!err){
                console.log("写入成功！")
                fs.close(fd,function (err) {
                    if (!err){
                        console.log("文件已关闭！")
                    }
                })
            }
        })
    } else {
        console.log(err);
    }
});
```

> 同样，关闭也是多一个回调函数



### 简单文件写入

```js
fs.writeFile("hello3.txt","简单异步写入内容",{flag:"w"},function (err) {
    if (!err){
        console.log("写入成功！")
    }
});
```

> 这里多了一个参数，可以传对象进去
>
> encoding：编码格式，默认utf-8
>
> mode：默认0o66
>
> flag：默认‘w’

> flag常用的值
>
> r读，w写，a追加

> 其实这个方法只是把我们写的方法封装了



### 流式文件写入

```js
var ws = fs.createWriteStream("hello.txt");

ws.once("open",function () {
    console.log("流开启")
});

ws.once("close",function () {
    console.log("流关闭")
});

ws.write("通过流写入1");
ws.write("通过流写入2");
ws.write("通过流写入3");
ws.write("通过流写入4");

ws.end();
```

> 之前的写入会一次性将文件读入内存，再写入
>
> 对于大文件容易造成内存溢出



### 简单文件读取

```js
fs.readFile("hello.txt",function (err,data) {
    if (!err){
        console.log(data.toString());
    }
});
```

> 读取到的data是一个buffer



### 流式文件读取

```js
var rs = fs.createReadStream("a.jpg");

rs.once("open",function () {
    console.log("流开启");
});

rs.once("close",function () {
    console.log("流关闭");
});

rs.on("data",function (data) {
    console.log(data);
});
```

> 如果要读取数据，必须为可读流绑定data事件
>
> data事件绑定完成会自动开始读数据，并且自动关闭

```js
var rs = fs.createReadStream("b.mp3");
var ws = fs.createWriteStream("a.mp3");

rs.once("close",function () {
   ws.end();
});

rs.on("data",function (data) {
    ws.write(data);
});
```

> 两者配合可以实现拷贝

```js
var rs = fs.createReadStream("b.mp3");
var ws = fs.createWriteStream("a.mp3");

rs.pipe(ws);
```

> 或者可以直接调用pipe，将两者绑定，都会自动关闭



### 其他方法

#### 文件是否存在

```js
var isExists = fs.existsSync("a.mp3");
console.log(isExists);
```

#### 获取文件状态

```js
fs.stat("a.mp3",function (err,stat) {
    if (!err){
        console.log(stat);
    }
});
```

> 将文件的详细信息封装进一个对象
>
> 常用的属性有
>
> isFile()：是否是个文件
>
> isDirectory()：是否是文件夹
>
> size：大小

#### 删除文件

```js
fs.unlink("hello.txt");
```

#### 读取目录结构

```js
fs.readdir(".",function (err,files) {
    if (!err){
        console.log(files);
    }
});
```

> files是一个字符串数组，每一个元素是一个文件或文件夹名称

#### 截断文件

```js
fs.truncateSync("hello2.txt",10);
```

> 会将文件修改为指定大小，其余的直接抛弃

#### 创建文件夹

```js
fs.mkdir("aaa");
```

#### 删除文件夹

```js
fs.rmdir("aaa");
```

#### 重命名

```js
fs.rename("a.mp3","c.mp3",function (err) {
    if (!err){
        console.log("修改成功！");
    }
});
```

#### 监视文件改动

```js
fs.watchFile("hello2.txt",function (curr,prev) {
    console.log("修改前文件大小：" + prev.size);
    console.log("修改后文件大小：" + curr.size);
});
```

> curr和prev都是stat对象
>
> 含有很多属性和方法