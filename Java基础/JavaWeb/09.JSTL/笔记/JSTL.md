# JSTL

> JSTL 标签库全称是指JSP Standard Tag Library JSP 标准标签库
>
> 是一个不断完善的开放源代码的JSP 标签库

> EL 表达式主要是为了替换jsp 中的表达式脚本
>
> 而标签库则是为了替换代码脚本
>
> 这样使得整个jsp 页面变得更佳简洁



## 组成

> JSTL 由五个不同功能的标签库组成

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\JavaWeb\09.JSTL\笔记\jstl1.PNG)

## 导入

> 下载页面有4个jar包:
>     Impl:   taglibs-standard-impl-1.2.5.jar    JSTL实现类库
>     Spec:   taglibs-standard-spec-1.2.5.jar    JSTL标准接口
>     EL:     taglibs-standard-jstlel-1.2.5.jar  JSTL1.0标签-EL相关
>     Compat: taglibs-standard-compat-1.2.5.jar  兼容版本
>
> 从README得知: 
>     如果不使用JSTL1.0标签,可以忽略taglibs-standard-jstlel包,
>     README没有介绍taglibs-standard-compat包,估计应该是兼容以前版本标签库,
>     所以一般只需要 taglibs-standard-impl 和 taglibs-standard-spec 两个jar包

```xml
<!-- https://mvnrepository.com/artifact/org.apache.taglibs/taglibs-standard-impl -->
<dependency>
    <groupId>org.apache.taglibs</groupId>
    <artifactId>taglibs-standard-impl</artifactId>
    <version>1.2.5</version>
</dependency>

<!-- https://mvnrepository.com/artifact/org.apache.taglibs/taglibs-standard-spec -->
<dependency>
    <groupId>org.apache.taglibs</groupId>
    <artifactId>taglibs-standard-spec</artifactId>
    <version>1.2.5</version>
</dependency>
```

> 在jsp 标签库中使用taglib 指令引入标签库

```html
CORE 标签库
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
FMT 标签库
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
FUNCTIONS 标签库
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    
SQL 标签库
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
    
XML 标签库
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
```

## 使用

### <c:set />（使用很少）

> **set 标签**可以往域中保存数据

```jsp
<c:set scope="request" var="abc" value="123" />
${ requestScope.abc } <br/>
```



### <c:if />

> **if 标签**用来做if 判断

```jsp
<c:if test="${ 12 == 12 }">
    <h1>12 等于12</h1>
</c:if>
<c:if test="${ 12 != 12 }">
    <h1>12 不等于12</h1>
</c:if>
```



### \<c:choose> \<c:when> \<c:otherwise>

> 多路判断
>
> 跟switch ... case .... default 非常接近

```jsp
<%
    request.setAttribute("height",178);
%>
<c:choose>
    <c:when test="${ requestScope.height > 190 }">
        <h2>非常高</h2>
    </c:when>
    <c:when test="${ requestScope.height > 180 }">
        <h2>很高</h2>
    </c:when>
    <c:when test="${ requestScope.height > 170 }">
        <h2>高</h2>
    </c:when>
    <c:otherwise>
        <h2>一般般</h2>
    </c:otherwise>
</c:choose>
```

> 在标签中不可以写html注释，应该写jsp注释
>
> when的父标签必须是choose标签，如果要在otherwise中继续做判断，要再写一个choose标签



### <c:forEach />

> 遍历输出使用

```jsp
<c:forEach begin="0" end="20" var="i" step="2">
    ${i}<br/>
</c:forEach>
```

```jsp
<%
    String[] strings = {"123", "456", "789"};
    request.setAttribute("arr",strings);
%>
<c:forEach items="${ requestScope.arr }" var="item">
    ${ item } <br/>
</c:forEach>
```

```jsp
<%
    Map<String,Object> map = new HashMap<>();
    map.put("key1","value1");
    map.put("key2","value2");
    map.put("key3","value3");
    request.setAttribute("map",map);
%>
<c:forEach items="${ requestScope.map }" var="entry">
    ${entry.key} : ${entry.value} <br/>
</c:forEach>
```



```jsp
<table border=" 1px solid" width="500px">
    <tr>
        <td>current</td>
        <td>index</td>
        <td>count</td>
        <td>first</td>
        <td>last</td>
        <td>begin</td>
        <td>end</td>
        <td>step</td>
    </tr>
    <c:forEach begin="0" end="20" var="i" step="2" varStatus="status">
        <tr>
            <td>${status.current}</td>
            <td>${status.index}</td>
            <td>${status.count}</td>
            <td>${status.first}</td>
            <td>${status.last}</td>
            <td>${status.begin}</td>
            <td>${status.end}</td>
            <td>${status.step}</td>
        </tr>
    </c:forEach>
</table>
```

> 输出如下：

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\JavaWeb\09.JSTL\笔记\jstl.PNG)

