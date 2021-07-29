# Redis

## NoSQL

### 概述

> NoSQL(NoSQL = Not Only SQL )，意即“不仅仅是SQL”，泛指非关系型的数据库
>
> NoSQL 不依赖业务逻辑方式存储，而以简单的key-value模式存储因此大大的增加了数据库的扩展能力
>
> 不遵循SQL标准
>
> 不支持ACID
>
> 远超于SQL的性能



### 适用场景

> 对数据高并发的读写
>
> 海量数据的读写
>
> 对数据高可扩展性的



### 不适用场景

> 需要事务支持
>
> 基于sql的结构化查询存储，处理复杂的关系，需要即席查询
>
> 用不着sql的和用了sql也不行的情况，请考虑用NoSql



## Redis概述和安装

> Redis是一个开源的key-value存储系统
>
> 和Memcached类似，它支持存储的value类型相对更多，包括string(字符串)、list(链表)、set(集合)、zset(sorted set --有序集合)和hash（哈希类型）
>
> 这些数据类型都支持push/pop、add/remove及取交集并集和差集及更丰富的操作，而且这些操作都是原子性的
>
> 在此基础上，Redis支持各种不同方式的排序
>
> 与memcached一样，为了保证效率，数据都是缓存在内存中
>
> 区别的是Redis会周期性的把更新的数据写入磁盘或者把修改操作写入追加的记录文件
>
> 并且在此基础上实现了master-slave(主从)同步



### 应用场景

#### 配合关系型数据库做高速缓存

> 高频次，热门访问的数据，降低数据库IO
>
> 分布式架构，做session共享

#### 多样的数据结构存储持久化数据

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片4.jpg)



### 安装

> 1. 从官网下载安装包，上传至opt目录
>
> 2. Redis需要C语言环境gcc
>
>    ```sh
>    yum install gcc
>    ```
>
> 3. 解压压缩包，进入解压后的文件夹
>
>    ```sh
>    tar -zxvf redis-xxx
>    ```
>
> 4. 执行make命令进行编译
>
>    如果有了gcc还报错，尝试运行make distclean清除编译缓存
>
> 5. 执行make install开始安装

> 默认安装路径：/usr/local/bin
>
> redis-benchmark:性能测试工具，可以在自己本子运行，看看自己电脑性能如何
>
> redis-check-aof：修复有问题的AOF文件，rdb和aof后面讲
>
> redis-check-dump：修复有问题的dump.rdb文件
>
> redis-sentinel：Redis集群使用
>
> **redis-server：Redis服务器启动命令**
>
> **redis-cli：客户端，操作入口**



### 启动

```sh
redis-server
```

> 前台启动**不推荐**

> **推荐使用后台启动**
>
> 在刚才的安装目录中有一个redis.conf文件，将其复制一份
>
> 将daemonize 从no改为yes
>
> 使用命令后台启动

```sh
redis-server /配置文件所在目录/redis.conf
```



### 关闭

> 可以使用redis-cli进入内部使用shutdown关闭
>
> 或者直接使用redis-cli shutdown关闭
>
> 如果有多个redis实例
>
> 可以使用redis-cli -p 6379 shutdown（指定端口号关闭）



### 相关知识

> 默认端口6379

> 默认16个数据库，类似数组下标从0开始，初始默认使用0号库
>
> 使用命令 select   <dbid>来切换数据库。如: select 8 
>
> 统一密码管理，所有库同样密码

> dbsize查看当前数据库的key的数量
>
> flushdb清空当前库
>
> flushall通杀全部库



## 常用数据类型

### Redis键（Key）

> * **keys ***	查看当前库所有key    (匹配：keys *1)
> * **exists key**    判断某个key是否存在
> * **type key**     查看你的key是什么类型
> * **del key**       删除指定的key数据
> * **unlink key**   根据value选择非阻塞删除，仅将keys从keyspace元数据中删除，真正的删除会在后续异步操作
> * **expire key 10**   10秒钟：为给定的key设置过期时间
> * **ttl key**   查看还有多少秒过期，-1表示永不过期，-2表示已过期
> * **select**    命令切换数据库
> * **dbsize**    查看当前数据库的key的数量
> * **flushdb**    清空当前库
> * **flushall**    通杀全部库



### 字符串String

> String是Redis最基本的类型，一个key对应一个value
>
> String类型是二进制安全的。意味着Redis的string可以包含任何数据。比如jpg图片或者序列化的对象
>
> String类型是Redis最基本的数据类型，一个Redis中字符串value最多可以是512M

|                     命令                      |                             效果                             |
| :-------------------------------------------: | :----------------------------------------------------------: |
|              set  \<key>\<value>              |                          添加键值对                          |
|                  get  \<key>                  |                         查询对应键值                         |
|            append  \<key>\<value>             |              将给定的\<value> 追加到原值的末尾               |
|                strlen  \<key>                 |                         获得值的长度                         |
|             setnx  \<key>\<value>             |               只有在 key 不存在时设置 key 的值               |
|                  incr \<key>                  | 将 key 中储存的数字值增1，只能对数字值操作，如果为空，新增值为1 |
|                  decr \<key>                  | 将 key 中储存的数字值减1，只能对数字值操作，如果为空，新增值为-1 |
|         incrby / decrby \<key>\<步长>         |            将 key 中储存的数字值增减。自定义步长             |
|  mset \<key1>\<value1>\<key2>\<value2> .....  |                同时设置一个或多个 key-value对                |
|       mget \<key1>\<key2>\<key3> .....        |                   同时获取一个或多个 value                   |
| msetnx \<key1>\<value1>\<key2>\<value2> ..... | 同时设置一个或多个 key-value 对，当且仅当所有给定 key 都不存在 |
|    getrange  \<key>\<起始位置>\<结束位置>     |       获得值的范围，类似java中的substring，前包，后包        |
|      setrange  \<key><起始位置>\<value>       | 用 \<value>  覆写\<key>所储存的字符串值，从<起始位置>开始(索引从0开始) |
|        setex  \<key><过期时间>\<value>        |             设置键值的同时，设置过期时间，单位秒             |
|             getset \<key>\<value>             |               以新换旧，设置了新值同时获得旧值               |

> Redis中的操作是具有原子性的，一个失败全部失败

> String的数据结构为简单动态字符串(Simple Dynamic String,缩写SDS)
>
> 是可以修改的字符串，内部结构实现上类似于Java的ArrayList
>
> 采用预分配冗余空间的方式来减少内存的频繁分配



### 列表List

> 单键多值
>
> Redis 列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的头部（左边）或者尾部（右边）
>
> 它的底层实际是个双向链表

