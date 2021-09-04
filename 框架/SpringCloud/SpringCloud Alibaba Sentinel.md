# SpringCloud Alibaba Sentinel

> 就是Hystrix的Alibaba版

## 安装

> Sentinel分为两个部分，后端和前端
>
> 在官网下载sentinel-dashboard的jar包
>
> 运行该jar包
>
> 访问localhost:8080
>
> 默认账号密码为sentinel



## Hello World

### Model

#### POM

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

    <artifactId>cloudalibaba-sentinel-service8401</artifactId>

    <dependencies>
        <!--springcloud alibaba nacos-->
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
        </dependency>
        <!--springcloud alibaba sentinel-datasource-nacos 后续做持久化用到-->
        <dependency>
            <groupId>com.alibaba.csp</groupId>
            <artifactId>sentinel-datasource-nacos</artifactId>
        </dependency>
        <!--springcloud alibaba sentinel-->
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-sentinel</artifactId>
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
            <groupId>com.augus</groupId>
            <artifactId>cloud-api-commons</artifactId>
            <version>1.0-SNAPSHOT</version>
        </dependency>
    </dependencies>

</project>
```

> 导入了sentinel-datasource-nacos与spring-cloud-starter-alibaba-sentinel
>
> 前者是后续做持久化会用到，这里先提前导入

#### YML

```yaml
server:
  port: 8401
  
spring:
  application:
    name: cloudalibaba-sentinel-service
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
    sentinel:
      transport:
        # sentinel dashboard 地址
        dashboard: localhost:8080
        # 默认为8719，如果被占用会自动+1，直到找到为止
        port: 8719
            
management:
  endpoints:
    web:
      exposure:
        include: "*"
```

#### 主启动

```java
@SpringBootApplication
@EnableDiscoveryClient
public class MainApp8401 {
    public static void main(String[] args) {
        SpringApplication.run(MainApp8401.class,args);
    }
}
```

#### 业务类

```java
@RestController
public class FlowLimitController {
    @GetMapping("/testA")
    public String testA(){
        return "--------testA";
    }

