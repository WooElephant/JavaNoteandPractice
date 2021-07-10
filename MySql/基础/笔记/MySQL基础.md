# MySQL基础

## 数据库简介

### 数据库的好处

> 1. 持久化数据到本地
> 2. 可以实现结构化查询，方便管理

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

> test_lesson05 分组函数



### 分组查询

```mysql
select 列
from 表
[where 表达式]
[group by 分组表达式]
[order by 列]
```

```mysql
select max(salary),job_id
from employees
group by job_id;

select count(*),location_id
from departments
group by location_id;
```

```mysql
select avg(salary),department_id
from employees
where email like '%a%'
group by department_id;

select max(salary),manager_id
from employees
where commission_pct is not null
group by manager_id;
```

#### having

> 需求：查询哪个部门的员工个数大于2

```mysql
select count(*),department_id
from employees
group by department_id;
```

> 筛选得建立在这条语句的结果之上

```mysql
select count(*),department_id
from employees
group by department_id
having count(*)>2;
```

> 所以要加入新的关键词having，添加分组后的筛选



---

> 需求：查询每个工种有奖金的员工的最高工资>12000的工种编号和最高工资

```mysql
select max(salary),job_id
from employees
where commission_pct is not null
group by job_id
having max(salary)>12000;
```



---

> 需求：查询领导编号>102的每个领导手下的最低工资>5000的领导编号

```mysql
select min(salary),manager_id
from employees
where manager_id>102
group by manager_id
having min(salary)>5000;
```



#### 按函数分组

```mysql
select length(last_name) 长度,count(*) 个数
from employees
group by 长度
having 个数>5;
```

> 注意，不推荐这样写，因为很多数据库，不支持 group by 和 having 后连接别名



#### 按多个字段分组

```mysql
select avg(salary),department_id,job_id
from employees
group by department_id, job_id;
```

#### 分组查询排序

```mysql
select avg(salary),department_id,job_id
from employees
where department_id is not null
group by department_id, job_id
having avg(salary) > 10000
order by avg(salary) desc;
```

#### 练习

> test_lesson06 分组查询



### 链接查询

> 又称多表连接

```mysql
select name,boyName
from boys,beauty;
```

> 如果我们这样写，结果有问题
>
> 就相当于，用第一张表的一行，去完全匹配第二张表
>
> 以此类推
>
> 就会形成12（name）*4（boyname）= 48个结果
>
> 我们将这种现象称为笛卡尔乘积
>
> 导致错误的原因，是我们没有添加任何连接条件

```mysql
select name,boyName
from boys,beauty
where beauty.boyfriend_id = boys.id;
```

> 按年代分类链接查询分为两个标准：
>
> sql92标准：仅仅对内连接支持较好
>
> sql99标准（推荐）：支持内连接，外连接，交叉连接。不支持外连接中的全外连接

> 按功能分为：
>
> 内链接：
>
> ​				等值连接
>
> ​				非等值连接
>
> ​				自连接
>
> 外连接：
>
> ​				左外连接
>
> ​				右外连接
>
> ​				全外连接
>
> 交叉连接：



#### sql92

##### 等值连接

> 查询女神名和对应的男神名

```mysql
select name,boyName
from boys,beauty
where beauty.boyfriend_id = boys.id;
```

> 查询员工名和对应的部门名

```mysql
select last_name,department_name
from employees,departments
where employees.department_id = departments.department_id;
```

---

###### 起别名

> 查询员工名，工种号，工种名

```mysql
select last_name,employees.job_id,job_title
from employees,jobs
where employees.job_id = jobs.job_id;

select last_name,e.job_id,job_title
from employees e,jobs j
where e.job_id = j.job_id;
```

> 可以为表起别名，如果起了别名，就必须用别名

---

###### 加筛选

> 查询有奖金的员工名，部门名

```mysql
select last_name,department_name
from employees e,departments d
where e.department_id = d.department_id
and e.commission_pct is not null ;
```

> 查询城市名第二个字符为o的部门名和城市名

```mysql
select department_name,city
from departments d,locations l
where d.location_id = l.location_id
and city like '_o%';
```

---

###### 加分组

> 查询每个城市的部门个数

```mysql
select count(*),city
from departments d,locations l
where d.location_id = l.location_id
group by city;
```

> 查询有奖金的每个部门的部门名和部门的领导编号和该部门的最低工资

```mysql
select department_name,e.manager_id,min(salary)
from departments d,employees e
where e.department_id = d.department_id
and commission_pct is not null
group by department_name, d.manager_id;
```

---

###### 加排序

> 查询每个工种的工种名和员工个数，并且按员工个数降序

```mysql
select job_title,count(*)
from employees e, jobs j
where e.job_id = j.job_id
group by job_title
order by count(*) desc ;
```

---

###### 三表连接

> 查询员工名，部门名，所在城市

```mysql
select last_name,department_name,city
from employees e,departments d,locations l
where e.department_id = d.department_id
and d.location_id = l.location_id;
```

---

##### 非等值连接

> 查询员工的工资和工资级别

```mysql
select salary,grade_level
from employees e,job_grades j
where e.salary between j.lowest_sal and j.highest_sal;
```

---

##### 自连接

