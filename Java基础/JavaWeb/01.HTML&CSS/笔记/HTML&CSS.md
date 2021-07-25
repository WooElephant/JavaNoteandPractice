# HTML&CSS

## 网页的组成部分

> 页面由三部分内容组成
>
> **内容、表现、行为**
>
> **内容：**是我们在页面中可以看到的数据，我们称之为内容。一般由html技术来展示
>
> **表现：**这些内容在页面上的展示形式，比如：布局、颜色、大小等。一般由css技术实现
>
> **行为：**页面中元素与输入设备交互的相应，一般由JavaScript技术实现

## HTML简介

> **H**yper **T**ext **M**arkup **L**anguage  超文本标记语言
>
> HTML通过标签标记要显示网页中的各个部分，网页文件本身是一种文本文件
>
> 通过在文本文件中添加标记符，可以告诉浏览器如何显示其中的内容（如：文字如何处理，画
> 面如何安排，图片如何显示等）

## 编写规范

```html
<!DOCTYPE html> <!-- 约束 声明 -->
<html lang="zh_CN"><!-- html标签表示html的开始   lang="zh_CN"表示中文  html标签中一般分为两部分，分别是head和body-->
<head><!-- 表示头部信息，一般包含三部分内容  title标题，css样式，js代码 -->
    <meta charset="UTF-8"><!-- 表示当前页面使用UTF-8字符集 -->
    <title>标题</title><!-- 表示标题 -->
</head>
<body><!-- body 标签是整个html页面显示的主体内容-->
    hello
</body>
</html>
```

## 标签

### 标签的格式

```html
<标签名>封装的数据</标签名>
```

> 标签名大小写不敏感



### 标签的属性

> 基本属性：

```html
<body bgcolor="red">hello</body>	<!-- 可以修改简单的样式效果 -->
```

> 事件属性：

```html
<body onclick="alert('123')">hello</body>	<!-- 可以直接设置事件响应后的代码 -->
```



### 单标签和双标签

```html
<p></p>	<!--双标签为一对，开始标签和结束标签-->
<br/>	<!--单标签只有一个-->
```

> 常见的单标签：br换行  hr水平线



### 标签的语法

> 标签不能交叉嵌套

```html
<div><span>你好</span></div>	<!--正确-->
<div><span>你好</div></span>	<!--错误-->
```

> 标签正确闭合

```html
<div>你好</div>	<!--正确-->
<div>你好		       <!--错误-->
```

```html
<br/>   <!--正确-->
<br>    <!--错误-->
```

> 属性必须要有值，属性值必须加引号

```html
<font color="blue">你好</font>   <!--正确-->
<font color=blue>你好</font>    <!--错误-->
<font color>你好</font>    <!--错误-->
```

> 注释不能嵌套

```html
<!--注释内容-->   <!--正确-->
<!--注释内容<!--嵌套注释内容-->-->    <!--错误-->
```



### W3School文档

> W3school文档中有详细的HTML参考手册，便于速查



### 常用标签

#### font

```html
<font color="red" face="黑体" size="7">我是字体标签</font>
```

> 字体标签
>
> 可以修改文本字体，颜色，大小



#### 特殊字符

```html
我是&lt;br/&gt;标签
```

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\JavaWeb\HTML&CSS\笔记\实体.PNG)

> 这是W3School里描述的一些常用字符实体
>
> 类似于转义字符



#### 标题标签

> ↑  上面这个就是h4
>
> 标题标签是h1到h6

```html
<h1 align="center">标题1</h1>
<h2 align="right">标题2</h2>
<h3>标题3</h3>
<h4>标题4</h4>
<h5>标题5</h5>
<h6>标题6</h6>
```

> align属性表示对齐，默认是左对齐



#### 超链接 （重点）

```html
<a href="http://www.baidu.com">百度</a>    <a href="http://www.baidu.com">百度</a>
<a href="http://www.baidu.com" target="_self">百度</a>
<a href="http://www.baidu.com" target="_blank">百度</a>
```

