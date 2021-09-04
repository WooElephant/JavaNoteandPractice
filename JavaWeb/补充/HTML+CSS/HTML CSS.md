# HTML CSS

> HTML(Hypertext Markup Language) 超文本标记语言
>
> 它负责网页的三个要素之中的结构
>
> HTML使用标签的形式来标识网页中的不同组成部分
>
> 所谓超文本指的是超链接，使用超链接可以让我们从一个页面跳转到另一个页面

## 第一个网页

```html
<html>
    <head>
        <title>标题</title>
    </head>
    <body>
        <h1>我是h1</h1>
        <h2>我是h2</h2>
        <p>我是p标签</p>
    </body>
</html>
```

## liveServer插件

> 为vscode安装liveServer插件，可以让我们改变源码以后不需要刷新网页
>
> 只需要保存，网页会自动刷新


## 常用语法

> 因为内容太多，可以去查文档
>
> 在这只做常用介绍

### 自结束标签

> 标签一般成对出现，但也存在自结束标签
>
> \<img>
>
> \<br/>
>
> 带与不带/都是对的



### 注释

```html
<!--我是注释-->
```



### 属性

> 在标签中还可以设置属性
>
> 属性为键值对的形式

```html
<font color="red">123</font>
```



### 文档声明

> 在网页的发展迭代中
>
> 网页的版本进行升级
>
> HTML4	HTML5等

> 我们需要写一些文档声明（doctype）
>
> 来告诉浏览器，使用的网页版本

```html
<!DOCTYPE html>
```

> 在html第一行加入这个代码即可



### 字符编码

```html
<meta charset="utf-8">
```

> 在head标签中定义字符编码



### 语言

```html
<html lang="zh">
```

> 添加lang属性，来告诉浏览器这个网页是什么语言的



### 转义字符

```html
&实体;
```

> 常用转义字符
>
> \&nbsp; 	空格
>
> \&gt;	大于号
>
> \&lt;	小于号
>
> \&copy;	版权符号



### meta标签

> meta主要用于设置网页中一些元数据
>
> charset	指定字符集
>
> name	指定数据名称
>
> content	指定数据内容

```html
<meta name="keywords" content="html5,css">
```

> keywords表示网站的关键字

```html
<meta name="description" content="这是一个练习用HTML页面">
```

> 描述的内容会显示在搜索引擎的结果中

```html
<meta http-equiv="refresh" content="3;url=http://www.baidu.com">
```

> 表示3秒后，跳转指指定网页



### 标题标签

> h1~h6 一共有6级标题
>
> 一般只会用h1~h3



### p标签

> p标签表示页面中的一个段落



### hgroup

> hgroup标签用来为标题分组，可以将一组相关的标题同时放到hgroup中



### em标签

> 标签告诉浏览器把其中的文本表示为强调的内容
>
> 对于所有浏览器来说，这意味着要把这段文字用斜体来显示



### strong标签

> strong标签和em标签一样，用于强调文本，但它强调的程度更强一些
>
> 通常是用加粗的字体来显示其中的内容



### q标签

> 用于短引用
>
> 浏览器经常在引用的内容周围添加引号



### blockquote标签

> 用于长引用
>
> 其之间的所有文本都会从常规文本中分离出来，经常会在左、右两边进行缩进（增加外边距），而且有时会使用斜体



### 换行

> br标签表示换行



### 块元素

> 在网页中一般通过块元素对页面进行布局
>
> p标签中不能放任何的块元素



### 行内元素

> 主要用来包裹文字
>
> 一般会在块元素中放行内元素，不会在行内元素中放块元素



### 布局标签

> **这些都可以不用，很多网站都用别的标签组合出这种效果，只作为了解**
>
> header	表示网页头部
>
> main	网页主体部分，一个页面中只会有一个
>
> footer	表示网页的底部
>
> nav	表示网页的导航
>
> aside	表示和主体相关的其他内容，侧边栏
>
> aricle	表示一个独立的文章
>
> section	表示一个独立的区块，上面的都无法表示时使用

> **div	没有语义，就表示一个区块。是我们目前主要使用的布局元素**
>
> **span	没有语义，用于选中文字，行内元素一般主要用它**



### 列表

> 使用li标签表示列表项

#### 有序列表

```html
<ol>
    <li>结构</li>
    <li>表现</li>
    <li>行为</li>
</ol>
```

#### 无序列表

```html
<ul>
    <li>结构</li>
    <li>表现</li>
    <li>行为</li>
</ul>
```

#### 定义列表

```html
<dl>
    <dt>结构</dt>
    <dd>结构表示网页的结构，结构用来规定哪里是标题，哪里是段落</dd>
</dl>
```



### 超链接

> 超链接可以让我们从一个页面跳转到其他页面
>
> 或者是当前页面其他位置

```html
<a href="https://www.baidu.com">超链接</a>
```

#### 相对路径

> 当我们需要跳转一个服务器内部页面时，一般我们会使用相对路径
>
> ./ 表示当前文件所在目录
>
> ../ 表示当前文件上一级目录

#### target属性

> 可以用来指定超链接打开位置
>
> _self	默认值。在当前页面打开
>
> _blank	在一个新的标签页中打开

#### 回到顶部

```html
<a href="#">回到顶部</a>
```

#### 跳转到指定位置

```html
<a href="#bottom">回到顶部</a>

....
<p id="p3">123....</p>
...

<a href="#p3">去p3</a>
<a id="bottom" href="#">回到顶部</a>
```



### 图片