> 查询员工名和领导名

```mysql
select e.last_name,m.last_name
from employees e,employees m
where e.manager_id = m.employee_id;
```

---

##### 练习

> test_lesson07 SQL92语法连接查询



#### sql99

```mysql
select 查询列
from 表1 别名 [连接类型]
join 表2 别名
on 连接条件
```

##### 内连接

```mysql
select 查询列
from 表1 别名
inner join 表2 别名
on 连接条件
```

###### 等值连接

> 查询员工名，部门名

```mysql
select last_name,department_name
from employees e
inner join departments d
on e.department_id = d.department_id;
```

> 查询名字中包含e的员工名和工种名

```mysql
select last_name,job_title
from employees e
inner join jobs j
on e.job_id = j.job_id
where e.last_name like '%e%';
```

> 查询部门个数>3的城市名和部门个数

```mysql
select count(*),city
from departments d
inner join locations l
on d.location_id = l.location_id
group by city
having count(*) > 3;
```

> 查询哪个部门的部门员工个数>3的部门名和员工个数，并按个数排序

```mysql
select count(*),department_name
from employees e
inner join departments d
on e.department_id = d.department_id
group by department_name
having count(*)>3
order by count(*) desc;
```

> 查询员工名，部门名，工种名，并按部门名降序

```mysql
select last_name,department_name,job_title
from employees e
inner join departments d on e.department_id = d.department_id
inner join jobs j on e.job_id = j.job_id
order by department_name desc;
```

---

###### 非等值连接

> 查询员工工资级别

```mysql
select last_name,salary,grade_level
from employees e
inner join job_grades j
on e.salary between j.lowest_sal and j.highest_sal;
```

> 查询每个工资级别的员工个数>20的个数，并且按降序排序

```mysql
select count(*),grade_level
from employees e
inner join job_grades j
on e.salary between j.lowest_sal and j.highest_sal
group by grade_level
having count(*) > 20
order by grade_level desc;
```

---

###### 自连接

> 查询员工名，上级名

```mysql
select e.last_name 员工名,m.last_name 上级名
from employees e
inner join employees m
on e.manager_id = m.employee_id;
```

---

##### 外连接

> 查询没有男朋友的女神名

```mysql
select b.name,bo.*
from beauty b
left join boys bo
on b.boyfriend_id = bo.id;
```

> 外连接的查询结果为主表中所有记录
>
> 如果从表中有和它匹配的，则显示匹配的值
>
> 如果从表中没有和它匹配的，则显示null
>
> 外连接查询结果=内连接查询结果+主表中有而从表中没有的部分

> 左外连接，left join左边的表是主表
>
> 右外连接，right join右边的表是主表
>
> 左外和右外，可以通过交换表的顺序实现同样的效果

> 查询哪个部门没有员工

```mysql
select d.department_id
from departments d
left join employees e on d.department_id = e.department_id
where e.employee_id is null ;
```

---

###### 全外连接

```mysql
select b.*,bo.*
from beauty b
full join boys bo
on b.boyfriend_id = bo.id;
```

> MySQL不支持这种语法，它的结果是左外+右外
>
> 匹配的值，主表有从表没有的值，从表有主表没有的值
>
> 都会显示

---

##### 交叉连接

```mysql
select b.*,bo.*
from beauty b
cross join boys bo;
```

> 其实就是99语法的笛卡尔乘积

---

##### 练习

> test_lesson08 SQL99语法连接查询



### 子查询

> 出现在其他语句中的select语句，称为子查询或内查询

#### where、having后子查询

> 子查询都放在小括号内

##### 标量子查询（单行子查询）

> 一般搭配单行操作符使用
>
> ">  <  >=  <=  =  <>"

> 谁的工资比Abel高

```mysql
select last_name
from employees
where salary > (
        select salary
        from employees
        where last_name = 'Abel'
    );
```

> 查询job_id与141号员工相同，salary比143号员工多的员工名，job_id和工资

```mysql
select last_name,job_id,salary
from employees
where job_id = (
    select job_id
    from employees
    where employee_id = 141
)
and salary > (
    select salary
    from employees
    where employee_id = 143
);
```

> 查询工资最少的员工的last_name，job_id，和salary

```mysql
select last_name,job_id,salary
from employees
where salary = (
    select min(salary)
    from employees
);
```

> 查询最低工资大于50号部门最低工资的部门id和其最低工资

```mysql
select department_id,min(salary)
from employees
group by department_id
having min(salary) > (
    select min(salary)
    from employees
    where department_id = 50
);
```

> 非法使用
>
> 结果必须为单行单列，如果不是则会报错

```mysql
select department_id,min(salary)
from employees
group by department_id
having min(salary) > (
    select salary
    from employees
    where department_id = 50
);
```

---

##### 列子查询（多行子查询）

> 一般搭配多行操作符使用
>
> `in / not in`：等于（不等于）任意一个
>
> `any | some`：与某一个作比较，可读性不高，且可以被替换，一般不用
>
> `all`：与所有的比较

> 查询location_id为1400或1700的部门中所有员工名

```mysql
select last_name
from employees
where department_id in (
    select department_id
    from departments
    where location_id in (1400,1700)
);
```

