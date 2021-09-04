# Bus

> Bus支持两种消息代理Kafka和RabbitMQ

> Bus能管理和传播分布式系统间的消息，就像一个分布式执行器
>
> 可用于广播状态更改，时间推送等
>
> 也可以当做微服务间的通信通道

> 在微服务架构的系统中，通常使用轻量级的消息代理来构建一个共用的消息主题
>
> 并让系统中所有微服务实例都连接上来
>
> 由于该主题中所产生的消息会被所有实例监听和消费，所以它被称为消息总线
>
> 在总线上的各个实例，都可以方便的广播一些需要让其他连接在该主题上的实例都知道的消息



## 全局广播

> 为了演示效果，我们将3355再创建一个一模一样的3366



### 服务端

> 为配置中心服务端3344添加总线支持

#### POM

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-bus-amqp</artifactId>
</dependency>
```

#### YML

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
  rabbitmq:
    host: 192.168.80.129
    port: 5672
    username: root
    password: 1234


eureka:
  client:
    service-url:
      defaultZone: http://localhost:7001/eureka

management:
  endpoints:
    web:
      exposure:
        include: 'bus-refresh'
```

> 添加RabbitMQ的配置和暴露相关配置



### 客户端

#### POM

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-bus-amqp</artifactId>
</dependency>
```

#### YML

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
  rabbitmq:
    host: 192.168.80.129
    port: 5672
    username: root
    password: 1234

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



### 测试

> 在启动后
>
> 将github中版本号修改
>
> 为服务端提交一个POST请求，刷新所有
>
> ```sh
> curl -X POST "http://localhost:3344/actuator/bus-refresh"
> ```
>
> 再访问http://localhost:3355/configInfo和http://localhost:3366/configInfo
>
> 发现数据已经刷新了



## 定点通知

> 不想通知全部微服务，只想定点通知，以只通知3355不通知3366为例
>
> 非常简单，只需要在通知的后面，追加指定的微服务名称与地址

```sh
curl -X POST "http://localhost:3344/actuator/bus-refresh/config-client:3355"
```