```html
<img src="1.png" alt="叶子" width="100px" height="100px">
<img src="https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi0.sinaimg.cn%2FIT%2F2009%2F1116%2F2009111674122.jpg&refer=http%3A%2F%2Fi0.sinaimg.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1630194898&t=709a2bbfe89da19ec99b89f3bcff919e">
```

> alt表示图片的描述
>
> 一般情况看不见
>
> 通常浏览器在无法加载图片时会以此替代图片显示
>
> 在搜索时alt中内容，也会作为搜索的匹配依据

> 使用width和height可以为图片指定大小
>
> 如果只改了一个则会等比缩放
>
> 如果都设置会强制缩放



### 内联框架

> 用于向当前页面引入一个其他页面
>
> 基本上用不着

```html
<iframe src="1.html" width="800" height="600"></iframe>
```



### 音视频播放

#### 音频

```html
<audio src="" controls autoplay loop></audio>

<audio controls>
    您的浏览器不支持此功能
    <source src="">
</audio>
```

> controls	显示控制面板
>
> autoplay	自动播放（大部分浏览器都不能自动播放）
>
> loop	循环播放

> 第二种写法虽然麻烦，但是里面可以写字
>
> 比如IE8，它会忽略不能运行的标签，但是留下了文字
>
> 还有一个好处可以同时指定多个文件，以防不支持某种音频格式（现在基本用不到）

> 如果非要让IE8播放音乐

```html
<embed src="" type="" width="" height="">
```

> 这几个属性缺一不可，基本上没人会用了

#### 视频

```html
<video controls>
    <source src="">
    <source src="">
</video>
```

> 使用方法基本与音频一样



## CSS

> CSS用来设置网页中元素的样式

### 编写位置

#### 行内样式
```html
<p style="color: red; font-size: 60px;">123456</p>
```

> 绝对不要使用这种方法
>
> 不利于复用
>
> HTML与CSS耦合度太高，不利于维护

#### head中

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <style>
        p{
            color: rgb(60, 212, 60);
            font-size: 50px;
        }
    </style>
</head>
<body>
    <p>123456</p>
    <p>一二三</p>
</body>
</html>
```

> 通过选择器来批量设置样式

#### 外部样式

> 通过link标签引入外部css文件

```html
<link rel="stylesheet" href="./style.css">
```



## CSS语法

### 注释

```css
/*
	我是注释
*/
```



### 基本语法

> 选择器  声明块
>
> 通过选择器选中页面中指定元素
>
> 通过声明块来指定为元素设置的样式

> 声明块由一个个声明组成
>
> 声明式键值对结构
>
> 名和值之间以：连接，以；结尾



### 常用选择器

#### 元素选择器

> 根据标签名选中指定元素
>
> **标签名{}**

#### id选择器

> 根据id选择指定元素
>
> **#id{}**

#### class选择器

> 根据元素class属性选择元素
>
> **.class{}**
>
> 一个元素可以有多个class属性，使用空格分割

```html
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <style>
        h1{
            color: tomato;
        }
        #p3{
            color: green;
        }
        .blue{
            color: blue;
        }
    </style>
</head>
<body>
    <h1>我是标题2</h1>
    <p class="blue">p1</p>
    <p class="blue">p2</p>
    <p id="p3">p3</p>
</body>
```

#### 复合选择器

```html
<style>
    div.red{
        color: red;
    }
</style>
<div class="red">我是div</div>
<p class="red">我是p标签</p>
```

> 同时满足选择器条件：选择器1选择器2选择器3{}
>
> 选择器中如果有元素选择器，必须用元素选择器开头

> 满足其中一个条件：选择器1，选择器2，选择器3{}

#### 关系选择器

```html
<div>
    我是一个div
    <p>
        我是div中的p元素
        <span>我是p元素中的span</span>
    </p>
    <span>我是div中的span</span>
</div>
```

```css
/*
子元素选择器
 */
div > span{
    color: red;
}
```

```css
/*
后代元素选择器
 */
div span{
    color: skyblue;
}
```

```css
/*
兄弟元素选择器
紧挨着的下一个兄弟
 */
p + span{
    color: tomato;
}
```

```css
/*
兄弟元素选择器
之后所有兄弟
 */
p ~ span{
    color: tomato;
}
```

#### 属性选择器

```html
<p title="abc">1</p>
<p title="abcdef">2</p>
<p title="hello">3</p>
<p>4</p>
<p>5</p>
<p>6</p>
```

```css
/*
[属性名]选择含有指定属性的元素
 */
p[title]{
    font-size: 50px;
    color: orange;
}
```

```css
/*
[属性名=属性值]选择含有指定属性，并且值等于属性值的元素
 */
p[title=abc]{
    font-size: 50px;
    color: orange;
}
```

```css
/*
[属性名^=属性值]选择含有指定属性，并且值以属性值开头的元素
 */
p[title^=abc]{
    font-size: 50px;
    color: orange;
}
```

```css
/*
[属性名$=属性值]选择含有指定属性，并且值以属性值结尾的元素
 */
p[title$=c]{
    font-size: 50px;
    color: orange;
}
```

```css
/*
[属性名*=属性值]选择含有指定属性，并且值中含有属性值的元素
 */
p[title*=e]{
    font-size: 50px;
    color: orange;
}
```

#### 伪类选择器

> 不存在的类，用来描述一个元素的状态
>
> 比如第一个元素，被点击的元素，鼠标移入的元素

> :first-child	第一个子元素
>
> :last-child	最后一个子元素
>
> :nth-child(n)	第n个子元素，也可以直接写n，表示所有。2n（even）表示偶数位。2n+1（odd）表示奇数位

```css
ul > li:first-child{
    color: red;
}
```

```html
<ul>
    <span>我是span</span>
    <li>1</li>
    <li>2</li>
    <li>3</li>
    <li>4</li>
    <li>5</li>