> 查询其他工种中，比job_id为IT_PROG部门任一工资低的员工的工号，姓名，job_id，salary

```mysql
select employee_id,last_name,job_id,salary
from employees
where salary < any(
    select distinct salary
    from employees
    where job_id = 'IT_PROG'
)
and job_id <> 'IT_PROG';

#替代any方案
select employee_id,last_name,job_id,salary
from employees
where salary < (
    select distinct max(salary)
    from employees
    where job_id = 'IT_PROG'
)
and job_id <> 'IT_PROG';
```

> 查询其他工种中，比job_id为IT_PROG部门所有工资低的员工的工号，姓名，job_id，salary

```mysql
select employee_id,last_name,job_id,salary
from employees
where salary < all(
    select distinct salary
    from employees
    where job_id = 'IT_PROG'
)
and job_id <> 'IT_PROG';

#替代all方案
select employee_id,last_name,job_id,salary
from employees
where salary < (
    select distinct min(salary)
    from employees
    where job_id = 'IT_PROG'
)
and job_id <> 'IT_PROG';
```

---

##### 行子查询（多列多行）

> 查询员工编号最小并且工资最高的员工

```mysql
select last_name
from employees
where employee_id = (
    select min(employee_id)
    from employees
)
and salary = (
   select max(salary)
    from employees
);
```

> 这是以前的写法
>
> 我们发现判断条件都是等于
>
> 这种情况可以替换为行子查询

```mysql
select last_name
from employees
where (employee_id,salary) = (
    select min(employee_id),max(salary)
    from employees
);
```

#### select后子查询

> 查询每个部门的员工个数

```mysql
select d.department_id,(
    select count(*)
    from employees e
    where e.department_id = d.department_id
) 个数
from departments d;
```

> 查询员工号=102的部门名

```mysql
select (
    select department_name
    from departments d
    inner join employees e on d.department_id = e.department_id
    where e.employee_id = 102
) 部门名;
```

#### from后子查询

> 查询每个部门的平均工资等级

```mysql
select ag.a,ag.department_id,grade_level
from (
    select avg(salary) a , department_id
    from employees
    group by department_id
) ag
inner join job_grades j on ag.a between lowest_sal and highest_sal;
```

#### exists后子查询（相关子查询）

```mysql
select exists(select employee_id from employees); #1
select exists(select employee_id from employees where salary=300000); #0
```

> 查询有员工的部门名

```mysql
select department_name
from departments d
where exists(
    select *
    from employees e
    where d.department_id = e.department_id
);
```

> 查询没有女朋友的男神信息

```mysql
select boyName
from boys bo
where not exists(
    select boyfriend_id
    from beauty b
    where bo.id = b.boyfriend_id
);
```

#### 练习

> test_lesson09 子查询





### 分页查询

```mysql
select 查询列
from 表
[ jointype 表2
on 连接条件
where 筛选条件
group by 分组字段
having 分组后筛选
order by 排序字段 ]
limit offset,size;
```

> `offset`：要现实的条目起始索引（从0开始）
>
> `size`：要显示的条目个数

> 查询前五条员工信息

```mysql
select *
from employees
limit 0,5;
```

> 查询11-25条员工信息

```mysql
select *
from employees
limit 10,15;
```

> 查询有奖金的员工信息，并且工资较高的前10条

```mysql
select *
from employees
where commission_pct is not null
order by salary desc
limit 10;
```

> limit 特点
>
> 1. limit 放在查询语句最后
>
> 2. 显示页数page，每页数目size  
>
>    limit （page-1）*size,size

#### 练习

> 子查询经典案例题目
>
> 作业



### union联合查询

> 将多条查询语句的结果合并成一个结果

```mysql
查询语句1
union
查询语句2
```

> 查询部门编号>90或者邮箱中包含a的员工信息

```mysql
select *
from employees
where email like '%a%'
union
select *
from employees
where department_id > 90;
```

> 应用场景
>
> 有两张表结构相同，一张记录中国人，一张记录美国人
>
> 但这两张表没有联系
>
> 现在需要查询的信息相同
>
> 所有性别为男的人的姓名

> 注意
>
> 查询列的数量要相同，不然会报错
>
> 内容和顺序最好也是相同的，不然会混乱
>
> 如果两张表中有相同的值会自动去重，如果不想去重要使用 `union all`



## DML语言学习

> 数据操作语言
>
> 增：insert
>
> 删：delete
>
> 改：update

### 增

```mysql
insert into 表(字段名...)
values (值....);
```

> 插入的值得类型要与列一致或兼容

```mysql
insert into beauty(id,name,sex,borndate,phone,photo,boyfriend_id)
value (13,'唐艺昕','女','1990-4-23','18988888888',null,2);
```

```mysql
insert into beauty(id,name,sex,borndate,phone,boyfriend_id)
value (14,'金星','女','1990-4-23','18988888888',9);

insert into beauty(id,name,sex,phone)
value (15,'娜扎','女','18988888888');
```

> 如果字段可以为空，也可以不写，如果不写，列名也不能写

```mysql
insert into beauty(name,sex,id,phone)
value ('娜扎','女',16,'18988888888');
```

> 列的顺序也可以颠倒

