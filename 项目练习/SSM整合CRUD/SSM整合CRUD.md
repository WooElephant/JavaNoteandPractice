# SSM整合CRUD

> SSM的配置是令人头疼的，这个项目是为了SSM整合的一个小练习，并且使用最常见CRUD操作，以达到基础部分的巩固练习

> 技术点：
>
> 1. 分页PageHelper
> 2. 数据校验（前端+后端）
> 3. AJAX
> 4. REST风格
> 5. SSM整合
> 6. MySQL
> 7. BootStrap
> 8. Maven
> 9. MyBatis Generator

## 环境搭建

### 创建工程

> 创建一个空Maven项目
>
> 在project structure中model中的web中，配置好webapp和web.xml



### 引入依赖

```xml
<dependencies>
    <!--SpringMVC-->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-webmvc</artifactId>
        <version>5.2.9.RELEASE</version>
    </dependency>
    <!--Spring-JDBC-->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-jdbc</artifactId>
        <version>5.2.9.RELEASE</version>
    </dependency>
    <!--Spring-AOP-->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-aspects</artifactId>
        <version>5.2.9.RELEASE</version>
    </dependency>
    <!--MyBatis-->
    <dependency>
        <groupId>org.mybatis</groupId>
        <artifactId>mybatis</artifactId>
        <version>3.5.7</version>
    </dependency>
    <!--MyBatis整合Spring-->
    <dependency>
        <groupId>org.mybatis</groupId>
        <artifactId>mybatis-spring</artifactId>
        <version>2.0.6</version>
    </dependency>
    <!--数据库连接池和驱动-->
    <dependency>
        <groupId>com.mchange</groupId>
        <artifactId>c3p0</artifactId>
        <version>0.9.5.5</version>
    </dependency>
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>8.0.26</version>
    </dependency>

    <!--其他依赖-->
    <!--JSTL-->
    <dependency>
        <groupId>javax.servlet.jsp.jstl</groupId>
        <artifactId>jstl</artifactId>
        <version>1.2</version>
    </dependency>
    <!--ServletAPI-->
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>servlet-api</artifactId>
        <version>2.5</version>
        <scope>provided</scope>
    </dependency>
    <!--junit-->
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.13.2</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```



### 引入BootStrap

![image-20211111191921195](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\项目练习\SSM整合CRUD\SSM整合CRUD.assets\image-20211111191921195.png)

> 将其下载，并粘贴到项目中
>
> 并且将JQuery也引入进来

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <%--引入BootStrap--%>
    <link href="static/bootstrap-3.4.1-dist/css/bootstrap.min.css">
    <script src="static/bootstrap-3.4.1-dist/js/bootstrap.min.js"></script>
    <%--引入JQuery--%>
    <script src="static/js/jquery-3.4.1.min.js"></script>

</head>
<body>
    
</body>
</html>
```



### 建库

```mysql
create database ssm_crud default character set utf8;

use ssm_crud;

create table tbl_dept(
    dept_id int(11) primary key auto_increment,
    dept_name varchar(20) not null
);

create table tbl_emp(
    emp_id int(11) primary key auto_increment,
    emp_name varchar(20) not null,
    gender char(1),
    email varchar(20),
    d_id int(11),
    foreign key(d_id) references tbl_dept(dept_id)
);
```



### MyBatis逆向工程

```xml
<!--MyBatis Generator-->
<dependency>
    <groupId>org.mybatis.generator</groupId>
    <artifactId>mybatis-generator-core</artifactId>
    <version>1.4.0</version>
</dependency>
```

> 导入依赖

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
        PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">

<generatorConfiguration>

    <context id="DB2Tables" targetRuntime="MyBatis3">
        <!--配置数据库连接-->
        <jdbcConnection driverClass="com.mysql.cj.jdbc.Driver"
                        connectionURL="jdbc:mysql://localhost:3306/ssm_crud"
                        userId="root"
                        password="1234">
        </jdbcConnection>

        <javaTypeResolver >
            <property name="forceBigDecimals" value="false" />
        </javaTypeResolver>

        <!--指定JavaBean生成的位置-->
        <javaModelGenerator targetPackage="com.augus.crud.bean" targetProject=".\src\main\java">
            <property name="enableSubPackages" value="true" />
            <property name="trimStrings" value="true" />
        </javaModelGenerator>

        <!--指定映射文件生成位置-->
        <sqlMapGenerator targetPackage="mapper"  targetProject=".\src\main\resources">
            <property name="enableSubPackages" value="true" />
        </sqlMapGenerator>

        <!--指定dao接口的位置-->
        <javaClientGenerator type="XMLMAPPER" targetPackage="com.augus.crud.dao"  targetProject=".\src\main\java">
            <property name="enableSubPackages" value="true" />
        </javaClientGenerator>

        <!--指定每个表的生成策略，tableName填表名，domainObjectName填生成出实体类的名称-->
        <table tableName="tbl_emp" domainObjectName="Employee"></table>
        <table tableName="tbl_dept" domainObjectName="Department"></table>

    </context>
</generatorConfiguration>
```

> 从官网把示例XML复制，在项目中建一个mbg.xml
>
> 把内容修改一下

