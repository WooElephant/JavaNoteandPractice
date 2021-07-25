# Servlet

## Servlet技术

### 什么是servlet

> 1. Servlet 是JavaEE 规范之一
> 2. Servlet 是JavaWeb 三大组件之一。三大组件分别是：Servlet 程序、Filter 过滤器、Listener 监听器
> 3. Servlet 是运行在服务器上的一个java 小程序，它可以接收客户端发送过来的请求，并响应数据给客户端

### 手动实现Servlet程序

> 1. 编写一个类去实现Servlet 接口
> 2. 实现service 方法，处理请求，并响应数据
> 3. 到web.xml 中去配置servlet 程序的访问地址

> service方法是专门用来处理请求和相应的

```java
public class HelloServlet implements Servlet {
    
    ...
        
    @Override
    public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
        System.out.println("Hello Servlet!");
    }
    
    ...
```

```xml
<!--servlet标签给Tomcat配置Servlet程序-->
<servlet>
    <!--servlet-name 给Servlet程序起一个别名（一般是类名） -->
    <servlet-name>HelloServlet</servlet-name>
    <!--servlet-class 是全类名-->
    <servlet-class>com.example.servlet.HelloServlet</servlet-class>
</servlet>
<!--servlet-mapping 给Servlet标签配置一个访问地址-->
<servlet-mapping>
    <servlet-name>HelloServlet</servlet-name>
    <url-pattern>/hello</url-pattern>
</servlet-mapping>
```



### Servlet 的生命周期

> 1. 执行Servlet 构造器方法
>
> 2. 执行init 初始化方法
>
>    第一、二步，是在第一次访问的时候创建Servlet 程序会调用
>
> 3. 执行service 方法
>
>    第三步，每次访问都会调用
>
> 4. 执行destroy 销毁方法
>
>    第四步，在web 工程停止的时候调用。



### 请求的分发处理

> service方法不能分别处理get和post请求
>
> 除非自己手动判断

```java
@Override
public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
    HttpServletRequest httpServletRequest = (HttpServletRequest) servletRequest;
    String method = httpServletRequest.getMethod();
    if (method.equals("GET")){
        System.out.println("GET请求");
    } else if (method.equals("POST")){
        System.out.println("POST请求");
    }
}
```

> 这里要讲servletRequest转成它的子类HttpServletRequest
>
> 因为只有HttpServletRequest才有getMethod方法



### 继承HttpServlet 实现Servlet 程序

> 一般在实际项目开发中，都是使用继承HttpServlet 类的方式去实现Servlet 程序
>
> 1. 编写一个类去继承HttpServlet 类
> 2. 根据业务需要重写doGet 或doPost 方法
> 3. 到web.xml 中的配置Servlet 程序的访问地址

```java
public class HelloServlet2 extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("servlet doGet 方法");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("servlet doPost 方法");
    }
}
```



### 使用IDEA 创建Servlet 程序

```java
@WebServlet(name = "Servlet3", value = "/Servlet3")
public class Servlet3 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
```



### Servlet 类的继承体系

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\JavaWeb\Servlet\笔记\123.jpg)



## ServletConfig 类

> ServletConfig 类从类名上来看，就知道是Servlet 程序的配置信息类
>
> Servlet 程序和ServletConfig 对象都是由Tomcat 负责创建，我们负责使用
>
> Servlet 程序默认是第一次访问的时候创建，ServletConfig 是每个Servlet 程序创建时，就创建一个对应的ServletConfig 对象

> 三大作用
>
> 1. 可以获取Servlet 程序的别名servlet-name 的值
> 2. 获取初始化参数init-param
> 3. 获取ServletContext 对象

```java
@Override
public void init(ServletConfig servletConfig) throws ServletException {
    System.out.println("HelloServlet的别名是" + servletConfig.getServletName());
    System.out.println("初始化参数username的值是" + servletConfig.getInitParameter("username"));
    System.out.println(servletConfig.getServletContext());
}
```

## ServletContext 类

> ServletContext 是一个接口，它表示Servlet 上下文对象
>
> 一个web 工程，只有一个ServletContext 对象实例
>
> ServletContext 对象是一个域对象
>
> ServletContext 是在web 工程部署启动的时候创建。在web 工程停止的时候销毁

> 什么是域对象?
>
> 域对象，是可以像Map 一样存取数据的对象，叫域对象
>
> 这里的域指的是存取数据的操作范围，整个web 工程

