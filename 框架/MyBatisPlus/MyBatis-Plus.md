# MyBatis-Plus

> MyBatis-Plus是MyBatis的一个增强工具

## 插件

> MyBatis-Plus提供了IDEA插件
>
> MyBatisX



## 依赖

```xml
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-boot-starter</artifactId>
    <version>3.4.3.1</version>
</dependency>
```

> 此依赖会自动引入Mybatis



## Hello World

```java
public interface EmployeeMapper extends BaseMapper<Employee> {
}
```

> MybatisPlus中提供了默认的实现
>
> 只需要继承BaseMapper

> MybatisPlus会自动将封装目标类名当做表名
>
> 如果我们两个名称不一致，在类名上加入注解

```java
@TableName("tbl_employee")
public class Employee {
    private Integer id;
    private String lastName;
    private String email;
    private Integer gender;
    private Integer age;
}
```

```java
@Autowired
EmployeeMapper employeeMapper;

@Test
void contextLoads() {
    Employee employee = employeeMapper.selectById(1);
    System.out.println(employee);
}
```

> 直接使用没有问题

> 如果想要看到执行的SQL语句

```yaml
logging:
  level:
    root: info
    com.augus: debug
```

> 在配置文件中改变日志级别即可

> **如果表中字段名与类中属性不一致可以使用@TableField注解**
>
> MybatisPlus默认属性为id的是主键，如果自增列没有指定值
>
> MybatisPlus会默认生成一个随机数
>
> 我们可以在属性上标注，它是自增的，不需要为其生成随机数
>
> **使用@TableId(value = "id",type = IdType.AUTO)注解**

```
@TableName("tbl_employee")
public class Employee {
    @TableId(value = "id",type = IdType.AUTO)
    private Integer id;
    @TableField("l_name")
    private String lastName;
    private String email;
    private Integer gender;
    private Integer age;
}
```

> **MybatisPlus主键是自动回填的**



### 指定条件查找

```java
@Test
void contextLoads() {
    Map<String,Object> map = new HashMap<>();
    map.put("gender",1);
    List<Employee> employees = employeeMapper.selectByMap(map);
    for (Employee employee : employees) {
        System.out.println(employee);
    }
}
```



### 表中不存在的字段

```java
@TableName("tbl_employee")
public class Employee {
    @TableId(value = "id",type = IdType.AUTO)
    private Integer id;
    private String lastName;
    private String email;
    private Integer gender;
    private Integer age;
    private String genderName;  //不存在这个列
}

//我们不需要从数据库中获取值，我们自己定义了设置的逻辑
public String getGenderName() {
    if (gender == 0){
        return  "女";
    }else {
        return  "男";
    }
}
```

> 这个时候要给不存在的字段上添加**@TableField(exist = false)注解**



## service层

```java
public interface EmployeeService extends IService<Employee> {
}
```

> 写一个service接口，继承IService

```java
public class EmployeeServiceImpl extends ServiceImpl<EmployeeMapper, Employee> implements EmployeeService {
}
```

> 再写这个接口的实现类，实现了这个接口
>
> 并且继承ServiceImpl，第一个泛型是对应的mapper，第二个是实体类

```java
@Autowired
EmployeeService employeeService;

@Test
void contextLoads() {
    Employee employee = employeeService.getById(1);
    System.out.println(employee);
}
```

> 然后就可以直接使用



### 默认方法名

> save	插入
>
> saveOrUpdate	插入或修改
>
> remove	删除
>
> update	更新
>
> get	查询
>
> list	查多个
>
> page	分页查询
>
> count	个数



## 分页查询

### 配置

```java
@Bean
public MybatisPlusInterceptor mybatisPlusInterceptor() {
    MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
    interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.H2));
    return interceptor;
}
```

> 将配置写在配置类中
>
> 这是官网的模板
>
> 注意 DbType.H2 根据自己的数据库类型进行更改 DbType.MYSQL



### 使用

```java
IPage<Employee> iPage = new Page<>(1,2);
IPage<Employee> page = employeeService.page(iPage);
List<Employee> emps = page.getRecords();
System.out.println(page.getPages());
```

> 然后就可以使用了



### XML如何实现分页

> 有些很复杂的sql语句还是需要XML来定义

```java
public interface EmployeeMapper extends BaseMapper<Employee> {
    IPage<Employee> getByGender(IPage page,Integer gender);
}
```

> 在mapper接口上，参数位置传递IPage，返回值为IPage即可实现

> 注意，默认MybatisPlus会将mapper目录下的xml全部扫描，不需要额外配置

```yaml
mybatis-plus:
  mapper-locations: 
```

> 或者使用此配置，手动指定



## 条件构造器Wrapper

