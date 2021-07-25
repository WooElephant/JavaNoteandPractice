# MySQL高级

## 7种join

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\MySql\高级\笔记\20171230161932523.png)



## 索引

> 索引是帮助MySQL高效获取数据的数据结构
>
> 如果没有特别说明，都是指B+树（多路搜索树，不一定是二叉树）



### 优劣势

> 优势
>
> 提高数据检索效率，降低IO成本，降低排序成本，降低CPU消耗

> 劣势
>
> 索引要占用空间
>
> 降低更新速度，不但要更新数据，还要更新索引



### 分类

> 单值索引：一个索引只包含单个列，一个表可以有多个单列索引
>
> 唯一索引：索引列的值必须唯一
>
> 复合索引：一个索引包含多个列



### 基本语法

> 创建
>
> ```mysql
> create [unique] index indexName on tableName(columName(length))
> alter tableName add [unique] index [indexName] on (columName(length))
> ```

> 删除
>
> ```mysql
> drop index [indexName] on tableName
> ```

> 查看
>
> ```mysql
> show index from tableName
> ```



### 结构

> BTree	Hash	full-text	R-Tree
>
> 因为我们是主攻Java，了解BTree即可

> BTree原理

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\MySql\高级\笔记\捕获.PNG)

> 浅蓝色的块称为磁盘块，每个磁盘块包含几个数据项和指针
>
> 真实的数据存在叶子节点
>
> 非叶子节点只存储指向搜索方向的数据项

> 如果要查找数据项29，首先会将1加载到内存，确定29在17和35之间，锁定p2指针
>
> 通过p2指针将磁盘块3加载到内存，29在26和30之间，确定p2指针
>
> 通过指针找到磁盘块8，查找到29

> 3层B+树可以表示上百万的数据，如果没有索引最多需要百万次IO
>
> 有了索引，上百万的数据查找只需要3次IO，性能提升是非常巨大的



### 哪些情况适合索引

> 1. 主键自动建立唯一索引
> 2. 频繁作为查询条件的字段，应该创建索引
> 3. 查询中与其他表关联字段，外键关系建立索引
> 4. 单键与组合索引，高并发下倾向创建组合索引
> 5. 查询中排序的字段，如果使用索引会大大提高排序速度
> 6. 查询中统计或分组字段



### 哪些情况不适合索引

> 1. 表记录太少
> 2. 经常增删改的表
> 3. 如果某列包含许多重复内容，为它创建索引没有太大的效果



## 性能分析

> MySQL中有专门负责优化select语句的模块，通过分析，为Query提供它认为最优的执行计划（不见得是真正最优的方案）

> MySQL的常见瓶颈：
>
> CPU饱和、IO瓶颈、服务器硬件性能瓶颈



### Explain

> 使用explain关键字可以模拟优化器执行SQL查询语句
>
> 从而知道MySQL是如何处理你的SQL语句的
>
> 分析你的查询语句或是表结构的性能瓶颈

```mysql
explain select * from tb_stu;
```

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\MySql\高级\笔记\2-1.PNG)

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\MySql\高级\笔记\2-2.PNG)

> 这是这条语句执行的结果，因为太长看不清，所以分成了两张图片
>
> 它能告诉我们
>
> 表的读取顺序
>
> 数据读取的操作类型
>
> 哪些索引可以引用
>
> 哪些索引被实际引用
>
> 表之间的引用
>
> 每张表有多少行被优化器查询



#### ID

> 表示select查询的序列号，包含一组数字，表示查询中select子句执行顺序
>
> 有三种情况



---



> id相同，执行顺序从上至下

```mysql
explain select t2.*
from t1,t2,t3
where t1.id = t2.id and t1.id = t3.id and t1.other_colum = '';
```

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\MySql\高级\笔记\id相同.PNG)

---



![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\MySql\高级\笔记\id不同.PNG)

> 如果是子查询，id的序号会递增，id越大优先级越高



---



![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\MySql\高级\笔记\相同又不同.PNG)

> id如果相同，可以认为是一组从上往下顺序执行



#### select_type