```java
public class MBGTest {
    public static void main(String[] args) throws Exception {
        List<String> warnings = new ArrayList<String>();
        boolean overwrite = true;
        File configFile = new File("mbg.xml");
        ConfigurationParser cp = new ConfigurationParser(warnings);
        Configuration config = cp.parseConfiguration(configFile);
        DefaultShellCallback callback = new DefaultShellCallback(overwrite);
        MyBatisGenerator myBatisGenerator = new MyBatisGenerator(config, callback, warnings);
        myBatisGenerator.generate(null);
    }
}
```

> 运行代码也是在官方复制的，只需要将配置文件名称改一下

```xml
<commentGenerator>
    <property name="suppressAllComments" value="true"/>
</commentGenerator>
```

> 如果不需要注释，可以在mbg.xml中加入commentGenerator的配置



#### 新增方法

> 因为我们在查询职工时，需要将员工和部门信息一同显示，所以我们需要手动写一个方法

```java
List<Employee> selectByExampleWithDept(EmployeeExample example);

Employee selectByPrimaryKeyWithDept(Integer empId);
```

> 在Employee的dao中新增两个方法

```java
private Department department;

public Department getDepartment() {
    return department;
}

public void setDepartment(Department department) {
    this.department = department;
}
```

> 在Employee的实体类中，加入Department字段，并生成get和set方法

```xml
<resultMap id="withDeptResultMap" type="com.augus.crud.bean.Employee">
  <id column="emp_id" jdbcType="INTEGER" property="empId" />
  <result column="emp_name" jdbcType="VARCHAR" property="empName" />
  <result column="gender" jdbcType="CHAR" property="gender" />
  <result column="email" jdbcType="VARCHAR" property="email" />
  <result column="d_id" jdbcType="INTEGER" property="dId" />
  <association property="department" javaType="com.augus.crud.bean.Department">
    <id column="dept_id" property="deptId"/>
    <result column="dept_name" property="deptName"/>
  </association>
</resultMap>

<sql id="withDept_Column_List">
  e.emp_id, e.emp_name, e.gender, e.email, e.d_id, d.dept_id, d.dept_name
</sql>

<select id="selectByExampleWithDept" resultMap="withDeptResultMap">
  select
  <if test="distinct">
    distinct
  </if>
  <include refid="withDept_Column_List" />
  from tbl_emp e
  left join tbl_dept d on e.d_id = d.dept_id
  <if test="_parameter != null">
    <include refid="Example_Where_Clause" />
  </if>
  <if test="orderByClause != null">
    order by ${orderByClause}
  </if>
</select>

<select id="selectByPrimaryKeyWithDept" resultMap="withDeptResultMap">
  select
  <include refid="withDept_Column_List" />
  from tbl_emp e
  left join tbl_dept d on e.d_id = d.dept_id
  where emp_id = #{empId,jdbcType=INTEGER}
</select>
```

> 在mapper文件中写好实现，大部分直接粘MyBatis自动生成的，把一些需要改的内容，改一改



### 配置文件

#### web.xml

```xml
<!--启动Spring容器-->
<context-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>classpath:applicationContext.xml</param-value>
</context-param>

<listener>
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>


<!--SpringMVC前端控制器-->
<servlet>
    <servlet-name>dispatcherServlet</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:SpringMVCConfig.xml</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>

<servlet-mapping>
    <servlet-name>dispatcherServlet</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>


<!--字符编码过滤器-->
<filter>
    <filter-name>characterEncodingFilter</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
        <param-name>encoding</param-name>
        <param-value>utf-8</param-value>
    </init-param>
    <init-param>
        <param-name>forceRequestEncoding</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <param-name>forceResponseEncoding</param-name>
        <param-value>true</param-value>
    </init-param>
</filter>

<filter-mapping>
    <filter-name>characterEncodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>


<!--RESTFul-->
<filter>
    <filter-name>hiddenHttpMethodFilter</filter-name>
    <filter-class>org.springframework.web.filter.HiddenHttpMethodFilter</filter-class>
</filter>

<filter-mapping>
    <filter-name>hiddenHttpMethodFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

> 过滤字符编码的过滤器必须放在最前面



#### SpringMVC

> 包含网站跳转逻辑的配置

```xml
<!--包扫描只扫描controller，将默认扫描关闭-->
<context:component-scan base-package="com.augus" use-default-filters="false">
    <context:include-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
</context:component-scan>

<!--视图解析器-->
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="prefix" value="/WEB-INF/views/"></property>
    <property name="suffix" value=".jsp"></property>
</bean>

<!--两个标准配置-->
<!--将不能处理的请求交给Tomcat-->
<mvc:default-servlet-handler/>
<!--支持MVC的一些高级功能，校验，映射动态请求等-->
<mvc:annotation-driven/>
```



#### Spring

> 需要给数据源引用数据库链接信息，我们将其写在DBConfig.properties中
>
> 为了避免参数重名，我们在其开头加入jdbc.以区分

```properties
jdbc.user=root
jdbc.password=1234
jdbc.jdbcUrl=jdbc:mysql://localhost:3306/ssm_crud
jdbc.driverClass=com.mysql.cj.jdbc.Driver
```

```xml
<!--扫描所有包，不扫描Controller注解的类-->
<context:component-scan base-package="com.augus">
    <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
</context:component-scan>

