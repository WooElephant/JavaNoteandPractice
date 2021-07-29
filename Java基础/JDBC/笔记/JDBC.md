# JDBC

## JDBC概述

### 数据的持久化

> - 持久化(persistence)：把数据保存到可掉电式存储设备中以供之后使用。而持久化的实现过程大多通过各种关系数据库来完成
>
> - 持久化的主要应用是将内存中的数据存储在关系型数据库中，当然也可以存储在磁盘文件、XML数据文件中

### Java中的数据存储技术

> - 在Java中，数据库存取技术可分为如下几类：
>   - JDBC直接访问数据库
>   - JDO (Java Data Object )技术
>
>   - 第三方O/R工具，如Hibernate, Mybatis 等
>
> - JDBC是java访问数据库的基石，JDO、Hibernate、MyBatis等只是更好的封装了JDBC。

### JDBC介绍

> - JDBC(Java Database Connectivity)是一个**独立于特定数据库管理系统、通用的SQL数据库存取和操作的公共接口**（一组API），定义了用来访问数据库的标准Java类库，（**java.sql,javax.sql**）使用这些类库可以以一种**标准**的方法、方便地访问数据库资源
> - JDBC为访问不同的数据库提供了一种**统一的途径**
> - JDBC的目标是使Java程序员使用JDBC可以连接任何**提供了JDBC驱动程序**的数据库系统，这样就使得程序员无需对特定的数据库系统的特点有过多的了解，从而大大简化和加快了开发过程

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\Java基础\JDBC\笔记\1555575721407.png)

> 如果没有JDBC，我们需要直接操作各个数据库
>
> 需要了解每一个数据库的相应语法和规范

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\Java基础\JDBC\笔记\1555575981203.png)

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\Java基础\JDBC\笔记\1566741692804.png)

> 有了JDBC，我们只需要学会如何操作JDBC，就可以兼容各种数据库

### JDBC体系结构

> - JDBC接口（API）包括两个层次：
>   - **面向应用的API**：Java API，抽象接口，供应用程序开发人员使用（连接数据库，执行SQL语句，获得结果）。
>   - **面向数据库的API**：Java Driver API，供开发商开发数据库驱动程序用。

### JDBC程序编写步骤

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\Java基础\JDBC\笔记\1565969323908.png)



## 获取数据库连接

### Driver

```java
Driver driver = null;

String url = null;
Properties info = null;
Connection connect = driver.connect(url, info);

System.out.println(connect);
```

> 根据API，我们通过Driver可以获取connection
>
> 在这里我们需要指定三个参数，才能获得
>
> Driver 这里要填SQL的具体实现类
>
> 我们导入MySQL的驱动

```java
Driver driver = new com.mysql.jdbc.Driver();
```

> 然后就可以导入具体的实现类，为我们导入包下的Driver类

### URL

> 就像我们使用数据库工具连接数据库
>
> 需要提供地址，这个URL就是这个地址

> 标准格式如下：
>
> jdbc:mysql://localhost:3306/dbname

### Properties

> 就像我们使用数据库工具连接数据库
>
> 这里需要填的是用户名和密码

```java
Driver driver = new com.mysql.jdbc.Driver();

String url = "jdbc:mysql://localhost:3306/test";
Properties info = new Properties();
info.setProperty("user","root");
info.setProperty("password","1234");
Connection connect = driver.connect(url, info);

System.out.println(connect);
```

> 这样我们就能成功的通过JDBC连接上数据库了

### 升级一

```java
Class aClass = Class.forName("com.mysql.jdbc.Driver");
Driver driver = (Driver) aClass.newInstance();

String url = "jdbc:mysql://localhost:3306/test";
Properties info = new Properties();
info.setProperty("user","root");
info.setProperty("password","1234");
Connection connect = driver.connect(url, info);

System.out.println(connect);
```

> 我们可以通过反射来创建Driver实现类对象
>
> 这样可以保证我们切换数据库时，代码也可以运行

### 升级二

```java
Class aClass = Class.forName("com.mysql.jdbc.Driver");
Driver driver = (Driver) aClass.newInstance();

DriverManager.registerDriver(driver);

String url = "jdbc:mysql://localhost:3306/test";
String user = "root";
String password = "1234";
Connection connection = DriverManager.getConnection(url, user, password);

System.out.println(connection);
```