> 常见的值有六种
>
> 主要用于区别普通查询、联合查询、子查询等复杂查询
>
> simple：简单的select查询，查询中不包含子查询或者union
>
> primary：查询中若包含任何复杂的子部分，最外层的查询为primary
>
> subquery：在select或where列表中包含了子查询
>
> derived：在from中包含了子查询
>
> union：若第二个select出现在union之后，则被标记为union
>
> union result：从union表中获取结果的select（union合并的结果集）



#### table

> 显示这一行的数据是关于哪张表的



#### type

> 常见的有八种值
>
> all：全表扫描
>
> index：全索引扫描
>
> range：只检索给定范围的行，使用一个索引来选择行
>
> ref：非唯一性索引扫描，返回匹配某个单独值的所有行
>
> eq_ref：唯一性索引扫描，对于每个索引键，表中只有一条记录，常见于主键或唯一键索引扫描
>
> const：表示通过索引一次就找到了，用于比较主键或唯一键，因为只匹配一行记录，所以很快
>
> system：表只有一行记录，平时不会出现
>
> null

> 从最好到最差依次是
>
> system > const > eq_ref > ref > range > index > all



#### possible_keys和keys

> possible_keys：显示可能应用在这张表中的索引，查询涉及到的字段上若存在索引，则该索引将被列出，但不一定被使用

> keys：实际使用的索引
>
> 查询中若使用了覆盖索引，则该索引仅出现在keys列表中



#### key_len

> 表示索引中使用的字节数，可通过该列计算查询中使用的索引长度
>
> key_len显示的值为索引字段的最大可能长度，并非实际使用长度



#### ref

> 显示索引的哪一列被使用了



#### rows

> 根据表统计信息及索引选用情况，大致估算出找到指定记录需要读取的行数



#### extra

> 不适合在其他列中显示，但十分重要的额外信息

> **using filesort**
>
> 说明MySQL会对数据使用一个外部的索引排序，而不是按照表内的索引顺序进行读取
>
> MySQL中无法利用索引完成的排序

> **using temporary**
>
> 使用了临时表保存中间结果，MySQL在对查询结果排序时使用了临时表

> **using index**
>
> 对应的select操作中使用了索引覆盖，避免访问了表的数据行
>
> 就是select的数据列只从索引中就能获得，不必读取数据行

> using where：使用了where过滤
>
> using join buffer：使用了连接缓存
>
> impossible where：where子句的值总是false



## 索引优化案例

### 单表案例

```mysql
explain select id,author_id
from article
where category_id = 1 and comments > 1
order by views desc
limit 1;
```

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\MySql\高级\笔记\e1.PNG)

> type是all，extra里还出现了using filesort

```mysql
create index idx_article_ccv on article(category_id,comments,views);
```

> 为where条件和order条件添加索引

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\MySql\高级\笔记\e12.PNG)

> 再次执行，索引被用到，type变为range
>
> 但是using filesort依然存在
>
> 因为where后面跟着范围判断
>
> 导致where后的索引失效

```mysql
drop index idx_article_ccv on article;
create index idx_article_cv on article(category_id,views);
```

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\MySql\高级\笔记\e13.PNG)

> 那我们就绕过第二层，建立1、3的索引
>
> 结果非常理想



### 两表案例

```mysql
explain select * 
from class
left join book on class.card = book.card;
```

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\MySql\高级\笔记\e2.PNG)

```mysql
alter table book add index y(card);
```

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\MySql\高级\笔记\e21.PNG)

```mysql
drop index y on book;
alter table class add index y(card);
```

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\MySql\高级\笔记\e22.PNG)

> 由左连接特性决定，左连接用于确定如何从右表搜索行，左表一定都有
>
> 右表才是关键点，应该把索引建在右表
>
> 右连接同理，应该把索引建在左表



### 三表案例

```mysql
explain select * 
from class
left join book on class.card = book.card
left join phone on book.card = phone.card;
```

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\MySql\高级\笔记\e3.PNG)

> 按照之前的理论，左连接建右表

```mysql
alter table book add index y(card);
alter table phone add index z(card);
```

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\数据库\MySql\高级\笔记\e31.PNG)

> 效果不错



### 结论

> * 永远用小表驱动大表
> * 优先优化嵌套循环中的内层循环
> * 保证join语句中被驱动表上的条件字段已经有索引
> * 如果无法保证join条件字段被索引，不要吝啬joinBuffer



## 避免索引失效


