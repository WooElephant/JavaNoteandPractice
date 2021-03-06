# Spring



## 1 初识Spring

### 框架

> `SSM框架`
>
> Spring+SpringMVC+MyBatis

> `什么叫框架`
>
> 高度抽取可重用代码的一种设计
>
> 具有高度的通用性
>
> 多个可重用模块的集合，形成一个某领域整体解决方案



### Spring

> Spring是一个`容器`框架
>
> 可以管理所有组件（类）

> Spring最重要的两个核心是`IOC`和`AOP`

> Spring的优点
>
> 非侵入式：不依赖于API，可以完全不懂，即可上手使用
>
> 依赖注入：IOC最经典的实现
>
> 面向切面编程：AOP
>
> 容器：Spring是一个容器，它包含并管理着对象的生命周期
>
> 组件化：实现了简单组件配置组合，使用部分功能不需要全部导入依赖
>
> 一站式：整合了各种企业应用开原框架

![](spring.PNG)

> Spring的模块划分图
>
> `Test`是Spring单元测试模块
>
> `Core Container` Spring的核心容器（IOC），黑色部分代表由哪些Jar包组成，要使用这部分的完整功能，需要导入全部Jar包
>
> `AOP`+`Aspects`：AOP是面向切面编程，Aspects是切面。他们俩共同组成面向切面编程
>
> `Instrumentation`+`Messaging`：不作了解
>
> `Data Access`：数据访问模块
>
> **JDBC** 负责操作数据库
>
> **ORM**（Objective Relation Mapping）对象关系映射
>
> **Transactions **简写为tx，控制事务的模块
>
> OXM x代表xml，对象与xml映射，不需要了解
>
> JMS java spring消息服务，不需要了解
>
> `Web`：Spring开发Web应用的模块
>
> WebSocket websocket技术
>
> servlet 和原生web相关的模块，jar包名为web
>
> web 开发web项目模块，jar包名为webmvc
>
> portlet 开发web应用组件的集成
>
> 
>
> 用哪个模块导哪个包





## 2 IOC初识

> Spring两个重要的功能就是`IOC（容器）`和`AOP（面向切面的编程）`

> IOC（ Inversion Of Control） : 控制反转
>
> 资源的获取方式分为主动式和被动式

主动式：需要的资源需要手动创建

```java
BookServlet{
    BookService bs = new BookService();
}
```

被动式：资源的获取不是我们来创建，而是交给容器来创建

```java
BookServlet{
    BookService bs;
    public void test(){
        bs.checkout();
    }
}
```



### 容器

> 容器管理所有的组件
>
> 容器可以自动的探查出，哪些组件需要另一些组件
>
> 容器帮我们创建BookService对象，并且帮我们赋值
>
> 将我们主动new资源变为被动的接受资源

> 容器类似于婚介所
>
> 在婚介所注册后，告诉婚介所需要什么样的对象，婚介所会给你匹配合适的对象



### DI

> DI : Dependency Injection 依赖注入
>
> IOC是一种思想，DI是一种实现IOC的方式
>
> 容器能知道，哪个组件运行的时候，需要另一个组件
>
> 容器通过反射的形式，将容器中准备好的对象，注入给需要的对象

> 只要是容器管理的组件，都能使用容器提供的功能



### HelloWorld

> 通过各种方式给容器中注册对象

```xml
<bean id="person01" class="com.augus.bean.Person">
		<property name="name" value="张三"></property>
		<property name="age" value="20"></property>
</bean>
```

> 首先编写Spring配置文件
>
> 每一个bean就是在Spring中注册的对象

```java
package com.augus.bean;

public class Person {
	private String name;
	private Integer age;
	
	public Person() {
		super();
	}

	public Person(String name, Integer age) {
		super();
		this.name = name;
		this.age = age;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getAge() {
		return age;
	}

	public void setAge(Integer age) {
		this.age = age;
	}

	@Override
	public String toString() {
		return "Person [name=" + name + ", age=" + age + "]";
	}
	
}
```