> 我们可以使用Java为我们提供的驱动管理类来管理驱动
>
> 我们需要注册驱动类，然后通过驱动管理类获得连接对象

### 升级三

```java
Class.forName("com.mysql.jdbc.Driver");

String url = "jdbc:mysql://localhost:3306/test";
String user = "root";
String password = "1234";
Connection connection = DriverManager.getConnection(url, user, password);

System.out.println(connection);
```

> 我们可以省略注册的步骤
>
> 因为MySQL驱动类中有一个静态代码块
>
> 在类加载时，就帮我们在 DriverManager注册好了

### 最终版

> 一般来说，我们不喜欢这种硬编码的形式
>
> 我们应该把配置信息写入配置文件，再读出来

```java
InputStream is = ConnectionTest.class.getClassLoader().getResourceAsStream("jdbc.properties");
Properties properties = new Properties();
properties.load(is);

String user = properties.getProperty("user");
String password = properties.getProperty("password");
String url = properties.getProperty("url");
String driverClass = properties.getProperty("driverClass");

Class.forName(driverClass);
Connection connection = DriverManager.getConnection(url, user, password);

System.out.println(connection);
```



## 实现CRUD操作

> 在之前的流程中我们说过
>
> 真正帮我们执行SQL语句的是`Statement`对象
>
> 我们在真正使用中会使用`Statement`的子接口`PerparedStatement`接口
>
> 因为使用`Statement`会出现注入问题



### 增

```java
InputStream is = UpdateTest.class.getClassLoader().getResourceAsStream("jdbc.properties");
Properties properties = new Properties();
properties.load(is);
String user = properties.getProperty("user");
String password = properties.getProperty("password");
String url = properties.getProperty("url");
String driverClass = properties.getProperty("driverClass");
Class.forName(driverClass);
Connection connection = DriverManager.getConnection(url, user, password);

//预编译sql语句
String sql = "insert into customers(name,email,birth) values(?,?,?)";
PreparedStatement ps = connection.prepareStatement(sql);

//为sql语句填充占位符
ps.setString(1,"哪吒");
ps.setString(2,"nezha@gamil.com");
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
java.util.Date date = sdf.parse("1000-01-01");
ps.setDate(3,new Date(date.getTime()));

//执行操作
ps.execute();

//释放资源
ps.close();
connection.close();
```

> 预编译sql语句，使用?占位
>
> 而不是使用拼接字符串的形式
>
> 这是`PerparedStatement`和`Statement`的区别

> 填充占位符，要使用对应类型的set方法

> 因为创建连接，释放资源这些操作都是重复用到
>
> 我们将它们一起封装到一个工具类中



### 改

```java
Connection connection = JDBCUtils.getConnection();

String sql = "update customers set name = ? where id = ?";
PreparedStatement ps = connection.prepareStatement(sql);

ps.setObject(1,"莫扎特");
ps.setObject(2,18);

ps.execute();

JDBCUtils.closeResource(connection,ps);
```



### 通用增删改操作

> 我们发现增删改大部分操作都是一样的

```java
public void updateCommonTest(String sql,Object ...args) {
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    try {
        connection = JDBCUtils.getConnection();
        preparedStatement = connection.prepareStatement(sql);
        for (int i = 0; i < args.length; i++) {
            preparedStatement.setObject(i+1,args[i]);
        }
        preparedStatement.execute();
    } catch (SQLException throwables) {
        throwables.printStackTrace();
    }
    JDBCUtils.closeResource(connection,preparedStatement);
}
```

> 我们可以写一个通用增删改的方法

### 查

```java
Connection connection = JDBCUtils.getConnection();
String sql = "select id,name,email,birth from customers where id = ?";
PreparedStatement preparedStatement = connection.prepareStatement(sql);
preparedStatement.setObject(1,1);

ResultSet resultSet = preparedStatement.executeQuery();
if (resultSet.next()){
    int id = resultSet.getInt(1);
    String name = resultSet.getString(2);
    String email = resultSet.getString(3);
    Date birth = resultSet.getDate(4);

    Customer customer = new Customer(id, name, email, birth);
    System.out.println(customer);
}

JDBCUtils.closeResource(connection,preparedStatement,resultSet);
```