|                        命令                         |                       功能                       |
| :-------------------------------------------------: | :----------------------------------------------: |
| lpush/rpush  \<key>\<value1>\<value2>\<value3> .... |           从左边/右边插入一个或多个值            |
|                  lpop/rpop  \<key>                  |    从左边/右边吐出一个值。值在键在，值光键亡     |
|              rpoplpush  \<key1>\<key2>              | 从\<key1>列表右边吐出一个值，插到\<key2>列表左边 |
|            lrange \<key>\<start>\<stop>             |          按照索引下标获得元素(从左到右)          |
|                 lrange mylist 0 -1                  | 0左边第一个，-1右边第一个，（0  -1表示获取所有） |
|                lindex \<key>\<index>                |          按照索引下标获得元素(从左到右)          |
|                     llen \<key>                     |                   获得列表长度                   |
|  linsert \<key>  before/after \<value>\<newvalue>   |    在\<value>的前面/后面插入\<newvalue>插入值    |
|               lrem \<key>\<n>\<value>               |           从左边删除n个value(从左到右)           |
|             lset \<key>\<index>\<value>             |       将列表key下标为index的值替换成value        |

> List的数据结构为快速链表quickList
>
> 首先在列表元素较少的情况下会使用一块连续的内存存储，这个结构是ziplist，也即是压缩列表
>
> 它将所有的元素紧挨着一起存储，分配的是一块连续的内存
>
> 当数据量比较多的时候才会改成quicklist
>
> 因为普通的链表需要的附加指针空间太大，会比较浪费空间
>
> 比如这个列表里存的只是int类型的数据，结构上还需要两个额外的指针prev和next
>
> Redis将链表和ziplist结合起来组成了quicklist
>
> 也就是将多个ziplist使用双向指针串起来使用
>
> 这样既满足了快速的插入删除性能，又不会出现太大的空间冗余



### 集合Set

> Redis set对外提供的功能与list类似是一个列表的功能，特殊之处在于set是可以自动排重的，当你需要存储一个列表数据，又不希望出现重复数据时，set是一个很好的选择，并且set提供了判断某个成员是否在一个set集合内的重要接口，这个也是list所不能提供的
>
> Redis的Set是string类型的无序集合
>
> 它底层其实是一个value为null的hash表，所以添加，删除，查找的复杂度都是O(1)

|                 命令                  |                             功能                             |
| :-----------------------------------: | :----------------------------------------------------------: |
|  sadd \<key>\<value1>\<value2> .....  | 将一个或多个 member 元素加入到集合 key 中，已经存在的 member 元素将被忽略 |
|            smembers \<key>            |                      取出该集合的所有值                      |
|       sismember \<key>\<value>        |       判断集合\<key>是否为含有该\<value>值，有1，没有0       |
|              scard\<key>              |                     返回该集合的元素个数                     |
|  srem \<key>\<value1>\<value2> ....   |                     删除集合中的某个元素                     |
|              spop \<key>              |                   随机从该集合中吐出一个值                   |
|        srandmember \<key>\<n>         |          随机从该集合中取出n个值。不会从集合中删除           |
| smove \<source>\<destination>\<value> |           把集合中一个值从一个集合移动到另一个集合           |
|         sinter \<key1>\<key2>         |                    返回两个集合的交集元素                    |
|         sunion \<key1>\<key2>         |                    返回两个集合的并集元素                    |
|         sdiff \<key1>\<key2>          |       返回两个集合的差集元素(key1中的，不包含key2中的)       |

> Set数据结构是dict字典，字典是用哈希表实现的
>
> Java中HashSet的内部实现使用的是HashMap，只不过所有的value都指向同一个对象
>
> Redis的set结构也是一样，它的内部也使用hash结构，所有的value都指向同一个内部值



### 哈希Hash

> Redis hash 是一个键值对集合
>
> Redis hash是一个string类型的field和value的映射表，hash特别适合用于存储对象
>
> 类似Java里面的Map<String,Object>

|                         命令                         |                             功能                             |
| :--------------------------------------------------: | :----------------------------------------------------------: |
|             hset \<key>\<field>\<value>              |            给\<key>集合中的\<field>键赋值\<value>            |
|                 hget \<key1>\<field>                 |                    集合\<field>取出 value                    |
| hmset \<key1>\<field1>\<value1>\<field2>\<value2>... |                       批量设置hash的值                       |
|               hexists \<key1>\<field>                |           查看哈希表 key 中，给定域 field 是否存在           |
|                     hkeys \<key>                     |                  列出该hash集合的所有field                   |
|                     hvals \<key>                     |                  列出该hash集合的所有value                   |
|          hincrby \<key>\<field>\<increment>          |         为哈希表 key 中的域 field 的值加上增量 1  -1         |
|            hsetnx \<key>\<field>\<value>             | 将哈希表 key 中的域 field 的值设置为 value ，当且仅当域 field 不存在 |

> Hash类型对应的数据结构是两种：ziplist（压缩列表），hashtable（哈希表）
>
> 当field-value长度较短且个数较少时，使用ziplist，否则使用hashtable



### 有序集合Zset(sorted set)

> Redis有序集合zset与普通集合set非常相似，是一个没有重复元素的字符串集合
>
> 不同之处是有序集合的每个成员都关联了一个评分（score）
>
> 这个评分（score）被用来按照从最低分到最高分的方式排序集合中的成员
>
> 集合的成员是唯一的，但是评分可以是重复的
>
> 因为元素是有序的，所以你也可以很快的根据评分（score）或者次序（position）来获取一个范围的元素
>
> 访问有序集合的中间元素也是非常快的，因此你能够使用有序集合作为一个没有重复成员的智能列表

|                             命令                             |                             功能                             |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
|       zadd \<key>\<score1>\<value1>\<score2>\<value2>…       |  将一个或多个 member 元素及其 score 值加入到有序集 key 当中  |
|          zrange \<key>\<start>\<stop>  [WITHSCORES]          | 返回有序集 key 中，下标在\<start>\<stop>之间的元素。带WITHSCORES，可以让分数一起和值返回到结果集 |
|  zrangebyscore key minmax [withscores] [limit offset count]  | 返回有序集 key 中，所有 score 值介于 min 和 max 之间(包括等于 min 或 max )的成员。有序集成员按 score 值递增(从小到大)次序排列 |
| zrevrangebyscore key maxmin [withscores] [limit offset count] |                    同上，改为从大到小排列                    |
|              zincrby \<key>\<increment>\<value>              |                    为元素的score加上增量                     |
|                     zrem  \<key>\<value>                     |                  删除该集合下，指定值的元素                  |
|                  zcount \<key>\<min>\<max>                   |               统计该集合，分数区间内的元素个数               |
|                     zrank \<key>\<value>                     |               返回该值在集合中的排名，从0开始                |

> SortedSet(zset)是Redis提供的一个非常特别的数据结构
>
> 一方面它等价于Java的数据结构Map<String, Double>，可以给每一个元素value赋予一个权重score
>
> 另一方面它又类似于TreeSet，内部的元素会按照权重score进行排序，可以得到每个元素的名次，还可以通过score的范围来获取元素的列表
>
> zset底层使用了两个数据结构
>
> 1. hash，hash的作用就是关联元素value和权重score，保障元素value的唯一性，可以通过元素value找到相应的score值
> 2. 跳跃表，跳跃表的目的在于给元素value排序，根据score的范围获取元素列表