> 这是一个很简单的Person类，并把它注册到Spring容器中，并赋值

```java
public void test01() {
    ApplicationContext ioc = new ClassPathXmlApplicationContext("SpringConfig.xml");
    Person person = (Person) ioc.getBean("person01");
    System.out.println(person);
}

//输出结果为
//Person [name=张三, age=20]
```

> 然后我们写一个简单的测试，发现我们并没有new Person的对象，但是可以进行正常的输出
>
> 1. ClassPathXml就是我们之前写的Spring配置文件，简单来说就是婚介所的记录表你放在哪里了。也可以用别的类，它的实现类总共只有两个。其中一个是FileSystem就是在磁盘中寻找配置文件，一般我们还是使用ClassPath
>
> 2. ioc就像替我们保管的容器，我们调用它的getBean方法，并且传入参数为我们刚才在Spring配置文件中所填对象的id值，来获取到在Spring中注册的那个对象



### HelloWorld中存在的细节

> 1. Person是什么时候被创建的
>
>    我们修改一下Person的构造方法，再修改一下测试类

```java
public Person() {
    super();
    System.out.println("Person被创建了");
}
```

```java
public void test01() {
    ApplicationContext ioc = new ClassPathXmlApplicationContext("SpringConfig.xml");
    
}

//Person被创建了
```

> `结论`
>
> ioc容器加载时，就已经创建了Person对象，无论我们是否使用他（饿汉式）



----



> 2. 先看代码

```java
public void test01() {
    ApplicationContext ioc = new ClassPathXmlApplicationContext("SpringConfig.xml");
    Person person = (Person) ioc.getBean("person01");
    Person person2 = (Person) ioc.getBean("person01");
    System.out.println(person2 == person);
}

//true
```

> `结论`
>
> 同一个组件在容器中是`单实例`的



----



> 3. 如果我们在set方法中输出一句话，会发现该方法在容器创建时也会在控制台输出
>
> `结论`
>
> 容器在创建对象的时候，会使用Set方法为bean的属性进行赋值



----



> 4. bean的属性名是由set方法来决定的，属性名就是set后面的字母，并且首字母改小写
>
>    如果我们更改set方法的名，比如将setName改为setLastname，就会报错
>
> `结论`
>
> bean的属性名是由set方法来决定的
>
> 我们尽量使用系统生成get/set方法，避免手写



## 3 XML配置

### 3.1 根据类型获取实例 **（重点）**

```xml
public void test02() {
    Person person = ioc.getBean(Person.class);
    System.out.println(person);
}
```

> 这个很容易，看一下就了解了

> 如果我们在容器中注册了两个Person则会报错
>
> 如果有多个，则只能通过id来找
>
> 或者既通过类型，又通过id来找

```java
public void test02() {
    Person person = ioc.getBean("person02",Person.class);
    System.out.println(person);
}
```



### 3.2 通过构造器赋值

```java
public Person(String name, Integer age) {
    super();
    this.name = name;
    this.age = age;
}
```

> 首先你的类中要有有参构造器

```xml
<bean id="person02" class="com.augus.bean.Person">
    <constructor-arg name="name" value="李四"></constructor-arg>
    <constructor-arg name="age" value="30"></constructor-arg>
</bean>
```

```java
Person person = ioc.getBean("person02",Person.class);
System.out.println(person);
```

> 使用 <constructor-arg>标签，使用构造器为对象赋值
>
> 构造函数有多少个参数，就需要写多少个<constructor-arg>不然会报错



---



```xml
<bean id="person03" class="com.augus.bean.Person">
    <constructor-arg value="王五"></constructor-arg>
    <constructor-arg value="40"></constructor-arg>
</bean>
```

> 你也可以不写name属性，直接写value值，但顺序必须与构造器相同



