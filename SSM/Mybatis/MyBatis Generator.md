# MyBatis Generator

> Mybatis官方提供的代码生成器
>
> 帮我们逆向生成代码
>
> 逆向分析数据表，自动生成JavaBean，Dao，dao.xml

```xml
<dependency>
    <groupId>org.mybatis.generator</groupId>
    <artifactId>mybatis-generator-core</artifactId>
    <version>1.4.0</version>
</dependency>

<!-- https://mvnrepository.com/artifact/org.mybatis.dynamic-sql/mybatis-dynamic-sql -->
<dependency>
    <groupId>org.mybatis.dynamic-sql</groupId>
    <artifactId>mybatis-dynamic-sql</artifactId>
    <version>1.3.0</version>
</dependency>
```

> 如果使用**MyBatis3DynamicSql**模式
>
> 生成的文件引用了mybatis-dynamic
>
> 所以要导入mybatis-dynamic-sql

## 配置

```xml
<!DOCTYPE generatorConfiguration PUBLIC
        "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">
<generatorConfiguration>
    <properties resource="jdbc.properties"/>
    <context id="dsql" targetRuntime="MyBatis3">
        <jdbcConnection driverClass="${jdbc.driver}"
                        connectionURL="${jdbc.url}"
                        userId="${jdbc.username}" password="${jdbc.password}"/>

        <javaModelGenerator targetPackage="com.augus.bean" targetProject="src/main/java"/>

        <sqlMapGenerator targetPackage="mapper" targetProject="src/main/resources"/>

        <javaClientGenerator targetPackage="com.augus.dao" targetProject="src/main/java" type="XMLMAPPER"/>

        <table tableName="t_cat" domainObjectName="Cat" />
    </context>
</generatorConfiguration>
```

> **context：**这里可以定义生成的模式，常用的有
>
> **jdbcConnection：**写数据库连接
>
> **javaModelGenerator：**将生成的Java实体类放在哪
>
> **sqlMapGenerator：**将生成的映射文件放在哪，javaClientGenerator中必须指定type="XMLMAPPER"，不然不会生成
>
> **javaClientGenerator：**将生成的Dao类放在哪
>
> **table：**将哪张表生成什么名称的实体类



## 运行

```java
public static void main(String[] args) throws Exception {
    List<String> warnings = new ArrayList<String>();
    boolean overwrite = true;
    File configFile = new File("src/main/resources/generatorConfig.xml");
    ConfigurationParser cp = new ConfigurationParser(warnings);
    Configuration config = cp.parseConfiguration(configFile);
    DefaultShellCallback callback = new DefaultShellCallback(overwrite);
    MyBatisGenerator myBatisGenerator = new MyBatisGenerator(config, callback, warnings);
    myBatisGenerator.generate(null);
}
```

> 复制粘贴



## 测试

```java
public static void main(String[] args) throws Exception {
    String path = "mybatis-config.xml";
    InputStream is = Resources.getResourceAsStream(path);
    SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(is);
    SqlSession sqlSession = sqlSessionFactory.openSession();
    CatMapper mapper = sqlSession.getMapper(CatMapper.class);
    Cat cat = mapper.selectByPrimaryKey(1);
    System.out.println(cat);
    sqlSession.close();
}
```

> 可以正常使用