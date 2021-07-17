# AJAX

> AJAX 即“Asynchronous Javascript And XML”（异步JavaScript 和XML）
>
> 是指一种创建交互式网页应用的网页开发技术

> ajax 是一种浏览器通过js 异步发起请求，局部更新页面的技术

> Ajax 请求的局部更新，浏览器地址栏不会发生变化
>
> 局部更新不会舍弃原来页面的内容



## 原生AJAX 请求

```js
var xmlHttpRequest = new XMLHttpRequest();

xmlHttpRequest.open("GET","http://localhost:8080/ajax/Servlet",true);

xmlHttpRequest.onreadystatechange = function (){
   if (xmlHttpRequest.readyState == 4 && xmlHttpRequest.status == 200 ){
      var jsonObj = JSON.parse(xmlHttpRequest.responseText);
      document.getElementById("div01").innerHTML = "编号：" + jsonObj.id + "   姓名：" + jsonObj.name;
   }
};

xmlHttpRequest.send();
```

```java
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    Person person = new Person(1, "张三");
    Gson gson = new Gson();
    String jsonStr = gson.toJson(person);
    response.setContentType("text/html;charset=UTF-8");
    response.getWriter().write(jsonStr);
}
```

> 原生AJAX请求写起来太麻烦，我们一般不用



## jQuery 中的AJAX 请求

### $.ajax 方法

> * **url** 表示请求的地址
>
> * **type** 表示请求的类型GET 或POST 请求
>
> * **data** 表示发送给服务器的数据
>
>   ​	格式有两种：
>
>   ​		一：name=value&name=value
>
>   ​		二：{key:value}
>
> * **success** 请求成功，响应的回调函数
>
> * **dataType** 响应的数据类型
>
>   ​	常用的数据类型有：
>
>   ​		text 表示纯文本
>
>   ​		xml 表示xml 数据
>
>   ​		json 表示json 对象

```js
$("#ajaxBtn").click(function(){
   $.ajax({
      url:"http://localhost:8080/demo/Servlet",
      type:"GET",
      success:function (msg){
         $("#msg").html("编号：" + msg.id + ",姓名：" + msg.name);
      },
      dataType:"json"
   });
});
```



### \$.get 方法和 $.post 方法

> **url** 请求的url 地址
> **data** 发送的数据
> **callback** 成功的回调函数
> **type** 返回的数据类型

```js
$("#getBtn").click(function(){
   $.get("http://localhost:8080/demo/Servlet",null,function (msg){
      $("#msg").html("编号：" + msg.id + ",姓名：" + msg.name);
   },"json")
});
```

```js
$("#postBtn").click(function(){
   // post请求
   $.post("http://localhost:8080/demo/Servlet",null,function (msg){
      $("#msg").html("编号：" + msg.id + ",姓名：" + msg.name);
   },"json")
});
```



### $.getJSON 方法

> **url** 请求的url 地址
> **data** 发送给服务器的数据
> **callback** 成功的回调函数

> 请求方式固定为get
>
> 返回类型固定为json

```js
$("#getJSONBtn").click(function(){
   $.getJSON("http://localhost:8080/demo/Servlet",null,function (msg) {
      $("#msg").html("编号：" + msg.id + ",姓名：" + msg.name);
   });
});
```



## 表单序列化

> serialize()可以把表单中所有表单项的内容都获取到
>
> 并以name=value&name=value 的形式进行拼接

```js
$("#submit").click(function(){
   $.getJSON("http://localhost:8080/demo/Servlet",$("#form01").serialize(),function (msg) {
      $("#msg").html("编号：" + msg.id + ",姓名：" + msg.name);
   });
});
```

```http
http://localhost:8080/demo/Servlet?username=111&password=111&single=Single&multiple=Multiple&multiple=Multiple3&check=check2&radio=radio1
```