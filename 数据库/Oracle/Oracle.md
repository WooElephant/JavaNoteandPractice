# Oracle

> Oracle大体上语法与MySQL一样，这里仅记录区别的地方

## 拼串

> 列与列，列与字符使用 || 连接
>
> Oracle的concat只能拼接两个值，而 || 没有限制



## 别名

> 别名要么不写引号，要么要使用双引号，而不是单引号

## 日期与字符串转化

> to_char(Date,'yyyy-mm-dd')
>
> to_date('2000-05-05','yyyy-mm-dd')



## ifnull

> 在Oracle中
>
> nvl（列，值）：如果列为空，则替换为值
>
> nvl2（列，值1，值2）：如果列为空，则替换为值2，如果不为空，则替换为值1
>
> coalesce（值1，值2，值3...）：依次判断，不为空则返回



## 数据类型

> varchar  --->   varchar2
>
> 数字   --->   number（x，y）相当于DEC（x，y）



## 自增

> 使用Sequence，除了名称别的都可以不填，默认是从0，步长1，自增

```sql
create sequence 名称
increment by 1  --步长
start with 0  --起始值
maxvalue 100  --最大值
cycle  --需要循环
nocache  --不需要缓存
```

> 使用 sequence名称.nextval取下一个值，每调用一次会自增
>
> 使用 sequence名称.currval取上次值



## PL/SQL

```plsql
declare
声明
begin
执行部分
exception
异常部分
end;
```



### Hello World

```plsql
begin
	dbms_output.put_line('Hello world');
end;
```



### 变量命名规则

|      标识符       |    命名规则     |       例        |
| :---------------: | :-------------: | :-------------: |
|     程序变量      |     V_name      |     v_name      |
|     程序常量      |     C_name      |     C_name      |
|     游标变量      |   name_cursor   |   Emp_cursor    |
|     异常标识      |     E_name      |   E_too_many    |
|      表类型       | name_table_type | Emp_record_type |
|        表         |   name_table    |       Emp       |
|     记录类型      |   name_record   |   Emp_record    |
| SQL*Plus 替代变量 |     P_name      |     P_name      |
|     绑定变量      |     G_name      |     G_name      |

```plsql
declare
	--v_sal varchar(20);
	v_sal employee.salary%type;
begin
	select salary into v_sal from employee where employee = 100;
	dbms_output.put_line(v_sal);
end;
```

> v_sal employee.salary%type;
>
> 表示v_sal的类型是动态的，是employee表中salary字段的类型



### 记录类型

```plsql
declare
	type emp_record is record(
		v_sal employee.salary%type,
		v_email employee.email%type,
		v_hire_date employee.hire_date%type
  	  );
	v_emp_record emp_record;
begin
	select salary,email,hire_date into v_emp_record from employee where employee = 100;
	dbms_output.put_line(v_emp_record.v_sal || ','  || v_emp_record.v_email || ','  || v_emp_record.v_hire_date );
end;
```

> 比较像是Java中的类



### 变量赋值

```plsql
declare
	v_sal number(8,2) := 0;
```

> := 是赋值运算符



### if

```plsql
if 表达式1 then
	语句;
elsif 表达式2 then
	语句;
elsif 表达式3 then
	语句;
else
	语句;
end if;
```



### case

```plsql
case 值
	when 表达式1 then 结果1
	when 表达式2 then 结果2
	when 表达式3 then 结果3
	else 结果n
end;
```



### loop

```plsql
loop
	语句;
	exit when 条件;
end loop;
```



### while

```plsql
while 表达式 loop
	语句;
end loop;
```



### for

```plsql
for 计数器 in [REVERSE] 起始...结束 loop
	语句;
end loop;
```

> 变量会自增（自减）



### 游标

> 类似于Iterator

```plsql
declare
	cursor salary_cursor is select salary from employee where department_id = 80;
	v_salary employee.salary%type;
begin
	open salary_cursor;
	fetch salary_cursor into v_salary;
	while salary_cursor%found loop
		dbms_output.putline('salary: ' || v_salary);
		fetch salary_cursor into v_salary;
	end loop;
	close salary_cursor;
end;
```



### 存储过程

```plsql
create or replace function add_param(v_num1 number, v_num2 number )
return number
is
	--定义局部参数
	v_sum number(10);
begin
	v_sum := v_num1 + v_num2;
	return v_sum;
end;
```



### 触发器

```plsql
create or replace trigger update_emp_trigger
after
	update on employee
for each row;
begin
	dbms_output.put_line('1');
end;
```