</ul>
```

> 注意，如果是这样，就没有任何被选中

> :first-of-type
>
> :last-of-type
>
> :nth-of-type()
>
> 用法和上面的一样，但是能解决刚才的问题，它只在这个类别中找

> :not
>
> 将符合条件的元素从选择器中去除

```css
ul > li:not(:nth-child(3)){
    font-size: 50px;
    color: tan;
}
```

```css
a:link{
    color: orange;
    font-size: 50px;
}
```

> :link	表示没访问过的链接
>
> :visited	表示访问过的链接
>
> 由于隐私的原因visited只能修改颜色
>
> 这两个基本上用不到

> :hover	表示鼠标移入
>
> :active	表示鼠标点击

#### 伪元素

```css
p::first-letter{
    font-size: 50px;
}
```

> ::first-letter	第一个字母
>
> ::first-line	第一行
>
> ::selection	选中的内容

> ::before	元素的开始
>
> ::after	元素的结束
>
> 必须结合content属性来使用

```css
div::before{
    content: 'abc';
    color: red;
}
```

> 会在div前增加红色的abc

#### 练习

> https://flukeout.github.io/
>
> 有个特别好玩的css选择器的练习



### 继承

```html
<p>
    我是一个p
    <span>我是p中span</span>
</p>
```

```css
p{
    color: red;
}
```

> 这是span也会变红
>
> 我们为一个元素设置样式的同时，也会作用于它的后代上

> 并不是所有的样式都会被继承
>
> 比如背景相关的，布局相关的等样式不会被继承



### 选择器的权重

> 当不同的选择器选中相同的元素，并且为相同的样式设置不同的值，此时就发生了冲突

> 选择器的权重（从高到低）：
>
> 内联样式
>
> id选择器
>
> 类和伪类选择器
>
> 元素选择器
>
> 通配选择器
>
> 继承的样式



### 像素和百分比

> 长度单位：
>
> 像素
>
> 百分比	可以将属性设置为相对于其父类的百分比



### em和rem

> em是相对于元素的字体大小来计算
>
> 1 em = 1 font-size
>
> em会随着字体大小改变而改变

> rem是相对于根元素（html标签）的字体大小来计算



## 文档流

> normal flow
>
> 网页是一个多层结构，一层压着一层
>
> 通过css可以为每一层设置样式
>
> 用户只能看到最顶上一层
>
> 最下面一层称作文档流
>
> 我们创建的元素默认都是在文档流中进行排列

> 对我们来说元素主要有两个状态
>
> 在文档流中
>
> 不在文档流中（脱离文档流）

> 元素在文档流中有什么特点
>
> 块元素：
>
> 1. 块元素会在页面中独占一行
> 2. 默认宽度是父元素的全部（撑满）
> 3. 默认高度是被子元素撑开
>
> 行内元素：
>
> 1. 行内元素不会独占一行，只占自身大小
> 2. 在页面中自左向右水平排列，如果一行无法容纳，则换行
> 3. 默认高度和宽度都是被内容撑开



## 盒子模型

> 盒子模型，又称盒模型，框模型，box model
>
> CSS将页面中的所有元素都设置为一个矩形的盒子
>
> 将元素设置为矩形的盒子后，对页面的布局就变成了将不同的盒子摆放到不同的位置

> 每一个盒子都由以下几个部分组成
>
> 内容区（content）
>
> 边框（border）
>
> 内边距（padding）
>
> 外边距（margin）

### 内容区

> 元素中的所有子元素和文本内容都在内容区中排列
>
> 内容区的大小由width和height来设置

### 边框

> 边框属于盒子的边缘
>
> 设置边框至少设置三个样式：
>
> **border-width(宽度)**
>
> **border-color(颜色)**
>
> **border-style(边框样式)**

> **border-width(宽度)**
>
> 默认一般是3px
>
> 也可以写四个值，分别对应上右下左
>
> 如果不写左，左边会跟右边相同，上下同理
>
> 也可以使用border-top-width,border-left-width等来分别某一个边的宽度
>
> **颜色与样式也可以分别指定，规则一样**

> **border-color(颜色)**
>
> 默认为前景色color的值，如果没有前景色。默认为black

> **border-style(边框样式)**
>
> 默认值是none，没有
>
> solid	实现
>
> dotted	点状虚线
>
> dashed	线状虚线
>
> double	双线

> 同时设置三个值有点麻烦，可以通过
>
> border同时设置三个值，没有顺序要求
>
> 我们会常用这种方法来设置边框
>
> 这里面也可以使用border-xxx来分别指定

### 轮廓

> outline用来设置元素的轮廓，用法和border一样
>
> 轮廓不会影响可见框的大小，不会影响布局

### 阴影

> box-shadow用来设置元素的阴影效果，阴影不会影响布局
>
> 默认情况阴影在元素的正下方
>
> box-shadow 10 10 10 black
>
> 前两个值代表偏移量
>
> 第三个值代表模糊半径

### 圆角

> border-radius用来设置圆角
>
> border-top-left-radius
>
> border-top-right-radius
>
> border-bottom-left-radius
>
> border-bottom-right-radius
>
> 可以分别设置
>
> 后面加上圆角半径
>
> 如果添加两个值，第一个值是水平方向半径，第二个值是垂直方向半径
>
> 如果使用border-radius统一指定椭圆该怎么做
>
> 要把椭圆的参数使用 / 隔开
>
> 如果我们想要一个圆形
>
> border-radius 50%

### 内边距

> 内容区和边框的距离称作内边距
>
> 内边距的设置会影响盒子的大小
>
> 背景颜色会延伸到内边距上

### 外边距

> 外边距不会影响盒子可见框的大小
>
> 外边距会影响盒子的位置
>
> 外边距可以为负值

### 水平方向布局

> 一个元素在其父元素中，水平布局必须满足以下等式
>
> 水平外边距+水平边框+水平内边距+内容宽度 = 其父元素内容区的宽度
>
> 如果不相等，则成为过渡约束，会自动调整为相等

> 如果这些值中没有auto，则会自动调整右外边距
>
> width，margin-left，margin-right可以设置为auto，则会调整为auto的值，以使等式成立
>
> width的值默认是auto
>
> 如果将宽度和一个外边距设置为auto，则宽度会调整到最大，auto的外边距会自动为0
>
> 如果都是auto，外边距会为0，宽度为最大
>
> 如果宽度固定，两个外边距为auto，则会平均分配两个外边距

### 垂直方向布局

> 默认情况下，父元素的高度被内容撑开
>
> 子元素是在父元素的内容区中排列，如果子元素的大小超过了父元素，则子元素会溢出

> 使用overflow属性来设置父元素如何处理溢出的子元素
>
> visible	默认值，子元素会溢出，在外部显示
>
> hidden	隐藏溢出的部分
>
> scroll	生成滚动条
>
> auto	根据需要生成滚动条，需要垂直方向还是水平方向，只会生成需要的
>
> 还可以使用overflow-x，overflow-y，单独为某个方向指定规则

### 外边距的折叠

```html
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <style>
        .box1,.box2{
            width: 200px;
            height: 200px;
        }
        .box1{
            background-color: skyblue;
            margin-bottom: 100px;
        }
        .box2{
            background-color: orange;
            margin-top: 100px;
        }
    </style>
