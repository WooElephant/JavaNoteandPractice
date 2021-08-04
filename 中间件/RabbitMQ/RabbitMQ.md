# RabbitMQ

## 概念

### 什么是MQ

> MQ(message queue)，从字面意思上看，本质是个队列
>
> FIFO先入先出，只不过队列中存放的内容是message而已，还是一种跨进程的通信机制，用于上下游传递消息
>
> 在互联网架构中，MQ是一种非常常见的上下游“逻辑解耦+物理解耦”的消息通信服务
>
> 使用了MQ之后，消息发送上游只需要依赖MQ，不用依赖其他服务

### 为什么要用MQ

#### 流量消峰

> 举个例子，如果订单系统最多能处理一万次订单，这个处理能力应付正常时段的下单时绰绰有余，正常时段我们下单一秒后就能返回结果。但是在高峰期，如果有两万次下单操作系统是处理不了的，只能限制订单超过一万后不允许用户下单。使用消息队列做缓冲，我们可以取消这个限制，把一秒内下的订单分散成一段时间来处理，这时有些用户可能在下单十几秒后才能收到下单成功的操作，但是比不能下单的体验要好

#### 应用解耦

> 以电商应用为例，应用中有订单系统、库存系统、物流系统、支付系统。用户创建订单后，如果耦合调用库存系统、物流系统、支付系统，任何一个子系统出了故障，都会造成下单操作异常。当转变成基于消息队列的方式后，系统间调用的问题会减少很多，比如物流系统因为发生故障，需要几分钟来修复。在这几分钟的时间里，物流系统要处理的内存被缓存在消息队列中，用户的下单操作可以正常完成。当物流系统恢复后，继续处理订单信息即可，中单用户感受不到物流系统的故障，提升系统的可用性

#### 异步处理

> 有些服务间调用是异步的，例如A调用B，B需要花费很长时间执行，但是A需要知道B什么时候可以执行完，以前一般有两种方式，A过一段时间去调用B的查询api查询。或者A提供一个callback api，B执行完之后调用api通知A服务。这两种方式都不是很优雅，使用消息总线，可以很方便解决这个问题，A调用B服务后，只需要监听B处理完成的消息，当B处理完成后，会发送一条消息给MQ，MQ会将此消息转发给A服务。这样A服务既不用循环调用B的查询api，也不用提供callback api。同样B服务也不用做这些操作。A服务还能及时的得到异步处理成功的消息。

### MQ分类

#### ActiveMQ

> 优点：单机吞吐量万级，时效性ms级，可用性高，基于主从架构实现高可用性，较低的概率丢失数据
>
> 缺点:官方社区现在对ActiveMQ 5.x维护越来越少，高吞吐量场景较少使用。

#### Kafka

> 大数据的杀手锏，谈到大数据领域内的消息传输，则绕不开Kafka，这款为大数据而生的消息中间件，以其百万级TPS的吞吐量名声大噪，迅速成为大数据领域的宠儿，在数据采集、传输、存储的过程中发挥着举足轻重的作用。目前已经被LinkedIn，Uber, Twitter, Netflix等大公司所采纳
>
> 优点: 性能卓越，单机写入TPS约在百万条/秒，最大的优点，就是吞吐量高。时效性ms级可用性非常高，kafka是分布式的，一个数据多个副本，少数机器宕机，不会丢失数据，不会导致不可用,消费者采用Pull方式获取消息, 消息有序, 通过控制能够保证所有消息被消费且仅被消费一次;有优秀的第三方Kafka Web管理界面Kafka-Manager；在日志领域比较成熟，被多家公司和多个开源项目使用；功能支持：功能较为简单，主要支持简单的MQ功能，在大数据领域的实时计算以及日志采集被大规模使用
>
> 缺点：Kafka单机超过64个队列/分区，Load会发生明显的飙高现象，队列越多，load越高，发送消息响应时间变长，使用短轮询方式，实时性取决于轮询间隔时间，消费失败不支持重试；支持消息顺序，但是一台代理宕机后，就会产生消息乱序，社区更新较慢；

#### RocketMQ

> RocketMQ出自阿里巴巴的开源产品，用Java语言实现，在设计时参考了 Kafka，并做出了自己的一些改进。被阿里巴巴广泛应用在订单，交易，充值，流计算，消息推送，日志流式处理，binglog分发等场景
>
> 优点:单机吞吐量十万级,可用性非常高，分布式架构,消息可以做到0丢失,MQ功能较为完善，还是分布式的，扩展性好,支持10亿级别的消息堆积，不会因为堆积导致性能下降,源码是java我们可以自己阅读源码，定制自己公司的MQ
>
> 缺点：支持的客户端语言不多，目前是java及c++，其中c++不成熟；社区活跃度一般,没有在MQ核心中去实现JMS等接口,有些系统要迁移需要修改大量代码