    @GetMapping("/testB")
    public String testB(){
        return "--------testB";
    }
}
```

### 测试

> 启动nacos8848与新模块8401
>
> http://localhost:8401/testA 访问正常
>
> 在sentinel页面中，也能看到该服务



## 流控规则

### 基本介绍

![image-20210903131240452](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210903131240452.png)

> 在sentinel左侧点击流控规则后，可以自己定义规则
>
> 也可以在簇点链路，对某一请求资源右侧直接点击流控，为其指定规则

> 资源名：唯一名称，默认请求路径

> 针对来源：Sentinel可以针对调用者进行限流，填写微服务名，默认default（不区分来源）

> 阈值类型/单机阈值：
>
> - QPS（每秒钟的请求数量）：当调用该API的QPS达到阈值时，进行限流
> - 线程数：当调用该API的线程数达到阈值时，进行限流

> 是否集群：不需要集群

> 流控模式：
>
> - 直接：API达到限流条件，直接限流
> - 关联：当关联资源达到阈值，限流自己
> - 链路：只记录指定链路上的流量（从入口资源进来的流量），如果达到阈值，就进行限流（API级别的针对来源）

> 流控效果：
>
> - 快速失败：直接失败，抛异常
> - Warm Up：根据codeFactor（冷加载因子，默认3）的值，从阈值/codeFactor，经过预热时长，才达到设定的QPS阈值
> - 排队等待：匀速排队，让请求以匀速的速度通过，阈值类型必须为QPS，否则无效



### 流控模式

#### 直接

![image-20210903132233381](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210903132233381.png)

> 为/testA指定QPS，阈值为1，模式为直接，效果为直接失败
>
> 我们慢一点访问/testA，1秒1次是正常访问的，一旦我们快速刷新，就无法访问

> 该效果为：1秒钟只允许1次请求

> 如果设置为线程数，则表示，不在服务器外设卡，改为服务器内部设卡
>
> 当我们将线程sleep 1秒，就会发现，也会报同样的错误被限流



#### 关联

![image-20210903133600218](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210903133600218.png)

> 这样的意思是，如果B出问题了，则将A限流
>
> 比如支付模块出问题了，就将下单模块限流

> 我们用工具密集访问B，每隔0.3秒访问一次，确保1秒内访问多次
>
> 再去访问A，发现A已经被限流了



#### 链路

> 这个东西有bug，老师没讲，官网配置也有问题，有些博客说跟版本也有关系



### 流控效果

> 快速失败我们就不说了，因为很简单，并且上面演示过了

#### Warm Up

> 当系统处于比较空闲的阶段，突然流量猛增容易将系统压垮
>
> 我们让流量缓慢增加，有个预热的过程

> 默认coldFactor为3，即QPS从阈值除以3开始，经过一定的时长，提升阈值至指定阈值

![image-20210903135930878](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210903135930878.png)

> 表示一开始，阈值为10/3 = 3QPS阈值，经过5秒，提升阈值至10



#### 排队等待

> 让请求以均匀的速度通过，阈值类型必须为QPS

![image-20210903140402925](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210903140402925.png)

> A每秒1次请求，超过就排队等待，等待的超时是20秒

> 主要用于间歇性突发流量，某一秒有大量流量，接下来几秒空闲，如此反复



## 降级规则

![image-20210903140906647](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210903140906647.png)

> RT（秒级）：
>
> 平均响应时间
>
> 平均响应时间超出阈值 且 在时间窗口内通过的请求大于等于5
>
> 两个条件同时满足后触发降级
>
> 窗口期过后关闭断路器
>
> RT最大为4900（更大的值需要通过-Dcsp.sentinel.statistic.max.rt=xxx来设置）

> 异常比例（秒级）：
>
> QPS 大于等于 5 且异常比例超过阈值，触发降级

> 异常数（分钟级）：
>
> 异常数超过阈值时，触发降级

> Sentenel的断路器是没有半开状态的



### RT

```java
@GetMapping("/testD")
public String testD(){
    try {
        TimeUnit.SECONDS.sleep(1);
    }catch (InterruptedException e){
        e.printStackTrace();
    }
    return "--------testD";
}
```

![image-20210903144042768](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210903144042768.png)

> 我们使用软件，1秒内访问10次
>
> 我们就会发现触发了熔断降级



### 异常比例

```java
@GetMapping("/testD")
public String testD(){
    int a = 10 / 0;
    return "--------testD";
}
```

![image-20210903150337762](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210903150337762.png)

> 我们使用软件，1秒内访问10次
>
> 我们就会发现触发了熔断降级



### 异常数

> 因为异常数是分钟级的，所以时间窗口最好设置大于60秒，不然可能会再次触发熔断

![image-20210903150845793](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210903150845793.png)



## 热点规则

### 代码

```java
@GetMapping("/testHotkey")
@SentinelResource(value = "testHotkey",blockHandler = "deal_testHotkey")
public String testHotkey(@RequestParam(value = "p1",required = false) String p1,
                         @RequestParam(value = "p1",required = false) String p2){
    return "--------testHotkey";
}

public String deal_testHotkey(String p1, String p2, BlockException e){
    return "--------deal_testHotkey,兜底方法";
}
```

> @SentinelResource(value = "testHotkey",blockHandler = "deal_testHotkey")
>
> value：是唯一标识即可，一般写的与访问路径一致
>
> blockHandler：设置兜底方法

### 配置

![image-20210903152631428](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210903152631428.png)

> 参数绑定第0个，也就是p1



### 测试

> http://localhost:8401/testHotkey?p1=a 当我们快速访问此地址，大于1秒1次，就会触发熔断，转而执行兜底方法

> 如果不设置兜底方法，则会显示异常界面
>
> 使用热点规则，要搭配兜底方法一起使用



### 高级选项

![image-20210903153413828](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210903153413828.png)

> 当p1的值为某个特定值时，我们希望它的规则不一样，这就是例外项

![image-20210903153901144](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210903153901144.png)

> 比如当p1=5时，阈值为200



## 系统规则

> 为整个系统指定限流规则

![image-20210903154319949](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210903154319949.png)

> - **Load 自适应**（仅对 Linux/Unix-like 机器生效）：系统的 load1 作为启发指标，进行自适应系统保护。当系统 load1 超过设定的启发值，且系统当前的并发线程数超过估算的系统容量时才会触发系统保护（BBR 阶段）。系统容量由系统的 `maxQps * minRt` 估算得出。设定参考值一般是 `CPU cores * 2.5`。
> - **CPU usage**（1.5.0+ 版本）：当系统 CPU 使用率超过阈值即触发系统保护（取值范围 0.0-1.0），比较灵敏。
> - **平均 RT**：当单台机器上所有入口流量的平均 RT 达到阈值即触发系统保护，单位是毫秒。
> - **并发线程数**：当单台机器上所有入口流量的并发线程数达到阈值即触发系统保护。
> - **入口 QPS**：当单台机器上所有入口流量的 QPS 达到阈值即触发系统保护。



## @SentinelResource

### 按资源名称限流

```java
@RestController
public class RateLimitController {

