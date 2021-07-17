# JQuery

> * jQuery，顾名思义，也就是JavaScript 和查询（Query），它就是辅助JavaScript 开发的js 类库它的核心思想是write less,do more(写得更少,做得更多)，所以它实现了很多浏览器的兼容问题
> * jQuery 现在已经成为最流行的JavaScript 库，在世界前10000 个访问最多的网站中，有超过55%在使用jQuery
> * jQuery 是免费、开源的，jQuery 的语法设计可以使开发更加便捷，例如操作文档对象、选择DOM元素、制作动画效果、事件处理、使用Ajax 以及其他功能

## hello world

```html
    <script type="application/javascript">
      window.onload = function (){
        var btn01 = document.getElementById("btn01");
        btn01.onclick = function () {
          alert("hello World");
        }
      }
    </script>
</head>
<body>
    <button id="btn01">SayHello</button>
```

> 之前学的点击事件是这样写的

```html
    <script type="application/javascript" src="Demo/script/jquery-1.7.2.js"></script>
    <script type="application/javascript">
      $(function (){
        var $btn01 = $("#btn01");
        $btn01.click(function (){
          alert("hello JQuery");
        })
      });
    </script>
</head>
<body>
    <button id="btn01">SayHello</button>
```

> $：是JQuery定义的函数



## 核心函数