#### RabbitMQ

> 2007年发布，是一个在AMQP(高级消息队列协议)基础上完成的，可复用的企业消息系统，是当前最主流的消息中间件之一
>
> 优点:由于erlang语言的高并发特性，性能较好；吞吐量到万级，MQ功能比较完备,健壮、稳定、易用、跨平台、支持多种语言 如：Python、Ruby、.NET、Java、JMS、C、PHP、ActionScript、XMPP、STOMP等，支持AJAX文档齐全；开源提供的管理界面非常棒，用起来很好用,社区活跃度高；更新频率相当高
>
> 缺点：商业版需要收费,学习成本较高

### MQ的选择

#### Kafka

> Kafka主要特点是基于Pull的模式来处理消息消费，追求高吞吐量，一开始的目的就是用于日志收集和传输，适合产生大量数据的互联网服务的数据收集业务。大型公司建议可以选用，如果有日志采集功能，肯定是首选kafka了

#### RocketMQ

> 天生为金融互联网领域而生，对于可靠性要求很高的场景，尤其是电商里面的订单扣款，以及业务削峰，在大量交易涌入时，后端可能无法及时处理的情况。RoketMQ在稳定性上可能更值得信赖，这些业务场景在阿里双11已经经历了多次考验，如果你的业务有上述并发场景，建议可以选择RocketMQ

#### RabbitMQ

> 结合erlang语言本身的并发优势，性能好时效性微秒级，社区活跃度也比较高，管理界面用起来十分方便，如果你的数据量没有那么大，中小型公司优先选择功能比较完备的RabbitMQ

### RabbitMQ概念

> RabbitMQ是一个消息中间件：它接受并转发消息。你可以把它当做一个快递站点，当你要发送一个包裹时，你把你的包裹放到快递站，快递员最终会把你的快递送到收件人那里，按照这种逻辑RabbitMQ是一个快递站，一个快递员帮你传递快件。RabbitMQ与快递站的主要区别在于，它不处理快件而是接收，存储和转发消息数据

### 四大核心概念

> 生产者
>
> 产生数据发送消息的程序是生产者

> 交换机
>
> 交换机是RabbitMQ非常重要的一个部件，一方面它接收来自生产者的消息，另一方面它将消息推送到队列中。交换机必须确切知道如何处理它接收到的消息，是将这些消息推送到特定队列还是推送到多个队列，亦或者是把消息丢弃，这个得有交换机类型决定

> 队列
>
> 队列是RabbitMQ内部使用的一种数据结构，尽管消息流经RabbitMQ和应用程序，但它们只能存储在队列中。队列仅受主机的内存和磁盘限制的约束，本质上是一个大的消息缓冲区。许多生产者可以将消息发送到一个队列，许多消费者可以尝试从一个队列接收数据。这就是我们使用队列的方式

> 消费者
>
> 消费与接收具有相似的含义。消费者大多时候是一个等待接收消息的程序。请注意生产者，消费者和消息中间件很多时候并不在同一机器上。同一个应用程序既可以是生产者又是可以是消费者

## 安装

> 1. 将安装包拷贝到目录
> 2. rpm -ivh erlang-21.3.8.16-1.el7.x86_64.rpm
> 3. yum install socat -y
> 4. rpm -ivh rabbitmq-server-3.8.8-1.el7.noarch.rpm

> 添加开机启动RabbitMQ服务
> chkconfig rabbitmq-server on
>
> 启动服务
> /sbin/service rabbitmq-server start
>
> 查看服务状态
> /sbin/service rabbitmq-server status
>
> 停止服务(选择执行)
> /sbin/service rabbitmq-server stop

> 开启web管理插件
> rabbitmq-plugins enable rabbitmq_management

```
创建账号
rabbitmqctl add_user admin 123

设置用户角色
rabbitmqctl set_user_tags admin administrator

设置用户权限
set_permissions [-p <vhostpath>] <user> <conf> <write> <read>
rabbitmqctl set_permissions -p "/" admin ".*" ".*" ".*"
用户user_admin具有/vhost1这个virtual host中所有资源的配置、写、读权限

当前用户和角色
rabbitmqctl list_users
```



## Hello World

### 依赖

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <configuration>
                <source>8</source>
                <target>8</target>
            </configuration>
        </plugin>
    </plugins>
</build>