> 索引失效常见原因：
> 1. ~~全值匹配我最爱~~
> 2. 最佳左前缀法则
> 3. 不在索引列上做任何操作
> 4. 存储引擎不能使用索引中范围条件右边的列
> 5. 尽量使用覆盖索引（只访问索引的查询）
> 6. mysql在使用不等的时候无法使用索引
> 7. is null，is not null也无法使用索引
> 8. like以通配符开头索引会失效
> 9. 字符串不加单引号索引失效
> 10. 少用or，用它连接索引会失效

```mysql
alter table staffs add index idx_staffs_nameAgePos(name,age,pos);
```



### 最佳左前缀法则

```mysql
explain select *
from staffs
where name = 'July';
#索引有效
```

```mysql
explain select *
from staffs
where name = 'July' and age = 25;
#索引有效
```

```mysql
explain select *
from staffs
where name = 'July' and age = 25 and pos = 'dev';
#索引有效
```

```mysql
explain select *
from staffs
where age = 25 and pos = 'dev';
#索引失效，全表扫描，ref是null
```

```mysql
explain select *
from staffs
where pos = 'dev';
#索引失效，全表扫描，ref是null
```

> 如果索引了多列，要遵守最佳左佳前缀法则
>
> 指的是**查询从索引的最左前列开始，不跳过索引中的列**

```mysql
explain select *
from staffs
where name = 'July' and pos = 'dev';
#索引有效，但只引用了索引的name部分
```



### 不在索引列上做任何操作

> 包含计算、函数、类型转换

```mysql
explain select *
from staffs
where left(name,4) = 'July';
```



### 范围之后全失效

```mysql
explain select *
from staffs
where name = 'July' and age > 11 and pos = 'dev';
#索引有效，type从ref变为range，引用了索引的name，age部分
```



### 尽量使用覆盖索引

```mysql
explain select name,age,pos
from staffs
where name = 'July' and age = 25 and pos = 'dev';
#不但索引有效，而且还using index
```

```mysql
explain select *
from staffs
where name = 'July' and age > 11 and pos = 'dev';
#索引有效，type是ref，using index
```



### 使用不等于无法使用索引

```mysql
explain select *
from staffs
where name <> 'July';
#全表扫描
```



### null判断无法使用索引

```mysql
explain select *
from staffs
where name is not null;
```



### like以通配符开头无法使用索引

```mysql
explain select *
from staffs
where name like '%July';
```

> 有的时候必须两边加入%，但又非得用索引，应该怎么做
>
> 使用覆盖索引，并且查询的数据必须是索引中的值，或者为主键



### 字符串不加单引号索引

> **重罪，varchar一定要加单引号**
>
> 不然会违反不在索引列上做任何操作
>
> 会进行类型转换，以至于不可使用索引



### 少用or，用它连接索引会失效

> 哪怕两个数据都是索引字段，索引依然会失效



## in和exists

> 遵循原则小表驱动大表

```mysql
select *
from A
where id in (
	select id from B
)
```

> 如果B表比A表小应该这样写
>
> 反之

```mysql
select * 
from A
exists (
    select 1
    from B
    where B.id = A.id
)
```



## 排序优化

###  order by

> 尽量使用索引进行排序

```mysql
create index idx_A_ageBirth on tblA(age,birth);
```

```mysql
explain select * 
from tblA 
where age > 20
order by age;
#不会产生filesort
```

```mysql
explain select * 
from tblA 
where age > 20
order by age,birth;
#不会产生filesort
```

```mysql
explain select * 
from tblA 
where age > 20
order by birth;
#产生filesort
```

```mysql
explain select * 
from tblA 
where age > 20
order by birth,age;
#产生filesort
```

```mysql
explain select * 
from tblA 
order by birth;
#产生filesort
```

```mysql
explain select * 
from tblA 
order by age asc, birth desc;
#产生filesort
```

> order by 使用索引最左前列
>
> 使用where子句与order by 子句条件列组合满足索引最左前列
>
> 会用到索引
>
> 依旧符合最佳左前列原则

> 如果排序不在索引上，filesort有两种算法
>
> 双路排序和单路排序



### 双路排序

