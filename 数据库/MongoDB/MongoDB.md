# MongoDB

> MongoDB是非关系型数据库

> MongoDB是为快速开发互联网Web应用而设计的
>
> MongoDB设计目标是极简、灵活、作为Web应用栈的一部分
>
> MongoDB的数据模型是面向文档的，简单来说，MongoDB存的是Json

> MongoDB偶数版本为稳定版，奇数版本为开发版



## 安装

> 1. 傻瓜安装
> 2. 安装完成之后要将其bin目录添加到环境变量path中
> 3. 在c盘根目录创建文件夹data
> 4. 在data中创建一个文件夹db，这个目录是数据库默认的路径
> 5. 再创建一个文件夹log，用来保存日志
> 6. 在cmd中输入mongod，开启数据库服务

> 再打开一个命令行，输入mongo，即可连接

> 在MongoDB的版本号目录中，创建mongod.cfg

```yaml
systemLog:
    destination: file
    path: c:\data\log\mongod.log
storage:
    dbPath: c:\data\db
```

> 填写这些内容

> 打开cmd窗口
>
> sc.exe create MongoDB binPath= "\"C:\Program Files\MongoDB\Server\3.4\bin\mongod.exe\" --service --config=\"C:\Program Files\MongoDB\Server\3.4\mongod.cfg\"" DisplayName= "MongoDB" start= "auto"
>
> 运行这个命令
>
> 则可以以服务的形式启动

> net start MongoDB	启动
>
> net stop MongoDB	停止
>
> sc.exe delete MongoDB	删除服务

> **每个版本都不太一样，推荐还是看官网手册，写的很详细**
>
> **4.0以上这些操作会变的很简单**



## 基本概念

> 数据库
>
> 数据库是一个仓库，在仓库中存放结合

> 集合
>
> 集合类似于数组，在集合中存放文档

> 文档
>
> 数据库中最小单位

> 在MongoDB中，数据库和集合不需要手动创建，当我们创建文档时，如果集合或数据库不存在会自动创建

## 基本操作

> **show dbs**	显示所有数据库
>
> **use 数据库名**	使用指定数据库
>
> **db**	显示当前所处数据库
>
> **show collections**	显示数据库中所有集合

## CRUD操作

### 增

```
db.stus.insertOne({name:"猪八戒",age:28,gender:"男"});
```

```
db.stus.insertMany([
    {name:"孙悟空",age:18,gender:"男"},
    {name:"沙和尚",age:38,gender:"男"},
    {name:"蜘蛛精",age:14,gender:"女"},
    {name:"白骨精",age:16,gender:"女"}
]);
```

> 当我们向集合中插入文档，如果没有指定\_id属性，则会自动添加_id

### 查

```
db.stus.find({});
db.stus.find({age:18});
db.stus.find({age:18,gender:"男"});

db.stus.find({gender:"男"})[2];
db.stus.findOne({gender:"男"}).name;
db.stus.findOne({gender:"男"});

db.stus.find({age:{$in:[18,14]}});

db.stus.find({gender:"女", age:{ $lte:15} });

db.stus.find( { gender:"女" , $or : [ {age: { $lt:15 } } , { name: /^白/}] } );

db.stus.find().count();
```

```sql
db.stus.find( { gender:"女" , $or : [ {age: { $lt:15 } } , { name: /^白/}] } );

表示

select * from stus
where gender = '女' and ( age < 15 or name like '白%');
```



### 改

```
db.stus.updateOne({name:"沙和尚"},{age:28});
```

> 默认情况下，会使用新对象替换旧对象

```
db.stus.updateOne({name:"沙和尚"},{$set:{age:28}});
```

> 使用$set:在之前，可以只替换掉对应的值

```
db.stus.updateOne({name:"沙和尚"},{$unset:{age:28}});
```

> $unset:只删除指定值

> 修改所有匹配项要使用updateMany

### 删

```
db.stus.deleteOne({name:"沙和尚"});
db.stus.deleteMany({gender:"男"});
```

```
db.stus.drop();

db.dropDatabase();
```



## 排序

```
db.stus.find({}).sort( { age: 1 } );
```

> 1表示升序，-1表示降序



## 投影

```
db.stus.find( {} , { name:1 } ).sort( { age:1 } );
```

> find第二个参数，可以指定选择某些字段，1代表显示，0代表不显示，默认也是不显示



## Mongoose

> Mongoose 是Node的一个模块，可以操作MongoDB

> Mongoose可以为文档创建约束

```sh
npm install mongoose --save
```

### 连接数据库

```
mongoose.connect("mongodb://localhost/mongoose_test" );

mongoose.connection.once("open",function (){
    console.log("数据库连接成功");
});

mongoose.disconnect();
```

> 如果端口号是默认，可以省略不写
>
> 关闭连接也可以不写，NoSQL没有事务

```
mongoose.connect("mongodb://localhost:1/mongoose_test", {useNewUrlParser: true, useUnifiedTopology: true}).then(() => console.log("数据库连接成功！"));
```

> 官方推荐的完整写法是这样

### 约束

```
var stuSchema = new Schema({
    name:String,
    age:Number,
    gender: {
        type:String,
        default:"female"
    },
    address:String
});
```

### Model

#### 创建

```
//通过Schema创建Model
//Model代表数据库中的集合，通过Model才能对数据库进行操作
var StuModel = mongoose.model("student",stuSchema);
```

> 第一个值是要映射的集合名，mongoose会自动将集合名变为复数
>
> 第二个值是约束

#### 操作

```
StuModel.create({ name:"孙悟空", age:18, gender:"male", address:"花果山" }).then(() => console.log("添加成功"));
```

> create为数据库中增加数据

#### 增

> create增加
>
> 第一个参数是内容，也可是是对象数组
>
> 第二个参数可选，回调函数

#### 查

> find查询
>
> findById
>
> findOne

```
StuModel.find({}).then(docs => console.log(docs));
```

```
StuModel.find({}, { name:1, _id:0 } ).then(docs => console.log(docs));
```

```
StuModel.find({},"name age -_id").then(docs => console.log(docs));
```

> 这里提供了直接用字符串传进想要的列
>
> -列名代表不要

```
StuModel.find({}, { name:1, _id:0 }, { skip:3, limit:1 }).then(docs => console.log(docs));
```

> 还可以加入第四个参数
>
> 常用的是skip跳过多少
>
> limit只显示多少

```
StuModel.count({}).then(count => console.log(count));
```

#### 改

> update
>
> updateOne
>
> updateMany

```
StuModel.updateOne({name:"孙悟空"}, {$set: {age:20} }).then(() => console.log("修改成功"));
```

#### 删

> remove
>
> deleteOne
>
> deleteMany

```
StuModel.deleteOne({name:"孙悟空"}).then(() => console.log("删除成功"));
```



### Document

> Document和文档是一一对应的

#### 创建并插入

```
var stu = new StuModel({
    name:"奔波霸",
    age:48,
    gender:"male",
    address:"碧波潭"
});
```

```
stu.save().then(() => console.log("保存成功！"));
```

#### 修改

```
StuModel.findOne({}, function (err,doc) {
    if (!err){
        doc.updateOne({$set: {age:28}}).then(() => console.log("修改成功"));
    }
});
```

```
StuModel.findOne({}, function (err,doc) {
    if (!err){
        doc.age = 88;
        doc.save().then(() => console.log("修改成功！"));
    }
});
```

#### 删除

```
StuModel.findOne({}, function (err,doc) {
    if (!err){
        doc.remove().then(() => console.log("删除成功"));
    }
});
```