> 有序集合在生活中比较常见，例如根据成绩对学生排名，根据得分对玩家排名等
>
> 对于有序集合的底层实现，可以用数组、平衡树、链表等
>
> 数组不便元素的插入、删除
>
> 平衡树或红黑树虽然效率高但结构复杂
>
> 链表查询需要遍历所有效率低
>
> Redis采用的是跳跃表
>
> 跳跃表效率堪比红黑树，实现远比红黑树简单

> 对比有序链表和跳跃表，从链表中查询出51

> 有序链表
>
> ![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片5.png)
>
> 要查找值为51的元素，需要从第一个元素开始依次查找、比较才能找到。共需要6次比较

> 跳跃表
>
> ![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片6.png)
>
> 从第2层开始，1节点比51节点小，向后比较。
>
> 21节点比51节点小，继续向后比较，后面就是NULL了，所以从21节点向下到第1层
>
> 在第1层，41节点比51节点小，继续向后，61节点比51节点大，所以从41向下
>
> 在第0层，51节点为要查找的节点，节点被找到，共查找4次



## 配置文件

### Units单位

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片7.jpg)

> 配置大小单位,开头定义了一些基本的度量单位，只支持bytes，不支持bit
>
> 大小写不敏感



### INCLUDES包含

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片8.jpg)

> 类似jsp中的include，多实例的情况可以把公用的配置文件提取出来



### 网络相关配置

#### bind

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片9.jpg)

> 默认情况bind=127.0.0.1只能接受本机的访问请求
>
> 不写的情况下，无限制接受任何ip地址的访问
>
> 生产环境肯定要写你应用服务器的地址；服务器是需要远程访问的，所以需要将其注释掉
>
> 如果开启了protected-mode，那么在没有设定bind ip且没有设密码的情况下，Redis只允许接受本机的响应
>
> 保存配置，停止服务，重启启动查看进程，不再是本机访问了

#### protected-mode

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片10.jpg)

> 将本机访问保护模式设置no

#### Port

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片11.jpg)

> 端口号，默认 6379

#### tcp-backlog

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片12.jpg)

> 设置tcp的backlog，backlog其实是一个连接队列，backlog队列总和=未完成三次握手队列 + 已经完成三次握手队列
>
> 在高并发环境下你需要一个高backlog值来避免慢客户端连接问题
>
> 注意Linux内核会将这个值减小到/proc/sys/net/core/somaxconn的值（128），所以需要确认增大/proc/sys/net/core/somaxconn和/proc/sys/net/ipv4/tcp_max_syn_backlog（128）两个值来达到想要的效果

#### timeout

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片13.jpg)

> 一个空闲的客户端维持多少秒会关闭，0表示关闭该功能。即永不关闭

#### tcp-keepalive

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片14.jpg)

> 对访问客户端的一种心跳检测，每个n秒检测一次
>
> 单位为秒，如果设置为0，则不会进行Keepalive检测，建议设置成60



### GENERAL通用

#### daemonize

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片15.jpg)

> 是否为后台进程，设置为yes
>
> 守护进程，后台启动

#### pidfile

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片16.jpg)

> 存放pid文件的位置，每个实例会产生一个不同的pid文件

#### loglevel 

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片17.jpg)

> 指定日志记录级别，Redis总共支持四个级别：debug、verbose、notice、warning，默认为notice
>
> 四个级别根据使用阶段来选择，生产环境选择notice 或者warning

#### logfile 

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片18.jpg)

> 日志文件名称

#### databases 16 

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片19.jpg)

> 设定库的数量 默认16



### SECURITY安全

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片20.jpg)

> 访问密码的查看、设置和取消
>
> 在命令中设置密码，只是临时的。重启redis服务器，密码就还原了。
>
> 永久设置，需要再配置文件中进行设置



### LIMITS限制

#### maxclients

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片21.jpg)

> 设置redis同时可以与多少个客户端进行连接
>
> 默认情况下为10000个客户端
>
> 如果达到了此限制，redis则会拒绝新的连接请求，并且向这些连接请求方发出“max number of clients reached”以作回应

#### maxmemory

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片22.jpg)

> 建议必须设置，否则，将内存占满，造成服务器宕机
>
> 设置redis可以使用的内存量。一旦到达内存使用上限，redis将会试图移除内部数据，移除规则可以通过maxmemory-policy来指定
>
> 如果redis无法根据移除规则来移除内存中的数据，或者设置了“不允许移除”，那么redis则会针对那些需要申请内存的指令返回错误信息，比如SET、LPUSH等
>
> 但是对于无内存申请的指令，仍然会正常响应，比如GET等。如果你的redis是主redis（说明你的redis有从redis），那么在设置内存使用上限时，需要在系统中留出一些内存空间给同步队列缓存，只有在你设置的是“不移除”的情况下，才不用考虑这个因素

#### maxmemory-policy

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片23.jpg)

> volatile-lru：使用LRU算法移除key，只对设置了过期时间的键；（最近最少使用）
>
> allkeys-lru：在所有集合key中，使用LRU算法移除key
>
> volatile-random：在过期集合中移除随机的key，只对设置了过期时间的键
>
> allkeys-random：在所有集合key中，移除随机的key
>
> volatile-ttl：移除那些TTL值最小的key，即那些最近要过期的key
>
> noeviction：不进行移除。针对写操作，只是返回错误信息

#### maxmemory-samples

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\图片24.jpg)

> 设置样本数量，LRU算法和最小TTL算法都并非是精确的算法，而是估算值，所以你可以设置样本的大小，redis默认会检查这么多个key并选择其中LRU的那个
>
> 一般设置3到7的数字，数值越小样本越不准确，但性能消耗越小



## 发布和订阅

> Redis 发布订阅 (pub/sub) 是一种消息通信模式：发送者 (pub) 发送消息，订阅者 (sub) 接收消息
>
> Redis 客户端可以订阅任意数量的频道

```
subscribe channel1
```

> 使用此命令订阅频道

```
publish channel1 hello
```

> 使用此命令向频道发送消息



## 新数据类型

### Bitmaps

> Redis提供了Bitmaps这个“数据类型”可以实现对位的操作：
>
> Bitmaps本身不是一种数据类型， 实际上它就是字符串（key-value） ， 但是它可以对字符串的位进行操作
>
> Bitmaps单独提供了一套命令， 所以在Redis中使用Bitmaps和使用字符串的方法不太相同。 可以把Bitmaps想象成一个以位为单位的数组， 数组的每个单元只能存储0和1， 数组的下标在Bitmaps中叫做偏移量

|                   命令                   |                             功能                             |
| :--------------------------------------: | :----------------------------------------------------------: |
|      setbit \<key>\<offset>\<value>      |             设置Bitmaps中某个偏移量的值（0或1）              |
|          getbit \<key>\<offset>          |                 获取Bitmaps中某个偏移量的值                  |
|        bitcount \<key>[start end]        |        统计字符串从start字节到end字节比特值为1的数量         |
| bitop  and(or/not/xor) \<destkey> [key…] | bitop是一个复合操作， 它可以做多个Bitmaps的and（交集） 、 or（并集） 、 not（非） 、 xor（异或） 操作并将结果保存在destkey中 |

#### setbit

> 每个用户是否访问过网站，存放在Bitmaps中
>
> 将访问的用户记做1，没有访问的用户记做0，用偏移量作为用户的id