```xml
<bean id="person03" class="com.augus.bean.Person">
    <constructor-arg value="123@qq.com"></constructor-arg>
    <constructor-arg value="40"></constructor-arg>
    <constructor-arg value="王五"></constructor-arg>
</bean>

<!--Person [name=123@qq.com, age=40, email=王五] -->
```

> 如果我们添加一个同样是String类型的参数，并将顺序颠倒赋值，结果就被赋给了错误的值
>
> 如何解决这种问题呢？

```xml
<bean id="person03" class="com.augus.bean.Person">
    <constructor-arg value="123@qq.com" index="2"></constructor-arg>
    <constructor-arg value="40"></constructor-arg>
    <constructor-arg value="王五" index="0"></constructor-arg>
</bean>

<!--Person [name=王五, age=40, email=123@qq.com] -->
```

> 为属性加上index属性，就可以解决不写name，顺序错误问题（虽然没什么用）

> 如果我们让构造函数重载，会发生什么呢

```java
public Person(String name, Integer age) {
    super();
    this.name = name;
    this.age = age;
}

public Person(String name, String email) {
    super();
    this.name = name;
    this.email = email;
}
```

```xml
<bean id="person05" class="com.augus.bean.Person">
    <constructor-arg value="王五"></constructor-arg>
    <constructor-arg value="40"></constructor-arg>
</bean>

<!--Person [name=王五, age=null, email=40] -->
```

> 如何解决这个问题呢
>
> 我们需要另一个属性，type

```xml
<bean id="person05" class="com.augus.bean.Person">
    <constructor-arg value="王五"></constructor-arg>
    <constructor-arg value="40" index="1" type="java.lang.Integer"></constructor-arg>
</bean>

<!--Person [name=王五, age=40, email=null]-->
```



### 3.3 通过p名称空间赋值

```xml
<bean id="person06" class="com.augus.bean.Person" p:name="小花" p:age="20" p:email="123@qq.com">
</bean>
```

> 也可以这样写，但这样写有点乱，太长了，不推荐



### 3.4 为各种类型属性赋值

> 我们在Person类中新增了各种类型的属性

```java
private String name;
private Integer age;
private String email;
private Car car;
private List<Book> books;
private Map<String,Object> maps;
private Properties properties;
```

#### 3.4.1 使用null赋值

```java
private String name = "张三";
private Integer age;
private String email;
private Car car;
private List<Book> books;
private Map<String,Object> maps;
private Properties properties;
```

> 如果我们想把name赋值为null

```java
<bean id="person01" class="com.augus.bean.Person">
    <property name="name"><null/></property>
</bean>
```

> 在属性标签中加入<null>标签



#### 3.4.2 引用赋值

```xml
<bean id="person01" class="com.augus.bean.Person">
    <property name="car" ref="car01"></property>
</bean>

<bean id="car01" class="com.augus.bean.Car">
    <property name="carName" value="宝马"></property>
    <property name="color" value="蓝色"></property>
    <property name="price" value="300000"></property>
</bean>
```

> 使用 ref 引用另一个已注册的 bean 的 id

```xml
<bean id="person01" class="com.augus.bean.Person">
    <property name="car">
        <bean class="com.augus.bean.Car">
            <property name="carName" value="奔驰"></property>
            <property name="color" value="黑色"></property>
            <property name="price" value="400000"></property>
        </bean>
    </property>
</bean>
```

> 或者可以直接在属性内部，嵌套一个<bean>标签



#### 3.4.3 List赋值

```xml
<bean id="person02" class="com.augus.bean.Person">
    <property name="books">
        <list>
            <bean class="com.augus.bean.Book" p:bookName="西游记"></bean>
            <ref bean="book01"/>
        </list>
    </property>
</bean>

<bean id="book01" class="com.augus.bean.Book">
    <property name="bookName" value="三国演义"></property>
</bean>
```

> list赋值写在<list>标签里
>
> 与引用类型赋值相同，可以使用内部bean或者引用外部bean



#### 3.4.4 map赋值