> 第七行resultSet.next()
>
> 这里的next方法与Java中的迭代器略有不同
>
> Java中的迭代器有两个方法：
>
> * hasnext：只做判断，不做指针移位
>
> * next：将指针移动到下一位，并返回下一个对象
>
> 这里的next方法的作用是：判断有没有下一个，如果有自动移动指针到下一个，如果没有则不移动指针

```java
public class Customer {
    private int id;
    private String name;
    private String email;
    private Date birth;
    ...
```

> 我们基于ORM思想，将表创建为一个对象来保存和操作
>
> 这里的属性必须与SQL表中相对应

> **ORM：（Object Relational Mapping）对象关系映射**
>
> 一个数据表，对应一个Java类
>
> 表中一条数据，对应Java一个对象
>
> 表中一个字段，对应Java类中一个属性
>
> 互相映射

### 通用查询

```java
public Customer queryForCustomer(String sql,Object ...args) throws Exception {
    Connection connection = JDBCUtils.getConnection();
    PreparedStatement preparedStatement = connection.prepareStatement(sql);
    for (int i = 0; i < args.length; i++) {
        preparedStatement.setObject(i+1,args[i]);
    }

    ResultSet resultSet = preparedStatement.executeQuery();
    ResultSetMetaData metaData = resultSet.getMetaData();
    int columnCount = metaData.getColumnCount();
    if (resultSet.next()){
        Customer customer = new Customer();
        for (int i = 0; i < columnCount; i++) {
            Object object = resultSet.getObject(i + 1);
            String columnName = metaData.getColumnName(i + 1);
            Field field = Customer.class.getDeclaredField(columnName);
            field.setAccessible(true);
            field.set(customer,object);
        }
        return customer;
    }
    JDBCUtils.closeResource(connection,preparedStatement,resultSet);
    return null;
}
```

> 这是针对Customers表的通用查询

> ResultSetMetaData metaData = resultSet.getMetaData();
>
> 第9行中，我们需要拿到总列数，才能知道要循环多少次为实体赋值
>
> 我们使用getMetaData()方法，获取resultSet的元数据

> String columnName = metaData.getColumnName(i + 1);
>
> 第15行中，我们需要知道取到的当前内容所对应的列名叫什么
>
> 不然我们不知道该调用什么set方法来赋值

```java
public Order queryForOrder(String sql, Object ...args) throws Exception {
    Connection connection = JDBCUtils.getConnection();
    PreparedStatement preparedStatement = connection.prepareStatement(sql);
    for (int i = 0; i < args.length; i++) {
        preparedStatement.setObject(i+1,args[i]);
    }

    ResultSet resultSet = preparedStatement.executeQuery();
    ResultSetMetaData metaData = resultSet.getMetaData();
    int columnCount = metaData.getColumnCount();
    if (resultSet.next()){
        Order order = new Order();
        for (int i = 0; i < columnCount; i++) {
            Object object = resultSet.getObject(i + 1);
            String columnName = metaData.getColumnName(i + 1);
            Field field = Customer.class.getDeclaredField(columnName);
            field.setAccessible(true);
            field.set(order,object);
        }
        return order;
    }
    JDBCUtils.closeResource(connection,preparedStatement,resultSet);
    return null;
}

public class Order {
    private int id;
    private String name;
    private Date data;
...
```

> 再来看一个案例，因为我们实体类中的字段名与SQL中不同
>
> 通过反射赋值，就会显示没有找到对应字段
>
> 解决方案很容易想到，就是给结果集起别名
>
> 具体操作如下

```java
public Order queryForOrder(String sql, Object ...args) throws Exception {
    Connection connection = JDBCUtils.getConnection();
    PreparedStatement preparedStatement = connection.prepareStatement(sql);
    for (int i = 0; i < args.length; i++) {
        preparedStatement.setObject(i+1,args[i]);
    }

    ResultSet resultSet = preparedStatement.executeQuery();
    ResultSetMetaData metaData = resultSet.getMetaData();
    int columnCount = metaData.getColumnCount();
    if (resultSet.next()){
        Order order = new Order();
        for (int i = 0; i < columnCount; i++) {
            Object object = resultSet.getObject(i + 1);
            String columnName = metaData.getColumnLabel(i + 1);
            Field field = Customer.class.getDeclaredField(columnName);
            field.setAccessible(true);
            field.set(order,object);
        }
        return order;
    }
    JDBCUtils.closeResource(connection,preparedStatement,resultSet);
    return null;
}
```

