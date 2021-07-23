# SpringMVC

> Spring实现Web模块，简化Web开发

> Spring 为展现层提供的基于MVC设计理念的优秀的 Web 框架，是目前最主流的MVC框架之一
>
> Spring3.0 后全面超越 Struts2，成为最优秀的MVC框架
>
> Spring MVC通过一套MVC注解，让 POJO 成为处理请求的控制器，而无须实现任何接口。
>
> 支持REST风格的URL请求
>
> 采用了松散耦合可插拔组件结构，比其他 MVC 框架更具扩展性和灵活性



## Hello World

```xml
<!-- https://mvnrepository.com/artifact/org.springframework/spring-webmvc -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>5.3.8</version>
</dependency>
```

> 此依赖依赖于Spring核心环境
>
> 所以会自动导入以下所有内容
>
> aop beans context core expression jcl web webmvc

> SpringMVC中有一个前端控制器拦截所有请求，并智能派发，要在Web.xml中配置
>
> 并且配置Spring配置文件位置

```xml
<servlet>
    <servlet-name>springDispatcherServlet</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:springmvc.xml</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>

<servlet-mapping>
    <servlet-name>springDispatcherServlet</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>
```
> 写一个Controller

```java
@Controller
public class MyFirstController {

    @RequestMapping("/hello")
    public String firstRequest(){
        System.out.println("请求收到！");
        return "/WEB-INF/page/success.jsp";
    }
}
```

> 在配置文件中配置视图解析器，为我们自动拼接前后缀

```xml
<!--配置视图解析器-->
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="prefix" value="/WEB-INF/page/"></property>
    <property name="suffix" value=".jsp"></property>
</bean>
```

```java
@RequestMapping("/hello")
public String firstRequest(){
    System.out.println("请求收到！");
    return "success";
}
```



### 运行流程

> 1. 客户端点击链接，发送请求
> 2. 前端控制器收到所有请求，寻找请求地址@RequestMapping与哪个匹配，定位哪个类的哪个方法来执行
> 3. 前端控制器调用目标方法
> 4. 方法执行完成，SpringMVC拿到返回值
> 5. 用视图解析器进行拼接，拿到完整的页面地址
> 6. 转发到指定页面



### @RequestMapping

> 告诉SpringMVC这个方法用来处理什么请求，/可以省略，我们一般都会加上，看起来更清晰明了



### 配置文件默认位置

```xml
<servlet>
    <servlet-name>springDispatcherServlet</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:springmvc.xml</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>
```

> 如果我们不指定配置文件位置
>
> 它默认寻找的位置是/WEB_INF/springDispatcherServlet-servlet.xml
>
> springDispatcherServlet就是你配置的servlet-name



### url-pattern

```xml
<servlet-mapping>
    <servlet-name>springDispatcherServlet</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>
```