```
setbit user:20210101 1 1
setbit user:20210101 6 1
setbit user:20210101 11 1
setbit user:20210101 15 1
setbit user:20210101 19 1
```

> 很多应用的用户id以一个指定数字（例如10000） 开头， 直接将用户id和Bitmaps的偏移量对应势必会造成一定的浪费， 通常的做法是每次做setbit操作时将用户id减去这个指定数字
>
> 在第一次初始化Bitmaps时， 假如偏移量非常大， 那么整个初始化过程执行会比较慢， 可能会造成Redis的阻塞

#### getbit

> 获取id=8的用户是否在20210101这天访问过， 返回0说明没有访问过

```
getbit user:20210101 1
getbit user:20210101 6
```

#### bitcount

> 计算20210101这天的用户访问量

```
bitcount user:20210101 1 3
```

> user:20210101
>
> 01000001 01000000 00000000 00100001
>
> 每一段代表一个byte

> 上面这行代码就是说从1-3这个bit中看看哪些为1
>
> 一个byte是8个bit
>
> 也就是说这个代码想从前3*8=24 个用户中看看谁登陆过

#### bitop

> 计算出两天都访问过网站的用户**数量**

```
 bitop and user:and:20210101_02 user:20210101 user:20210102
```

#### Bitmaps与set对比

> 假设网站有1亿用户， 每天独立访问的用户有5千万， 如果每天用集合类型和Bitmaps分别存储活跃用户可以得到表

<table>
	<tr>
		<th colspan="4">
			set和Bitmaps存储一天活跃用户对比
		</th>
	</tr>
	<tr>
		<td>
			数据  类型
		</td>
		<td>
			每个用户id占用空间
		</td>
		<td>
			需要存储的用户量
		</td>
		<td>
			全部内存量
		</td>
	</tr>
	<tr>
		<td>
			集合  类型
		</td>
		<td>
			 64位 
		</td>
		<td>
			50000000
		</td>
		<td>
			64位*50000000 = 400MB
		</td>
	</tr>
	<tr>
		<td>
			 Bitmaps
		</td>
		<td>
			 1位 
		</td>
		<td>
			100000000
		</td>
		<td>
			1位*100000000 = 12.5MB
		</td>
	</tr>
</table>

> 假如该网站每天的独立访问用户很少， 例如只有10万，这时候使用Bitmaps就不太合适了，因为基本上大部分位都是0



### HyperLogLog

> 在工作当中，我们经常会遇到与统计相关的功能需求，比如统计网站PV（PageView页面访问量），可以使用Redis的incr、incrby轻松实现

> 但像UV（UniqueVisitor，独立访客）、独立IP数、搜索记录数等需要去重和计数的问题如何解决？这种求集合中不重复元素个数的问题称为基数问题

> 解决基数问题有很多种方案：
> （1）数据存储在MySQL表中，使用distinct count计算不重复个数
> （2）使用Redis提供的hash、set、bitmaps等数据结构来处理
> 以上的方案结果精确，但随着数据不断增加，导致占用空间越来越大，对于非常大的数据集是不切实际的

> 能否能够降低一定的精度来平衡存储空间？Redis推出了HyperLogLog
>
> Redis HyperLogLog 是用来做基数统计的算法，HyperLogLog 的优点是，在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定的、并且是很小的
>
> 在 Redis 里面，每个 HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 2^64 个不同元素的基数。这和计算基数时，元素越多耗费内存就越多的集合形成鲜明对比
>
> 但是，因为 HyperLogLog 只会根据输入元素来计算基数，而不会储存输入元素本身，所以 HyperLogLog 不能像集合那样，返回输入的各个元素

> 什么是基数?
>
> 比如数据集 {1, 3, 5, 7, 5, 7, 8}， 那么这个数据集的基数集为 {1, 3, 5 ,7, 8}, 基数(不重复元素)为5。 基数估计就是在误差可接受的范围内，快速计算基数

|                      命令                      |                     功能                     |
| :--------------------------------------------: | :------------------------------------------: |
|      pfadd \<key>< element> [element ...]      |        添加指定元素到 HyperLogLog 中         |
|            pfcount \<key> [key ...]            |                 计算基数个数                 |
| pfmerge \<destkey>\<sourcekey> [sourcekey ...] | 将一个或多个HLL合并后的结果存储在另一个HLL中 |



### Geospatial

> Redis 3.2 中增加了对GEO类型的支持
>
> GEO，Geographic，地理信息的缩写
>
> 该类型，就是元素的2维坐标，在地图上就是经纬度
>
> redis基于该类型，提供了经纬度设置，查询，范围查询，距离查询，经纬度Hash等常见操作

|                             命令                             |                    功能                    |
| :----------------------------------------------------------: | :----------------------------------------: |
| geoadd \<key>< longitude>\<latitude>\<member> [longitude latitude member...] |      添加地理位置（经度，纬度，名称）      |
|              geopos \<key>\<member> [member...]              |            获得指定地区的坐标值            |
|       geodist \<key>\<member1>\<member2> [m\km\ft\mi]        |         获取两个位置之间的直线距离         |
|  georadius \<key>< longitude>\<latitude>radius [m\km\ft\mi]  | 以给定的经纬度为中心，找出某一半径内的元素 |

```
geoadd china:city 121.47 31.23 shanghai
geoadd china:city 106.50 29.53 chongqing 114.05 22.52 shenzhen 116.38 39.90 beijing

geodist china:city beijing shanghai km    //"1068.1535"

georadius china:city 110 30 1000 km    //"chongqing""shenzhen"
```



## Jedis

### 依赖

```xml
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
    <version>3.6.3</version>
</dependency>
```

### 准备工作

> 将redis bind注释掉，protected-mode设置为no，不然只能本机访问
>
> systemctl stop firewalld.service关闭防火墙

### 连接

```java
Jedis jedis = new Jedis("192.168.80.128",6379);
String ping = jedis.ping();
System.out.println(ping);
```

```java
Set<String> keys = jedis.keys("*");
for (String key : keys) {
    System.out.println(key);
}

jedis.set("name","lucy");
String name = jedis.get("name");
System.out.println(name);
```

### 案例

> 要求：
>
> 输入手机号，点击发送后随机生成6位数字码，2分钟有效
>
> 输入验证码，点击验证，返回成功或失败
>
> 每个手机号每天只能输入3次

```java
public String getCode(){
    Random r = new Random();
    String code = "";
    for (int i = 0; i < 6; i++) {
        int random = r.nextInt(10);
        code += random;
    }
    return code;
}
```

```java
public void getCountAndCode(String phone){
    Jedis jedis = new Jedis("192.168.80.128",6379);

    //计数功能
    String countKey = phone + ":count";
    String count = jedis.get(countKey);
    if (count == null){
        //没有记录，初始化为1次
        jedis.setex(countKey,24*60*60,"1");
    } else if (Integer.parseInt(count) <= 2){
        //小于等于2次，次数+1
        jedis.incr(countKey);
    } else if (Integer.parseInt(count) > 2){
        //大于2次
        System.out.println("滚！");
    }

    //保存验证码
    String codeKey = phone + ":code";
    jedis.setex(codeKey,120,getCode());

    jedis.close();
}
```

