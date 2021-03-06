## 去官网下载Oracle数据库
> 下载地址
> https://www.oracle.com/database/technologies/xe-prior-releases.html

![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621784286627)

#### 注意
> win32_11gR2_database_1of2.zip 
> win32_11gR2_database_2of2.zip 
> `把这两个文件下载到同一目录下,解压缩即可`


## 开始安装Oracle数据库
![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621784521034)

- 执行安装程序，出现控制台窗口如下 
  > ![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621784549531)
- 执行等待片刻之后，会出现如图所示的启动画面
  > ![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621784609993)
- 稍许等待，就会出现如图所示的安装画面。取消默认选中的“我希望通过My Oracle Support接收安全更新。”，然后点击“下一步”继续
  > ![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621784680427)
- 之后出现 “选择安装选项”对话框，如图所示。保持默认选择“创建和配置数据库”，点击“下一步”继续
  > ![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621784729279)
- 之后出现“系统类”对话框，如图所示。保持默认选择“桌面类”，点击“下一步”继续
  > ![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621784758950)
- 接下来出现“典型安装配置”对话框，如图所示
  - 设置Oracle基目录、软件位置和数据库文件位置，选择数据库版本（企业版）和字符集（保持默认值）
  - 同时要设置全局数据库名，本次安装时如图所示，全局数据库名设置为orcl11，需要记住
  - 最后还需要设置管理口令，其格式要求至少包含一个大写字母、一个小写字母和一个数字，否则会提示警告信息
  - 点击“下一步”继续，如果管理口令的设置不符合Oracle建议的标准，安装过程会再次弹出一个对话框，提示管理口令不符合要求，是否继续
  > ![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621784884079)
- 之后出现“执行先决条件检查”对话框，如图所示。安装程序为确保目标环境能满足所选Oracle产品的最低安装和配置要求，执行条件检查。检查完成后，点击“下一步”继续
  > ![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621784931796)
- 之后出现“概要”对话框，如图所示。该概要总结了之前对Oracle 11g安装的设置信息，如果安装者发现存在问题，可以通过点击“后退”进行更改；如果没有发现问题，则点击“完成”，开始Oracle 11g的安装
  > ![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621784972992)
- 之后出现“安装产品”对话框，安装画面如图所示，需要等待一段时间
  > ![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621785011637)
- 安装产品结束之后，出现“数据库配置助手”对话框，如图所示。该过程需要完成复制数据库文件，创建并启动Oracle实例和创建数据库的工作
  > ![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621785039756)
- 数据库创建完成之后，出现“确认”对话框，如图所示。在该对话框中，有一个重要的工作就是给数据库默认帐户解锁，并设置帐户口令，点击“口令管理”按钮继续
  > ![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621785069228)
- 之后出现“口令管理”对话框，如图所示
  - Oracle数据库系统提供了多个默认帐户，这些默认帐户具有不同的数据库对象、角色权限和系统权限等。从图中可以看出，用蓝色对号标识的数据库帐户处于锁定状态，不能使用
  - 对于解锁的帐户，需要设置帐户口令，本次安装解锁了HR、SYSTEM、SYS和SCOTT四个帐户，并设置了不同的密码，其中解锁HR帐户的目的是之后需要通过使用HR帐户登录Oracle数据库，访问其中的人力资源相关表，达到演示SQL语句作用的目的
  - 注意SCOTT用户默认密码一般设置为tiger
  > ![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621785137094)
- 最后出现“完成”对话框，提示Oracle数据库安装成功，并告知可以通过指定的URL访问Oracle企业管理器数据库控制台。
  - 点击“关闭”，安装程序会自动打开一个浏览器窗口，访问企业管理器，使用SYS或SYSTEM帐户（HR和SCOTT帐户不具备相关权限）登录企业管理器，可以对Oracle数据库进行管理
  > ![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621785201190)


## PL/SQLDeveloper工具连接Oracle
> PL/SQL Developer 是一个为Oracle数据库量身定制的集成开发环境（IDE）

![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621785432127)

![图片描述](https://doc.shiyanlou.com/courses/uid1321907-20210523-1621785445556)