> 这里可以写*.do  *.action  *.haha
>
> 也可以写/  /*
>
> / 代表拦截所有请求，不拦截jsp页面
>
> /* 代表拦截所有请求

> 服务器的web.xml中有一个defaultServlet，它的url-pattern是 /
>
> 我们的配置中url-pattern也是 /
>
> **defaultServlet是Tomcat负责处理静态资源的**
>
> **我们配置了url-pattern为 /，就会把defaultServlet禁用掉**
>
> **导致所有静态资源都回去找controller来执行，导致显示失败**
>
> Tomcat中还有JspServlet，它的url-pattern是 *.jsp
>
> 这就是为什么 / 无法拦截jsp，jsp是可以访问的

```xml
<mvc:default-servlet-handler/>
<mvc:annotation-driven></mvc:annotation-driven>
```

> 在Spring的配置文件中加入这样一行代码
>
> 表示，如果我无法处理的请求，会自动交给Tomcat来处理
>
> 可以解决JQuery或各种脚本的加载问题

## RequestMapping注解

> Spring MVC 使用 @RequestMapping 注解为控制器指定可以处理哪些 URL 请求



### 在类上使用

> 在控制器的类定义及方法定义处都可标注 @RequestMapping
>
> **类定义处**：提供初步的请求映射信息。相对于 WEB 应用的根目录
>
> **方法处**：提供进一步的细分映射信息。相对于类定义处的 URL。若类定义处未标注
>
>  			  @RequestMapping，则方法处标记的 URL 相对于 WEB 应用的根目录

```java
@RequestMapping("/test")
@Controller
public class RequestMappingTest {

    @RequestMapping("/handle01")
    public String handle01(){
        return "success";
    }
}
```

> 此时handle01的访问路径是 /test/handle01



### @RequestMapping的属性

#### value

> 就是我们刚才写的访问路径



#### method

> 可以限定请求方式，默认是全部接收

```java
@RequestMapping(value = "/handle02" , method = RequestMethod.POST)
```



#### params

> 规定请求参数
>
> params 和 headers支持简单的表达式：
>
> param1: 表示请求必须包含名为 param1 的请求参数
>
> !param1: 表示请求不能包含名为 param1 的请求参数
>
> param1 != value1: 表示请求包含名为 param1 的请求参数，但其值不能为 value1
>
> {“param1=value1”, “param2”}: 请求必须包含名为 param1 和param2 的两个请求参数，且 param1 参数的值必须为 value1

```java
@RequestMapping(value = "/handle02" , params = {"username"})
```

> 代表这个请求，必须带有名为username的参数

```java
@RequestMapping(value = "/handle02" , params = {"!username"})
```

> 代表这个请求，必须不携带名为username的参数

```java
@RequestMapping(value = "/handle02" , params = {"username != 123"})
```

> 代表这个请求，携带名username的参数不可以是123
>
> 不带也可以

```java
@RequestMapping(value = "/handle02" , params = {"username != 123","pwd","!age"})
```

> 请求参数必须满足username不可以是123，必须携带pwd参数，必须不能携带age参数
>
> 必须全部满足



#### headers

> 规定请求头
>
> 和params一样，可以写简单的表达式

```java
@RequestMapping(value = "/handle02" , headers = {"User-Agent != Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"})
```

> 代表chrome不可访问



#### consumes

> 只接受内容类型是某种的类型，规定请求头中的content-type

#### produces

> 告诉浏览器，返回的内容类型是什么，给响应头中加入content-type
>
> text/html;charset=utf-8



### 模糊匹配

> 又称Ant风格，就是使用通配符的风格

> URL地址可以写模糊的通配符
>
> ？：能替代任意一个字符
>
> *：能替代任意多个字符和一层路径
>
> **：能替代多层路径
>
> **精确优先**

```java
@RequestMapping("/handle0?")
@RequestMapping("/handle0*")
@RequestMapping("/*/handle01")
@RequestMapping("/**/handle01")
```



## @PathVariable

> 这是Spring3.0新增的功能
>
> 让我们可以在URL中使用占位符，并获取其中的值
>
> 是我们使用REST风格中常用到的功能

```java
@RequestMapping("/user/{id}")
public String handle01(@PathVariable("id") String id){
    System.out.println(id);
    return "success";
}
```



## REST风格

> * **REST：**即 Representational State Transfer。（资源）表现层状态转化。是目前最流行的一种互联网软件架构。它结构清晰、符合标准、易于理解、扩展方便，所以正得到越来越多网站的采用
>
> * **资源（Resources）：**网络上的一个实体，或者说是网络上的一个具体信息。它可以是一段文本、一张图片、一首歌曲、一种服务，总之就是一个具体的存在。可以用一个URI（统一资源定位符）指向它，每种资源对应一个特定的URI。要获取这个资源，访问它的URI就可以，因此 URI即为每一个资源的独一无二的识别符。
>
> * **表现层（Representation）：**把资源具体呈现出来的形式，叫做它的表现层（Representation）。比如，文本可以用 txt 格式表现，也可以用 HTML 格式、XML 格式、JSON 格式表现，甚至可以采用二进制格式。
>
> * **状态转化（State Transfer）：**每发出一个请求，就代表了客户端和服务器的一次交互过程。HTTP协议，是一个无状态协议，即所有的状态都保存在服务器端。因此，如果客户端想要操作服务器，必须通过某种手段，让服务器端发生“状态转化”（State Transfer）。而这种转化是建立在表现层之上的，所以就是“表现层状态转化”。具体说，就是HTTP协议里面，四个表示操作方式的动词：GET、POST、PUT、DELETE。它们分别对应四种基本操作：GET用来获取资源，POST用来新建资源，PUT用来更新资源，DELETE用来删除资源。

> 这是一种URL的规范思想，请求无非就是增删改查
>
> 在HTTP协议中有四种请求方式GET，POST，PUT，DELETE
>
> 我们就用这四种请求方式区分四种行为
>
> 只要看到请求方式和URL就能明白客户端想要做的事

> /getBook?id=1	            /book/1  Get请求
>
> /deleteBook?id=1			 /book/1  Delete请求
>
> /updateBook?id=1			/book/1  Put请求
>
> /addBook						  /book  Post请求

> 问题：
>
> 从页面上只能发送GET和POST请求
>
> 其他的请求方式要如何实现？



### 实现增删改查

```java
@Controller
public class BookController {


    @RequestMapping(value = "/book/{id}",method = RequestMethod.GET)
    public String getBook(@PathVariable("id") Integer id){
        System.out.println("查询到了" + id + "号图书");
        return "success";
    }

    @RequestMapping(value = "/book/{id}",method = RequestMethod.DELETE)
    public String deleteBook(@PathVariable("id") Integer id){
        System.out.println("删除了" + id + "号图书");
        return "success";
    }

    @RequestMapping(value = "/book/{id}",method = RequestMethod.PUT)
    public String updateBook(@PathVariable("id") Integer id){
        System.out.println("更新了" + id + "号图书");
        return "success";
    }

    @RequestMapping(value = "/book",method = RequestMethod.POST)
    public String addBook(){
        System.out.println("添加了新的图书");
        return "success";
    }

}
```

> 这是controller的写法

> 现在的难点是如何在页面发起不存在的put和delete请求
>
> 1. SpringMVC中有一个过滤器，可以把普通的请求转化为规定的形式，我们在web.xml中配置这个过滤器

```xml
<filter>
    <filter-name>hiddenHttpMethodFilter</filter-name>
    <filter-class>org.springframework.web.filter.HiddenHttpMethodFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>hiddenHttpMethodFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

> 2. 创建一个post类型的表单
> 3. 表单项中携带一个 _method 的参数
> 4. 这个参数就携带需要的请求方式

```html
<form action="book" method="post">
    <input name="_method" value="delete">
    <input type="submit" value="删除图书" />
</form><br/>
<form action="book" method="post">
    <input name="_method" value="put">
    <input type="submit" value="更新图书" />
</form><br/>
```

> 过滤器底层会接收 _method 的值
>
> 如果请求方式是post，并且有 _method 的值
>
> 则将当前请求包装为一个新的request对象，并将请求方式更改为 _method 的值



### 高版本Tomcat解决

> 8.0以上的Tomcat不接受PUT和DELETE请求