> a标签是超链接
>
> href属性是链接地址
>
> target属性是设置如何跳转
>
> _self：当前窗口，默认值
>
> _blank：新窗口打开



#### 列表标签

```html
<ul>
    <li>赵四</li>
    <li>刘能</li>
    <li>小沈阳</li>
    <li>宋小宝</li>
</ul>
```

> 这是一组无序列表

```html
<ol>
    <li>赵四</li>
    <li>刘能</li>
    <li>小沈阳</li>
    <li>宋小宝</li>
</ol>
```

> 这是一组有序列表



#### img标签

> 可以在HTML页面中显示图片

```html
<img src="./imgs/222.png" width="400" height="200" border="20px" alt="找不到图片"/>
```

> img是图像标签
>
> src是设置图片的路径
>
> width和height是设置图片大小
>
> border是设置边框
>
> alt是设置如果图片找不到，替代的信息显示



#### 表格标签 （重点）

```html
<table border="1" width="300" height="200" align="center" cellspacing="0">
    <tr>
        <th>1.1</th>
        <th>1.2</th>
        <th>1.3</th>
    </tr>
    <tr>
        <td><b>2.1</b></td>
        <td>2.2</td>
        <td>2.3</td>
    </tr>
    <tr>
        <td>3.1</td>
        <td>3.2</td>
        <td>3.3</td>
    </tr>
</table>
```

> table是表格标签
>
> tr是行
>
> th是表头
>
> td是单元格
>
> cellspacing设置单元格间距

```html
<table align="center" width="500" height="200" cellspacing="0" border="1">
    <tr>
        <td colspan="2">1.1</td>
        <td>1.3</td>
        <td>1.4</td>
        <td>1.5</td>
    </tr>
    <tr>
        <td rowspan="2">2.1</td>
        <td>2.2</td>
        <td>2.3</td>
        <td>2.4</td>
        <td>2.5</td>
    </tr>
    <tr>
        <td>3.2</td>
        <td>3.3</td>
        <td>3.4</td>
        <td>3.5</td>
    </tr>
    <tr>
        <td>4.1</td>
        <td>4.2</td>
        <td>4.3</td>
        <td colspan="2" rowspan="2">4.4</td>
    </tr>
    <tr>
        <td>5.1</td>
        <td>5.2</td>
        <td>5.3</td>
    </tr>
</table>
```

> colspan：设置跨列
>
>  rowspan：设置跨行



#### iframe

> 内嵌窗口，在html页面中，打开一个窗口，单独显示一个页面

```html
我是一个页面<br/>
<iframe src="welcome.html" width="500" height="500" name="abc"></iframe>
<br/>
<br/>
<br/>
<br/>
<br/>

<a href="2.html" target="abc">跳转</a>
```

> iframe可以使用name定义一个名字
>
> 然后可以指定这个iframe中的内容跳转



#### 表单 （重点）

> 表单就是用来收集用户信息的元素集合，然后把这些信息发送给服务器

```html
<form>
    
    用户名称：<input type="text" value="请输入用户名称"/><br/>
    用户密码：<input type="password" /><br/>
    确认密码：<input type="password" /><br/>
    性别：<input type="radio" name="sex" checked="checked"/>男<input type="radio" name="sex"/>女<br/>
    兴趣爱好：<input type="checkbox" />Java<input type="checkbox" />Python<input type="checkbox" />C++<br/>
    国籍：<select>
            <option>----请选择国籍----</option>
            <option selected="selected">中国</option>
            <option>美国</option>
        </select><br/>
    自我评价：<textarea rows="10" cols="20">请输入自我评价</textarea><br/>
    <input type="file"><br/>
    <input type="reset" />
    <input type="submit" value="写好了"/>
    <input type="button" value="按钮中的文字" /><br/>
    <input type="hidden" name="abc" value="abcValue" />

</form>
```