> String columnName = metaData.getColumnLabel(i + 1);
>
> 第15行中，我们将`getColumnName`改为了`getColumnLabel`
>
> 这样就不会获取列名，而是结果集的标签名
>
> 如果没有设置别名，标签名就是列名

> 上述两个案例都是针对特定表的查询操作
>
> 我们现在着手做一个真正通用的查询方法

```java
public <T> T getInstance(Class<T> clazz,String sql, Object... args) throws Exception {
    Connection connection = JDBCUtils.getConnection();
    PreparedStatement preparedStatement = connection.prepareStatement(sql);
    for (int i = 0; i < args.length; i++) {
        preparedStatement.setObject(i + 1, args[i]);
    }

    ResultSet resultSet = preparedStatement.executeQuery();
    ResultSetMetaData metaData = resultSet.getMetaData();
    int columnCount = metaData.getColumnCount();
    if (resultSet.next()) {
        T t = clazz.newInstance();
        for (int i = 0; i < columnCount; i++) {
            Object columnValue = resultSet.getObject(i + 1);
            String columnName = metaData.getColumnLabel(i + 1);
            Field field = clazz.getDeclaredField(columnName);
            field.setAccessible(true);
            field.set(t, columnValue);
        }
        return t;
    }
    JDBCUtils.closeResource(connection, preparedStatement, resultSet);
    return null;
}
```

> 使用泛型将我们写的类全部替换掉就可以了
>
> 这是获取一个对象的方法

```java
public <T> List<T> getList(Class<T> clazz, String sql, Object... args) throws Exception {
    Connection connection = JDBCUtils.getConnection();
    PreparedStatement preparedStatement = connection.prepareStatement(sql);
    for (int i = 0; i < args.length; i++) {
        preparedStatement.setObject(i + 1, args[i]);
    }

    ResultSet resultSet = preparedStatement.executeQuery();
    ResultSetMetaData metaData = resultSet.getMetaData();
    int columnCount = metaData.getColumnCount();

    List<T> list = new ArrayList();
    while (resultSet.next()) {
        T t = clazz.newInstance();
        for (int i = 0; i < columnCount; i++) {
            Object columnValue = resultSet.getObject(i + 1);
            String columnName = metaData.getColumnLabel(i + 1);
            Field field = clazz.getDeclaredField(columnName);
            field.setAccessible(true);
            field.set(t, columnValue);
        }
        list.add(t);
    }
    JDBCUtils.closeResource(connection, preparedStatement, resultSet);
    return list;
}
```

> 这是获取不限个数的通用方法



## 操作BLOB类型字段

### MySQL BLOB类型

> - MySQL中，BLOB是一个二进制大型对象，是一个可以存储大量数据的容器，它能容纳不同大小的数据
> - 插入BLOB类型的数据必须使用PreparedStatement，因为BLOB类型的数据无法使用字符串拼接写的
>
> - MySQL的四种BLOB类型(除了在存储的最大信息量上不同外，他们是等同的)

|    类型    |     大小     |
| :--------: | :----------: |
|  TinyBlob  | 最大 255字节 |
|    Blob    |   最大 65k   |
| MediumBlob |   最大 16M   |
|  LongBlob  |   最大 4G    |

### 添加Blob数据

```java
Connection connection = JDBCUtils.getConnection();
String sql = "insert into customers (name,email,birth,photo) values (?,?,?,?)";
PreparedStatement preparedStatement = connection.prepareStatement(sql);
preparedStatement.setObject(1,"张三");
preparedStatement.setObject(2,"zhangsan@qq.com");
preparedStatement.setObject(3,"1992-09-08");

FileInputStream fis = new FileInputStream("D:\\123.png");
preparedStatement.setBlob(4,fis);

preparedStatement.execute();
JDBCUtils.closeResource(connection,preparedStatement);
```

> 我们使用preparedStatement.setBlob(4,fis);
>
> 为Blob传入一个输入流即可

### 读取Blob数据