> 因为我们Servlet会将请求转发到success页面
>
> 转发时携带的请求方式不是Tomcat支持的
>
> 我们需要在被转发的页面上添加 isErrorPage="true"
>
> 就可以解决问题



## 请求处理

> 我们如何在SpringMVC中获取作用域中的参数呢，有三个注解
>
> **@RequestParam：**获取请求参数
>
> **@RequestHeader：**获取请求头中的值
>
> **@CookieValue：**获取某个cookie的值



### 默认方式获取请求参数

```html
<a href="hello?username=root" >请求</a>
```

```java
@RequestMapping("/hello")
public String firstRequest(String username){
    System.out.println(username);
    return "success";
}
```

> 我们可以让参数名与作用域中参数名一致
>
> 就可以直接获取到



### @RequestParam

```java
@RequestMapping("/hello")
public String firstRequest(@RequestParam("username") String username){
    System.out.println(username);
    return "success";
}
```

> 如果标了@RequestParam则默认必须携带此参数

> 在@RequestParam中有三个参数
>
> **value：**指定要获取参数的key
>
> **required：**是否是必须的
>
> **defaultValue：**默认值

```java
@RequestMapping("/hello")
public String firstRequest(@RequestParam(value = "username",required = false,defaultValue = "没带参数") String username){
    System.out.println(username);
    return "success";
}
```



### @RequestHeader

```java
@RequestMapping("/hello")
public String firstRequest(@RequestHeader("User-Agent") String userAgent){
    System.out.println(userAgent);
    return "success";
}
```

> 如果请求头中没有所选的值，会报错

> 在@RequestHeader中也有三个参数
>
> **value：**指定要获取参数的key
>
> **required：**是否是必须的
>
> **defaultValue：**默认值



### @CookieValue

```java
@RequestMapping("/hello")
public String firstRequest(@CookieValue("JSESSIONID") String jid){
    System.out.println(jid);
    return "success";
}
```

> 如果没有携带指定参数，会报错

> 在@CookieValue中也有三个参数
>
> **value：**指定要获取参数的key
>
> **required：**是否是必须的
>
> **defaultValue：**默认值



### 传入POJO

```java
@RequestMapping("/book")
public String addBook(Book book){
    System.out.println("保存的图书：" + book);
    return "success";
}
```

> 如果我们的请求参数是一个POJO
>
> SpringMVC会自动为这个POJO赋值，将每一个参数获取出来，封装成一个对象
>
> 而且还可以级联赋值，比如POJO中还引用了另外的POJO，也会自动赋值
>
> 前端使用属性.子属性作为name即可



### 原生API

```java
@RequestMapping("/handle02")
public String handle02(HttpSession session, HttpServletRequest req){
    req.setAttribute("reqParam","reqValue1");
    session.setAttribute("sessionParam","sessionValue1");
    return "success";
}
```

> 只要在参数列表填入想要的对象，就可以直接使用

> 仅支持以下API：
>
> HttpServletRequest
> HttpServletResponse
> HttpSession
> java.security.Principal
> Locale
> InputStream
> OutputStream
> Reader
> Writer



## 解决乱码

> 提交的数据可能有乱码
>
> 我们之前使用req.setCharacterEncoding("UTF-8");来解决
>
> 但现在获取参数是SpringMVC在做
>
> 我们只能使用过滤器
>
> 但是，SpringMVC已经帮我们解决了这个问题
>
> CharacterEncodingFilter