    @GetMapping("/byResource")
    @SentinelResource(value = "byResource",blockHandler = "handleException")
    public CommonResult byResource(){
        return new CommonResult(200,"测试通过",new Payment(1234L,"serial001"));
    }

    public CommonResult handleException(BlockException e){
        return new CommonResult(444,e.getClass().getCanonicalName() + "\t服务不可用");
    }

}
```

![image-20210903155832093](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210903155832093.png)

> 如果请求超过阈值，则进入兜底方法



### 按url地址限流

```java
@GetMapping("/rateLimit/byUrl")
@SentinelResource(value = "byUrl")
public CommonResult byUrl(){
    return new CommonResult(200,"Url测试通过",new Payment(1234L,"serial002"));
}
```

> 新添加一个方法，不填写兜底方法

![image-20210903160400805](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210903160400805.png)

> 这个就是我们最初看到的效果，使用url限流，并且显示默认的提示信息



### 以上方法面临的问题

> 1. 系统默认的，没有体现自定义的要求
> 2. 代码耦合
> 3. 每个方法都要有兜底，代码膨胀
> 4. 没有全局处理方法

> 在Hystrix中也遇到过这些问题



### 自定义限流处理逻辑

```java
public class CustomerBlockHandler {
    public static CommonResult handlerException(BlockException e){
        return new CommonResult(444,"自定义限流处理,全局兜底1");
    }
    public static CommonResult handlerException2(BlockException e){
        return new CommonResult(444,"自定义限流处理,全局兜底2");
    }
}
```

> 自定义一个类，来存放兜底方法

```java
@GetMapping("/rateLimit/customerBlockHandler")
@SentinelResource(value = "customerBlockHandler",
        blockHandlerClass = CustomerBlockHandler.class,
        blockHandler = "handlerException2")
public CommonResult customerBlockHandler(){
    return new CommonResult(200,"自定义限流处理测试通过",new Payment(1234L,"serial003"));
}
```

> 指定哪个类，哪个方法来处理兜底

![image-20210903161404368](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210903161404368.png)



## 服务熔断

### Ribbon整合

#### 服务端

> 服务提供者9003/9004

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

    <artifactId>cloudalibaba-provider-payment9003</artifactId>

    <dependencies>
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
        </dependency>
        <dependency>
            <groupId>com.augus</groupId>
            <artifactId>cloud-api-commons</artifactId>
            <version>1.0-SNAPSHOT</version>
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

```yaml
server:
  port: 9003

spring:
  application:
    name: nacos-payment-provider
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848

management:
  endpoints:
    web:
      exposure:
        include: '*'
```

```java
@SpringBootApplication
@EnableDiscoveryClient
public class PaymentMain9003 {
    public static void main(String[] args) {
        SpringApplication.run(PaymentMain9003.class,args);
    }
}
```

```java
@RestController
public class PaymentController {

    @Value("${server.port}")
    private String serverPort;

    public static HashMap<Long, Payment> hashMap = new HashMap<>();
    static {
        hashMap.put(1L,new Payment(1L,"serial001"));
        hashMap.put(2L,new Payment(2L,"serial002"));
        hashMap.put(3L,new Payment(3L,"serial003"));
    }