> MySQL 4.1之前使用双路排序，两次扫描磁盘，最终得到数据
>
> 第一次读取行指针和列，对它们进行排序
>
> 再次扫描排好的列，按照顺序读取数据
>
> 很显然这样做很耗IO，所以在4.1版本之后，出现了改进算法，单路排序



### 单路排序

> 从磁盘中读取需要的所有列，在buffer中对它们排序，然后进行输出
>
> 它的缺点是浪费空间，因为需要一个buffer
>
> 如果一次读取大小超出了buffer的大小，则会效率还不如双路排序
>
> 总体而言单路还是优于双路

> 解决方案：
>
> 不要在order by时使用select *
>
> 增大sort_buffer_size的设置
>
> 增大max_length_for_sort_data的设置



### group by

> 实质是先排序再分组，遵循order by的原则

> where 高于 having，能写在where的条件，不要写在having里



## 慢查询日志

> MySQL的慢查询日志是MySQL提供的一种日志记录
>
> 用来记录在MySQL中响应时间超过阈值的语句
>
> 阈值是指long_query_time的值，默认为10（秒）
>
> 由它来查看哪些SQL，是我们需要关心优化的

> 默认情况下，MySQL不开启慢查询日志
>
> ```mysql
> show variables like '%slow_query_log%';
> set global slow_query_log = 1;
> ```
> 如果重启，会恢复关闭状态
>
> 如果非得一直生效，请修改配置文件

> ```mysql
> show variables like 'long_query_time%';
> ```
>
> 设置完成后要重启会话
>
> ```mysql
> show global status like '%slow_queries%';
> ```
>
> 此命令可以看到慢查询日志记录了多少条



### 日志分析工具

> MySQL提供了日志分析工具mysqldumpslow

> 得到返回记录集最多的10条sql
>
> ```mysql
> mysqldumpslow -s r -t 10 /var/lib/mysql/xxx-slow.log
> ```
>
> 得到访问次数最多的10条sql
>
> ```mysql
> mysqldumpslow -s c -t 10 /var/lib/mysql/xxx-slow.log
> ```
>
> 得到按时间排序的，前10条中含有左连接的查询语句
>
> ```mysql
> mysqldumpslow -s t -t 10 -g "left join" /var/lib/mysql/xxx-slow.log
> ```
>
> 建议在使用这些命令时搭配 | 和 more 使用，否则可能会爆屏



## show profile

> show profile是MySQL提供可以用来分析当前会话中语句执行的资源消耗情况
>
> 可以用于SQL调优的测量

> ```mysql
> show variables like 'profiling';
> set profiling = on;
> ```
>
> 默认是关闭的，需要开启

> ```mysql
> show profiles;
> ```
>
> 查看结果
>
> ```mysql
> show profile cpu,block io for query id;
> ```
>
> id填上一步查出来对应的id
>
> 这里的参数可以填以下内容
>
> all：所有开销信息
>
> block io：io相关开销
>
> context switches：上下文切换相关开销
>
> cpu：cpu开销
>
> ipc：发送和接收相关开销
>
> memory：内存开销
>
> page faults：页面错误开销
>
> source：显示和source_function，source_file，source_line相关开销
>
> swaps：显示交换次数相关开销

> 严重问题：
>
> converting HEAP to MyISAM：查询结果太大，内存不够，开始往磁盘记录
>
> Creating tmp table：创建临时表
>
> Copying to tmp table on disk：把内存中临时表复制到磁盘，危险！
>
> locked



## 全局查询日志

> 永远不要在生产环境开启这个功能！

> 开启方式一：
>
> 在配置文件中
>
> general_log=1
>
> general_log_file=/path/logfile
>
> log_output=FILE

> 开启方式二：
>
> set global general_log=1;
>
> set global log_output='TABLE';

> 使用
>
> select * from mysql.general_log;
>
> 来查看



## 锁

### 表锁

> 表锁偏读
>
> 偏向MyISAM存储引擎，开销小，加锁快，无死锁，粒度大，发生冲突概率高，并发度最低

> 手动增加表锁
>
> 手动解锁

```mysql
lock table 表名 read(wirte), 表2 read(wirte),...;
unlock tables;
```

> session 1使用读锁，锁了A表
>
> 在此期间
>
> session 1可以读这个表
>
> session 1不可以写这张表
>
> session 1不可以读其他表
>
> 其他session 可以读这张表
>
> 其他session 可以读其他表
>
> 其他session 写这张表将被阻塞

