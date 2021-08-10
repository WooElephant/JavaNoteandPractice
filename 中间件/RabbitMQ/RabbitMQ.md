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
>
> 默认访问端口15672

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

> 为了保证消息在发送过程中不丢失，rabbitmq引入消息应答机制，消息应答就是:消费者在接收到消息并且处理该消息之后，告诉rabbitmq它已经处理了，rabbitmq可以把该消息删除了

#### 自动应答

> 消息发送后立即被认为已经传送成功，这种模式需要在高吞吐量和数据传输安全性方面做权衡

#### 消息应答的方法

> - Channel.basicAck(用于肯定确认)
>
>   RabbitMQ已知道该消息并且成功的处理消息，可以将其丢弃了
>
> - Channel.basicNack(用于否定确认)
>
> - Channel.basicReject(用于否定确认)
>
>   与Channel.basicNack相比少一个参数
>
>   不处理该消息了直接拒绝，可以将其丢弃了

#### Multiple的解释

> multiple的true和false代表不同意思
>
> true代表批量应答channel上未应答的消息
>
> 比如说channel上有传送tag的消息 5,6,7,8 当前tag是8 那么此时
>
> 5-8的这些还未应答的消息都会被确认收到消息应答

> false同上面相比
>
> 只会应答tag=8的消息 5,6,7这三个消息依然不会被确认收到消息应答

#### 消息自动重新入队

> 如果消费者由于某些原因失去连接(其通道已关闭，连接已关闭或TCP连接丢失)，导致消息未发送ACK确认，RabbitMQ将了解到消息未完全处理，并将对其重新排队。如果此时其他消费者可以处理，它将很快将其重新分发给另一个消费者。这样，即使某个消费者偶尔死亡，也可以确保不会丢失任何消息

#### 消息手动应答代码实现

```java
public class Worker01 {
    public static final String TASK_QUEUE_NAME = "ack_queue";

    public static void main(String[] args) throws IOException {
        Channel channel = RabbitMQUtils.getChannel();
        System.out.println("C1等待接收消息....");

        DeliverCallback deliverCallback = (var1,var2) -> {
            //模拟处理过程，沉睡1秒
            SleepUtils.sleep(1);
            System.out.println("接收到的消息：" + new String(var2.getBody(), StandardCharsets.UTF_8));
            //应答
            //第一个参数：表示消息的标记
            //第二个参数：是否批量应答
            channel.basicAck(var2.getEnvelope().getDeliveryTag(),false);
        };
        CancelCallback cancelCallback = (var1) -> {
            System.out.println(var1 + "取消消费");
        };
        boolean autoAck = false;
        channel.basicConsume(TASK_QUEUE_NAME,autoAck,deliverCallback,cancelCallback);
    }
}
```

### 持久化

#### 队列持久化

```java
channel.queueDeclare(TASK_QUEUE_NAME,false,false,false,null);
channel.queueDeclare(TASK_QUEUE_NAME,true,false,false,null);
```

> 在我们创建队列的时候，第二个参数就是是否开启持久化
>
> 已经存在的非持久化队列，运行会报错
>
> 应该先删掉队列，再重新创建

#### 消息持久化

```java
channel.basicPublish("",TASK_QUEUE_NAME,null,msg.getBytes(StandardCharsets.UTF_8));

channel.basicPublish("",TASK_QUEUE_NAME, MessageProperties.PERSISTENT_TEXT_PLAIN,msg.getBytes(StandardCharsets.UTF_8));
```

> 发布消息时，第三个参数就是是否开启消息持久化
>
> MessageProperties.PERSISTENT_TEXT_PLAIN属性代表消息保存到磁盘

### 不公平分发

> 如果有两个消费者在处理任务，一个处理的很快，一个很慢。这种情况下轮训分发就不太好

```java
channel.basicQos(1);
boolean autoAck = false;
channel.basicConsume(TASK_QUEUE_NAME,autoAck,deliverCallback,cancelCallback);
```

> 在消费者接收消息之前
>
> 使用channel.basicQos(1);
>
> 更改为不公平分发

### 预取值

> 指定某个消费者的信道缓冲区大小

```java
channel.basicQos(4);
```

> 代表为此消费者信道中预存4条数据



## 发布确认

> 当我们要求队列和消息都进行持久化的时候
>
> 有可能这个消息还没来得及保存，就宕机，导致数据丢失
>
> 这个时候就需要发布确认
>
> 在队列持久化完成后进行回调通知

```java
Channel channel = RabbitMQUtils.getChannel();
channel.confirmSelect();
channel.queueDeclare(TASK_QUEUE_NAME,false,false,false,null);
```

> 在获得信道的时候，创建队列之前
>
> 使用channel.confirmSelect();启动发布确认

### 单个发布确认

> 发布一个消息之后只有它被确认发布，后续的消息才能继续发布

```java
//单个确认
public static void confirmMessageIndividually() throws Exception{
    Channel channel = RabbitMQUtils.getChannel();
    channel.queueDeclare("test_queue",true,false,false,null);
    channel.confirmSelect();
    long start = System.currentTimeMillis();

    for (int i = 0; i < 1000; i++) {
        String msg = i + "";
        channel.basicPublish("","test_queue",null,msg.getBytes(StandardCharsets.UTF_8));
        //消息确认
        boolean flag = channel.waitForConfirms();
        if (flag){
            System.out.println(msg + "消息发送成功");
        }
    }

    long end = System.currentTimeMillis();
    System.out.println("用时：" + (end - start));
}

//用时：617
```

### 批量发布确认

> 先发布一批消息然后一起确认可以极大地提高吞吐量
>
> 这种方式的缺点就是:当发生故障导致发布出现问题时，不知道是哪个消息出现问题了，我们必须将整个批处理保存在内存中，以记录重要的信息而后重新发布消息