```mysql
insert into beauty
values (18,'张飞','男',null,'119',null,null);
```

> 列可以不写，但值得顺序必须与表一致，且空必须写null

```mysql
insert into 表名
set 列1=值1, 列2=值2.....

insert into beauty
set id=19,name='刘涛',phone='999';
```

> 也可以这样添加

> values添加可以添加多行，小括号间用逗号隔开
>
> values可以支持子查询



### 改

```mysql
update 表
set 列=新值，列=新值...
where 筛选条件
```

```mysql
update beauty
set phone = '138'
where name like '唐%';

update boys
set boyName='张飞',userCP=10
where id=2;
```

> 多表修改也是可以的，但很少用，了解即可

```mysql
#sql92
update 表1 别名，表2 别名
set 列=值.....
where 连接条件
and 筛选条件

#sql99
update 表1 别名
连接类型 join 表2 别名
on 连接条件
set 列=值.....
where 筛选条件
```
> 修改张无忌的女朋友的手机号为114
```mysql
update boys bo
inner join beauty b
on b.boyfriend_id = bo.id
set b.phone = '114'
where bo.boyName = '张无忌';
```

> 修改没有男朋友的女神的男朋友编号为2

```mysql
update beauty b
left join boys bo
on b.boyfriend_id = bo.id
set b.boyfriend_id = 2
where b.id is null;
```



### 删

```mysql
delete from 表
where 筛选条件

truncate table 表名;
```

> truncate是直接把表删了

> 删除手机号以9结尾的女神信息

```mysql
delete from beauty
where phone like '%9';
```

> 删除张无忌的女朋友的信息

```mysql
delete b
from beauty b
inner join boys bo
on b.boyfriend_id = bo.id
where bo.boyName = '张无忌';
```

> 删除黄晓明的信息，以及他女朋友的信息

```mysql
delete b,bo
from beauty b
inner join boys bo
on b.boyfriend_id = bo.id
where bo.boyName = '黄晓明';
```

```mysql
truncate table boys;
```

> 清空boys表

> delete删除数据，自增长从断点开始
>
> truncate删除，自增长从0开始
>
> truncate不可以回滚



### 练习

> test_lesson10 数据处理



## DDL语言学习

> 数据定义语言
>
> 库和表的管理

### 库的管理

#### 库的创建

```mysql
create database 库名;

create database if not exists 库名;
```

#### 库的修改

> 一般不使用，容易导致严重问题

```mysql
rename database 旧库名 to 新库名;
```

> 这条语句已经不能使用了，因为会导致数据丢失，了解即可

> 可以更改的内容一般是字符集

```mysql
alter database 库名 character set 字符集;
```

#### 库的删除

```mysql
drop database 库名;

drop database if exists 库名;
```



### 表的管理

#### 表的创建

```mysql
create table 表名(
	列名 类型[(长度) 约束]
         ....
)
```

```mysql
create table book(
    id int,
    bName varchar(20),
    price double,
    authorId int,
    publishDate DATETIME
);

create table author(
    id int,
    au_name varchar(20),
    nation varchar(10)
);
```

#### 表的修改

##### 修改列名

```mysql
alter table book
change column publishDate pubDate datetime;
```

##### 修改类型

```mysql
alter table book
modify column pubDate timestamp;
```

##### 添加列

```mysql
alter table author
add column annual double;
```

##### 删除列

```mysql
alter table author
drop column annual;
```

##### 修改表名

```mysql
alter table author
rename to book_author;
```

#### 表的删除

```mysql
drop table book_author;

drop table if exists book_author;
```

#### 表的复制

```mysql
create table copy like author;
```

> 仅复制表的结构

```mysql
create table copy2
select * from author;
```

> 连同数据一起复制

```mysql
create table copy3
select id,au_name
from author
where nation = '中国';
```

> 仅复制部分数据

```mysql
create table copy4
select id,au_name
from author
where 0;
```

> 仅复制部分列的结构



### 练习

> test_lesson11 创建和管理表



### 数据类型

> 常见数据类型
>
> 数值型：整形，小数（定点数，浮点数）
>
> 字符型：较短的（char，varchar），较长的（text，blob（二进制数据））
>
> 日期型

#### 整形

|   类型    | 字节 |
| :-------: | :--: |
|  Tinyint  |  1   |
| Smallint  |  2   |
| Mediumint |  3   |
|    int    |  4   |
|  bigint   |  8   |

> * 整形分为有符号和无符号
>
> * 默认是有符号
>
> * 如果要使用无符号需要添加关键字 int unsigned
>
> * 如果插入的值超过范围，会报异常，插入的值是临界值
>
> * 如果不设置长度，会有默认的长度
>
> * 整形长度决定了显示该列时的宽度
> * 字段后加入zerofill，会用0占位占满设定宽度为止，此操作会自动将其变为无符号

#### 小数

| 浮点数类型 | 字节 |
| :--------: | :--: |
|   float    |  4   |
|   double   |  8   |

|          定点数类型          | 字节 |                           范围                            |
| :--------------------------: | :--: | :-------------------------------------------------------: |
| DEC（M，D）（DECIMAL（M，D）） | M+2  | 最大取值范围与double相同，给定decimal的有效范围由M和D决定 |

