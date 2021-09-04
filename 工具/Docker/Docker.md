# Docker

> 仅限于JavaEE方向的Docker基础知识

 

## 阿里云镜像

> 在http://dev.aliyun.com/登陆
>
> 在镜像搜索--->镜像工具--->镜像加速器
>
> 复制下方代码块，并运行
>
> ```
> sudo mkdir -p /etc/docker
> sudo tee /etc/docker/daemon.json <<-'EOF'
> {
>   "registry-mirrors": ["https://3jn3bqxx.mirror.aliyuncs.com"]
> }
> EOF
> sudo systemctl daemon-reload
> sudo systemctl restart docker
> ```



## 常用命令

### 帮助命令

> docker version
>
> docker info
>
> docker --help

### 镜像命令

#### docker image

>  列出本机镜像
>
> REPOSITORY：镜像的仓库源
>
> TAG：镜像的标签
>
> IMAGE ID：镜像ID
>
> CREATED：创建时间
>
> SIZE：大小

> 参数
>
> -a	显示所有镜像（包含中间映像层）
>
> -q	只显示镜像id
>
> --digests	显示镜像的摘要信息
>
> --no-trunc	显示完整镜像信息

#### docker search

```
docker search tomcat
```

> 在docker HUB中搜索镜像

> 参数
>
> -s n	大于n个stars才显示
>
> --no-trunc	显示完整镜像信息
>
> --automated	只列出automated build类型的镜像

#### docker pull

```
docker pull tomcat
```

> 下载镜像
>
> docker pull tomcat：xx
>
> 可以指定版本号

#### docker rmi

> 删除镜像

```js
docker rmi -f 镜像id	//删除一个
docker rmi -f hello-world nginx		//删除多个
docker rmi -f $(docker images -qs)	//删除全部
```



## 容器命令

### 新建并启动容器

```
docker run [options] image [command] [arg...]
```

> **options**
>
> --name	为容器指定名称
>
> -d	后台运行
>
> -i	交互模式运行，通常与-t同时使用
>
> -t	为容器重新分配一个伪输入终端，通常与-i同时使用
>
> -P	随机端口映射
>
> -p	指定端口映射：有以下四种格式
>
> ​		ip：hostPort：containerPort
>
> ​		ip：：containerPort
>
> ​		**hosetPort：containerPort**
>
> ​		containerPort



### 列出正在运行的容器

```
docker ps [options]
```

> **options**
>
> -a	列出所有正在运行的容器+历史运行过的容器
>
> -l	显示最近创建的容器
>
> -n value	显示最近value个创建的容器
>
> -q	静默模式，只显示容器编号
>
> --no-trunc	完整输出



### 退出容器

> exit	容器停止并退出
>
> ctrl+P+Q	容器不停止退出



### 启动容器

> docker start 容器名或ID



### 停止容器

> docker stop 容器名或ID
>
> docker kill 容器名或ID	强制停止



### 删除容器

> docker rm 容器id
>
> docker rm -f $(docker ps -a -q)	删除全部容器



### 查看容器日志

> docker logs [-f] [-t] [--taill] 容器id
>
> t是加入时间戳
>
> f是跟随最新日志打印
>
> taill 数字	显示最后多少条



### 查看容器内运行的进程

> docker top 容器ID



### 查看容器内部细节

> docker inspect 容器ID



### 进入正在运行的容器

> docker exec -it 容器ID bashShell	进入容器内部执行bashShell并退出
>
> docker attach 容器ID	重新进入容器内部

> docker exec -it 容器ID /bin/bash
>
> 与
>
> docker attach 容器ID
>
> 效果是一样的



### 从容器内拷贝

> docker cp 容器ID:容器内路径 目标主机路径



### 注意事项

> Docker容器后台运行必须有一个前台进程
>
> 如果没有前台进程，容器会立即自杀



## 镜像

> 镜像是一种轻量级，可执行的独立软件包
>
> 用来打包软件运行环境，和基于运行环境开发的软件
>
> 它包含运行某个软件所需所有内容



### UnionFS

> UnionFS是一种分层，轻量级并且高性能的文件系统
>
> 它支持对文件系统的修改，作为一次提交来一层层的叠加
>
> UnionFS是Docker镜像的基础
>
> 一次同时加载多个文件系统，但从外面看起来，只能看到一个文件系统



### docker commit

> docker commit提交容器副本使之成为一个新的镜像

```
docker commit -m="提交的信息" -a="作者" 容器id 要创建的目标镜像名:[标签名]
```



## 容器数据卷

> 为了使数据可以持久化，我们使用数据卷

> 数据卷可以在容器之间共享或重用数据
>
> 卷中的更改可以直接生效
>
> 数据卷中的更改不会包含在镜像的更新中
>
> 数据卷的生命周期一直持续到没有容器使用它为止



### 添加数据卷

```
docker run -it -v /主机绝对路径:/容器内目录 镜像名
```

```
docker run -it -v /主机绝对路径:/容器内目录:ro 镜像名
```

> ro代表read only

> 这两个目录被绑定，就像是给容器插上了一个移动硬盘



### 使用DockerFile添加数据卷

```
VOLUME ["容器内目录1","容器内目录2","容器内目录3"]
```

```
from centos
VOLUME ["/data1","/data2"]
CMD echo "finished"
CMD /bin/bash
```