```java
public void testQuery() throws Exception{
    Connection connection = JDBCUtils.getConnection();
    String sql = "select id,name,email,birth,photo from customers where id = ?";
    PreparedStatement preparedStatement = connection.prepareStatement(sql);
    preparedStatement.setObject(1,21);
    ResultSet resultSet = preparedStatement.executeQuery();
    if (resultSet.next()){
        int id = resultSet.getInt(1);
        String name = (String) resultSet.getObject(2);
        String email = (String) resultSet.getObject(3);
        Date birth = (Date) resultSet.getObject(4);
        Customer customer = new Customer(id, name, email, birth);
        System.out.println(customer);

        Blob photo = resultSet.getBlob(5);
        InputStream is = photo.getBinaryStream();
        FileOutputStream fos = new FileOutputStream("d:\\222.png");
        byte[] buff = new byte[1024];
        int dataLen = 0;
        while ((dataLen = is.read(buff)) != -1){
            fos.write(buff,0,dataLen);
            fos.flush();
        }
        fos.close();
        is.close();

        JDBCUtils.closeResource(connection,preparedStatement,resultSet);
    }
}
```

### 特殊情况说明

> 虽然MediumBlob的大小限制是16M
>
> 我们往数据库中写入大于1M的数据会报错

> xxx too large，那么在mysql的安装目录下，找my.ini文件加上如下的配置参数：
>
>  **max_allowed_packet=16M**
>
> 同时注意：修改了my.ini文件之后，需要重新启动mysql服务



## 批量插入

```java
public void insertStatement() throws Exception{
    Connection connection = JDBCUtils.getConnection();
    Statement statement = connection.createStatement();
    for (int i = 0; i < 20000; i++) {
        String sql = "insert into goods (name) values ('name_"+i+"')";
        statement.execute(sql);
    }
    JDBCUtils.closeResource(connection,statement);
}
```

> 我们可以用`statement`来实现

```java
public void insert01() throws Exception{
    Connection connection = JDBCUtils.getConnection();
    String sql = "insert into goods (name) values (?)";
    PreparedStatement preparedStatement = connection.prepareStatement(sql);
    for (int i = 0; i < 20000; i++) {
        preparedStatement.setObject(1,"name_"+i);
        preparedStatement.execute();
    }

    JDBCUtils.closeResource(connection,preparedStatement);
}
```

> 也可以用`statement`来实现
>
> 明显可以看出，`statement`每次循环就需要新建一个字符串，又耗时，又耗时间，而且还需要重新校验

> `prepareStatement`插入2万条数据耗时：74秒
>
> `statement`插入2万条数据耗时：74秒
>
> 按理来说`prepareStatement`应该快，但我也不知道为什么这样

### 升级一

```java
public void insert02() throws Exception{
    long start = System.currentTimeMillis();
    Connection connection = JDBCUtils.getConnection();
    String sql = "insert into goods (name) values (?)";
    PreparedStatement preparedStatement = connection.prepareStatement(sql);
    for (int i = 0; i < 20000; i++) {
        preparedStatement.setObject(1,"name_"+i);
        preparedStatement.addBatch();
        if ( i % 500 == 0 ){
            preparedStatement.executeBatch();
            preparedStatement.clearBatch();
        }
    }
    long end = System.currentTimeMillis();

    System.out.println(end-start);

    JDBCUtils.closeResource(connection,preparedStatement);
}
```

> 我们读一批，再存一批
>
> 减少磁盘IO

> mysql服务器默认是关闭批处理的
>
> 我们需要通过一个参数，让mysql开启批处理的支持
>
> rewriteBatchedStatements=true 写在配置文件的url后面

> 一些老版本的SQL驱动也不支持批处理

> 通过此方法运行，我们发现运行时间奇迹的变成了
>
> **0.7秒！！！**
>
> 我们将数据量改为100万，为了使后续优化效果明显
>
> 再次执行用时14秒

### 终极方案

```java
public void insert03() throws Exception{
    long start = System.currentTimeMillis();
    Connection connection = JDBCUtils.getConnection();
    connection.setAutoCommit(false);
    String sql = "insert into goods (name) values (?)";
    PreparedStatement preparedStatement = connection.prepareStatement(sql);
    for (int i = 0; i < 1000000; i++) {
        preparedStatement.setObject(1,"name_"+i);
        preparedStatement.addBatch();
        if ( i % 500 == 0 ){
            preparedStatement.executeBatch();
            preparedStatement.clearBatch();
        }
    }
    connection.commit();
    long end = System.currentTimeMillis();

    System.out.println(end-start);

    JDBCUtils.closeResource(connection,preparedStatement);
}
```