> * M和D可以省略，D表示小数点后几位，M表示整数+小数一共多少位
> * 浮点数也可以设置M和D
> * 浮点数省略MD，会根据插入的值决定精度
> * 定点数省略MD，M默认为0，D为0
> * 如果对精度要求较高则使用定点数

#### 字符型

| 字符串类型 | 最多字符数 |        描述        |
| :--------: | :--------: | :----------------: |
|  char(M)   |     M      |  M为0-255之间整数  |
| varchar(M) |     M      | M为0-65535之间整数 |

> char是定长的，如果只插入1个字符，也会占用指定长度
>
> varchar是根据插入的数据决定长度，最大长度是设定长度
>
> char的执行效率比varchar高
>
> char的M可以省略，默认为1
>
> varchar的M不可省略

#### 日期类型

|   类型    | 字节 |       最小值        |       最大值        |
| :-------: | :--: | :-----------------: | :-----------------: |
|   date    |  4   |     1000-01-01      |     9999-12-31      |
| datetime  |  8   | 1000-01-01 00:00:00 | 9999-12-31 23:59:59 |
| timestamp |  4   |   1970010 080001    |   2038年某个时刻    |
|   time    |  3   |     -838:59:59      |      838:59:59      |
|   year    |  1   |        1901         |        2155         |

> timestamp和实际时区有关，更能反应实际的日期
>
> datetime只能反映出插入时的当地时区
>
> timestamp的属性受MySQL版本和SQLMode影响

#### 其他类型

> bit(M) ：范围bit(1)-bit(8)
>
> binary  varbinary：类似于char和varchar，他们保存的是二进制字符串
>
> ENUM：枚举类型，要求插入的值，必须是列表中指定的值之一
>
> Set：和ENUM类似，set可以一次选取多个成员，ENUM只可选择一个



### 常见约束

> 一种限制，用于限制表中的数据，为了保证表中的数据的准确性和可靠性

> 分类：
>
> `NOT NULL`：非空
>
> `DEFAULT`：该字段有默认值
>
> `PRIMARY KEY`：主键
>
> `UNIQUE`：唯一，可以为空
>
> `CHECK`：检查约束，MySQL中不支持
>
> `FOREIGN KEY`：外键，用于限制两个表的关系，保证该字段的值必须来自于主表关联列

> 六大约束，语法上都支持列级约束，但外键约束没有效果
>
> 除了非空，默认。其他的约束都可以写在表级约束

#### 列级约束

```mysql
create table stuinfo(
    id int primary key ,
    stuName varchar(20) not null ,
    gender char(1) check ( gender='男' or gender='女' ),
    seat int unique ,
    age int default 18,
    majorId int references major(id)#只是语法不报错，但没有作用
);
```

#### 表级约束

```mysql
create table stuinfo(
    id int,
    stuName varchar(20),
    gender char(1),
    seat int,
    age int,
    majorId int,

    constraint pk primary key (id),
    constraint uq unique (seat),
    constraint ck check ( gender='男' or gender='女' ),
    constraint fk_stuinfo_major foreign key (majorId) references major(id)
);

#constraint 别名  可以省略
create table stuinfo(
    id int,
    stuName varchar(20),
    gender char(1),
    seat int,
    age int,
    majorId int,

    primary key (id),
    unique (seat),
    check ( gender='男' or gender='女' ),
    foreign key (majorId) references major(id)
);
```

> 常用格式，只把外键写在表级，起好别名

```mysql
create table stuinfo(
    id int primary key ,
    stuName varchar(20) not null ,
    gender char(1),
    seat int unique ,
    age int default 18,
    majorId int,
    constraint fk_stuinfo_major foreign key (majorId) references major(id)
);
```

#### 主键和唯一的区别

|      | 保证唯一性 | 是否允许为空 | 一个表可以有多少个 | 是否允许组合 |
| :--: | :--------: | :----------: | :----------------: | :----------: |
| 主键 |     √      |      ×       |      至多1个       | √，但不推荐  |
| 唯一 |     √      |      √       |      可以多个      | √，但不推荐  |

#### 外键的特点

> 1. 在从表设置外键关系
> 2. 从表外键列的类型和主表关联列需要兼容
> 3. 主表中的关联列必须是key（主键、唯一键）
> 4. 插入数据时，先插入主表，再插入从表。删除数据时，先删除从表，再删除主表

#### 修改表时添加约束

```mysql
alter table stuinfo
modify column stuName varchar(20) not null ;

alter table stuinfo
modify column age int default 18;

#列级约束写法
alter table stuinfo
modify column id int primary key ;
#表级约束写法
alter table stuinfo
add primary key (id);
```

#### 修改表时删除约束

```mysql
alter table stuinfo
modify column stuName varchar(20);

alter table stuinfo
modify column age int;

#因为表中只有1个主键，所以可以直接用drop
alter table stuinfo
drop primary key ;
```

#### 标识列（自增列）

```mysql
create table tab_identity(
    id int primary key auto_increment,
    name varchar(20)
);
```

```mysql
show variables like '%auto_increment%';

#auto_increment_increment	1
#auto_increment_offset	1
```

