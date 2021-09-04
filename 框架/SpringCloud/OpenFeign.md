# OpenFeign

> OpenFeign是一个声明式的web服务客户端，让编写web服务客户端变得容易，只需要创建接口，并在上面添加注解

> 以前使用 Ribbon + RestTemplate 时，利用 RestTemplate 对http进行封装
>
> 每个微服务就需要一个客户端去调用
>
> Feign在此基础上进行封装，我们只需要创建接口，就像Dao上面标注Mapper注解一样。即可完成接口绑定

> Feign集成了Ribbon



## 使用

### 改POM

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

    <artifactId>cloud-sonsumer-feign-order80</artifactId>

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
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
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
        <!--openfeign-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>
    </dependencies>

</project>
```

### 写配置

```yaml
server:
  port: 80

eureka:
  client:
    register-with-eureka: false
    service-url:
      defaultZone: http://eureka7001.com:7001/eureka,http://eureka7002.com:7002/eureka
```

### 主启动

```java
@SpringBootApplication
@EnableFeignClients
public class OrderFeignMain80 {
    public static void main(String[] args) {
        SpringApplication.run(OrderFeignMain80.class,args);
    }
}
```

> 这里使用@EnableFeignClients注释，开启Feign的客户端

### 业务类

```java
@Component
@FeignClient(value = "CLOUD-PAYMENT-SERVICE")
public interface PaymentFeignService {
    @GetMapping(value = "/payment/get/{id}")
    public CommonResult<Payment> getPaymentById(@PathVariable("id") Long id);
}
```

> 写一个Service接口
>
> 将要调用的目标Controller声明粘贴过来
>
> 并添加@FeignClient(value = "CLOUD-PAYMENT-SERVICE")注解，指定要访问哪个服务

```java
@RestController
@Slf4j
public class OrderFeignController {

    @Autowired
    private PaymentFeignService paymentFeignService;

    @GetMapping(value = "/consumer/payment/get/{id}")
    public CommonResult<Payment> getPaymentById(@PathVariable("id") Long id){
        return paymentFeignService.getPaymentById(id);
    }
}
```

> 在Controller中直接调用Service接口



## 超时控制

> OpenFeign默认等待1秒钟，超时会报错

```yaml
ribbon:
  ReadTimeout: 5000
  connectTimeout: 5000
```

> 在配置文件中添加这些内容，可以控制超时
>
> ReadTimeout: 指建立连接所用时间
>
> connectTimeout: 指建立连接后读取资源时间



## 日志功能

### 日志级别

> NONE：默认值
>
> BASIC：仅记录请求方法、URL、响应状态码和执行时间
>
> HEADERS：除了BASIC以外，还包含请求与响应头
>
> FULL：除了HEADERS以外，还包含请求和响应正文及元数据

```java
@Configuration
public class FeignConfig {
    @Bean
    Logger.Level feignLoggerLevel(){
        return Logger.Level.FULL;
    }
}
```

```yaml
logging:
  level:
    com.augus.springcloud.service.PaymentFeignService: debug
```

> 在配置文件中，定义监控哪个接口和打印方式

