# SpringCloud Alibaba Nacos

> Nacos为Naming和Configuration加Service的简写
>
> 是一个更易于构建云原生应用的，动态服务发现、配置管理和服务管理平台
>
> 简单来说就是注册中心 + 配置中心（Eureka + Config + Bus）

> Nacos支持AP与CP模式的切换

## 安装

> 在官网下载并解压缩
>
> 在bin目录中运行startup
>
> 访问http://localhost:8848/nacos
>
> 默认的账号密码都是nacos

## 服务注册中心

```xml
<!--SpringCloud Alibaba-->
<dependency>
  <groupId>com.alibaba.cloud</groupId>
  <artifactId>spring-cloud-alibaba-dependencies</artifactId>
  <version>2.1.0.RELEASE</version>
  <type>pom</type>
  <scope>import</scope>
```

> 在整个项目的父POM中添加spring-cloud-alibaba的依赖



### 生产者

> 为了演示负载均衡，会建立两个模块9001与9002

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

    <artifactId>cloudalibaba-provider-payment9001</artifactId>

    <dependencies>
        <!--springcloud alibaba nacos-->
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
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
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
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

> 在模块中引入nacos

#### YML

```yaml
server:
  port: 9001

spring:
  application:
    name: nacos-payment-provider
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848 #配置Nacos地址

management:
  endpoints:
    web:
      exposure:
        include: '*'  #监控
```

#### 主启动

```java
@SpringBootApplication
@EnableDiscoveryClient
public class PaymentMain9001 {
    public static void main(String[] args) {
        SpringApplication.run(PaymentMain9001.class,args);
    }
}
```

#### 业务类

```java
@RestController
public class PaymentController {
    @Value("${server.port}")
    private String serverPort;

    @GetMapping("/payment/nacos/{id}")
    public String getPayment(@PathVariable("id") Integer id){
        return "nacos registry,serverPort: "+ serverPort+"\t id"+id;
    }
}
```

#### 测试

> 运行该模块，在nacos服务管理中的服务列表可以看到已经注册成功
>
> http://localhost:9001/payment/nacos/1 访问正常
>
> http://localhost:9002/payment/nacos/1 访问正常



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

    <artifactId>cloudalibaba-consumer-macos-order83</artifactId>

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

#### YML

```yaml
server:
  port: 83

spring:
  application:
    name: nacos-order-consumer
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848

#消费者将要去访问的微服务名称（成功注册进nacos的微服务提供者），在这配置了访问的服务，业务类就不用在定义常量了
service-url:
  nacos-user-service: http://nacos-payment-provider
```

#### 主启动

```java
@SpringBootApplication
@EnableDiscoveryClient
public class OrderNacosMain83 {
    public static void main(String[] args) {
        SpringApplication.run(OrderNacosMain83.class,args);
    }
}
```

#### 业务类

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
public class OrderNacosController {
    @Autowired
    private RestTemplate restTemplate;

    @Value("${service-url.nacos-user-service}")
    private String serverURL;

    @GetMapping("/consumer/payment/nacos/{id}")
    public String paymentInfo(@PathVariable("id") Integer id){
        return restTemplate.getForObject(serverURL + "/payment/nacos/" + id,String.class);
    }
}
```

#### 测试

> 在nacos服务管理中的服务列表可以看到已经注册成功
>
> http://localhost:83/consumer/payment/nacos/1 正常访问



## 服务配置中心

### 基础配置

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

    <artifactId>cloudalibaba-config-nacos-client3377</artifactId>

    <dependencies>
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
        </dependency>
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
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

> 引入nacos-config

#### YML

```yaml
server:
  port: 3377

spring:
  application:
    name: nacos-config-client
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
      config:
        server-addr: localhost:8848
        file-extension: yml
```

> bootstrap

```yaml
spring:
  profiles:
    active: dev
```

> application

#### 主启动

```java
@SpringBootApplication
@EnableDiscoveryClient
public class NacosConfigClientMain3377 {
    public static void main(String[] args) {
        SpringApplication.run(NacosConfigClientMain3377.class,args);
    }
}
```

#### 业务类

```java
@RestController
@RefreshScope
public class ConfigClientController {

    @Value("${config.info}")
    private String configInfo;