```java
public void verifyCode(String phone,String code){
    Jedis jedis = new Jedis("192.168.80.128",6379);

    String codeKey = phone + ":code";
    String codeFromRedis = jedis.get(codeKey);
    if (codeFromRedis.equals(code)){
        System.out.println("成功");
    } else {
        System.out.println("失败");
    }

    jedis.close();
}
```



## SpringBoot整合

### 配置文件

```yaml
spring:
  redis:
    host: 192.168.80.128
```

```java
@EnableCaching
@Configuration
public class RedisConfig {
    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory factory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        RedisSerializer<String> redisSerializer = new StringRedisSerializer();
        Jackson2JsonRedisSerializer jackson2JsonRedisSerializer = new Jackson2JsonRedisSerializer(Object.class);
        ObjectMapper om = new ObjectMapper();
        om.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        om.enableDefaultTyping(ObjectMapper.DefaultTyping.NON_FINAL);
        jackson2JsonRedisSerializer.setObjectMapper(om);
        template.setConnectionFactory(factory);
        //key序列化方式
        template.setKeySerializer(redisSerializer);
        //value序列化
        template.setValueSerializer(jackson2JsonRedisSerializer);
        //value hashmap序列化
        template.setHashValueSerializer(jackson2JsonRedisSerializer);
        return template;
    }

    @Bean
    public CacheManager cacheManager(RedisConnectionFactory factory) {
        RedisSerializer<String> redisSerializer = new StringRedisSerializer();
        Jackson2JsonRedisSerializer jackson2JsonRedisSerializer = new Jackson2JsonRedisSerializer(Object.class);
        //解决查询缓存转换异常的问题
        ObjectMapper om = new ObjectMapper();
        om.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        om.enableDefaultTyping(ObjectMapper.DefaultTyping.NON_FINAL);
        jackson2JsonRedisSerializer.setObjectMapper(om);
        // 配置序列化（解决乱码的问题）,过期时间600秒
        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofSeconds(600))
                .serializeKeysWith(RedisSerializationContext.SerializationPair.fromSerializer(redisSerializer))
                .serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(jackson2JsonRedisSerializer))
                .disableCachingNullValues();
        RedisCacheManager cacheManager = RedisCacheManager.builder(factory)
                .cacheDefaults(config)
                .build();
        return cacheManager;
    }

}
```

### 测试

```java
@ResponseBody
@RestController
public class RedisTestController {

    @Autowired
    private RedisTemplate redisTemplate;

    @RequestMapping("/redis")
    public Object testRedis(){
        redisTemplate.opsForValue().set("name","lucy");
        Object name = redisTemplate.opsForValue().get("name");
        return name;
    }
}
```



## 事务和锁

> Redis事务是一个单独的隔离操作：事务中的所有命令都会序列化、按顺序地执行
>
> 事务在执行的过程中，不会被其他客户端发送来的命令请求所打断
>
> Redis事务的主要作用就是串联多个命令防止别的命令插队



### Multi、Exec、discard

> 从输入Multi命令开始，输入的命令都会依次进入命令队列中，但不会执行
>
> 直到输入Exec后，Redis会将之前的命令队列中的命令依次执行
>
> 组队的过程中可以通过discard来放弃组队



### 错误处理

> 组队中某个命令出现了报告错误，执行时整个的所有队列都会被取消
>
> 如果执行阶段某个命令报出了错误，则只有报错的命令不会被执行，而其他的命令都会执行，不会回滚

```
127.0.0.1:6379> multi
OK
127.0.0.1:6379(TX)> set b1 v1
QUEUED
127.0.0.1:6379(TX)> set b2 v2
QUEUED
127.0.0.1:6379(TX)> set b3
(error) ERR wrong number of arguments for 'set' command
127.0.0.1:6379(TX)> exec
(error) EXECABORT Transaction discarded because of previous errors.

组队时出错，全部不会执行
```

```
127.0.0.1:6379> multi
OK
127.0.0.1:6379(TX)> set c1 v1
QUEUED
127.0.0.1:6379(TX)> incr c1
QUEUED
127.0.0.1:6379(TX)> set c2 v2
QUEUED
127.0.0.1:6379(TX)> exec
1) OK
2) (error) ERR value is not an integer or out of range
3) OK
127.0.0.1:6379>

组队成功，执行时出错。哪个出错哪个爆炸，不影响其他
```



### 悲观锁

> 悲观锁(Pessimistic Lock)
>
> 每次去拿数据的时候都认为别人会修改，所以每次在拿数据的时候都会上锁
>
> 这样别人想拿这个数据就会block直到它拿到锁
>
> 传统的关系型数据库里边就用到了很多这种锁机制，比如行锁，表锁等，读锁，写锁等，都是在做操作之前先上锁



### 乐观锁

> 乐观锁(Optimistic Lock)
>
> 每次去拿数据的时候都认为别人不会修改，所以不会上锁
>
> 但是在更新的时候会判断一下在此期间别人有没有去更新这个数据，可以使用版本号等机制
>
> 乐观锁适用于多读的应用类型，这样可以提高吞吐量。Redis就是利用这种check-and-set机制实现事务的

> 在执行multi之前，先执行watch key1 [key2]
>
> 可以监视一个(或多个) key ，如果在事务执行之前这个(或这些) key 被其他命令所改动，那么事务将被打断

> unwatch
>
> 取消 WATCH 命令对所有 key 的监视
>
> 如果在执行 WATCH 命令之后，EXEC 命令或DISCARD 命令先被执行了的话，那么就不需要再执行UNWATCH 了



### 特性

> **单独的隔离操作** 
>
> 事务中的所有命令都会序列化、按顺序地执行
>
> 事务在执行的过程中，不会被其他客户端发送来的命令请求所打断

> **没有隔离级别的概念** 
>
> 队列中的命令没有提交之前都不会实际被执行，因为事务提交前任何指令都不会被实际执行

> **不保证原子性** 
>
> 事务中如果有一条命令执行失败，其后的命令仍然会被执行，没有回滚 



### ~~秒杀案例~~（存疑）

```java
@Autowired
RedisTemplate redisTemplate;

public boolean doSecKill(String userId,String productId){
    //用户id和商品id非空判断
    if (userId == null || productId == null){
        return false;
    }

    //初始化redis中的数据
    String inventoryKey = "inventory:" + productId;
    String successUserKey = "inventory:" + productId + ":successUser";

    //如果库存为null，则表示没有开始
    Object o = redisTemplate.opsForValue().get(inventoryKey);
    if (o == null){
        System.out.println("秒杀没有开始！");
        return false;
    }


    //判断用户是否重复秒杀
    Boolean alreadySuccess = redisTemplate.opsForSet().isMember(successUserKey, userId);
    if (alreadySuccess){
        System.out.println("已经秒杀成功，不能重复秒杀！");
        return false;
    }

    //库存小于1，秒杀结束
    int remain = Integer.parseInt((String) redisTemplate.opsForValue().get(inventoryKey));
    if (remain < 1){
        System.out.println("秒杀结束！");
        return false;
    }

    //库存-1，列表+1
    redisTemplate.opsForValue().decrement(inventoryKey,1L);
    redisTemplate.opsForSet().add(successUserKey,userId);
    return true;
}
```

