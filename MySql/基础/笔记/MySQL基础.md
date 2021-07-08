# MySQL基础

## 数据库简介

### 数据库的好处

> 	1. 持久化数据到本地
> 	2. 可以实现结构化查询，方便管理

### 数据库相关概念

> 1. DB：数据库，保存一组有组织的数据的容器
> 2. DBMS：数据库管理系统，又称为数据库软件（产品），用于管理DB中的数据
> 3. SQL:结构化查询语言，用于和DBMS通信的语言

### 数据库存储数据的特点

> 1. 将数据放到表中，表再放到库中
> 2. 一个数据库中可以有多个表，每个表都有一个的名字，用来标识自己。表名具有唯一性
> 3. 表具有一些特性，这些特性定义了数据在表中如何存储，类似java中 “类”的设计
> 4. 表由列组成，我们也称为字段。所有表都是由一个或多个列组成的，每一列类似java 中的”属性”
> 5. 表中的数据是按行存储的，每一行类似于java中的“对象”



## MySQL介绍

### 常见命令

```mysql
#1.查看当前所有的数据库
show databases;

#2.打开指定的库
use 库名

#3.查看当前库的所有表
show tables;

#4.查看其它库的所有表
show tables from 库名;

#5.创建表
create table 表名(
	列名 列类型,
	列名 列类型，
	。。。
);

#6.查看表结构
desc 表名;

#7.查看服务器的版本
#方式一：登录到mysql服务端
select version();
#方式二：没有登录到mysql服务端
mysql --version
#或
mysql --V
```



### MySQL的语法规范

> 1. 不区分大小写,但建议关键字大写，表名、列名小写
> 2. 每条命令最好用分号结尾
> 3. 每条命令根据需要，可以进行缩进 或换行
> 4. 注释
>    单行注释：#注释文字
>    单行注释：-- 注释文字
>    多行注释：/* 注释文字  */



### SQL语言分类