```xml
<filter>
    <filter-name>characterEncodingFilter</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
        <param-name>encoding</param-name>
        <param-value>UTF-8</param-value>
    </init-param>
    <init-param>
        <param-name>forceResponseEncoding</param-name>
        <param-value>true</param-value>
    </init-param>
</filter> 
<filter-mapping>
    <filter-name>characterEncodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

> 这样可以解决POST请求乱码，顺便forceResponseEncoding解决响应乱码问题



### 解决GET请求乱码

> get请求乱码要在服务器中设置
>
> 在tomcat配置文件server.xml中找到端口号为8080那一行
>
> 在标签中添加 URIEncoding="UTF-8"



### REST过滤器与编码过滤器

> 项目中存在多个过滤器，我们要为他们设置优先级
>
> REST过滤器会在底层执行获取参数的操作
>
> 所以编码过滤器必须在它之前过滤 
>
> 因为执行顺序是按xml中配置的顺序
>
> **所以字符编码过滤器一定要在最前**



## 数据输出

> 除了在参数上传原生的API输出以外
>
> SpringMVC还提供了很多其他方法来响应数据



### Map，Model，ModelMap

> 可以在方法参数中传入这些类型
>
> 这些参数中保存的数据也会放在域中

```html
<h1>成功！</h1>
pageContext:${pageScope.msg}<br/>
request:${requestScope.msg}<br/>
session:${sessionScope.msg}<br/>
application:${applicationScope.msg}<br/>
```

> 这是我们改造的success页面，负责显示接收到的数据

```java
@RequestMapping("/hello")
public String firstRequest(Map<String,Object> map){
    map.put("msg","你好");
    return "success";
}
```

```java
@RequestMapping("/hello")
public String firstRequest(Model model){
    model.addAttribute("msg","modelValue");
    return "success";
}
```

```java
@RequestMapping("/hello")
public String firstRequest(ModelMap modelMap){
    modelMap.addAttribute("msg","modelMap Value");
    return "success";
}
```

> 这三个都会将数据保存在request作用域中
>
> 他们三个其实都是一样的
>
> 他们实际都是BindingAwareModelMap在工作

> ModelMap实现了Map
>
> ExtendedModelMap实现了Model并且继承了ModelMap
>
> BindingAwareModelMap继承了ExtendedModelMap
>
> 所以ExtendedModelMap是他们三个的实现子类



### ModelAndView

> 方法返回值可以变为ModelAndView

```java
@RequestMapping("/hello")
public ModelAndView firstRequest(){
    ModelAndView mv = new ModelAndView("success");
    mv.addObject("msg","ModelAndView Value");
    return mv;
}
```

> 数据也会放在request作用域中



### SessionAttribute

> SpringMVC提供了一种可以给Session作用域保存数据的方式
>
> 使用注解@SessionAttribute
>
> 只能标在类上

```java
@SessionAttributes(value = "msg")
```

> 此注释代表，向BindingAwareModelMap或ModelAndView中保存的"msg"为key的数据，同时给session中放一份

```java
@SessionAttributes(value = {"msg","haha"})
```

```java
@SessionAttributes(value = "msg",types = {String.class})
```

> types指定只要是这种类型的数据，也给session中放一份

> 不推荐使用此注释，可能会引发异常
>
> 如果要给Session中放数据，推荐使用原生API



### ModelAttribute

> 因为现在使用Mybatis，此注解已经不再使用了，了解即可

> 当我们前端要修改信息时，某些字段只能让用户看，不能让他改
>
> 但是这个表单提交到后台，SpringMVC将其封装成一个对象，不能修改的字段，并没有提交过来值
>
> 但是我们的SQL语句是全字段修改，就会将一些不可更改的字段变为null

> 我们的想法是，每次修改时，不要从前端提交的数据创建对象
>
> 而是搜索相应ID从数据库中取出数据，将更改的值重新赋值

> ModelAttribute可以标注在方法或者参数上
>
> 如果标注在方法上，此方法会优先于目标方法先运行
>
> 这样我们就可以提前查出数据库中的信息，并将其保存到作用域
>
> 如果标注在参数上，就可以取出刚才保存的数据
>
> 达到阻止SpringMVC帮我们创建对象的目的

 

## 视图解析

### forward

> 如果我们现在想转发的页面与其他页面不在同一个文件夹下
>
> 不想使用自动解析

```java
@RequestMapping("/handle02")
public String handle02(){
    return "../../hello";
}
```

> 我们可以写相对路径来跳转

```java
@RequestMapping("/handle02")
public String handle02(){
    return "forward:/hello.jsp";
}
```

> 或者我们可以这样写
>
> 这些写则不会拼串

```java
@RequestMapping("/handle02")
public String handle02(){
    return "forward:/handle01";
}
```

> 也可以将请求转发到另一个Servlet



### redirect

```java
@RequestMapping("/handle02")
public String handle02(){
    return "redirect:/hello.jsp";
}
```

> 使用方法和forward一样
>
> 只不过是重定向



### 视图解析器

> 请求处理方法执行完成后，最终返回一个 ModelAndView 对象。对于那些返回 String，View 或 ModeMap 等类型的处理方法，Spring MVC 也会在内部将它们装配成一个 ModelAndView 对象，它包含了逻辑名和模型对象的视图
> Spring MVC 借助视图解析器（ViewResolver）得到最终的视图对象（View），最终的视图可以是 JSP ，也可能是 Excel、JFreeChart  等各种表现形式的视图
> 对于最终究竟采取何种视图对象对模型数据进行渲染，处理器并不关心，处理器工作重点聚焦在生产模型数据的工作上，从而实现 MVC 的充分解耦



## Spring表单标签

> 通过 SpringMVC 的表单标签可以实现将模型数据中的属性和 HTML 表单元素相绑定，以实现表单数据更便捷编辑和表单值的回显

 ```jsp
 <%@ taglib prefix="from" uri="http://www.springframework.org/tags/form" %>
 ```

> 导入Spring表单

```html
<from:form>
  lastname:<from:input path="lastname" />
</from:form>
```

> 这里的path属性就和原生的name属性一样
>
> 但它拥有额外的功能，如果我们作用域中存在lastname的值，会自动回显

```html
dept:
  <from:select path="department.id" items="${depts}" itemLabel="departmentName" itemValue="id"></from:select>
```

> items：表示要遍历的集合，会自动进行遍历
>
> itemLabel：指遍历出的对象的哪个属性作为标签体的值
>
> itemValue：指遍历出的对象的哪个属性作为提交的value值

```html
<from:form>
  lastname:<from:input path="lastname" />
  email:<form:input path="email" />
  gender:
    男：<from:radiobutton path="gender" value="1" /><br/>
    女：<from:radiobutton path="gender" value="0" /><br/>
  dept:
    <from:select path="department.id" items="${depts}" itemLabel="departmentName" itemValue="id"></from:select><br/>
  <input type="submit" value="保存">