> 创建完DockerFile，使用build创建镜像

```
docker build -f /mydocker/DockerFile -t haha/centos .
```

> 启动我们自己编译的镜像以后
>
> 使用inspect，就可以查看到默认绑定的本机目录



### 数据卷共享

```
docker run -it --name xxx --volumes-from xxx haha/centos
```

> 这样就可以让之后建立的容器，可以与--volumes-from后的容器共享数据卷



## DockerFile

> DockerFile是用来构建Docker镜像的构建文件，是由一系列的命令和参数构成的脚本



### 基础知识

> - 每条保留字指令都必须为大写字母，且后面要跟随至少一个参数
> - 指令从上到下顺序执行
> - #表示注释
> - 每条指令都会新建一个镜像层，并提交

> Docker在执行DockerFile时，大致会以一下流程进行执行
>
> 1. 从基础镜像运行容器
> 2. 执行一条指令对镜像进行修改
> 3. 执行docker commit，提交一个新的镜像层
> 4. 再基于刚提交的镜像运行新的容器
> 5. 执行下一条指令，一直反复到结束

> Docker Hub中99%的镜像都是通过base镜像中安装和配置需要的软件构建出来的
>
> base镜像就是scratch



### 结构

#### FROM

>基础镜像，当前新镜像是基于哪个镜像

#### MAINTAINER

>镜像维护者姓名和邮箱  

#### RUN

>容器构建时需要运行的命令

#### EXPOSE

>当前容器对外暴露出的接口

#### WORKDIR

>在创建容器后，终端默认登录进来的目录

#### ENV

>用来构建镜像过程中设置环境变量

#### ADD

>将主机目录下的文件拷贝进镜像，并且ADD会自动处理URL和tar压缩包

#### COPY

>类似ADD，拷贝文件到镜像中

#### VOLUME

>容器数据卷

#### CMD

>指定一个容器启动时要运行的命令
>
>DockerFile中可以有多个CMD命令，但只有最后一个会生效
>
>CMD会被docker run之后的参数替掉

#### ENTRYPOINT

>指定一个容器启动时要运行的命令
>
>如果docker run后面有参数，则变为追加

#### ONBUILD

>当构建一个被继承的DockerFile时运行命令，父镜像在被子继承后，父镜像的ONBUILD触发



### 案例

> 目标：
>
> 自定义一个CentOS
>
> 修改默认登录路径
>
> 添加vim编辑器
>
> 添加ifconfig支持

```dockerfile
FROM centos
MAINTAINER xxxx<xxxx@xxx>

ENV mypath /tmp
WORKDIR $mypath

RUN yum -y install vim
RUN yum -y install net-tools

EXPOSE 80
CMD /bin/bash
```



### CMD与ENTRYPOINT

```dockerfile
CMD ["curl","-s","http://ip.cn"]
```

> 比如我们有一个这样的命令，在运行的时候，我们又想加入-i参数，显示头信息
>
> CMD就无法执行
>
> 因为如果在docker run 后面加-i
>
> 会在末尾生成一句CMD -i这显然是不行的

```dockerfile
ENTRYPOINT ["curl","-s","http://ip.cn"]
```

> 如果是ENTRYPOINT
>
> 我们在docker run的后面加入-i参数
>
> 就会变为ENTRYPOINT ["curl","-s","-i","http://ip.cn"]



### ONBUILD

```dockerfile
FROM centos
RUN yum install -y curl
ENTRYPOINT ["curl","-s","http://ip.cn"]
ONBUILD RUN echo "father image onbuild"
```

> 如果之后有镜像是from这个镜像的
>
> 当子类build的时候，这个ONBUILD会被触发



### 案例2

> 自定义Tomcat

```dockerfile
FROM centos
MAINTAINER xxx<xxx@xxx>

COPY a.txt /usr/local/aincontainer.txt
ADD jdk-8u171-linux-x64.tar.gz /usr/local
ADD apache-tomcat-9.0.8.tar.gz /usr/local

RUN yum -y install vim

ENV MYPATH /usr/locak
WORKDIR $MYPATH

ENV JAVA_HOME /usr/loacl/jdk1.8.0_171
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOM/lib/tools.jar
ENV CATALINA_HOME /usr/local/apache-tomcat-9.0.8
ENV CATALINA_BASE /usr/local/apache-tomcat-9.0.8
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/lib:$CATALINA_HOME/bin

EXPOSE 8080

CMD /usr/local/apache-tomcat-9.0.8/bin/startup.sh && tail -F /usr/local/apache-tomcat-9.0.8/bin/logs/catalina.out
```

> COPY a.txt /usr/local/aincontainer.txt
>
> 没有意义，单纯为了演示COPY

```
docker run -d -p 9080:8080 --name myt9 -v /mydockerfile/tomcat9/test:/usr/loacl/apache-tomcat-9.0.8/webapps/test -v /mydockerfile/tomcat9/tomcat9logs/:/usr/loacl/apache-tomcat-9.0.8/logs --privileged=true mytomcat9
```

```
docker run -d -p 9080:8080 --name myt9
-v /mydockerfile/tomcat9/test:/usr/loacl/apache-tomcat-9.0.8/webapps/test
-v /mydockerfile/tomcat9/tomcat9logs/:/usr/loacl/apache-tomcat-9.0.8/logs
--privileged=true
mytomcat9
```

> 换个行看着比较清楚