```xml
<bean id="person02" class="com.augus.bean.Person">
    <property name="maps">
        <map>
            <entry key="key01" value="value01"></entry>
            <entry key="key02" value-ref="book01"></entry>
            <entry key="key03">
                <bean class="com.augus.bean.Car">
                    <property name="carName" value="奔驰"></property>
                    <property name="color" value="黑色"></property>
                    <property name="price" value="400000"></property>
                </bean>
            </entry>
            <entry key="key04">
                <map></map>
            </entry>
        </map>
    </property>
</bean>
```

> map赋值与list基本相同，也是写在<map>标签中



#### 3.4.5 Properties赋值

```xml
<bean id="person03" class="com.augus.bean.Person">
    <property name="properties">
        <props>
            <prop key="username">root</prop>
            <prop key="password">1234</prop>
        </props>
    </property>
</bean>
```

> Properties赋值与之前没有什么区别，要注意的是<prop>标签中没有value属性，只能写在两个标签包含的内部



#### 3.4.6 Util名称空间

```xml
<bean id="person04" class="com.augus.bean.Person">
    <property name="maps" ref="map01"></property>
</bean>

<util:map id="map01">
    <entry key="key01" value="value01"></entry>
    <entry key="key02" value-ref="book01"></entry>
    <entry key="key03">
        <bean class="com.augus.bean.Car">
            <property name="carName" value="奔驰"></property>
            <property name="color" value="黑色"></property>
            <property name="price" value="400000"></property>
        </bean>
    </entry>
    <entry key="key04">
        <map></map>
    </entry>
</util:map>
```

> 如果一个集合想被别的bean引用，需要使用util名称空间



#### 3.4.7 级联属性赋值

```xml
<bean id="person05" class="com.augus.bean.Person">
    <property name="car" ref="car01"></property>
    <property name="car.price" value="200"></property>
</bean>

<bean id="car01" class="com.augus.bean.Car">
    <property name="carName" value="奔驰"></property>
    <property name="color" value="黑色"></property>
    <property name="price" value="400000"></property>
</bean>
```

> 引用外部的bean之后，还可以更改其值，直接使用"."即可



### 3.5 bean之间的继承

```xml
<bean id="person06" class="com.augus.bean.Person">
    <property name="name" value="张三"></property>
    <property name="age" value="18"></property>
    <property name="email" value="12@qq.com"></property>
</bean>

<bean id="person07" class="com.augus.bean.Person" parent="person06" >
    <property name="name" value="李四"></property>
</bean>
```

> 如果多个值相同，可以直接继承，并修改其中部分的值
>
> 可以省略class，但不推荐



### 3.6 抽象bean

```xml
<bean id="person06" class="com.augus.bean.Person" abstract="true">
    <property name="name" value="张三"></property>
    <property name="age" value="18"></property>
    <property name="email" value="12@qq.com"></property>
</bean>
```

> 加入 abstract="true" 就可以生命为抽象bean，该对象不可被获取，只可以被其他bean继承



### 3.7 bean之间的依赖

```xml
<bean id="person01" class="com.augus.bean.Person"></bean>
<bean id="car01" class="com.augus.bean.Car"></bean>
<bean id="book01" class="com.augus.bean.Book"></bean>
```

> 这三个对象的创建顺序是从上而下的

```xml
<bean id="person01" class="com.augus.bean.Person" depends-on="car01,book01"></bean>
<bean id="car01" class="com.augus.bean.Car"></bean>
<bean id="book01" class="com.augus.bean.Book"></bean>
```

> 使用depends-on可以改变创建顺序，只是改变了创建顺序



### 3.8 bean的作用域，单实例与多实例**（重点）**

> bean默认是单实例的

```xml
<bean id="book01" class="com.augus.bean.Book" scope="prototype"></bean>
```

> 创建bean的时候，有一个属性叫scope，它有四个选项
>
> `prototype`：多实例
>
> `singleton`：单实例 **默认值**
>
> `request`：在Web环境下，同一次请求创建一次**（没用）**
>
> `session`：在Web环境下，同一次会话创建一次**（没用）**