</from:form>
```

> 可能会报错
>
> 请求域中没有command类型对象

> SpringMVC认为表单中每一项都是要回显的
>
> path指定的每一个属性，请求域中必须有一个对象拥有这个属性
>
> 要在访问的时候，在作用域中保存一个command对象，让这个对象包含表单中的值

```html
<from:form modelAttribute="employee">
```

> 可以在from标签中添加一个modelAttribute属性
>
> 告诉Spring不要去取command对象的值，转而取我设置的这个对象的值

```jsp
<from:form action="${pageContext.request.contextPath}/emp" method="post" modelAttribute="employee">
```

> 为我们的表单添加请求地址和请求方式



## 数据转换

> 1. Spring MVC 主框架将 ServletRequest  对象及目标方法的入参实例传递给 WebDataBinderFactory 实例，以创建 DataBinder 实例对象
> 2. DataBinder 调用装配在 Spring MVC 上下文中的 ConversionService 组件进行数据类型转换、数据格式化工作。将 Servlet 中的请求信息填充到入参对象中
> 3. 调用 Validator 组件对已经绑定了请求消息的入参对象进行数据合法性校验，并最终生成数据绑定结果 BindingData 对象
> 4. Spring MVC 抽取 BindingResult 中的入参对象和校验错误对象，将它们赋给处理方法的响应入参



### 自定义转换器

> Spring底层是调用了Coverter来将各种数据相互转换的
>
> 我们也可以自己定义一个转换器
>
> 我们将employee中的属性写在一个字符串中并以 - 分割

```java
public class MyStringToEmployeeConverter implements Converter<String, Employee> {

    @Autowired
    DepartmentDao departmentDao;

    @Override
    public Employee convert(String source) {
        Employee employee = new Employee();
        if (source.contains("-")){
            String[] split = source.split("-");
            employee.setLastName(split[0]);
            employee.setEmail(split[1]);
            employee.setGender(Integer.parseInt(split[2]));
            employee.setDepartment(departmentDao.getDepartment(Integer.parseInt(split[3])));
        }
        return employee;
    }
}
```

> 下一步要将写好的Converter放入ConversionService中

```xml
<bean id="conversionService2" class="org.springframework.context.support.ConversionServiceFactoryBean">
    <property name="converters" >
        <set>
            <bean class="com.augus.component.MyStringToEmployeeConverter"></bean>
        </set>
    </property>
</bean>
```

```xml
<mvc:annotation-driven conversion-service="conversionService2"></mvc:annotation-driven>
```

> 然后激活我们新注册的conversionService2

> 最好把自己写的转换器加入到FormattingConversionServiceFactoryBean中，而不是ConversionServiceFactoryBean
>
> 因为FormattingConversionServiceFactoryBean中额外还有格式化转化器，功能更齐全



### mvc:annotation-driven

> <mvc:annotation-driven /> 
>
> 会自动注册
>
> RequestMappingHandlerMapping 
>
> RequestMappingHandlerAdapter 
>
> ExceptionHandlerExceptionResolver  

> 还将提供以下支持：
> 支持使用 ConversionService 实例对表单参数进行类型转换
> 支持使用 @NumberFormat annotation、@DateTimeFormat 注解完成数据类型的格式化
> 支持使用 @Valid 注解对 JavaBean 实例进行 JSR 303 验证
> 支持使用 @RequestBody 和 @ResponseBody 注解



### 数据格式化

> 如果我们传入2019-01-01这样的日期字符串，映射到Date类型就会报错

```java
@DateTimeFormat(pattern="yyyy-MM-dd")
private Date birth;
```

> 注意：
>
> 由ConversionServiceFactoryBean创建的conversionService组件是没有格式化器的
>
> 如果自定义的转化器也同时需要，应该把自定义的转换器添加到FormattingConversionServiceFactoryBean里面

> 前端提交过来的钱数有可能是10,000.98带有，分割的数字

```java
@NumberFormat(pattern = "#,###.##")
private double salary;
```

> 也可以做数字格式化



### 数据校验

> 只做前端校验是不安全的
>
> 在重要数据，一定要加上后端验证

> 可以用笨办法，把每个数据都检查一遍，如果不通过，把它退回页面重新填

> SpringMVC可以使用JSR303来进行数据校验
>
> Hibernate Validator提供了第三方的实现

#### 依赖

```xml
<!-- https://mvnrepository.com/artifact/org.hibernate.validator/hibernate-validator -->
<dependency>
    <groupId>org.hibernate.validator</groupId>
    <artifactId>hibernate-validator</artifactId>
    <version>6.2.0.Final</version>
</dependency>
<!-- https://mvnrepository.com/artifact/org.hibernate.validator/hibernate-validator-annotation-processor -->
<dependency>
    <groupId>org.hibernate.validator</groupId>
    <artifactId>hibernate-validator-annotation-processor</artifactId>
    <version>6.2.0.Final</version>
</dependency>
```

#### 在bean的属性上添加注解

```java
@NotEmpty
@Length(min = 3,max = 10)
private String lastName;
@Email
private String email;
```

#### 告诉SpringMVC，需要校验的Bean

```java
@RequestMapping(value = "/emp",method = RequestMethod.POST)
public String addEmp(@Valid Employee employee){
    employeeDao.save(employee);
    return "success";
}
```

> 在需要校验的属性上添加@Valid注解

#### 得到结果

```java
@RequestMapping(value = "/emp",method = RequestMethod.POST)
public String addEmp(@Valid Employee employee, BindingResult result){
    boolean hasErrors = result.hasErrors();
    if (hasErrors){
        return "add";
    }else {
        employeeDao.save(employee);
        return "success";
    }
}
```

> 在校验的参数后，紧跟一个BindingResult result，用于保存校验结果
>
> 他们两个之间不能有别的参数，必须紧跟

#### 问题显示

```html
lastname:<from:input path="lastName" /><form:errors path="lastName"/> <br/>
```

> 它的强大之处在于，在前端页面直接写form：errors标签
>
> 会直接把错误信息回显回来

#### 普通表单问题显示

```java
@RequestMapping(value = "/emp",method = RequestMethod.POST)
public String addEmp(@Valid Employee employee, BindingResult result,Model model){
    boolean hasErrors = result.hasErrors();
    Map<String,Object> errorsMap = new HashMap<>();
    List<FieldError> errors = result.getFieldErrors();
    for (FieldError error : errors) {
        errorsMap.put(error.getField(),error.getDefaultMessage());
    }
    model.addAttribute("errorInfo",errorsMap);
    if (hasErrors){
        System.out.println("有错误");
        return "add";
    }else {
        System.out.println("校验通过");
        return "success";
    }
}
```

> 将问题塞入model中，以便于在页面中显示

```html
lastname:<from:input path="lastName" />${errorInfo.lastName} <br/>
```

#### 国际化定制错误消息显示

> 国际化文件中错误消息的key必须对应一个错误代码
>
> 如果不知道该写什么，就将错误消息打印出来，随便找code之后的一个属性来当做key

```properties
Length=长度不合法,必须在 {2} {1}之间~~
```

```xml
<bean id="messageSource" class="org.springframework.context.support.ResourceBundleMessageSource">
    <property name="basename" value="errors"></property>
