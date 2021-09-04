# Hystrix

> Hystrix已经停止更新，但它的理念是服务降级教科书般的存在，学习他方便我们理解其他服务降级

> 分布式面临的问题
>
> 复杂分布式体系结构中的应用程序有数十个依赖关系，每个依赖关系在某些时候将不可避免的失败

> 服务雪崩
>
> 多个微服务之间调用的时候，假设微服务A调用微服务B和C，B和C又调用其他微服务，这被称作“扇出”
>
> 如果扇出的链路上，某个微服务响应时间过长，或不可用。对微服务A的调用就会占用越来越多的资源，进而引起系统崩溃，这就是“雪崩效应”

> 对于高流量应用来说，单一的后端依赖可能导致所有服务器上的所有资源在几秒钟以内饱和
>
> 比失败更糟糕的是，这些应用还可能导致服务延迟增加，备份队列，线程和其他资源紧张。导致整个系统发生更多的级联故障。这些都需要对故障进行隔离和管理，以便单个依赖关系的失败，不能导致整个系统的崩溃

> Hystrix是一个用于处理分布式系统延迟和容错的开源库
>
> Hystrix能保证在一个依赖出问题的情况下，不会导致整体服务失败，避免级联故障，提高分布式弹性

> 断路器
>
> 断路器本身是一种开关装置，当某个服务单元发生故障之后。通过故障监控，向调用方法返回一个符合预期的、可处理的备选响应。而不是长时间等待或者抛出异常
>
> 这样就保证了服务调用方的线程不会被长时间，不必要的占用，从而避免了故障在分布式系统中的蔓延，乃至雪崩

## 重要概念

### 服务降级

> 服务器忙，请稍后再试
>
> 不让客户端等待，立刻返回一个友好的提示

> 哪些情况会出现服务降级
>
> - 程序运行异常
> - 超时
> - 服务熔断触发服务降级
> - 线程池 / 信号量打满

### 服务熔断

> 类比保险丝达到最大访问后，直接拒绝访问，然后调用服务降级方法返回友好提示

### 服务限流

> 秒杀，高并发等操作
>
> 严禁一窝蜂的过来拥挤
>
> 进行排队，一秒钟n个，有序执行

## 案例

### 服务端

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

    <artifactId>cloud-provider-hystrix-payment8001</artifactId>

    <dependencies>
        <!--hystrix-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
        </dependency>
        <!--eureka client-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
        <!--web-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <!--引入自定义的api通用包，可用使用Payment支付Entity-->
        <dependency>
            <groupId>com.augus</groupId>
            <artifactId>cloud-api-commons</artifactId>
            <version>1.0-SNAPSHOT</version>
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
    name: cloud-provider-hystrix-payment

eureka:
  client:
    register-with-eureka: true
    fetch-registry: true
    service-url:
      defaultZone: http://eureka7001.com:7001/eureka
```

#### 主启动

```java
@SpringBootApplication
@EnableEurekaClient
public class PaymentHystrixMain8001 {
    public static void main(String[] args) {
        SpringApplication.run(PaymentHystrixMain8001.class,args);
    }
}
```

#### 业务类

```java
@Service
public class PaymentService {
    //正常访问，没问题的方法
    public String paymentInfo_OK(Integer id){
        return "线程池：" + Thread.currentThread().getName() + "paymentInfo_OK, id:" + id;
    }


    public String paymentInfo_TimeOut(Integer id){
        int timeNumber = 3;
        try {
            TimeUnit.SECONDS.sleep(timeNumber);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return "线程池：" + Thread.currentThread().getName() + "paymentInfo_TimeOut, id:" + id + "\t耗时：" + timeNumber + "s";
    }
}
```

```java
@RestController
@Slf4j
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @Value("${server.port}")
    private String serverPort;

    @GetMapping("/payment/hystrix/ok/{id}")
    public String paymentInfo_OK(@PathVariable("id") Integer id){
        String result = paymentService.paymentInfo_OK(id);
        log.info("result :" + result);
        return result;
    }

