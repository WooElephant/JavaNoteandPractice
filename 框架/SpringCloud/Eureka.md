# Eureka

> 此服务已经停止更新
>
> 但很多老项目依然再用
>
> 而且Eureka的思想是值得我们学习的，程序会淘汰，思想是相通的

> Eureka包含两个组件
>
> Eureka Server提供注册服务
>
> Eureka Client通过注册中心进行访问

## 单机构建

### server端

#### 改POM

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

    <artifactId>cloud-eureka-server7001</artifactId>

    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
        </dependency>
        <dependency>
            <groupId>com.augus</groupId>
            <artifactId>cloud-api-commons</artifactId>
            <version>${project.version}</version>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
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
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
        </dependency>
    </dependencies>
    
</project>
```

#### 写配置

```yaml
server:
  port: 7001
  
eureka:
  instance:
    hostname: localhost #服务端的实例名称
  client:
    register-with-eureka: false #不向服务中心注册自己
    fetch-registry: false #自己就是服务中心，不需要检索服务
    service-url:
      #设置Eureka Server交互的地址
      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
```

#### 主程序

```java
@SpringBootApplication
@EnableEurekaServer
public class EurekaMain7001 {
    public static void main(String[] args) {
        SpringApplication.run(EurekaMain7001.class,args);
    }
}
```

> @EnableEurekaServer
>
> 注明本服务是EurekaServer而不是client



### 注册服务

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
```

> 在payment的pom中加入eureka-client的依赖

```yaml
eureka:
  client:
    register-with-eureka: true  #将自己注册进Eureka Server
    fetch-registry: true  #是否从Eureka Server抓取已有注册信息，默认为true
    service-url: 
      defaultZone: http://localhost:7001/eureka
```

> 在yaml中加入Eureka的配置

```java
@SpringBootApplication
@EnableEurekaClient
public class PaymentMain8001 {
    public static void main(String[] args) {
        SpringApplication.run(PaymentMain8001.class,args);
    }
}
```

> 在主程序上加入@EnableEurekaClient注解



### 注册消费者

> pom引入Eureka client依赖
>
> 配置文件添加Eureka的配置
>
> 在主程序上加入@EnableEurekaClient注解
>
> 都和上面一致



## 集群构建

> 修改host文件
>
> 127.0.0.1 eureka7001.com
> 127.0.0.1 eureka7002.com

### 修改yml

```yaml
server:
  port: 7002
eureka:
  instance:
    hostname: eureka7002.com
  client:
    register-with-eureka: false
    fetch-registry: false
    service-url:
      defaultZone: http://eureka7001.com:7001/eureka/
```

```yaml
server:
  port: 7001
eureka:
  instance:
    hostname: eureka7001.com
  client:
    register-with-eureka: false
    fetch-registry: false
    service-url:
      defaultZone: http://eureka7002.com:7002/eureka/
```

> 让他们互相注册到对方



### 注册服务

```yaml
    service-url:
      defaultZone: http://eureka7001.com:7001/eureka,http://eureka7002.com:7002/eureka
#      defaultZone: http://localhost:7001/eureka
```

> 将yaml的注册配置，修改为两个值



## 服务的集群搭建

> 将服务的model复制一份
>
> 改个名，改个端口

### 改controller

```java
@RestController
@Slf4j
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @Value("${server.port}")
    private String serverPort;

    @PostMapping(value = "/payment/create")
    public CommonResult create(@RequestBody Payment payment){
        int result = paymentService.create(payment);
        log.info("插入结果：" + result);

        if (result > 0){
            return new CommonResult(200,"插入数据成功！执行端口号：" + serverPort,result);
        }else {
            return new CommonResult(444,"插入数据失败！",null);
        }
    }

    @GetMapping(value = "/payment/get/{id}")
    public CommonResult<Payment> getPaymentById(@PathVariable("id") Long id){
        Payment payment = paymentService.getPaymentById(id);
        log.info("查询结果：" + payment);

        if (payment != null){
            return new CommonResult(200,"查询成功！执行端口号：" + serverPort,payment);
        }else {
            return new CommonResult(444,"查询失败！查询id：" + id,null);
        }
    }

}
```

