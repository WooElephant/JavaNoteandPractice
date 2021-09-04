# SpringCloud

> SpringCloud是分布式微服务架构的一站式解决方案
>
> 是多种微服务架构的集合体，微服务全家桶

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud.assets\SpringCloud体系-16284589968361.jpg)

## 准备

### 父POM

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.augus</groupId>
  <artifactId>springcloud</artifactId>
  <version>1.0-SNAPSHOT</version>
  <packaging>pom</packaging>

  <!--统一jar包和版本号管理-->
  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.source>1.8</maven.compiler.source>
    <maven.compiler.target>1.8</maven.compiler.target>
    <junit.version>4.12</junit.version>
    <log4j.version>1.2.17</log4j.version>
    <lombok.version>1.18.12</lombok.version>
    <mysql.version>8.0.25</mysql.version>
    <druid.version>1.2.6</druid.version>
    <mybatis.spring.boot.version>2.1.4</mybatis.spring.boot.version>
  </properties>

  <!--子模块继承之后，锁定版本，不用写groupId和version-->
  <dependencyManagement>
    <dependencies>
      <!--SpringBoot-->
      <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-dependencies</artifactId>
        <version>2.2.2.RELEASE</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
      <!--SpringCloud-->
      <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-dependencies</artifactId>
        <version>Hoxton.SR1</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
      <!--SpringCloud Alibaba-->
      <dependency>
        <groupId>com.alibaba.cloud</groupId>
        <artifactId>spring-cloud-alibaba-dependencies</artifactId>
        <version>2.1.0.RELEASE</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
      <!--mysql-->
      <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>${mysql.version}</version>
      </dependency>
      <!--druid-->
      <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>druid</artifactId>
        <version>${druid.version}</version>
      </dependency>
      <!--myBatis-->
      <dependency>
        <groupId>org.mybatis.spring.boot</groupId>
        <artifactId>mybatis-spring-boot-starter</artifactId>
        <version>${mybatis.spring.boot.version}</version>
      </dependency>
      <!--junit-->
      <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>${junit.version}</version>
      </dependency>
      <!--lombok-->
      <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <version>${lombok.version}</version>
        <optional>true</optional>
      </dependency>
    </dependencies>
  </dependencyManagement>

  <build>
    <plugins>
      <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
        <configuration>
          <fork>true</fork>
          <addResources>true</addResources>
        </configuration>
      </plugin>
    </plugins>
  </build>

</project>
```

### 代码构建

> 写一个支付模块

#### 改pom

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>springcloud</artifactId>
        <groupId>com.augus</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>colud-provider-payment8001</artifactId>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid-spring-boot-starter</artifactId>
            <version>1.1.10</version>
        </dependency>
        <!--mysql-connector-java-->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jdbc</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

</project>
```

#### 写配置

```yaml
server:
  port: 8001

spring:
  application:
    name: cloud-payment-service
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/springcloudtest?useUnicode=true&characterEncoding=utf-8&useSSL=false
    username: root
    password: 1234

mybatis:
  mapper-locations: classpath:mapper/*.xml
  type-aliases-package: com.augus.springcloud.entities
```

#### 主启动

```java
@SpringBootApplication
public class PaymentMain8001 {
    public static void main(String[] args) {
        SpringApplication.run(PaymentMain8001.class,args);
    }
}
```

#### 建表

```mysql
create table payment(
    id bigint(20) primary key auto_increment comment 'ID',
    serial varchar(200) default ''
)default character set UTF8;
```

#### entity

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Payment implements Serializable {
    private Long id;
    private String serial;
}
```

```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommonResult<T> {
    private Integer code;
    private String message;
    private T data;

    public CommonResult(Integer code,String message){
        this(code,message,null);
    }
}
```

#### dao

```java
@Mapper
public interface PaymentDao {
    public int create(Payment payment);
    public Payment getPaymentById(@Param("id") Long id);
}
```

#### mapper

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.augus.springcloud.dao.PaymentDao">
    <insert id="create" parameterType="payment" useGeneratedKeys="true" keyProperty="id">
        insert into payment(serial) values(#{serial})
    </insert>
    
    <select id="getPaymentById" parameterType="long" resultMap="BaseResultMap">
        select * from payment where id = #{id}
    </select>
    
    <resultMap id="BaseResultMap" type="com.augus.springcloud.entities.Payment">
        <id column="id" property="id" jdbcType="BIGINT"/>
        <result column="serial" property="serial" jdbcType="VARCHAR"/>
    </resultMap>
</mapper>
```

#### service

```java
@Service
public class PaymentServiceImpl implements PaymentService {

    @Autowired
    private PaymentDao paymentDao;

    @Override
    public int create(Payment payment) {
        return paymentDao.create(payment);
    }

    @Override
    public Payment getPaymentById(Long id) {
        return paymentDao.getPaymentById(id);
    }
}
```

#### controller

```java
@RestController
@Slf4j
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @PostMapping(value = "/payment/create")
    public CommonResult create(@RequestBody Payment payment){
        int result = paymentService.create(payment);
        log.info("插入结果：" + result);

        if (result > 0){
            return new CommonResult(200,"插入数据成功！",result);
        }else {
            return new CommonResult(444,"插入数据失败！",null);
        }
    }

    @GetMapping(value = "/payment/get/{id}")
    public CommonResult getPaymentById(@PathVariable("id") Long id){
        Payment payment = paymentService.getPaymentById(id);
        log.info("查询结果：" + payment);

        if (payment != null){
            return new CommonResult(200,"查询成功！",payment);
        }else {
            return new CommonResult(444,"查询失败！查询id：" + id,null);
        }
    }

}
```