> form标签就是表单
>
> input type=text     是文件输入框  value设置默认显示内容
> input type=password 是密码输入框  value设置默认显示内容
> input type=radio    是单选框    name属性可以对其进行分组   checked="checked"表示默认选中
> input type=checkbox 是复选框   checked="checked"表示默认选中
> input type=reset    是重置按钮      value属性修改按钮上的文本
> input type=submit   是提交按钮      value属性修改按钮上的文本
> input type=button   是按钮          value属性修改按钮上的文本
> input type=file     是文件上传域
> input type=hidden   是隐藏域    当我们要发送某些信息，而这些信息，不需要用户参与，就可以使用隐藏域（提交的时候同时发送给服务器）
>
> 
>
> select 标签是下拉列表框
>
> ​	option 标签是下拉列表框中的选项 selected="selected"设置默认选中
>
> textarea 表示多行文本输入框 （起始标签和结束标签中的内容是默认值）
>
> ​	rows 属性设置可以显示几行的高度
>
> ​	cols 属性设置每行可以显示几个字符宽度



```html
<form>
    <table>
        <tr>
            <td>用户名称：</td>
            <td><input type="text" value="请输入用户名称"/></td>
        </tr>
        <tr>
            <td>用户密码：</td>
            <td><input type="password" /></td>
        </tr>
        <tr>
            <td>确认密码：</td>
            <td><input type="password" /></td>
        </tr>
        <tr>
            <td>性别：</td>
            <td><input type="radio" name="sex" checked="checked"/>男<input type="radio" name="sex"/>女</td>
        </tr>
        <tr>
            <td>兴趣爱好：</td>
            <td><input type="checkbox" />Java<input type="checkbox" />Python<input type="checkbox" />C++</td>
        </tr>
        <tr>
            <td>国籍：</td>
            <td>
                <select>
                    <option>----请选择国籍----</option>
                    <option selected="selected">中国</option>
                    <option>美国</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>自我评价：</td>
            <td><textarea rows="10" cols="20">请输入自我评价</textarea></td>
        </tr>
        <tr>
            <td><input type="file"></td>
        </tr>
        <tr>
            <td><input type="reset" /></td>
            <td><input type="submit" /></td>
        </tr>
        <tr>
            <td><input type="hidden" name="abc" value="abcValue" /></td>
        </tr>
    </table>

</form>
```

> 可以使用一个表格来包裹form表单内容
>
> 格式化一下，更美观



```html
<form action="" method="">
```

> action属性设置提交的服务器地址
>
> method属性设置提交的方式get（默认）或post

> 表单提交的时候，数据没有发送给服务器的三种情况
>
> 1. 表单项没有name值
> 2. 单选，复选 都需要添加value属性
> 3. 表单项不在form标签中

```html
<form action="" method="">
    <table>
        <tr>
            <td>用户名称：</td>
            <td><input type="text" name="username" value="请输入用户名称"/></td>
        </tr>
        <tr>
            <td>用户密码：</td>
            <td><input type="password" name="password"/></td>
        </tr>
        <tr>
            <td>性别：</td>
            <td><input type="radio" name="sex" checked="checked" />男<input type="radio" name="sex"/>女</td>
        </tr>
        <tr>
            <td>兴趣爱好：</td>
            <td>
                <input type="checkbox" name="hobby"/>Java
                <input type="checkbox" name="hobby"/>Python
                <input type="checkbox" name="hobby"/>C++
            </td>
        </tr>
        <tr>
            <td>国籍：</td>
            <td>
                <select name="nation">
                    <option>----请选择国籍----</option>
                    <option selected="selected">中国</option>
                    <option>美国</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>自我评价：</td>
            <td><textarea rows="10" cols="20" name="desc">请输入自我评价</textarea></td>
        </tr>
        <tr>
            <td><input type="file"></td>
        </tr>
        <tr>
            <td><input type="reset" /></td>
            <td><input type="submit" /></td>
        </tr>
        <tr>
            <td><input type="hidden" name="abc" value="abcValue" /></td>
        </tr>
    </table>

</form>
```