<!--引入外部properties数据库链接-配置-->
<context:property-placeholder location="classpath:DBConfig.properties"></context:property-placeholder>

<!--配置数据源，为其加载数据库的链接配置-->
<bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
    <property name="user" value="${jdbc.user}"></property>
    <property name="password" value="${jdbc.password}"></property>
    <property name="jdbcUrl" value="${jdbc.jdbcUrl}"></property>
    <property name="driverClass" value="${jdbc.driverClass}"></property>
</bean>

<!--MyBatis的整合-->
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
    <!--指定MyBatis全局配置文件的位置-->
    <property name="configLocation" value="classpath:MybatisConfig.xml"></property>
    <!--指定数据源-->
    <property name="dataSource" ref="dataSource"></property>
    <!--指定mapper所在位置-->
    <property name="mapperLocations" value="classpath:mapper/*.xml"></property>
</bean>

<!--配置扫描器，将MyBatis的接口实现类加入IOC-->
<bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
    <!--扫描所有DAO接口，加入IOC容器-->
    <property name="basePackage" value="com.augus.crud.dao"></property>
</bean>

<!--事务控制-->
<bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <!--控制数据源-->
    <property name="dataSource" ref="dataSource"></property>
</bean>

<!--开启事务-->
<aop:config>
    <!--切入点表达式，表示哪些需要被切入-->
    <aop:pointcut id="txPoint" expression="execution(* com.augus.crud.service..*(..))"/>
    <!--配置事务-->
    <aop:advisor advice-ref="txAdvice" pointcut-ref="txPoint"></aop:advisor>
</aop:config>

<!--配置事务如何切入-->
<tx:advice id="txAdvice" transaction-manager="transactionManager">
    <tx:attributes>
        <tx:method name="*"/>
        <!--以get开始的方法，为只读，优化性能-->
        <tx:method name="get*" read-only="true"/>
    </tx:attributes>
</tx:advice>
```



#### MyBatis

```xml
<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <settings>
        <!--开启驼峰命名规则-->
        <setting name="mapUnderscoreToCamelCase" value="true"/>
    </settings>
    <typeAliases>
        <!--定义包的别名-->
        <package name="com.augus.crud.bean"/>
    </typeAliases>
</configuration>
```



### 测试

```xml
<!--Spring单元测试-->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-test</artifactId>
    <version>5.2.9.RELEASE</version>
</dependency>
```

> 导入Spring单元测试模块

```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Test
    public void testCRUD(){
        departmentMapper.insertSelective(new Department(null,"服务部"));
        employeeMapper.insertSelective(new Employee(null,"李四","男","lisi@163.com",102));
    }
}
```

> 插入两条数据，正常运行



## 查询

> 访问index页面
>
> index页面发出查询请求
>
> 处理请求，查出数据
>
> 来到list页面展示

```xml
<!--分页插件-->
<dependency>
    <groupId>com.github.pagehelper</groupId>
    <artifactId>pagehelper</artifactId>
    <version>5.1.11</version>
</dependency>
```

> 引入分页插件

```xml
<plugins>
    <plugin interceptor="com.github.pagehelper.PageInterceptor"></plugin>
</plugins>
```

> 在MyBatis配置文件中，引入分页插件

```java
@Service
public class EmployeeService {

    @Autowired
    EmployeeMapper employeeMapper;

    public List<Employee> getAll(){
        return employeeMapper.selectByExampleWithDept(null);
    }
}
```

> service直接调用mapper

```java
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    @RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pageNum",defaultValue = "1")Integer pageNum, Model model){
        //传入页码以及每页数量
        PageHelper.startPage(pageNum,5);
        List<Employee> emps = employeeService.getAll();

        //使用PageInfo包装结果，第二个参数为连续显示多少页
        PageInfo pageInfo = new PageInfo(emps,5);

        model.addAttribute("pageInfo",pageInfo);
        return "list";
    }
}
```

> controller中的逻辑

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:forward page="/emps"></jsp:forward>
```

> index页面，直接请求/emps

