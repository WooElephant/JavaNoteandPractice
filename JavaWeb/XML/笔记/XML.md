# XML

> xml 是可扩展的标记性语言

> xml 的主要作用有：
>
> 1. 用来保存数据，而且这些数据具有自我描述性
> 2. 它还可以做为项目或者模块的配置文件
> 3. 还可以做为网络传输数据的格式（现在JSON 为主）



## 语法

### 文档声明

```xml
<?xml version="1.0" encoding="UTF-8" ?>
```

> `version`表示xml的版本，很多很多年没有新版本，只有1.0和1.1，1.1还没人用
>
> `encoding`表示xml文件本身的编码
>
> <?xml 一定要连起来写，不然会报错



### 注释

> 与HTML一样

```xml
<!--注释内容-->
```



### 元素

> 元素是指从开始标签到结束标签的内容
>
> 例如：\<title>java 编程思想\</title>
>
> 元素我们可以简单的理解为是标签

> XML 元素必须遵循以下命名规则：
>
> 1. 名称可以含字母、数字以及其他的字符
> 2. 名称不能以数字或者标点符号开始
> 3. 名称不能包含空格



### 属性

> xml 的标签属性和html 的标签属性是非常类似的，属性可以提供元素的额外信息
>
> 在标签上可以书写属性：
>
> 一个标签上可以书写多个属性。每个属性的值必须使用引号引起来





### 其他语法规则

> * XML 标签对大小写敏感
> * XML 文档必须有根元素

> CDATA 语法可以告诉xml 解析器
>
> 我CDATA 里的文本内容，只是纯文本，不需要xml 语法解析

```xml
<![CDATA[
	>>>>}}}}{{{{[[[]]]]]]]}}}}怎么都不报错
]]>
```



## xml解析

> 不管是html 文件还是xml 文件它们都是标记型文档，都可以使用w3c 组织制定的dom 技术来解析

> 早期JDK 为我们提供了两种xml 解析技术DOM 和Sax 简介**（已经过时，但我们需要知道这两种技术）**

> dom 解析技术是W3C 组织制定的
>
> 而所有的编程语言都对这个解析技术使用了自己语言的特点进行实现
>
> Java 对dom 技术解析标记也做了实现

> sun 公司在JDK5 版本对dom 解析技术进行升级：SAX（ Simple API for XML ）
>
> SAX 解析，它跟W3C 制定的解析不太一样。它是以类似事件机制通过回调告诉用户当前正在解析的内容
>
> 它是一行一行的读取xml 文件进行解析的。不会创建大量的dom 对象
>
> 所以它在解析xml 的时候，在内存的使用上。和性能上。都优于Dom 解析

> 第三方的解析：
>
> jdom 在dom 基础上进行了封装
>
> **dom4j** 又对jdom 进行了封装
>
> pull 主要用在Android 手机开发，是在跟sax 非常类似都是事件机制解析xml 文件

> Dom4j 它是第三方的解析技术
>
> 我们需要使用第三方给我们提供好的类库才可以解析xml 文件



## dom4j解析 （重点）

> 由于dom4j 它不是sun 公司的技术，而属于第三方公司的技术
>
> 我们需要使用dom4j 就需要到dom4j 官网下载dom4j的jar 包



### 编程步骤

> 1. 先加载xml 文件创建Document 对象
> 2. 通过Document 对象拿到根元素对象
> 3. 通过根元素.elelemts(标签名); 可以返回一个集合，这个集合里放着。所有你指定的标签名的元素对象
> 4. 找到你想要修改、删除的子元素，进行相应在的操作
> 5. 保存到硬盘上



### 获取DOM对象

```java
//创建saxReader输入流，读取xml，获得document对象
SAXReader saxReader = new SAXReader();
Document document = saxReader.read("src/books.xml");
```



### 解析XML

```java
        //创建saxReader输入流，读取xml，获得document对象
        SAXReader saxReader = new SAXReader();
        Document document = saxReader.read("src/books.xml");
        //读取books.xml生成Book对象
        //通过document对象获得根元素
        Element rootElement = document.getRootElement();
        //通过根元素获取book标签对象
        //element和elements方法都是通过标签名查找子元素
        List<Element> books = rootElement.elements("book");
        //遍历，将每个book标签转换为Book类对象
        for (Element book : books) {
//            //asXML是把标签对象转换为标签字符串
//            System.out.println(book.asXML());
//            Element name = book.element("name");
//            //getText方法可以获取标签中的内容
//            String nameText = name.getText();

            //elementText可以直接获得对应标签中的内容
            String name = book.elementText("name");
            String price = book.elementText("price");
            String author = book.elementText("author");

            String sn = book.attributeValue("sn");

            System.out.println(new Book(sn,name, BigDecimal.valueOf(Double.parseDouble(price)),author));

        }
```

