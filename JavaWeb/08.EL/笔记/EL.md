# EL

> EL 表达式的全称是：
>
> Expression Language  表达式语言

> EL 表达式的什么作用：
>
> EL 表达式主要是代替jsp 页面中的表达式脚本
>
> 在jsp 页面中进行数据的输出

> 因为EL 表达式在输出数据的时候，要比jsp 的表达式脚本要简洁很多



## hello world

```jsp
<%
    request.setAttribute("key","value");
%>

<!--jsp表达式-->
<%= request.getAttribute("key") %><br/>
<!--el表达式-->    
${key}
```

> 对比发现，EL要比jsp脚本简单很多
>
> 如果获取空值，jsp会输出null，el会输出空串



## 搜索域数据的顺序

> EL 表达式主要是输出域对象中的数据
>
> 当四个域中都有相同的key 的数据的时候，EL 表达式会按照四个域的从小到大的顺序去进行搜索，找到就输出

```jsp
<%
    pageContext.setAttribute("key","pageContextValue");
    request.setAttribute("key","requestValueValue");
    session.setAttribute("key","sessionValue");
    application.setAttribute("key","applicationValue");
%>

${key}
```



## 输出Bean中属性

```java
public class Person {
    private String name;
    private String[] phones;
    private List<String> cities;
    private Map<String,Object> map;
    
   ...
```

```jsp
<%
    Person person = new Person();
    person.setName("张三");
    person.setPhones(new String[]{"13811111111","13822222222","13833333333"});

    List<String> list = new ArrayList<>();
    list.add("北京");
    list.add("上海");
    list.add("深圳");
    person.setCities(list);

    Map<String,Object> map = new HashMap<>();
    map.put("key1","value1");
    map.put("key2","value2");
    map.put("key3","value3");
    person.setMap(map);

    pageContext.setAttribute("person",person);
%>

    输出Person: ${person}<br/><br/>

    输出Person的name属性: ${person.name}<br/><br/>

    输出Person的phones中第一个属性: ${person.phones[0]}<br/><br/>

    输出Person的cities属性: ${person.cities}<br/><br/>

    输出Person的map属性: ${person.map}<br/><br/>

    输出Person的map中第一个属性: ${person.map.key1}<br/><br/>
```

> 在EL表达式中，输出属性，回去找该属性get方法
>
> 哪怕没有这个属性，只写了个常量返回值的get方法
>
> 也能打印出来



## 运算

### 关系运算

| 关系运算符 | 说明 | 范例 | 结果 |
| :--------: | :--: | :--: | :--: |
|  == 或 eq   |   等于   | \${ 5 == 5 } 或 ${ 5 eq 5 } | true |
|  != 或 ne   |   不等于   | \${ 5 !=5 } 或 ${ 5 ne 5 } | false |
|   < 或 lt   |   大于   | \${ 3 < 5 } 或 ${ 3 lt 5 } | true |
|   > 或 gt   |   小于   | \${ 2 > 10 } 或 ${ 2 gt 10 } | false |
|  <= 或 le   |   小于等于   | \${ 5 <= 12 } 或 ${ 5 le 12 } | true |
|  >= 或 ge   |   大于等于   | \${ 3 >= 5 } 或 ${ 3 ge 5 } | false |



### 逻辑运算

| 逻辑运算符 | 说明 |                          范例                           | 结果  |
| :--------: | :--: | :-----------------------------------------------------: | :---: |
| && 或 and  |  与  | \${ 12 == 12 && 12 < 11 } 或 ${ 12 == 12 and 12 < 11 }  | false |
| \|\| 或 or |  或  | \${ 12 == 12 \|\| 12 < 11 } 或 ${ 12 == 12 or 12 < 11 } | true  |
|  ! 或 not  |  非  |              \${ ! true } 或 ${ not true }              | false |



### 算术运算

| 算数运算符 | 说明 |               范例                | 结果 |
| :--------: | :--: | :-------------------------------: | :--: |
|     +      |  加  |           ${ 12 + 18 }            |  30  |
|     -      |  减  |            ${ 18 - 8 }            |  10  |
|     *      |  乘  |           ${ 12 * 12 }            | 144  |
|  / 或 div  |  除  | \${ 144 / 12 } 或 ${ 144 div 12 } |  12  |
|  % 或 mod  | 取余 | \${ 144 % 10 } 或 ${ 144 mod 10 } |  4   |



### 判断空

> empty 运算可以判断一个数据是否为空
>
> 如果为空，则输出true
>
> 不为空输出false

> 以下几种情况为空：
>
> 1. 值为null 值的时候，为空
> 2. 值为空串的时候，为空
> 3. 值是Object 类型数组，长度为零的时候
> 4. list 集合，元素个数为零
> 5. map 集合，元素个数为零

```jsp
${ empty username }
```



### 三元运算

> 表达式1 ？表达式2 ：表达式3
>
> 如果表达式1 的值为真，返回表达式2 的值
>
> 如果表达式1 的值为假，返回表达式3 的值



## 隐含对象