```java
//批量确认
public static void confirmMessageBatch() throws Exception{
    Channel channel = RabbitMQUtils.getChannel();
    channel.queueDeclare("test_queue",true,false,false,null);
    channel.confirmSelect();
    long start = System.currentTimeMillis();

    for (int i = 0; i < 1000; i++) {
        String msg = i + "";
        channel.basicPublish("","test_queue",null,msg.getBytes(StandardCharsets.UTF_8));
        //消息确认
        if ( i%100 == 0 ){
            boolean flag = channel.waitForConfirms();
            if (flag){
                System.out.println("本批数据发送成功");
            }
        }
    }

    long end = System.currentTimeMillis();
    System.out.println("用时：" + (end - start));
}

//用时：77
```

### 异步确认发布

> 异步确认虽然编程逻辑比上两个要复杂，但是性价比最高
>
> 无论是可靠性还是效率都没得说，他是利用回调函数来达到消息可靠性传递的

```java
//异步确认
public static void confirmMessageAsync() throws Exception{
    Channel channel = RabbitMQUtils.getChannel();
    channel.queueDeclare("test_queue",true,false,false,null);
    channel.confirmSelect();
    long start = System.currentTimeMillis();

    //准备消息的监听器，监听哪些消息成功，哪些消息失败
    ConfirmCallback confirmCallback = (var1,var3) -> {
        System.out.println(var1 + "消息已确认");
    };
    ConfirmCallback nackCallback = (var1,var3) -> {
        System.out.println("未确认的消息：" + var1);
    };
    channel.addConfirmListener(confirmCallback,nackCallback);

    for (int i = 0; i < 1000; i++) {
        String msg = i + "";
        channel.basicPublish("","test_queue",null,msg.getBytes(StandardCharsets.UTF_8));
    }

    long end = System.currentTimeMillis();
    System.out.println("用时：" + (end - start));
}

//用时：43
```

```java
//异步确认
public static void confirmMessageAsync() throws Exception{
    Channel channel = RabbitMQUtils.getChannel();
    channel.queueDeclare("test_queue",true,false,false,null);
    channel.confirmSelect();

    /**
     * 线程安全有序的一个哈希表，适用于高并发的情况 *
     * 1.轻松的将序号与消息进行关联
     * 2.轻松批量删除条目 只要给到序列号
     * 3.支持并发访问
     */
    ConcurrentSkipListMap<Long,String> outstandingConfirms = new ConcurrentSkipListMap<>();

    ConfirmCallback confirmCallback = (var1,var3) -> {
        //删除已确认消息
        //判断是否是批量
        if (var3){
            ConcurrentNavigableMap<Long, String> confirmed = outstandingConfirms.headMap(var1);
            confirmed.clear();
        }else {
            outstandingConfirms.remove(var1);
        }
        System.out.println(var1 + "消息已确认");
    };
    ConfirmCallback nackCallback = (var1,var3) -> {
        //打印未确认消息
        String msg = outstandingConfirms.get(var1);
        System.out.println("未确认的消息：" + msg);
    };
    channel.addConfirmListener(confirmCallback,nackCallback);

    for (int i = 0; i < 1000; i++) {
        String msg = i + "";
        //记录所有要发送的消息
        // channel.getNextPublishSeqNo()获取信道下一次要发送的编号
        outstandingConfirms.put(channel.getNextPublishSeqNo(),msg);

        channel.basicPublish("","test_queue",null,msg.getBytes(StandardCharsets.UTF_8));
    }

}
```

> 使用一个哈希表来保存要发送的数据
>
> 以及后调后的处理



## 交换机

> 如果我们希望消息可以被多个消费者得到
>
> 就要使用发布订阅模式

> RabbitMQ消息传递模型的核心思想是: 生产者生产的消息从不会直接发送到队列
>
> 生产者只能将消息发送到交换机(exchange)
>
> 交换机工作的内容非常简单，一方面它接收来自生产者的消息，另一方面将它们推入队列
>
> 交换机必须确切知道如何处理收到的消息
>
> 是应该把这些消息放到特定队列还是说把他们到许多队列中还是说应该丢弃它们
>
> 这就的由交换机的类型来决定

> Exchanges的类型
>
> 直接(direct), 主题(topic) ,标题(headers) , 扇出(fanout)

> 之前我们使用空串，来访问的是默认交换机

### 绑定

> binding其实是exchange和queue之间的桥梁，它告诉我们exchange和那个队列进行了绑定关系

### Fanout

> 它是将接收到的所有消息，广播到它知道的所有队列中

```java
public static void main(String[] args) throws IOException {
    Channel channel = RabbitMQUtils.getChannel();
    //声明交换机
    // 第一个参数是交换机的名称
    // 第二个参数是交换机的模式
    channel.exchangeDeclare("logs","fanout");

    //通过信道获取一个临时队列
    // 队列的名称是随机的，当消费者断开连接时，队列自动删除
    String queue = channel.queueDeclare().getQueue();

    //绑定交换机与队列
    // 第一个值是队列名
    // 第二个值是交换机名
    // 第三个值是routingKey
    channel.queueBind(queue,"logs","");

    System.out.println("01等待接收消息...");
    DeliverCallback deliverCallback = (var1,var2) -> {
        System.out.println("01接收到的消息：" + new String(var2.getBody(),StandardCharsets.UTF_8));
    };
    CancelCallback cancelCallback = var1 -> {};
    channel.basicConsume(queue,true,deliverCallback,cancelCallback);

}
```

```java
public static void main(String[] args) throws IOException {
    Channel channel = RabbitMQUtils.getChannel();
    channel.exchangeDeclare("logs","fanout");
    Scanner sc = new Scanner(System.in);

    while (sc.hasNext()){
        String msg = sc.next();
        channel.basicPublish("logs","",null,msg.getBytes(StandardCharsets.UTF_8));
        System.out.println("消息：" + msg + "发送成功");
    }
}
```

