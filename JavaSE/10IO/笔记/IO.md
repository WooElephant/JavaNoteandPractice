# IO

> 文件在程序中是以流的形式传输的

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\JavaSE\10IO\笔记\1.PNG)

## 文件操作

### 创建文件

> 使用File类相关的方法

```java
new File(String pathname);//根据路径创建File对象
new File(File parent,String child);//根据父目录文件+子路径构建
new File(String parent,String child);//根据父目录+子路径构建
```

> new File(String pathname);//根据路径创建File对象

```java
String filepath = "D:\\abc.txt";
File file = new File(filepath);
file.createNewFile();
System.out.println("创建成功！");
```

> new File(File parent,String child);//根据父目录文件+子路径构建

```java
File file = new File("D:\\");
String filename = "bbb.txt";
File file2 = new File(file,filename);
file2.createNewFile();
System.out.println("创建成功！");
```

> new File(String parent,String child);//根据父目录+子路径构建

```java
String path = "D:\\";
String filename = "ccc.txt";
File file2 = new File(path,filename);
file2.createNewFile();
System.out.println("创建成功！");
```



### 获取文件信息

```java
File file = new File("D:\\abc.txt");
System.out.println("文件名："+file.getName());
System.out.println("文件绝对路径："+file.getAbsolutePath());
System.out.println("文件父级目录："+file.getParent());
System.out.println("文件大小："+file.length());
System.out.println("文件是否存在："+file.exists());
System.out.println("是不是一个文件："+file.isFile());
System.out.println("是不是一个目录："+file.isDirectory());
```



### 目录操作

```java
String filepath = "D:\\abc.txt";
File file = new File(filepath);
if (file.exists()) {
    file.delete();
}else {
    System.out.println("文件不存在！");
}
```

```java
String filepath = "D:\\demo";
File file = new File(filepath);
if (file.exists()) {
    file.delete();
}else {
    System.out.println("目录不存在！");
}
```

> 删除文件或者目录的方法是一样的

```java
String filepath = "D:\\demo\\a\\b\\c";
File file = new File(filepath);
if (file.exists()) {
    System.out.println("该目录存在！");
}else {
    file.mkdirs();
}
```



> **I / O** 是 **Input / Output** 的缩写
>
> Java程序中，对于数据的输入输出操作以流的方式来进行
>
> Java.io包下面提供了各种流类和接口



## 流的分类

| 抽象基类 |    字节流    | 字符流 |
| :------: | :----------: | :----: |
|  输入流  | InputStream  | Reader |
|  输出流  | OutputStream | Writer |

> Java中IO的类，都是由以上四个类派生出来的
>
> 他们的后缀都是以他们的父类名为后缀

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\JavaSE\10IO\笔记\io.png)

## 字节流

### FileInputStream

> 字节输入流
>
> **InputStream**抽象类是所有字节输入流的父类
>
> 常用子类：
>
> `FileInputStream`：文件输入流
>
> `BufferedInputStream`：缓冲字节输入流
>
> `ObjectInputStream`：对象字节输入流

```java
String filepath = "D:\\bbb.txt";
FileInputStream fis = new FileInputStream(filepath);
int read = 0;
while ( ( read = fis.read() ) != -1 ){
    System.out.print((char) read);
}
fis.close();
```

> 我们可以通过这样的方法读取一个txt文件的全部信息，并打印出来
>
> 读一个字节写一个字节
>
> 最后不要忘了释放资源，关闭流

> 但这样读一个写一个太浪费，我们可以为他创建一个缓冲区，读一批，写一批

```java
String filepath = "D:\\bbb.txt";
FileInputStream fis = new FileInputStream(filepath);
byte[] buff = new byte[8];
int read = 0;
while ( ( read = fis.read(buff) ) != -1 ){
    System.out.print(new String(buff,0,read));
}
fis.close();
```

> 如果文件的长度不是8的整数，就会造成最后一次只读了少于8位
>
> 比如最后剩余了3个字节，但剩下的5个并没有更新，是上一次缓存的数据
>
> 所以我们要用截取字符串的行驶，只输出读取了的部分



### FileOutputStream

```java
String filepath = "D:\\aaa.txt";
FileOutputStream fos = new FileOutputStream(filepath);
String str = "Hello World!";
fos.write(str.getBytes(StandardCharsets.UTF_8));
fos.close();
```

