# Sleuth

> 在微服务框架中，一个由客户端发起的请求在后端系统中会经过多个不同的服务节点调用协同产生最后的结果
>
> 每一个前端请求都会形成一条复杂的分布式服务调用链路
>
> 链路中的任何一环出现高延迟或错误都会引起整体请求的失败

> SpringCloud Sleuth提供了一套完整的服务跟踪方案
>
> 在分布式系统中提供追中解决方案，并且兼容支持zipkin



## 搭建

### zipkin

> 简单来说，Sleuth负责收集数据，zipkin负责展示数据

> 从SpringCloud F版起，不需要自己构建Zipkin Server了，只需要调用jar包即可

```sh
curl -sSL https://zipkin.io/quickstart.sh | bash -s
java -jar zipkin.jar
```

> 运行成功后，访问http://your_host:9411/zipkin/即可



#### 术语

![image-20210901172829200](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\Sleuth.assets\image-20210901172829200.png)

> 完整的调用链路
>
> 表示请求链路，一条链路通过Trace Id唯一标识，Span表示发起的请求信息，各Span通过parent id关联起来
>
> Trace：表示一条调用链路
>
> Span：表示调用链路的来源，通俗理解就是一次请求



### 服务端

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-zipkin</artifactId>
</dependency>
```

> 在POM中导入依赖

```yaml
server:
  port: 8001

spring:
  application:
    name: cloud-payment-service
  zipkin:
    base-url: http://192.168.80.129:9411
  sleuth:
    sampler:
      probability: 1
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/springcloudtest?useUnicode=true&characterEncoding=utf-8&useSSL=false
    username: root
    password: 1234

mybatis:
  mapper-locations: classpath:mapper/*.xml
  type-aliases-package: com.augus.springcloud.entities

eureka:
  client:
    register-with-eureka: true  #将自己注册进Eureka Server
    fetch-registry: true  #是否从Eureka Server抓取已有注册信息，默认为true
    service-url:
      defaultZone: http://localhost:7001/eureka
  instance:
    instance-id: payment8001
    prefer-ip-address: true
    lease-renewal-interval-in-seconds: 1
    lease-expiration-duration-in-seconds: 2
```

> 添加zipkin和sleuth的配置
>
> probability表示采样率，介于0到1之间，1表示全部收集

```java
@GetMapping("/payment/zipkin")
public String paymentZipkin(){
    return "我是paymentZipkin";
}
```

> 为了方便测试，我们写一个很简单的方法



### 消费端

> 在POM中也导入同样的依赖

> 配置文件中也是加入相同的内容

```java
@GetMapping("/consumer/payment/zipkin")
public String consumerZipkin(){
    String result = restTemplate.getForObject("http://localhost:8001" + "/payment/zipkin",String.class);
    return result;
}
```

> 也写一个简单的访问方法



### 测试

> 访问http://localhost/consumer/payment/zipkin
>
> 在dashboard中就能看到追踪信息