> $是JQuery的核心函数，能完成JQuery的很多功能
>
> 1. 传入参数为**[ 函数]** 时：表示页面加载完成之后。相当于window.onload = function(){}
>
> 2. 传入参数为**[ HTML 字符串]** 时：会对我们创建这个html 标签对象
>
> 3. 传入参数为**[ 选择器字符串]** 时：
>
>    **\$(“#id 属性值”); **id 选择器，根据id 查询标签对象
>
>    **\$(“标签名”);** 标签名选择器，根据指定的标签名查询标签对象
>
>    **\$(“.class 属性值”);** 类型选择器，可以根据class 属性查询标签对象
>
> 4. 传入参数为**[ DOM 对象]** 时：会把这个dom 对象转换为jQuery 对象

```html
<script type="application/javascript" src="Demo/script/jquery-1.7.2.js"></script>
<script type="application/javascript">
  $(function (){
    alert("页面加载完毕")
  });
</script>
```

```js
$(function (){
  $("<div>div1</div>").appendTo("body");
});
```

```js
$(function (){
  alert($("button").length);
});
```

```js
$(function (){
  var btn01 = document.getElementById("btn01");
  alert($(btn01));
});
```



## JQuery对象和DOM对象区分

> **DOM对象**
>
> 1. 通过getElementById()查询出来的标签对象是Dom 对象
>
> 2. 通过getElementsByName()查询出来的标签对象是Dom 对象
>
> 3. 通过getElementsByTagName()查询出来的标签对象是Dom 对象
>
> 4. 通过createElement() 方法创建的对象，是Dom 对象
>
>    
>
>    DOM 对象Alert 出来的效果是：[object HTML 标签名Element]

> **jQuery 对象**
>
> 1. 通过JQuery 提供的API 创建的对象，是JQuery 对象
>
> 2. 通过JQuery 包装的Dom 对象，也是JQuery 对象
>
> 3. 通过JQuery 提供的API 查询到的对象，是JQuery 对象
>
>    
>
>    jQuery 对象Alert 出来的效果是：[object Object]



### JQuery对象的本质

```js
var $btns = $("button");
for (var i = 0; i < $btns.length; i++) {
   alert($btns[i])    ;
}
```

> jQuery 对象是dom 对象的数组+ jQuery 提供的一系列功能函数



### JQuery对象和DOM对象使用区别

>  jQuery 对象不能使用DOM 对象的属性和方法
>
> DOM 对象也不能使用jQuery 对象的属性和方法

```js
document.getElementById("testDiv").innerHTML = "这是DOM对象的InnerHTML";
$("#testDiv").innerHTML = "这是JQuery对象的InnerHTML";//没有效果

document.getElementById("testDiv").click(function (){
   alert("click是JQuery对象的方法");
});//没有效果
```

 

### DOM对象和JQuery对象转换 （重点）

#### DOM对象转为JQuery对象

> 1. 先有DOM 对象
> 2. $( DOM 对象) 就可以转换成为jQuery 对象

#### JQuery对象转为DOM对象

> 1. 先有jQuery 对象
> 2. jQuery 对象[下标]取出相应的DOM 对象

```js
alert( $( document.getElementById("testDiv") ) );
alert( $( document.getElementById("testDiv") )[0] );
```



## JQuery选择器 （重点）

### 基本选择器

> **#ID 选择器：**根据id 查找标签对象
>
> **.class 选择器：**根据class 查找标签对象
>
> **element 选择器：**根据标签名查找标签对象
>
> **\* 选择器：**表示任意的，所有的元素
>
> **selector1，selector2 组合选择器：**合并选择器1，选择器2 的结果并返回

```js
//1.选择 id 为 one 的元素 "background-color","#bbffaa"
$(function (){
   $("#btn1").click(function (){
      $("#one").css("background-color","#bbffaa");
   });
});
```

> css方法可以设置和获取样式

```js
//2.选择 class 为 mini 的所有元素
$(function (){
   $("#btn2").click(function (){
      $(".mini").css("background-color","#bbffaa");
   });
});

//3.选择 元素名是 div 的所有元素 
$(function (){
    $("#btn3").click(function (){
        $("div").css("background-color","#bbffaa");
    });
});

//4.选择所有的元素 
$(function (){
    $("#btn4").click(function (){
        $("*").css("background-color","#bbffaa");
    });
});

//5.选择所有的 span 元素和id为two的元素   
$(function (){
    $("#btn5").click(function (){
        $("span,#two").css("background-color","#bbffaa");
    });
});
```

### 层级选择器

> **ancestor descendant 后代选择器：**在给定的祖先元素下匹配所有的后代元素
>
> **parent > child 子元素选择器：**在给定的父元素下匹配所有的子元素
>
> **prev + next 相邻元素选择器：**匹配所有紧接在prev 元素后的next 元素
>
> **prev ~ sibings 之后的兄弟元素选择器：**匹配prev 元素之后的所有siblings 元素

> **A B，指A内所有的B**
>
> **A > B，指A直接的子B（子的子不算）**
>
> **A + B，A后面紧跟着、同级的B**
>
> **A ~ B，与A同级，后面的B**

```js
$(document).ready(function () {
    //1.选择 body 内的所有 div 元素
    $("#btn1").click(function () {
        $("body div").css("background", "#bbffaa");
    });

    //2.在 body 内, 选择div子元素
    $("#btn2").click(function () {
        $("body > div").css("background", "#bbffaa");
    });

    //3.选择 id 为 one 的下一个 div 元素
    $("#btn3").click(function () {
        $("#id + div").css("background", "#bbffaa");
    });

    //4.选择 id 为 two 的元素后面的所有 div 兄弟元素
    $("#btn4").click(function () {
        $("#two ~ div").css("background", "#bbffaa");
    });
});
```

> \$(document).ready(function (){}) 是$(function(){})的全写



### 过滤选择器

#### 基本过滤器

> * `:first` 获取第一个元素
> * `:last` 获取最后个元素
> * `:not(selector)` 去除所有与给定选择器匹配的元素
> * `:even` 匹配所有索引值为偶数的元素，从0 开始计数
> * `:odd` 匹配所有索引值为奇数的元素，从0 开始计数
> * `:eq(index)` 匹配一个给定索引值的元素
> * `:gt(index)` 匹配所有大于给定索引值的元素
> * `:lt(index)` 匹配所有小于给定索引值的元素
> * `:header` 匹配如h1, h2, h3 之类的标题元素
> * `:animated` 匹配所有正在执行动画效果的元素

```js
$(document).ready(function(){
   //1.选择第一个 div 元素  
   $("#btn1").click(function(){
      $("div:first").css("background", "#bbffaa");
   });

   //2.选择最后一个 div 元素
   $("#btn2").click(function(){
      $("div:last").css("background", "#bbffaa");
   });

   //3.选择class不为 one 的所有 div 元素
   $("#btn3").click(function(){
      $("div:not(.one)").css("background", "#bbffaa");
   });

   //4.选择索引值为偶数的 div 元素
   $("#btn4").click(function(){
      $("div:even").css("background", "#bbffaa");
   });

   //5.选择索引值为奇数的 div 元素
   $("#btn5").click(function(){
      $("div:odd").css("background", "#bbffaa");
   });

   //6.选择索引值为大于 3 的 div 元素
   $("#btn6").click(function(){
      $("div:gt(3)").css("background", "#bbffaa");
   });

   //7.选择索引值为等于 3 的 div 元素
   $("#btn7").click(function(){
      $("div:lt(3)").css("background", "#bbffaa");
   });

   //8.选择索引值为小于 3 的 div 元素
   $("#btn8").click(function(){
      $("div:eq(3)").css("background", "#bbffaa");
   });

   //9.选择所有的标题元素
   $("#btn9").click(function(){
      $(":header").css("background", "#bbffaa");
   });

   //10.选择当前正在执行动画的所有元素
   $("#btn10").click(function(){
      $(":animated").css("background", "#bbffaa");
   });
});
```

#### 内容过滤器

> * `:contains(text)` 匹配包含给定文本的元素
> * `:empty` 匹配所有不包含子元素或者文本的空元素
> * `:parent` 匹配含有子元素或者文本的元素
> * `:has(selector)` 匹配含有选择器所匹配的元素的元素

```js
$(document).ready(function(){
   //1.选择 含有文本 'di' 的 div 元素
   $("#btn1").click(function(){
      $("div:contains('di')").css("background", "#bbffaa");
   });

   //2.选择不包含子元素(或者文本元素) 的 div 空元素
   $("#btn2").click(function(){
      $("div:empty").css("background", "#bbffaa");
   });

   //3.选择含有 class 为 mini 元素的 div 元素
   $("#btn3").click(function(){
      $("div:has(.mini)").css("background", "#bbffaa");
   });

   //4.选择含有子元素(或者文本元素)的div元素
   $("#btn4").click(function(){
      $("div:parent").css("background", "#bbffaa");
   });
});
```

#### 属性过滤器

> * `[attribute]` 匹配包含给定属性的元素
> * `[attribute=value]` 匹配给定的属性是某个特定值的元素
> * `[attribute!=value]` 匹配所有不含有指定的属性，或者属性不等于特定值的元素
> * `[attribute^=value]` 匹配给定的属性是以某些值开始的元素
> * `[attribute$=value]` 匹配给定的属性是以某些值结尾的元素
> * `[attribute*=value]` 匹配给定的属性是以包含某些值的元素
> * `[attrSel1] [attrSel2] [attrSelN]` 复合属性选择器，需要同时满足多个条件时使用

```js
$(function() {
   //1.选取含有 属性title 的div元素
   $("#btn1").click(function() {
      $("div[title]").css("background", "#bbffaa");
   });
   //2.选取 属性title值等于'test'的div元素
   $("#btn2").click(function() {
      $("div[title='test']").css("background", "#bbffaa");
   });
   //3.选取 属性title值不等于'test'的div元素(*没有属性title的也将被选中)
   $("#btn3").click(function() {
      $("div[title!='test']").css("background", "#bbffaa");
   });
   //4.选取 属性title值 以'te'开始 的div元素
   $("#btn4").click(function() {
      $("div[title^='te']").css("background", "#bbffaa");
   });
   //5.选取 属性title值 以'est'结束 的div元素
   $("#btn5").click(function() {
      $("div[title$='est']").css("background", "#bbffaa");
   });
   //6.选取 属性title值 含有'es'的div元素
   $("#btn6").click(function() {
      $("div[title*='es']").css("background", "#bbffaa");
   });
   
   //7.首先选取有属性id的div元素，然后在结果中 选取属性title值 含有'es'的 div 元素
   $("#btn7").click(function() {
      $("div[id][title*='es']").css("background", "#bbffaa");
   });
   //8.选取 含有 title 属性值, 且title 属性值不等于 test 的 div 元素
   $("#btn8").click(function() {
      $("div[title][title!='test']").css("background", "#bbffaa");
   });
});
```



#### 表单过滤器

> * `:input` 匹配所有input, textarea, select 和button 元素
> * `:text` 匹配所有文本输入框
> * `:password` 匹配所有的密码输入框
> * `:radio` 匹配所有的单选框
> * `:checkbox` 匹配所有的复选框
> * `:submit` 匹配所有提交按钮
> * `:image` 匹配所有img 标签
> * `:reset` 匹配所有重置按钮
> * `:button` 匹配所有input type=button \<button>按钮
> * `:file` 匹配所有input type=file 文件上传
> * `:hidden` 匹配所有不可见元素display:none 或input type=hidden

> 其实就是筛选form表单中type的值



#### 表单对象属性

> * `:enabled` 匹配所有可用元素
> * `:disabled` 匹配所有不可用元素
> * `:checked` 匹配所有选中的单选，复选，不包括下拉列表中选中的option 标签对象
> * `:selected` 匹配所有选中的option

> disabled="disabled"
>
> 加了这个属性的标签会变的不可用

```js
//1.对表单内 可用input 赋值操作
$("#btn1").click(function(){
   $(":text:enabled").val("New Value");
});
//2.对表单内 不可用input 赋值操作
$("#btn2").click(function(){
   $(":text:disabled").val("New Value Too");
});
//3.获取多选框选中的个数  使用size()方法获取选取到的元素集合的元素个数
$("#btn3").click(function(){
   alert($(":checkbox:checked").size())
});
//4.获取多选框，每个选中的value值
$("#btn4").click(function(){
   var $checkboxs = $(":checkbox:checked");
   $checkboxs.each(function (){
      alert(this.value);
   });
});
//5.获取下拉框选中的内容  
$("#btn5").click(function(){
   var $select = $("select option:selected");
   $select.each(function (){
      alert(this.value);
   });
});
```

> JQuery为我们提供了遍历方法each
>
> 在each方法函数中为我们提供了this对象，这个this对象就是当前遍历到的dom对象



#### 可见性过滤

> style = "dispaly : none";
>
> 加了这个属性的标签就会变为不可见
>
> 筛选器:hidden就是筛选不可见的内容
>
> :visible就是筛选可见的



## 元素筛选

> * `eq()` 获取给定索引的元素功能    **跟:eq() 一样**
> * `first()` 获取第一个元素功能    **跟:first 一样**
> * `last()` 获取最后一个元素功能    **跟:last 一样**
> * `filter(exp)` 留下匹配的元素
> * `is(exp)` 判断是否匹配给定的选择器，只要有一个匹配就返回，true
> * `has(exp)` 返回包含有匹配选择器的元素的元素功能    **跟:has 一样**
> * `not(exp)` 删除匹配选择器的元素功能    **跟:not 一样**
> * `children(exp)` 返回匹配给定选择器的子元素功能    **跟parent>child 一样**
> * `find(exp)` 返回匹配给定选择器的后代元素功能    **跟ancestor descendant 一样**
> * `next()` 返回当前元素的下一个兄弟元素功能    **跟prev + next 功能一样**
> * `nextAll()` 返回当前元素后面所有的兄弟元素功能    **跟prev ~ siblings 功能一样**
> * `nextUntil()` 返回当前元素到指定匹配的元素为止的后面元素
> * `parent()` 返回父元素
> * `prev(exp)` 返回当前元素的上一个兄弟元素
> * `prevAll()` 返回当前元素前面所有的兄弟元素
> * `prevUnit(exp)` 返回当前元素到指定匹配的元素为止的前面元素
> * `siblings(exp)` 返回所有兄弟元素
> * `add()` 把add 匹配的选择器的元素添加到当前jquery 对象中

> 元素筛选某些和过滤器一样

```js
$("li").first();
$("li:first");
//这是一个意思
```

```js
//(1)eq()  选择索引值为等于 3 的 div 元素
$("#btn1").click(function(){
   $("div").eq(3).css("background-color","#bfa");
});
//(2)first()选择第一个 div 元素
 $("#btn2").click(function(){
    //first()   选取第一个元素
   $("div").first().css("background-color","#bfa");
});
//(3)last()选择最后一个 div 元素
$("#btn3").click(function(){
   //last()  选取最后一个元素
   $("div").last().css("background-color","#bfa");
});
//(4)filter()在div中选择索引为偶数的
$("#btn4").click(function(){
   //filter()  过滤   传入的是选择器字符串
   $("div").filter(":even").css("background-color","#bfa");
});
 //(5)is()判断#one是否为:empty或:parent
$("#btn5").click(function(){
   alert( $("#one").is(":empty") );
});

//(6)has()选择div中包含.mini的
$("#btn6").click(function(){
   $("div").has(".mini").css("background-color","#bfa");
});
//(7)not()选择div中class不为one的
$("#btn7").click(function(){
   $("div").not(".one").css("background-color","#bfa");
});
//(8)children()在body中选择所有class为one的div子元素
$("#btn8").click(function(){
   $("body").children("div.one").css("background-color","#bfa");
});


//(9)find()在body中选择所有class为mini的div元素
$("#btn9").click(function(){
   $("div").find(".mini").css("background-color","#bfa");
});
//(10)next() #one的下一个div
$("#btn10").click(function(){
   $("#one").next("div").css("background-color","#bfa");
});
//(11)nextAll() #one后面所有的span元素
$("#btn11").click(function(){
   $("#one").nextAll("span").css("background-color","#bfa");
});
//(12)nextUntil() #one和span之间的元素
$("#btn12").click(function(){
   $("#one").nextUntil("span").css("background-color","#bfa")
});
//(13)parent() .mini的父元素
$("#btn13").click(function(){
   $(".mini").parent().css("background-color","#bfa");
});
//(14)prev() #two的上一个div
$("#btn14").click(function(){
   $("#two").prev("div").css("background-color","#bfa")
});
//(15)prevAll() span前面所有的div
$("#btn15").click(function(){
   $("span").prevAll("div").css("background-color","#bfa")
});
//(16)prevUntil() span向前直到#one的元素
$("#btn16").click(function(){
   $("span").prevUntil("#one").css("background-color","#bfa")
});
//(17)siblings() #two的所有兄弟元素
$("#btn17").click(function(){
   $("#two").siblings().css("background-color","#bfa")
});


//(18)add()选择所有的 span 元素和id为two的元素
$("#btn18").click(function(){
   $("span").add("#two").css("background-color","#bfa");
});
```



## 属性操作

> * `html()` 它可以设置和获取起始标签和结束标签中的内容    **跟dom 属性innerHTML 一样**
>
> * `text()` 它可以设置和获取起始标签和结束标签中的文本    **跟dom 属性innerText 一样**
>
> * `val()` 它可以设置和获取表单项的value 属性值    **跟dom 属性value 一样**
>
> * `attr() `可以设置和获取属性的值，不推荐操作checked、readOnly、selected、disabled 等等
>
>   attr 方法还可以操作非标准的属性。比如自定义属性：abc,bbj
>
> * `prop() `可以设置和获取属性的值,只推荐操作checked、readOnly、selected、disabled 等等



> val方法可以同时设置多个表单项的选中状态

```html
<script type="application/javascript">
      $(function (){
          $("input:radio").val(["radio1"]);
          $("input:checkbox").val(["checkbox2","checkbox3"]);
          $("#multiple").val(["mu1","mu3"]);
          $("#single").val(["si3"]);

         //或者可以一次性选中
       $("input:radio,input:checkbox,#multiple,#single").val(["radio1","checkbox2","checkbox3","mu1","mu3","si3"]);
      });
    </script>
</head>
<body>
    单选:
    <input type="radio" name="radio" value="radio1"/>radio1
    <input type="radio" name="radio" value="radio2"/>radio2
    <br/>
    多选：
    <input type="checkbox" name="checkbox" value="checkbox1" />checkbox1
    <input type="checkbox" name="checkbox" value="checkbox2" />checkbox2
    <input type="checkbox" name="checkbox" value="checkbox3" />checkbox3
    <br/>
    下拉多选：
    <select id="multiple" multiple="multiple" size="4">
        <option value="mu1">mu1</option>
        <option value="mu2">mu2</option>
        <option value="mu3">mu3</option>
        <option value="mu4">mu4</option>
    </select>
    <br/>
    下拉单选：
    <select id="single">
        <option value="si1">si1</option>
        <option value="si2">si2</option>
        <option value="si3">si3</option>
    </select>
```

```js
alert( $(":checkbox").attr("name") );//获取
$(":checkbox:first").attr("name","abc");//设置

alert( $(":checkbox:first").attr("checked") );
alert( $(":checkbox:first").prop("checked") );
```

> 如果没有定义默认选中
>
> attr会显示undefined，prop显示false
>
> 如果默认选中
>
> attr会显示checked，prop显示true



## DOM的增删改

### 内部插入

> * `appendTo()` a.appendTo(b) 把a 插入到b 子元素末尾，成为最后一个子元素
> * `prependTo()` a.prependTo(b) 把a 插到b 所有子元素前面，成为第一个子元素
>
> **这些操作时剪切，而不是复制**

```js
$("<h1>标题</h1>").appendTo("div");
$("<h1>标题</h1>").prependTo("div");
```



### 外部插入

> * `insertAfter()` a.insertAfter(b) 得到ba
> * `insertBefore()` a.insertBefore(b) 得到ab
>
> 平级插入

```js
$("<h1>标题</h1>").insertAfter("div");
$("<h1>标题</h1>").insertBefore("div");
```



### 替换

> * `replaceWith()` a.replaceWith(b) 用b 替换掉a
> * `replaceAll()` a.replaceAll(b) 用a 替换掉所有b

```js
$("div").replaceWith("<h1>标题</h1>");
$("<h1>标题</h1>").replaceAll("div");
```

> replaceWith会把多个div替换成1个
>
> replaceAll则是有多少个div替换多少次



### 删除

> * `remove()` a.remove(); 删除a 标签
> * `empty()` a.empty(); 清空a 标签里的内容



## CSS样式操作

> * `addClass()` 添加样式
> * `removeClass()` 删除样式
> * `toggleClass()` 有就删除，没有就添加样式
> * `offset()` 获取和设置元素的坐标



```js
var $divEle = $('div:first');

$('#btn01').click(function(){
   $divEle.addClass("redDiv blueBorder");
});

$('#btn02').click(function(){
   $divEle.removeClass("redDiv");
});


$('#btn03').click(function(){
   $divEle.toggleClass('redDiv');
});


$('#btn04').click(function(){
   $divEle.offset({
      top:100,
      left:50
   });
```



## JQuery动画

### 基本效果

> * `show()` 将隐藏的元素显示
> * `hide()` 将可见的元素隐藏
> * `toggle()` 可见就隐藏，不可见就显示


### 淡入淡出

> * `fadeIn()` 淡入
> * `fadeOut()` 淡出
> * `fadeTo()` 在指定时长内慢慢的将透明度修改到指定的值。0 透明，1 完成可见，0.5 半透明
> * `fadeToggle()` 淡入/淡出切换


> 以上动画方法都可以添加参数
>
> 1. 第一个参数是动画执行的时长，以毫秒为单位
> 2. 第二个参数是动画的回调函数(动画完成后自动调用的函数)

```js
//显示   show()
$("#btn1").click(function(){
   $("#div1").show();
});       
//隐藏  hide()
$("#btn2").click(function(){
   $("#div1").hide();
});    
//切换   toggle()
$("#btn3").click(function(){
   $("#div1").toggle(1000,function (){
      alert('111');
   });
});    

//淡入   fadeIn()
$("#btn4").click(function(){
   $("#div1").fadeIn();
});    
//淡出  fadeOut()
$("#btn5").click(function(){
   $("#div1").fadeOut();
});    

//淡化到  fadeTo()
$("#btn6").click(function(){
   $("#div1").fadeTo(500,0.5);
});    
//淡化切换  fadeToggle()
$("#btn7").click(function(){
   $("#div1").fadeToggle();
});    
```



## JQuery事件操作

### 页面加载区别

> \$( function(){} );
> 和
> window.onload = function(){}
> 的区别？

> 1. jQuery 页面加载完成之后先执行
> 2. 原生js 的页面加载完成之后

> jQuery 的页面加载完成之后是浏览器的内核解析完页面的标签创建好DOM 对象之后就会马上执行
>
> 原生js 的页面加载完成之后，除了要等浏览器内核解析完标签创建好DOM 对象，**还要等标签显示时需要的内容加载完成**

> 原生js 的页面加载完成之后，只会执行最后一次的赋值函数
>
> jQuery 的页面加载完成之后是全部把注册的function 函数，依次顺序全部执行



### 其他事件

> * `click()` 它可以绑定单击事件，以及触发单击事件
> * `mouseover()` 鼠标移入事件
> * `mouseout()` 鼠标移出事件
> * `bind()` 可以给元素一次性绑定一个或多个事件
> * `one()` 使用上跟bind 一样。但是one 方法绑定的事件只会响应一次
> * `unbind()` 跟bind 方法相反的操作，解除事件的绑定
> * `live()` 也是用来绑定事件。它可以用来绑定选择器匹配的所有元素的事件。哪怕这个元素是后面动态创建出来的也有效

```js
$("h5").click(function (){
   alert("h5单击");
});
//点击按钮，触发点击h5标签的点击
$("button").click(function () {
   $("h5").click();
});

$("h5").mouseover(function (){
   console.log("进入h5");
});
$("h5").mouseout(function (){
   console.log("移出h5");
});

$("h5").bind("click mouseover mouseout",function (){
   console.log("这是bind绑定的事件");
});
$("h5").unbind("mouseover mouseout");


$("h5").one("click mouseover mouseout",function (){
   console.log("这是bind绑定的事件");
});

$("h5").live("click",function (){
   alert("h5单击");
});
$("<h5 class=\"head\">什么是jQuery?</h5>").appendTo( $("#panel") );
```

### 事件的冒泡

> 事件的冒泡是指，父子元素同时监听同一个事件。当触发子元素的事件的时候，同一个事件也被传递到了父元素的事件里去响应

```html
    <script type="text/javascript">
      $(function(){
         $("#content").click(function (){
            alert("执行了");
         });
         $("span").click(function (){
            alert("我是span");
         });
      })
   </script>
</head>
<body>
   <div id="content">
      外层div元素
      <span>内层span元素</span>
      外层div元素
   </div>
```

> 内部span点击会触发span和content两个的点击事件

> 那么如何阻止事件冒泡呢？
>
> 在子元素事件函数体内，return false; 可以阻止事件的冒泡传递

```js
$("#content").click(function (){
   alert("执行了");
});
$("span").click(function (){
   alert("我是span");
   return false;
});
```



### 事件对象

> 事件对象，是封装有触发的事件信息的一个javascript 对象
>
> 我们重点关心的是怎么拿到这个javascript 的事件对象。以及使用

> 在给元素绑定事件的时候，在事件的function( event ) 参数列表中添加一个参数，这个参数名，我们习惯取名为event
>
> 这个event 就是javascript 传递参事件处理函数的事件对象

```js
//1.原生javascript获取 事件对象
window.onload = function () {
   document.getElementById("areaDiv").onclick = function (event) {
      console.log(event);
   }
}
//2.JQuery代码获取 事件对象
$(function () {
   $("#areaDiv").click(function (event) {
      console.log(event);
   });
});
//3.使用bind同时对多个事件绑定同一个函数。怎么获取当前操作是什么事件
$(function () {
   $("#areaDiv").bind("mouseover mouseout",function (event) {
      if (event.type == "mouseover"){
         console.log("鼠标移入");
      } else if (event.type == "mouseout") {
         console.log("鼠标移出");
      }
   });
});
```









