# Mybatis

> MyBatis 是支持定制化 SQL、存储过程以及高级映射的优秀的持久层框架。
>
> MyBatis 避免了几乎所有的 JDBC 代码和手动设置参数以及获取结果集。
>
> MyBatis可以使用简单的XML或注解用于配置和原始映射，将接口和Java的POJO（Plain Old Java Objects，普通的Java对象）映射成数据库中的记录.



## Hello World

### 依赖

```xml
<!-- https://mvnrepository.com/artifact/org.mybatis/mybatis -->
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.5.7</version>
</dependency>
<!-- https://mvnrepository.com/artifact/mysql/mysql-connector-java -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.24</version>
</dependency>
<!-- https://mvnrepository.com/artifact/log4j/log4j -->
<dependency>
    <groupId>log4j</groupId>
    <artifactId>log4j</artifactId>
    <version>1.2.17</version>
</dependency>
```

### 数据库建表

```mysql
create table t_employee(
    id int primary key auto_increment,
    empname varchar(50) not null ,
    gender int,
    email varchar(100)
);

insert into t_employee(empname, gender, email) VALUES ('admin',0,'admin@qq.com');
```

### Java Bean

```java
package com.augus.bean;

public class Employee {
    private Integer id;
    private String empName;
    private String email;
    private Integer gender;
```

### Dao

```java
package com.augus.dao;

import com.augus.bean.Employee;

public interface EmployeeDao {
    public Employee getEmpById(Integer id);
```

### mybatis全局配置文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
                <property name="driver" value="com.mysql.cj.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/mybatis_test"/>
                <property name="username" value="root"/>
                <property name="password" value="1234"/>
            </dataSource>
        </environment>
    </environments>
</configuration>
```

### SQL映射文件

> 编写每一个方法执行的sql语句

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<!--namespace:名称空间：填写接口的全类名，相当于告诉Mybatis，这个配置文件是实现哪个接口的-->
<mapper namespace="com.augus.dao.EmployeeDao">

    <!--id：方法名，相当于方法的实现-->
    <!--resultType：指定返回值类型，查询操作必须指定-->
    <!--#{id}:属性名，代表取出某个参数的值-->
    <select id="getEmpById" resultType="com.augus.bean.Employee">
        select * from t_employee where id = #{id}
    </select>
</mapper>
```

### 注册映射文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
                <property name="driver" value="com.mysql.cj.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/mybatis_test"/>
                <property name="username" value="root"/>
                <property name="password" value="1234"/>
            </dataSource>
        </environment>
    </environments>
    <mappers>
        <mapper resource="EmployeeDao.xml"/>
    </mappers>
</configuration>
```

### 使用

```java
//根据全局配置文件创建SqlSessionFactory
String path = "mybatis-config.xml";
InputStream is = Resources.getResourceAsStream(path);
SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(is);