> 单实例的bean，在容器启动时就已经创建了
>
> 多实例的bean，在使用的时候才会被创建，每次都会创建一个新的对象



### 3.9 通过工厂来创建bean**（重点）**

> bean的创建默认就是框架利用反射new出来的

```java
public class Airplane {
	private String engine;
	private String wingLength;
	private String busload;
	private String captainName;
}
```

> 如果有这样一个类，每次创建对象，除了机长名其余属性都一样
>
> 虽然可以使用之前继承的方法来实现，但还是太麻烦

> 我们可以使用工厂模式，工厂帮我们创造对象，我们只需要给它机长的名字，自动会得到我们想要的对象
>
> 专门有一个类帮我们创造对象，这个类就是工厂类

> 工厂类分为两种：
>
> `静态工厂`：工厂本身不用创建对象，通过静态方法调用  
>
> `实例工厂`：工厂本身需要创建对象



#### 静态工厂

```xml
<bean id="airplane01" class="com.augus.bean.StaticFactory" 
      factory-method="getAirplane">
    <constructor-arg value="张三"></constructor-arg>
</bean>
```

> 在飞机bean标签中
>
> `class`指定工厂的全路径名
>
> `factory-method`指定工厂方法
>
> 如果方法需要参数
>
> 使用<constructor-arg> 为方法传递参数



#### 实例工厂

```xml
<bean id="airplaneFactory" class="com.augus.bean.InstanceFactory"></bean>

<bean id="airplane02" class="com.augus.bean.Airplane" 
      factory-bean="airplaneFactory" factory-method="getAirplane">
    <constructor-arg value="张三"></constructor-arg>
</bean>
```

> 在飞机bean标签中
>
> ` factory-bean`指定工厂的bean
>
> 剩下的与静态工厂一样



#### FactoryBean

> FactoryBean是Spring定义的工厂类接口

```java
public class MyFactoryBean implements FactoryBean<Book>{
	@Override
	public Book getObject() throws Exception {
		Book book = new Book();
		book.setBookName("这是书名");
		return book;
	}
	@Override
	public Class<?> getObjectType() {
		return Book.class;
	}
}
```

```xml
<bean id="myFactory" class="com.augus.bean.MyFactoryBean"></bean>
```

> 如果我们自己写一个方法实现了FactoryBean，并且将它注册到容器中
>
> 我们获取myFactory，会得到一个Book的对象
>
> 因为实现了FactoryBean的对象，Spring会认为它就是一个工厂类
>
> **注意**  此方法并不会在容器启动时创建实例，不论是否是单实例



### 3.10 bean的生命周期

> 我们在Book类中添加两个方法

```java
public void myInit() {
    System.out.println("这是Book的初始化方法...");
}

public void myDestory() {
    System.out.println("这是Book的销毁方法...");
}
```

```xml
<bean id="book01" class="Book" destroy-method="myDestory" init-method="myInit"></bean>
```

> 在bean标签中可以指定初始化方法和销毁方法

> bean的生命周期是
>
> （容器创建）构造器-------->初始化方法-------->（容器关闭）销毁方法
>
> 多实例的时候，在获取bean的时候才会创建对象，容器关闭不会调用销毁方法



### 3.11 bean的后置处理器

> Spring有一个后置处理器接口：可以在bean的初始化前后调用方法

```java
public class MyBeanPostProcessor implements BeanPostProcessor {
    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("[" + beanName + "]Bean将要调用初始化方法...");
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("[" + beanName + "]Bean初始化方法调用完了...");
        return bean;
    }
}
```

```xml
<bean class="com.augus.bean.MyBeanPostProcessor" id="beanPostProcessor"></bean>
```

> 这里返回的bean就是交给下一环的对象
>
> 在这里可以对对象进行一些操作



### 3.12 引用外部属性文件 （重点）