> 在多并发情况下会出现超卖和超时的问题
>
> 我们这里使用的是Spring封装的redisTemplate，默认就是从连接池中获取连接，基本不会产生超时问题
>
> 下面就是解决超卖问题
>
> 使用乐观锁

```java
Object execute = redisTemplate.execute(new SessionCallback() {
    @Override
    public Object execute(RedisOperations redisOperations) throws DataAccessException {
        redisOperations.watch(inventoryKey);
        //库存小于1，秒杀结束
        int remain = Integer.parseInt((String) redisTemplate.opsForValue().get(inventoryKey));
        if (remain < 1) {
            System.out.println("秒杀结束！");
            return 0;
        }
        //库存-1，列表+1
        redisOperations.multi();
        redisOperations.opsForValue().decrement(inventoryKey,1L);
        redisOperations.opsForSet().add(successUserKey,userId);
        redisOperations.exec();
        return 1;
    }
});
int flag = (int) execute;
if (flag == 0){
    return false;
}
return true;
```

> **存疑，我也不知道这么写对不对**
>
> 还是用ZooKeeper上分布式锁吧

```lua
local userid=KEYS[1]; 
local prodid=KEYS[2];
local qtkey="sk:"..prodid..":qt";
local usersKey="sk:"..prodid.":usr'; 
local userExists=redis.call("sismember",usersKey,userid);
if tonumber(userExists)==1 then 
  return 2;
end
local num= redis.call("get" ,qtkey);
if tonumber(num)<=0 then 
  return 0; 
else 
  redis.call("decr",qtkey);
  redis.call("sadd",usersKey,userid);
end
return 1;
```

> 使用Lua脚本解决所有问题



## 持久化

> Redis 提供了2个不同形式的持久化方式
>
> RDB（Redis DataBase）
>
> AOF（Append Of File）



### RDB

> 在指定的时间间隔内将内存中的数据集快照写入磁盘， 也就是行话讲的Snapshot快照，它恢复时是将快照文件直接读到内存里

#### 配置

> 在redis.conf中配置文件名称，默认为dump.rdb
>
> rdb文件的保存路径，也可以修改。默认为Redis启动时命令行所在的目录下
>
> dir "/myredis/"

> 配置文件中默认的快照配置
>
> 1小时内如果有改变，则保存
>
> 5分钟内有100条记录改变，则保存
>
> 1分钟内10000条记录改变，则保存
>
> ```
> save 3600 1
> save 300 100
> save 60 10000
> ```

> save ：save时只管保存，其它不管，全部阻塞。手动保存。不建议
>
> bgsave：Redis会在后台异步进行快照操作， 快照同时还可以响应客户端请求
>
> 可以通过lastsave 命令获取最后一次成功执行快照的时间

> 有一个配置stop-writes-on-bgsave-error
>
> 表示当Redis无法写入磁盘的话，直接关掉Redis的写操作。推荐yes

#### 工作原理

> Redis会单独创建（fork）一个子进程来进行持久化，会先将数据写入到 一个临时文件中，待持久化过程都结束了，再用这个临时文件替换上次持久化好的文件。 整个过程中，主进程是不进行任何IO操作的，这就确保了极高的性能 如果需要进行大规模数据的恢复，且对于数据恢复的完整性不是非常敏感，那RDB方式要比AOF方式更加的高效。**RDB的缺点是最后一次持久化后的数据可能丢失**

#### 备份恢复

> rdb的备份
>
> 先通过config get dir  查询rdb文件的目录 
>
> 将*.rdb的文件拷贝到别的地方

> rdb的恢复
>
> 关闭Redis
>
> 先把备份的文件拷贝到工作目录下
>
> 启动Redis, 备份数据会直接加载



### AOF

> 以日志的形式来记录每个写操作（增量保存），将Redis执行过的所有写指令记录下来(读操作不记录)， 只许追加文件但不可以改写文件，redis启动之初会读取该文件重新构建数据，换言之，redis 重启的话就根据日志文件的内容将写指令从前到后执行一次以完成数据的恢复工作

#### 配置

> AOF默认不开启  appendonly no
>
> 可以在redis.conf中配置文件名称，默认为 appendonly.aof
>
> AOF文件的保存路径，同RDB的路径一致

> AOF和RDB同时开启，系统默认取AOF的数据

> appendfsync always
>
> 始终同步，每次Redis的写入都会立刻记入日志；性能较差但数据完整性比较好
>
> appendfsync everysec
>
> 每秒同步，每秒记入日志一次，如果宕机，本秒的数据可能丢失
>
> appendfsync no
>
> redis不主动进行同步，把同步时机交给操作系统

#### 工作原理

> 客户端的请求写命令会被append追加到AOF缓冲区内
>
> AOF缓冲区根据AOF持久化策略[always,everysec,no]将操作sync同步到磁盘的AOF文件中
>
> AOF文件大小超过重写策略或手动重写时，会对AOF文件rewrite重写，压缩AOF文件容量
>
> Redis服务重启时，会重新load加载AOF文件中的写操作达到数据恢复的目的

#### 备份恢复

> AOF的备份机制和性能虽然和RDB不同, 但是备份和恢复的操作同RDB一样，都是拷贝备份文件，需要恢复时再拷贝到Redis工作目录下，启动系统即加载
>
> 正常恢复
>
> 修改默认的appendonly no，改为yes
>
> 将有数据的aof文件复制一份保存到对应目录(查看目录：config get dir)
>
> 恢复：重启redis然后重新加载
>
> 如遇到AOF文件损坏，通过/usr/local/bin/redis-check-aof--fix appendonly.aof进行恢复



### 总结

> 官方推荐两个都开启
>
> 如果数据没那么重要，单用RDB
>
> 不要单独用AOF，可能会出现BUG
>
> 如果单纯做缓存，可以都不用



## 主从复制

> 主机数据更新后根据配置和策略， 自动同步到备机的master/slaver机制，Master以写为主，Slave以读为主

> 优点
>
> 读写分离，性能扩展
>
> 容灾快速恢复

### 使用

#### 一台电脑启动多个redis实例配置

> 给不同的系统分别写好配置文件
>
> 比如用一台机器演示，就使其端口号不同
>
> redis6379.coonf
>
> redis6380.coonf
>
> redis6381.coonf

> 将之前的配置文件与这些新的都放在一个目录，方便我们引入
>
> 在每个配置文件中都include我们之前的配置文件
>
> include /文件夹/之前的配置文件（redis.conf）

> 之前的配置中
>
> appendonly no

> 在新的配置文件中写入自己独特的配置
>
> include /myredis/redis.conf
>
> pidfile /var/run/redis_6379.pid
>
> port 6379
>
> dbfilename dump6379.rdb
>
> 以此类推，有多少主机写多少份配置文件

> 分别启动这三个实例