```jsp
<%--
  Created by IntelliJ IDEA.
  User: augus
  Date: 2021/11/12
  Time: 14:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>>
<html>
<head>
    <title>员工列表</title>
    <%
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>
    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.4.1-dist/css/bootstrap.min.css">
    <script src="${APP_PATH}/static/bootstrap-3.4.1-dist/js/bootstrap.min.js"></script>
    <script src="${APP_PATH}/static/js/jquery-3.4.1.min.js"></script>
</head>
<body>
    <div class="container">
        <%--标题--%>
        <div class="row">
            <div class="col-md-12">
                <h1>SSM_CRUD</h1>
            </div>
        </div>

        <%--按钮--%>
        <div class="row">
            <div class="col-md-4 col-md-offset-8">
                <button class="btn btn-primary">新增</button>
                <button class="btn btn-danger">删除</button>
            </div>
        </div>
        <%--表格--%>
        <div class="row">
            <div class="col-md-12">
                <table class="table table-hover">
                    <tr>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>
                    <c:forEach items="${pageInfo.list}" var="emp">
                        <tr>
                            <th>${emp.empId}</th>
                            <th>${emp.empName}</th>
                            <th>${emp.gender}</th>
                            <th>${emp.email}</th>
                            <th>${emp.department.deptName}</th>
                            <th>
                                <button class="btn btn-primary btn-sm">
                                    <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                    编辑
                                </button>

                                <button class="btn btn-danger btn-sm">
                                    <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                    删除
                                </button>
                            </th>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>
        <%--分页--%>
        <div class="row">
            <div class="col-md-6">
                当前${pageInfo.pageNum}页，共${pageInfo.pages}页，共${pageInfo.total}条记录
            </div>

            <div class="col-md-6">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li>
                            <a href="${APP_PATH}/emps?pageNum=1">
                                首页
                            </a>
                        </li>
                        <c:if test="${pageInfo.hasPreviousPage}">
                            <li>
                                <a href="${APP_PATH}/emps?pageNum=${pageInfo.pageNum-1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach items="${pageInfo.navigatepageNums}" var="page_Num">
                            <c:if test="${page_Num == pageInfo.pageNum}">
                                <li class="active">
                                    <a href="">${page_Num}</a>
                                </li>
                            </c:if>
                            <c:if test="${page_Num != pageInfo.pageNum}">
                                <li>
                                    <a href="${APP_PATH}/emps?pageNum=${page_Num}">${page_Num}</a>
                                </li>
                            </c:if>
                        </c:forEach>
                        <c:if test="${pageInfo.hasNextPage}">
                            <li>
                                <a href="${APP_PATH}/emps?pageNum=${pageInfo.pageNum+1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <li>
                            <a href="${APP_PATH}/emps?pageNum=${pageInfo.pages}">
                                末页
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

</body>
</html>
```

> 展示页的业务逻辑



### AJAX查询

> index页面发送ajax请求
>
> 服务器返回json
>
> 对json进行解析，通过dom改变页面

```xml
<!--jackson-->
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.12.4</version>
</dependency>
```

> @ResponseBody需要jackson-databind依赖

```java
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    @RequestMapping("/emps")
    @ResponseBody
    public PageInfo getEmpsWithJson(@RequestParam(value = "pageNum",defaultValue = "1")Integer pageNum){
        //传入页码以及每页数量
        PageHelper.startPage(pageNum,5);
        List<Employee> emps = employeeService.getAll();

        //使用PageInfo包装结果，第二个参数为连续显示多少页
        PageInfo pageInfo = new PageInfo(emps,5);
        return pageInfo;
    }
}
```

> controller直接返回pageInfo对象，自动转换为json

```java
package com.augus.crud.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * 通用返回类
 */
public class Msg {
    //状态码
    private int code;
    //提示信息
    private String msg;
    //自定义返回数据
    private Map<String,Object> extend = new HashMap<>();

    public static Msg success(){
        Msg result = new Msg();
        result.setCode(100);
        result.setMsg("处理成功！");
        return result;
    }

    public static Msg fail(){
        Msg result = new Msg();
        result.setCode(200);
        result.setMsg("处理失败！");
        return result;
    }

    //快捷链式添加自定义数据
    public Msg add(String key,Object value){
        this.getExtend().put(key,value);
        return this;
    }
    
    //get&set....
}
```

> 为了使返回有一些基本提示我们自定义一个通用返回类

```java
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pageNum",defaultValue = "1")Integer pageNum){
        //传入页码以及每页数量
        PageHelper.startPage(pageNum,5);
        List<Employee> emps = employeeService.getAll();

        //使用PageInfo包装结果，第二个参数为连续显示多少页
        PageInfo pageInfo = new PageInfo(emps,5);
        return Msg.success().add("pageInfo",pageInfo);
    }
}
```

> 在controller中直接返回Msg并携带数据

