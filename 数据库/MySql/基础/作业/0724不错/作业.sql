--1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数 
select s1.sname,s1.score as score01,s2.score as score02 from (
  select sname,c.score
  from student s
  join sc c on c.sno = s.sno
  where c.cno = 01
) s1
left join (
  select sname,c.score
  from student s
  join sc c on c.sno = s.sno
  where c.cno = 02
) s2
on s1.sname = s2.sname
where s1.score > s2.score;

--2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数 
select s1.sname,s1.score as score01,s2.score as score02 from (
  select sname,c.score
  from student s
  join sc c on c.sno = s.sno
  where c.cno = 01
) s1
left join (
  select sname,c.score
  from student s
  join sc c on c.sno = s.sno
  where c.cno = 02
) s2
on s1.sname = s2.sname
where s1.score < s2.score;

--3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩 
select avg(score) avg_score,sc.sno,sname
from sc
join student s
on s.sno = sc.sno
group by sc.sno,sname
having avg(score) > 60;

--4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩 
select avg(score) avg_score,sc.sno,sname
from sc
join student s
on s.sno = sc.sno
group by sc.sno,sname
having avg(score) < 60;

--5、查询在sc表中不存在成绩的学生信息的SQL语句
select s.sno,sname,sage,ssex
from student s
left join sc
on sc.sno = s.sno
where sc.sno is null;

--6、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩
select s.sno,sname,count(cno),sum(score)
from student s
left join sc
on s.sno = sc.sno
group by s.sno,sname;


--7、查询"李"姓老师的数量
select count(*)
from teacher
where tname like '李%';

--8、查询学过"张三"老师授课的同学的信息
select s.sno,s.sname
from student s
join sc on sc.sno = s.sno
join course co on co.cno = sc.cno
join teacher t on t.tno = co.tno
where t.tname = '张三';

--9、查询没学过"张三"老师授课的同学的信息
select sno,sname
from student
where sno not in (
select sno
from sc
where cno = (
  select co.cno
    from course co
    join teacher t on t.tno = co.tno
    where t.tname = '张三'
  )
);


--10、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息
select sname
from student
where sno in(
  select sno
  from sc
  where cno = 01
) and sno in(
  select sno
  from sc
  where cno = 02
);

--11、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息 
select sname
from student
where sno in(
  select sno
  from sc
  where cno = 01
) and sno not in(
  select sno
  from sc
  where cno = 02
);

--12、查询没有学全所有课程的同学的信息
select sname
from student
where sno in (
  select sno
  from sc
  group by sno
  having count(cno) <> (
        select count(cno) from course
  )
);

--13、查询至少有一门课与学号为"01"的同学所学相同的同学的信息
select sname
from student
where sno in (
  select distinct sno
  from sc
  where cno in (
    select cno
    from sc
    where sno = 1
  )
);

--14、查询和"01"号的同学学习的课程完全相同的其他同学的信息
select sname
from student
where sno in (
  select distinct sno
  from sc
  where sno <> 01
  and cno in (
    select distinct cno
    from sc
    where sno = 01
  )
  group by sno
  having count(cno) = (
    select count(*)
    from sc
    where sno = 01
  )
);

--15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select t1.sno,t1.sname,avg(score)
from (
  select sno,sname
  from student
  where sno in(
    select sno
    from sc
    where score < 60
    group by sno
    having count(score)>= 2
  )
)t1
join sc on t1.sno = sc.sno
group by t1.sno,t1.sname;

--16、检索"01"课程分数小于60，按分数降序排列的学生信息
select score,s.sno,s.sname
from sc
join student s on s.sno = sc.sno
where cno = 01 and score < 60
order by score desc;

--17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
select sc.score,t2.ag,t2.sno
from sc
join (
  select avg(score) ag,sno
  from sc
  group by sno
)t2 on t2.sno = sc.sno
order by sc.score desc;

--19、查询每门课程被选修的学生数
select count(sno)
from sc
group by cno;

--20、查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
select avg(score)
from sc
group by cno
order by avg(score),cno asc;

--21、查询每个学员的每科成绩，显示结果如下
--学号  语文   数学   英语
--01       98     88       77 
select s1.sno 学号 ,s1.score as 语文,s2.score as 数学,s3.score 英语 from (
  select s.sno,c.score
  from student s
  join sc c on c.sno = s.sno
  where c.cno = 01
) s1
left join (
  select s.sno,c.score
  from student s
  join sc c on c.sno = s.sno
  where c.cno = 02
) s2
on s1.sno = s2.sno
left join (
  select s.sno,c.score
  from student s
  join sc c on c.sno = s.sno
  where c.cno = 03
) s3
on s1.sno = s3.sno;


--18、查询各科成绩前三名的记录，显示结果如下
--          第一名    第二名    第三名
--语文     张三       李四       王五
--数学
--英语



------------------------------------如果不要求格式----------------------------------------
select sc.*
from sc
where (
      select count(*)
      from sc s2
      where s2.cno = sc.cno and s2.score > sc.score
) < 3
order by sc.cno,sc.score;