> ServletContext 类的四个作用
>
> 1. 获取web.xml 中配置的上下文参数context-param
> 2. 获取当前的工程路径，格式: /工程路径
> 3. 获取工程部署后在服务器硬盘上的绝对路径
> 4. 像Map 一样存取数据

```java
//获取web.xml 中配置的上下文参数context-param
ServletContext servletContext = getServletConfig().getServletContext();
String username = servletContext.getInitParameter("username");
String password = servletContext.getInitParameter("password");
```

```xml
<context-param>
    <param-name>username</param-name>
    <param-value>context</param-value>
</context-param>
<context-param>
    <param-name>password</param-name>
    <param-value>1234</param-value>
</context-param>
```

```java
//获取当前的工程路径
ServletContext servletContext = getServletConfig().getServletContext();
String contextPath = servletContext.getContextPath();
```

```java
//获取工程部署后在服务器硬盘上的绝对路径
ServletContext servletContext = getServletConfig().getServletContext();
String realPath = servletContext.getRealPath("/");
```

```java
//像Map 一样存取数据
ServletContext servletContext = getServletContext();
servletContext.setAttribute("key1","value1");
System.out.println(servletContext.getAttribute("key1"));
```



## HTTP协议

> 什么是协议?
>
> 协议是指双方，或多方，相互约定好，大家都需要遵守的规则，叫协议
>
> 所谓HTTP 协议，就是指，客户端和服务器之间通信时，发送的数据，需要遵守的规则，叫HTTP 协议
>
> HTTP 协议中的数据又叫报文

### 请求的HTTP 协议格式

> 客户端给服务器发送数据叫请求
>
> 服务器给客户端回传数据叫响应
>
> 请求又分为GET 请求，和POST 请求两种

#### GET 请求

> 请求行
>
> 请求的方式GET
>
> 请求的资源路径[+?+请求参数]
>
> 请求的协议的版本号HTTP/1.1

> 请求头
>
> key : value 组成不同的键值对，表示不同的含义

#### POST 请求

> 请求行
>
> 请求的方式POST
>
> 请求的资源路径
>
> 请求的协议的版本号HTTP/1.1

> 请求头
>
> key : value 不同的请求头，有不同的含义
>
> 空行

> 请求体
>
> 就是发送给服务器的数据



> 最大区别就是
>
> POST请求携带的数据并不会带在资源路径上
>
> 而是在请求体内



### 常用请求头

> **Accept:** 表示客户端可以接收的数据类型
>
> **Accpet-Languege:** 表示客户端可以接收的语言类型
>
> **User-Agent:** 表示客户端浏览器的信息
>
> **Host：** 表示请求时的服务器ip 和端口号



### 响应的HTTP 协议格式

> 响应行
>
> 响应的协议和版本号
>
> 响应状态码
>
> 响应状态描述符

> 响应头
>
> key : value 不同的响应头，有其不同含义
>
> 空行

> 响应体
>
> 就是回传给客户端的数据



### 常用的响应码

> **200** 表示请求成功
>
> **302** 表示请求重定向
>
> **404** 表示请求服务器已经收到了，但是你要的数据不存在（请求地址错误）
>
> **500** 表示服务器已经收到请求，但是服务器内部错误（代码错误）



### MIME 类型说明

> MIME 是HTTP 协议中数据类型
>
> MIME 的英文全称是"Multipurpose Internet Mail Extensions" 多功能Internet 邮件扩充服务
>
> MIME 类型的格式是“大类型/小类型”，并与某一种文件的扩展名相对应



## HttpServletRequest 类

> 每次只要有请求进入Tomcat 服务器，Tomcat 服务器就会把请求过来的HTTP 协议信息解析好封装到Request 对象中
>
> 然后传递到service 方法（doGet 和doPost）中给我们使用。我们可以通过HttpServletRequest 对象，获取到所有请求的信息



### HttpServletRequest 类的常用方法

> **getRequestURI()** 获取请求的资源路径
>
> **getRequestURL()** 获取请求的统一资源定位符（绝对路径）
>
> **getRemoteHost()** 获取客户端的ip 地址
>
> **getHeader()** 获取请求头
>
> **getParameter()** 获取请求的参数
>
> **getParameterValues()** 获取请求的参数（多个值的时候使用）
>
> **getMethod()** 获取请求的方式GET 或POST
>
> **setAttribute(key, value)** 设置域数据
>
> **getAttribute(key)** 获取域数据
>
> **getRequestDispatcher()** 获取请求转发对象

