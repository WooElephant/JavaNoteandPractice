# Config

> 微服务意味着要将单体应用中的业务拆分成一个个子服务，每个服务的粒度相对较小，因此系统中会出现大量的服务
>
> 由于每个服务都需要配置才能运行，所以一套集中式，动态的配置管理是必不可少的

> SpringCloud Config为微服务提供了集中化的外部配置支持。配置服务器，为各个微服务应用提供了一个中心化的外部配置

> SpringCloud Config分为客户端和服务端两部分
>
> 服务端也称为分布式配置中心，他是一个独立的微服务应用，用来连接配置服务器，并为客户端提供配置信息，加密解密信息等接口
>
> 客户端则是通过指定的配置中心来管理应用资源，以及与业务相关的配置内容。并在启动的时候从配置中心获取和加载配置信息。
>
> 配置服务器默认采用git来存储配置信息



## 服务端

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

    <artifactId>cloud-config-center3344</artifactId>

    <dependencies>
        <!--添加消息总线RabbitMQ支持-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-bus-amqp</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-config-server</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
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
  port: 3344

spring:
  application:
    name: cloud-config-center
  cloud:
    config:
      server:
        git:
          uri: https://github.com/WooElephant/SpringCloud-Config
          search-paths:
            - SpringCloud-Config
      label: main


eureka:
  client:
    service-url:
      defaultZone: http://localhost:7001/eureka
```

### 主启动

```java
@SpringBootApplication
@EnableConfigServer
public class ConfigCenterMain3344 {
    public static void main(String[] args) {
        SpringApplication.run(ConfigCenterMain3344.class,args);
    }
}
```

### 测试

> 此时我们访问http://localhost:3344/main/config-dev.yml
>
> 就会得到配置文件中的内容



### 配置读取规则

```
规则
/{label}/{application}-{profile}.yml

举例
master分支
http://localhost:3344/master/config-dev.yml
http://localhost:3344/master/config-test.yml
http://localhost:3344/master/config-prod.yml
dev分支
http://localhost:3344/dev/config-dev.yml
http://localhost:3344/dev/config-test.yml
http://localhost:3344/dev/config-prod.yml
```

```
规则
/{application}-{profile}.yml

举例
http://localhost:3344/config-dev.yml
http://localhost:3344/config-test.yml
http://localhost:3344/config-prod.yml
```

> 默认读取master分支

```
规则
/{application}/{profile}[/{label}].yml

举例
http://localhost:3344/config/dev/master
http://localhost:3344/config/test/master
http://localhost:3344/config/test/dev
```

> 推荐使用第一种，也就是上述案例中使用的http://localhost:3344/main/config-dev.yml，清晰明了



## 客户端

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

    <artifactId>cloud-config-client3355</artifactId>

    <dependencies>
        <!--不带server了，说明是客户端-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-config</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
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

### 写配置

```yaml
server:
  port: 3355

spring:
  application:
    name: config-client
  cloud:
    config:
      label: main
      name: config
      profile: dev
      uri: http://localhost:3344
      
eureka:
  client:
    service-url:
      defaultZone: http://localhost:7001/eureka
```

> 注意：此配置名称为bootstrap.yml

> application.yml是用户级系统配置
>
> bootstrap.yml是系统级，优先级更高
>
> SpringCloud会创建Bootstrap Context作为Application Context的父级上下文
>
> 这样可以保留两者的配置，并且隔离

### 主启动

```java
@SpringBootApplication
@EnableEurekaClient
public class ConfigClientMain3355 {
    public static void main(String[] args) {
        SpringApplication.run(ConfigClientMain3355.class,args);
    }
}
```

### 业务类

```java
@RestController
public class ConfigClientController {
    @Value("${config.info}")
    private String configInfo;

    @GetMapping("/configInfo")
    public String getConfigInfo(){
        return configInfo;
    }
}
```

### 测试

> 访问http://localhost:3355/configInfo
>
> 即可得到github上配置文件中的值



## 客户端动态刷新

> 目前修改github上配置文件，除非手动重启3355，不然配置不会刷新



### POM

> 引入监控模块

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```



### 修改配置

> 暴露监控端点

```yaml
server:
  port: 3355

spring:
  application:
    name: config-client
  cloud:
    config:
      label: main
      name: config
      profile: dev
      uri: http://localhost:3344

eureka:
  client:
    service-url:
      defaultZone: http://localhost:7001/eureka
      
management:
  endpoints:
    web:
      exposure:
        include: "*"
```



### 业务类

```java
@RestController
@RefreshScope
public class ConfigClientController {
    @Value("${config.info}")
    private String configInfo;

    @GetMapping("/configInfo")
    public String getConfigInfo(){
        return configInfo;
    }
}
```

> 添加@RefreshScope注解，增加刷新功能



### 测试

> 其实这样测试还没没效果
>
> 必须给3355一个post请求，让其刷新

```sh
curl -X POST "http://localhost:3355/actuator/refresh"
```



### 总结

> 这样做确实可以避免重启
>
> 但是当微服务超过一定规模，我们肯定不愿意去手动发命令指定刷新
>
> 应该达到广播通知所有微服务，全部进行自动刷新
>
> 这就引出了另一个功能，消息总线