### Direct

> 绑定routingKey，以达到不同的routingKey发送给不同的信道

```java
public static void main(String[] args) throws IOException {
    Channel channel = RabbitMQUtils.getChannel();
    channel.exchangeDeclare("direct_logs", BuiltinExchangeType.DIRECT);

    channel.queueDeclare("console",false,false,false,null);
    channel.queueBind("console","direct_logs","info");
    channel.queueBind("console","direct_logs","warning");

    System.out.println("01等待接收消息...");
    DeliverCallback deliverCallback = (var1,var2) -> {
        System.out.println("01接收到的消息：" + new String(var2.getBody(),StandardCharsets.UTF_8));
    };
    CancelCallback cancelCallback = var1 -> {};
    channel.basicConsume("console",true,deliverCallback,cancelCallback);
}
```

```java
public static void main(String[] args) throws IOException {
    Channel channel = RabbitMQUtils.getChannel();

    channel.basicPublish("direct_logs","info",null,"info msg".getBytes(StandardCharsets.UTF_8));
    channel.basicPublish("direct_logs","warning",null,"warning msg".getBytes(StandardCharsets.UTF_8));
    channel.basicPublish("direct_logs","error",null,"error msg".getBytes(StandardCharsets.UTF_8));

}
```

### Topics

> Direct不能写多个routingKey
>
> 但我们又需要这种功能，就出现了Topics交换机

> 发送到类型是topic交换机的消息的routing_key不能随意写，必须满足一定的要求
>
> 它必须是一个单词列表，以点号分隔开
>
> 这些单词可以是任意单词，比如说："stock.usd.nyse", "nyse.vmw", "quick.orange.rabbit".这种类型的
>
> 在这个规则列表中，其中有两个替换符是大家需要注意的
>
> *(星号)可以代替一个单词
>
> #(井号)可以替代零个或多个单词

#### 匹配案例

> Q1-->绑定的是
> 中间带orange带3个单词的字符串(\*.orange.\*)
>
> Q2-->绑定的是
> 最后一个单词是rabbit的3个单词(\*.*.rabbit)
> 第一个单词是lazy的多个单词(lazy.#)

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\中间件\RabbitMQ\rabbit1.jpg)

|        routingKey        |                   接收方                   |
| :----------------------: | :----------------------------------------: |
|   quick.orange.rabbit    |                 Q1Q2接收到                 |
|   lazy.orange.elephant   |                 Q1Q2接收到                 |
|     quick.orange.fox     |                  Q1接收到                  |
|      lazy.brown.fox      |                  Q2接收到                  |
|     lazy.pink.rabbit     |    虽然满足两个绑定但只被队列Q2接收一次    |
|     quick.brown.fox      | 不匹配任何绑定不会被任何队列接收到会被丢弃 |
| quick.orange.male.rabbit |      是四个单词不匹配任何绑定会被丢弃      |
| lazy.orange.male.rabbit  |             是四个单词但匹配Q2             |

> 当队列绑定关系是下列这种情况时需要引起注意
>
> 当一个队列绑定键是#,那么这个队列将接收所有数据，就有点像fanout了
>
> 如果队列绑定键当中没有#和*出现，那么该队列绑定类型就是direct了

#### 代码实现

```java
public static final String EXCHANGE_NAME = "topic_logs";

public static void main(String[] args) throws IOException {
    Channel channel = RabbitMQUtils.getChannel();
    //声明交换机
    channel.exchangeDeclare(EXCHANGE_NAME,BuiltinExchangeType.TOPIC);
    //声明队列
    channel.queueDeclare("Q1",false,false,false,null);
    //绑定
    channel.queueBind("Q1",EXCHANGE_NAME,"*.orange.*");

    System.out.println("Q1等待接收消息...");
    DeliverCallback deliverCallback = (var1,var2) -> {
        System.out.println("Q1接收到的消息：" + new String(var2.getBody(),StandardCharsets.UTF_8));
    };
    CancelCallback cancelCallback = var1 -> {};
    channel.basicConsume("Q1",true,deliverCallback,cancelCallback);
}
```

```java
public static final String EXCHANGE_NAME = "topic_logs";

public static void main(String[] args) throws IOException {
    Channel channel = RabbitMQUtils.getChannel();

    Map<String,String> bindingKeyMap = new HashMap<>();
    bindingKeyMap.put("quick.orange.rabbit","Q1Q2接收到");
    bindingKeyMap.put("lazy.orange.elephant","Q1Q2接收到");
    bindingKeyMap.put("quick.orange.fox","Q1接收到");
    bindingKeyMap.put("lazy.brown.fox","Q2接收到");
    bindingKeyMap.put("lazy.pink.rabbit","虽然满足两个绑定但只被队列Q2接收一次");
    bindingKeyMap.put("quick.brown.fox"," 不匹配任何绑定不会被任何队列接收到会被丢弃");
    bindingKeyMap.put("quick.orange.male.rabbit","是四个单词不匹配任何绑定会被丢弃");
    bindingKeyMap.put("lazy.orange.male.rabbit","是四个单词但匹配Q2");

    for (Map.Entry<String, String> entry : bindingKeyMap.entrySet()) {
        String key = entry.getKey();
        String value = entry.getValue();
        channel.basicPublish(EXCHANGE_NAME,key,null,value.getBytes(StandardCharsets.UTF_8));
        System.out.println("发送消息：" + value + "完成！");
    }

}
```

## 死信队列

> 死信，顾名思义就是无法被消费的消息
>
> 一般来说，producer将消息投递到broker或者直接到queue里了，consumer从queue取出消息进行消费，但某些时候由于特定的原因导致queue中的某些消息无法被消费，这样的消息如果没有后续的处理，就变成了死信，有死信自然就有了死信队列