> increment：代表步长
>
> offset：代表偏移
>
> MySQL中不支持设置偏移，只可以设置步长

```mysql
set auto_increment_increment = 3;
```

> 标识列特点：
>
> 1. 标识列必须与key绑定
> 2. 一个表中只可以有一个标识列
> 3. 标识列的类型只能是数值型

```mysql
#标识列也可以在修改时添加
alter table tab_identity
modify column id int primary key auto_increment;
```

#### 练习

> test_lesson12 约束



## TCL语言学习

> 事务控制语言
>
> 事务：一组sql语句组成一个执行单元，这个执行单元要么全部执行，要么全部不执行

### 经典转账问题

> A有1000元
>
> B有1000元

```mysql
update 表 set A余额 = 500 where name = ‘A’；
意外
update 表 set B余额 = 1500 where name = ‘B’；
```

> 整个执行单元应该是一个不可分割的整体，如果单元中某出现意外，则整个单元回滚



### 支持事务引擎

```mysql
show engines;
```

> INNODB支持事务
>
> MYISAM、MEMORY等不支持事务



### 事务的ACID

> **Atomicity：原子性**是指事务是一个不可分割的工作单位，要么都发生，要么都不发生
>
> **Consistency：一致性**，事务必须使数据库从一个一致状态变换到另一个一致状态（转账前后，余额总量一致）
>
> **Atomicity：隔离性**是指一个事物的执行不能被其他事务干扰，一个事务内部的操作及使用的数据对并发的其他事务是隔离的
>
> **Atomicity：持久性**是指一个事物一旦被提交，它的改变是永久性的，接下来的操作或故障，不应对其有影响



### 事务的使用

> 隐式事务：事务没有明显的开启或结束标记，比如insert，update，delete语句
>
> 显式事务：事务具有明显的开启或结束标记

> autocommit，默认提交，默认是开启的
>
> 如果要开启显式事务，autocommit需要设置为禁用
>
> 语句完成后需要手动提交或回滚，使用commit rollback



### 隔离级别

> 对于同时运行的多个事务，这些事务访问数据库中相同数据时
>
> 如果没有隔离机制，就会出现各种问题（类似Java中线程隔离）

> **脏读：**
>
> 对于两个事物T1，T2
>
> T1读取了已经被T2更新但没有提交的字段
>
> 如果T2回滚，T1读取到的内容就是临时且无效的

> **不可重复读：**
>
> 对于两个事物T1，T2
>
> T1读取了一个字段
>
> T2更新了该字段
>
> T1又读取了一次
>
> T1前后两次读取到的结果不一致

> **幻读：**
>
> 对于两个事物T1，T2
>
> T1读取了一个字段
>
> T2插入了一些数据
>
> T1又读取了一次
>
> T1前后两次读取到的结果不一致

> 我们可以通过设置隔离级别，避免上述问题

|           隔离级别           |                             描述                             |
| :--------------------------: | :----------------------------------------------------------: |
| READ UNCOMMITTED（读未提交） | 允许事务读取，未被其他事务提交的变更。脏读、不可重复读、幻读都会出现 |
|  READ COMMITTED（读已提交）  | 只允许事务读取已经被其他事务提交的变更，可以避免脏读，但不可重复读、幻读仍然会出现 |
| REPEATABLE READ（可重复读）  | 确保事务可以多次从一个字段中读取相同的值，这个事务持续期间，禁止其他事务对这个字段进行更新。可以避免脏读和不可重复读，但幻读仍然存在 |
|   SERIALIZABLE （串行化）    | 串行化，在事务持续期间，禁止其他事务操作，所有并发问题都会解决，但效率非常低下 |

> 数据库提供了四种隔离级别
>
> Oracle支持：READ COMMITTED和SERIALIZABLE，默认为READ COMMITTED
>
> MySQL支持四种隔离级别：默认为REPEATABLE READ

```mysql
#查看当前隔离级别
select @@tx_isolation;
#更改当前会话隔离级别为read uncommitted
set session transaction isolation level read uncommitted ;
```

> 为了演示各个事物间出现的问题，可以使用多个console来同时执行，模拟脏读、不可重复读、幻读
>
> 就不在这演示了



### 回滚点

```mysql
set autocommit=0;
delete from textTx where id = 2;
savepoint a;
delete from textTx where id = 3;
rollback to a;
```

> 可以不全部回滚，只回滚到回滚点

### 练习

> test_lesson13 事务



## 视图

> 视图是一种虚拟表，可以和表一样的使用
>
> 是MySQL 5.0版本后出现的新特性
>
> 是通过动态生成的数据

> 注意
>
> 视图中，并不是保存了数据
>
> 而是保存了SQL逻辑

```mysql
select stuName,majorName
from stuinfo s
join major m on m.id = s.majorId
where stuName like '张%';
```

> 在以前我们查询姓张同学的姓名和专业名，需要这样做

```mysql
create view v1
as
select stuName,majorName
from stuinfo s
join major m on m.id = s.majorId;

select * from v1 where stuName like '张%';
```

### 创建视图

```mysql
create view 视图名
as
查询语句
```
> 查询姓名中包含a的员工名，部门名和工种名