```jsp
<%--
  Created by IntelliJ IDEA.
  User: augus
  Date: 2021/11/12
  Time: 14:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>>
<html>
<head>
    <title>员工列表</title>
    <%
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>
    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.4.1-dist/css/bootstrap.min.css">
    <script src="${APP_PATH}/static/bootstrap-3.4.1-dist/js/bootstrap.min.js"></script>
    <script src="${APP_PATH}/static/js/jquery-3.4.1.min.js"></script>
</head>
<body>
    <div class="container">
        <%--标题--%>
        <div class="row">
            <div class="col-md-12">
                <h1>SSM_CRUD</h1>
            </div>
        </div>

        <%--按钮--%>
        <div class="row">
            <div class="col-md-4 col-md-offset-8">
                <button class="btn btn-primary">新增</button>
                <button class="btn btn-danger">删除</button>
            </div>
        </div>
        <%--表格--%>
        <div class="row">
            <div class="col-md-12">
                <table class="table table-hover" id="emps_table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>empName</th>
                            <th>gender</th>
                            <th>email</th>
                            <th>deptName</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
        <%--分页--%>
        <div class="row">
            <div class="col-md-6" id="page_info_area">

            </div>

            <div class="col-md-6" id="page_nav_area">

            </div>
        </div>
    </div>

    <script type="text/javascript">
        //页码加载完成发送ajax请求
        $(function () {
            toPage(1);
        });

        function toPage(num) {
            $.ajax({
                url:"${APP_PATH}/emps",
                data:"pageNum=" + num,
                type:"get",
                success:function (result) {
                    build_emps_table(result);
                    build_page_info(result);
                    build_page_nav(result);
                }
            });
        }

        //数据单元格的构建
        function build_emps_table(result) {
            $("#emps_table tbody").empty();
            var emps = result.extend.pageInfo.list;
            $.each(emps,function (index,item) {
                var empIdTd = $("<td></td>").append(item.empId);
                var empNameTd = $("<td></td>").append(item.empName);
                var genderTd = $("<td></td>").append(item.gender);
                var emailTd = $("<td></td>").append(item.email);
                var deptNameTd = $("<td></td>").append(item.department.deptName);
                var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm")
                    .append($("<span></span>").addClass("glyphicon glyphicon-pencil").append("编辑"));
                var removeBtn = $("<button></button>").addClass("btn btn-danger btn-sm")
                    .append($("<span></span>").addClass("glyphicon glyphicon-trash").append("删除"));
                var btnTd = $("<td></td>").append(editBtn).append(removeBtn);
                $("<tr></tr>").append(empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(deptNameTd)
                    .append(btnTd)
                    .appendTo("#emps_table tbody");
            });
        }

        //分页信息构建
        function build_page_info(result) {
            $("#page_info_area").empty();
            $("#page_info_area").append("当前"+ result.extend.pageInfo.pageNum +"页，共"+
                result.extend.pageInfo.pages +"页，共"+
                result.extend.pageInfo.total+"条记录");
        }

        //分页条构建
        function build_page_nav(result) {
            $("#page_nav_area").empty();
            var ul = $("<ul></ul>").addClass("pagination");

            var firstPageLi = $("<li></li>").append($("<a></a>").append("首页"));
            var lastPageLi = $("<li></li>").append($("<a></a>").append("末页"));
            var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
            var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));


            if (!result.extend.pageInfo.hasPreviousPage){
                firstPageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            }else {
                firstPageLi.click(function () {
                    toPage(1);
                });
                prePageLi.click(function () {
                    toPage(result.extend.pageInfo.pageNum - 1);
                });
            }

            if (!result.extend.pageInfo.hasNextPage){
                lastPageLi.addClass("disabled");
                nextPageLi.addClass("disabled");
            }else {
                lastPageLi.click(function () {
                    toPage(result.extend.pageInfo.pages);
                });
                nextPageLi.click(function () {
                    toPage(result.extend.pageInfo.pageNum + 1);
                });
            }

            ul.append(firstPageLi).append(prePageLi);

            $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
                var numLi = $("<li></li>").append($("<a></a>").append(item));
                if (result.extend.pageInfo.pageNum == item){
                    numLi.addClass("active");
                }

                numLi.click(function () {
                    toPage(item);
                })

                ul.append(numLi);
            });

            ul.append(nextPageLi).append(lastPageLi);

            var navELement = $("<nav></nav>").append(ul);
            navELement.appendTo("#page_nav_area");
        }
    </script>

</body>
</html>
```

> 使用JQuery动态改变页面



### 排序查询

> 我们没有给MyBatis定义查询参数，查询出来的结果并不会像我们想的一样，按主键升序

```java
public List<Employee> getAll(){
    EmployeeExample employeeExample = new EmployeeExample();
    employeeExample.setOrderByClause("emp_id");
    List<Employee> employees = employeeMapper.selectByExampleWithDept(employeeExample);
    return employees;
}
```

> 在Service中，为查询添加一个OrderBy

## 新增

> 点击新增，弹出对话框
>
> 去数据库查询部门列表，供页面显示选择
>
> 输入数据，完成保存

```java
@Controller
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    @RequestMapping("/depts")
    @ResponseBody
    public Msg getDepts(){
        List<Department> depts = departmentService.getDepts();
        return Msg.success().add("depts",depts);
    }
}
```

```java
@Service
public class DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    public List<Department> getDepts(){
        List<Department> departments = departmentMapper.selectByExample(null);
        return departments;
    }

}
```

> 将处理查询department的controller和service准备好

> 因为我们基于REST风格
>
> 我们规定
>
> /emp/{id} GET查询
>
> /emp POST保存
>
> /emp/{id} PUT修改
>
> /emp/{id} DELETE删除

```java
@RequestMapping(value = "/emp",method = RequestMethod.POST)
@ResponseBody
public Msg saveEmp(Employee employee){
    employeeService.saveEmp(employee);
    return Msg.success();
}
```

> 在EmployeeController中定义POST存储方法

```xml
<plugins>
    <plugin interceptor="com.github.pagehelper.PageInterceptor">
        <property name="reasonable" value="true"/>
    </plugin>
</plugins>
```

> 因为我们保存成功后要跳转到最后一页，我们又无法知道新增一个员工会不会增加一页，所以我们之间写一个非常大的数字，远大于最后一页
>
> 在MyBatis配置文件中，打开pagehelper的reasonable属性，这样输入的值超过最后一页就默认查最后一页



### 数据校验

> 导入hibernate-validator用于后端校验，防止用户恶意写入或者禁用js

```xml
<!--JSR校验-->
<dependency>
    <groupId>org.hibernate.validator</groupId>
    <artifactId>hibernate-validator</artifactId>
    <version>6.2.0.Final</version>
</dependency>
```