> session 1使用写锁，锁了A表
>
> 在此期间
>
> session 1可以读这个表
>
> session 1可以写这张表
>
> session 1不可以读其他表
>
> 其他session 读这张表将被阻塞
>
> 其他session 可以读其他表
>
> 其他session 写这张表将被阻塞

> MyISAM在执行查询语句前，会给涉及的所有表加读锁
>
> 在执行增删改之前，会给涉及的所有表加写锁

> **简而言之**
>
> **读锁会阻塞写**
>
> **写锁会阻塞读和写**

```mysql
show status like 'table%';
```

> 此命令可以查到
>
> table_locks_immediate：可以立即获取锁的查询次数
>
> table_locks_waited：出现表级锁争用而发生的等待次数



### 行锁

> 偏向InnoDB引擎，开销大，加锁慢，会出现死锁，锁定粒度最小，发生锁冲突概率最低，并发度最高

> 如果使用索引失效，会将行锁升级为表锁
>
> 最常见的就是自动类型转换

> 当我们用范围条件检索数据，InnoDB会给复合条件的记录加锁，如果表中没有这条数据，但是符合范围条件，也会被加锁，这种锁叫**间隙锁**

> 如果某一行出现问题，我们需要锁定这一行
>
> 就这样做
>
> ```mysql
> begin;
> select * from 表 where a=8 for update;
> commit;
> ```
>
> 在不执行commit之前，这行数据就被锁了

```mysql
show status like 'innodb_row_lock%';
```

> 这条命令可以分析行锁的状态
>
> Innodb_row_lock_current_waits：当前正在等待锁定的数量
>
> Innodb_row_lock_time：锁定总时间
>
> Innodb_row_lock_time_avg：每次等待平均时间
>
> Innodb_row_lock_time_max：等待最长一次所花时间
>
> Innodb_row_lock_waits：总共等待次数



## 主从复制

> MySQL复制过程分为三步
>
> 1. master将改变记录到二进制日志（binary log），这些记录过程叫做二进制日志事件，binary log events
> 2. slave将master的binary log events拷贝到它的中继日志（relay log）
> 3. slave重做中继日志中的事件，将改变应用到自己的数据库
>
> MySQL复制是异步且串行化的

> 每个slave只有一个master
>
> 每个slave只能有一个唯一的服务器ID
>
> 每个master可以有多个slave



### 具体操作

> 要求
>
> mysql版本一致，且后台以服务运行

> 1. 主机配置（**必须**，可选）：
>
> **server-id=1**  ----> 标识ID
>
> **log-bin=自己sql本地安装路径/mysqlbin**  ----> 二进制日志
>
> log-error=自己sql本地安装路径/mysqlerr  ----> 错误日志
>
> basedir="自己sql本地安装路径"  ----> 根目录
>
> tmpdir="自己sql本地安装路径"  ----> 临时目录
>
> datadir="自己sql本地安装路径/Data/"  ----> 数据目录
>
> read-only=0  ----> 主机读写都可以
>
> binlog-ignore-db=mysql  ----> 设置不要复制的数据库
>
> binlog-do-db=mysql  ----> 设置需要复制的数据库

> 2. 从机配置（**必须**，可选）：
>
> **服务器唯一ID**
>
> 启用二进制日志

> 3. 重启mysql服务
>
> 4. 关闭主从机防火墙
>
> 5. 在主机建立账户授权slave
>
>    ```mysql
>    grant replication slave on *.* to '名称'@'从机ip' identified by '密码' ;
>    flush privileges;
>    #查询master的状态
>    show master status;
>    ```
>
> 6. 从机上配置要复制的主机
>
>    ```mysql
>    change master to master_host='主机ip',master_user='名称',master_password='密码',master_log_file='file名',master_log_pos=position数字;
>    start slave;
>    #查看从机状态
>    show slave status;
>    ```
>
>    如果以下参数为yes说明配置成功
>
>    Slave_IO_Running
>
>    Slave_SQL_Running

> 至此，已经配置成功
>
> 之后主机的新建库，新建表，insert记录，从机都会复制



### 停止复制功能

```mysql
stop slave;
```

