# JSP

> jsp 的全换是java server pages。Java 的服务器页面
>
> jsp 的主要作用是代替Servlet 程序回传html 页面的数据
>
> 因为Servlet 程序回传html 页面数据是一件非常繁锁的事情，开发成本和维护成本都极高



## jsp 的本质是什么

> jsp 页面本质上是一个Servlet 程序
>
> 当我们第一次访问jsp 页面的时候。Tomcat 服务器会帮我们把jsp 页面翻译成为一个java 源文件
>
> 并且对它进行编译成为.class 字节码程序
>
> 其底层实现，也是通过输出流。把html 页面数据回传给客户端



## jsp 的三种语法

### 头部的page 指令

> jsp 的page 指令可以修改jsp 页面中一些重要的属性，或者行为

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
```

> 1. language 属性表示jsp 翻译后是什么语言文件。暂时只支持java
> 2. contentType 属性表示jsp 返回的数据类型是什么。也是源码中response.setContentType()参数值
> 3. pageEncoding 属性表示当前jsp 页面文件本身的字符集
> 4. import 属性跟java 源代码中一样。用于导包，导类

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
```

> 1. autoFlush 属性设置当out 输出流缓冲区满了之后，是否自动刷新冲级区。默认值是true
> 2. buffer 属性设置out 缓冲区的大小。默认是8kb
>
> 这两个属性是给out输出流使用的

> 1. errorPage 属性设置当jsp 页面运行时出错，自动跳转去的错误页面路径
> 2. isErrorPage 属性设置当前jsp 页面是否是错误信息页面。默认是false。如果是true 可以获取异常信息
> 3. session 属性设置访问当前jsp 页面，是否会创建HttpSession 对象。默认是true
> 4. extends 属性设置jsp 翻译出来的java 类默认继承谁。



### jsp 中的常用脚本

#### 声明脚本(极少使用)

> 声明脚本的格式是： <%! 声明java 代码%>
>
> 作用：可以给jsp 翻译出来的java 类，定义属性和方法甚至是静态代码块，内部类等

```jsp
<%!
    private Integer id;
    private String name;
    private static Map<Object,Object> map;
%>

<%!
    static {
        map = new HashMap<>();
        map.put("key1","value1");
        map.put("key2","value2");
        map.put("key3","value3");
    }
%>

<%!
    public int f(){
        return 10;
    }
%>

<%!
    public static class A{
        private Integer id;
        private String name;
    }
%>
```

#### 表达式脚本（常用）

> 表达式脚本的格式是：<%=表达式%>
>
> 表达式脚本的作用是：在jsp 页面上输出数据

> 表达式脚本的特点：
>
> 1. 所有的表达式脚本都会被翻译到 \_jspService() 方法中
> 2. 表达式脚本都会被翻译成为out.print()输出到页面上
> 3. 由于表达式脚本翻译的内容都在 \_jspService() 方法中,所以 _jspService()方法中的对象都可以直接使用
> 4. 表达式脚本中的表达式不能以分号结束

```jsp
<%= 12 %><br/>
<%= 12.12 %><br/>
<%= "我是字符串" %><br/>
<%= request.getParameter("username") %>
```

#### 代码脚本

> 代码脚本的格式是：

```jsp
<%
	java语句
%>
```

> 代码脚本的作用是：
>
> 可以在jsp 页面中，编写我们自己需要的功能（写的是java 语句）

> 代码脚本的特点是：
>
> 1. 代码脚本翻译之后都在 \_jspService 方法中_
> 2. 代码脚本由于翻译到 \_jspService()方法中，所以在 _jspService()方法中的现有对象都可以直接使用
> 3. 还可以由多个代码脚本块组合完成一个完整的java 语句
> 4. 代码脚本还可以和表达式脚本一起组合使用，在jsp 页面上输出数据

```jsp
<%
    int i = 12;
    if (i == 12){
        System.out.println("等于");
    } else {
        System.out.println("不等于");
    }

    for (int j = 0; j < 10; j++) {
        System.out.println(j);
    }

    String username = request.getParameter("username");
%>
```

```jsp
<%
    for (int j = 0; j < 10; j++) {
%>
<%
        System.out.println(j);
    }
%>
```

```jsp
<%
    for (int j = 0; j < 10; j++) {
%>
<%= j %> <br/>
<%
    }
%>
```



### jsp 中的三种注释

#### html 注释