> 因为write方法需要二进制数据，所以调用String的getBytes方法，该方法可以有参数，参数为编码集
>
> 这样写入会直接覆盖掉原有的文件

```java
FileOutputStream fos = new FileOutputStream(filepath,true);
```

> 在构造器中，添加第二个参数true可以改变覆盖为追加到文件结尾



### 文件拷贝

```java
String srcfilepath = "E:\\123.jfif";
String desfilepath = "D:\\123.jfif";
FileInputStream fis = new FileInputStream(srcfilepath);
FileOutputStream fos = new FileOutputStream(desfilepath);

byte[] buff = new byte[1024];
int readLen = 0;
while ( (readLen = fis.read(buff)) != -1 ) {
    fos.write(buff,0,readLen);
}

fos.close();
fis.close();
```

> 没有要注意的，别忘了释放资源



## 字符流

### FileReader

```java
String filepath = "D:\\aaa.txt";
FileReader fr = new FileReader(filepath);
int data = 0;
while ( (data = fr.read()) != -1){
    System.out.print((char)data);
}
fr.close();
```

> 跟字节读取没什么区别，但字符流可以解决乱码问题，因为每个字符把它当做一个整体来读取

```java
String filepath = "D:\\aaa.txt";
FileReader fr = new FileReader(filepath);
int readLen = 0;
char[] buff = new char[8];
while ( (readLen = fr.read(buff)) != -1){
    System.out.print(new String(buff,0,readLen));
}
fr.close();
```

> 使用缓冲数组读取，也是一样的



### FileWriter

```java
String filepath = "d:\\ccc.txt";
FileWriter fw = new FileWriter(filepath,true);
String str = "你好，世界！";
fw.write(str);
fw.close();
```

> 和字节输出没有什么区别



## 处理流

### 节点流和处理流

> 节点流是从一个特定数据源读写数据的
>
> 上面我们谈到的这些都是节点流
>
> 节点流是底层流，它与数据源直接连接

> 处理流也叫包装流
>
> 就是把节点流进行包装，使流的功能更加强大



### BufferedReader

```java
String filepath = "d:\\abc.txt";
BufferedReader br = new BufferedReader(new FileReader(filepath));
String line;
while ((line = br.readLine()) != null){
    System.out.println(line);
}
br.close();
```

> 我们发现包装流在使用的时候，比节点流方便很多，readline就可以直接读取下一行
>
> **注意**包装流只需要关闭本身，被传入的节点流，会在底层自动关闭





### BufferedWriter

```java
String filepath = "d:\\abc.txt";
BufferedWriter bw = new BufferedWriter(new FileWriter(filepath));
String str = "你好，世界！";
bw.write(str);
bw.newLine();
bw.write(str);
bw.close();
```

> 需要注意的是，自己要记得手动加入换行
>
> newline方法会插入一个与你系统设置相关的换行符





### 字符处理流文件拷贝

```java
String srcFilePath = "d:\\aaa.txt";
String desFilePath = "e:\\aaa.txt";
BufferedReader br = new BufferedReader(new FileReader(srcFilePath));
BufferedWriter bw = new BufferedWriter(new FileWriter(desFilePath));
String line;
while ( (line = br.readLine()) != null ){
    bw.write(line);
    bw.newLine();
}
bw.close();
br.close();
```

> readline不会读取换行符，所以要手动写一个换行符



### 字节处理流拷贝文件

```java
String srcPath = "e:\\spring.png";
String desPath = "d:\\spring.png";
BufferedInputStream bis = new BufferedInputStream(new FileInputStream(srcPath));
BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(desPath));
byte[] buff = new byte[1024];
int dataLen = 0;
while ( (dataLen = bis.read(buff)) != -1){
    bos.write(buff,0,dataLen);
}
bos.close();
bis.close();
```

> 和节点流的使用没有什么区别



### 对象处理流

> 将int num = 100保存到文件中，应该怎么做
>
> 将Dog dog = new Dog("小黄", 3)保存到文件中，应该怎么做
>
> 这些内容保存之后，要能恢复到程序中

> `序列化和反序列化`
>
> `序列化`：序列化就是在保存数据时，保存*数据的值*和*数据类型*
>
> `反序列化`：反序列化就是在恢复数据时，恢复*数据的值*和*数据类型*
>
> 如果需要让某个对象支持序列化机制，必须让其类是可序列化的
>
> 必须实现以下两个接口之一
>
> Serializable 这是一个标记接口，一般我们用这个
>
> Externalizable