```mysql
create view myv1
as
    select last_name,department_name,job_title
    from employees e
    join departments d on d.department_id = e.department_id
    join jobs j on j.job_id = e.job_id;

select * from myv1
where last_name like '%a%';
```

> 查询各部门平均工资级别

```mysql
create view myv2
as
select avg(salary),department_id
from employees
group by department_id;

select myv2.ag,grade_level
from myv2
join job_grades j
on myv2.ag between j.lowest_sal and j.highest_sal;
```

> 查询平均工资最低的部门信息

```mysql
select * from myv2
order by ag
limit 1;
```

> 查询平均工资最低的部门名和工资

```mysql
create view myv3
as
select * from myv2
order by ag
limit 1;

select d.*,m.ag
from myv3 m
join departments d on m.department_id = d.department_id;
```

### 视图的修改

```mysql
create or replace view 视图名
as
查询语句;
```

```mysql
create or replace view myv3
as
select avg(salary),job_id
from employees
group by job_id;
```

> 也可以这样写

```mysql
alter view myv3
as
select avg(salary),job_id
from employees
group by job_id;
```

### 视图的删除

```mysql
drop view 视图名，视图名，.....；
```

### 视图的查看

```mysql
show create view myv3;
```

### 视图的更新

```mysql
create or replace view myv1
as
select last_name,email
from employees;

insert into myv1
values ('张飞','zhangfei@qq.com');

update myv1
set last_name = '张无忌'
where last_name = '张飞';

delete from myv1
where last_name = '张无忌';
```

> 视图的更新也会导致原始表数据的更新
>
> 为视图添加只读，可以解决这个问题
>
> 但我们一般也不会这样做

> 具备以下特点的视图是不允许更新的
>
> 1. 包含以下关键词
>
>    分组函数、distinct、group by、having、union或union all
>    
> 1. 常量视图
>
> 1. select中包含子查询
>
> 1. join
>
> 1. from一个不能更新的视图
>
> 1. where子句的子查询引用了from子句中的表

### 练习

> test_lesson14 视图



## 变量

> 系统变量：
>
> * 全局变量
> * 会话变量
>
> 自定义变量：
>
> * 用户变量
> * 局部变量

### 系统变量

#### 查看系统变量

```mysql
show global variables;
show session variables;
```

> 如果不写global或session则默认是session

```mysql
show variables like '%character%';
```

> 查看部分系统变量

```mysql
select @@tx_isolation;
select @@global.tx_isolation;
```

> 查看指定系统变量
>
> 不写作用域，默认session

#### 为系统变量赋值

```mysql
set autocommit = 0;
set global autocommit = 0;

set @@global.tx_isolation = ;
set @@tx_isolation = ;
```

> 服务器每次启动，将为所有全局变量赋初始值



### 自定义变量

```mysql
set @name='john';
set @name=100;
set @count=1;

select count(*) into @count
from employees;

select @count;
```

> 为了避免歧义，赋值符 “ = ” 也可以写为  “ := ” 

```mysql
set @m = 1;
set @n = 2;
set @sum = @m + @n;
select @sum;
```

#### 局部变量

> 作用域仅仅在它的begin end中有效

```mysql
declare m int default 1;
declare n int default 2;
declare sum int;
set sum = m + n;
select sum;
```

> 直接这样写会报错，因为它不在begin end中



## 存储过程

> 类似于Java中的Method
>
> 一组预先编译好的SQL语句的集合

### 创建

```mysql
create procedure 储存过程名(参数列表)
begin
	存储过程体
end
```

> 注意
>
> * 如果存储过程体仅有一句话，begin end可以省略
>
> * 参数列表包含三部分
>
>   参数模式	参数名	参数类型
>
> * 存储过程体中的每条SQL语句必须加分号，存储过程的结尾用delimiter重新设置

```mysql
delimiter $
```

```mysql
in stuname varchar(20)
```

> 参数模式
>
> `in`：该参数可以作为输入，相当于Java中的传统参数
>
> `out`：该参数可以作为输出，相当于返回值
>
> `inout`：该参数既可以作为输入，又可以作为输出

### 调用

```mysql
call 存储过程名(实参列表);
```

### 空参列表

> 插入到admin表中5条记录

```mysql
delimiter $
create procedure myp1()
begin
    insert into admin
    values (null,'john1',000),(null,'lily',0000),(null,'rose',0000),(null,'jack',0000),(null,'tom',0000);
end $

call myp1();
```

### in模式

> 根据女神名查询对应男神信息

```mysql
create procedure myp2(in beautyName varchar(20))
begin
    select bo.*
    from boys bo
    right join beauty b
    on b.boyfriend_id = bo.id
    where b.name = beautyName;
end $

call myp2('唐艺昕');
```

> 用户是否登陆成功

```mysql
create procedure myp3(in username varchar(20),in password varchar(10))
begin
    declare result int default 0;

    select count(*) into result
    from admin
    where admin.username = username and admin.password = password;

    select if(result>0,'成功','失败');
end $

call myp3('john',8888);
```

### out模式

> 根据女神名返回男神名