> EL 个达式中11 个隐含对象，是EL 表达式中自己定义的，可以直接使用

|       变量       |         类型         |                          作用                          |
| :--------------: | :------------------: | :----------------------------------------------------: |
|   pageContext    |   PageContextImpl    |             它可以获取jsp 中的九大内置对象             |
|    pageScope     |  Map<String,Object>  |            它可以获取pageContext 域中的数据            |
|   requestScope   |  Map<String,Object>  |              它可以获取Request 域中的数据              |
|   sessionScope   |  Map<String,Object>  |              它可以获取Session 域中的数据              |
| applicationScope |  Map<String,Object>  |          它可以获取ServletContext 域中的数据           |
|      param       |  Map<String,String>  |                 它可以获取请求参数的值                 |
|   paramValues    | Map<String,String[]> |     它也可以获取请求参数的值，获取多个值的时候使用     |
|      header      |  Map<String,String>  |                 它可以获取请求头的信息                 |
|   headerValues   | Map<String,String[]> |     它可以获取请求头的信息，它可以获取多个值的情况     |
|      cookie      |  Map<String,Cookie>  |            它可以获取当前请求的Cookie 信息             |
|    initParam     |  Map<String,String>  | 它可以获取在web.xml 中配置的\<context-param>上下文参数 |



### 四个特定域中的属性

> pageScope：pageContext 域
> requestScope：Request 域
> sessionScope：Session 域
> applicationScope：ServletContext 域

```jsp
<%
	pageContext.setAttribute("key1", "pageContext1");
	pageContext.setAttribute("key2", "pageContext2");
	request.setAttribute("key2", "request");
	session.setAttribute("key2", "session");
	application.setAttribute("key2", "application");
%>

${ applicationScope.key2 }
```



### pageContext 对象

```jsp
<%--
	request.getScheme() 它可以获取请求的协议
	request.getServerName() 获取请求的服务器ip 或域名
	request.getServerPort() 获取请求的服务器端口号
	getContextPath() 获取当前工程路径
	request.getMethod() 获取请求的方式（GET 或POST）
	request.getRemoteHost() 获取客户端的ip 地址
	session.getId() 获取会话的唯一标识
--%>

	1.协议： ${ pageContext.request.scheme }<br>
	2.服务器ip：${ pageContext.request.serverName }<br>
	3.服务器端口：${ pageContext.request.serverPort }<br>
	4.获取工程路径：${ pageContext.request.contextPath }<br>
	5.获取请求方法：${ pageContext.request.method }<br>
	6.获取客户端ip 地址：${ pageContext.request.remoteHost }<br>
	7.获取会话的id 编号：${ pageContext.session.id }<br>
```



### 其他隐含对象

|       变量       |         类型         |                          作用                          |
| :--------------: | :------------------: | :----------------------------------------------------: |
|      param       |  Map<String,String>  |                 它可以获取请求参数的值                 |
|   paramValues    | Map<String,String[]> |     它也可以获取请求参数的值，获取多个值的时候使用     |

```jsp
    输出请求参数username 的值：${ param.username } <br>
    输出请求参数password 的值：${ param.password } <br>
    输出请求参数username 的值：${ paramValues.username[0] } <br>
    输出请求参数hobby 的值：${ paramValues.hobby[0] } <br>
    输出请求参数hobby 的值：${ paramValues.hobby[1] } <br>
```

> http:// localhost:8080/项目名/*.jsp?username=wzg168&password=666666&hobby=java&hobby=cpp
>
> 在访问时携带参数，则可以显示



|       变量       |         类型         |                          作用                          |
| :--------------: | :------------------: | :----------------------------------------------------: |
|      header      |  Map<String,String>  |                 它可以获取请求头的信息                 |
|   headerValues   | Map<String,String[]> |     它可以获取请求头的信息，它可以获取多个值的情况     |

```jsp
    输出请求头【User-Agent】的值：${ header['User-Agent'] } <br>
    输出请求头【Connection】的值：${ header.Connection } <br>
    输出请求头【User-Agent】的值：${ headerValues['User-Agent'][0] } <br>
```



|       变量       |         类型         |                          作用                          |
| :--------------: | :------------------: | :----------------------------------------------------: |
|      cookie      |  Map<String,Cookie>  |            它可以获取当前请求的Cookie 信息             |
```jsp
    获取Cookie 的名称：${ cookie.JSESSIONID.name } <br>
    获取Cookie 的值：${ cookie.JSESSIONID.value } <br>
```



|       变量       |         类型         |                          作用                          |
| :--------------: | :------------------: | :----------------------------------------------------: |
|    initParam     |  Map<String,String>  | 它可以获取在web.xml 中配置的\<context-param>上下文参数 |

```xml
<context-param>
	<param-name>username</param-name>
	<param-value>root</param-value>
</context-param>
<context-param>
	<param-name>url</param-name>
	<param-value>jdbc:mysql:///test</param-value>
</context-param>
```

```jsp
输出Context-param username 的值：${ initParam.username } <br>
输出Context-param url 的值：${ initParam.url } <br>
```