    @GetMapping("/paymentSQL/{id}")
    public CommonResult<Payment> paymentSQL(@PathVariable("id") Long id){
        Payment payment = hashMap.get(id);
        CommonResult<Payment> result = new CommonResult<>(200,"数据成功获取,port:" + serverPort);
        return result;
    }
}
```

#### 消费端

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

    <artifactId>cloudalibaba-consumer-nacos-order84</artifactId>

    <dependencies>
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
        </dependency>
        <!--     sentinel-datasource-nacos 后续持久化用   -->
        <dependency>
            <groupId>com.alibaba.csp</groupId>
            <artifactId>sentinel-datasource-nacos</artifactId>
        </dependency>
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-sentinel</artifactId>
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
            <groupId>com.augus</groupId>
            <artifactId>cloud-api-commons</artifactId>
            <version>1.0-SNAPSHOT</version>
        </dependency>
    </dependencies>

</project>
```

```yaml
server:
  port: 84
spring:
  application:
    name: nacos-order-consumer
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
    sentinel:
      transport:
        dashboard: localhost:8080
        port: 8719

service-url:
  nacos-user-service: http://naocs-payment-provider
```

```java
@SpringBootApplication
@EnableDiscoveryClient
public class OrderNacosMain84 {
    public static void main(String[] args) {
        SpringApplication.run(OrderNacosMain84.class,args);
    }
}
```

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

```java
@RestController
public class CircleBreakerController {

    public static final String SERVICE_URL = "http://nacos-payment-provider";

    @Autowired
    private RestTemplate restTemplate;

    @RequestMapping("/consumer/fallback/{id}")
    @SentinelResource(value = "fallback")
    public CommonResult<Payment> fallback(@PathVariable("id") Long id){
        CommonResult<Payment> commonResult = restTemplate.getForObject(SERVICE_URL + "/paymentSQL/" + id, CommonResult.class);
        if(id == 4){
            throw new IllegalArgumentException("IllegalArgumentException,非法参数异常");
        }else if(commonResult.getData() == null){
            throw new NullPointerException("NullPointerException,该ID没有记录，空指针异常");
        }
        return commonResult;
    }

}
```

#### 测试

> http://localhost:84/consumer/fallback/1 访问成功
>
> 当前没有任何配置，如果访问4或者更大的数字，会直接显示错误页面



#### 只配置fallback

```java
@RequestMapping("/consumer/fallback/{id}")
@SentinelResource(value = "fallback",fallback = "handlerFallback")
public CommonResult<Payment> fallback(@PathVariable("id") Long id){
    CommonResult<Payment> commonResult = restTemplate.getForObject(SERVICE_URL + "/paymentSQL/" + id, CommonResult.class);
    if(id == 4){
        throw new IllegalArgumentException("IllegalArgumentException,非法参数异常");
    }else if(commonResult.getData() == null){
        throw new NullPointerException("NullPointerException,该ID没有记录，空指针异常");
    }
    return commonResult;
}

public CommonResult handlerFallback(Long id, Throwable e){
    Payment payment = new Payment(id, null);
    return new CommonResult(444, "兜底异常handler，exception内容"+e.getMessage(), payment);
}
```

> 这样就不会有异常页面，而是交给兜底方法处理



#### 只配置blockHandler

```java
@RequestMapping("/consumer/fallback/{id}")
@SentinelResource(value = "fallback",blockHandler = "blockHandler")
public CommonResult<Payment> fallback(@PathVariable("id") Long id){
    CommonResult<Payment> commonResult = restTemplate.getForObject(SERVICE_URL + "/paymentSQL/" + id, CommonResult.class);
    if(id == 4){
        throw new IllegalArgumentException("IllegalArgumentException,非法参数异常");
    }else if(commonResult.getData() == null){
        throw new NullPointerException("NullPointerException,该ID没有记录，空指针异常");
    }
    return commonResult;
}

public CommonResult blockHandler(Long id, BlockException exception){
    Payment payment = new Payment(id, null);
    return new CommonResult<>(445, "blockHandler-sentinel 限流，无此流水号：blockException" + exception.getMessage(), payment);
}
```

> 只能处理限流，不可以处理程序异常



#### fallback+blockHandler