```java
@Pattern(regexp = "(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5})",message = "用户名可以为2-5位中文或3-16位英文，您的输入不合法！")
private String empName;

@Pattern(regexp = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$",message = "您输入的邮箱不合法！")
private String email;
```

> 在Employee中的字段上，加入@pattern注解，自定义验证规则

```java
@RequestMapping(value = "/emp",method = RequestMethod.POST)
@ResponseBody
public Msg saveEmp(@Valid Employee employee, BindingResult result){
    if (result.hasErrors()){
        List<FieldError> fieldErrors = result.getFieldErrors();
        Map<String,String> map = new HashMap<>();
        for (FieldError fieldError : fieldErrors) {
            map.put(fieldError.getField(),fieldError.getDefaultMessage());
        }
        return Msg.fail().add("errorFields",map);
    }else {
        employeeService.saveEmp(employee);
        return Msg.success();
    }
}
```

> 在controller中的保存方法，参数上加入@Valid，启动校验，并添加参数BindingResult result，用于接收校验失败信息
>
> 将失败信息封装进一个map中，返回给前端用于显示

```java
@ResponseBody
@RequestMapping("/checkEmail")
public Msg checkEmail(@RequestParam("email") String email){
    String reg = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$";
    if (!email.matches(reg)){
        return Msg.fail().add("email_validate","您输入的邮箱不合法！");
    }

    boolean b = employeeService.checkEmail(email);
    if (b){
        return Msg.success();
    }else {
        return Msg.fail().add("email_validate","您输入的邮箱已存在！");
    }
}
```

> 再添加一个email检查方法，用于前端ajax请求，查找数据库是否有重复数据，返回给前端验证信息

```js
function show_validate_msg(element,status,msg){
    $(element).parent().removeClass("has-success has-error");
    $(element).next("span").text("");

    if (status == "success"){
        $(element).parent().addClass("has-success");
        $(element).next("span").text("");
    }else {
        $(element).parent().addClass("has-error");
        $(element).next("span").text(msg);
    }
}
```

> 通用显示错误信息的方法

```js
$("#empName_input").change(function () {
    var empName = $("#empName_input").val();
    var regName = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
    if(!regName.test(empName)){
        show_validate_msg("#empName_input","error","用户名可以为2-5位中文或3-16位英文，您的输入不合法！");
        $("#emp_save_btn").attr("validateCheck","error");
    }else {
        show_validate_msg("#empName_input","success","");
        $("#emp_save_btn").attr("validateCheck","success");
    }
})
```

> 姓名输入时，前端校验是否合法

```js
$("#empEmail_input").change(function () {

    var value = $("#empEmail_input").val();

    $.ajax({
        url: "${APP_PATH}/checkEmail",
        data: "email=" + value,
        type: "POST",
        success: function (result) {
            if (result.code == 100){
                show_validate_msg("#empEmail_input","success","");
                $("#emp_save_btn").attr("validateCheck","success");
            }else {
                show_validate_msg("#empEmail_input","error",result.extend.email_validate);
                $("#emp_save_btn").attr("validateCheck","error");
            }
        }
    });
});
```

> email输入，ajax发送后端验证，并接收返回值，并显示

```js
//保存点击事件
$("#emp_save_btn").click(function () {

    if($("#emp_save_btn").attr("validateCheck") == "error"){
        return false;
    }

    $.ajax({
        url: "${APP_PATH}/emp",
        type: "POST",
        data: $("#empAddModal form").serialize(),
        success: function (result) {
            if (result.code == 100){
                alert("操作成功！");
                $("#empAddModal").modal("hide");
                toPage(99999999);
            }else {
                if (result.extend.errorFields.email != undefined){
                    show_validate_msg("#empEmail_input","error",result.extend.errorFields.email);
                }
                if (result.extend.errorFields.empName != undefined){
                    show_validate_msg("#empName_input","error",result.extend.errorFields.empName);
                }
            }
        }
    });
});
```

> 如果前端校验出了问题，就为提交按钮添加一个validateCheck的属性，先判断前端校验，前端校验没问题发送给后端，后端交验结果再来做判断

```js
//点击新增按钮
$("#emp_add_btn").click(function () {
    //表单重置
    $("#empAddModal form")[0].reset();
    $("#empAddModal form").removeClass("has-error has-success");
    $("#empAddModal form").find(".help-block").text("");
    //查询部门信息
    getDepts();
    //弹出窗口
    $("#empAddModal").modal();
});
```

> 弹出模态框的时候，重置掉所有的提示属性，和表单数据



## 修改

> 点击编辑，弹出模态框，展示用户信息
>
> 再点击更新，完成用户修改

```html
<%--员工修改窗口--%>
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="empName_input" class="col-sm-2 control-label">员工姓名</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="empName_update_input" placeholder="empName" name="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">员工性别</label>
                        <div class="col-sm-10">
                            <label for="empGender1_input" class="radio-inline">
                                <input type="radio" name="gender" id="empGender1_update_input" value="男" checked="checked"> 男
                            </label>
                            <label for="empGender2_input" class="radio-inline">
                                <input type="radio" name="gender" id="empGender2_update_input" value="女"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="empEmail_input" class="col-sm-2 control-label">员工email</label>
                        <div class="col-sm-10">
                            <input type="email" class="form-control" id="empEmail_update_input" placeholder="xxxxx@xxx.xxx" name="email">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="deptName_input" class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-4">
                            <select class="form-control" id="deptName_update_input" name="dId">

                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">修改</button>
            </div>
        </div>
    </div>
</div>
```