```java
String filepath = "d:\\data.dat";
ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(filepath));
oos.writeInt(100);
oos.writeUTF("你好！");
oos.writeObject(new Dog("旺财",3));
oos.close();
```

> 将一些类型写出到硬盘



```java
String filepath = "d:\\data.dat";
ObjectInputStream ois = new ObjectInputStream(new FileInputStream(filepath));
System.out.println(ois.readInt());
System.out.println(ois.readUTF());
Dog dog = (Dog) ois.readObject();
System.out.println(dog);
ois.close();
```

> 一定要按照储存的顺序来读取，不然会报错

> 序列化和反序列化注意事项
>
> 1. 读写顺序要一致
>
> 2. 序列化的类建议添加SerialVersionUID，提高兼容性
>
>    如果不添加此属性，只要类的主体发生变化，java会认为他们版本不一致，不允许反序列化
>
> 3. 序列化对象时，所有属性都会被序列化，除了static和transient修饰的成员
>
> 4. 序列化对象时，要求内部的成员属性也要实现序列化接口



### 标准输入输出流

> System.in		默认输入流，代表键盘
>
> System.out	 默认输出流，代表显示器





### 转换流

> `InputStreamReader`：可以将InputStream（字节流）转换为Reader（字符流）
>
> `OutputStreamWriter`：可以将OutputStream（字节流）转换为Writer（字符流）
>
> 处理纯文本数据时，使用字符流效率更高，并且可以有效解决乱码问题

```java
String path = "d:\\bbb.txt";
BufferedReader br = new BufferedReader(new FileReader(path));
String data = br.readLine();
System.out.println(data);
br.close();
```

> 如果我们的文件含有中文，编码格式不是UTF8
>
> 就会出现乱码

```java
String path = "d:\\bbb.txt";
InputStreamReader isr = new InputStreamReader(new FileInputStream(path),"gbk");
BufferedReader br = new BufferedReader(isr);
String data;
data = br.readLine();
System.out.println(data);
br.close();
```

> 我们使用转换流，将FileInputStream转成字节流，然后再传给包装流
>
> 就可以解决乱码问题

```java
String filepath = "d:\\ccc.txt";
OutputStreamWriter osw = new OutputStreamWriter(new FileOutputStream(filepath), "gbk");
osw.write("你好，世界！");
osw.close();
```

> 使用字符转换流，自定义输出的编码格式



### 打印流

```java
PrintStream out = System.out;
out.println("你好");
out.close();
```

> 就相当于我们常用的sout（syso）

```java
System.setOut(new PrintStream("d:\\ddd.txt"));
System.out.println("你好");
```

> 我们现在可以设置System.out的位置不要为默认的显示器
>
> 而手动指定一个位置，就可以把打印的内容输出到，我们指定的文件中

```java
PrintWriter pw = new PrintWriter(System.out);
pw.println("hello world");
pw.close();
```

> PrintWriter和PrintStream用法是相同的

```java
PrintWriter pw = new PrintWriter(new FileWriter("d:\\ddd.txt"));
pw.println("hello world");
pw.close();
```

> 我们也可以为它指定输出位置



### Properties

```java
BufferedReader br = new BufferedReader(new FileReader("src/com/augus01/mysql.properties"));
String data;
while ((data = br.readLine()) != null) {
    String[] split = data.split("=");
    System.out.println(split[0] + " : " + split[1]);
}
br.close();
```

> 使用流，从properties文件中读取配置信息

```java
Properties pro = new Properties();
pro.load(new FileReader("src/com/augus01/mysql.properties"));
pro.list(System.out);

String username = pro.getProperty("username");
System.out.println(username);
```

> 我们使用properties类可以更容易的获取

```java
Properties pro = new Properties();
pro.setProperty("username","root");
pro.setProperty("password","1234");
pro.store(new FileWriter("src/com/augus01/mysql.properties"),null);
```

> 使用properties类也可以写入一个配置文件
>
> store方法中，第二个参数是注释，如果填写，将在properties文件最上面生成注释信息
>
> **注意**  如果文件中本身就有写入的key，则会覆盖，否则会创建
>
> 其实就是个HashTable