</bean>
```

> 让spring管理国际化配置
>
> {1} 和 {2} 代表使用注解时传入的参数
>
> 会按参数字符串顺序决定1和2的顺序
>
> 所以1,2代表的是max，min

> 这样Spring表单的错误标签就可以使用自定义的消息



#### 简易自定义消息

```java
@Email(message = "邮箱格式错误")
private String email;
```

> 也可以直接使用message属性，来自定义错误信息
>
> 但是这样无法做到国际化



## AJAX，JSON处理

### 依赖

```xml
<!-- https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-databind -->
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.12.4</version>
</dependency>
```

### 使用

```java
@ResponseBody
@RequestMapping(value = "/getall")
public Collection<Employee> getAllAjax(){
    Collection<Employee> all = employeeDao.getAll();
    return all;
}
```

> @ResponseBody代表将返回的数据放在响应体中，如果是对象，则自动转为json

```java
@JsonIgnore
private Department department;
```

> 可以在字段上加入@JsonIgnore，使其不被输出

```java
@JsonFormat(pattern = "yyyy-MM-dd")
private Date birth；
```

> 可以在字段上加入@JsonFormat，格式化输出的格式

```java
@ResponseBody
@RequestMapping(value = "/test02")
public String test02(){
    return "<h1>success</h1>";
}
```

> ResponseBody也可以直接把字符串放在响应体中，直接写出



### responseEntity

```java
@ResponseBody
@RequestMapping(value = "/test02")
public ResponseEntity<String> test02(){
    String body = "<h1>success</h1>";
    MultiValueMap<String,String> headers = new HttpHeaders();
    headers.add("Set-Cookie","username=haha");
    ResponseEntity responseEntity = new ResponseEntity<String>(body,headers, HttpStatus.OK);
    return responseEntity;
}
```

> 也可以在返回体中，自定义返回头中的内容



### RequestBody

```java
@RequestMapping(value = "/testbody")
public String requestBody(@RequestBody String body){
    System.out.println(body);
    return "success";
}
```

> 获取请求体

```java
@RequestMapping(value = "/testbody")
public String requestBody(@RequestBody Employee employee){
    System.out.println(employee);
    return "success";
}
```

> 使用@RequestBody接收json数据，自动封装成对象



### HttpEntity

```java
@RequestMapping(value = "/test01")
public String test01(HttpEntity<String> str){
    System.out.println(str);
    return "success";
}
```

> 获取请求头和请求体信息



### 下载

```java
@RequestMapping("/download")
public ResponseEntity<byte[]> download(HttpServletRequest request) throws Exception {
    ServletContext servletContext = request.getServletContext();
    String realPath = servletContext.getRealPath("/scripts/jquery-1.9.1.min.js");
    FileInputStream fis = new FileInputStream(realPath);
    byte[] buff = new byte[fis.available()];
    fis.read(buff);
    fis.close();
    HttpHeaders httpHeaders = new HttpHeaders();
    httpHeaders.set("Content-Disposition","attachment:filename=JQuery");
    ResponseEntity<byte[]> responseEntity = new ResponseEntity<>(buff, httpHeaders, HttpStatus.OK);
    return responseEntity;
}
```

> SpringMVC的下载还没有原生API方便，一般不会使用



## 文件上传

### 依赖

```xml
<!-- https://mvnrepository.com/artifact/commons-fileupload/commons-fileupload -->
<dependency>
    <groupId>commons-fileupload</groupId>
    <artifactId>commons-fileupload</artifactId>
    <version>1.4</version>
</dependency>
```

### form表单准备

```html
<form action="${pageContext.request.contextPath}/upload" method="post" enctype="multipart/form-data">
    用户头像：<input name="headerimg" type="file"><br/>
    用户名：<input name="username" type="text"><br/>
    <input type="submit">
</form>
```

### 配置文件上传解析器

```xml
<bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
    <property name="maxUploadSize" value="#{1024*1024*20}"></property>
    <property name="defaultEncoding" value="UTF-8"></property>