```java
QueryWrapper<Employee> wrapper = new QueryWrapper<>();
wrapper.select("last_name","age").eq("last_name","Tom");
List<Employee> list = employeeService.list(wrapper);
for (Employee employee : list) {
    System.out.println(employee);
}
```

> https://mp.baomidou.com/guide/wrapper.html
>
> 更多使用方法可以参照官网



## 主键生成策略

```yaml
mybatis-plus:
  global-config:
    db-config:
      id-type: auto
```

> 也可以通过配置文件改变全局配置



## 逻辑删除

> 通常会在表中添加一个逻辑删除字段如enable或is_delete
>
> 当用户执行删除，并不会执行delete，而是将该字段的值修改

> 在实体类中和表中添加逻辑删除字段

```java
public class Employee {
    private Integer id;
    private String lastName;
    private String email;
    private Integer gender;
    private Integer age;
    @TableLogic(value = "1",delval = "0")
    private Integer enable;
}
```

```java
employeeService.removeById(1);
```

> 执行删除操作，可以发现，只是将enable的值改变了

```java
List<Employee> list = employeeService.list();
for (Employee employee : list) {
    System.out.println(employee);
}
```

> 运行查询，他会自动帮我们判断，查不出来enable是0的数据了

```yaml
mybatis-plus:
  global-config:
    db-config:
      logic-delete-field: enable
      logic-delete-value: 0
      logic-not-delete-value: 1
```

> 也可以在配置文件中进行全局配置



## 自动填充

> 比如表中有创建时间，修改时间，这些字段
>
> 我们需要自动填充

```java
@TableName("tbl_employee")
public class Employee {
    private Integer id;
    private String lastName;
    private String email;
    private Integer gender;
    private Integer age;
    @TableLogic(value = "1",delval = "0")
    private Integer enable;

    @TableField(fill = FieldFill.INSERT)
    private Date createDate;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private Date modifyDate;
}
```

> 先在字段上添加注解，注明何时需要自动填充

```java
@Component
public class MyMetaObjectHandler implements MetaObjectHandler {

    @Override
    public void insertFill(MetaObject metaObject) {
        this.setFieldValByName("createDate",new Date(),metaObject);
        this.setFieldValByName("modifyDate",new Date(),metaObject);
    }

    @Override
    public void updateFill(MetaObject metaObject) {
        this.setFieldValByName("modifyDate",new Date(),metaObject);
    }
}
```

> 这样在我们操作的时候，就会将当前时间填入相应的字段了



## 执行SQL分析打印

### 依赖

```xml
<dependency>
    <groupId>p6spy</groupId>
    <artifactId>p6spy</artifactId>
    <version>3.9.1</version>
</dependency>
```

### 配置文件

```yaml
spring:
  datasource:
    username: root
    password: 1234
#    url: jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8
#    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:p6spy:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8
    driver-class-name: com.p6spy.engine.spy.P6SpyDriver
    type: com.alibaba.druid.pool.DruidDataSource
```

> 需要更改url和driver

```properties
#3.2.1以上使用
modulelist=com.baomidou.mybatisplus.extension.p6spy.MybatisPlusLogFactory,com.p6spy.engine.outage.P6OutageFactory
#3.2.1以下使用或者不配置
#modulelist=com.p6spy.engine.logging.P6LogFactory,com.p6spy.engine.outage.P6OutageFactory
# 自定义日志打印
logMessageFormat=com.baomidou.mybatisplus.extension.p6spy.P6SpyLogger
#日志输出到控制台
appender=com.baomidou.mybatisplus.extension.p6spy.StdoutLogger
# 使用日志系统记录 sql
#appender=com.p6spy.engine.spy.appender.Slf4JLogger
# 设置 p6spy driver 代理
deregisterdrivers=true
# 取消JDBC URL前缀
useprefix=true
# 配置记录 Log 例外,可去掉的结果集有error,info,batch,debug,statement,commit,rollback,result,resultset.
excludecategories=info,debug,result,commit,resultset
# 日期格式
dateformat=yyyy-MM-dd HH:mm:ss
# 实际驱动可多个
#driverlist=org.h2.Driver
# 是否开启慢SQL记录
outagedetection=true
# 慢SQL记录标准 2 秒
outagedetectioninterval=2
```

> 新建名为spy.properties 配置文件



## 乐观锁

> 在表中和实体类中加入字段如version
>
> 并标注@Version注解

```java
@Version
private Integer version;
```

```java
@Bean
public MybatisPlusInterceptor mybatisPlusInterceptor() {
    MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
    interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.MYSQL));
    interceptor.addInnerInterceptor(new OptimisticLockerInnerInterceptor());
    return interceptor;
}
```

> 在MybatisPlusInterceptor中，注册一个OptimisticLockerInnerInterceptor插件