> 复制一份模态框，改改id和显示的内容

```js
var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
    .append($("<span></span>").addClass("glyphicon glyphicon-pencil").append("编辑"));
editBtn.attr("empId",item.empId);
var removeBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
    .append($("<span></span>").addClass("glyphicon glyphicon-trash").append("删除"));
```

> 在创建每一行数据的js中，为编辑删除按钮添加class
>
> 并且为编辑按钮上添加一个empId方便我们后面使用

```js
$(document).on("click",".edit_btn",function () {
    
});
```

> 因为每一行都是ajax请求后创建出来的，普通绑定是无法绑定事件的，要使用on函数来绑定

```js
//查部门
function getDepts(element) {
    $.ajax({
        url: "${APP_PATH}/depts",
        type: "get",
        success: function (result) {
            $(element).empty();
            $.each(result.extend.depts,function (index,item) {
                var optionElement = $("<option></option>").append(item.deptName).attr("value",item.deptId);
                optionElement.appendTo(element);
            });
        }
    });
}
```

> 查询部门的方法，不写死

```java
@ResponseBody
@RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
public Msg getEmp(@PathVariable("id") Integer id){
    Employee employee = employeeService.getEmp(id);
    return Msg.success().add("emp",employee);
}
```

```java
public Employee getEmp(Integer id) {
    return employeeMapper.selectByPrimaryKeyWithDept(id);
}
```

> 在controller和service中定义好按id查单个员工的方法

```js
$(document).on("click",".edit_btn",function () {
    getDepts("#deptName_update_input");
    getEmp($(this).attr("empId"));
    //传递ID给模态框中的按钮
    $("#emp_update_btn").attr("empId",$(this).attr("empId"));
    $("#empUpdateModal").modal();
});

function getEmp(id) {
    $.ajax({
        url: "${APP_PATH}/emp/" + id,
        type: "GET",
        success: function (result) {
            var empData = result.extend.emp;
            $("#empName_update_input").val(empData.empName);
            $("#empEmail_update_input").val(empData.email);
            $("#empUpdateModal input[name=gender]").val([empData.gender]);
            $("#empUpdateModal select").val([empData.dId]);
        }
    });
}
```

> 模态框弹出之前，发送ajax，获取各种信息并显示

```java
@ResponseBody
@RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
public Msg updateEmp(Employee employee){
    employeeService.updateEmp(employee);
    return Msg.success();
}
```

```java
public void updateEmp(Employee employee) {
    employeeMapper.updateByPrimaryKey(employee);
}
```

> 为增加方法创建controller和service

```js
$("#empName_update_input").change(function () {
    var empName = $("#empName_update_input").val();
    var regName = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
    if(!regName.test(empName)){
        show_validate_msg("#empName_update_input","error","用户名可以为2-5位中文或3-16位英文，您的输入不合法！");
        $("#emp_update_btn").attr("validateCheck","error");
    }else {
        show_validate_msg("#empName_update_input","success","");
        $("#emp_update_btn").attr("validateCheck","success");
    }
})

$("#empEmail_update_input").change(function () {

    var value = $("#empEmail_update_input").val();

    $.ajax({
        url: "${APP_PATH}/checkEmail",
        data: "email=" + value,
        type: "POST",
        success: function (result) {
            if (result.code == 100){
                show_validate_msg("#empEmail_update_input","success","");
                $("#emp_update_btn").attr("validateCheck","success");
            }else {
                show_validate_msg("#empEmail_update_input","error",result.extend.email_validate);
                $("#emp_update_btn").attr("validateCheck","error");
            }
        }
    });
});
```

> 数据前端校验，复制过来改吧改吧

```java
$("#emp_update_btn").click(function () {
    if ($("#emp_update_btn").attr("validateCheck") != "success"){
        return false;
    }

    $.ajax({
        url: "${APP_PATH}/emp/" + $(this).attr("empId"),
        type: "POST",
        data: $("#empUpdateModal form").serialize() + "&_method=PUT",
        success: function (result) {
            alert(result.msg);
            $("#empUpdateModal").modal("hide");
            toPage(currentPage);
        }
    });
});
```

> 为修改按钮绑定事件
>
> 如果要直接发PUT请求，需要给MVC添加一个filter，不然数据不会被封装
>
> 也可以使用POST请求，带上_method参数，由hiddenHttpxxx那个拦截器自动帮我们转

```js
var totalRecord,currentPage;

//分页信息构建
function build_page_info(result) {
    $("#page_info_area").empty();
    $("#page_info_area").append("当前"+ result.extend.pageInfo.pageNum +"页，共"+
                                result.extend.pageInfo.pages +"页，共"+
                                result.extend.pageInfo.total+"条记录");
    totalRecord = result.extend.pageInfo.total;
    currentPage = result.extend.pageInfo.pageNum;
}
```

> 因为修改涉及到修改成功后跳转到当前页，我们在全局定义两个参数
>
> 在分页信息构建时，保存当前页码
>
> 来实现修改后也刷新该页面
>
> 之前写的9999999不太优雅，直接记录总条目数，跳转比较优雅