    @GetMapping("/payment/hystrix/timeout/{id}")
    public String paymentInfo_TimeOut(@PathVariable("id") Integer id){
        String result = paymentService.paymentInfo_TimeOut(id);
        log.info("result :" + result);
        return result;
    }
}
```



### 消费端

#### pom

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

    <artifactId>cloud-consumer-feign-hystrix-order80</artifactId>

    <dependencies>
        <!--openfeign-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>
        <!--hystrix-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
        </dependency>
        <!--eureka client-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
        <!--引入自定义的api通用包，可以使用Payment支付Entity-->
        <dependency>
            <groupId>com.augus</groupId>
            <artifactId>cloud-api-commons</artifactId>
            <version>1.0-SNAPSHOT</version>
        </dependency>
        <!--web-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <!--一般通用配置-->
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

#### yml

```yaml
server:
  port: 80

eureka:
  client:
    register-with-eureka: false
    service-url:
      defaultZone: http://localhost:7001/eureka/
```

#### 主启动

```java
@SpringBootApplication
@EnableFeignClients
public class OrderHystrixMain80 {
    public static void main(String[] args) {
        SpringApplication.run(OrderHystrixMain80.class,args);
    }
}
```

#### 业务类

```java
@Component
@FeignClient(value = "CLOUD-PROVIDER-HYSTRIX-PAYMENT")
public interface PaymentHystrixService {

    @GetMapping("/payment/hystrix/ok/{id}")
    public String paymentInfo_OK(@PathVariable("id") Integer id);

    @GetMapping("/payment/hystrix/timeout/{id}")
    public String paymentInfo_TimeOut(@PathVariable("id") Integer id);
}
```

```java
@RestController
@Slf4j
public class PaymentHystrixController {

    @Autowired
    private PaymentHystrixService paymentHystrixService;

    @GetMapping("/consumer/payment/hystrix/ok/{id}")
    public String paymentInfo_OK(@PathVariable("id") Integer id){
        String result = paymentHystrixService.paymentInfo_OK(id);
        return result;
    }

    @GetMapping("/consumer/payment/hystrix/timeout/{id}")
    public String paymentInfo_TimeOut(@PathVariable("id") Integer id){
        String result = paymentHystrixService.paymentInfo_TimeOut(id);
        return result;
    }
}
```

### 故障现象

> 如果我们进行多并发压力测试，会发现原本秒刷新的ok，也会变得开始卡顿，甚至崩溃

> 8001超时，调用者80不能一直等待，必须有服务降级
>
> 8001宕机，调用者80不能一直等待，必须有服务降级
>
> 8001正常，调用者80自己出现故障或有自己的需求，自己处理降级



## 服务降级

### 服务侧

> 设置自身调用超时的峰值，峰值内可以正常运行
>
> 超过峰值做服务降级

```java
package com.augus.springcloud.service;

import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
import com.netflix.hystrix.contrib.javanica.annotation.HystrixProperty;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
public class PaymentService {
    //正常访问，没问题的方法
    public String paymentInfo_OK(Integer id){
        return "线程池：" + Thread.currentThread().getName() + "paymentInfo_OK, id:" + id;
    }