> 我们可以将提交设为不自动提交
>
> 全部插入完一次性提交
>
> 100万条用时：4秒
>
> 再次测试2万条用时：0.5秒是`statement`的150倍



## 事务操作

```java
public int updateCommonTest(String sql,Object ...args) {
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    try {
        connection = JDBCUtils.getConnection();
        preparedStatement = connection.prepareStatement(sql);
        for (int i = 0; i < args.length; i++) {
            preparedStatement.setObject(i+1,args[i]);
        }
        return preparedStatement.executeUpdate();
    } catch (SQLException throwables) {
        throwables.printStackTrace();
    }
    JDBCUtils.closeResource(connection,preparedStatement);
    return 0;
}
```

> 这是我们之前做的通用增删改方法
>
> 考虑到事务的操作，我们现在需要对它进行改造

```java
public int updateCommonTest2(Connection connection,String sql,Object ...args) {
    PreparedStatement preparedStatement = null;
    try {
        preparedStatement = connection.prepareStatement(sql);
        for (int i = 0; i < args.length; i++) {
            preparedStatement.setObject(i+1,args[i]);
        }
        return preparedStatement.executeUpdate();
    } catch (SQLException throwables) {
        throwables.printStackTrace();
    }
    JDBCUtils.closeResource(null,preparedStatement);
    return 0;
}
```

> 为了使事务统一，我们不能在每次操作中进行连接，关闭连接操作
>
> 让调用者创建连接，把连接传给我们执行

```java
public void test2() {
    Connection connection = null;
    try {
        connection = JDBCUtils.getConnection();
        connection.setAutoCommit(false);
        String sql1 = "update user_table set balance = balance - 100 where user = ?";
        updateCommonTest2(connection,sql1,"AA");
        //int a = 10 / 0;
        String sql2 = "update user_table set balance = balance + 100 where user = ?";
        updateCommonTest2(connection,sql2,"BB");
        System.out.println("转账成功");
        connection.commit();
    } catch (Exception throwables) {
        throwables.printStackTrace();
        try {
            connection.rollback();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    } finally {
        JDBCUtils.closeResource(connection,null);
    }
}
```

> 这是调用端的写法

> 注意
>
> 如果程序完成了，没有关闭connection，我们需要为其恢复自动提交状态
>
> 尤其是在使用数据库连接池时，我们不会关闭connection，而是把它放回池中
>
> 执行close方法前，建议恢复自动提交状态



## DAO

> 我们将通用的增删改查封装成一个BaseDao
>
> 再对应每一个实体生成Dao接口

```java
public interface CustomerDao {

    void insert(Connection connection, Customer customer);

    void deleteById(Connection connection,int id);

    void update(Connection connection,Customer customer);

    Customer getById(Connection connection,int id);

    List<Customer> getAll(Connection connection);

    long getCount(Connection connection);

    Date getMaxBirth(Connection connection);

}
```

> 然后为此实体提供具体的实现类Dao

```java
public class CustomerDaoImpl extends BaseDao implements CustomerDao {

    @Override
    public void insert(Connection connection, Customer customer) {
        String sql = "insert into customers (name,email,birth) values (?,?,?)";
        update(connection,sql,customer.getName(),customer.getEmail(),customer.getBirth());
    }

    @Override
    public void deleteById(Connection connection, int id) {
        String sql = "delete from customers where id = ?";
        update(connection,sql,id);
    }

    @Override
    public void update(Connection connection, Customer customer) {
        String sql = "update customers set name=?,email=?,birth=? where id = ?";
        update(connection,sql,customer.getName(),customer.getEmail(),customer.getBirth(),customer.getId());
    }

    @Override
    public Customer getById(Connection connection, int id) {
        String sql = "select id,name,email,birth from customers where id = ?";
        Customer customer = getInstance(connection, Customer.class, sql, id);
        return customer;
    }

    @Override
    public List<Customer> getAll(Connection connection) {
        String sql = "select id,name,email,birth from customers";
        List<Customer> list = getList(connection, Customer.class, sql);
        return null;
    }

    @Override
    public long getCount(Connection connection) {
        String sql = "select count(*) from customers";
        return getValue(connection,sql);
    }

    @Override
    public Date getMaxBirth(Connection connection) {
        String sql = "select max(birth) from customers";
        return getValue(connection,sql);
    }
}
```

