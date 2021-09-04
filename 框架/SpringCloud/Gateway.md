# Gateway

> Cloud全家桶中有一个很重要的组件就是网关，在1.x版本中采用Zuul网关
>
> 但在2.x版本中，Zuul一直跳票，SpringCloud自己研发了SpringCloud Gateway来替代Zuul

> Gateway旨在提供一种简单而有效的方式来对API进行路由，以及提供一些强大的过滤器功能，例如：熔断，限流，重试等

> Gateway使用Webflux中的reactor-netty响应式编程组件，底层使用了netty通讯框架

## 三大核心概念

### 路由Route

> 路由是构建网关的基本模块，由ID，目标URI，一系列的断言和过滤器组成
>
> 如果断言为true则匹配该路由



### 断言Predicate

> 开发人员可以匹配HTTP请求中的所有内容（例如请求头或请求参数），如果请求与断言相匹配则进行路由



### 过滤Filter

> 指的是Spring框架中GatewayFilter的实例，使用过滤器，可以在请求被路由前或之后对请求进行修改



## Gateway工作流程

> 客户端向Spring Cloud Gateway发出请求
>
> 在Gateway Handler Mapping中找到与请求相匹配的路由
>
> 将其发送到Gateway Web Handler
>
> Handler再通过指定的过滤器链，来将请求发送到实际的服务执行业务逻辑



## 配置Gateway

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

    <artifactId>cloud-gateway-gateway9527</artifactId>

    <dependencies>
        <!--gateway-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-gateway</artifactId>
        </dependency>

        <!--eureka client-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
        <!--引入自定义的api通用包，可使用Payment支付Entity-->
        <dependency>
            <groupId>com.augus</groupId>
            <artifactId>cloud-api-commons</artifactId>
            <version>1.0-SNAPSHOT</version>
        </dependency>
        <!--一般基础配置类-->
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
  port: 9527
spring:
  application:
    name: cloud-gateway

eureka:
  instance:
    hostname: cloud-gateway-server
  client:
    service-url:
      register-with-rureka: true
      fetch-registry: true
      defaultZone: http://localhost:7001/eureka
```

### 主启动

```java
@SpringBootApplication
@EnableEurekaClient
public class GatewayMain9527 {
    public static void main(String[] args) {
        SpringApplication.run(GatewayMain9527.class,args);
    }
}
```

### 路由配置

```yaml
server:
  port: 9527
spring:
  application:
    name: cloud-gateway
  cloud:
    gateway:
      routes:
        - id: payment_routh
          uri: http://localhost:8001
          predicates:
            - Path=/payment/get/**

        - id: payment_routh2
          uri: http://localhost:8001
          predicates:
            - Path=/payment/lb/**

eureka:
  instance:
    hostname: cloud-gateway-server
  client:
    service-url:
      register-with-rureka: true
      fetch-registry: true
      defaultZone: http://localhost:7001/eureka
```

> 在yml文件中增加route的配置



### 测试

> 启动之后我们发现，访问http://localhost:9527/payment/get/1
>
> 也可以得到数据



### YAML配置说明

> Gateway配置网关有两种方法，第一种就是前面演示的，使用yaml文件中配置
>
> 第二种在代码中注入RouteLocator的Bean

```java
@Configuration
public class GatewayConfig {
    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder routeLocatorBuilder){
        RouteLocatorBuilder.Builder routes = routeLocatorBuilder.routes();
        routes.route("route_haha",r -> r.path("/guonei").uri("http://news.baidu.com/guonei")).build();
        return routes.build();
    }
}
```



## 动态路由

> 默认情况下，Gateway会根据注册中心注册的服务列表，以注册中心上微服务名为路径创建动态路由进行转发，从而实现动态路由

```yaml
server:
  port: 9527
spring:
  application:
    name: cloud-gateway
  cloud:
    gateway:
      discovery:
        locator:
          enabled: true
      routes:
        - id: payment_routh
          uri: lb://cloud-payment-service
          predicates:
            - Path=/payment/get/**

        - id: payment_routh2
          uri: lb://cloud-payment-service
          predicates:
            - Path=/payment/lb/**

eureka:
  instance:
    hostname: cloud-gateway-server
  client:
    service-url:
      register-with-rureka: true
      fetch-registry: true
      defaultZone: http://localhost:7001/eureka
```

> 开启locator.enabled = true
>
> 并且将uri改为lb://微服务的名称

> 访问http://localhost:9527/payment/lb
>
> 会发现8001与8002交替响应



## Predicate的使用

```yaml
routes:
  - id: payment_routh
    uri: lb://cloud-payment-service
    predicates:
      - Path=/payment/get/**
```

> 在predicates中可以写多种断言
>
> **\- Path**只是其中一种，表示有没有这个访问路径
>
> **\- After**表示在某个时间点之后
>
> **\- Before**表示在某个时间点之前
>
> **\- Between**表示在两个时间之间，使用逗号分割，这三个后面跟着的时间有特殊格式要求，可以使用ZonedDateTime.now()来获取这种时间格式，并做修改
>
> **\- Cookie**表示，验证Cookie
>
> 比如 \- Cookie=username,aaa  代表cookie中必须要username=aaa这条数据，才可以访问
>
> **\- Header**表示头部信息中必须携带某些信息
>
> 比如 \- Header=X-Request-Id,\d+  表示请求头要有X-Request-Id属性，并且值必须为整数
>
> **\- Host**表示接收一组参数，一组匹配的域名列表
>
> \- Host=**.baidu.com  请求头中的Host内容，必须以.baidu.com结尾
>
> **\- Method**表示请求类型
>
> **\- Query**表示参数检查
>
> 比如 \- Query=username,\d+ 要有参数名为username并且值是整数



## Filter的使用

> 按生命周期分为两种pre和post，类似前置通知和后置通知
>
> 按种类分为两种GatewayFilter和GlobalFilter

```yaml
routes:
  - id: payment_routh
    uri: lb://cloud-payment-service
    filters:
      -AddRequestParameter=X-Request-Id,1024
    predicates:
      - Path=/payment/get/**
```

> 它的使用方法与断言差不多，只不过是修改请求



### 自定义过滤器

> 需要实现GlobalFilter和Ordered

```java
@Component
@Slf4j
public class MyLogGatewayFilter implements GlobalFilter, Ordered {

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        log.info("=================自定义全局过滤器加载=================");
        String uname = exchange.getRequest().getQueryParams().getFirst("uname");
        if (uname == null){
            log.info("用户名非法！");
            exchange.getResponse().setStatusCode(HttpStatus.NOT_ACCEPTABLE);
            return exchange.getResponse().setComplete();
        }
        return chain.filter(exchange);
    }

    @Override
    public int getOrder() {
        //表示过滤器的优先级，值越小优先级越高
        return 0;
    }
}
```