> html 注释会被翻译到java 源代码中
>
> 在 _jspService 方法里，以out.writer 输出到客户端

#### java 注释

> java 注释会被翻译到java 源代码中

#### jsp 注释

```jsp
<%-- 这是jsp 注释--%>
```

>
> jsp 注释可以注掉，jsp 页面中所有代码。



## jsp 九大内置对象

> jsp 中的内置对象，是指Tomcat 在翻译jsp 页面成为Servlet 源代码后，内部提供的九大对象，叫内置对象

> request：请求对象
>
> response：相应对象
>
> session：会话对象
>
> pageContext：jsp的上下文对象
>
> application：ServletContext对象
>
> config：ServletConfig对象
>
> out：jsp输出流对象
>
> page：指向当前jsp对象
>
> exception：异常对象



## jsp 四大域对象

> 四个域对象分别是：
>
> **pageContext (PageContextImpl 类)** 当前jsp 页面范围内有效
>
> **request (HttpServletRequest 类)**一次请求内有效
>
> **session (HttpSession 类)**一个会话范围内有效（打开浏览器访问服务器，直到关闭浏览器）
>
> **application (ServletContext 类)** 整个web 工程范围内都有效（只要web 工程不停止，数据都在）

> 域对象是可以像Map 一样存取数据的对象
>
> 四个域对象功能一样，不同的是它们对数据的存取范围
>
> 虽然四个域对象都可以存取数据
>
> 在使用上它们是有优先顺序的
>
> 四个域在使用的时候，优先顺序分别是，他们从小到大的范围的顺序



## out 输出和response.getWriter 输出

> response 中表示响应，我们经常用于设置返回给客户端的内容（输出）
>
> out 也是给用户做输出使用的

> 当jsp页面中所有代码执行完成后会做以下两个操作：
>
> 1. 执行out.flush()，将out缓冲区中的数据追加到response缓冲区末尾
> 2. 会执行response的刷新，把所有数据写给客户端

> 由于jsp 翻译之后，底层源代码都是使用out 来进行输出，所以一般情况下。我们在jsp 页面中统一使用out 来进行输出。避免打乱页面输出内容的顺序

> out.write() 输出字符串没有问题
>
> out.print() 输出任意数据都没有问题（都转换成为字符串后调用的write 输出）
>
> out.write() 输出如果不是字符，会直接强转为char类型，存在缓冲区中

> **结论：**
>
> **在jsp 页面中，可以统一使用out.print()来进行输出**



## jsp 的常用标签

### jsp 静态包含

> 比如很多网站都有底部栏，联系我们，友情链接这些内容
>
> 上万个页面中这些内容是相同的，也便于维护

```jsp
<%@ include file="/include/foot.jsp" %>
```

> 静态包含就是把包含的jsp页面代码拷贝到包含的位置，执行输出



### jsp 动态包含

```jsp
<jsp:include page="/include/foot.jsp"></jsp:include>
```

> 动态包含也可以像静态包含一样，把包含的内容输出到包含位置

> 1. 动态包含会把包含的jsp页面也翻译成java代码
>
> 2. 动态包含底层代码使用
>
>    JspRuntimeLibrary.include(request, response, "/include/footer.jsp", out, false);
>
>    代码去调用被包含的jsp 页面执行输出
>
> 3.    动态包含还可以传递参数



### jsp 标签-转发

```html
<jsp:forward page="/scope2.jsp"></jsp :forward>
```



## 监听器

> 1. Listener 监听器它是JavaWeb 的三大组件之一：Servlet 程序、Filter 过滤器、Listener 监听器
> 2. Listener 它是JavaEE 的规范
> 3. 监听器的作用是，监听某种事物的变化。然后通过回调函数，反馈给客户（程序）去做一些相应的处理

### ServletContextListener 监听器

> ServletContextListener 它可以监听ServletContext 对象的创建和销毁
>
> ServletContext 对象在web 工程启动的时候创建，在web 工程停止的时候销毁
>
> 监听到创建和销毁之后都会分别调用ServletContextListener 监听器的方法反馈

```java
public class MyServletContextListenerImpl implements ServletContextListener {
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		System.out.println("ServletContext 对象被创建了");
	}
	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		System.out.println("ServletContext 对象被销毁了");
	}
}
```

```xml
<!--配置监听器-->
<listener>
	<listener-class>MyServletContextListenerImpl</listener-class>
</listener>
```



