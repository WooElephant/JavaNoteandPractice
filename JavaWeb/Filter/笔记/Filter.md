# Filter

> Filter 过滤器它是JavaWeb 的三大组件之一：Servlet 程序、Listener 监听器、Filter 过滤器
>
> Filter 过滤器它是JavaEE 的规范
>
> Filter 过滤器它的作用是：拦截请求，过滤响应

> 拦截请求常见的应用场景有：
>
> 1. 权限检查
>
> 2. 日记操作
>
> 3. 事务管理
>
>    等等



## 实例

> 要求：
>
> 在你的web 工程下，有一个admin 目录
>
> 这个admin 目录下的所有资源都必须是用户登录之后才允许访问

```jsp
<%
    Object user = session.getAttribute("user");
    if (user == null){
        request.getRequestDispatcher("/login.jsp").forward(request,response);
        return;
    }
%>
```

> 可以在不允许访问的页面中加入转发操作
>
> 但这种方案不可以应用于图片，或其他资源



## 过滤器使用

```java
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest httpServletRequest = (HttpServletRequest) servletRequest;
        HttpSession session = httpServletRequest.getSession();
        Object user = session.getAttribute("user");
        if (user == null){
            httpServletRequest.getRequestDispatcher("/login").forward(servletRequest,servletResponse);
        }else {
            filterChain.doFilter(servletRequest,servletResponse);
        }
    }

    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}
```



## 过滤器配置

> 当我们实现了过滤器之后，还需要去注册此过滤器

### xml注册

```xml
<filter>
    <filter-name>AdminFilter</filter-name>
    <filter-class>com.augus.filter.AdminFilter</filter-class>
</filter>

<filter-mapping>
    <filter-name>AdminFilter</filter-name>
    <url-pattern>/admin/*</url-pattern>
</filter-mapping>
```

### 注解

```java
@WebFilter(value = "/admin/*")
```

> 直接在过滤器类上加注释



## filter的生命周期

> Filter 的生命周期包含几个方法
>
> 1. 构造器方法
>
> 2. init 初始化方法
>
>    第1，2 步，在web 工程启动的时候执行（Filter 已经创建）
>
> 3. doFilter 过滤方法
>
>    第3 步，每次拦截到请求，就会执行
>
> 4. destroy 销毁
>
>    第4 步，停止web 工程的时候，就会执行（停止web 工程，也会销毁Filter 过滤器）



## FilterConfig 类

> FilterConfig 类见名知义，它是Filter 过滤器的配置文件类
>
> Tomcat 每次创建Filter 的时候，也会同时创建一个FilterConfig 类，这里包含了Filter 配置文件的配置信息

> FilterConfig 类的作用是获取filter 过滤器的配置内容
>
> 1. 获取Filter 的名称filter-name 的内容
> 2. 获取在Filter 中配置的init-param 初始化参数
> 3. 获取ServletContext 对象



## FilterChain 过滤器链

> 多个Filter可以串联使用
>
> filterChain.doFilter(servletRequest,servletResponse);
>
> 我们在执行这个放行方法的时候其实，就是让FilterChain执行下一个filter
>
> 如果没有filter了，则执行目标资源

> 优先级：
>
> 如果使用注解：按全类名的字符串顺序执行
>
> 如果是xml：按注册顺序从上至下

## Filter 的拦截路径

### 精确匹配

> \<url-pattern>/target.jsp\</url-pattern>
> 以上配置的路径，表示请求地址必须为：http:// ip:port/工程路径/target.jsp

### 目录匹配

> \<url-pattern>/admin/\*\</url-pattern>
> 以上配置的路径，表示请求地址必须为：http:// ip:port/工程路径/admin/*

### 后缀名匹配

> \<url-pattern>*.html\</url-pattern>
> 以上配置的路径，表示请求地址必须以.html 结尾才会拦截到

