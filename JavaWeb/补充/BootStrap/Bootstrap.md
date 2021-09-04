# BootStrap

> BootStrap是一套现成的CSS样式合集
>
> 特别适合没有前端的团队，快速做出一个网页



## 下载与使用

> 导入dist目录

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
		<meta name="viewport" content="width=device-width, initial-scale=1"/>
        	<title>BootStrap模板</title>
		<!-- 导入BootStrap的css -->
		<link rel="stylesheet" type="text/css" href="dist/css/bootstrap.min.css"/>
		<!-- 要使用BootStrap的js插件，要先导入jQuery -->
		<script src="js/jquery-3.4.1.min.js"></script>
		<script src="dist/js/bootstrap.min.js"></script>
		
	</head>
	<body>
		<h1>1111</h1>
	</body>
</html>
```



## 布局容器

```html
<div class="container" style="background-color: rebeccapurple; height: 1000px;">123</div>
<div class="container-fluid" style="background-color: rebeccapurple; height: 1000px;">123</div>
```

> container会默认两侧留边
>
> container-fluid则是全屏



## 栅格系统

> Bootstrap提供了一套响应式栅格系统
>
> 系统自动将视口分为12列，将内容放置在这些创建好的布局中

> 数据行（row）必须放在容器中（container）
>
> 行中可以添加列（column）

> 列有
>
> xs	手机
>
> sm	平板
>
> md	电脑
>
> lg	大屏幕

```html
<div class="container">
    <div class="row">
        <div class="col-md-4" style="background-color: red">1222233333</div>
        <div class="col-md-8" style="background-color: blue">222</div>
    </div>
</div>
```

```html
<div class="row">
    <div class="col-md-4" style="background-color: red">1222233333</div>
    <div class="col-md-4 col-md-offset-4" style="background-color: blue">222</div>
</div>
```

```html
<div class="container">
    <div class="row">
        <div class="col-md-2" style="background-color: red">111</div>
        <div class="col-md-2 col-md-push-2" style="background-color: blue">222</div>
        <div class="col-md-2" style="background-color: greenyellow">333</div>
    </div>
</div>
```

> push是向右，pull是向左，push或pull会被元素挡住
>
> offset会带着之后的元素一起动

```html
<div class="container">
    <div class="row">
        <div class="col-md-6" style="background-color: red">
            <div class="row">
                <div class="col-md-4" style="background-color: khaki">123</div>
                <div class="col-md-4" style="background-color: aqua">123</div>
            </div>
        </div>
        <div class="col-md-6" style="background-color: blue">222</div>
    </div>
</div>
```

> 列中还可以嵌套列

```html
<div class="container">
    <div class="row">
        <div class="col-md-6 col-xs-6" style="background-color: khaki">111</div>
        <div class="col-md-6 col-xs-6" style="background-color: rosybrown">222</div>
    </div>
</div>
```

> 可以为不同大小的屏幕指定不同的格式

## 常用样式

### 排版

#### 标题

> BootStrap为非标题提供了h1~h6的样式
>
> 并且提供了small副标题的样式

#### 突出

> lead突出内容
>
> <small>标签来设置小号字
>
> <b>标签设置加粗
>
> <i>设置斜体

#### 强调样式

> text-muted：提示，浅灰色
>
> text-primary：主要，蓝色
>
> text-success：成功，浅绿色
>
> text-info：通知，浅蓝色
>
> text-warning：警告，黄色
>
> text-danger：危险，褐色

#### 对齐

> text-left：左对齐
>
> text-right：右对齐
>
> text-center：居中
>
> text-justify：两端对齐

#### 列表

> list-unstyled	去点列表
>
> list-inline	水平列表
>
> dl-horizontal	水平定义列表，宽度过宽，会显示...

### 代码

> \<code>单行内联代码
>
> \<pre>代码块
>
> \<kbd>快捷键

### 表格

> table：基础表格
>
> table-striped：斑马线表格
>
> table-bordered：带边框表格
>
> table-hover：鼠标悬停高亮表格
>
> table-condensed：紧凑型表格

> tr，th，td样式
>
> active：悬停颜色应用在单元格上
>
> success：成功
>
> info：信息变化
>
> warning：警告
>
> danger：危险

### 表单

> form-control：表单基本样式
>
> input-lg：较大
>
> input-sm：较小
>
> 较大较小可以连在form-control 后面使用空格隔开

> 复选框
>
> checkbox：垂直显示
>
> checkbox-inline：水平显示

> 单选框
>
> radio：垂直显示
>
> radio-inline：水平显示

> 按钮
>
> btn：基本样式，后面可以接以下附加样式
>
> btn-primary
>
> btn-info
>
> btn-success
>
> btn-warning
>
> btn-danger
>
> btn-link
>
> btn-default
>
> 还可以再接大小
>
> btn-lg
>
> btn-sm
>
> btn-xs