<dependencies>
    <!--rabbitmq依赖客户端-->
    <dependency>
        <groupId>com.rabbitmq</groupId>
        <artifactId>amqp-client</artifactId>
        <version>5.8.0</version>
    </dependency>
    <!--操作文件流的一个依赖-->
    <dependency>
        <groupId>commons-io</groupId>
        <artifactId>commons-io</artifactId>
        <version>2.6</version>
    </dependency>
</dependencies>
```

### 生产者

```java
public class Producer {
    //队列名称
    public static final String QUEUE_NAME = "hello";
    //发消息
    public static void main(String[] args) throws Exception {
        //创建连接工厂
        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("192.168.80.129");
        factory.setUsername("root");
        factory.setPassword("1234");

        //创建连接
        Connection connection = factory.newConnection();
        //获取信道
        Channel channel = connection.createChannel();

        /**
         * 创建一个队列
         * 第一个参数：队列名称
         * 第二个参数：队列中消息是否持久化，默认消息存储在内存中
         * 第三个参数：队列是否只供一个消费者消费，是否进行消息共享，true代表可以多个消费者消费
         * 第四个参数：是否自动删除，最后一个消费者断开链接以后，该队列是否自动删除
         * 第五个参数：其他参数
         */
        channel.queueDeclare(QUEUE_NAME,false,false,false,null);

        //发消息
        String msg = "Hello World";

        /**
         * 发送消息
         * 第一个参数：发送到哪个交换机
         * 第二个参数：路由的key值，本次是队列名称
         * 第三个参数：其他参数信息
         * 第四个参数：发送的消息体
         */
        channel.basicPublish("",QUEUE_NAME,null,msg.getBytes(StandardCharsets.UTF_8));

        System.out.println("消息发送完毕！");

    }
}
```

### 消费者

```java
public class Consumer {

    public static final String QUEUE_NAME = "hello";

    public static void main(String[] args) throws Exception{
        //创建连接工厂
        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("192.168.80.129");
        factory.setUsername("root");
        factory.setPassword("1234");
        //创建连接
        Connection connection = factory.newConnection();
        //获取信道
        Channel channel = connection.createChannel();

        DeliverCallback deliverCallback = (var1, var2) -> {
            String msg = new String(var2.getBody());
            System.out.println(msg);
        };

        CancelCallback cancelCallback = var1 -> {
            System.out.println("消费消息被中断！");
        };
        /**
         * 接收消息
         * 第一个参数：消费哪个队列
         * 第二个参数：消费成功后，是否要自动应答
         * 第三个参数：消费者未成功消费的回调
         * 第四个参数：消费者取消消费的回调
         */
        channel.basicConsume(QUEUE_NAME,true,deliverCallback,cancelCallback);
    }
}
```



## Work Queues

> 由多个消费者，一起处理生产者发来的消息

### 抽取工具类

```java
public class RabbitMQUtils {
    public static Channel getChannel(){
        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("192.168.80.129");
        factory.setUsername("root");
        factory.setPassword("1234");
        Connection connection = null;
        Channel channel = null;
        try {
            connection = factory.newConnection();
            channel = connection.createChannel();
        } catch (IOException | TimeoutException e) {
            e.printStackTrace();
        }
        return channel;
    }
}
```

### 消费者

```java
public class Worker01 {
    public static final String QUEUE_NAME = "hello";

    public static void main(String[] args) throws IOException {
        Channel channel = RabbitMQUtils.getChannel();
        DeliverCallback deliverCallback = (var1,var2) -> {
            System.out.println("接收到的消息：" + new String(var2.getBody()));
        };
        CancelCallback cancelCallback = (var1) -> {
            System.out.println(var1 + "取消消费");
        };
        channel.basicConsume(QUEUE_NAME,true,deliverCallback,cancelCallback);
    }
}
```

### 生产者

```java
public class Task01 {
    public static final String QUEUE_NAME = "hello";

    public static void main(String[] args) throws IOException {
        Channel channel = RabbitMQUtils.getChannel();
        channel.queueDeclare(QUEUE_NAME,false,false,false,null);
        Scanner sc = new Scanner(System.in);
        while (sc.hasNext()){
            String msg = sc.next();
            channel.basicPublish("",QUEUE_NAME,null,msg.getBytes(StandardCharsets.UTF_8));
            System.out.println("发送" + msg + "消息完成！");
        }
    }
}
```

```java
AA
发送AA消息完成！
BB
发送BB消息完成！
CC
发送CC消息完成！
DD
发送DD消息完成！
```

```
C1等待接收消息....
接收到的消息：AA
接收到的消息：CC
```

```
C2等待接收消息....
接收到的消息：BB
接收到的消息：DD
```

### 消息应答

> 