#### 开启主从

>从机执行命令slaveof 127.0.0.1 6379
>
>如果从机重启，需要重新执行
>
>或者直接添加进配置文件

> **再来回顾一下配置中的重点**
>
> bind 127.0.0.1  注释掉
>
> daemonize yes  开启守护进程后台启动
>
> requirepass 123456  开启密码
>
> maxclients 10000  设置最大链接数
>
> maxmemory bytes  设置最大内存
>
> maxmemory-policy volatile-lru 或 allkeys-lru或者根据自己需求设置
>
> **从服务器额外配置项**
>
> slaveof ip port  开启从服务器
>
> masterauth password  主服务器redis密码
>
> slave-read-only yes  默认值也是yes，一般来说从服务器是只读的



### 复制原理

> 当从服务器连接上主服务器之后，从服务器会发送要求数据同步
>
> 主服务器接收到消息，将数据进行持久化，并将rdb文件发送给从服务器
>
> 从服务器拿到rdb文件开始读取数据
>
> 从此
>
> 主服务器每次进行写操作之后，会和从服务器进行数据同步，进行增量更新



### 层层传递

> 1台主服务器向几台从服务器同步增量更新没有问题，但是当从服务器有几百上千个
>
> 主服务器就应付不来
>
> 所以我们需要层级传递
>
> 将军将命令传达给师长们，师长们传达给自己的团长们，一层层的传递。来解决这个问题

> 这样做的缺点是，中间某个节点挂了
>
> 李云龙死了，独立团下面的张大彪，孙德胜就收不到消息了
>
> 他们收不到消息，一营和骑兵连的将士们，就收不到任何信息了

> 设置起来也很简单
>
> 主机还是主机
>
> 第一层的salveof 主机
>
> 第二层的salveof 第一层的主机
>
> 以此类推



### 提升从机为主机

> 如果主机挂掉
>
> 可以在从机中运行命令
>
> slaveof no one

> 它就迎来了解放，翻身农奴做地主

> 它的奴隶还是它的奴隶
>
> 它的主人已经没有了

> 这个命令没法自动完成，必须手动运行
>
> 不过有替代方案，哨兵模式



### 哨兵模式

> 这种模式可以监控主机是否故障，如果故障发生
>
> 将会根据投票数自动升级为主库

> 自定义一个配置文件，叫**sentinel.conf 必须是这个名字**
>
> 在这个文件中写一行命令
>
> **sentinel monitor mymaster 127.0.0.1 6379 1**
>
> mymaster是一个别称，可以随便写
>
> 1为投票数量，至少有多少个哨兵赞成切换

> **redis-sentinel sentinel.cof所在位置**
>
> 即可启动哨兵

> 当主服务器挂掉，哨兵按优先级选取一台从机，将它变为主机
>
> 将其他从机切换为新主机的从机
>
> 并将已经挂掉的主机也切换为新主机的从机

> 优先级选取条件为
>
> 1. 选择优先级靠前的
>
> 2. 选择偏移量最大的
>
> 3. 选择runid最小的
>
> 在配置文件中有slave-priority 100
>
> 来设置优先级，值越小优先级越高，默认是100



## 集群

### 存在的问题

> 容量不够，redis如何进行扩容？
>
> 并发写操作， redis如何分摊？
>
> 另外，主从模式，薪火相传模式，主机宕机，导致ip地址发生变化，应用程序中配置需要修改对应的主机地址、端口等信息
>
> 之前通过代理主机来解决，但是redis3.0中提供了解决方案。就是无中心化集群配置



### 什么是集群

> Redis 集群实现了对Redis的水平扩容，即启动N个redis节点，将整个数据库分布存储在这N个节点中，每个节点存储总数据的1/N
>
> Redis 集群通过分区（partition）来提供一定程度的可用性（availability）： 即使集群中有一部分节点失效或者无法进行通讯， 集群也可以继续处理命令请求



### 配置

> cluster-enabled yes  开启集群
>
> cluster-config-file nodes-6379.conf  设定节点配置文件
>
> cluster-node-timeout 15000  设定节点失联时间，单位毫秒，超过该时间自动进行主从切换



### 集群合成

> 确保所有实例都启动
>
> 节点配置文件生成正常

> 进入redis安装包中src文件夹
>
> 因为这个文件夹中有我们需要用的依赖

```
redis-cli --cluster create --cluster-replicas 1 你的ip:端口号 你的ip2:端口号2  ....
```

> -replicas 1，表示用最简单的方式创建集群，也就是1主1从
>
> 注意，这里就算是本机也要写真实ip，不能写127.0.0.1
>
> 运行完成之后会有一个值  16384 slots covered（之后会提到）



### 集群连接

> 在之前普通连接加入-c表示使用集群策略连接，会自动切换主机
>
> redis-cli -c -p 6379

> 使用cluster nodes
>
> 查看集群信息



### slots

> 在集群绑定完成时候会有一个提示
>
> 16384 slots covered
>
> 表示集群总共含有多少个槽位，数据库中每个键都属于这些槽位中的一个
>
> 集群中每个节点负责处理一部分数据（类似RAID 0）



### 批量添加

> 因为要计算key的哈希值来决定向哪个服务区存放
>
> 所以批量添加的操作将会失败

> 解决办法是给key加组
>
> mset name{user} lucy age{user} 20 gender{user} 0
>
> 表示使用user来计算哈希值，来分组



### 插槽操作

> cluster keyslot key  查看key对应的插槽
>
> cluster countkeysinslot 4847 查看插槽中有几个值
>
> cluster getkeyinslot 4847 n  返回指定插槽中n个key



### 故障配置

> 配置文件中有一个配置 cluster-require-full-coverage
>
> 如果某一段插槽的主从都挂掉，而cluster-require-full-coverage 为yes ，那么 ，整个集群都挂掉
>
> 如果某一段插槽的主从都挂掉，而cluster-require-full-coverage 为no ，那么，整个集群不会挂掉，但该插槽范围数据全都不能使用，也无法存储



### Spring配置

```properties
spring.redis.cluster.nodes=192.168.174.221:6381, 192.168.174.221:6382, 192.168.174.221:6383, 192.168.174.221:6384, 192.168.174.221:6385, 192.168.174.221:6386
# 新版
spring.redis.jedis.pool.max-wait=-1
spring.redis.jedis.pool.max-active=300
spring.redis.jedis.pool.max-idle=100
spring.redis.jedis.pool.min-idle=20
## 连接超时时间（毫秒） 
spring.redis.timeout=60000
## Redis数据库索引(默认为0) 
spring.redis.database=0
```

> 将host和prot改为spring.redis.cluster.nodes=



## 问题解决

### 缓存穿透

> 每次都访问一个必不存在的数据，会导致缓存失效，直接去数据库中寻找
>
> 黑客不停地访问一个不可能存在的数据，因为必然不存在，缓存中必然没有
>
> 所以会不停地访问数据库，最终导致服务器瘫痪