------------------------------------要求格式----------------------------------------
select subject as 科目,first as 第一名,second as 第二名,third as 第三名
from(
  select '语文' as subject,s1.first,s2.second,s3.third
  from(
    -- 筛选出语文第一
    select t2.sname as first,t2.cno
    from(
      select t1.sname,t1.score,rownum rn,t1.cno
      from(
      -- 查询前三，同分拼接
        select wm_concat(s.sname) sname,sc.score,co.cno
        from sc
        join course co on co.cno = sc.cno
        join student s on s.sno = sc.sno
        where co.cname = '语文'
        group by sc.score,co.cno
        order by sc.score desc
      )t1
      where rownum <= 3
    )t2
    where rn between 1 and 1
  )s1
  left join (
    -- 筛选出语文第二
    select t2.sname as second,t2.cno
    from(
      select t1.sname,t1.score,rownum rn,t1.cno
      from(
      -- 查询前三，同分拼接
        select wm_concat(s.sname) sname,sc.score,co.cno
        from sc
        join course co on co.cno = sc.cno
        join student s on s.sno = sc.sno
        where co.cname = '语文'
        group by sc.score,co.cno
        order by sc.score desc
      )t1
      where rownum <= 3
    )t2
    where rn between 2 and 2
  )s2 on s1.cno = s2.cno
  left join (
    -- 筛选出语文第三
    select t2.sname as third,t2.cno
    from(
      select t1.sname,t1.score,rownum rn,t1.cno
      from(
      -- 查询前三，同分拼接
        select wm_concat(s.sname) sname,sc.score,co.cno
        from sc
        join course co on co.cno = sc.cno
        join student s on s.sno = sc.sno
        where co.cname = '语文'
        group by sc.score,co.cno
        order by sc.score desc
      )t1
      where rownum <= 3
    )t2
    where rn between 3 and 3
  )s3 on s1.cno = s3.cno
)a1
union all
select subject as 科目,first as 第一名,second as 第二名,third as 第三名
from(
  select '数学' as subject,s1.first,s2.second,s3.third
  from(
    -- 筛选出数学第一
    select t2.sname as first,t2.cno
    from(
      select t1.sname,t1.score,rownum rn,t1.cno
      from(
      -- 查询前三，同分拼接
        select wm_concat(s.sname) sname,sc.score,co.cno
        from sc
        join course co on co.cno = sc.cno
        join student s on s.sno = sc.sno
        where co.cname = '数学'
        group by sc.score,co.cno
        order by sc.score desc
      )t1
      where rownum <= 3
    )t2
    where rn between 1 and 1
  )s1
  left join (
    -- 筛选出数学第二
    select t2.sname as second,t2.cno
    from(
      select t1.sname,t1.score,rownum rn,t1.cno
      from(
      -- 查询前三，同分拼接
        select wm_concat(s.sname) sname,sc.score,co.cno
        from sc
        join course co on co.cno = sc.cno
        join student s on s.sno = sc.sno
        where co.cname = '数学'
        group by sc.score,co.cno
        order by sc.score desc
      )t1
      where rownum <= 3
    )t2
    where rn between 2 and 2
  )s2 on s1.cno = s2.cno
  left join (
    -- 筛选出数学第三
    select t2.sname as third,t2.cno
    from(
      select t1.sname,t1.score,rownum rn,t1.cno
      from(
      -- 查询前三，同分拼接
        select wm_concat(s.sname) sname,sc.score,co.cno
        from sc
        join course co on co.cno = sc.cno
        join student s on s.sno = sc.sno
        where co.cname = '数学'
        group by sc.score,co.cno
        order by sc.score desc
      )t1
      where rownum <= 3
    )t2
    where rn between 3 and 3
  )s3 on s1.cno = s3.cno
)a1
union all
select subject as 科目,first as 第一名,second as 第二名,third as 第三名
from(
  select '英语' as subject,s1.first,s2.second,s3.third
  from(
    -- 筛选出英语第一
    select t2.sname as first,t2.cno
    from(
      select t1.sname,t1.score,rownum rn,t1.cno
      from(
      -- 查询前三，同分拼接
        select wm_concat(s.sname) sname,sc.score,co.cno
        from sc
        join course co on co.cno = sc.cno
        join student s on s.sno = sc.sno
        where co.cname = '英语'
        group by sc.score,co.cno
        order by sc.score desc
      )t1
      where rownum <= 3
    )t2
    where rn between 1 and 1
  )s1
  left join (
    -- 筛选出英语第二
    select t2.sname as second,t2.cno
    from(
      select t1.sname,t1.score,rownum rn,t1.cno
      from(
      -- 查询前三，同分拼接
        select wm_concat(s.sname) sname,sc.score,co.cno
        from sc
        join course co on co.cno = sc.cno
        join student s on s.sno = sc.sno
        where co.cname = '英语'
        group by sc.score,co.cno
        order by sc.score desc
      )t1
      where rownum <= 3
    )t2
    where rn between 2 and 2
  )s2 on s1.cno = s2.cno
  left join (
    -- 筛选出英语第三
    select t2.sname as third,t2.cno
    from(
      select t1.sname,t1.score,rownum rn,t1.cno
      from(
      -- 查询前三，同分拼接
        select wm_concat(s.sname) sname,sc.score,co.cno
        from sc
        join course co on co.cno = sc.cno
        join student s on s.sno = sc.sno
        where co.cname = '英语'
        group by sc.score,co.cno
        order by sc.score desc
      )t1
      where rownum <= 3
    )t2
    where rn between 3 and 3
  )s3 on s1.cno = s3.cno
)a1;