    @HystrixCommand(fallbackMethod = "paymentInfo_TimeOutHandler",commandProperties = {
            @HystrixProperty(name = "execution.isolation.thread.timeoutInMilliseconds",value = "3000")
    })
    public String paymentInfo_TimeOut(Integer id){
        int timeNumber = 5;
        try {
            TimeUnit.SECONDS.sleep(timeNumber);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return "线程池：" + Thread.currentThread().getName() + "paymentInfo_TimeOut, id:" + id + "\t耗时：" + timeNumber + "s";
    }

    public String paymentInfo_TimeOutHandler(Integer id){
        return "线程池：" + Thread.currentThread().getName() + "paymentInfo_TimeOutHandler, id:" + id + "\t兜底方法";
    }


}
```

> 在Timeout上加入HystrixCommand注解
>
> 并将休眠时间改为5秒以演示效果

```java
@HystrixCommand(fallbackMethod = "paymentInfo_TimeOutHandler",commandProperties = {
            @HystrixProperty(name = "execution.isolation.thread.timeoutInMilliseconds",value = "3000")
    })
```

> 为其指定兜底方法的方法名fallbackMethod = "paymentInfo_TimeOutHandler"
>
> 以及其配置信息commandProperties = {@HystrixProperty(name = "execution.isolation.thread.timeoutInMilliseconds",value = "3000")}
>
> 这个配置信息表示，超过3000毫秒就认为应该进行服务降级

```java
@SpringBootApplication
@EnableEurekaClient
@EnableCircuitBreaker
public class PaymentHystrixMain8001 {
    public static void main(String[] args) {
        SpringApplication.run(PaymentHystrixMain8001.class,args);
    }
}
```

> 在主启动类上加入@EnableCircuitBreaker，注册服务降级

> 此时我们访问timeout，等待三秒后，自动输出兜底方法
>
> 服务降级已经配置成功
>
> 如果我们在timeout中加入10/0，直击报错
>
> 发现服务降级也可以正常触发



### 客户端

```yaml
feign:
  hystrix:
    enabled: true
```

> 在配置文件中开启此功能

```java
@SpringBootApplication
@EnableFeignClients
@EnableHystrix
public class OrderHystrixMain80 {
    public static void main(String[] args) {
        SpringApplication.run(OrderHystrixMain80.class,args);
    }
}
```

> 在主启动类加入@EnableHystrix注解

```java
@RestController
@Slf4j
public class PaymentHystrixController {

    @Autowired
    private PaymentHystrixService paymentHystrixService;

    @GetMapping("/consumer/payment/hystrix/ok/{id}")
    public String paymentInfo_OK(@PathVariable("id") Integer id){
        String result = paymentHystrixService.paymentInfo_OK(id);
        return result;
    }

    @GetMapping("/consumer/payment/hystrix/timeout/{id}")
    @HystrixCommand(fallbackMethod = "PaymentTimeOutFallbackMethod",commandProperties = {
            @HystrixProperty(name = "execution.isolation.thread.timeoutInMilliseconds",value = "1500")
    })
    public String paymentInfo_TimeOut(@PathVariable("id") Integer id){
        String result = paymentHystrixService.paymentInfo_TimeOut(id);
        return result;
    }

    public String PaymentTimeOutFallbackMethod(@PathVariable("id") Integer id){
        return "80发现，对方系统繁忙，请稍后再试";
    }
}
```

> 为其方法也添加相应的配置，这里我们将超时设置为1.5秒，来显示消费端对自己的要求



### 注意事项

> devTools对java代码改动很敏感，可以实现热部署
>
> 但是对于@HystrixCommand注解内的改动不敏感，推荐手动重启服务



### 存在问题

> 目前我们发现，每一个方法都需要一个兜底方法，造成代码膨胀
>
> 而且他们全部在同一个文件中，没有进行分别



### 代码膨胀解决

```java
@RestController
@Slf4j
@DefaultProperties(defaultFallback = "payment_Global_FallbackMethod")
public class PaymentHystrixController {

    @Autowired
    private PaymentHystrixService paymentHystrixService;

    @GetMapping("/consumer/payment/hystrix/ok/{id}")
    public String paymentInfo_OK(@PathVariable("id") Integer id){
        String result = paymentHystrixService.paymentInfo_OK(id);
        return result;
    }

    @GetMapping("/consumer/payment/hystrix/timeout/{id}")
    @HystrixCommand
    public String paymentInfo_TimeOut(@PathVariable("id") Integer id){
        String result = paymentHystrixService.paymentInfo_TimeOut(id);
        return result;
    }

    public String PaymentTimeOutFallbackMethod(@PathVariable("id") Integer id){
        return "80发现，对方系统繁忙，请稍后再试";
    }

