# ZooKeeper

> Zookeeper 是一个开源的分布式的，为分布式框架提供协调服务的Apache 项目

> 特点
>
> 1. Zookeeper：一个领导者（Leader），多个跟随者（Follower）组成的集群
> 2. 集群中只要有半数以上节点存活，Zookeeper集群就能正常服务。所以Zookeeper适合安装奇数台服务器
> 3. 全局数据一致：每个Server保存一份相同的数据副本，Client无论连接到哪个Server，数据都是一致的
> 4. 更新请求顺序执行，来自同一个Client的更新请求按其发送顺序依次执行
> 5. 数据更新原子性，一次数据更新要么成功，要么失败
> 6. 实时性，在一定时间范围内，Client能读到最新数据

## 数据结构

> ZooKeeper数据模型的结构与Unix文件系统很类似，整体上可以看做是一棵树，每个节点称作一个ZNode，每个ZNode默认能存储1MB的数据，每个ZNode都可以通过其路径唯一标识



## 应用场景

> 统一命名服务、统一配置管理、统一集群管理、服务器节点动态上下线、软负载均衡等



## 运行

> 开启服务器

```sh
zkServer.sh start
```

> 开启客户端

```sh
zkCli.sh
```



## 配置文件

> 在conf目录下有一个zoo_sample.cfg实例配置文件
>
> 将其修改为zoo.cfg

> **tickTime=2000**
>
> 通信心跳时间，Zookeeper服务器与客户端心跳时间，单位毫秒

> **initLimit = 10**
>
> LF初始通信时限
>
> Leader和Follower初始连接时能容忍的最多心跳数（tickTime的数量）

> **syncLimit = 5**
>
> LF同步通信时限
>
> Leader和Follower之间通信时间如果超过syncLimit * tickTime，Leader认为Follwer死掉，从服务器列表中删除Follwer

> **dataDir**
>
> 保存Zookeeper中的数据
>
> 注意：默认的tmp目录，容易被Linux系统定期删除，所以一般不用默认的tmp目录

> **clientPort = 2181**
>
> 客户端连接端口，通常不做修改



## 集群操作

### 安装

> 1. 将安装包解压
> 2. 在安装目录下创建zkData用来保存数据
> 3. 在zkData下创建myid文件
> 4. 在文件中填写服务器id
> 5. 将配置好的整个文件夹拷贝到其他服务器并修改id的值

### 配置

> 重命名conf目录下的zoo_sample.cfg为zoo.cfg
>
> 打开zoo.cfg文件
>
> 修改数据存储路径配置
>
> 增加如下配置
>
> ```
> server.2=hadoop102:2888:3888
> server.3=hadoop103:2888:3888
> server.4=hadoop104:2888:3888
> ```
> 将配置文件分发给其他机器

> **server.A=B:C:D**
>
> **A	**表示这是第几号服务器，myid中定义的数值
>
> **B**	是这个服务器的地址
>
> **C**	是这个服务器 Follower与集群中的 Leader服务器交换信息的端口
>
> **D**	是万一集群中的 Leader服务器挂了，需要一个端口来重新进行选举，选出一个新的Leader，而这个端口就是用来执行选举时服务器相互通信的端口