### 升级

> 我们发现DAO已经具体到实现类了，没有必要在参数中再填写Customer.class了，有些多余

```java
public class BaseDao<T> {

    private Class<T> clazz = null;

    {
        Type genericSuperclass = this.getClass().getGenericSuperclass();
        ParameterizedType paramType = (ParameterizedType) genericSuperclass;
        Type[] actualTypeArguments = paramType.getActualTypeArguments();
        clazz = (Class<T>) actualTypeArguments[0];
    }
    
    ...
```

> 我们在BaseDao开头添加这样的内容，在初始化的时候为clazz赋值
>
> Type genericSuperclass = this.getClass().getGenericSuperclass();获取实现类带泛型的父类
>
> ParameterizedType paramType = (ParameterizedType) genericSuperclass;
>
> Type[] actualTypeArguments = paramType.getActualTypeArguments();获取父类泛型的参数



## 数据库连接池

> - 普通的JDBC数据库连接使用 DriverManager 来获取，每次向数据库建立连接的时候都要将 Connection 加载到内存中，再验证用户名和密码(得花费0.05s～1s的时间)。需要数据库连接的时候，就向数据库要求一个，执行完成后再断开连接。这样的方式将会消耗大量的资源和时间。**数据库的连接资源并没有得到很好的重复利用。**若同时有几百人甚至几千人在线，频繁的进行数据库连接操作将占用很多的系统资源，严重的甚至会造成服务器的崩溃
> - **对于每一次数据库连接，使用完后都得断开。**否则，如果程序出现异常而未能关闭，将会导致数据库系统中的内存泄漏，最终将导致重启数据库（回忆：何为Java的内存泄漏？）
> - **这种开发不能控制被创建的连接对象数**，系统资源会被毫无顾及的分配出去，如连接过多，也可能导致内存泄漏，服务器崩溃

### 数据库连接池技术

> - **数据库连接池的基本思想**：就是为数据库连接建立一个“缓冲池”。预先在缓冲池中放入一定数量的连接，当需要建立数据库连接时，只需从“缓冲池”中取出一个，使用完毕之后再放回去
>
> - **数据库连接池**负责分配、管理和释放数据库连接，它**允许应用程序重复使用一个现有的数据库连接，而不是重新建立一个**
> - 数据库连接池在初始化时将创建一定数量的数据库连接放到连接池中，这些数据库连接的数量是由**最小数据库连接数来设定**的。无论这些数据库连接是否被使用，连接池都将一直保证至少拥有这么多的连接数量。连接池的**最大数据库连接数量**限定了这个连接池能占有的最大连接数，当应用程序向连接池请求的连接数超过最大连接数量时，这些请求将被加入到等待队列中

### 多种开源的数据库连接池

> - **DBCP** 是Apache提供的数据库连接池。tomcat 服务器自带dbcp数据库连接池。**速度相对c3p0较快**，但因自身存在BUG，Hibernate3已不再提供支持。
> - **C3P0** 是一个开源组织提供的一个数据库连接池，**速度相对较慢，稳定性还可以。**hibernate官方推荐使用
> - **Proxool** 是sourceforge下的一个开源项目数据库连接池，有监控连接池状态的功能，**稳定性较c3p0差一点**
> - **BoneCP** 是一个开源组织提供的数据库连接池，速度快
> - **Druid** 是阿里提供的数据库连接池，据说是集DBCP 、C3P0 、Proxool 优点于一身的数据库连接池，但是速度不确定是否有BoneCP快

> - DataSource 通常被称为数据源，它包含连接池和连接池管理两个部分，习惯上也经常把 DataSource 称为连接池
> - **DataSource用来取代DriverManager来获取Connection，获取速度快，同时可以大幅度提高数据库访问速度。**

### C3P0

```java
ComboPooledDataSource cpds = new ComboPooledDataSource();
cpds.setDriverClass("com.mysql.jdbc.Driver");
cpds.setJdbcUrl("jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8");
cpds.setUser("root");
cpds.setPassword("1234");

Connection connection = cpds.getConnection();
System.out.println(connection);
```

> 使用此方法获得连接对象
>
> C3P0也提供了多种配置文件的选择

### DBCP