    public String payment_Global_FallbackMethod(){
        return "全局异常处理，请稍后再试";
    }
}
```

> 在类上使用@DefaultProperties(defaultFallback = "payment_Global_FallbackMethod")指定默认兜底方法
>
> 在需要兜底的函数上使用@HystrixCommand
>
> 如果像之前一样配置了详细的配置，则优先使用详细配置的



### 代码混乱解决

```java
@Component
public class PaymentFallbackService implements PaymentHystrixService{
    @Override
    public String paymentInfo_OK(Integer id) {
        return "-----PaymentFallbackService类调用paymentInfo_OK兜底方法";
    }

    @Override
    public String paymentInfo_TimeOut(Integer id) {
        return "-----PaymentFallbackService类调用paymentInfo_TimeOut兜底方法";
    }
}
```

> 新建一个类，实现feign接口

```java
@Component
@FeignClient(value = "CLOUD-PROVIDER-HYSTRIX-PAYMENT",fallback = PaymentFallbackService.class)
public interface PaymentHystrixService {

    @GetMapping("/payment/hystrix/ok/{id}")
    public String paymentInfo_OK(@PathVariable("id") Integer id);

    @GetMapping("/payment/hystrix/timeout/{id}")
    public String paymentInfo_TimeOut(@PathVariable("id") Integer id);
}
```

> 在feign接口中增加一个配置，fallback = PaymentFallbackService.class
>
> 为其指定降级的方法所在类

> 我们将8001关闭，模拟宕机
>
> 发现ok方法兜底被执行了



## 服务熔断

> 熔断机制是应对雪崩效应的一种微服务链路保护机制
>
> 当扇出的某个微服务出错不可用或响应时间太长
>
> 会进行服务降级，进而熔断该节点的调用，快速返回错误响应信息
>
> 当检查到该节点响应正常后，恢复链路调用

```java
@Service
public class PaymentService {
    //正常访问，没问题的方法
    public String paymentInfo_OK(Integer id){
        return "线程池：" + Thread.currentThread().getName() + "paymentInfo_OK, id:" + id;
    }