> 新增一个private String serverPort;
>
> 让我们能看出来访问的是哪一台服务器

### 改消费端写死的代码

```java
//    public static final String PAYMENT_URL = "http://localhost:8001";
public static final String PAYMENT_URL = "http://CLOUD-PAYMENT-SERVICE";
```

> 之前我们是指定ip访问，将其修改为微服务名称

```java
@Configuration
public class ApplicationContextConfig {
    @Bean
    @LoadBalanced
    public RestTemplate getRestTemplate(){
        return new RestTemplate();
    }
}
```

> 并在配置类中，添加@LoadBalanced注解，开启负载均衡



## 微服务信息完善

### 主机名称修改

```yaml
eureka:
  client:
    register-with-eureka: true
    fetch-registry: true
    service-url:
      defaultZone: http://eureka7001.com:7001/eureka,http://eureka7002.com:7002/eureka
  instance:
    instance-id: payment8001
```

> 在下方添加  instance.instance-id = payment8001



### 访问信息ip提示

```yaml
eureka:
  client:
    register-with-eureka: true
    fetch-registry: true
    service-url:
      defaultZone: http://eureka7001.com:7001/eureka,http://eureka7002.com:7002/eureka
  instance:
    instance-id: payment8001
    prefer-ip-address: true
```

> 在下方添加 prefer-ip-address = true



## 服务发现

> 对于注册进eureka中的服务，可以通过服务发现来获得服务信息

### controller

```java
@Autowired
private DiscoveryClient discoveryClient;

@GetMapping(value = "/payment/discovery")
public Object discovery(){
    List<String> services = discoveryClient.getServices();
    for (String service : services) {
        log.info("element:" + service);
    }

    List<ServiceInstance> instances = discoveryClient.getInstances("CLOUD-PAYMENT-SERVICE");
    for (ServiceInstance instance : instances) {
        log.info(instance.getServiceId() + "\t" + instance.getHost() + "\t" + instance.getPort() + "\t" + instance.getUri() );
    }

    return this.discoveryClient;
}
```

> 加入这些代码
>
> 可以获得全部服务，也可以获取一个服务的详细信息

### 主程序

```java
@SpringBootApplication
@EnableEurekaClient
@EnableDiscoveryClient
public class PaymentMain8001 {
    public static void main(String[] args) {
        SpringApplication.run(PaymentMain8001.class,args);
    }
}
```

> 加入@EnableDiscoveryClient标签



## 自我保护机制

> 保护模式主要用于一组客户端和Eureka Server之间存在网络分区场景下的保护
>
> Eureka Server会尝试保护其服务注册表中的信息，不在删除服务注册表中的数据，也就是不会注销任何微服务
>
> 简单来说就是，如果有一个微服务不能用了，Eureka不会立刻清理，依旧保存该服务的信息

### 禁用自我保护

#### server端

```yaml
eureka:
  instance:
    hostname: eureka7001.com
  client:
    register-with-eureka: false
    fetch-registry: false
    service-url:
      defaultZone: http://eureka7002.com:7002/eureka/
  server:
    enable-self-preservation: false
    eviction-interval-timer-in-ms: 2000
```

> 添加
>
> eureka.server.enable-self-preservation = false	关闭自我保护
>
> eureka.server.eviction-interval-timer-in-ms = 2000	设置弥留时间为2秒

#### client端

```yaml
eureka:
  client:
    register-with-eureka: true  #将自己注册进Eureka Server
    fetch-registry: true  #是否从Eureka Server抓取已有注册信息，默认为true
    service-url:
      defaultZone: http://eureka7001.com:7001/eureka,http://eureka7002.com:7002/eureka
  instance:
    instance-id: payment8001
    prefer-ip-address: true
    lease-renewal-interval-in-seconds: 1
    lease-expiration-duration-in-seconds: 2
```

> eureka.instance.lease-renewal-interval-in-seconds = 1	发送心跳间隔，默认是30，单位秒
>
> eureka.instance.lease-expiration-duration-in-seconds = 2	服务端等待时间上限，默认90，单位秒