> 数据库连接池作为单实例是很好的

```xml
<bean class="com.mchange.v2.c3p0.ComboPooledDataSource" id="dataSource">
    <property name="user" value="root"></property>
    <property name="password" value="1234"></property>
    <property name="jdbcUrl" value="jdbc:mysql://localhost:3306/test"></property>
    <property name="driverClass" value="com.mysql.jdbc.Driver"></property>
</bean>
```

```java
DataSource dataSource = ioc.getBean(DataSource.class);
```

> 这些属性又如何通过Properties来获取呢

```xml
xmlns:context="http://www.springframework.org/schema/context
xsi:schemaLocation=...
http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context-4.2.xsd
```

> 注意名称空间结尾是context，而不是util，有的时候会自动导入util导致名称空间不可用
>
> 下方还需要加入解析文件，否则会报错

```properties
username123=root
password=1234
url=jdbc:mysql://localhost:3306/test
driver=com.mysql.cj.jdbc.Driver
```

> 这里username123可以起任何名称唯独不能是，username是Spring的保留字
>
> 如果写username会取出spring中的username

```xml
<bean class="com.mchange.v2.c3p0.ComboPooledDataSource" id="dataSource">
    <property name="user" value="${username123}"></property>
    <property name="password" value="${password}"></property>
    <property name="jdbcUrl" value="${url}"></property>
    <property name="driverClass" value="${driver}"></property>
</bean>
```



### 3.13 基于XML的自动装配

```xml
<bean id="car" class="com.augus.bean.Car">
    <property name="brand" value="宝马"></property>
    <property name="color" value="黑色"></property>
    <property name="price" value="300000"></property>
</bean>

<bean class="com.augus.bean.Person" id="person" autowire="byType">
</bean>
```

> 在这里有一个属性autowire
>
> 它的默认值是default：不自动装配
>
> no：不自动装配
>
> byName：按照名称匹配赋值（以属性名作为id去容器中寻找）
>
> byType：按照类型匹配赋值，集合中的内容也会被装配
>
> Constructor：按照构造器进行赋值，按照有参构造器类型进行装配，如果找到了多个则将参数名作为id继续寻找



### 3.14 Spring表达式

```xml
<bean class="com.augus.bean.Person" id="person">
    <!--字面量-->
    <property name="age" value="#{12*5}"></property>
    <!--引用其他bean属性-->
    <property name="name" value="#{book1.bookname}"></property>
    <!--引用其他bean-->
    <property name="car" value="#{car}"></property>
    <!--调用静态方法-->
    <property name="email" value="#{T(java.util.UUID).randomUUID().toString().substring(0,5)}" ></property>
    <!--调用非静态方法-->
    <property name="email" value="#{book1.getBookName()}"></property>
</bean>
```



## 4 注解配置

### 4.1 通过注解创建对象 （重点）

> 通过给bean上添加注解，快捷的将bean加入容器
>
> 1. 给要添加的组件上加注解
> 2. 告诉Spring自动扫描注解
> 3. 导入AOP包

#### 4.1.1 注解

> Spring有四个注解
>
> @Controller：推荐控制器层（Servlet）
>
> @Service：推荐业务逻辑层（Service）
>
> @repository：推荐持久化层（DAO）
>
> @component：推荐其他

```java
@Controller
public class BookServlet {
}

@Service
public class BookService {
}

@Repository
public class BookDao {
}
```

#### 4.1.2 注册扫描

```xml
<context:component-scan base-package="com.augus"></context:component-scan>
```

> 会将base-package下面所有包和所有加了注解的类
>
> 扫描进容器中
>
> 至少精确到2级目录，不然会把一些外部依赖项也导入容器



#### 4.1.3 获取bean

> 加了注解的bean，其id为类名首字母小写



### 4.2 更改默认id

```java
@Repository("bookDao01")
public class BookDao {
}
```



### 4.3 更改多实例

```java
@Scope(value = "prototype")
public class BookDao {
}
```



