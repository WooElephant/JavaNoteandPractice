# Dubbo

> Dubbo是阿里巴巴开源的高性能，轻量级RPC框架



## Hello World

> 创建两个模块
>
> service和web

### service

```java
@Service
public class UserServiceImpl implements UserService {
    @Override
    public String sayHello() {
        return "hello dubbo";
    }
}
```

### web

```java
@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/sayHello")
    public String sayHello(){
        return userService.sayHello();
    }
}
```

### 服务提供者

```java
@Service    //将这个类提供的方法，对外发布
public class UserServiceImpl implements UserService {
    public String sayHello() {
        return "hello dubbo";
    }
}
```

> 将service中的@Service改为dubbo包中的注解

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:dubbo="http://dubbo.apache.org/schema/dubbo"
       xmlns="http://www.springframework.org/schema/beans"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.3.xsd
       http://dubbo.apache.org/schema/dubbo http://dubbo.apache.org/schema/dubbo/dubbo.xsd">


    <!--配置项目名称-->
    <dubbo:application name="dubbo-service"/>
    <!--配置ZooKeeper地址-->
    <dubbo:registry address="zookeeper://192.168.80.129:2181"/>
    <!--扫描Dubbo的包-->
    <dubbo:annotation package="com.augus.service.impl"/>
</beans>
```

> 添加配置

### 服务消费者

```java
@RestController
@RequestMapping("/user")
public class UserController {

    @Reference
    private UserService userService;

    @RequestMapping("/sayHello")
    public String sayHello(){
        return userService.sayHello();
    }
}
```

> 将Autowire改为@Reference
>
> 远程注入
>
> 从注册中心获取访问url，进行远程调用RPC
>
> 将结果封装为一个代理对象，给变量赋值

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:context="http://www.springframework.org/schema/context" xmlns:dubbo="http://dubbo.apache.org/schema/dubbo"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/mvc https://www.springframework.org/schema/mvc/spring-mvc.xsd http://www.springframework.org/schema/context https://www.springframework.org/schema/context/spring-context.xsd http://dubbo.apache.org/schema/dubbo http://dubbo.apache.org/schema/dubbo/dubbo.xsd">

    <mvc:annotation-driven/>
    <context:component-scan base-package="com.augus.controller"/>

    <!--配置项目名称-->
    <dubbo:application name="dubbo-service"/>
    <!--配置ZooKeeper地址-->
    <dubbo:registry address="zookeeper://192.168.80.129:2181"/>
    <!--扫描Dubbo的包-->
    <dubbo:annotation package="com.augus.controller"/>
</beans>
```

> 在配置文件中，添加Dubbo的配置



## 管理平台

> 修改dubbo-admin-server\src\main\resources中的application.properties
>
> 将ZooKeeper的ip改为自己的ip

> 在根目录下运行mvn clean package

> 进入dubbo-admin-distribution\target目录
>
> 运行dubbo-admin-0.1.jar

> 进入dubbo-admin-ui目录
>
> 使用npm run dev



## 高级功能

### 超时、重试

```java
@Service(timeout = 3000,retries = 0)
public class UserServiceImpl implements UserService {
    public String sayHello() {
        return "hello dubbo";
    }
}
```

> 超过3秒没有反应则超时
>
> 重试0次

### 灰度发布

```java
@Service(version = "v1.0")
public class UserServiceImpl implements UserService {
    public String sayHello() {
        return "hello dubbo";
    }
}
```

```java
@RestController
@RequestMapping("/user")
public class UserController {

    @Reference(version = "v1.0")
    private UserService userService;

    @RequestMapping("/sayHello")
    public String sayHello(){
        return userService.sayHello();
    }
}
```

### 负载均衡

> 多个服务器保持相同服务名即可称为集群
>
> 注意要在配置文件中指定不同的通信端口
>
> ```xml
> <dubbo:protocol port="20881"/>
> ```

> 负载均衡策略
>
> Random：按权重随机，默认值
>
> RoundRobin：按权重轮训
>
> LeastActive：最少活跃调用
>
> ConsistentHash：根据Hash值来确定，相同参数的请求必定访问的同一个服务器

```java
@Service(weight = 100)
public class UserServiceImpl implements UserService {
    public String sayHello() {
        return "hello dubbo";
    }
}
```

```java
@RestController
@RequestMapping("/user")
public class UserController {

    @Reference(loadbalance = "random")
    private UserService userService;

    @RequestMapping("/sayHello")
    public String sayHello(){
        return userService.sayHello();
    }
}
```

