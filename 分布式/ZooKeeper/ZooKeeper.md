# ZooKeeper

> ZooKeeper 是一个开源的分布式的，为分布式框架提供协调服务的Apache 项目

> ZooKeeper是一个树形目录结构
>
> 每个节点可以有数据和子节点，每个子节点叫做一个znode



## 安装

> 1. 下载
> 2. 解压
> 3. 进入conf目录，复制一份zoo_sample.cfg，改名为zoo.cfg
> 4. 在zk目录中创建zkdata文件夹用来保存数据
> 5. 编辑zoo.cfg，将dataDir=/tmp/zookeeper改为dataDir=/opt/apache-zookeeper-3.5.9-bin/zkdata

### 启动，停止

> 进入bin目录
>
> ./zkServer.sh start
>
> ./zkServer.sh stop
>
> ./zkServer.sh status



## ZooKeeper特点

### Znode节点

> 四种Znode
>
> 1. 持久节点：永久保存在zk中
> 2. 持久有序节点：永久保存在zk中，他会给节点添加一个有序的序号
> 3. 临时节点：当储存的客户端和zk断开连接时，这个节点删除
> 4. 临时有序节点：当储存的客户端和zk断开连接时，这个节点删除，他会给节点添加一个有序的序号

### 监听通知机制

> 客户端可以监听zk中的节点
>
> 节点改变时，会通知监听的客户端



## 常用命令

### 查

```sh
#查询当前节点下全部子节点
ls 节点名
```

```sh
#查询当前节点下数据
get 节点名
```

### 增

```sh
create [-s] [-e] 节点名 数据
```

> -s：代表有序节点
>
> -e：代表临时节点

### 改

```sh
set 节点名 数据
```

### 删

```sh
delete 节点名
rmr 节点名
```

> delete：删除没有子节点的节点
>
> rmr：删除当前节点和全部子节点（老版本写作deleteall）



## 集群

> ZooKeeper必须有master节点
>
> master：执行读写操作
>
> slave：只执行读操作
>
> 在没有master节点时，会进行重新选举

### 角色

> 1. Leader：也就是master
> 2. Follower：也就是slaver，参与选举投票，从节点的默认模式
> 3. Observer：也是Slaver，不参与选举投票
> 4. Looking：正在寻找Leader

### 投票策略

> 每一个zk服务都会被分配一个全局的myid
>
> zk执行写数据时，每一个节点都有自己的FIFO队列，保证写每一个数据的时候，顺序是不会乱的
>
> zk还会给每一个数据分配一个全局唯一的zxid，数据越新，zxid越大

> 1. 选举出zxid为最大的节点为Leader
> 2. zxid相同，选举myid的最大节点

### 搭建集群

> 在zkdata下创建myid文件（文件名必须为myid）
>
> 在其中为服务器指定id

> 修改配置文件，增加如下配置
>
> ```sh
> server.2=zk2:2888:3888
> server.3=zk3:2888:3888
> server.4=zk4:2888:3888
> ```
>
> server.A=B:C:D
>
> A代表第几号服务器，就是刚才设置的myid
>
> B是服务器的地址
>
> C代表互相之间交换数据使用的端口
>
> D代表选举时所用的通信端口



## Java操作ZooKeeper

### 依赖

```xml
<dependencies>
    <dependency>
        <groupId>org.apache.zookeeper</groupId>
        <artifactId>zookeeper</artifactId>
        <version>3.6.0</version>
    </dependency>
    <dependency>
        <groupId>org.apache.curator</groupId>
        <artifactId>curator-recipes</artifactId>
        <version>4.0.1</version>
    </dependency>
</dependencies>
```

### 创建连接

```java
public class ZkUtil {

    public static CuratorFramework cf(){
        RetryPolicy retryPolicy = new ExponentialBackoffRetry(3000,2);
        CuratorFramework cf = CuratorFrameworkFactory.builder().connectString("192.168.80.129:2181").retryPolicy(retryPolicy).build();
        cf.start();
        return cf;
    }
}
```

### 查询

```java
CuratorFramework cf = ZkUtil.cf();
List<String> strings = cf.getChildren().forPath("/");
for (String string : strings) {
    System.out.println(string);
}
```

```java
byte[] bytes = cf.getData().forPath("/aaa");
System.out.println(new String(bytes, StandardCharsets.UTF_8));
```

### 增加

```java
cf.create().withMode(CreateMode.PERSISTENT).forPath("/bbb","bbb_msg".getBytes(StandardCharsets.UTF_8));
```

### 修改

```java
cf.setData().forPath("/bbb","bbb_hello".getBytes(StandardCharsets.UTF_8));
```

### 删除

```java
cf.delete().deletingChildrenIfNeeded().forPath("/bbb");
```

### 查看节点状态

```java
Stat stat = cf.checkExists().forPath("/aaa");
System.out.println(stat);
```

### 监听通知机制

```java
CuratorFramework cf = ZkUtil.cf();
//创建NodeCache对象，指定要监听的node
NodeCache nodeCache = new NodeCache(cf,"/aaa");
nodeCache.start();

//添加监听器
nodeCache.getListenable().addListener(new NodeCacheListener() {
    @Override
    public void nodeChanged() throws Exception {
        byte[] data = nodeCache.getCurrentData().getData();
        Stat stat = nodeCache.getCurrentData().getStat();
        String path = nodeCache.getCurrentData().getPath();

        System.out.println("监听的节点是：" + path);
        System.out.println("节点现在数据是：" + new String(data,StandardCharsets.UTF_8));
        System.out.println("节点状态是：" + stat);
    }
});

System.out.println("开始监听...");
System.in.read();
```



## 分布式锁

```java
CuratorFramework cf = ZkUtil.cf();
InterProcessMutex lock = new InterProcessMutex(cf,"/lock");
//加锁
//lock.acquire();
lock.acquire(1, TimeUnit.SECONDS);	//指定超时时间
//释放锁
lock.release();
```