### 4.4 指定扫描的内容

```xml
<context:component-scan base-package="com.augus">
    <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Repository"/>
</context:component-scan>
```

> context:exclude-filter：可以使扫描时不包含某些组件
>
> type="annotation"：指定排除规则为，以注解进行排除
>
> expression：写注解的全类名

> type还有几种类型的值：
>
> assignable：指定排除某个具体类
>
> aspectj：aspectj表达式
>
> custom：自定义typefilter类，来过滤
>
> regex：正则表达式
>
> 我们一般只用annotation与assignable

```xml
<context:component-scan base-package="com.augus" use-default-filters="false">
    <context:include-filter type="annotation" expression="org.springframework.stereotype.Repository"/>
</context:component-scan>
```

> 也可以反向，选择只要哪些
>
> 这里要禁用掉默认的过滤规则



### 4.5 Autowire （重点）

```java
@Controller
public class BookServlet {
    @Autowired
    private BookService bookService;
```

> 只需要在需要使用的组件上加入 @Autowired
>
> 则会自动从容器中找到相应组件，并且赋值

> 1. 先按照类型去容器中寻找组件，找到则赋值，找不到就报错
> 2. 如果找到多个，按照变量名作为id继续匹配，匹配成功则赋值，匹配不到则报错

```java
@Qualifier("bookService2")
@Autowired
private BookService bookService;
```

> 也可以用@Qualifier("bookService2")手动为其指定一个id来赋值

```java
@Qualifier("bookService2")
@Autowired(required = false)
private BookService bookService;
```

> 如果找不到不想报错，则可以@Autowired(required = false)这样写
>
> 如果找不到，就用null赋值
>
> 但这样容易产生空指针异常

```java
@Autowired
public void test01(BookDao bookDao){
    
}
```

> @Autowired写在方法上，方法的参数也会自动注入
>
> 这个方法在bean创建的时候会自动运行
>
> 可以当做自动set方法使用

```java
@Autowired
public void test01(@Qualifier("bookDao2") BookDao bookDao){
}
```

> 在参数中也可以嵌套@Qualifier("bookDao2") 使用指定id的组件进行注入



### 4.6 Resource、Inject

> 这两个注解也可以实现Autowire的功能，但他们不能使用required = false这样的参数
>
> Resource是J2EE的标准，Inject是EJB的标准
>
> Autowire是Spring规定的，Autowire的功能要更加强大



### 4.7 泛型依赖注入 （重点）

```java
public class BaseService<T> {

    @Autowired
    BaseDao<T> baseDao;

    public void save(){
        System.out.println("baseDao是：" + baseDao);
        baseDao.save();
    }
}

@Service
public class BookService extends BaseService<Book> {

}

bookService.save();

//baseDao是：com.augus.dao.BookDao@515aebb0
//BookDao save...
```

> 我们发现，BaseService我们并没有注册
>
> 但是依然可以成功赋值，并且引用了正确的BookDao

> 在注入时，BookService需要BaseDao\<Book>这个类型
>
> 所以会在容器中找到 BookDao extends BaseDao\<Book>
>
> 来完成对应的注入

> **在注入组件时，泛型也是参考标准**

## 5 Spring单元测试

> 我们直接把Junit注册称为Spring的组件，并且要求它为我们自动注入会陷入死循环
>
> 这个时候应该用Spring自己的单元测试

```xml
<!-- https://mvnrepository.com/artifact/org.springframework/spring-test -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-test</artifactId>
    <version>5.3.9</version>
    <scope>test</scope>
</dependency>
```

```java
@ContextConfiguration(locations = "classpath:Spring-Config.xml")
@RunWith(SpringJUnit4ClassRunner.class)
public class MyTest {

    @Autowired
    BookServlet bookServlet;

    @Test
    public void test01() throws SQLException {
        System.out.println(bookServlet);
    }
}
```

> 此方法仅适用于Junit4，Junit5不可以