```java
String uri = request.getRequestURI();
StringBuffer url = request.getRequestURL();
String remoteHost = request.getRemoteHost();
String header = request.getHeader("User-Agent");
String method = request.getMethod();
```



### 获取请求参数

```html
<form action="http://localhost:8080/07_servlet/parameterServlet" method="get">
    用户名：<input type="text" name="username"><br/>
    密码：<input type="password" name="password"><br/>
    兴趣爱好：<input type="checkbox" name="hobby" value="cpp">C++
    <input type="checkbox" name="hobby" value="java">Java
    <input type="checkbox" name="hobby" value="js">JavaScript<br/>
    <input type="submit">
</form>
```

```java
String username = request.getParameter("username");
String password = request.getParameter("password");
String[] hobbies = request.getParameterValues("hobby");
```



### 解决中文乱码

> 一般不建议使用GET来传递中文参数

> POST处理乱码如下

```java
request.setCharacterEncoding("UTF-8");
```

> 在获取参数之前加上这句话就可以了



### 请求的转发

> 什么是请求的转发?
>
> 请求转发是指，服务器收到请求后，从一次资源跳转到另一个资源的操作叫请求转发

```java
RequestDispatcher requestDispatcher = request.getRequestDispatcher("/hello");
requestDispatcher.forward(request,response);
```

> 转发的特点：
>
> 1. 浏览器地址栏没有变化
> 2. 是同一次请求
> 3. 不可以访问工程以外的地址



### base 标签的作用

> 首页上有一个按钮，它访问了/test/forwordTest这个Servlet
>
> 在这个Servlet中，将其转发到a/b/c.html
>
> 在c.html中，有一个按钮是返回首页，它是这样定义的../../index.html
>
> 这个时候就会出错，因为通过转发地址栏不会发生变化，所以找上级目录会出错

> 所以在这个写了层级逻辑的页面中加入一个base标签解决此问题

```html
<base href="http://localhost:8080/test/a/b/c.html">
```



### 斜杠的不同意义

> / 斜杠如果被浏览器解析，得到的地址是：http:// ip:port/

> / 斜杠如果被服务器解析，得到的地址是：http:// ip:port/工程路径



## HttpServletResponse 类

> HttpServletResponse 类和HttpServletRequest 类一样
>
> 每次请求进来，Tomcat 服务器都会创建一个Response 对象传递给Servlet 程序去使用
>
> HttpServletRequest 表示请求过来的信息，HttpServletResponse 表示所有响应的信息，我们如果需要设置返回给客户端的信息，都可以通过HttpServletResponse 对象来进行设置



### 两个输出流的说明

> * 字节流getOutputStream(); 	常用于下载	（传递二进制数据）
> * 字符流getWriter();  	常用于回传字符串 	（常用）

> 两个流同时只能使用一个
>
> 使用了字节流，就不能再使用字符流，反之亦然，否则就会报错



### 回传数据

```java
PrintWriter writer = response.getWriter();
writer.write("response");
```



### 响应的乱码解决

```java
response.setCharacterEncoding("UTF-8");
response.setHeader("Content-Type","text/html;charset=UTF-8");
PrintWriter writer = response.getWriter();
writer.write("你好");
```

> 设置响应数据编码格式
>
> 并且在头中告诉浏览器，所使用的编码集

```java
response.setContentType("text/html;charset=UTF-8");
PrintWriter writer = response.getWriter();
writer.write("你好");
```

> 这样设置更简单
>
> 同时设置头和编码信息都为指定的编码集

> **注意**
>
> **此方法一定要在获取流之前运行**



### 重定向

> 请求重定向，是指客户端给服务器发请求
>
> 服务器告诉客户端说我给你一些地址，你去新地址访问

```java
response.sendRedirect("http://localhost:8080/testServlet/hello");
```

> 重定向特点：
>
> 1. 地址栏会发生变化
> 2. 两次请求
> 3. 不能访问WEB-INF下的内容
> 4. 可以访问工程外的资源



## 注解

> 直接在类名上添加注解@WebServlet
>
> 就可以不写xml中的配置了
>
> 此功能仅限Servlet 3.0之后使用

> 他可以有一些属性
>
> **name：**Servlet名字（可选）
>
> **value：**url路径，可以有多个
>
> **urlPatterns：**和value作用一样，不能同时使用
>
> **loadOnStartup：**配置Servlet创建时机，非负数为启动时创建，负数则是访问时创建，数字越小优先级越高



