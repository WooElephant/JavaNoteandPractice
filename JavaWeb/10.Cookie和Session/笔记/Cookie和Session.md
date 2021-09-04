# Cookie和Session

## Cookie

> Cookie 翻译过来是饼干的意思
>
> Cookie 是服务器通知客户端保存键值对的一种技术
>
> 客户端有了Cookie 后，每次请求都发送给服务器
>
> 每个Cookie 的大小不能超过4kb



### 创建

```java
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    Cookie cookie = new Cookie("username","root");
    response.addCookie(cookie);
}
```

```java
Cookie cookie = new Cookie("username","root");
cookie.setPath("/testServlet/get");
response.addCookie(cookie);
```

> 也可以设置只有在访问某些路径时携带Cookie

```java
cookie.setMaxAge(-1);
```

> 也可以为Cookie创建有效期
>
> 大于0，单位**秒**
>
> 等于0，马上删除
>
> 小于0，持续到浏览器关闭



### 获取

```java
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    Cookie[] cookies = request.getCookies();
    if (cookies!=null){
        for (Cookie cookie : cookies) {
            System.out.println(cookie.getName() + " : " + cookie.getValue());
        }
    }
}
```



### 修改

> 修改与创建一样
>
> 需要保证名称和访问路径一致
>
> 就会覆盖掉原有Cookie



### 编码

> 如果Cookie中存在无法识别的字符，比如中文
>
> 不仅仅是乱码问题，会直接报500错

> Cookie默认不支持中文，只能包含ASCII字符，所以需要对Cookie进行编码

> 编码使用java.net.URLEncoder类中的encode方法
>
> 解码使用java.net.URLDecoder类中的decode方法

```java
Cookie cookie = new Cookie(
        URLEncoder.encode("姓名", "UTF-8"),
        URLEncoder.encode("张三", "UTF-8")
);
response.addCookie(cookie);
```

```java
Cookie[] cookies = request.getCookies();
if (cookies != null){
    for (Cookie cookie : cookies) {
        System.out.println(
                URLDecoder.decode(cookie.getName(),"UTF-8")
                + " : " +
                URLDecoder.decode(cookie.getValue(),"UTF-8")        
        );
    }
}
```



### Cookie优缺点

> **优点：**
>
> 可配置到期规则
>
> 简单性：Cookie是一种基于文本的轻量结构，包含简单的键值对
>
> 数据持久性：Cookie默认在过期之前是可以一直存在客户端浏览器上的

> **缺点：**
>
> 大小受到限制：大多数浏览器都有4k，8k的限制
>
> 用户配置为禁用：有些用户设置了浏览器拒绝接收Cookie
>
> 潜在的安全风险：Cookie可能会被篡改



## session

> session用于记录用户的状态，在一段时间内，单个客户端与服务器的一连串交互过程

> 服务器会为每一次会话分配一个Session对象
>
> 用一个浏览器多次请求与，属于同一次会话
>
> 首次用到session时，服务器会自动创建session，并创建cookie存储sessionId发送回客户端



### 作用域

> 作用范围是一次会话有效
>
> * 一次会话是使用同一浏览器发送的多次请求，一旦浏览器关闭，则会话结束
>
> * 可以将数据存入session中，在一次会话任意位置获取
>
> * 可以传递任何数据



### 获取session

```java
HttpSession session = request.getSession();
```



### 数据操作

#### 保存

```java
HttpSession session = request.getSession();
session.setAttribute("username","root");
```

#### 获取

```java
HttpSession session = request.getSession();
Object usename = session.getAttribute("usename");
```

#### 移除

```java
HttpSession session = request.getSession();
session.removeAttribute("username");
```



### 生命周期

> 开始：第一次使用到session的请求产生，则创建session
>
> 结束：
>
> * 浏览器关闭
>
> * session超时
>
>   ```java
>   session.setMaxInactiveInterval(100);//单位秒
>   ```
>
> * 手工销毁
>
>   ```java
>   session.invalidate();
>   ```



## 浏览器禁用cookie解决方案

> 我们在浏览器访问某地址时，不使用原来的地址
>
> 在后面拼接上sessionId

```java
HttpSession session = request.getSession();
String s = response.encodeRedirectURL("/hello");
response.sendRedirect(s);
```

> 这个encodeRedirectURL，会把目标路径后拼接上sessionId

