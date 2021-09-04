# SpringCloud Alibaba Seata

> Seata是一款开源的分布式事务解决方案

## 术语

> Transaction ID（XID）：全局唯一的事务ID

> Transaction Coordinator（TC）：事务协调器，维护全局事务的运行状态，负责协调并驱动全局事务的提交或回滚
>
> Transaction Manager（TM）：控制全局事务的范围，负责开启一个全局事务，并最终发起全局提交或全局回滚的决议
>
> Resource Manager（RM）：控制分支事务，负责分支注册，状态汇报。并接收事务协调器的指令，驱动分支事务的提交和回滚

![image-20210904112628752](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Seata.assets\image-20210904112628752.png)

> 1. TM向TC申请开启一个全局事务，全局事务创建成功，并生成一个全局唯一XID
> 2. XID在微服务调用链路上下文中传播
> 3. RM向TC注册分支事务，将其纳入XID对应全局事务的管辖
> 4. TM向TC发起针对XID的全局提交或回滚
> 5. TC调度XID下管辖的全部分支完成提交或回滚



## 安装

> 官网下载并解压

> 修改conf中的file.conf，修改自定义事务组名称，事务日志存储模式为db，数据库连接信息
>
> 第一处在service模块中，将vgroup_mapping.my_test_tx_group = "default"，default改为任意值
>
> 第二处在store模块中，将mode = "file"，file改为db
>
> 第三处在第二处下面，在db子模块中配置数据库连接信息

> 在数据库中新建数据库seata
>
> 运行conf文件夹中db_store.sql建表脚本

> 修改conf目录中的registry.conf文件
>
> type改为nacos
>
> nacos中serverAddr改为相应的，比如localhost:8848



## 案例

> 创建三个微服务，订单，库存，账户
>
> 用户下单时，在订单中创建，通过远程调用库存服务减库存
>
> 再通过远程调用账户来扣余额
>
> 最后在订单服务中修改状态为已完成



### 数据库准备

> seata_order：存储订单
>
> seata_storage：存储库存
>
> seata_account：存储账户

```mysql
create database seata_order;
create database seata_storage;
create database seata_account;

use seata_order;
CREATE TABLE t_order(
    id BIGINT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    user_id BIGINT(11) DEFAULT NULL COMMENT '用户id',
    product_id BIGINT(11) DEFAULT NULL COMMENT '产品id',
    count INT(11) DEFAULT NULL COMMENT '数量',
    money DECIMAL(11,0) DEFAULT NULL COMMENT '金额',
    status INT(1) DEFAULT NULL COMMENT '订单状态：0创建中，1已完结'
)ENGINE=InnoDB AUTO_INCREMENT=7 CHARSET=utf8;

USE seata_account;
CREATE TABLE t_account(
    id BIGINT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    user_id BIGINT(11) DEFAULT NULL COMMENT '用户id',
    total DECIMAL(10,0) DEFAULT NULL COMMENT '总额度',
    used DECIMAL(10,0) DEFAULT NULL COMMENT '已用额度',
    residue DECIMAL(10,0) DEFAULT 0 COMMENT '剩余可用额度'
)ENGINE=InnoDB AUTO_INCREMENT=7 CHARSET=utf8;
INSERT INTO t_account(id, user_id, total, used, residue) VALUES(1,1,1000,0,1000);

USE seata_storage;
CREATE TABLE t_storage(
    id BIGINT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY ,
    product_id BIGINT(11) DEFAULT NULL COMMENT '产品id',
    total INT(11) DEFAULT NULL COMMENT '总库存',
    used INT(11) DEFAULT NULL COMMENT '已用库存',
    residue INT(11) DEFAULT NULL COMMENT '剩余库存'
)ENGINE=InnoDB AUTO_INCREMENT=7 CHARSET=utf8;
INSERT INTO t_storage(id, product_id, total, used, residue) VALUES(1,1,100,0,100);
```

> 创建三个库各自的回滚日志表
>
> 在conf目录中有db_undo_log.sql



### 微服务准备