> 死信的来源
>
> - 消息TTL过期
> - 队列达到最大长度(队列满了，无法再添加数据到mq中)
> - 消息被拒绝(basic.reject或basic.nack)并且requeue=false

### 案例

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\中间件\RabbitMQ\dead.jpg)

```java
public static final String NORMAL_EXCHANGE = "normal_exchange";
public static final String DEAD_EXCHANGE = "dead_exchange";

public static final String NORMAL_QUEUE = "normal_queue";
public static final String DEAD_QUEUE = "dead_queue";

public static void main(String[] args) throws IOException {
    Channel channel = RabbitMQUtils.getChannel();

    //声明死信和普通交换机  类型为direct
    channel.exchangeDeclare(NORMAL_EXCHANGE,BuiltinExchangeType.DIRECT);
    channel.exchangeDeclare(DEAD_EXCHANGE,BuiltinExchangeType.DIRECT);

    //声明死信队列
    channel.queueDeclare(DEAD_QUEUE,false,false,false,null);

    //声明普通队列
    HashMap<String, Object> map = new HashMap<>();
    //设置死信交换机是哪个
    map.put("x-dead-letter-exchange",DEAD_EXCHANGE);
    //设置死信routingKey
    map.put("x-dead-letter-routing-key","lisi");
    //设置过期时间 单位ms
    //也可以在发送的时候设置过期时间
    //map.put("x-message-ttl",1000*10);
    channel.queueDeclare(NORMAL_QUEUE,false,false,false,map);

    //绑定普通交换机与队列
    channel.queueBind(NORMAL_QUEUE,NORMAL_EXCHANGE,"zhangsan");
    //绑定死信交换机与队列
    channel.queueBind(DEAD_QUEUE,DEAD_EXCHANGE,"lisi");

    System.out.println("C1等待接收消息...");
    DeliverCallback deliverCallback = (var1, var2) -> {
        System.out.println("C1接收的消息：" + new String(var2.getBody(),StandardCharsets.UTF_8));
    };
    CancelCallback cancelCallback = var1 -> {};
    channel.basicConsume(NORMAL_QUEUE,true,deliverCallback,cancelCallback);
}
```

```java
public static final String NORMAL_EXCHANGE = "normal_exchange";

public static void main(String[] args) throws IOException {
    Channel channel = RabbitMQUtils.getChannel();

    //设置消息的参数
    AMQP.BasicProperties properties = new AMQP.BasicProperties().builder().expiration("10000").build();

    //发送消息，设置ttl
    for (int i = 1; i <= 10; i++) {
        String msg = "msg" + i;
        channel.basicPublish(NORMAL_EXCHANGE,"zhangsan",properties,msg.getBytes(StandardCharsets.UTF_8));
    }

}
```

```java
public static final String DEAD_QUEUE = "dead_queue";

public static void main(String[] args) throws IOException {

    Channel channel = RabbitMQUtils.getChannel();
    System.out.println("C2等待接收消息...");
    DeliverCallback deliverCallback = (var1, var2) -> {
        System.out.println("C2接收的消息：" + new String(var2.getBody(),StandardCharsets.UTF_8));
    };
    CancelCallback cancelCallback = var1 -> {};
    channel.basicConsume(DEAD_QUEUE,true,deliverCallback,cancelCallback);
}
```

> 我们关闭C1之后开启生产者
>
> 可以发现消息在队列中NORMAL_QUEUE存在10秒后，因为超时被自动转发到DEAD_QUEUE中
>
> 再开启C2，将其消费掉

```java
//设置队列长度
map.put("x-max-length",6);
```

> 在队列声明中的参数，加入x-max-length，即可设置队列最大长度
>
> 超出最大长度也会进入死信队列

```java
DeliverCallback deliverCallback = (var1, var2) -> {
    String msg = new String(var2.getBody(),StandardCharsets.UTF_8);
    if (msg.equals("msg5")){
        channel.basicReject(var2.getEnvelope().getDeliveryTag(),false);
    } else {
        channel.basicAck(var2.getEnvelope().getDeliveryTag(),false);
        System.out.println("C1接收的消息：" + new String(var2.getBody(),StandardCharsets.UTF_8));
    }
};
CancelCallback cancelCallback = var1 -> {};
channel.basicConsume(NORMAL_QUEUE,false,deliverCallback,cancelCallback);
```

> 在C1中也可以对消息进行拒收
>
> 其中第二个参数表示是否放回队列
>
> 这与应答时，第二个参数表示是否批量应答是不同的
>
> channel.basicConsume(NORMAL_QUEUE,false,deliverCallback,cancelCallback);
>
> 将自动应答（第二个参数）改为false



## 整合SpringBoot

```xml
<!--RabbitMQ依赖-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-amqp</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>fastjson</artifactId>
    <version>1.2.47</version>
</dependency>
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
</dependency>
<!--swagger-->
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>2.9.2</version>
</dependency>
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>2.9.2</version>
</dependency>
<!--RabbitMQ测试依赖-->
<dependency>
    <groupId>org.springframework.amqp</groupId>
    <artifactId>spring-rabbit-test</artifactId>
    <scope>test</scope>
</dependency>
```

```yaml
spring:
  rabbitmq:
    host: 192.168.80.129
    port: 5672
    username: root
    password: 1234
```

```java
package com.augus.rabbitmqspringboottest.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableSwagger2
public class SwaggerConfig {
    @Bean
    public Docket webApiConfig() {
        return new Docket(DocumentationType.SWAGGER_2).groupName("webApi").apiInfo(webApiInfo()).select()
                .build();
    }

    private ApiInfo webApiInfo() {
        return new ApiInfoBuilder().title("rabbitmq接口文档").description("本文档描述了rabbitmq微服务接口定义").version("1.0").contact(new Contact("zhangsan", "http://zhangsan.com", "zhangsan@qq.com")).build();
    }
}
```



## 延迟队列

### 使用场景