```http
username=zhangsan
password=1234
sex=on
hobby=on&hobby=on
nation=中国
desc=aaa
```

> 这时候多选框和单选框只会显示on 
>
> 这显然不是我们想要的

```html
<form action="" method="">
    <table>
        <tr>
            <td>用户名称：</td>
            <td><input type="text" name="username" value="请输入用户名称"/></td>
        </tr>
        <tr>
            <td>用户密码：</td>
            <td><input type="password" name="password"/></td>
        </tr>
        <tr>
            <td>性别：</td>
            <td>
                <input type="radio" name="sex" checked="checked" value="男"/>男
                <input type="radio" name="sex" value="女"/>女
            </td>
        </tr>
        <tr>
            <td>兴趣爱好：</td>
            <td>
                <input type="checkbox" name="hobby" value="Java"/>Java
                <input type="checkbox" name="hobby" value="Python"/>Python
                <input type="checkbox" name="hobby" value="C++"/>C++
            </td>
        </tr>
        <tr>
            <td>国籍：</td>
            <td>
                <select name="nation">
                    <option>----请选择国籍----</option>
                    <option selected="selected">中国</option>
                    <option>美国</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>自我评价：</td>
            <td><textarea rows="10" cols="20" name="desc">请输入自我评价</textarea></td>
        </tr>
        <tr>
            <td><input type="file"></td>
        </tr>
        <tr>
            <td><input type="reset" /></td>
            <td><input type="submit" /></td>
        </tr>
        <tr>
            <td><input type="hidden" name="abc" value="abcValue" /></td>
        </tr>
    </table>

</form>
```

```http
username=zhangsan
password=1234
sex=男
hobby=Java&hobby=Python
nation=中国
desc=aaaa
```



#### div span p标签

```html
<div>div标签1</div>
<div>div标签2</div>

<span>span标签1</span>
<span>span标签2</span>

<p>p标签1</p>
<p>p标签2</p>
```

> `div标签`		默认独占一行
>
> `span标签`	他的长度是封装的数据的长的
>
> `p标签`		  默认会在段落的上方或下方各空出一行来（如果已有就不再空）



## CSS

### 介绍

> CSS 是「层叠样式表单」
>
> 用于(增强)控制网页样式并允许将样式信息与网页内容分离的一种标记性语言



### 语法

```css
选择器 {
    属性：值
}
```

> * **选择器：**浏览器根据“选择器”决定受CSS 样式影响的HTML 元素（标签）
> * **属性(property) ：**是你要改变的样式名，并且每个属性都有一个值。属性和值被冒号分开，并
>   由花括号包围，这样就组成了一个完整的样式声明（declaration）
> * **多个声明：**如果要定义不止一个声明，则需要用分号将每个声明分开。虽然最后一条声明的
>   最后可以不加分号(但尽量在每条声明的末尾都加上分号)
> * 一般每一行只描述一个属性
> * 注释 /\* 注释内容 */

```css
p {
   color : red;
    font-size : 30px;
}
```



### CSS与HTML结合

#### 第一种方式

> 在标签的style属性上设置KV修改标签样式

```html
<div style="border: 1px solid rgb(215,91,91);">div标签1</div>
<div style="border: 1px solid rgb(215,91,91);">div标签2</div>

<span style="border: 1px solid rgb(215,91,91);">span标签1</span>
<span style="border: 1px solid rgb(215,91,91);">span标签2</span>
```

> 如果样式多，代码量非常庞大
>
> 可读性很差
>
> 没有复用性



#### 第二种方式

> 在head标签中，使用style标签来定义各种自己需要的样式

```html
<style type="text/css">
    div {
        border: 1px solid red;
    }
    span {
        border: 1px solid red;
    }
</style>
```

> style标签转码用来定义css样式代码

> 这样写只能在用一个页面中复用代码，不能再多个页面复用css代码
>
> 维护起来不方便，一个项目里有成千上万的页面，修改起来很麻烦