## 删除

> 单击单个数据，弹出确认框，点击确认删除
>
> 在每条数据前有多选框，选中多个，点击删除，全部删除



### 单个删除

```java
@ResponseBody
@RequestMapping(value = "emp/{id}",method = RequestMethod.DELETE)
public Msg deleteEmpById(@PathVariable("id")Integer id){
    employeeService.deleteEmp(id);
    return Msg.success();
}
```

```java
public void deleteEmp(Integer id) {
    employeeMapper.deleteByPrimaryKey(id);
}
```

> 创建controller和service处理方法

```js
$(document).on("click",".delete_btn",function () {
    var empName = $(this).parents("tr").find("td:eq(1)").text();
    var empId = $(this).parents("tr").find("td:eq(0)").text();
    if (confirm("确认删除["+ empName +"]吗？")){
        $.ajax({
            url: "${APP_PATH}/emp/" + empId,
            method: "DELETE",
            success: function (result) {
                alert(result.msg);
                toPage(currentPage);
            }
        });
    }
});
```

> 为删除按钮绑定事件，这里我们使用另一种方法获取id，通过找其父元素，来获得同一行中的id和name



### 批量删除

```html
<div class="row">
    <div class="col-md-12">
        <table class="table table-hover" id="emps_table">
            <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all"/>
                    </th>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
            </thead>
```

> 在表头添加单选框

```js
//数据单元格的构建
function build_emps_table(result) {
    $("#emps_table tbody").empty();
    var emps = result.extend.pageInfo.list;
    $.each(emps,function (index,item) {
        var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
        var empIdTd = $("<td></td>").append(item.empId);
        var empNameTd = $("<td></td>").append(item.empName);
        var genderTd = $("<td></td>").append(item.gender);
        var emailTd = $("<td></td>").append(item.email);
        var deptNameTd = $("<td></td>").append(item.department.deptName);
        var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
            .append($("<span></span>").addClass("glyphicon glyphicon-pencil").append("编辑"));
        editBtn.attr("empId",item.empId);
        var removeBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
            .append($("<span></span>").addClass("glyphicon glyphicon-trash").append("删除"));
        var btnTd = $("<td></td>").append(editBtn).append(removeBtn);
        $("<tr></tr>").append(checkBoxTd)
            .append(empIdTd)
            .append(empNameTd)
            .append(genderTd)
            .append(emailTd)
            .append(deptNameTd)
            .append(btnTd)
            .appendTo("#emps_table tbody");
    });
}
```

> 每一行构建时，加入一个checkbox

```js
//全选全不选
$("#check_all").click(function () {
    var checked = $(this).prop("checked");
    $(".check_item").prop("checked",checked);
});

$(document).on("click",".check_item",function () {
    var num = $(".check_item:checked").length;
    if (num == $(".check_item").length){
        $("#check_all").prop("checked",true);
    }else {
        $("#check_all").prop("checked",false);
    }
});
```

> 为checkbox绑定单击事件

```html
<%--按钮--%>
<div class="row">
    <div class="col-md-4 col-md-offset-8">
        <button class="btn btn-primary" id="emp_add_btn">新增</button>
        <button class="btn btn-danger" id="emp_delete_all">删除</button>
    </div>
</div>
```

> 为按钮添加id

```java
@ResponseBody
@RequestMapping(value = "emp/{ids}",method = RequestMethod.DELETE)
public Msg deleteEmpById(@PathVariable("ids")String ids){
    if (ids.contains("-")){
        String[] ids_arr = ids.split("-");
        List<Integer> id_list = new ArrayList<>();
        for (String s : ids_arr) {
            int i = Integer.parseInt(s);
            id_list.add(i);
        }
        employeeService.deleteBatch(id_list);
    }else {
        int id = Integer.parseInt(ids);
        employeeService.deleteEmp(id);
    }
    return Msg.success();
}
```

> 我们将controller改造为二合一的，既可以删除单个，也可以删除批量
>
> 注意，这里的批量删除，要传入List的数据

```java
public void deleteBatch(List<Integer> ids) {
    EmployeeExample employeeExample = new EmployeeExample();
    EmployeeExample.Criteria criteria = employeeExample.createCriteria();
    criteria.andEmpIdIn(ids);
    employeeMapper.deleteByExample(employeeExample);
}
```

> service只需要添加一个规则，即可以批量删除

```js
$("#emp_delete_all").click(function () {

    var empNames = "";
    var empIds = "";

    $.each($(".check_item:checked"),function () {
        var empName = $(this).parents("tr").find("td:eq(2)").text();
        var empId = $(this).parents("tr").find("td:eq(1)").text();
        empNames = empNames + empName + ",";
        empIds = empIds + empId + "-";
    });

    empNames = empNames.substring(0,empNames.length-1);
    empIds = empIds.substring(0,empIds.length-1);

    if (confirm("确认删除[" + empNames + "]吗？")){
        $.ajax({
            url: "${APP_PATH}/emp/" + empIds,
            type: "DELETE",
            success: function (result) {
                alert(result.msg);
                toPage(currentPage);
            }
        });
    }
});
```

> 在页面拼接数据，然后发送ajax请求