> 1. 订单在十分钟之内未支付则自动取消
> 2. 新创建的店铺，如果在十天内都没有上传过商品，则自动发送消息提醒
> 3. 用户注册成功后，如果三天内没有登陆则进行短信提醒
> 4. 用户发起退款，如果三天内没有得到处理则通知相关运营人员
> 5. 预定会议后，需要在预定的时间点前十分钟通知各个与会人员参加会议

### 案例

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\中间件\RabbitMQ\ttl.jpg)

#### 配置类

> 在SpringBoot中不再是生产者或消费者某一方代码中再声明交换机与队列
>
> 而是写在配置类当中

```java
@Configuration
public class TTLQueueConfig {

    //普通交换机
    public static final String X_EXCHANGE = "X";
    //死信交换机
    public static final String Y_DEAD_LETTER_EXCHANGE = "Y";
    //普通队列
    public static final String QUEUE_A = "QA";
    public static final String QUEUE_B = "QB";
    //死信队列
    public static final String DEAD_LETTER_QUEUE_D = "QD";

    //声明普通交换机
    @Bean("xExchange")
    public DirectExchange xExchange(){
        return new DirectExchange(X_EXCHANGE);
    }

    //声明死信交换机
    @Bean("yExchange")
    public DirectExchange yExchange(){
        return new DirectExchange(Y_DEAD_LETTER_EXCHANGE);
    }

    //声明普通队列
    @Bean("queueA")
    public Queue queueA(){
        HashMap<String, Object> arguments = new HashMap<>(3);
        //设置死信交换机
        arguments.put("x-dead-letter-exchange",Y_DEAD_LETTER_EXCHANGE);
        //设置死信RoutingKey
        arguments.put("x-dead-letter-routing-key","YD");
        //设置TTL
        arguments.put("x-message-ttl",10*1000);
        return QueueBuilder.durable(QUEUE_A).withArguments(arguments).build();
    }

    @Bean("queueB")
    public Queue queueB(){
        HashMap<String, Object> arguments = new HashMap<>(3);
        //设置死信交换机
        arguments.put("x-dead-letter-exchange",Y_DEAD_LETTER_EXCHANGE);
        //设置死信RoutingKey
        arguments.put("x-dead-letter-routing-key","YD");
        //设置TTL
        arguments.put("x-message-ttl",40*1000);
        return QueueBuilder.durable(QUEUE_B).withArguments(arguments).build();
    }

    //声明死信队列
    @Bean("queueD")
    public Queue queueD(){
        return QueueBuilder.durable(DEAD_LETTER_QUEUE_D).build();
    }

    //绑定
    @Bean
    public Binding queueABindingX(@Qualifier("queueA") Queue queueA,@Qualifier("xExchange") DirectExchange xExchange){
        return BindingBuilder.bind(queueA).to(xExchange).with("XA");
    }

    @Bean
    public Binding queueBBindingX(@Qualifier("queueB") Queue queueB,@Qualifier("xExchange") DirectExchange xExchange){
        return BindingBuilder.bind(queueB).to(xExchange).with("XB");
    }

    @Bean
    public Binding queueDBindingY(@Qualifier("queueD") Queue queueD,@Qualifier("yExchange") DirectExchange yExchange){
        return BindingBuilder.bind(queueD).to(yExchange).with("YD");
    }
    
}
```

#### 生产者

```java
@Slf4j
@RestController
@RequestMapping("/ttl")
public class SendMsgController {

    @Autowired
    private RabbitTemplate rabbitTemplate;

    @GetMapping("/sendMsg/{message}")
    public void sendMsg(@PathVariable String message){
        log.info("当前时间：{}，发送一条消息给两个队列：{}",new Date().toString(),message);
        rabbitTemplate.convertAndSend("X","XA","消息来自QA：" + message);
        rabbitTemplate.convertAndSend("X","XB","消息来自QB：" + message);
    }
}
```

#### 消费者

```java
@Slf4j
@Component
public class DeadLetterQueueConsumer {

    @RabbitListener(queues = "QD")
    public void recevieD(Message message, Channel channel){
        String msg = new String(message.getBody(), StandardCharsets.UTF_8);
        log.info("当前时间：{}，收到消息：{}",new Date().toString(),message);
    }

}
```

### 优化

> 如果我们需要延迟其他时间，还需要再创建队列，太麻烦

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\中间件\RabbitMQ\ttlv2.jpg)

> 增加一个QC队列，不再指定ttl
>
> 由发送方指定

```java
public static final String QUEUE_C = "QC";

@Bean("queueC")
public Queue queueC(){
    HashMap<String, Object> arguments = new HashMap<>(2);
    arguments.put("x-dead-letter-exchange",Y_DEAD_LETTER_EXCHANGE);
    arguments.put("x-dead-letter-routing-key","YD");
    return QueueBuilder.durable(QUEUE_C).withArguments(arguments).build();
}

@Bean
public Binding queueCBindingX(@Qualifier("queueC") Queue queueC,@Qualifier("xExchange") DirectExchange xExchange){
    return BindingBuilder.bind(queueC).to(xExchange).with("XC");
}
```

```java
@GetMapping("sendExpireMsg/{message}/{ttlTime}")
public void sendMsg(@PathVariable String message,@PathVariable String ttlTime){
    log.info("当前时间：{}，发送一条ttl为：{}，消息为：{}",new Date().toString(),ttlTime,message);
    //设置发送消息的ttl
    MessagePostProcessor messagePostProcessor = var1 -> {
        var1.getMessageProperties().setExpiration(ttlTime);
        return var1;
    };
    rabbitTemplate.convertAndSend("X","XC","消息来自QC：" + message,messagePostProcessor);
}
```

### 问题

> 这里出现了问题
>
> 如果我们发送一条延迟20s的消息2
>
> 再发一条延迟10s的消息1
>
> 结果是到了20s我们同时收到了2条消息
>
> 证明第二条的ttl跟随第一条而改变了