    @GetMapping("/config/info")
    public String getConfigInfo(){
        return configInfo;
    }
}
```

#### Nacos中配置信息匹配规则

> 在Nacos中，需要配置dataId
>
> 其规则为
>
> ```
> ${prefix}-${spring.profile.active}.${file.extension}
> ```
>
> prefix默认为 spring.application.name的值
>
> spring.profile.active即为当前环境对应的profile，当spring.profile.active为空，-连接符也会不存在，dataId则变为\${prefix}.${file.extension}**（一般不会不设置）**
>
> file.extension为配置的格式

> 以我们当前的例子
>
> prefix = nacos-config-client
>
> spring.profile.active = dev
>
> file.extension = yml
>
> 所以dataId = nacos-config-client-dev.yml

![image-20210902163741875](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Nacos.assets\image-20210902163741875.png)

> 在nacos页面中，点击配置列表，加号
>
> 完成配置

> http://localhost:3377/config/info 成功访问
>
> 在nacos中将version改为2
>
> 再次访问也变为2，动态刷新也成功



### 分类配置

> 到目前为止已经实现了Config + Bus的功能
>
> 但Nacos更进一步，提供了更多的功能

> 在Nacos中，配置文件拥有Namespace，Group，DataId
>
> 类似于包名，类名

![image-20210902164738081](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\SpringCloud Alibaba Nacos.assets\image-20210902164738081.png)

> 默认情况
>
> Namespace = public
>
> Group = DEFAULT_GROUP
>
> 默认集群也是DEFAULT

> Namespace用于区分环境，如开发，测试，生产
>
> Group用于将不同微服务分组
>
> 集群可以将不同集群分别命名



#### DataId配置

> 和基础配置一样，如果要切换配置文件
>
> 将active: dev改为其他即可



#### Group配置

> 新建两个配置 nacos-config-client-info.yaml
>
> 分别属于DEV_GROUP与TEST_GROUP

> application改为

```yaml
spring:
  profiles:
    active: info
```

> bootstrap中添加group

```yaml
server:
  port: 3377

spring:
  application:
    name: nacos-config-client
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
      config:
        server-addr: localhost:8848
        file-extension: yaml
        group: TEST_GROUP
```

> 即可访问



#### Namespace配置

> 在Nacos页面新建dev和test命名空间

```yaml
server:
  port: 3377

spring:
  application:
    name: nacos-config-client
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
      config:
        server-addr: localhost:8848
        file-extension: yaml
        group: DEV_GROUP
        namespace: d82d5861-e804-4cd4-bf40-cc16f86b5c2f
```

> 在配置中，加入namespace，填入命名空间的id

> 在nacos页面，配置列表相应的名称空间中就可以新建文件，来访问



## Nacos集群与持久化

> 默认Nacos使用嵌入式数据库实现数据存储（Derby），如果使用多个Nacos节点，数据存储存在一致性问题
>
> Nacos采用集中式存储来解决这个问题，目前仅支持MySQL

> 在Nacos config文件夹中有一个nacos-mysql.sql文件，将其中的代码复制到MySQL中运行，为其创建数据存储环境
>
> 之后在config文件夹中找到application.properties文件，在其下方新增数据库配置内容

```properties
spring.datasource.platform=mysql

db.num=1
db.url.0=jdbc:mysql://127.0.0.1:3306/nacos_config?characterEncoding=utf-8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true
db.user=root
db.password=1234
```



### 生产环境搭建

> 以1个Nginx，3个Nacos，1个MySQL为例

#### MySQL

> 粘贴mysql脚本到Linux中的mysql运行

> 修改application.properties

#### Nacos集群配置

> 将conf文件夹中cluster.conf复制一份，并修改

```
192.168.80.129:3333
192.168.80.129:4444
192.168.80.129:5555
```

#### Nacos启动脚本

> 因为我们是在一台机器中做测试，所以我们需要修改启动脚本，使用不同的端口在一台机器中运行

```sh
while getopts ":m:f:s:" opt
do
    case $opt in
        m)
            MODE=$OPTARG;;
        f)
            FUNCTION_MODE=$OPTARG;;
        s)
            SERVER=$OPTARG;;
        ?)
        echo "Unknown parameter"
        exit 1;;
    esac
done
```

> 将这一部分修改为

```sh
while getopts ":m:f:s:p:" opt
do
    case $opt in
        m)
            MODE=$OPTARG;;
        f)
            FUNCTION_MODE=$OPTARG;;
        s)
            SERVER=$OPTARG;;
        p)
            PORT=$OPTARG;;
        ?)
        echo "Unknown parameter"
        exit 1;;
    esac
done
```

> 还有一处在最后面

```sh
nohup $JAVA ${JAVA_OPT} nacos.nacos >> ${BASE_DIR}/logs/start.out 2>&1 &
```

> 将其修改为

```sh
nohup $JAVA -Dserver.port=${PORT} ${JAVA_OPT} nacos.nacos >> ${BASE_DIR}/logs/start.out 2>&1 &
```

#### Nginx配置

> 修改nginx.conf
>
> 改为如下配置

```
#gzip  on;
    
    upstream cluster{
        server 127.0.0.1:3333;
        server 127.0.0.1:4444;
        server 127.0.0.1:5555;
    }

    server {
        listen       1111;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            #root   html;
            #index  index.html index.htm;
            proxy_pass http://cluster;
        }
```

#### 测试

> http://192.168.80.129:1111/nacos/#/login 正常访问
>
> 随便加一个配置，发现服务器上mysql中config_info表中多了一条数据