> 常见解决方案：
>
> 1. 对空值缓存：
>
>    如果一个查询返回的数据为空（不管是数据是否不存在），我们仍然把这个空结果（null）进行缓存，设置空结果的过期时间会很短，最长不超过五分钟
>
> 2. 设置可访问的名单（白名单）：
>
>    使用bitmaps类型定义一个可以访问的名单，名单id作为bitmaps的偏移量，每次访问和bitmap里面的id进行比较，如果访问id不在bitmaps里面，进行拦截，不允许访问
>
> 3. 采用布隆过滤器：(布隆过滤器（Bloom Filter）
>
>    是1970年由布隆提出的。它实际上是一个很长的二进制向量(位图)和一系列随机映射函数（哈希函数）布隆过滤器可以用于检索一个元素是否在一个集合中。它的优点是空间效率和查询时间都远远超过一般的算法，缺点是有一定的误识别率和删除困难）将所有可能存在的数据哈希到一个足够大的bitmaps中，一个一定不存在的数据会被 这个bitmaps拦截掉，从而避免了对底层存储系统的查询压力
>
> 4. 进行实时监控：
>
>    当发现Redis的命中率开始急速降低，需要排查访问对象和访问的数据，和运维人员配合，可以设置黑名单限制服务



### 缓存击穿

> key对应的数据存在，但在redis中过期
>
> 此时若有大量并发请求过来，这些请求发现缓存过期一般都会从后端DB加载数据并回设到缓存，这个时候大并发的请求可能会瞬间把后端DB压垮

> 常见解决方案：
>
> 1. 预先设置热门数据：在redis高峰访问之前，把一些热门数据提前存入到redis里面，加大这些热门数据key的时长
> 2. 实时调整：现场监控哪些数据热门，实时调整key的过期时长
> 3. 使用锁：
>    1. 就是在缓存失效的时候（判断拿出来的值为空），不是立即去load db
>    2. 先使用缓存工具的某些带成功操作返回值的操作（比如Redis的SETNX）去set一个mutex key
>    3. 当操作返回成功时，再进行load db的操作，并回设缓存,最后删除mutex key
>    4. 当操作返回失败，证明有线程在load db，当前线程睡眠一段时间再重试整个get缓存的方法



### 缓存雪崩

> key对应的数据存在，但在redis中过期
>
> 此时若有大量并发请求过来，这些请求发现缓存过期一般都会从后端DB加载数据并回设到缓存，这个时候大并发的请求可能会瞬间把后端DB压垮
>
> 缓存雪崩与缓存击穿的区别在于这里针对很多key缓存，前者则是某一个key

> 常见解决方案：
>
> 1. 构建多级缓存架构：nginx缓存 + redis缓存 +其他缓存（ehcache等）
>
> 2. 使用锁或队列：
>
>    用加锁或者队列的方式保证来保证不会有大量的线程对数据库一次性进行读写，从而避免失效时大量的并发请求落到底层存储系统上。不适用高并发情况
>
> 3. 设置过期标志更新缓存：
>
>    记录缓存数据是否过期（设置提前量），如果过期会触发通知另外的线程在后台去更新实际key的缓存
>
> 4. 将缓存失效时间分散开：
>
>    比如我们可以在原有的失效时间基础上增加一个随机值，比如1-5分钟随机，这样每一个缓存的过期时间的重复率就会降低，就很难引发集体失效的事件。



## 分布式锁

> 随着业务发展的需要，原单体单机部署的系统被演化成分布式集群系统后，由于分布式系统多线程、多进程并且分布在不同机器上，这将使原单机部署情况下的并发控制锁策略失效，单纯的Java API并不能提供分布式锁的能力
>
> 为了解决这个问题就需要一种跨JVM的互斥机制来控制共享资源的访问，这就是分布式锁要解决的问题！

> 分布式锁主流的实现方案：
>
> * 基于数据库实现分布式锁
>
> * 基于缓存（Redis等）
>
> * 基于Zookeeper

> 每一种分布式锁解决方案都有各自的优缺点：
>
> 性能：redis最高
>
> 可靠性：zookeeper最高



### Redis实现分布式锁

```
set key value NX EX 10000
```

> EX second ：设置键的过期时间为 second 秒
>
> SET key value EX second 效果等同于 SETEX key second value 

> PX millisecond ：设置键的过期时间为 millisecond 毫秒
>
> SET key value PX millisecond 效果等同于 PSETEX key millisecond value 

> NX ：只在键不存在时，才对键进行设置操作
>
> SET key value NX 效果等同于 SETNX key value 

```java
public void testLock(){
    //1获取锁，setne
    Boolean lock = redisTemplate.opsForValue().setIfAbsent("lock", "111");
    //2获取锁成功、查询num的值
    if(lock){
        Object value = redisTemplate.opsForValue().get("num");
        //2.1判断num为空return
        if(StringUtils.isEmpty(value)){
            return;
        }
        //2.2有值就转成成int
        int num = Integer.parseInt(value+"");
        //2.3把redis的num加1
        redisTemplate.opsForValue().set("num", ++num);
        //2.4释放锁，del
        redisTemplate.delete("lock");

    }else{
        //3获取锁失败、每隔0.1秒再获取
        try {
            Thread.sleep(100);
            testLock();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

> 说白了
>
> 就是利用setnx如果不存在再设定值
>
> 设置一个值，如果不删掉，就永远设定不了新的值
>
> 以此来当做一把锁



## Redis 6.0 新特性

### ACL

> Redis ACL是Access Control List（访问控制列表）的缩写，该功能允许根据可以执行的命令和可以访问的键来限制某些连接

> 在Redis 5版本之前，Redis 安全规则只有密码控制 还有通过rename 来调整高危命令比如 flushdb ， KEYS* ， shutdown 等

> Redis 6 则提供ACL的功能对用户进行更细粒度的权限控制 
>
> 1. 接入权限:用户名和密码 
> 2. 可以执行的命令 
> 3. 可以操作的 KEY

#### 命令

> acl list
>
> 查看用户权限列表

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\acl01.png)

> acl cat
>
> 查看添加权限指令类别

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\acl2.png)

> acl cat string
>
> 加参数类型名可以查看类型下具体命令

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\Redis\acl3.png)

> acl whoami
>
> 查看当前用户

> acl setuser
>
> 创建和编辑用户权限
>
> acl setuser user1 创建用户user1
>
> acl setuser user2 on >password ~cached:* +get  
>
> 创建用户user2 并赋予权限，只能操作带有cached:的key，只能使用get命令



### 多线程

> Redis6终于支撑多线程了，告别单线程了吗？
>
> IO多线程其实指客户端交互部分的网络IO交互处理模块多线程，而非执行命令多线程
>
> Redis6执行命令依然是单线程

> Redis 6 加入多线程,但跟 Memcached 这种从 IO处理到数据访问多线程的实现模式有些差异
>
> Redis 的多线程部分只是用来处理网络数据的读写和协议解析，执行命令仍然是单线程
>
> 之所以这么设计是不想因为多线程而变得复杂，需要去控制 key、lua、事务，LPUSH/LPOP 等等的并发问题

> 另外，多线程IO默认也是不开启的，需要在配置文件中配置
>
> io-threads-do-reads  yes 
>
> io-threads 4