> 因为RabbitMQ只会检查第一个消息是否过期，如果过期则丢到死信队列
>
> 如果第一个消息的延时时长很长，而第二个消息的延时时长很短，第二个消息并不会优先得到执行

### 基于插件的延迟队列

> 1. 在官网上下载https://www.rabbitmq.com/community-plugins.html，下载rabbitmq_delayed_message_exchange插件
>
> 2. 放置到RabbitMQ的插件目录
>
>    cp rabbitmq_delayed_message_exchange-3.9.0.ez /usr/lib/rabbitmq/lib/rabbitmq_server-3.8.8/plugins/
>
> 3. 进入RabbitMQ的安装目录下的plgins目录，执行下面命令让该插件生效
>
>    rabbitmq-plugins enable rabbitmq_delayed_message_exchange
>
> 4. 然后重启RabbitMQ
>
>    systemctl restart rabbitmq-server

> 注意插件版本不要高于RabbitMQ的版本，不然会报错
>
> {:case_clause, {:plugin_built_with_incompatible_erlang, 'rabbitmq_delayed_message_exchange'}}

> 在网页后台管理界面中
>
> 新建交换机中有Type类型
>
> 如果出现x-delayed-message
>
> 证明插件已经生效

> 基于插件的延迟队列
>
> 交由交换机执行
>
> 不是由死信队列完成，而是在交换机中等待

### 基于插件的延迟队列代码实现

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\中间件\RabbitMQ\ttlplugin.jpg)

#### 配置文件

```java
@Configuration
public class DelayQueueConfig {

    //交换机
    public static final String DELAYED_EXCHANGE_NAME = "delayed.exchange";
    //队列
    public static final String DELAYED_QUEUE_NAME = "delayed.queue";
    //RoutingKey
    public static final String DELAYED_ROUTING_KEY = "delayed.routingKey";

    //声明交换机
    @Bean
    public CustomExchange delayedExchange(){
        HashMap<String, Object> arguments = new HashMap<>();
        arguments.put("x-delayed-type","direct");
        /**
         * 第一个参数    交换机名
         * 第二个参数    交换机类型
         * 第三个参数    是否需要持久化
         * 第四个参数    是否自动删除
         * 第五个参数    其他参数
         */
        CustomExchange customExchange = new CustomExchange(DELAYED_EXCHANGE_NAME,"x-delayed-message",
                false,false,arguments);

        return customExchange;
    }

    //声明队列
    @Bean
    public Queue delayedQueue(){
        return new Queue(DELAYED_QUEUE_NAME);
    }

    //绑定
    @Bean
    public Binding delayedQueueBindingDelayedExchange(@Qualifier("delayedQueue") Queue queue,
                                                      @Qualifier("delayedExchange") CustomExchange exchange){
        return BindingBuilder.bind(queue).to(exchange).with(DELAYED_ROUTING_KEY).noargs();
    }
}
```

#### 生产者

```java
@GetMapping("sendDelayMsg/{message}/{delayTime}")
public void sendDelayMsg(@PathVariable String message,@PathVariable Integer delayTime){
    log.info("当前时间：{}，发送一条delay为：{}，消息为：{}",new Date().toString(),delayTime,message);

    MessagePostProcessor messagePostProcessor = var1 -> {
        var1.getMessageProperties().setDelay(delayTime);
        return var1;
    };
    rabbitTemplate.convertAndSend(DelayQueueConfig.DELAYED_EXCHANGE_NAME,DelayQueueConfig.DELAYED_ROUTING_KEY,
            "消息来自延迟队列：" + message,messagePostProcessor);
}
```

#### 消费者

```java
@Slf4j
@Component
public class DelayQueueConsumer {

    @RabbitListener(queues = DelayQueueConfig.DELAYED_QUEUE_NAME)
    public void receiveDelayQueue(Message message){
        String msg = new String(message.getBody());
        log.info("当前时间：{}，收到消息：{}",new Date().toString(),msg);
    }
}
```



## 发布确认高级

> 生产者无法得知消息发送成功与否
>
> 如果服务器宕机，消息将会丢失

### 准备

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\中间件\RabbitMQ\confirminit.jpg)

```java
@Configuration
public class ConfirmConfig {

    public static final String CONFIRM_EXCHANGE_NAME = "confirm.exchange";
    public static final String CONFIRM_QUEUE_NAME = "confirm.queue";
    public static final String CONFIRM_ROUTING_KEY = "key1";

    @Bean
    public DirectExchange confirmExchange(){
        return new DirectExchange(CONFIRM_EXCHANGE_NAME);
    }

    @Bean
    public Queue confirmQueue(){
        return QueueBuilder.durable(CONFIRM_QUEUE_NAME).build();
    }

    @Bean
    public Binding confirmQueueBindingConfirmExchange(@Qualifier("confirmQueue") Queue queue,
                                                      @Qualifier("confirmExchange") DirectExchange exchange){
        return BindingBuilder.bind(queue).to(exchange).with(CONFIRM_ROUTING_KEY);
    }
}
```

```java
@GetMapping("sendConfirmMsg/{message}")
public void sendConfirmMsg(@PathVariable String message){
    log.info("发送消息：{}",message);
    rabbitTemplate.convertAndSend(ConfirmConfig.CONFIRM_EXCHANGE_NAME,ConfirmConfig.CONFIRM_ROUTING_KEY,message);
}
```

```java
@Slf4j
@Component
public class ConfirmConsumer {

    @RabbitListener(queues = ConfirmConfig.CONFIRM_QUEUE_NAME)
    public void receiveMsg(Message message){
        String msg = new String(message.getBody(), StandardCharsets.UTF_8);
        log.info("收到的消息：{}",msg);
    }
}
```

### 回调接口