#### order-module

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

    <artifactId>seata-order-service2001</artifactId>

    <dependencies>
        <!--nacos-->
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
        </dependency>
        <!--seata-->
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-seata</artifactId>
            <exclusions>
                <exclusion>
                    <groupId>io.seata</groupId>
                    <artifactId>seata-all</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
        <dependency>
            <groupId>io.seata</groupId>
            <artifactId>seata-all</artifactId>
            <version>1.0.0</version>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid-spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
        <!--jdbc-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jdbc</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
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
        <dependency>
            <groupId>cn.hutool</groupId>
            <artifactId>hutool-captcha</artifactId>
            <version>5.2.0</version>
        </dependency>
    </dependencies>

</project>
```

```yaml
server:
  port: 2001

spring:
  application:
    name: seata-order-service
  cloud:
    alibaba:
      seata:
        tx-service-group: my_tx_group
    nacos:
      discovery:
        server-addr: 127.0.0.1:8848
  datasource:
    # 当前数据源操作类型
    type: com.alibaba.druid.pool.DruidDataSource
    driver-class-name: com.mysql.jdbc.Driver
    url: jdbc:mysql://localhost:3306/seata_order?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=GMT%2B8
    username: root
    password: 1234
feign:
  hystrix:
    enabled: false
logging:
  level:
    io:
      seata: info

