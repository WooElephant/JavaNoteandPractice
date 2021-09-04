# Stream

> SpringCloud Stream可以屏蔽底层消息中间件的差异，降低切换成本，统一消息的编程模型
>
> 有点像是接口实现，JDBC

> 应用程序通过inputs或outputs来与SpringCloud Stream中binder对象交互
>
> 通过配置来binding（绑定），而binder对象负责与消息中间件交互

> 目前仅支持RabbitMQ与Kafka

> Binder	很方便的连接中间件，屏蔽差异
>
> Channel	通道，是队列Queue的一种抽象，在消息通讯系统中就是实现存储和转发的媒介，通过Channel对队列进行配置
>
> Source和Sink	简单的可理解为参照对象是SpringCloud Stream自身，从Stream发布消息是输出，接收消息是输入

## 常用注解

> @input	标识输入通道，通过该通道接收到的消息，进入应用程序
>
> @output	标识输出通道，发布的消息将通过该通道离开应用程序
>
> @StreamListener	监听队列，用于消费者的队列消息接收
>
> @EnableBinding	值信道channel和exchange绑定在一起



## 案例

> 新建三个模块
>
> cloud-stream-rabbitmq-provider8801	作为生产者发送消息
>
> cloud-stream-rabbitmq-consumer8802	作为消息接收者
>
> cloud-stream-rabbitmq-consumer8803	作为消息接收者

### 生产者

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

    <artifactId>cloud-stream-rabbitmq-provider8801</artifactId>

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
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-stream-rabbit</artifactId>
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

#### YML

```yaml
server:
  port: 8801

spring:
  application:
    name: cloud-stream-provider
  rabbitmq:
    host: 192.168.80.129
    port: 5672
    username: root
    password: 1234
  cloud:
    stream:
      binders: # 在此处配置要绑定的rabbitMQ的服务信息
        defaultRabbit: # 表示定义的名称，用于binding的整合
          type: rabbit # 消息中间件类型
      bindings: # 服务的整合处理
        output: # 这个名字是一个通道的名称
          destination: studyExchange # 表示要使用的exchange名称定义
          content-type: application/json # 设置消息类型，本次为json，文本则设为text/plain
          binder: defaultRabbit # 设置要绑定的消息服务的具体设置

eureka:
  client:
    service-url:
      defaultZone: http://localhost:7001/eureka
  instance:
    lease-renewal-interval-in-seconds: 2 # 设置心跳的间隔时间，默认30
    lease-expiration-duration-in-seconds: 5 # 超过5秒间隔，默认90
    instance-id: send-8801.com # 主机名
    prefer-ip-address: true # 显示ip
```

#### 主启动

```java
@SpringBootApplication
public class StreamMQMain8801 {
    public static void main(String[] args) {
        SpringApplication.run(StreamMQMain8801.class,args);
    }
}
```

#### 业务类

```java
package com.augus.springcloud.service.impl;

import com.augus.springcloud.service.IMessageProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.stream.annotation.EnableBinding;
import org.springframework.cloud.stream.messaging.Source;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.support.MessageBuilder;
import java.util.UUID;

@EnableBinding(Source.class)    //定义消息的推送管道
public class MessageProviderImpl implements IMessageProvider {

    @Autowired
    private MessageChannel output;  //消息发送管道

    @Override
    public String send() {
        String serial = UUID.randomUUID().toString();
        output.send(MessageBuilder.withPayload(serial).build());
        System.out.println("===========   serial:" + serial);
        return null;
    }
}
```

```java
@RestController
public class SendMessageController {
    @Autowired
    private IMessageProvider messageProvider;

    @GetMapping("/sendMessage")
    public String sendMessage(){
        return messageProvider.send();
    }
}
```

#### 测试

> 访问http://localhost:8801/sendMessage
>
> 看看MQ后台有没有消息



### 消费者

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

    <artifactId>cloud-stream-rabbitmq-consumer8802</artifactId>

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
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-stream-rabbit</artifactId>
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

#### YML

```yaml
server:
  port: 8802

spring:
  application:
    name: cloud-stream-consumer
  rabbitmq:
    host: 192.168.80.129
    port: 5672
    username: root
    password: 1234
  cloud:
    stream:
      binders:
        defaultRabbit:
          type: rabbit
      bindings:
        input:
          destination: studyExchange
          content-type: application/json
          binder: defaultRabbit

eureka:
  client:
    service-url:
      defaultZone: http://localhost:7001/eureka
  instance:
    lease-renewal-interval-in-seconds: 2
    lease-expiration-duration-in-seconds: 5 
    instance-id: receive-8802.com
    prefer-ip-address: true
```

#### 主启动

```java
@SpringBootApplication
public class StreamMQMain8802 {
    public static void main(String[] args) {
        SpringApplication.run(StreamMQMain8802.class,args);
    }
}
```

#### 业务类

```java
@RestController
@EnableBinding(Sink.class)
public class ReceiveMessageListenerController {

    @Value("${server.port}")
    private String serverPort;

    @StreamListener(Sink.INPUT)
    public void input(Message<String> message){
        System.out.println("收到消息：" + message.getPayload() + "\t port:" + serverPort);
    }
}
```

#### 测试

> http://localhost:8801/sendMessage发送消息
>
> 8802控制台输出



### 消费者2

> 与消费者1相同



## 重复消费

> 当我们生产者发送一条消息，两个消费者都会收到，这显然不是我们想要的
>
> 我们需要使用消息分组来解决

```yaml
server:
  port: 8802

spring:
  application:
    name: cloud-stream-consumer
  rabbitmq:
    host: 192.168.80.129
    port: 5672
    username: root
    password: 1234
  cloud:
    stream:
      binders:
        defaultRabbit:
          type: rabbit
      bindings:
        input:
          destination: studyExchange
          content-type: application/json
          binder: defaultRabbit
          group: groupA

eureka:
  client:
    service-url:
      defaultZone: http://localhost:7001/eureka
  instance:
    lease-renewal-interval-in-seconds: 2
    lease-expiration-duration-in-seconds: 5
    instance-id: receive-8802.com
    prefer-ip-address: true
```

> 只需要在配置文件中加入group，将他们分为一个组即可



## 消息持久化

> 比如说我们8802和8803都宕机了
>
> 8801此时发了几条消息
>
> 8802中我们将group删除，并重启，这时，这四条消息并不能被收到
>
> 但是8803我们不删除group，重启后，这几条消息依然可以获得
>
> group可以帮助我们做到持久化的功能