```java
@Slf4j
@Component
public class MyCallBack implements RabbitTemplate.ConfirmCallback {

    @Autowired
    private RabbitTemplate rabbitTemplate;

    //将其注入回给RabbitTemplate
    @PostConstruct
    public void init(){
        rabbitTemplate.setConfirmCallback(this);
    }
    
    /**
     * 交换机确认回调方法
     * 第一个参数  保存回调消息的id和信息
     * 第二个参数  收到消息为true
     * 第三个参数  失败的原因
     */
    @Override
    public void confirm(CorrelationData correlationData, boolean b, String s) {
        String id = correlationData != null ? correlationData.getId() : "";
        if (b){
            log.info("交换机收到了消息，id为{}",id);
        }else {
            log.info("交换机未收到消息，id为{}，原因：{}",id,s);
        }
    }
}
```

```java
@GetMapping("sendConfirmMsg/{message}")
public void sendConfirmMsg(@PathVariable String message){
    CorrelationData correlationData = new CorrelationData("1");
    log.info("发送消息：{}",message);
    rabbitTemplate.convertAndSend(ConfirmConfig.CONFIRM_EXCHANGE_NAME,ConfirmConfig.CONFIRM_ROUTING_KEY,
            message,correlationData);
}
```

> CorrelationData是由发送方发送的

```yaml
spring:
  rabbitmq:
    host: 192.168.80.129
    port: 5672
    username: root
    password: 1234
    publisher-confirm-type: correlated
```

> 在配置文件中加入publisher-confirm-type: correlated
>
> 他有三个值
>
> none：禁用发布确认模式，是默认值
>
> correlated：发布消息成功到交换器后会触发回调方法
>
> simple：有两种效果，其一效果和CORRELATED值一样会触发回调方法，其二在发布消息成功后使用rabbitTemplate调用waitForConfirms或waitForConfirmsOrDie方法 等待broker节点返回发送结果，根据返回结果来判定下一步的逻辑，要注意的点是 waitForConfirmsOrDie方法如果返回false则会关闭channel，则接下来无法发送消息到broker

### 回退消息

> 到此我们已经处理了交换机和生产者之间的消息接收问题
>
> 那么交换机与信道之间的问题该怎么处理
>
> 通过Mandatory参数，可以将不可达目的地的消息回退给生产者

```yaml
spring:
  rabbitmq:
    host: 192.168.80.129
    port: 5672
    username: root
    password: 1234
    publisher-confirm-type: correlated
    publisher-returns: true
```

> 配置文件中使用publisher-returns: true

> 在接口实现类中，加一个RabbitTemplate.ReturnsCallback

```java
@Slf4j
@Component
public class MyCallBack implements RabbitTemplate.ConfirmCallback,RabbitTemplate.ReturnsCallback {

    @Autowired
    private RabbitTemplate rabbitTemplate;

    //将其注入回给RabbitTemplate
    @PostConstruct
    public void init(){
        rabbitTemplate.setConfirmCallback(this);
        rabbitTemplate.setReturnsCallback(this);
    }

	....

    @Override
    public void returnedMessage(ReturnedMessage returned) {
        log.error("消息{},被交换机{}退回了。路由key：{}，原因{}",returned.getMessage(),returned.getExchange(),
                returned.getRoutingKey(),returned.getReplyText());
    }

}
```



## 备份交换机

> 如果交换机无响应，则发送消息给备份交换机

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\中间件\RabbitMQ\backup.jpg)

### 代码实现

#### 配置类

```java
@Configuration
public class ConfirmConfig {

    public static final String CONFIRM_EXCHANGE_NAME = "confirm.exchange";
    public static final String CONFIRM_QUEUE_NAME = "confirm.queue";
    public static final String CONFIRM_ROUTING_KEY = "key1";

    public static final String BACKUP_EXCHANGE_NAME = "backup.exchange";
    public static final String BACKUP_QUEUE_NAME = "backup.queue";
    public static final String WARNING_QUEUE_NAME = "warning.queue";

    @Bean
    public FanoutExchange backupExchange(){
        return new FanoutExchange(BACKUP_EXCHANGE_NAME);
    }

    @Bean
    public Queue backupQueue(){
        return new Queue(BACKUP_QUEUE_NAME);
    }

    @Bean
    public Queue waringQueue(){
        return new Queue(WARNING_QUEUE_NAME);
    }

    @Bean
    public Binding backupQueueBindingBackupExchange(@Qualifier("backupQueue") Queue queue,
                                                    @Qualifier("backupExchange") FanoutExchange exchange){
        return BindingBuilder.bind(queue).to(exchange);
    }

    @Bean
    public Binding waringQueueBindingBackupExchange(@Qualifier("waringQueue") Queue queue,
                                                    @Qualifier("backupExchange") FanoutExchange exchange){
        return BindingBuilder.bind(queue).to(exchange);
    }

    //修改confirm.exchange，指向备份交换机
    @Bean
    public DirectExchange confirmExchange(){
        return ExchangeBuilder.directExchange(CONFIRM_EXCHANGE_NAME).durable(false)
                .withArgument("alternate-exchange",BACKUP_EXCHANGE_NAME).build();
    }
```

#### 消费者

```java
@Slf4j
@Component
public class WarningConsumer {
    @RabbitListener(queues = ConfirmConfig.WARNING_QUEUE_NAME)
    public void receiveWarningMsg(Message message){
        String msg = new String(message.getBody(), StandardCharsets.UTF_8);
        log.warn("发现不可路由消息：" + msg);
    }
}
```

#### 优先级

> 同时开启回退消息和交换机备份
>
> 交换机备份优先级更高



## 其他知识点

### 幂等性

> 消费者在消费MQ中的消息时，MQ已把消息发送给消费者
>
> 消费者在给MQ返回ack时网络中断，故MQ未收到确认信息
>
> 该条消息会重新发给其他的消费者，或者在网络重连后再次发送给该消费者
>
> 但实际上该消费者已成功消费了该条消息，造成消费者消费了重复的消息