```java
Employee e = employeeService.getById(2);
Employee e2 = employeeService.getById(2);
e.setAge(100);
e2.setAge(80);
System.out.println(employeeService.updateById(e));
System.out.println(employeeService.updateById(e2));
```

> 这样第二次更新就会报错



## 代码生成器

### 依赖

```xml
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-generator</artifactId>
    <version>3.4.1</version>
</dependency>
<dependency>
    <groupId>org.apache.velocity</groupId>
    <artifactId>velocity-engine-core</artifactId>
    <version>2.2</version>
</dependency>
```

### 配置

```java
package com.augus.mybatisplusgenerator;

import com.baomidou.mybatisplus.core.exceptions.MybatisPlusException;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.generator.AutoGenerator;
import com.baomidou.mybatisplus.generator.config.DataSourceConfig;
import com.baomidou.mybatisplus.generator.config.GlobalConfig;
import com.baomidou.mybatisplus.generator.config.PackageConfig;
import com.baomidou.mybatisplus.generator.config.StrategyConfig;
import com.baomidou.mybatisplus.generator.config.po.LikeTable;
import com.baomidou.mybatisplus.generator.config.rules.DateType;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;

import java.util.Scanner;

public class GeneratorApp {

    public static void main(String[] args) {
        //代码生成器
        AutoGenerator mpg = new AutoGenerator();

        // 全局配置
        GlobalConfig gc = new GlobalConfig();
        //获得当前项目路径
        String projectPath = System.getProperty("user.dir");
        //设置生成路径
        gc.setOutputDir(projectPath + "/src/main/java");
        //作者，最终会展示在类上面注释中
        gc.setAuthor("augus");
        //代码生成后，是否要打开文件夹
        gc.setOpen(false);
        //生成Swagger2注解
        gc.setSwagger2(true);
        //生成基础mapper.xml，会映射所有的字段
        gc.setBaseResultMap(true);
        //再次生成是覆盖还是累加
        gc.setFileOverride(true);
        //设置业务逻辑类名称，%s代表表名
        gc.setServiceName("%sService");
        gc.setServiceImplName("%sServiceImpl");

        //将全局配置设置到生成器中
        mpg.setGlobalConfig(gc);


        // 数据源配置
        DataSourceConfig dsc = new DataSourceConfig();
        dsc.setUrl("jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8");
        // dsc.setSchemaName("public");
        dsc.setDriverName("com.mysql.cj.jdbc.Driver");
        dsc.setUsername("root");
        dsc.setPassword("1234");
        mpg.setDataSource(dsc);


        // 包配置
        PackageConfig pc = new PackageConfig();
        //模块名
        //pc.setModuleName(scanner("模块名"));
        //包名
        pc.setParent("com.augus.mybatisplusgenerator");
        //完整的包名就会是com.augus.mybatisplusgenerator.模块名
        mpg.setPackageInfo(pc);


        // 策略配置
        StrategyConfig strategy = new StrategyConfig();
        //表名生成策略：下划线转驼峰
        strategy.setNaming(NamingStrategy.underline_to_camel);
        //列名生成策略：下划线转驼峰
        strategy.setColumnNaming(NamingStrategy.underline_to_camel);
        //strategy.setSuperEntityClass("你自己的父类实体,没有就不用设置!");
        //实体类是不是支持lombok
        strategy.setEntityLombokModel(true);
        //controller是不是REST风格
        strategy.setRestControllerStyle(true);
        // 公共父类
        //strategy.setSuperControllerClass("你自己的父类控制器,没有就不用设置!");
        // 写于父类中的公共字段
        //strategy.setSuperEntityColumns("id");
        //要生成的表名，多个用，分割
        strategy.setInclude(scanner("表名，多个英文逗号分割").split(","));
        //按前缀生成所有匹配表
        //strategy.setLikeTable(new LikeTable("前缀"));
        //controller驼峰转连字符  pms_product  --->  @RequestMapping("pms/pms_product")
        //strategy.setControllerMappingHyphenStyle(true);
        //设置表的替换前缀
        //strategy.setTablePrefix(pc.getModuleName() + "_");
        //mpg.setTemplateEngine(new FreemarkerTemplateEngine());
        mpg.setStrategy(strategy);
        mpg.execute();

    }

    public static String scanner(String tip) {
        Scanner scanner = new Scanner(System.in);
        StringBuilder help = new StringBuilder();
        help.append("请输入" + tip + "：");
        System.out.println(help.toString());
        if (scanner.hasNext()) {
            String ipt = scanner.next();
            if (StringUtils.isNotBlank(ipt)) {
                return ipt;
            }
        }
        throw new MybatisPlusException("请输入正确的" + tip + "！");
    }
}
```