</head>
<body>
    <div class="box1"></div>
    <div class="box2"></div>
</body>
</html>
```

> 按理来说这两个box应该垂直方向是200px的间距
>
> 实际上只有100px
>
> 相邻的垂直方向外边距会发生重叠现象

> 兄弟元素间的相邻垂直外边距
>
> 会取两者的最大值
>
> 如果两者中有一个负值，则取两者之和
>
> 如果两者都是负值，则取负值较大者

> 父子元素间的相邻垂直外边距
>
> 子元素的会传递给父元素
>
> 如果我想把子元素在父元素内部推动完美的处理方案以后会讲

### 行内元素盒子模型

> 行内元素不支持设置宽高
>
> 可以设置padding，垂直方向padding不会影响布局，如果重叠会盖住
>
> 可以设置border，垂直方向border不会影响布局，如果重叠会盖住
>
> 可以设置margin，垂直方向margin不会影响布局，水平方向也不会重叠

> display用来设置元素的显示类型
>
> inline	将元素设置为行内元素
>
> block	将元素设置为块元素
>
> inline-block	将元素设置为行内块元素，既可以设置宽高，又不会独占一行
>
> table	将元素设置为表格
>
> none	元素不在页面中显示

> visibility用来设置元素的显示状态
>
> visible	默认值，可见
>
> hindden	不可见

> visibility hidden与display none的区别是
>
> visibility hidden不可见但是会占据位置
>
> display none不可见的时候不占据位置

### 盒子的大小

> box-sizing用来设置盒子尺寸的计算方式
>
> content-box	默认值，宽度和高度用来设置内容区大小
>
> border-box	宽度和高度用来设置整个盒子可见框大小（内容区，内边距，边框总大小）

## 浏览器的默认样式

> 通常情况，浏览器都会为元素设置默认样式
>
> 默认样式的村庄会影响页面的布局
>
> 通常情况下必须要去除浏览器默认样式（通常指PC端）

```css
*{
    margin: 0;
    padding: 0;
}
```

> 使用这样来去除简单的默认样式
>
> 但每个默认样式都不同，不能一概而论

> 不止我们一个人有这样的问题
>
> 所以直接copy一份重置样式表，引入即可
>
> **reset.css	直接去除默认样式**
>
> **normalize.css	对默认样式进行统一**



## 浮动

> 通过浮动可以使一个元素向其父元素左侧或者右侧移动
>
> float
>
> none	默认值，不浮动
>
> left	向左
>
> right	向右

> 元素设置浮动以后
>
> 1. 水平布局的等式就会失效，不需要强制成立
>
> 2. 元素会从文档流中脱离，不再占据位置

> 浮动的特点
>
> - 浮动的元素会脱离文档流，不再占据文档流中的位置
> - 设置浮动以后，元素会向父元素左或右移动
> - 浮动元素默认不会从父元素中移出
> - 浮动元素向左或向右移动时，不会超过前面的其他的浮动元素
> - 浮动元素不会超过它上边浮动的兄弟元素，最多和它一样高

> 浮动元素不会盖住文字，文字会自动环绕在浮动元素的周围

> 元素设置浮动以后，其元素的特点也会发生变化
>
> * 块元素不再独占一行，宽度和高度都被内容撑开
>
> * 行内元素会变成块元素
>
>**脱离文档流以后，不再区分块和行内了**



### 高度塌陷问题

> 一般来说我们高度值都不会设置为定值，而是根据内容撑开
>
> 但是如果浮动，脱离文档流，无法撑起父元素高度，父元素高度就是0
>
> 这就是高度塌陷

### BFC

> Block Formatting Content块级格式化环境
>
> BFC是css中的一个隐含的属性，可以为一个元素开启BFC
>
> 开启BFC，该元素会变成一个独立的布局环境

> 开启BFC后的特点：
>
> * 开启BFC的元素，不会被浮动元素所覆盖
> * 开启BFC的元素，子元素和父元素外边距不会重叠
> * 开启BFC的元素，可以包含浮动的子元素

> 如何开启BFC
>
> - 设置元素的浮动（不推荐）
> - 将元素设置为行内块元素（不推荐）
> - 将元素的overflow设置为一个非visible的值，常用的值是hidden

### clear

> 如果我们不希望某个元素因为其他元素浮动而影响位置
>
> 可以通过clear属性来消除影响

> clear可以清楚浮动元素对当前元素的影响
>
> left	清除左侧浮动元素的影响
>
> right	清除右侧浮动元素的影响
>
> both	清除两侧浮动元素影响中的最大值

> 原理：
>
> 设置clear以后，浏览器会自动为元素添加一个（和浮动元素一样大的）上外边框，以使其不受其他元素影响

### 终极解决方案

```css
.cleaarfix::before,
.cleaarfix::after{
    content: '';
    display: table;
    clear: both;
}
```

> 既可以解决塌陷
>
> 又可以解决外边距重叠



## 定位

> 定位是一种更加高级的定位手段
>
> 通过定位可以将元素摆放到页面的任意位置
>
> 使用position属性来设置定位

> static	默认值，元素是静止的，没有开启定位
>
> relative	开启元素的相对定位
>
> absolute	开启元素的绝对定位
>
> fixed	开启元素的固定定位
>
> sticky	开启元素的粘滞定位

### 偏移量

> 当元素开启了定位后，可以通过偏移量来设置元素的位置
>
> top	定位元素和定位位置上面的距离
>
> bottom	定位元素和定位位置下面的距离
>
> left	定位元素和定位位置左面的距离
>
> right	定位元素和定位位置右面的距离

### 相对定位

> 当元素的position属性值设置为relative，则开启了元素的相对定位

> 特点：
>
> * 元素开启相对定位以后，如果不设置偏移量，元素不会发生任何变化
> * 相对定位，是参照元素在文档流中的位置
> * 相对定位会提升元素的层级
> * 相对定位不会使元素脱离文档流

### 绝对定位

> 当元素的position属性值设置为absolute，则开启了元素的绝对定位

> 特点：
>
> * 元素开启绝对定位以后，如果不设置偏移量，元素不会发生任何变化
> * 元素会从文档流中脱离
> * 行内元素变成块，块的宽高被内容撑开
> * 绝对定位会提升元素的层级
> * 绝对定位元素是相对于其包含块进行定位的

> 包含块
>
> 正常情况下包含块就是离当前元素最近的祖先块
>
> 在绝对定位中包含块就是离它最近的，开启了定位的祖先元素。如果所有祖先元素都没有开启定位，则相对点是根元素

> 当我们开启了绝对定位以后，水平方向等式就要添加了left和right两个值
>
> 垂直方向的等式也必须满足

### 固定定位

> 当元素的position属性值设置为fixed，则开启了元素的固定定位
>
> 固定定位也是一种绝对定位，所以大部分特点与绝对定位一样
>
> 不同的是，固定定位用于参照于浏览器的视口进行定位

> 浏览器视口：浏览器的可视窗口

### 粘滞定位

> 当元素的position属性值设置为sticky，则开启了元素的粘滞定位
>
> 兼容性不是很好，需要很新的浏览器，并且不支持IE，了解即可
>
> 粘滞定位和相对定位特点基本一致
>
> 不同点是，粘滞定位，可以在元素到达某个位置时将其固定
>
> 比如：导航栏要开始消失了，就将其固定住

### 元素层级

> 对于开启了定位的元素
>
> 可以通过z-index来指定元素的层级
>
> z-index需要一个整数，值越大层级越高

> 祖先元素永远不会盖住后代元素



## 字体

> 字体相关的样式
>
> color	前景色
>
> font-size	字体大小
>
> font-family	指定字体族

> 字体族可以直接写某一个（几个，用逗号分割）字体具体名
>
> 如果写了很多个，会先用第一个，如果无法使用则用下一个，一般会用一个字体族作为最后一个保险
>
> 还可以直接写字体族，常用的有
>
> serif	衬线字体
>
> sans-serif	非衬线字体
>
> monospace	等宽字体

> 如果一定要用户使用某个字体
>
> 可以将字体文件存在项目中
>
> 并且加入@font-face语句，让用户从服务器下载指定字体并使用

```css
@font-face {
    /* 指定字体名称 */
    font-family: 'myfont';
    /* 服务器中字体文件路径 */
    src: url("./font/xxxxxx");
}
```

### 图标字体

> 在网页中，经常需要使用一些图标
>
> 可以通过图片来引入
>
> 但是图片大小比较大，并且不灵活
>
> 我们还可以将图标设置为字体
>
> 通过font-face来进行引入，这样我们可以通过使用字体的方式使用图标

> 推荐两个网站
>
> 阿里图标字体库
>
> font awesome（这个用起来更简单）

> font awesome使用步骤
>
> 1. 下载、解压
>
> 2. 将css和webfonts目录拷贝到项目中，这两个目录要在同一级目录下
>
> 3. 将all.css引入

```html
<i class="fas fa-bell"></i>
```

> fas 你要用的图标名
>
> 或
>
> fab 你要用的图标名

```html
<span class="fas">&#xf0f3;</span>
```

> 也可以这样引入
>
> &#x图标的编码；

```css
li::before{
    content: "\f0f3";
    font-family: "Font Awesome 5 Free";
}
```

> 也可以这样批量使用

### 行高

> 行高指文字占有的实际高度
>
> 可以通过line-height来设置行高
>
> 除了设置px em之外开可以直接设置一个整数，代表是字体的多少倍（默认就是1.33倍）

> 字体框，就是字体存在的格子
>
> 设置font-size实际上就是在设置字体框的高度
>
> 行高会在字体框上下平均分配

> 行高也会经常用来设置行间距

### 字体简写属性

> font可以设置字体相关的所有属性

```css
font: 50px 'Times New Roman', Times, serif; 
/*同时指定行高*/
font: 50px/2 'Times New Roman', Times, serif; 
/*同时设置加粗*/
font: bold 50px/2 'Times New Roman', Times, serif; 
/*同时设置加粗倾斜*/
font: italic bold 50px/2 'Times New Roman', Times, serif; 
```

> font-wetight	字体加粗级别100-900 9个，noraml，bold
>
> font-style	normal正常，italic斜体

### 文本的样式

> text-align	文本对齐方式left、right、center、justify（两端对齐）

> vertical-align	垂直对齐方式
>
> baseline	基线对齐
>
> top	顶部对齐
>
> bottom	底部对齐
>
> middle	居中对齐（参考基线的居中）
>
> 也可以写偏移量100px

> 图片添加的时候默认也是以基线来对齐
>
> 也可以添加vertical-align 非基线的值，来消除空白

### 其他文本样式

> text-decoration	文本修饰
>
> none	什么都没有
>
> underline	下划线
>
> line-through	删除线
>
> overline	上划线
>
> 在underline后还可以跟颜色与下划线样式，但IE不支持这个功能

> white-space	设置网页如何处理空白
>
> normal	正常情况
>
> nowrap	不换行
>
> pre	保留空白

> 省略过长文本
>
> 在white-space设置为nowrap的情况下
>
> 设置overflow：hidden会将多余内容裁减掉
>
> 设置text-overflow：ellipsis会将多余内容转变为省略号



## 背景

> background-image: url()可以设置背景图片
>
> 如果图片小于元素会平铺，如果图片小于元素图片部分无法完全显示

> 通过该background-repeat来设置背景重复方式
>
> repeat	默认值，沿着x，y轴重复
>
> repeat-x	沿着x轴重复
>
> repeat-y	沿着y轴重复
>
> no-repeat	不重复

> background-position设置图片位置
>
> top left	左上角
>
> 通过top、left、right、bottom、center组合使用
>
> 只写一个值，第二个值默认是center
>
> 也可以通过偏移量来指定

> background-clip	设置背景范围
>
> border-box	默认值，背景会出现在边框下面
>
> padding-box	背景不会出现在边框，只会出现在内容区和内边距
>
> content-box	背景只会出现在内容区

> background-origin	设置背景偏移量的原点
>
> border-box	从边框处开始计算
>
> padding-box	默认值，从内边距处开始
>
> content-box	从内容区开始计算

> background-size	背景图片尺寸
>
> 宽	高	指定图片宽高（只设置一个值，则等比例缩放）
>
> cover	比例不变，铺满元素
>
> contain	比例不变，完整显示

> background-attachment	背景图片是否跟随元素移动
>
> scroll	默认值，背景会跟着元素移动
>
> fixed	固定在页面中

> 可以使用background将这些值一起设置

```css
background: url() #bfa center center/contain border-box content-box no-repeat;
```

> background-size必须连在background-position的后面用/分割
>
> background-origin background-clip必须按顺序写

### 雪碧图

> 将一个图标的多种状态放在同一个图片文件中
>
> 以降低访问次数加快访问速度，而且可以解决闪烁问题
>
> 其实就是一张宽图片，将不同状态都放在其中

```css
a:link{
    display: block;
    wideth: 100px;
    height: 30px;
    background-image: url(....);
}
a:hover{
    background-position: -100px 0;
}
a:active{
    background-position: -200px 0;
}
```

> 然后将图片左移即可

> 雪碧图的使用步骤：
>
> 1. 确定要使用的图标
> 2. 测量图标的大小
> 3. 根据测量结果创建元素
> 4. 将雪碧图设置为元素的背景图片
> 5. 设置偏移量

## 渐变

> 通过渐变可以设置一些复杂的背景颜色，可以从一个颜色向其他颜色过渡
>
> 通过background-image来设置

> linear-gradient()	线性渐变
>
> 第一个值，to top right 渐变方向，xxxdeg表示度数，xturn表示x圈
>
> 第二个值，开始颜色
>
> 第三个值，结束颜色

> 也可以继续写颜色，会多色渐变，并且平均分配
>
> 也可以为每个颜色指定宽度
>
> red 50px，yellow 100px

> repeating-linear-gradient()	平铺的线性渐变
>
> 比如red 50px，yellow 100px
>
> 整个元素是300
>
> 就会循环两次

> radial-gradient()	径向渐变（放射性）
>
> 默认情况下，形状是根据元素的形状来计算的

> 或者手动指定渐变的大小
>
> radial-gradient(100px 100px, red, yellow)

> 也可以使用
>
> repeating-radial-gradient(100px 100px, red, yellow)使其重复（平铺）

> 也可以指定圆的形状
>
> circle	默认值，正圆
>
> ellipse	椭圆
>
> radial-gradient(ellipse, 100px 100px, red, yellow)

> 也可以手动指定圆心
>
> radial-gradient(100px 100px at 0 0, red, yellow)

## 表格

> 使用table标签来穿甲表格
>
> tr表示行
>
> td表示列
>
> colspan表示横向合并
>
> rowspan表示纵向合并

> 一个表格可以分成三个部分
>
> thead	头部
>
> tbody	主体
>
> tfoot	底部
>
> th	表示头部单元格，会加粗
>
> 如果表格中没有tbody而直接使用tr，那么浏览器会自动创建一个tbody将tr放到tbody中。**所以我们无法通过table选择tr子元素**

> border-spacing	指定边框之间的距离
>
> border-collapse	设置边框的合并

> 默认情况下元素在td中是垂直居中的
>
> vertical-align指定垂直排列方式
>
> text-align指定水平排列方式



## 表单

> 网页中的表单用于将本地数据提交给服务器
>
> 使用form标签来创建一个表单

> form表单的属性
>
> action	表示要提交服务器的地址

```html
<form action="">
    <!--文本框-->
    用户名：<input type="text" name="username" value="在此输入用户名"><br>
    <!--密码框-->
    密码：<input type="password" name="password"><br>
    <!--单选按钮-->
    性别：
    <input type="radio" name="gender" value="male" checked>男
    <input type="radio" name="gender" value="female">女<br>
    <!--多选框-->
    爱好：
    <input type="checkbox" name="hobby" value="Java">Java
    <input type="checkbox" name="hobby" value="C++">C++
    <input type="checkbox" name="hobby" value="Python">Python<br>
    <!--下拉列表-->
    国籍：
    <select name="nation">
        <option value="china">中国</option>
        <option value="america">美国</option>
    </select><br>
    <!--提交按钮-->
    <input type="submit" value="我是提交按钮名">
    <!--按钮-->
    <input type="button" value="我是按钮名">
    <!--重置-->
    <input type="reset" value="重置">