```java
@RequestMapping("/consumer/fallback/{id}")
@SentinelResource(value = "fallback",fallback = "handlerFallback",blockHandler = "blockHandler")
public CommonResult<Payment> fallback(@PathVariable("id") Long id){
    CommonResult<Payment> commonResult = restTemplate.getForObject(SERVICE_URL + "/paymentSQL/" + id, CommonResult.class);
    if(id == 4){
        throw new IllegalArgumentException("IllegalArgumentException,非法参数异常");
    }else if(commonResult.getData() == null){
        throw new NullPointerException("NullPointerException,该ID没有记录，空指针异常");
    }
    return commonResult;
}

public CommonResult handlerFallback(Long id, Throwable e){
    Payment payment = new Payment(id, null);
    return new CommonResult(444, "兜底异常handler，exception内容"+e.getMessage(), payment);
}

public CommonResult blockHandler(Long id, BlockException exception){
    Payment payment = new Payment(id, null);
    return new CommonResult<>(445, "blockHandler-sentinel 限流，无此流水号：blockException" + exception.getMessage(), payment);
}
```

> 这样限流问题，和兜底问题都会有对应方法进行处理



#### 异常忽略

```java
@RequestMapping("/consumer/fallback/{id}")
@SentinelResource(value = "fallback",fallback = "handlerFallback",blockHandler = "blockHandler",
    exceptionsToIgnore = {IllegalArgumentException.class})
public CommonResult<Payment> fallback(@PathVariable("id") Long id){
    CommonResult<Payment> commonResult = restTemplate.getForObject(SERVICE_URL + "/paymentSQL/" + id, CommonResult.class);
    if(id == 4){
        throw new IllegalArgumentException("IllegalArgumentException,非法参数异常");
    }else if(commonResult.getData() == null){
        throw new NullPointerException("NullPointerException,该ID没有记录，空指针异常");
    }
    return commonResult;
}
```

> 表示忽略此异常，不会进入兜底，直接报错



### Feign整合

#### 消费端

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
```

> pom引入feign，之前的文件中已经提前引入了

```yaml
feign:
  sentinel:
    enabled: true
```

> yml中添加feign的sentinel支持

```java
@SpringBootApplication
@EnableDiscoveryClient
@EnableFeignClients
public class OrderNacosMain84 {
    public static void main(String[] args) {
        SpringApplication.run(OrderNacosMain84.class,args);
    }
}
```

> 主启动加入@EnableFeignClients注解

```java
@FeignClient(value = "naocs-payment-provider",fallback = PaymentFallbackService.class)
public interface PaymentService {
    @GetMapping("/paymentSQL/{id}")
    public CommonResult<Payment> paymentSQL(@PathVariable("id") Long id);
}
```

> 定义feign的service接口

```java
@Component
public class PaymentFallbackService implements PaymentService{
    @Override
    public CommonResult<Payment> paymentSQL(Long id) {
        return new CommonResult<>(444,"服务降级方法",new Payment(id,"error"));
    }
}
```

> 定义降级方法



## 规则持久化

> 当服务关闭，我们为其指定的规则也会消失
>
> 我们以持久化到Nacos为例，以8401为例

```xml
<!--springcloud alibaba sentinel-datasource-nacos 后续做持久化用到-->
<dependency>
    <groupId>com.alibaba.csp</groupId>
    <artifactId>sentinel-datasource-nacos</artifactId>
</dependency>
```

> pom中添加依赖，之前已经提前导入了

```yaml
server:
  port: 8401

spring:
  application:
    name: cloudalibaba-sentinel-service
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
    sentinel:
      transport:
        dashboard: localhost:8080
        port: 8719
      datasource:
        ds1:
          nacos:
            server-addr: localhost:8848
            dataId: cloudalibaba-sentinel-server
            groupId: DEFAULT_GROUP
            data-type: json
            rule-type: flow

management:
  endpoints:
    web:
      exposure:
        include: "*"
```

> 将SpringCloud sentinel datasource的内容添加进配置文件

![image-20210904001520802](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Sentinel.assets\image-20210904001520802.png)

> 在nacos中新增配置
>
> resource：资源名称
>
> limitApp：来源应用
>
> grade：阈值类型，0表示线程数，1表示QPS
>
> count：单机阈值
>
> strategy：流控模式，0直接，1关联，2链路
>
> controlBehavior：流控效果，0快速失败，1Warm Up，2排队等待
>
> clusterMode：是否集群

> 我们重新启动微服务，发现配置是自动配置好的