> * DQL（Data Query Language）：数据查询语言  select 
> * DML  (Data Manipulate Language）：数据操作语言  insert 、update、delete
> * DDL（Data Define Languge）：数据定义语言  create、drop、alter
> * TCL（Transaction Control Language）：事务控制语言  commit、rollback





## DQL语言学习

### 基础查询

```mysql
select 查询列表
from 表名;
```

> * 通过select查询完的结果 ，是一个虚拟的表格，不是真实存在
>
> * 要查询的东西 可以是常量值、可以是表达式、可以是字段、可以是函数

```mysql
select last_name 
from employees;

select last_name,salary,email 
from employees;

select employee_id,first_name,last_name,email,
       phone_number,job_id,salary,commission_pct,
       manager_id,department_id,hiredate
from employees;

select *
from employees;
```

> 有些字段可能会与MySQL中保留字冲突，虽然不影响执行结果，但看起来不舒服，可以用单引号包裹，让可读性增强



#### 查询常量

```mysql
#查询常量
select 100;
select 'john';
```

#### 查询表达式
```mysql
select 2*3;
select 100%98;
```

####  查询函数
```mysql
select version();
```

#### 起别名

```mysql
select last_name as 姓,
       first_name 名
from employees;
```

> * 便于理解
>
> * 如果多表联查，字段名冲突，可以用于区分

#### 去重

```mysql
select department_id
from employees;
#这样查有多少条内容，会出多少条结果

select distinct department_id
from employees;
```

#### + 号

> 查询员工名和姓，拼成一个字段，显示为姓名

```mysql
select last_name+employees.first_name as 姓名
from employees;
```

> 按照Java的理解，这样写是对的
>
> **但 + 号在MySQL中只有运算符这一个功能，没有字符拼接的含义**



```mysql
select '123'+90; #213
select 'john'+90; #90
select null+90; #null
```

> * 双方都是数字不用过多解释
>
> * 如果有一方为字符，则会尝试进行转换，如果转换成功则继续执行加法运算
>
>   **如果转换失败，则讲字符型转换为0**
>
> * 只要其中一方为null，则结果是null

#### concat

> 如果需要字符拼接，则需要使用concat函数

```mysql
select concat('a','b','c') as 结果;
```

#### ifnull

```mysql
select ifnull(commission_pct,0) as 奖金率, commission_pct
from employees;
```
> 如果是null就用第二个值填充，否则直接输出


#### 练习一

> test_lesson01 基本SQL-SELECT语句



### 条件查询

```mysql
select 
	查询类别
from
	表名
where
	筛选条件;
```

> 分类：
>
> 1. 按条件表达式筛选 > < =  <> (!=) >= <=
>
> 2. 按逻辑表达式筛选 and or not
>
> 3. 模糊查询 
>
>    like
>
>    between and
>
>    in 
>
>    is null



#### 条件表达式筛选

```mysql
select last_name
from employees
where salary>12000;
```

```mysql
select last_name,department_id
from employees
where department_id <> 90;
```

#### 逻辑表达式筛选

```mysql
select last_name,salary,commission_pct
from employees
where salary>=10000 and salary<=20000;
```

```mysql
select last_name
from employees
where department_id<90 or department_id>110 or salary>15000;
```

#### 模糊查询

##### like

> 1. 需求：查询员工名中包含a的员工
> 2. 需求：查询员工名第三个字符为n，第五个字符为l的员工名和工资
> 3. 需求：查询员工名第三个字符为_的员工名

```mysql
select *
from employees
where last_name like '%a%';

select last_name,salary
from employees
where last_name like '__n_l%';

select last_name
from employees
where last_name like '_\_%';

select last_name
from employees
where last_name like '_$_%' escape '$';
```

> `like` 一般来说和通配符搭配使用
>
> **通配符%** ：任意多个字符  0+
>
> **通配符_** ：任意单个字符  1
>
> 转义字符 “ \ ”  用法与Java一致
>
> MySQL中支持自定义转义字符，只需在后在escape ' 你的转义字符 '



---



##### between and

```mysql
select *
from employees
where employee_id between 100 and 120;
```

> `between  and`：**完全**等同于>= 和 <= 所以包含了首尾，所以**不能把大的写前面，小的写后面**



---

##### in

```mysql
select last_name,job_id
from employees
where job_id in ('IT_PROT','AD_VP','AD_PRES');
```



---



##### is  null

```mysql
select last_name,commission_pct
from employees
where commission_pct is null ;

select last_name,commission_pct
from employees
where commission_pct is not null ;
```



---



##### 安全等于

```mysql
select last_name,commission_pct
from employees
where commission_pct <=> null ;

select last_name,salary
from employees
where salary <=> 12000;
```

> 安全等于，既可以连接常量，也可以连接null
>
> 但不建议使用，可读性差



#### 练习二

>test_lesson02 过滤数据



### 排序查询

```mysql
select
	查询列表
from
	表
[where
	筛选条件]
order by 排序列 asc|desc;
```

```mysql
select *
from employees
order by salary desc ;
```

> `asc` ：升序，默认值
>
> `desc` ：降序

```mysql
select *
from employees
where department_id >= 90
order by hiredate;
```
#### 按别名排序

```mysql
select last_name,salary*12*(1+ifnull(commission_pct,0)) as 年薪
from employees
order by 年薪 desc ;
```
#### 按表达式排序

```mysql
select last_name,salary*12*(1+ifnull(commission_pct,0)) as 年薪
from employees
order by salary*12*(1+ifnull(commission_pct,0)) desc ;
```
#### 按函数排序

```mysql
select last_name,salary
from employees
order by length(last_name);
```

#### 多重排序

```mysql
select last_name,salary,employee_id
from employees
order by salary,employee_id desc;
```

#### 练习三

> test_lesson03 排序数据 



### 单行函数

#### 字符函数

##### length

```mysql
select length('john');
```
---
##### concat

```mysql
select concat(last_name,'_',first_name)
from employees;
```
```mysql
select concat(upper(last_name),'-',lower(first_name)) 姓名
from employees;
```
---
##### substr
```mysql
select substr('123456',5); #56
select substr('123456',2,3); #234
```

> 注意：索引是从1开始的，而不是0

---

##### instr

```mysql
select instr('杨不悔爱上了殷六侠','殷六侠'); #7
```

> 返回子字符串，第一次出现的索引，如果找不到返回0

---

##### trim

```mysql
select length(trim('    张翠山   ')) as output;  #9
select trim('a' from 'aaaaaaaa张aaa翠山aaaaaaaaaaa') as output; #张aaa翠山
```

---

##### lpad

```mysql
select lpad('殷素素',10,'*') as output; #*******殷素素
select lpad('殷素素',2,'*') as output; #殷素

select rpad('殷素素',12,'ab') as output; #殷素素ababababa
```

> 用指定的字符，左填充至指定长度

---

##### replace

```mysql
select replace('张无忌爱上了周芷若','周芷若','赵敏') as output;
```



#### 数学函数

##### round

```mysql
select round(1.65);
select round(1.567,2);
```

---

##### ceil

```mysql
select ceil(1.65);
```

---

##### floor

```mysql
select floor(-5.22);
```

---

##### truncate

```mysql
select truncate(2.555,1);
```

> 截断

---

##### mod

```mysql
select mod(10,3);
```

> 取余



#### 日期函数

##### now

```mysql
select now();
```

---

##### curdate

```mysql
select curdate();
```

---

##### curtime

```mysql
select curtime();
```

---

##### 指定时间部分

```mysql
select year(now());
select month(now());
select day(now());
select hour(now());
select minute(now());
select second(now());

select yearweek(now());
select dayofyear(now());
select weekofyear(now());

select monthname(now());
select dayofmonth(now());
```

---

##### str_to_date

```mysql
select str_to_date('9-13-2000','%m-%d-%Y');
```

---

##### date_format

```mysql
select date_format('2018/6/6','%Y年%m月%d日');
```

---

##### datediff

```mysql
select datediff('2021-10-01','2021-09-25');
```

#### 其它函数

```mysql
select version();
select database();
select user();
```



#### 流程控制函数

##### if

```mysql
select if(10>5,'大','小');

select last_name,commission_pct,if(commission_pct is null , '没奖金','有奖金') as 备注
from employees;
```

---

##### case

```mysql
case 字段或表达式
when 常量1 then 语句1
when 常量2 then 语句2
when 常量3 then 语句3
...
else 语句n
end
```

```mysql
select salary as 原始工资,department_id,
case department_id
when 30 then salary*1.1
when 40 then salary*1.2
when 50 then salary*1.3
else salary
end as 新工资
from employees;
```

> case也可以当做多重if来使用

```mysql
case
when 条件1 then 语句1
when 条件2 then 语句2
...
else 语句n
end
```

```mysql
select salary,
case
when salary>20000 then 'A'
when salary>15000 then 'B'
when salary>10000 then 'C'
else 'D'
end as 工资级别
from employees;
```

#### 练习

> test_lesson04 单行函数



### 分组函数

> 用作统计使用
>
> 又称聚合函数或统计函数或组函数

> 分类：
>
> `sum`：求和
>
> `avg`：平均值
>
> `max`：最大值
>
> `min`：最小值
>
> `count`：计算个数

```mysql
select sum(salary) 总和,round(avg(salary),2) 平均,max(salary) 最高,min(salary) 最低,count(salary) 个数
from employees;
```

```mysql
select sum(last_name),avg(last_name)
from employees;
#无意义

select max(last_name),min(last_name)
from employees;
#按字符排序
```

> `sum` `avg` 一般用于处理数值类型
>
> `max` `min` `count` 可以处理任何类型

```mysql
select sum(commission_pct),avg(commission_pct),sum(commission_pct)/35,sum(commission_pct)/107
from employees;

select max(commission_pct),min(commission_pct)
from employees;

select count(commission_pct)
from employees;
```

> 所有分组函数，都忽略null值

```mysql
select sum(distinct salary),sum(salary)
from employees;

select count(distinct salary)
from employees;
```

> 所有分组函数，都支持distinct

```mysql
select count(salary)
from employees;

select count(*)
from employees;

select count(1)
from employees;

select count('崔侠')
from employees;
```

> count(salary)如果有空，则会忽略
>
> count(*)如果有一行，每一列都是空，则会忽略
>
> 剩下两个则是为表添加了一列，内容都是你指定的内容
>
> 在MYISAM引擎下，count(*)效率最高
>
> 在INNODB引擎下，count(*)和count(1)效率差不多，比count(字段)高

```mysql
select avg(salary),employee_id
from employees;
```

> employee_id在这里没有任何意义

#### 练习

> test_lesson06 分组查询





