#### 热部署

> 1. 添加devtools依赖

> 2. 在pom中plugin中加入
>
> ```xml
> <build>
>     <plugins>
>         <plugin>
>             <groupId>org.springframework.boot</groupId>
>             <artifactId>spring-boot-maven-plugin</artifactId>
>             <configuration>
>                 <fork>true</fork>
>                 <addResources>true</addResources>
>             </configuration>
>         </plugin>
>     </plugins>
> </build>
> ```

> 3. 在设置中，build/compiler中
>
>    开启ADBC开头的四个选项

> 4. 点击 ctrl + shift + alt + /
>
>    开启compiler.automake.allow.when.app.running
>
>    开启actionSystem.assertFocusAccessFromEdt

> 5. 重启IDEA



### 代码构建2

> 消费者订单模块

> 改POM
>
> 写配置
>
> 主启动
>
> 这三个步骤就不再重复了，直接写业务代码

#### 配置类

```java
@Configuration
public class ApplicationContextConfig {
    @Bean
    public RestTemplate getRestTemplate(){
        return new RestTemplate();
    }
}
```

> 将RestTemplate添加进容器

#### controller

```java
@RestController
@Slf4j
public class OrderController {
    @Autowired
    private RestTemplate restTemplate;

    public static final String PAYMENT_URL = "http://localhost:8001";

    @GetMapping("/consumer/payment/create")
    public CommonResult<Payment> create(Payment payment){
        return restTemplate.postForObject(PAYMENT_URL + "/payment/create",payment,CommonResult.class);
    }

    @GetMapping("/consumer/payment/get/{id}")
    public CommonResult<Payment> getPayment(@PathVariable("id") Long id){
        return restTemplate.getForObject(PAYMENT_URL + "/payment/get/" + id,CommonResult.class);
    }
}
```

## DashBoard

> 如果IDEA未自动开启DashBoard
>
> 手动在项目路径中.idea文件夹，workspace.xml中加入
>
> ```xml
> <component name="RunDashboard">
>     <option name="configurationTypes">
>         <set>
>             <option value="SpringBootApplicationConfigurationType" />
>         </set>
>     </option>
> </component>
> ```

> 新版IDEA只需要在view中打开Tool Windows中的Service，并添加Spring Boot即可



## 重构

> 我们两个微服务中，都有entity，这部分代码是重复的

> 我们新建一个model，放置所有共用部分

### pom

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>springcloud</artifactId>
        <groupId>com.augus</groupId>
        <version>1.0-SNAPSHOT</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>cloud-api-commons</artifactId>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>cn.hutool</groupId>
            <artifactId>hutool-all</artifactId>
            <version>5.1.0</version>
        </dependency>
    </dependencies>

</project>
```

### entity

> 将之前项目中的entity抽取出来，复制到这个新的model中
>
> 并用maven install一下

> 删除之前项目中的entity包
>
> 并导入新的model
>
> ```xml
> <dependency>
>     <groupId>com.augus</groupId>
>     <artifactId>cloud-api-commons</artifactId>
>     <version>${project.version}</version>
> </dependency>
> ```



## 服务注册中心

### Eureka

> 详见文件夹中Eureka.md



### ZooKeeper

> 详见文件夹中ZooKeeper.md



### Consul

> 详见文件夹中Consul.md



### 三个配置中心的区别

|  组件名   | 语言 | CAP  | 服务健康检查 | 对外暴露接口 | Spring Cloud集成 |
| :-------: | :--: | :--: | :----------: | :----------: | :--------------: |
|  Eureka   | Java |  AP  |     可配     |     HTTP     |      已集成      |
|  Consul   |  Go  |  CP  |     支持     |   HTTP/DNS   |      已集成      |
| ZooKeeper | Java |  CP  |     支持     |    客户端    |      已集成      |

> 在分布式架构中，P（分区容错）是一定要保证的
>
> 所以只有AP和CP
>
> CP强调C，强一致
>
> AP强调A，高可用
>
> 说白了，就是在访问服务时，如果数据还没来得及同步，是等还是不等
>
> 等肯定可用性就会下降，不等一致性就会下降



### Nacos

> Nacos应用很广泛，并且是现在主流使用的
>
> 配置与总线中，我们还会用到Nacos，所以到时候一起提及





## 服务调用

### Ribbon

> 详见文件夹中Ribbon.md

### OpenFeign

> 详见文件夹中OpenFeign.md



## 服务降级

### Hystrix

> 详见文件夹中Hystrix.md



## 服务网关

### Gateway

> 详见文件夹中Gateway.md



## 分布式配置中心

### Config

> 详见文件夹中Config.md



## 消息总线

### Bus

> 详见文件夹中Bus.md



## 消息驱动

### Stream

> 详见文件夹中Stream.md



## 分布式请求链路跟踪

### Sleuth

> 详见文件夹中Sleuth.md



## SpringCloud Alibaba

> 因为很多Netflix组件停止更新，Alibaba出了很多替代并且好用的云端整合方案，解决了Netflix停更的空白

```xml
<dependency>
  <groupId>com.alibaba.cloud</groupId>
  <artifactId>spring-cloud-alibaba-dependencies</artifactId>
  <version>2.1.0.RELEASE</version>
  <type>pom</type>
  <scope>import</scope>
</dependency>
```

> 引入其依赖即可使用



### Nacos

> 详见文件夹中Nacos.md



### Sentinel

> 详见文件夹中Sentinel.md



### Seata

> 详见文件夹中Seata.md