```java
BasicDataSource dataSource = new BasicDataSource();
dataSource.setDriverClassName("com.mysql.jdbc.Driver");
dataSource.setUrl("jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8");
dataSource.setUsername("root");
dataSource.setPassword("1234");
Connection connection = dataSource.getConnection();
System.out.println(connection);
```

> DBCP也可以通过配置文件来设置属性

### Druid（重点）

```java
DruidDataSource dataSource = new DruidDataSource();
dataSource.setUrl();
dataSource.setDriver();
dataSource.setUsername();
dataSource.setPassword();
DruidPooledConnection connection = dataSource.getConnection();
```

> 德鲁伊也可以直接通过写死配置来获得连接，但不推荐这么做

```properties
url=jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true
username=root
password=1234
driverClassName=com.mysql.jdbc.Driver
```

```java
Properties properties = new Properties();
InputStream is = ClassLoader.getSystemClassLoader().getResourceAsStream("druid.properties");
properties.load(is);
DataSource dataSource = DruidDataSourceFactory.createDataSource(properties);
Connection connection = dataSource.getConnection();
System.out.println(connection);
```

> 推荐使用配置文件来配置连接池



## Apache-DBUtils

### QueryRunner

```java
QueryRunner qr = new QueryRunner();
Connection connection = JDBCUtils.getDruidConnection();
String sql = "insert into customers (name,email,birth) values (?,?,?)";
qr.update(connection, sql, "蔡徐坤", "caixukun@qq.com", "1997-09-08");
JDBCUtils.closeResource(connection,null);
```

> 其实它封装的底层跟我们自己写的几乎一样

```java
QueryRunner qr = new QueryRunner();
Connection connection = JDBCUtils.getDruidConnection();
String sql = "select id,name,email,birth from customers where id = ?";
BeanHandler<Customer> handler = new BeanHandler(Customer.class);
Customer customer = qr.query(connection, sql, handler, 22);
System.out.println(customer);
JDBCUtils.closeResource(connection,null);
```

> BeanHandler：是ResultSetHandler接口的实现类，用于封装表中的一条记录

```java
QueryRunner qr = new QueryRunner();
Connection connection = JDBCUtils.getDruidConnection();
String sql = "select id,name,email,birth from customers where id < ?";
BeanListHandler<Customer> handler = new BeanListHandler(Customer.class);
List<Customer> list = qr.query(connection, sql, handler, 22);
list.forEach(System.out::println);
JDBCUtils.closeResource(connection,null);
```

> BeanListHandler：是ResultSetHandler接口的实现类，用于封装表中多条记录的集合

```java
QueryRunner qr = new QueryRunner();
Connection connection = JDBCUtils.getDruidConnection();
String sql = "select id,name,email,birth from customers where id = ?";
MapHandler handler = new MapHandler();
Map<String, Object> map = qr.query(connection, sql, handler, 22);
System.out.println(map);
```

> MapHandler：是ResultSetHandler接口的实现类，对应表中一条数据，将字段值作为Map中的KV

```java
QueryRunner qr = new QueryRunner();
Connection connection = JDBCUtils.getDruidConnection();
String sql = "select count(*) from customers";
ScalarHandler scalarHandler = new ScalarHandler();
long query = (long) qr.query(connection, sql, scalarHandler);
System.out.println(query);
```

> ScalarHandler用于查询一些特殊值

> DBUtils里定义了很多类似的Handler用于不同的数据结构
>
> 用法都很相似

```java
QueryRunner qr = new QueryRunner();
Connection connection = JDBCUtils.getDruidConnection();
String sql = "select id,name,email,birth from customers where id = ?";
ResultSetHandler<Customer> handler = new ResultSetHandler<Customer>() {
    @Override
    public Customer handle(ResultSet resultSet) throws SQLException {
        if (resultSet.next()){
            int id = resultSet.getInt("id");
            String name = resultSet.getString("name");
            String email = resultSet.getString("email");
            Date birth = resultSet.getDate("birth");
            return new Customer(id,name,email,birth);
        }
        return null;
    }
};
Customer customer = qr.query(connection, sql, handler, 22);
System.out.println(customer);
```

> 我们也可以直接以匿名内部类自己写一个Handler

```java
try {
    DbUtils.close(conn);
    DbUtils.close(statement);
    DbUtils.close(resultSet);
} catch (SQLException throwables) {
    throwables.printStackTrace();
}
```

> 我们也可以直接调用DBUtils为我们包装好的close