</bean>
```

> 文件上传解析器的id必须为multipartResolver

### 文件上传请求处理

```java
@RequestMapping("/upload")
public String upload(@RequestParam(value = "username") String username,@RequestParam("headerimg")MultipartFile file,
                     Model model) {
    System.out.println("文件名：" + file.getName());
    try {
        file.transferTo(new File("E:\\" + file.getOriginalFilename()));
        model.addAttribute("msg","文件上传成功");
    } catch (IOException e) {
        e.printStackTrace();
        model.addAttribute("msg","文件上传失败");
    }
    return "success";
}
```

> 只需要写一个@RequestParam("headerimg")MultipartFile file
>
> 它封装了当前文件的信息，并且可以直接保存
>
> file.getName()会得到文件项的名字
>
> file.getOriginalFilename()是文件自己的名字



### 多文件上传

```java
@RequestMapping("/upload")
public String upload(@RequestParam(value = "username") String username,@RequestParam("headerimg")MultipartFile[] file,
                     Model model) {
    for (MultipartFile multipartFile : file) {
        if (!multipartFile.isEmpty()){
            try {
                multipartFile.transferTo(new File("E:\\" + multipartFile.getOriginalFilename()));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
    return "success";
}
```

> 将MultipartFile file改为MultipartFile[]数组即可



## 拦截器

> SpringMVC提供了拦截器机制
>
> 允许运行目标方法之前进行一些拦截操作
>
> 或者目标方法运行之后进行一些处理

> Filter是JavaWeb定义的
>
> 拦截器是Spring定义的

> Spring的拦截器有三个方法
>
> preHandle：在目标方法运行之前调用，返回Boolean，返回true则放行
>
> postHandle：在目标方法运行之后调用，目标方法调用之后就执行
>
> afterCompletion：在请求完成之后，资源响应之后执行

```java
public class MyInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        System.out.println("preHandler");
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        System.out.println("postHandler");
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        System.out.println("afterCompletion");
    }
}
```

```xml
<mvc:interceptors>
    <bean class="com.augus.controller.MyInterceptor"></bean>
</mvc:interceptors>
```

> 在Spring中注册，这样写就是默认拦截所有请求

```xml
<mvc:interceptors>
    <mvc:interceptor>
        <mvc:mapping path="/test03"/>
        <bean class="com.augus.controller.MyInterceptor"></bean>
    </mvc:interceptor>
</mvc:interceptors>
```

> 也可以详细配置

### 执行顺序

> 正常执行流程：
>
> preHandle  --->   目标方法  --->   postHandle  --->   页面  --->   afterCompletion

> 只要放行，afterCompletion总会执行
>
> 报错页面，也是页面

> 如果有多个连接器
>
> 正常执行顺序
>
> FirstpreHandle
>
> SecondpreHandle
>
> 目标方法
>
> SecondpostHandle
>
> FirstpostHandle
>
> 页面
>
> SecondafterCompletion
>
> FirstafterCompletion

> 先执行哪个由配置文件哪个写在上面决定

> 如果Second不放行
>
> FirstpreHandle
>
> SecondpreHandle
>
> FirstafterCompletion
>
> 已经放行的拦截器的afterCompletion还是会执行



## 国际化

> 在Spring中实现国际化很简单
>
> 1. 写好国际化资源文件
> 2. 让ResourceBundleMessageSource管理资源文件
> 3. 直接在页面取值

```properties
#login_zh_CN.properties
welcomeinfo=欢迎
username=用户名
password=密码
loginbtn=登陆

#login_en_US.properties
welcomeinfo=welcom
username=Username
password=Password
loginbtn=Login
```

```xml
<bean id="messageSource" class="org.springframework.context.support.ResourceBundleMessageSource">
    <property name="basename" value="login"></property>
</bean>
```

```html
<h1>
    <fmt:message key="welcomeinfo"/>
</h1>
<form>
    <fmt:message key="username"/> ：<input /><br/>
    <fmt:message key="password"/> ：<input /><br/>
    <input type="submit" value="<fmt:message key="loginbtn"/> "/>
</form>
```

> SpringMVC中区域信息是由区域信息解析器得到的
>
> 所有用到区域信息的地方，都是用AcceptHeaderLocaleResolver获取的



### 获取国际化信息

```java
@Autowired
private MessageSource messageSource;

@RequestMapping("/tologinpage")
public String test03(Locale locale){
    String username = messageSource.getMessage("username", null, locale);
    System.out.println(username);
    return "login";
}
```

> 可以通过messageSource直接获取国际化信息
>
> 第二个变量是占位符，我们没写所以填null



### 点击按钮切换

#### 自定义LocaleResolver

```java
public class MyLocaleResolver implements LocaleResolver {
    @Override
    public Locale resolveLocale(HttpServletRequest httpServletRequest) {
        String locale = httpServletRequest.getParameter("locale");
        Locale l = null;
        if (locale!=null && !"".equals(locale)){
            l = new Locale(locale.split("_")[0],locale.split("_")[1]);
        }else {
            l = httpServletRequest.getLocale();
        }
        return l;
    }
```

```xml
<bean id="localeResolver" class="com.augus.component.MyLocaleResolver"></bean>
```
> 自定义一个解析器，并将其注册到Spring，注意id必须是localeResolver

```html
<a href="${pageContext.request.contextPath}/tologinpage?locale=zh_CN">中文</a>|<a href="${pageContext.request.contextPath}/tologinpage?locale=en_US">english</a>
```

> 这样按钮切换就可以生效了



#### SessionLocaleResolver

> 区域信息是从Session中获取的
>
> 可以将locale对象放在Session中

> CookieLocaleResolver也是一样的道理
>
> 只是Cookie保存Locale不太好用，我们不研究

```xml
<bean id="localeResolver" class="org.springframework.web.servlet.i18n.SessionLocaleResolver"></bean>
```

> 注册SessionLocaleResolver

```java
@RequestMapping("/tologinpage")
public String test03(@RequestParam(value = "locale",defaultValue = "zh_CN") String localeStr, Locale locale, HttpSession session){
    Locale l = null;
    if (localeStr!=null && !"".equals(locale)){
        l = new Locale(localeStr.split("_")[0],localeStr.split("_")[1]);
    }else {
        l = locale;
    }
    session.setAttribute(SessionLocaleResolver.class.getName() + ".LOCALE",l);
    return "login";
}
```

> 这里的Session作用域的key是Spring规定的，照着写就行



#### LocaleChangeInterceptor

```xml
<mvc:interceptors>
    <bean  class="org.springframework.web.servlet.i18n.LocaleChangeInterceptor"></bean>
</mvc:interceptors>
```

> Spring为我们定义好了一个拦截器，用于设置Locale信息
>
> 直接用就行，不需要写大段代码
>
> 注意，他会获取locale的变量，前端要携带name为locale的变量

> 他只是帮我们往localeResolver里设置值，我们还是需要一个localeResolver
>
> SessionLocaleResolver也需要注册
>
> 或者干脆直接用自定义的



## 异常处理

> Spring MVC 通过 HandlerExceptionResolver  处理程序的异常，包括 Handler 映射、数据绑定以及目标方法执行时发生的异常

> 如果发生异常，默认的三个异常处理器都处理不了
>
> 就会将异常抛出
>
> 就会交给Tomcat来处理，显示异常页面

> 三个默认使用的异常处理器：
>
> ExceptionHandlerExceptionResolver：处理@ExceptionHandler
>
> ResponseStatusExceptionResolver：处理@ResponseStatus
>
> DefaultHandlerExceptionResolver：判断是否为SpringMVC自带的异常



### @ExceptionHandler

> 标注在方法上，告诉SpringMVC这个方法专门用来处理异常

```java
@ExceptionHandler(value = {ArithmeticException.class})
public String handleException01(){
    return "myerror";
}
```

```java
@ExceptionHandler(value = {ArithmeticException.class})
public ModelAndView handleException01(Exception e){
    ModelAndView mv = new ModelAndView("myerror");
    mv.addObject("ex",e);
    return mv;
}
```

> 将异常信息显示给页面，这里要使用ModelAndView



### 全局异常处理

```java
@ControllerAdvice
public class MyException {

    @ExceptionHandler(value = {Exception.class})
    public ModelAndView handleException01(Exception e){
        ModelAndView mv = new ModelAndView("myerror");
        mv.addObject("ex",e);
        return mv;
    }
}
```

> 也可以在类上加@ControllerAdvice
>
> 使其方法变为全局异常处理方法



### @ResponseStatus

> 用来给自定义异常标注

```java
@RequestMapping("/exceptiontest2")
public String handle02(@RequestParam("username") String username){
    if (!"admin".equals(username)){
        throw new UserNameNotFoundException();
    }
    return "success";
}
```

```java
@ResponseStatus(reason = "用户被拒绝登陆",value = HttpStatus.NOT_ACCEPTABLE)
public class UserNameNotFoundException extends RuntimeException{
}
```

> 将其标在自定义异常的上方



### SpringMVC自带的异常

```java
@RequestMapping(value = "/exceptiontest3",method = RequestMethod.POST)
public String handle03(){
    return "success";
}
```

> 明确要求使用POST来请求，如果使用GET请求
>
> 就会产生Spring自定义的异常



### SimpleMappingExceptionResolver

> 通过配置的方式进行异常处理

```xml
<bean class="org.springframework.web.servlet.handler.SimpleMappingExceptionResolver">
    <property name="exceptionMappings">
        <props>
            <prop key="java.lang.NullPointerException">myerror.jsp</prop>
        </props>
    </property>
</bean>
```

> exceptionMappings里面保存了各种异常的映射
>
> key就是异常类型，value就是处理的页面
>
> 错误的信息使用exception属性取出

```xml
<bean class="org.springframework.web.servlet.handler.SimpleMappingExceptionResolver">
    <property name="exceptionMappings">
        <props>
            <prop key="java.lang.NullPointerException">myerror.jsp</prop>
        </props>
    </property>
    <property name="exceptionAttribute" value="ex"></property>
</bean>
```

> 或者手动指定使用ex取出异常信息



## SpringMVC运行流程

> 1. 所有请求，前端控制器（DispatcherServlet）收到请求，调用doDispatch处理
>
> 2. 根据HandlerMapping中保存的请求映射信息，找到处理当前请求的处理器执行链（包含了拦截器）
>
> 3. 根据当前处理器，找到他的HandlerAdapter（适配器）
>
> 4. 拦截器的preHandle先执行
>
> 5. 适配器执行目标方法，返回ModelAndView
>
> 6. ModelAttribute标注的方法提前运行
>
> 7. 执行目标方法时，确定目标方法用的参数
>
>    看是否Model、Map以及其他的
>
>    如果是自定义类型
>
>    先从隐含模型中查找
>
>    再看是否是SessionAttributes标注的属性，如果是从Session中拿，如果拿不到就抛异常
>
>    如果都没有，就创建对象
>
> 8. 拦截器的postHandle执行
>
> 9. 处理结果，页面渲染
>
>    如果有异常，使用异常解析器处理，处理完后还是返回ModelAndView
>
>    调用render进行页面渲染
>
>    ​	视图解析器根据视图名得到视图对象
>
>    ​	视图对象调用render方法
>
> 10. 拦截器的afterCompletion方法执行



## SpringMVC与Spring整合

> SpringMVC的配置文件就来配置和网站转发逻辑以及网站功能有关的
>
> Spring的配置文件来配置和业务有关的

> 推荐使用分别的容器，分别管理各自的内容