#### 第三种方式

> 把css样式写成一个单独的css文件，再通过link标签引入

```css
/* 1.css */
div {
    border: 1px solid red;
}
span {
    border: 1px solid red;
}
```

```html
<link rel="stylesheet" type="text/css" href="1.css"/>
```



### CSS选择器

#### 标签名选择器

> 标签名选择器可以决定哪些标签被动的使用这个样式

> 需求：
>
> 所有div标签，修改字体为蓝色，字体大小为30个像素，边框为1像素黄色实线
>
> 所有span标签，修改字体为黄色，字体大小为20个像素，边框为5像素蓝色虚线

```css
div{
    border: 1px yellow solid;
    color: blue;
    font-size: 30px;
}
span{
    border: 5px blue dashed;
    color: yellow;
    font-size: 20px;
}
```

#### id选择器

```css
#id 属性值{
    属性：值；
}
```

> 可以让我们通过id属性，选择性的去使用这个样式

> 分别定义两个div标签
>
> 一个标签id定义为id001，修改字体颜色为蓝色，字体大小30个像素，边框为1像素黄色实线
>
> 一个标签id定义为id002，修改字体颜色为红色，字体大小20个像素，边框为5像素蓝色点线

```html
<style type="text/css">
    #id001 {
        color: blue;
        font-size: 30px;
        border: 1px yellow solid;
    }
    #id002 {
        color: red;
        font-size: 20px;
        border: 5px blue dotted;
    }
</style>

<div id="id001">div标签1</div>
<div id="id002">div标签2</div>
```

#### 类选择器

```css
.class 属性值{
    属性：值； 	   
}
```

> 可以通过class属性有效的选择去使用这个样式

> 修改class属性为class01的字体颜色为蓝色，大小30个像素，边框为1像素黄色实线
>
> 修改class属性为class02的字体颜色为灰色，大小26个像素，边框为1像素红色实线

```html
<style type="text/css">
    .class01{
        color: blue;
        font-size: 30px;
        border: 1px yellow solid;
    }
    .class02{
        color: gray;
        font-size: 26px;
        border: 1px red solid;
    }
</style>

<div class="class01">div标签class01</div>
<div class="class02">div标签</div>
<span class="class01">span标签class01</span>
<span>span标签2</span>
```



#### 组合选择器

```css
选择器1，选择器2，选择器n{
    属性：值；    
}
```

> 组合选择器，可以让多个选择器共用一个代码

> 修改class为class01和id为id01的所有标签
>
> 字体颜色为蓝色，大小20个像素，边框为1像素黄色实线

```html
<meta charset="UTF-8">
<title>标题</title>
<style type="text/css">
.class01,#id01{
color: blue;
font-size: 20px;
border: 1px yellow solid;
}
</style>

<div class="class01">div标签class01</div><br/>
<span id="id01">span标签</span><br/>
<div>div标签</div><br/>
<div>div标签</div><br/>
```



### 常用样式

#### 颜色

```css
color : red;
```

> 颜色可以写颜色名
>
> 或者十六进制表示值#00F6DE，如果写十六进制值必须加#
>
> 或者rgb(255,0,0)



#### 宽度 高度

```css
width:19px;
height:20px;
```

> 可以写像素值：19px；
>
> 也可以写百分比值：20%；



#### 背景颜色

```css
background-color: red;
```

#### 字体样式

```css
color：#FF0000；
font-size：20px; 
```

#### 边框样式

```css
border：1px solid red;
```

#### div居中

```css
margin-left: auto;
margin-right: auto;
```

#### 文本居中

```css
text-align: center;
```

#### 超连接去下划线

```css
text-decoration: none;
```

#### 表格细线

```css
table {
	border: 1px solid black; /*设置边框*/
	border-collapse: collapse; /*将边框合并*/
}
td,th {
	border: 1px solid black; /*设置边框*/
}
```

#### 列表去除修饰

```css
ul {
	list-style: none;
}
```