> 解决思路
>
> 利用redis执行setnx命令，天然具有幂等性。从而实现不重复消费



### 优先级队列

> 可以为队列中的消息设置优先级

#### 代码实现

```java
Channel channel = RabbitMQUtils.getChannel();

//设置参数，允许优先级范围为0-10
HashMap<String, Object> arguments = new HashMap<>();
arguments.put("x-max-priority",10);
channel.queueDeclare("priority",true,false,false,arguments);

for (int i = 1; i <= 10; i++) {
    String msg = "msg" + i;
    if (i == 5){
        AMQP.BasicProperties properties = new AMQP.BasicProperties().builder().priority(5).build();
        channel.basicPublish("","priority",properties,msg.getBytes(StandardCharsets.UTF_8));
    }else {
        channel.basicPublish("","priority",null,msg.getBytes(StandardCharsets.UTF_8));
    }
}
```

> 这样msg5就会被优先消费



### 惰性队列

> 惰性队列接收到消息会将其保存在磁盘中，而不是内存中
>
> 需要使用时，消费者从磁盘中读取

> 如果消费者因为各种原因宕机，长时间不能处理，而导致消息堆积
>
> 这个时候惰性队列就有必要了

> 队列有两种模式default和lazy，默认为default

```java
HashMap<String, Object> arguments = new HashMap<>();
arguments.put("x-queue-mode","lazy");
channel.queueDeclare("my_queue",false,false,false,arguments);
```

> 在100万条消息情况下，普通队列占用内存1.2G，惰性队列占用1.5MB



## 集群

### 搭建

> 1. 修改3台机器的主机名称
>    vim /etc/hostname
> 2. 配置各个节点的 hosts 文件，让各个节点都能互相识别对方
>    vim /etc/hosts
>    10.211.55.74 node1
>    10.211.55.75 node2
>    10.211.55.76 node3
> 3. 以确保各个节点的cookie文件使用的是同一个值
>    在node1上执行远程操作命令
>    scp /var/lib/rabbitmq/.erlang.cookie root@node2:/var/lib/rabbitmq/.erlang.cookie
>    scp /var/lib/rabbitmq/.erlang.cookie root@node3:/var/lib/rabbitmq/.erlang.cookie
> 4. 启动RabbitMQ服务,顺带启动Erlang虚拟机和RbbitMQ应用服务(在三台节点上分别执行以下命令)
>    rabbitmq-server -detached
> 5. 在节点2执行
>    rabbitmqctl stop_app
>    (rabbitmqctl stop会将Erlang虚拟机关闭，rabbitmqctl stop_app只关闭RabbitMQ服务)
>    rabbitmqctl reset
>    rabbitmqctl join_cluster rabbit@node1
>    rabbitmqctl start_app(只启动应用服务)
> 6. 在节点3执行
>    rabbitmqctl stop_app
>    rabbitmqctl reset
>    rabbitmqctl join_cluster rabbit@node2
>    rabbitmqctl start_app
> 7. 集群状态
>    rabbitmqctl cluster_status
> 8. 需要重新设置用户
>    创建账号
>    rabbitmqctl add_user admin 123
>    设置用户角色
>    rabbitmqctl set_user_tags admin administrator
>    设置用户权限
>    rabbitmqctl set_permissions -p "/" admin ".\*" ".\*" ".*"
> 9. 解除集群节点(node2和node3机器分别执行)
>    rabbitmqctl stop_app
>    rabbitmqctl reset
>    rabbitmqctl start_app
>    rabbitmqctl cluster_status
>    rabbitmqctl forget_cluster_node rabbit@node2(node1机器上执行)



### 镜像队列

> 当前如果访问一号节点创建队列，当一号节点挂掉，队列就不存在了
>
> 我们应该将其备份

> 开启方法
>
> 在任意节点上，点开Admin标签，点击policies填写配置

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\中间件\RabbitMQ\policy.jpg)

> pattern：^mirrior	表示以mirrior为前缀的队列进行备份
>
> ha-mode：exactly	表示永远保留几份
>
> ha-params：2	总共两份，也就是额外备份一份
>
> ha-sync-mode：automatic	表示自动备份

> 比如一个队列存在1上，2号自动备份
>
> 当1宕机，这个队里会存在2号和3号上，永远保持2份



### 负载均衡

> 现在还是在连接一个MQ，如果此台宕机，并不会自动变更连接的ip
>
> 使用Haproxy，Nginx等软件都可以达到消息转发的效果



### Federation Exchange

> 1. 需要保证每台节点单独运行
> 2. 在每台机器上开启federation相关插件
>    rabbitmq-plugins enable rabbitmq_federation
>    rabbitmq-plugins enable rabbitmq_federation_management

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\中间件\RabbitMQ\fed.jpg)

> 我们要为下游节点准备好交换机，并且配置好

```java
//连接到下游服务器
ConnectionFactory factory = new ConnectionFactory();
factory.setHost("192.168.80.130");
factory.setUsername("root");
factory.setPassword("1234");
Connection connection = factory.newConnection();
Channel channel = connection.createChannel();

channel.exchangeDeclare("fed_exchange",BuiltinExchangeType.DIRECT);
```

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\中间件\RabbitMQ\fedconfig.jpg)

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\中间件\RabbitMQ\fedpolicy.jpg)

> 在右侧Federation Status可以查看是否设置成功



### Federation Queue

> 添加上游UpStream同上

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\中间件\RabbitMQ\fedQueuePolicy.jpg)

### Shovel

> 开启插件(需要的机器都开启)
> rabbitmq-plugins enable rabbitmq_shovel
> rabbitmq-plugins enable rabbitmq_shovel_management

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\中间件\RabbitMQ\shovel.jpg)

