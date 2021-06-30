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



## I/O流

> **I / O** 是 **Input / Output** 的缩写
>
> Java程序中，对于数据的输入输出操作以流的方式来进行
>
> Java.io包下面提供了各种流类和接口



### 流的分类

| 抽象基类 |    字节流    | 字符流 |
| :------: | :----------: | :----: |
|  输入流  | InputStream  | Reader |
|  输出流  | OutputStream | Writer |

> Java中IO的类，都是由以上四个类派生出来的
>
> 他们的后缀都是以他们的父类名为后缀

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\JavaSE\10IO\笔记\io.png)



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