```mysql
create procedure myp5(in beautyName varchar(20),out boyName varchar(20))
begin
    select bo.boyName into boyName
    from boys bo
    inner join beauty b
    on b.boyfriend_id = bo.id
    where b.name = beautyName;
end $

call myp5('唐艺昕',@bName);
select @bName;
```

> 根据女神名返回男神名和男神魅力值

```mysql
create procedure myp6(in beautyName varchar(20),out boyName varchar(20),out boyCP int)
begin
    select bo.boyName , bo.userCP into boyName,boyCP
    from boys bo
    inner join beauty b
    on b.boyfriend_id = bo.id
    where b.name = beautyName;
end $

call myp6('唐艺昕',@bname,@bCP);
select @bName,@bCP;
```

### inout模式

> 传入a和b两个值，a和b翻倍后返回

```mysql
create procedure myp7(inout a int,inout b int)
begin
    set a = a * 2;
    set b = b * 2;
end $

set @a = 2;
set @b = 4;
call myp7(@a,@b);
select @a,@b;
```

### 存储过程删除

```mysql
drop procedure myp7;
```

### 存储过程查看

```mysql
show create procedure myp7;
```

### 练习

> test_lesson16 存储过程



## 函数

> 函数与存储过程类似
>
> 区别在于：
>
> 存储过程可以有0个返回，也可以有多个返回
>
> 函数只能有1个返回

> 存储过程适合做批量插入，批量更新
>
> 函数适合做数据处理后返回一个结果

### 函数创建

```mysql
create function 函数名(参数列表) returns 返回类型
begin
	函数体
end
```

> 参数列表包含两部分
>
> 参数名	参数类型
>
> 函数体中有return 语句

> 注意
>
> 在存储过程和函数中设定结束符号
>
> delimiter $
>
> 和下方的区别
>
> delimiter $;
>
> 如果这样，会表示
>
> $;两个字符共同表示结束

### 函数调用

```mysql
select 函数名(参数列表)
```

### 无参有返回

> 返回公司的员工个数

```mysql
create function myf1() returns int
begin
    declare c int default 0;
    select count(*) into c
    from employees;
    return c;
end $

select myf1();
```

### 有参有返回

> 根据员工名，返回工资

```mysql
create function myf2(empName varchar(20)) returns double
begin
    set @sal = 0;
    select salary into @sal
    from employees
    where last_name = empName;
    return @sal;
end $

select myf2('Kochhar');
```

> 根据部门名，返回该部门的平均工资

```mysql
create function myf3(deptName varchar(20)) returns double
begin
    declare sal double;
    select avg(salary) into sal
    from employees e
    join departments d
    on d.department_id = e.department_id
    where department_name = deptName;
    return sal;
end $

select myf3('IT');
```

### 查看函数

```mysql
show create function myf3;
```

### 删除函数

```mysql
drop function myf3;
```

### 练习

> test_lesson17 函数



## 流程控制结构

### 分支结构

#### if函数

```mysql
select if(表达式1,表达式2,表达式3)
```

> 如果表达式1城里，则返回表达式2，否则返回表达式3

#### case结构

> 类似于switch语句

> 这两个在单行函数中提过

#### if结构

```mysql
if 条件1 then 语句1;
elseif 条件2 then 语句2;
...
else 语句n
end if;
```

> 只能运用在begin end中

> 根据传入的成绩，来显示等级
>
> 90-100	A
>
> 80-90	B
>
> 60-80	C
>
> 其他	D

```mysql
create function test_if(score int) returns char
begin
    if score >= 90 and score <= 100 then return 'A';
    elseif score >= 80 then return 'B';
    elseif score >= 60 then return 'C';
    else return 'D';
    end if;
end $

select test_if(75);
```

### 循环结构

> 分类：
>
> `while`、`loop`、`repeat`
>
> 循环控制：
>
> `iterate`：类似于continue
>
> `leave`：类似于break

#### while

```mysql
[标签:] while 循环条件 do
	循环体
end while [标签]
```

#### loop

```mysql
[标签:] loop
	循环体
end loop [标签]
```

#### repeat

```mysql
[标签:] repeat
	循环体
until 结束循环的条件
end repeat [标签]
```

#### 案例

> 根据传入次数，批量插入admin表

```mysql
create procedure pro_while1(in insertCount int)
begin
    declare i int default 1;
    while i<=insertCount do
        insert into admin(username, password)
        values (concat('rose',i),'666');
        set i = i + 1;
        end while;
end $

call pro_while1(100);
```

> 根据传入次数，批量插入admin表，如果次数>20则停止

```mysql
create procedure pro_while1(in insertCount int)
begin
    declare i int default 1;
    a:while i<=insertCount do
        insert into admin(username, password)
        values (concat('rose',i),'666');
        if i >= 20 then leave a;
        end if;
        set i = i + 1;
        end while a;
end $

call pro_while1(100);
```

> 根据传入次数，批量插入admin表，只插入偶数次

```mysql
create procedure pro_while1(in insertCount int)
begin
    declare i int default 1;
    a:while i<=insertCount do
        set i = i + 1;
        if mod(i,2) != 0 then iterate a;
        end if;
        insert into admin(username, password)
        values (concat('rose',i),'666');
        end while a;
end $

call pro_while1(100);
```

### 练习

> test_lesson18 流程控制结构