</form>
```



## 动画

### 过渡

> transition设置过渡
>
> 设置属性切换的方式

> transition-peoperty	指定要执行过渡的属性，多个属性间用逗号隔开，所有属性使用all
>
> transition-duration	指定过渡效果的持续时间，可以为每个属性单独指定过渡时间，使用逗号隔开
>
> transition-delay	设置过渡效果的延迟

> transition-timing-function	过渡的时序函数，指定过渡的执行方式
>
> ease	默认值，慢速开始，先加速，再减速
>
> line	匀速
>
> ease-in	加速
>
> ease-out	减速
>
> ease-in-out	先加速后减速
>
> cubie-bezier()	指定贝塞尔曲线
>
> steps()	分步执行，如果设置第二个值，代表在时间开始执行还是结束时执行（1s的开始还是结束）

> 可以用transition同时设置这些属性
>
> 只有一个要求，如果要写延迟，第一个时间代表持续时间，第二个时间代表延迟

### 动画

> 动画与过渡类似，可以实现动态效果
>
> 动画不需要被触发

```css
@keyframes test{
    to{}
    from{}
}
```

> 设置关键帧
>
> to代表结束位置
>
> from代表开始位置

> 在元素中使用
>
> animation-name来使用关键帧
>
> 并为animation-duration指定动画执行时间
>
> animation-iteration-count指定动画执行次数，值可以为infinite无限
>
> animation-direction指定动画方向，normal或reverse正反向，alternate或alternate-reverse往复执行
>
> animation-play-state	runing或paused

> animation-fill-mode	动画执行完毕停在哪
>
> none默认值，回到元素原来的位置
>
> forwards停在动画结束的位置
>
> backwards动画延迟等待时，元素处在开始位置
>
> both结合forwards和backwards

### 变形

> tansform来指定变形

> tanslateX（值） X轴移动
>
> tanslateY（值） Y轴移动
>
> tanslateZ（值） Z轴移动

> rotateX/Y/Z	旋转

> scaleX/Y	缩放



## less

> less是css的预处理语言
>
> 通过less可以编写更少的代码实现更强大的样式
>
> 在less中添加了许多新特性，对变量的支持，对mixin的支持等

```less
body{
  width: 200px;
  height: 200px;
  div{
    color: red;
  }
```

```css
body {
  width: 200px;
  height: 200px;
}
body div {
  color: red;
}
```

> 在less中写的代码会被自动转换为css

### 变量

```less
@a:100px;
@b:orange;
@c:box6;
.box5{
  width: @a;
  color: @b;
}
.@{c}{
  width: @a;
}
```

```css
.box5 {
  width: 100px;
  color: orange;
}
.box6 {
  width: 100px;
}
```

> 编译后自动变成100px
>
> 作为类名，使用时要使用@{c}
>
> 作为url，使用@{c}加双引号

### 父级元素

```less
.box1{
  color: red;

  .box2{
    color: red;
  }
  //&表示外层父元素
  &:hover{
    color: orange;
  }
}
```

```css
.box1 {
  color: red;
}
.box1 .box2 {
  color: red;
}
.box1:hover {
  color: orange;
}
```

### 继承

```less
.p1{
  width: 100px;
  height: 200px;
}
.p2:extend(.p1){
  color: red;
}
```

```css
.p1,
.p2 {
  width: 100px;
  height: 200px;
}
.p2 {
  color: red;
}
```

### mixin

```less
.p1{
  width: 100px;
  height: 200px;
}
.p2{
  .p1();
}
```

```css
.p1 {
  width: 100px;
  height: 200px;
}
.p2 {
  width: 100px;
  height: 200px;
}
```

### 混合函数

```less
.test(@w){
  width: @w;
  height: @w;
  border: 1px red solid;
}

div{
  .test(200px);
}
```

```css
div {
  width: 200px;
  height: 200px;
  border: 1px red solid;
}
```

### 其他特性

```less
.box1{
    width: 100px + 100px;
}
```

> 在less中，所有的数值可以直接进行运算

```less
@import "style2.less"
```

> 引入其他的less



## 弹性盒

> flex(弹性盒，伸缩盒)
>
> 是css中又一种布局手段，主要代替浮动来完成页面的布局
>
> flex可以使元素具有弹性，让元素可以跟随页面大小的改变而改变

> 要使用弹性盒，必须先将一个元素设置为弹性容器
>
> display: flex	设置为块级弹性容器
>
> display: inline-flex	设置为行内弹性容器

> 弹性容器的直接子元素是弹性元素
>
> 一个元素可以同时是弹性容器，也是弹性元素

```html
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>flex</title>
    <style>
        *{
            margin: 0;
            padding: 0;
            list-style: none;
        }
        ul{
            width: 800px;
            border: red solid 10px;
            /*将其设置为弹性容器*/
            display: flex;
        }
        li{
            width: 100px;
            height: 100px;
            background-color: #bfa;
            font-size: 50px;
            text-align: center;
        }
        li:nth-child(2){
            background-color: pink;
        }
        li:nth-child(3){
            background-color: orange;
        }
    </style>
</head>
<body>
    <ul>
        <li>1</li>
        <li>2</li>
        <li>3</li>
    </ul>
</body>
</html>
```

![image-20210823190824045](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\JavaWeb\补充\HTML+CSS\HTML CSS.assets\image-20210823190824045.png)

> flex-direction	用来指定弹性容器中元素的排列方式
>
> row	默认值，水平排列
>
> row-reverse	反向水平排列，又右至左排列，右对齐，效果  空---------------空321
>
> colum	垂直排列
>
> colum-reverse	垂直反向排列



### 主轴与侧（辅）轴

> 弹性元素的排列方向称为主轴
>
> 与主轴方向垂直的为侧轴



### 弹性元素

> flex-grow	
>
> 指定元素的伸展系数
>
> 当父元素有空余空间时，子元素如何伸展
>
> 父元素的剩余空间，会按比例进行分配，后面跟的值越大，占比越大
>
> 如下，123一共占6份，1占1份，2占2份，3占3份

```css
li{
    width: 100px;
    height: 100px;
    background-color: #bfa;
    font-size: 50px;
    text-align: center;

    /*弹性元素的属性*/
    flex-grow: 1;
}
li:nth-child(2){
    background-color: pink;
    flex-grow: 2;
}
li:nth-child(3){
    background-color: orange;
    flex-grow: 3;
}
```

![image-20210823191520326](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\JavaWeb\补充\HTML+CSS\HTML CSS.assets\image-20210823191520326.png)

> flex-shrink
>
> 指定元素的收缩系数
>
> 当父元素不足以容纳所有子元素时，子元素如何收缩
>
> 值越大缩的越多



### 容器的属性

![image-20210823192233692](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\JavaWeb\补充\HTML+CSS\HTML CSS.assets\image-20210823192233692.png)

> flex-wrap
>
> 设置元素在弹性容器中自动换行
>
> nowrap	默认值，不会自动换行
>
> wrap	元素沿辅轴自动换行
>
> wrap-reverse	元素沿辅轴反向自动换行

> flex-flow	wrap和direction的简写

![image-20210823192432840](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\JavaWeb\补充\HTML+CSS\HTML CSS.assets\image-20210823192432840.png)

> justify-content	如何分配主轴的空白空间
>
> flex-start	元素沿着主轴起边排列，如图，起边可以理解为起始点，从左往右，起始点就是左
>
> flex-end	元素沿着主轴终边排列
>
> center	居中排列
>
> space-around	空白分布到元素两侧，每个元素两侧都有空白
>
> space-evenly	空白分布到元素单侧，如果重合部分只算做一份，不再计算为两份
>
> space-between	空白分布到元素间

![image-20210823193429010](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\JavaWeb\补充\HTML+CSS\HTML CSS.assets\image-20210823193429010.png)

> align-items	元素在辅轴上如何对齐
>
> stretch	默认值，将元素的长度设置为相同的值，将元素拉伸
>
> flex-start	元素不会拉伸，沿辅轴起边对齐
>
> flex-end	沿辅轴终边对齐
>
> center	居中对齐
>
> baseline	基线对齐

> align-content	辅轴空白空间分布，用法与justify-content一样



### 元素的属性

> flex-grow	弹性按比例增长系数
>
> flex-shrink	弹性按比例缩减系数

> flex-basis	元素在主轴上的基础长度
>
> 如果主轴是横向的，就相当于当前元素的width
>
> 如果主轴是纵向的，就相当于当前元素的height
>
> 默认值是auto，表示参考元素自身的width，height

> flex	可以设置弹性元素三个基础样式
>
> flex	增长系数	缩减系数	基础长度

> order	决定元素的排列顺序
>
> 越小优先级越高



## 移动端页面

> 为了保证移动端的体验
>
> 通常会给移动端专门写一个页面

> 编写移动端页面时，必须确保有一个合理的像素比
>
> 比如1css像素对应2个物理像素
>
> 我们可以通过改变视口的大小来改变css像素和物理像素的比值
>
> 移动端默认视口大小是980px（css像素），移动端像素比是980/750
>
> 每一款移动设备设计时，都有一个最佳像素比，我们只需要将像素比设定为这个值就是最好的效果

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

> device-width表示动态取设备的宽度，来达到最佳像素比
>
> initial-scale=1.0以防止取不到值，保险起见

### vw单位

> 由于不同设备视口和像素比不同
>
> 375像素在不同设备意义是不一样的
>
> 在iphone6中，375是全屏，而在plus中就会缺一块
>
> **在移动端开发中就不能使用px进行布局**

> vw表示视口宽度
>
> 100vw	=	一个视口宽度