    @HystrixCommand(fallbackMethod = "paymentInfo_TimeOutHandler",commandProperties = {
            @HystrixProperty(name = "execution.isolation.thread.timeoutInMilliseconds",value = "3000")
    })
    public String paymentInfo_TimeOut(Integer id){
//        int i = 10 / 0;
        try {
            TimeUnit.MILLISECONDS.sleep(5000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return "线程池：" + Thread.currentThread().getName() + "paymentInfo_TimeOut, id:" + id + "\t 正常访问";
    }

    public String paymentInfo_TimeOutHandler(Integer id){
        return "线程池：" + Thread.currentThread().getName() + "8001服务繁忙，稍后再试，兜底方法";
    }

    //=========================服务熔断==============================
    @HystrixCommand(fallbackMethod = "paymentCircuitBreaker_fallback",commandProperties = {
            @HystrixProperty(name = "circuitBreaker.enabled",value = "true"),   //是否开启断路器
            @HystrixProperty(name = "circuitBreaker.requestVolumeThreshold",value = "10"),  //请求次数
            @HystrixProperty(name = "circuitBreaker.sleepWindowInMilliseconds",value = "10000"),    //时间窗口期
            @HystrixProperty(name = "circuitBreaker.errorThresholdPercentage",value = "60"),    //失败率达到多少后跳闸
    })
    public String paymentCircuitBreaker(@PathVariable("id") Integer id){
        if(id < 0){
            throw new RuntimeException("******id 不能为负数");
        }
        String serialNumber = IdUtil.simpleUUID();  //UUID.randomUUID();

        return Thread.currentThread().getName()+"\t"+"调用成功，流水号："+serialNumber;
    }
    public String paymentCircuitBreaker_fallback(@PathVariable("id") Integer id){
        return "id 不能负数，请稍后再试，兜底方法，id："+id;
    }

}
```

> 此配置表示，在10秒以内（时间窗口期），10次请求中（请求次数）有60%失败率，则触发跳闸

```java
//服务熔断
@GetMapping("/payment/circuit/{id}")
public String paymentCircuitBreaker(@PathVariable("id") Integer id){
    String result = paymentService.paymentCircuitBreaker(id);
    return result;
}
```

> 在controller中新增方法调用

> 我们不停地向8001发送负数id的请求，然后发一个正常的请求会发现已经不能访问了，已经触发了断路器
>
> 过一会儿再发送正确的请求发现又可以访问了，链路调用恢复了



### 总结

> 熔断类型分为三种
>
> 熔断打开：请求不再调用当前服务，内部设置时钟一般为MTTR（平均故障处理时间），当打开时长到达所设定时钟，则进入熔断半开状态
>
> 熔断关闭：不会对服务进行熔断
>
> 熔断半开：部分请求根据规则调用服务，如果请求成功且符合规则，则认定当前服务恢复正常，关闭熔断

> 断路器三个重要参数：
>
> 快照时间窗：断路器确定是否打开统计一些请求和错误数据，而统计的时间范围就是快照时间窗，默认为最近的10秒
>
> 请求总数阈值：在快照时间窗内，必须满足请求总数阈值才有资格熔断，默认为20，意味着在10秒内，如果该Hystrix命令调用不足20次，即使所有请求都失败，断路器也不会打开
>
> 错误百分比阈值：当请求数在快照时间窗内超过了阈值，比如30次。在这30次中，有15次请求失败，超过50%的错误比，在默认50%的阈值情况下，断路器将会打开

> 当断路器开启，5秒钟后（默认值）。断路器会进入半开状态，会让其中一个请求进入服务器，如果此请求成功执行，则关闭断路器。如果失败继续保持开启状态，并且等待下一个5秒后尝试

> 断路器打开之后，将不会调用主逻辑，而是调用降级方法



## 服务限流

> 将在之后alibaba的Sentinel中进行学习



## Dashboard监控页面

> Hystrix提供了准实时的调用监控，会持续的记录所有通过Hystrix发起请求的执行信息，并以报表和图形的形式展示给用户，包括每秒执行多少请求成功，多少请求失败等



### POM

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

    <artifactId>cloud-consumer-hystrix-dashboard9001</artifactId>

    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-hystrix-dashboard</artifactId>
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



### YML

```yaml
server:
  port: 9001
```



### 主启动

```java
@SpringBootApplication
@EnableHystrixDashboard
public class HystrixDashboardMain9001 {
    public static void main(String[] args) {
        SpringApplication.run(HystrixDashboardMain9001.class,args);
    }
}
```

> 使用@EnableHystrixDashboard注解开启HystrixDashboard



### 被监控端

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

> 注意，所有被监控的组件，都需要有此依赖，他是SpringBoot提供的监控功能
>
> 之前我们已经都导入过

```java
@SpringBootApplication
@EnableEurekaClient
@EnableCircuitBreaker
public class PaymentHystrixMain8001 {
    public static void main(String[] args) {
        SpringApplication.run(PaymentHystrixMain8001.class,args);
    }

    //此配置为了解决ServletRegistrationBean默认路径不是/hystrix.stream
    @Bean
    public ServletRegistrationBean getServlet(){
        HystrixMetricsStreamServlet streamServlet = new HystrixMetricsStreamServlet();
        ServletRegistrationBean registrationBean = new ServletRegistrationBean(streamServlet);
        registrationBean.setLoadOnStartup(1);
        registrationBean.addUrlMappings("/hystrix.stream");
        registrationBean.setName("HystrixMetricsStreamServlet");
        return registrationBean;
    }
}
```

> 在主启动类中加入这些代码



### 访问

> http://localhost:9001/hystrix
>
> 在地址栏填写http://localhost:8001/hystrix.stream
>
> Delay填写延迟
>
> Title填写一个名称