mybatis:
  mapper-locations: classpath*:mapper/*.xml
```

> 将file.conf粘到resources目录下，修改为这样
>
> ```
> vgroup_mapping.my_tx_group = "default"
> ```

> 将registry.conf粘到resources目录下，不用修改

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class CommonResult<T> {

    private Integer code;
    private String message;
    private T data;

    public CommonResult(Integer code, String message){
        this(code,message,null);
    }
}
```

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Order {
    private Long id;
    private Long userId;
    private Long productId;
    private Integer count;
    private BigDecimal money;
    private Integer status;
}
```

> 两个entity

```java
@Mapper
public interface OrderDao {
    //新建订单
    void create(Order order);

    //修改订单状态
    void update(@Param("userId") Long userId,@Param("status") Integer status);
}
```

> dao接口

```xml
<mapper namespace="com.augus.springcloudalibaba.dao.OrderDao">
    
    <resultMap id="BaseResultMap" type="com.augus.springcloudalibaba.entity.Order">
        <id column="id" property="id" jdbcType="BIGINT"/>
        <result column="user_id" property="userId" jdbcType="BIGINT"/>
        <result column="product_id" property="productId" jdbcType="BIGINT"/>
        <result column="count" property="count" jdbcType="INTEGER"/>
        <result column="money" property="money" jdbcType="DECIMAL"/>
        <result column="status" property="status" jdbcType="INTEGER"/>
    </resultMap>

    <insert id="create">
        insert into t_order(id,user_id,product_id,count,money,status)
        values(null,#{userId},#{productId},#{count},#{money},0)
    </insert>
    
    <update id="update">
        update t_order set status = 1 where user_id = #{userId} and status=#{status}
    </update>
</mapper>
```

> dao对应的mapper

```java
@FeignClient(value = "seata-account-service")
public interface AccountService {

    @PostMapping(value = "/account/decrease")
    CommonResult decrease(@RequestParam("userId")Long userId, @RequestParam("money") BigDecimal money);
}
```

```java
@FeignClient(value = "seata-storage-service")
public interface StorageService {

    @PostMapping(value = "/storage/decrease")
    CommonResult decrease(@RequestParam("productId")Long productId,@RequestParam("count")Integer count);
}
```

> 两个调用其他微服务的service接口

```java
public interface OrderService {
    void create(Order order);
}
```

```java
@Service
@Slf4j
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderDao orderDao;
    @Autowired
    private StorageService storageService;
    @Autowired
    private AccountService accountService;


    @Override
    public void create(Order order) {
        log.info("------开始创建订单");
        orderDao.create(order);

        log.info("------调用库存减法");
        storageService.decrease(order.getProductId(),order.getCount());
        log.info("------调用库存减法完成");

        log.info("------调用账户扣余额");
        accountService.decrease(order.getUserId(),order.getMoney());
        log.info("------调用账户扣余额完成");

        log.info("------修改订单状态");
        orderDao.update(order.getUserId(),0);
        log.info("------修改订单状态完成");

        log.info("------创建订单完成");

    }
}
```

> 本地业务接口与实现

```java
@RestController
public class OrderController {

    @Autowired
    private OrderService orderService;

    @GetMapping("/order/create")
    public CommonResult create(Order order){
        orderService.create(order);
        return new CommonResult(200,"订单创建成功");
    }
}
```

> controller

```java
@Configuration
@MapperScan({"com.augus.springcloudalibaba.dao"})
public class MyBatisConfig {
}
```

```java
@Configuration
public class DataSourceProxyConfig {

    @Value("${mybatis.mapper-locations}")
    private String mapperLocations;

    @Bean
    @ConfigurationProperties(prefix = "spring.datasource")
    public DataSource druidDataSource(){
        return new DruidDataSource();
    }

    @Bean
    public DataSourceProxy dataSourceProxy(DataSource dataSource){
        return new DataSourceProxy(dataSource);
    }

    @Bean
    public SqlSessionFactory sqlSessionFactoryBean(DataSourceProxy dataSourceProxy) throws Exception{
        SqlSessionFactoryBean bean = new SqlSessionFactoryBean();
        bean.setDataSource(dataSourceProxy);
        ResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        bean.setMapperLocations(resolver.getResources(mapperLocations));

        SqlSessionFactory factory;
        try {
            factory = bean.getObject();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return factory;
    }
}
```

> 两个配置类

```java
@SpringBootApplication(exclude = DataSourceAutoConfiguration.class)
@EnableDiscoveryClient
@EnableFeignClients
public class SeataOrderMainApp2001 {
    public static void main(String[] args) {
        SpringApplication.run(SeataOrderMainApp2001.class,args);
    }
}
```

> 主启动，排除数据源的自动装配，使用我们自己的配置类与seata绑定

#### storage-module

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

    <artifactId>seata-storage-service2002</artifactId>

    <dependencies>
        <!--nacos-->
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
        </dependency>
        <!--seata-->
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-seata</artifactId>
            <exclusions>
                <exclusion>
                    <groupId>io.seata</groupId>
                    <artifactId>seata-all</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
        <dependency>
            <groupId>io.seata</groupId>
            <artifactId>seata-all</artifactId>
            <version>0.9.0</version>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid</artifactId>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
        <!--jdbc-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jdbc</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
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
        <dependency>
            <groupId>cn.hutool</groupId>
            <artifactId>hutool-captcha</artifactId>
            <version>5.2.0</version>
        </dependency>
    </dependencies>

</project>
```

```yaml
server:
  port: 2002

spring:
  application:
    name: seata-storage-service
  cloud:
    alibaba:
      seata:
        tx-service-group: my_tx_group
    nacos:
      discovery:
        server-addr: 127.0.0.1:8848
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    driver-class-name: com.mysql.jdbc.Driver
    url: jdbc:mysql://localhost:3306/seata_storage?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=GMT%2B8
    username: root
    password: 1234
feign:
  hystrix:
    enabled: false
logging:
  level:
    io:
      seata: info

mybatis:
  mapper-locations: classpath*:mapper/*.xml
```

> file.conf和registry.conf直接从order粘贴过来

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Storage {
    private Long id;
    private Long productId;
    private Integer total;
    private Integer used;
    private Integer residue;
}
```

> CommonResult直接粘

```
@Mapper
public interface StorageDao {
    void decrease(@Param("productId") Long productId,@Param("count") Integer count);
}
```

```xml
<mapper namespace="com.augus.springcloudalibaba.dao.StorageDao">

    <resultMap id="BaseResultMap" type="com.augus.springcloudalibaba.entity.Storage">
        <id column="id" property="id" jdbcType="BIGINT"></id>
        <result column="product_id" property="productId" jdbcType="BIGINT"></result>
        <result column="total" property="total" jdbcType="INTEGER"></result>
        <result column="used" property="used" jdbcType="INTEGER"></result>
        <result column="residue" property="residue" jdbcType="INTEGER"></result>
    </resultMap>

    <update id="decrease">
        update t_storage
        set used = used + #{count},residue = residue - #{count}
        where product_id=#{productId};
    </update>
    
</mapper>
```

> dao和mapping

```java
public interface StorageService {
    void decrease(Long productId,Integer count);
}
```

```java
@Service
public class StorageServiceImpl implements StorageService {

    @Autowired
    private StorageDao storageDao;

    @Override
    public void decrease(Long productId, Integer count) {
        storageDao.decrease(productId,count);
    }
}
```

> service层

```java
@RestController
public class StorageController {

    @Autowired
    private StorageService storageService;

    @RequestMapping("/storage/decrease")
    public CommonResult decrease(Long productId, Integer count){
        storageService.decrease(productId,count);
        return new CommonResult(200,"扣减库存成功");
    }
}
```

> controller

> config直接从order中粘贴那两个类

```java
@SpringBootApplication(exclude = DataSourceAutoConfiguration.class)
@EnableDiscoveryClient
@EnableFeignClients
public class SeataStorageServiceApplication2002 {
    public static void main(String[] args) {
        SpringApplication.run(SeataStorageServiceApplication2002.class,args);
    }
}
```

> 主启动



#### account-module

> 该粘贴的粘贴，只写不一样的部分

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Account {
    private Long id;
    private Long userId;
    private Integer total;
    private Integer used;
    private Integer residue;
}
```

> Account的entity

```java
@Mapper
public interface AccountDao {
    void decrease(@Param("userId") Long userId, @Param("money") BigDecimal money);
}
```

```xml
<mapper namespace="com.augus.springcloudalibaba.dao.AccountDao">
    <update id="decrease">
        update t_account set residue = residue- #{money},used = used + #{money}
        where user_id =#{userId};
    </update>
</mapper>
```

> dao和mapper

```java
public interface AccountService {
    void decrease(@RequestParam("userId") Long userId, @RequestParam("money") BigDecimal money);
}
```

```java
@Service
public class AccountServiceImpl implements AccountService {

    @Autowired
    AccountDao accountDao;

    @Override
    public void decrease(Long userId, BigDecimal money) {
        accountDao.decrease(userId,money);
    }
}
```

> service

```java
@RestController
public class AccountController {

    @Autowired
    AccountService accountService;

    @RequestMapping("/account/decrease")
    public CommonResult decrease(@RequestParam("userId") Long userId, @RequestParam("money") BigDecimal money){
        accountService.decrease(userId,money);
        return new CommonResult(200,"扣减账户余额成功");
    }
}
```

> controller

```java
@SpringBootApplication(exclude = DataSourceAutoConfiguration.class)
@EnableDiscoveryClient
@EnableFeignClients
public class SeataAccountMainApp2003 {
    public static void main(String[] args) {
        SpringApplication.run(SeataAccountMainApp2003.class,args);
    }
}
```

> 主启动



### 测试

> localhost:2001/order/create?userId=1&productId=1&count=10&money=100
>
> 三张表都正确的更新了

```java
@Service
public class AccountServiceImpl implements AccountService {

    @Autowired
    AccountDao accountDao;

    @Override
    public void decrease(Long userId, BigDecimal money) {
        try {
            TimeUnit.SECONDS.sleep(20);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        accountDao.decrease(userId,money);
    }
}
```

> 让account直接休眠20秒来模拟超时异常
>
> 再次访问，发现库存减了，订单还是0状态，余额也没减



### 解决

```java
@Service
@Slf4j
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderDao orderDao;
    @Autowired
    private StorageService storageService;
    @Autowired
    private AccountService accountService;


    @Override
    @GlobalTransactional(name = "my-create-order",rollbackFor = Exception.class)
    public void create(Order order) {
        log.info("------开始创建订单");
        orderDao.create(order);

        log.info("------调用库存减法");
        storageService.decrease(order.getProductId(),order.getCount());
        log.info("------调用库存减法完成");

        log.info("------调用账户扣余额");
        accountService.decrease(order.getUserId(),order.getMoney());
        log.info("------调用账户扣余额完成");

        log.info("------修改订单状态");
        orderDao.update(order.getUserId(),0);
        log.info("------修改订单状态完成");

        log.info("------创建订单完成");

    }
}
```

> 只需要在业务上方加入@GlobalTransactional注解，name随便起，唯一即可

> 再次测试
>
> 发现所有事务都回滚了，没有任何改变，全局事务已经生效