//获取会话
SqlSession sqlSession = sqlSessionFactory.openSession();
//获取dao接口实现
EmployeeDao mapper = sqlSession.getMapper(EmployeeDao.class);
Employee employee = mapper.getEmpById(1);
System.out.println(employee);
sqlSession.close();
```

> 获取到的接口，是代理对象，是Mybatis自动创建的

## 如何写xml有提示

> 只要找到了dtd约束文件，则可以自动提示
>
> 如果联网，此dtd会自动下载

> 在Mybatis Jar包中builder/xml中有这个dtd文件
>
> 可以手动将这两个文件添加到IDE的设置中
>
> 关键词DTD或xml catalog

## 实现增删改查

```java
public Employee getEmpById(Integer id);
public int updateEmployee(Employee employee);
public int deleteEmployee(Integer id);
public int insertEmployee(Employee employee);
```

> 我们把dao再多添加几个方法

```xml
<mapper namespace="com.augus.dao.EmployeeDao">
    
    <select id="getEmpById" resultType="com.augus.bean.Employee">
        select * from t_employee where id = #{id}
    </select>
    
    <update id="updateEmployee">
        update t_employee set empname = #{empName} , gender = #{gender} , email = #{email} where id = #{id}
    </update>

    <delete id="deleteEmployee">
        delete from t_employee where id = #{id}
    </delete>

    <insert id="insertEmployee">
        insert into t_employee(empname, gender, email) VALUES (#{empName},#{gender},#{email})
    </insert>
</mapper>
```

> 在xml中将要执行的sql语句写好
>
> 参数如果是对象，也可以直接用 #{empName}取对象中的属性

```java
String path = "mybatis-config.xml";
InputStream is = Resources.getResourceAsStream(path);
SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(is);

SqlSession sqlSession = sqlSessionFactory.openSession();
EmployeeDao mapper = sqlSession.getMapper(EmployeeDao.class);

Employee e1 = mapper.getEmpById(1);
System.out.println(e1);

Employee zhangsan = new Employee(null, "张三", "zhangsan@qq.com", 1);
mapper.insertEmployee(zhangsan);


Employee lisi = new Employee(1, "李四", "lisi@qq.com", 1);
mapper.updateEmployee(lisi);

Employee wangwu = new Employee(3, "王五", "wangwu@qq.com", 1);
mapper.insertEmployee(wangwu);
mapper.deleteEmployee(3);

sqlSession.commit();
sqlSession.close();
```

> 注意默认自动提交是关闭的
>
> 关闭会话前要提交



## 全局配置文件

> MyBatis 的配置文件包含了影响 MyBatis 行为甚深的设置（settings）和属性（properties）信息。文档的顶层结构如下：
>
> - configuration 配置
>    - properties 属性
>
>    - settings 设置
>
>    - typeAliases 类型命名
>
>    - typeHandlers 类型处理器
>
>    - objectFactory 对象工厂
>
>    - plugins 插件
>
>    - environments 环境
>
>      - environment 环境变量
>         - transactionManager 事务管理器
>         - dataSource 数据源
>    - databaseIdProvider 数据库厂商标识
>
>    - mappers 映射器



### properties

```xml
<properties resource="jdbc.properties"></properties>
```

> 从外部引入配置文件
>
> 它有两个属性
>
> resource：从类路径下引用
>
> url：从磁盘路径或网络位置引用

```xml
<environments default="development">
    <environment id="development">
        <transactionManager type="JDBC"/>
        <dataSource type="POOLED">
            <property name="driver" value="${driver}"/>
            <property name="url" value="${url}"/>
            <property name="username" value="${username}"/>
            <property name="password" value="${password}"/>
        </dataSource>
    </environment>
</environments>
```

> 使用${}引入属性值



### settings

> 修改Mybatis运行行为的配置
>
> 很多设置可以去官方文档查询

```xml
<settings>
    <setting name="mapUnderscoreToCamelCase" value="true"/>
</settings>
```

> 这个设置是可以自动将数据库中的
>
> a_salary自动转换给aSalary属性
>
> 每个_后的自动变大写查找相应属性赋值



### typeAliases

> 为Java类型起别名

```xml
<typeAliases>
    <typeAlias type="com.augus.bean.Employee" alias="Employee"/>
</typeAliases>
```

> 这样我们在映射配置文件中就可以使用别名代替全类名
>
> 别名不区分大小写

```xml
<typeAliases>
    <package name="com.augus.bean"/>
</typeAliases>
```

> 也可以为一个包下面所有类起别名
>
> 默认别名为类名

```java
@Alias("emp")
public class Employee {
    private Integer id;
    private String empName;
    private String email;
    private Integer gender;
```

> 也可以在类上面加注释起别名

> 推荐还是使用全类名
>
> 便于阅读，便于定位

> Mybatis已经为java常见类型起好别名了
>
> 普通类型就是在之前加下划线，例如_int
>
> 包装类就是类名，例如string
>
> 注意不要占用这些关键字



### typeHandlers

> 在预处理参数传入时，和最终结果输出时
>
> 使用类型处理器以合适的方式进行转换

> 也可以自定义转换器，继承BaseTypeHandler<T>即可
>
> 再将其通过此标签，注册进Mybatis
>
> 使用方法与JDBC一样，可参照官方文档，很简单



### objectFactory

> 使用对象工厂，帮我们的查询结果封装成指定对象
>
> 一般没人会重写这个对象工厂，所以也不会用到这个标签



### plugins

> 插件是Mybatis中一个强大的功能
>
> 自定义更改Mybatis行为的插件，需要我们对Mybatis底层运行原理非常熟悉
>
> 所以以后再提



### environments

> 配置环境使用
>
> 每一个environment用来配置一个环境，每一个环境都需要一个数据源和一个事务管理器

```xml
<environments default="development">
    <environment id="development">
        <transactionManager type="JDBC"/>
        <dataSource type="POOLED">
            <property name="driver" value="${driver}"/>
            <property name="url" value="${url}"/>
            <property name="username" value="${username}"/>
            <property name="password" value="${password}"/>
        </dataSource>
    </environment>
</environments>
```

> 通过更改default来切换激活的环境

> 事务是要交给Spring控制的
>
> 数据源要交给第三方连接池管理的
>
> 所以这个标签以后不怎么用到



### databaseIdProvider

> Mybatis用来做数据库移植的

```xml
<databaseIdProvider type="DB_VENDOR">
    <property name="Oracle" value="oracle"/>
    <property name="MySQL" value="mysql"/>
</databaseIdProvider>
```

> type="DB_VENDOR"这是写死的，不能改变
>
> 下面的name填数据库厂商标识，value起一个别名

```xml
<select id="getEmpById" resultType="com.augus.bean.Employee" databaseId="mysql">
    select * from t_employee where id = #{id}
</select>
```

> 可以写很多个语句，针对同一个方法，并标注他们各自的运行环境
>
> 这样在切换数据库时，Mybatis会按你指定的自动切换

> 一般没有公司会天天切数据库



### mappers

> 这是我们最需要关注的标签
>
> 注册映射配置文件

```xml
<mapper class=""/>
<mapper url=""/>
<mapper resource=""/>
```

> 默认我们用resource在类路径下找映射文件
>
> url是从磁盘路径或者网络位置寻找映射文件
>
> class是直接引用某个dao接口

> 如果使用class引用接口，映射配置文件应该和接口使用同样的名字，并且放在同样的路径下

> 使用class也可以直接不写映射文件，直接在方法上方写注解

```java
@Select("select * from t_employee where id = #{id}")
public Employee getEmpById(Integer id);

@Update("update t_employee set empname = #{empName} , gender = #{gender} , email = #{email} where id = #{id}")
public int updateEmployee(Employee employee);
```

```xml
<package name="com.augus.dao"/>
```

> 也可以批量注册，但是需要将xml也放入指定的文件夹



## 配置文件不在根目录解决

> 如果以批量注册，或者class注册的方式
>
> xml文件没有放在resources下
>
> 但是maven打包的时候，main.java中不是java文件都会被忽略，导致配置文件读取失败

```xml
<build>
    <resources>
        <resource>
            <directory>src/main/java</directory>
            <includes>
                <include>*.xml</include>
                <include>**/*.xml</include>
            </includes>
            <filtering>true</filtering>
        </resource>
    </resources>
</build>
```

> 需要在pom文件中加入这样的代码
>
> 表示要包含src/main/java目录及子目录下所有xml文件

## SQL映射配置文件

> 在这个配置文件中，我们能用的标签有：
>
> cache：和缓存相关
>
> cache-ref：和缓存相关
>
> delete，update，insert，select：增删改查
>
> ~~parameterMap：过时的，进行复杂参数映射，不使用~~
>
> resultMap：自定义结果集封装规则
>
> sql：抽取可重用的sql



### 增删改标签

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\SSM\Mybatis\增删改.png)



### 获取自增ID

```java
Employee haha = new Employee(null, "haha", "haha@qq,com", 1);
int i = mapper.insertEmployee(haha);
System.out.println(haha.getId());
```

> 这样获取，肯定是null
>
> 我们如何让Mybatis把自增后的id赋值给对象呢

```xml
<insert id="insertEmployee" useGeneratedKeys="true" keyProperty="id">
    insert into t_employee(empname, gender, email) VALUES (#{empName},#{gender},#{email})
</insert>
```

> useGeneratedKeys是告诉Mybatis，将自增后的id赋值回来
>
> keyProperty表示赋值给哪个属性

```xml
<insert id="insertEmployee">
    <selectKey order="BEFORE" keyProperty="id">
        select max(id)+1 from t_employee
    </selectKey>
    insert into t_employee(id,empname, gender, email) VALUES (#{id},#{empName},#{gender},#{email})
</insert>
```

> selectKey也可以进行获取某个值，赋值给我们的对象
>
> order就是让此语句在主语句之前还是之后运行
>
> 有些不支持自增的数据库，或者全字段更新，可以这样写



### 查询

#### 获取参数

```xml
<select id="getEmpByIdAndName" resultType="com.augus.bean.Employee">
    select * from t_employee where id = #{id} and empname = #{name}
</select>
```

> 如果需要多个参数，这样写就会出错

```xml
<select id="getEmpByIdAndName" resultType="com.augus.bean.Employee">
    select * from t_employee where id = #{0} and empname = #{1}
</select>
```

```xml
<select id="getEmpByIdAndName" resultType="com.augus.bean.Employee">
    select * from t_employee where id = #{param1} and empname = #{param2}
</select>
```

> 要么使用索引，要么使用param1，param2

> 如果传入了**单个基本类型**参数
>
> 使用**#{随便写}**就可以取值成功

> 如果传入**多个参数**
>
> 使用**0,1（索引）或者param1，param2**
>
> Mybatis会将你传入的值，存放在Map中，并且key就是顺序的值
>
> map.put("1",参数1)
>
> map.put("2",参数2)
>
> 我们可以告诉Mybatis，封装Map的时候用我们指定的值

```java
public Employee getEmpByIdAndName(@Param("id") Integer id,@Param("name") String name);
```

> 在dao接口中，在参数前面加上@Param("id")来指定参数的Key
>
> **@Param("xxx")叫做命名参数，我们之后会经常使用**

> **传入的值是pojo**
>
> **直接使用#{属性名}**就可以取出

> **传入的值是Map**
>
> **将参数名作为Key，参数值作为value，直接使用#{Key}取值**

```java
method01(@param("id") Integer id, String empName, Employee employee)
```

> Integer id  --->   #{id}
>
> String empName  --->   #{param2}
>
> Employee employee中的email  --->   #{param3.email}



#### 取值额外设置

> 在取值的时候可以设置一些规则
>
> javaType、jdbcType、mode、numericScale、resultMap、typeHandler、jdbcTypeName、expression

> 我们常用的只有jdbcType
>
> #{id,jdbcType=INTEGER}
>
> 默认不指定是没问题的
>
> 万一传入的数据是null，Oracle会不知道是什么类型，必须手动指定一下



#### ${} 和 #{}

> 其实这两种方式都可以取属性值
>
> 他们的区别#{}使用预编译的方式，参数值用？占位，然后设置进去
>
> ${}是直接拼串

> 因为只有参数才可以预编译传进去
>
> 当我们别的部分需要动态取值时，比如表名不确定
>
> 只能使用${}



#### 查询返回list

```xml
<select id="getAllEmps" resultType="com.augus.bean.Employee">
    select * from t_employee
</select>
```

> 注意，这里的resultType写的是list中元素的类型，而不是写list



#### 查询返回Map

> 查询列名作为key，值作为value的Map集合

```xml
<select id="getEmpByIdReturnMap" resultType="map">
    select * from t_employee where id = #{id}
</select>
```

> 查询主键作为key，该条记录对象作为value

```java
@MapKey("id")
public Map<Integer,Employee> getAllEmpsReturnMap();
```

> 在方法上加入@MapKey("id")指定id字段作为key的值

```xml
<select id="getAllEmpsReturnMap" resultType="com.augus.bean.Employee">
    select * from t_employee
</select>
```

> resultType依然填元素的类型



#### 自定义封装规则

> 如果sql中的字段名与Java实体类属性名不一致，我们又不想起别名，该怎么映射呢

```mysql
create table t_cat(
    id int primary key auto_increment,
    cName varchar(20),
    cAge int,
    cgender int
);
```

```java
public class Cat {

    private Integer id;
    private String name;
    private Integer gender;
    private Integer age;
```

```xml
<!--resultMap来自定义每一行数据和java Bean的映射规则-->
<!--type：指定为哪个java Bean自定义规则  id：起别名-->
<resultMap id="myCat" type="com.augus.bean.Cat">
    <!--指定主键列对应，column指定哪一列是主键  property指定目标对象哪个属性接收这个属性-->
    <id column="id" property="id"/>
    <!--普通列使用result来指定映射规则-->
    <result column="cname" property="name"/>
    <result column="cgender" property="gender"/>
    <result column="cAge" property="age"/>
</resultMap>
```

```xml
<select id="getCatById" resultMap="myCat">
    select * from t_cat where id = #{id}
</select>
```

> 改变查询的封装规则为自己定义的封装规则





### 联合查询

#### 一对一

```java
public class Key {
    private Integer id;
    private String keyName;
    private Lock lock;
```

```xml
<select id="getKeyById" resultMap="myKey">
    select k.id kid,keyName,lockName,tl.id lid
    from t_key k
    join t_lock tl on tl.id = k.lockId
    where k.id = #{id}
</select>

<resultMap id="myKey" type="com.augus.bean.Key">
    <id property="id" column="kid"/>
    <result property="keyName" column="keyName"/>
    <result property="lock.id" column="lid"/>
    <result property="lock.lockName" column="lockName"/>
</resultMap>
```

> Mybatis更推荐我们用下面这种写法

```xml
<resultMap id="myKey2" type="com.augus.bean.Key">
    <id property="id" column="kid"/>
    <result property="keyName" column="keyName"/>
    <association property="lock" javaType="com.augus.bean.Lock">
        <id property="id" column="lid"/>
        <result property="lockName" column="lockName"/>
    </association>
</resultMap>
```

> 嵌套一层association



#### 一对多

```mysql
insert into t_lock(lockName) value ('3号锁');

insert into t_key(keyName, lockId) VALUE ('3号锁钥匙1',3);
insert into t_key(keyName, lockId) VALUE ('3号锁钥匙2',3);
insert into t_key(keyName, lockId) VALUE ('3号锁钥匙3',3);
```

> 3号锁，有3把钥匙

```xml
<select id="getLockById" resultMap="myLock">
    select l.id lid,lockName,tk.id kid,tk.keyName,tk.lockId
    from t_lock l
    join t_key tk on l.id = tk.lockId
    where l.id = #{id}
</select>

<resultMap id="myLock" type="com.augus.bean.Lock">
    <id property="id" column="lid"/>
    <result property="lockName" column="lockName"/>
    <collection property="keys" ofType="com.augus.bean.Key">
        <id column="kid" property="id"/>
        <result property="keyName" column="keyName"/>
    </collection>
</resultMap>
```

> 使用collection来表示一个集合



#### 分步查询

```xml
<select id="getLockByIdSimple" resultType="com.augus.bean.Lock">
    select * from t_lock where id = #{id}
</select>
```

> 首先有一个简易查所有锁的查询

```xml
<select id="getKeyByIdSimple" resultMap="myKey3">
    select * from t_key where id = #{id}
</select>

<resultMap id="myKey3" type="com.augus.bean.Key">
    <id property="id" column="id"/>
    <result property="keyName" column="keyName"/>
    <association property="lock" select="com.augus.dao.LockDao.getLockByIdSimple" column="lockId">
    </association>
</resultMap>
```

> 再有一个简易查钥匙的查询
>
> 只不过映射的时候，我们使用select，调用另外一个查询
>
> 并且使用column将某一列的值作为参数传递进去



#### 按需加载&延迟加载

```xml
<settings>
    <setting name="lazyLoadingEnabled" value="true"/>
    <setting name="aggressiveLazyLoading" value="false"/>
</settings>
```

```java
KeyDao mapper = sqlSession.getMapper(KeyDao.class);
Key keyByIdSimple = mapper.getKeyByIdSimple(3);
String keyName = keyByIdSimple.getKeyName();
System.out.println(keyName);
Thread.sleep(2000);
String lockName = keyByIdSimple.getLock().getLockName();
System.out.println(lockName);
```

> 在我们没有用到某些属性时，他不会执行子查询的sql语句
>
> 需要用时，才触发执行

```xml
<resultMap id="myKey3" type="com.augus.bean.Key">
    <id property="id" column="id"/>
    <result property="keyName" column="keyName"/>
    <association property="lock" select="com.augus.dao.LockDao.getLockByIdSimple" column="lockId" fetchType="eager">
    </association>
</resultMap>
```

> 在全局延迟加载开启的情况下，我们在嵌套查询中添加fetchType="eager"
>
> 会无视全局延迟加载，直接查出所有数据

> 虽然可以这样做，但是还是**推荐使用连接查询**



## 动态SQL

> 动态SQL是Mybatis强大特性之一，极大简化了我们拼装SQL的操作

```java
public List<Teacher> getTeacherByCondition(Teacher teacher);
```

> 有这样一个方法，我传入Teacher对象
>
> 自动判断有属性的值，用and拼接
>
> 按照之前的思路我们应该会这样写

```xml
<select id="getTeacherByCondition" resultMap="teacherMap">
    select * from t_teacher where
    <if test="id != null">
        id > #{id} and
    </if>
    <if test="name != null &amp;&amp; !name.equals(&quot;&quot;)">
        teacherName like #{name} and
    </if>
    <if test="birth != null">
        birth_date &lt; #{birth}
    </if>
</select>
```

> 这时候，如果birth为空，sql就会以and结尾而报错



### where标签

```xml
<select id="getTeacherByCondition" resultMap="teacherMap">
    select * from t_teacher
    <where>
        <if test="id != null">
            and id > #{id}
        </if>
        <if test="name != null &amp;&amp; !name.equals(&quot;&quot;)">
            and teacherName like #{name}
        </if>
        <if test="birth != null">
            and birth_date &lt; #{birth}
        </if>
    </where>
</select>
```

> where标签首先会添加where关键字到sql中
>
> 其次会去掉不改存在的and或or



### trim标签

> trim标签有4个属性
>
> **prefix：**为标签内sql整体添加前缀
>
> **prefixOverrides：**去除字符串前缀多余的字符
>
> **suffix：**为标签内sql整体添加后缀
>
> **suffixOverrides：**去除字符串后缀多余的字符

```xml
<select id="getTeacherByCondition" resultMap="teacherMap">
    select * from t_teacher
    <trim prefix="where" suffixOverrides="and">
        <if test="id != null">
            id > #{id} and
        </if>
        <if test="name != null &amp;&amp; !name.equals(&quot;&quot;)">
            teacherName like #{name} and
        </if>
        <if test="birth != null">
            birth_date &lt; #{birth} and
        </if>
    </trim>
</select>
```

> 推荐使用where标签



### foreach标签

> 我们现在想完成动态拼接以下语句
>
> ```mysql
> select * from t_teacher where id in (1,2,3...)
> ```
>
> 数值由list集合传过来

> 在foreach标签中有6个参数
>
> **collection：**指定要遍历的集合
>
> **close：**整体遍历以什么结束（往整体遍历后添加一部分内容）
>
> **index：**索引，如果遍历的是一个list，为其指定一个变量，来保存当前索引。如果遍历的是Map，index定义的变量就保存当前遍历到的key
>
> **item：**指定当前遍历到的对象的名称
>
> **open：**整体遍历以什么开始（往整体遍历前添加一部分内容）
>
> **separator：**元素之间的分隔符

```xml
<select id="getTeacherByIdIn" resultMap="teacherMap">
    select * from t_teacher where id in
    <foreach collection="ids" item="id_item" separator="," open="(" close=")">
        #{id_item}
    </foreach>
</select>
```

> ids是我们在Dao接口中定义的注解名
>
> ```java
> public List<Teacher> getTeacherByIdIn(@Param("ids") List<Integer> list);
> ```



### choose标签

```xml
<select id="getTeacherByConditionChoose" resultMap="teacherMap">
    select * from t_teacher
    <where>
        <choose>
            <when test="id != null"> id = #{id} </when>
            <when test="name != null &amp;&amp; !name.equals(&quot;&quot;)"> teacherName = #{name} </when>
            <when test="birth != null"> birth_date = #{birth} </when>
            <otherwise>
                1 = 1
            </otherwise>
        </choose>
    </where>
</select>
```

> 这个与where的区别就是
>
> choose只有一个属性会生效
>
> where如果表达式成立，都会生效



### set标签

```xml
<update id="updateTeacher">
    update t_teacher
    <set>
        <if test="name != null &amp;&amp; !name.equals(&quot;&quot;)">
            teacherName = #{name},
        </if>
        <if test="course != null &amp;&amp; !course.equals(&quot;&quot;)">
            class_name = #{course},
        </if>
        <if test="address != null &amp;&amp; !address.equals(&quot;&quot;)">
            address = #{address},
        </if>
        <if test="birth != null">
            birth_date = #{birth}
        </if>
    </set>
    <where>
        id = #{id}
    </where>
</update>
```

> set可以自动删除结尾多余的，



### 补充说明

> 动态SQL引用的是OGNL表达式
>
> **获取属性：**对象.子对象.子属性
>
> **运行方法：**对象.方法()
>
> **调用静态属性：**@java.lang.Math@PI 
>
> **调用静态方法：**@java.util.UUID@randomUUID() 
>
> **调用构造方法：**new com.augus.bean.Person("admin").name
>
> **使用运算符：**+ ， - ， * ， / ， %
>
> **使用逻辑运行算符（需要转义）：** in ， not in ， > ， < ， = = ， != ， >= ， <=
>
> **使用伪属性：**list.size ， list.isEmpty ， list.iterator ， map.kes ，Iterator.next

> 在Mybatis中，不止可以引用传入的参数
>
> 还有两个参数是存在的
>
> **_Parameter：**代表传入的参数。传入单个参数\_Parameter就代表这个参数，传入多个参数_Parameter就代表这些参数的集合Map
>
> **_databaseId：**代表当前数据库环境，可以直接判断环境来定制语句（替代databaseId属性），它的值为你配置databaseIdProvider中的别名



### 抽取重用sql

```xml
<sql id="selectTeacher">
    select * from t_teacher
</sql>

<select id="getTeacherById" resultMap="teacherMap">
    <include refid="selectTeacher"></include>
     where id = #{id}
</select>
```



## 缓存

### 一级缓存

> 也叫SqlSession级别的缓存，默认是开启的

```java
TeacherDao mapper = sqlSession.getMapper(TeacherDao.class);
Teacher t1 = mapper.getTeacherById(1);
System.out.println(t1);

System.out.println("********************************");

Teacher t2 = mapper.getTeacherById(1);
System.out.println(t2);
```

> 第二次查询，并没有发送Sql语句



### 增删改清缓存

```java
TeacherDao mapper = sqlSession.getMapper(TeacherDao.class);
Teacher t1 = mapper.getTeacherById(1);
System.out.println(t1);

System.out.println("********************************");
Teacher teacher = new Teacher();
teacher.setId(3);
teacher.setName("3号");
mapper.updateTeacher(teacher);

Teacher t2 = mapper.getTeacherById(1);
System.out.println(t2);

sqlSession.commit();
sqlSession.close();
```

> 在sqlSession期间执行任何一次增删改操作，都会清空缓存



### 清除缓存

```java
sqlSession.clearCache();
```

> 手动清除缓存



### 二级缓存

> 二级缓存是全局缓存，默认不开启
>
> 二级缓存在sqlSession关闭或提交之后才会生效

```xml
<setting name="cacheEnabled" value="true"/>
```

> 在全局配置里添加一条属性，开启二级缓存

```xml
<cache></cache>
```

> 在映射配置文件中加入cache标签，为此映射开启缓存

```java
public class Teacher implements Serializable {
```

> 为封装的实体类添加序列化接口

```java
SqlSession sqlSession = sqlSessionFactory.openSession();
SqlSession sqlSession1 = sqlSessionFactory.openSession();

TeacherDao mapper = sqlSession.getMapper(TeacherDao.class);
TeacherDao mapper1 = sqlSession1.getMapper(TeacherDao.class);

Teacher t1 = mapper.getTeacherById(1);
System.out.println(t1);
sqlSession.close();

System.out.println("********************************");
Teacher t2 = mapper1.getTeacherById(1);
System.out.println(t2);
sqlSession1.close();
```

> 二级缓存是namespace级别的缓存

> 在映射文件中cache标签也有属性可以设置
>
> **eviction：**缓存回收策略
>
> ​	LRU（默认值）：移除最长时间不被使用的
>
> ​	FIFO：按进入缓存的顺序，先进先出
>
> ​	SOFT：移除基于垃圾回收器状态和弱引用规则的对象
>
> ​	WEEK：更积极地移除基于垃圾回收器状态和弱引用规则的对象
>
> **flushInterval：**刷新间隔，单位毫秒，默认情况不设置
>
> **size：**引用数目，正整数，代表缓存最多可以存储多少个对象
>
> **readOnly：**只读，如果是只读，则返回缓存对象。如果不是，则返回缓存对象的拷贝



### 缓存相关设置

```xml
<select id="getTeacherById" resultMap="teacherMap" useCache="true">
```

> 在查询标签中，useCache用来控制是否使用二级缓存（一级缓存永远是生效的）

```xml
<update id="updateTeacher" flushCache="true">
```

> 增删改中有个属性flushCache，默认是true，所以调用增删改会自动清空缓存，会同时清空一级和二级缓存
>
> 查询标签中也可以设置flushCache，默认值是false



### 整合第三方缓存

> Mybatis缓存做的有些简陋，一般要使用二级缓存，我们会引入第三方缓存

```xml
<!-- https://mvnrepository.com/artifact/org.mybatis.caches/mybatis-ehcache -->
<dependency>
    <groupId>org.mybatis.caches</groupId>
    <artifactId>mybatis-ehcache</artifactId>
    <version>1.2.1</version>
</dependency>
```

> 我们以ehcache做例子
>
> 如果仅仅使用缓存框架，我们需要自己写一个实现Cache接口的类，再调用框架，将数据存入
>
> 导入这个Mybatis ehcache就能简化这一部分的操作
>
> 因为此依赖依赖ehcache所以，导入一个即可

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ehcache xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="../config/ehcache.xsd">
    <!-- 磁盘保存路径 -->
    <diskStore path="D:\ehcache" />

    <defaultCache
            maxElementsInMemory="100"
            maxElementsOnDisk="10000000"
            eternal="false"
            overflowToDisk="true"
            timeToIdleSeconds="120"
            timeToLiveSeconds="120"
            diskExpiryThreadIntervalSeconds="120"
            memoryStoreEvictionPolicy="LRU">
    </defaultCache>
</ehcache>

        <!--
        属性说明：
        l diskStore：指定数据在磁盘中的存储位置。
        l defaultCache：当借助CacheManager.add("demoCache")创建Cache时，EhCache便会采用<defalutCache/>指定的的管理策略

        以下属性是必须的：
        l maxElementsInMemory - 在内存中缓存的element的最大数目
        l maxElementsOnDisk - 在磁盘上缓存的element的最大数目，若是0表示无穷大
        l eternal - 设定缓存的elements是否永远不过期。如果为true，则缓存的数据始终有效，如果为false那么还要根据timeToIdleSeconds，timeToLiveSeconds判断
        l overflowToDisk - 设定当内存缓存溢出的时候是否将过期的element缓存到磁盘上

        以下属性是可选的：
        l timeToIdleSeconds - 当缓存在EhCache中的数据前后两次访问的时间超过timeToIdleSeconds的属性取值时，这些数据便会删除，默认值是0,也就是可闲置时间无穷大
        l timeToLiveSeconds - 缓存element的有效生命期，默认是0.,也就是element存活时间无穷大
         diskSpoolBufferSizeMB 这个参数设置DiskStore(磁盘缓存)的缓存区大小.默认是30MB.每个Cache都应该有自己的一个缓冲区.
        l diskPersistent - 在VM重启的时候是否启用磁盘保存EhCache中的数据，默认是false。
        l diskExpiryThreadIntervalSeconds - 磁盘缓存的清理线程运行间隔，默认是120秒。每个120s，相应的线程会进行一次EhCache中数据的清理工作
        l memoryStoreEvictionPolicy - 当内存缓存达到最大，有新的element加入的时候， 移除缓存中element的策略。默认是LRU（最近最少使用），可选的有LFU（最不常使用）和FIFO（先进先出）
         -->
```
> 写一个ehcache.xml

```xml
<cache type="org.mybatis.caches.ehcache.EhcacheCache"></cache>
```

> 在映射文件cache标签中，加入Mybatis ehcach的实现类

```xml
<cache-ref namespace="com.augus.dao.TeacherDao"/>
```

> 其他dao也可以加入cache-ref，与目标共用一个缓存



## 整合Spring

```xml
<!-- https://mvnrepository.com/artifact/org.mybatis/mybatis-spring -->
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis-spring</artifactId>
    <version>2.0.6</version>
</dependency>
```

```xml
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
    <property name="configLocation" value="classpath:Mybatis/mybatis-config.xml"/>
    <property name="dataSource" ref="dataSource"/>
    <property name="mapperLocations" value="classpath:Mybatis/mapper/*.xml"/>
</bean>
```

> 在Spring中添加Mybatis的配置，引用Spring中定义好的dataSource

```xml
<bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
    <property name="basePackage" value="com.augus.dao"/>
</bean>
```

> 在Spring中添加mybatis-spring整合类
>
> 将Dao的路径填入，这样就可以自动注入被代理的Dao



## 分页插件

```xml
<!-- https://mvnrepository.com/artifact/com.github.pagehelper/pagehelper -->
<dependency>
    <groupId>com.github.pagehelper</groupId>
    <artifactId>pagehelper</artifactId>
    <version>5.1.11</version>
</dependency>
<!-- https://mvnrepository.com/artifact/com.github.jsqlparser/jsqlparser -->
<dependency>
    <groupId>com.github.jsqlparser</groupId>
    <artifactId>jsqlparser</artifactId>
    <version>4.0</version>
</dependency>
```

```xml
<plugins>
    <plugin interceptor="com.github.pagehelper.PageInterceptor"></plugin>
</plugins>
```

> 在Mybatis配置文件中引入插件

```java
EmployeeDao mapper = sqlSession.getMapper(EmployeeDao.class);
PageHelper.startPage(1,2);
List<Employee> all = mapper.getAll();
for (Employee e : all) {
    System.out.println(e);
}
sqlSession.close();
```

> 只需要在调用之前调用一下，就可以实现分页的操作
>
> ```java
> PageHelper.startPage(1,2);
> ```

```java
EmployeeDao mapper = sqlSession.getMapper(EmployeeDao.class);
Page<Object> page = PageHelper.startPage(1, 2);
List<Employee> all = mapper.getAll();
for (Employee e : all) {
    System.out.println(e);
}
System.out.println("当前页码：" + page.getPageNum());
System.out.println("总记录数：" + page.getTotal());
System.out.println("每页记录数：" + page.getPageSize());
System.out.println("总页码：" + page.getPages());
sqlSession.close();
```

> 这个对象中，封装了很多我们需要的属性

```java
List<Employee> all = mapper.getAll();
PageInfo<Employee> info = new PageInfo<>(all);
for (Employee e : all) {
    System.out.println(e);
}
System.out.println("当前页码：" + info.getPageNum());
System.out.println("总记录数：" + info.getTotal());
System.out.println("每页记录数：" + info.getPageSize());
System.out.println("总页码：" + info.getPages());
sqlSession.close();
```

> 也可以用pageinfo将数据封装成对象
>
> pageinfo的好处是，能判断是否为首页，尾页等



## 批量操作

```java
SqlSession sqlSession = sqlSessionFactory.openSession(ExecutorType.BATCH);
EmployeeDao mapper = sqlSession.getMapper(EmployeeDao.class);
for (int i = 0; i < 1000 ; i++) {
    mapper.addEmp(new Employee(null,"name_" + i,i + "@qq.com",i%2));
}
sqlSession.commit();
sqlSession.close();
```

> 可以在获得sqlSession的时候，更改其运行模式为BATCH
>
> 这个的效率要比拼接Sql语句高很多

```xml
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
    <property name="configLocation" value="classpath:Mybatis/mybatis-config.xml"/>
    <property name="dataSource" ref="dataSource"/>
    <property name="mapperLocations" value="classpath:Mybatis/mapper/*.xml"/>
</bean>

<bean id="sessionTemplate" class="org.mybatis.spring.SqlSessionTemplate">
    <constructor-arg name="sqlSessionFactory" ref="sqlSessionFactory"/>
    <constructor-arg name="executorType" value="BATCH"/>
</bean>
```

> 如果是和Spring整合，在Spring配置文件中添加配置
>
> 在使用时，Autowire一个SqlSession，这个sqlSession就是批量操作的sqlSession



