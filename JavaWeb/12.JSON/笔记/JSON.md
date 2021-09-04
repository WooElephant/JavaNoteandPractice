# JSON

> JSON (JavaScript Object Notation) 是一种轻量级的数据交换格式
>
> 易于人阅读和编写
>
> 同时也易于机器解析和生成

> JSON采用完全独立于语言的文本格式，而且很多语言都提供了对json 的支持（包括C, C++, C#, Java, JavaScript, Perl, Python等）
>
> 这样就使得JSON 成为理想的数据交换格式

> json 是一种轻量级的数据交换格式
>
> 轻量级指的是跟xml 做比较
>
> 数据交换指的是客户端和服务器之间业务数据的传递格式

> json 是由键值对组成，并且由花括号（大括号）包围
>
> 每个键由引号引起来，键和值之间使用冒号进行分隔
>
> 多组键值对之间进行逗号进行分隔

## JavaScript 中使用

### 定义

```js
var jsonobj = {
    "key1" : 12,
    "key2" : "abc",
    "key3" : true,
    "key4" : [11,12,13],
    
    "key5" : {
        "key5_1" : 111,
        "key5_2" : 222
    },
    
    "key6" : [{
        "key6_1_1" : 666,
        "key6_1_2" : "662"
    },{
        "key6_2_1" : 6662,
        "key6_2_2" : "6622"
    }]
};
```

> json中可以定义很多种数据类型



### 访问

```js
alert(typeof(jsonObj));// object json 就是一个对象
alert(jsonObj.key1); //12
alert(jsonObj.key2); // abc
alert(jsonObj.key3); // true
alert(jsonObj.key4);// 得到数组[11,12,13]
// json 中数组值的遍历
for(var i = 0; i < jsonObj.key4.length; i++) {
    alert(jsonObj.key4[i]);
}
alert(jsonObj.key5.key5_1);//111
alert(jsonObj.key5.key5_2);//222
alert( jsonObj.key6 );// 得到json 数组

var jsonItem = jsonObj.key6[0];
alert( jsonItem.key6_1_2 ); //662
```

### 常用方法

> json 的存在有两种形式
>
> 一种是：对象的形式存在，我们叫它json 对象
>
> 一种是：字符串的形式存在，我们叫它json 字符串

> 一般我们要操作json 中的数据的时候，需要json 对象的格式
>
> 一般我们要在客户端和服务器之间进行数据交换的时候，使用json 字符串

> JSON.stringify() 把json 对象转换成为json 字符串
>
> JSON.parse() 把json 字符串转换成为json 对象

```js
// 把json 对象转换成为json 字符串
var jsonObjString = JSON.stringify(jsonObj); // 特别像Java 中对象的toString
alert(jsonObjString)

// 把json 字符串。转换成为json 对象
var jsonObj2 = JSON.parse(jsonObjString);
alert(jsonObj2.key1);// 12
alert(jsonObj2.key2);// abc
```



## Java中使用

### 依赖

```xml
<!-- https://mvnrepository.com/artifact/com.google.code.gson/gson -->
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
    <version>2.8.6</version>
</dependency>
```

> 常见的有gson和FastJson
>
> gson功能强
>
> FastJson速度快



### Bean和json

```java
public class Person {
    private Integer id;
    private String name;
    
    ...
```

```java
Person person = new Person(1, "张三");
Gson gson = new Gson();
String jsonStr = gson.toJson(person);

Person jsonObj = gson.fromJson(jsonStr, Person.class);
```



### List和json

```java
List<Person> list = new ArrayList<>();
list.add(new Person(1,"张三"));
list.add(new Person(2,"李四"));
list.add(new Person(3,"王五"));

Gson gson = new Gson();
String jsonStr = gson.toJson(list);

List<Person> jsonList = gson.fromJson(jsonStr, new PersonListType().getType());
Person person = jsonList.get(0);
System.out.println(person);
```

```java
public class PersonListType extends TypeToken<List<Person>> {
}
```

> 如果要返回一个list类型
>
> 需要我们创建一个类，继承TypeToken，并且填好泛型



### Map和json

```java
Map<Integer,Person> map = new HashMap<>();
map.put(1,new Person(1,"张三"));
map.put(2,new Person(2,"李四"));

Gson gson = new Gson();
String jsonStr = gson.toJson(map);

Map<Integer,Person> map2 = gson.fromJson(jsonStr,new PersonMapType().getType());
```

```java
public class PersonMapType extends TypeToken<Map<Integer,Person>> {
}
```

> 与list一样，也需要写一个类



### 匿名内部类

> list和map转换都需要一个类，而且只用一次
>
> 我们很容易联想到应该使用匿名内部类

```java
Map<Integer,Person> map2 = gson.fromJson(jsonStr,new TypeToken<Map<Integer,Person>>(){}.getType());
```

