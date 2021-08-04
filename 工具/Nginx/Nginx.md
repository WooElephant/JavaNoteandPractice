# Nginx

> Nginx 是高性能的 HTTP 和反向代理的服务器，处理高并发能力是十分强大的， 能经受高负载的考验

## 基本概念

### 反向代理

> 其实客户端对代理是无感知的，因为客户端不需要任何配置就可以访问，我们只需要将请求发送到反向代理服务器，由反向代理服务器去选择目标服务器获取数据后，在返回给客户端，此时反向代理服务器和目标服务器对外就是一个服务器，暴露的是代理服务器地址，隐藏了真实服务器 IP 地址

### 负载均衡

> 增加服务器的数量，然后将请求分发到各个服务器上，将原先请求集中到单个服务器上的情况改为将请求分发到多个服务器上，将负载分发到不同的服务器，也就是我们所说的负载均衡

### 动静分离

> 为了加快网站的解析速度，可以把动态页面和静态页面由不同的服务器来解析，加快解析速度。降低原来单个服务器的压力



## 安装

### 依赖

```sh
yum -y install make zlib zlib devel gcc c++ libtool openssl openssl dev el
```

### 安装Nginx

> 1. 导入压缩包
> 2. 解压
> 3. 进入目录运行./configure
> 4. 运行make && make install

> ./configure: error: the HTTP gzip module requires the zlib library.
>
> yum install -y zlib-devel

> 安装成功之后
>
> usr/local中会多出来一个nginx文件夹

> 在usr/local/nginx/sbin
>
> 中运行./nginx
>
> 可以启动服务

> 通过ip地址访问，如果出现Nginx欢迎页，则证明启动成功

### 防火墙

>  firewall-cmd --add-port=80/tcp --permanent
>
> firewall-cmd --reload
>
> 开放80端口，并重启



## 常用命令

### 启动命令

> 在/usr/local/nginx/sbin 目录下执行 ./nginx

### 关闭命令

> 在/usr/local/nginx/sbin 目录下执行 ./nginx -s stop

### 重新加载命令

> 在/usr/local/nginx/sbin 目录下执行 ./nginx -s reload



## 配置文件

> /usr/local/nginx/conf目录下的nginx.conf
>
> nginx配置文件由三部分组成

### 全局块

> 从配置文件开始到 events 块之间的内容，主要会设置一些影响nginx 服务器整体运行的配置指令

> worker_processes  1;
>
> 这是 Nginx 服务器并发处理服务的关键配置，worker_processes 值越大，可以支持的并发处理量也越多，但是会受到硬件、软件等设备的制约

### events块

> events 块涉及的指令主要影响 Nginx 服务器与用户的网络连接

> worker_connections  1024;
>
> 表示每个 work process 支持的最大连接数为 1024

### http块

> 这算是 Nginx 服务器配置中最频繁的部分，代理、缓存和日志定义等绝大多数功能和第三方模块的配置都在这里

#### http 全局块

> http全局块配置的指令包括文件引入、MIME-TYPE 定义、日志自定义、连接超时时间、单链接请求数上限等

#### server 块

> 这块和虚拟主机有密切关系，虚拟主机从用户角度看，和一台独立的硬件主机是完全一样的，该技术的产生是为了节省互联网服务器硬件成本

##### 全局 server 块

> 最常见的配置是本虚拟机主机的监听配置和本虚拟主机的名称或IP配置

##### location 块

> 这块的主要作用是基于 Nginx 服务器接收到的请求字符串（例如 server_name/uri-string），对虚拟主机名称（也可以是IP别名）之外的字符串（例如 前面的 /uri-string）进行匹配，对特定的请求进行处理。地址定向、数据缓存和应答控制等功能，还有许多第三方模块的配置也在这里进行



## 反向代理

### 案例一

    server {
        listen       80;
        server_name  192.168.80.129;
    
        #charset koi8-r;
    
        #access_log  logs/host.access.log  main;
    
        location / {
            root   html;
            proxy_pass http://127.0.0.1:8080;
            index  index.html index.htm;
        }

> server_name更改为本机ip
>
> location中增加
>
> proxy_pass http://127.0.0.1:8080;



### 案例二

    server {
        listen       9001;
        server_name  192.168.80.129;
    
        location ~ /edu/ {
            proxy_pass http://127.0.0.1:8080;
        }
        location ~ /vod/ {
            proxy_pass http://127.0.0.1:8081;
        }
    }

### location

```
location [ = | ~ | ~* | ^~ ] uri {

}
```

> **= ：**用于不含正则表达式的 uri 前，要求请求字符串与 uri 严格匹配，如果匹配成功，就停止继续向下搜索并立即处理该请求
>
> **~：**用于表示 uri 包含正则表达式，并且区分大小写
>
> **~*：**用于表示 uri 包含正则表达式，并且不区分大小写
>
> **^~：**用于不含正则表达式的 uri 前，要求 Nginx 服务器找到标识 uri 和请求字符串匹配度最高的 location 后，立即使用此 location 处理请求，而不再使用 location 块中的正则 uri 和请求字符串做匹配

> 注意：如果 uri 包含正则表达式，则必须要有 ~ 或者 ~* 标识



## 负载均衡

    http{
    ...
        upstream myserver{
            server 192.168.80.129:8080;
            server 192.168.80.129:8081;
        }
    ...
        server{
    	 location / {
    	    ...
                proxy_pass http://myserver;
                ...
            }
        }
    

> Nginx 提供了几种分配方式（策略）

> **轮询**
>
> 默认，每个请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器down掉，能自动剔除

> **weight**
>
> weight代表权重默认为 1, 权重越高被分配的客户端越多
>
> 指定轮询几率，weight和访问比率成正比，用于后端服务器性能不均的情况
>
> ```
> upstream server_pool{ 
>     server 192.168.5.21 weight=10; 
>     server 192.168.5.22 weight=10; 
> }
> ```

> **ip_hash**
>
> 每个请求按访问ip的hash结果分配，这样每个访客固定访问一个后端服务器，可以解决session的问题
>
> ```
> upstream server_pool{ 
>     ip_hash; 
>     server 192.168.5.21:80; 
>     server 192.168.5.22:80; 
> }
> ```

> **fair（第三方）**
>
> 按后端服务器的响应时间来分配请求，响应时间短的优先分配
>
> ```
> upstream server_pool{ 
>     server 192.168.5.21:80; 
>     server 192.168.5.22:80; 
>     fair; 
> }
> ```



## 动静分离

### 概念

> Nginx 动静分离简单来说就是把动态跟静态请求分开

> 动静分离从目前实现角度来讲大致分为两种
>
> 一种是纯粹把静态文件独立成单独的域名，放在独立的服务器上，也是目前主流推崇的方案
>
> 另外一种方法就是动态跟静态文件混合在一起发布，通过 nginx 来分开

> 通过 location 指定不同的后缀名实现不同的请求转发

> 通过 expires 参数设置，可以使浏览器缓存过期时间，减少与服务器之前的请求和流量
>
> 是给一个资源设定一个过期时间，也就是说无需去服务端验证，直接通过浏览器自身确认是否过期即可，所以不会产生额外的流量
>
> 此种方法非常适合不经常变动的资源
>
> 我这里设置 3d，表示在这 3 天之内访问这个 URL，发送一个请求，比对服务器该文件最后更新时间没有变化，则不会从服务器抓取，返回状态码 304，如果有修改，则直接从服务器重新下载，返回状态码 200

### 配置

```
location /www/ {
    root   /data/;
    index  index.html index.htm;
}
location /image/ {
    root   /data/;
    autoindex on;
}
```

## 高可用集群

### keepalived

```sh
yum install keppalived -y
```

### 配置

> 在etc目录中有一个keepalived.conf文件

```
global_defs {
    notification_email {
        acassen@firewall.loc
        failover@firewall.loc
        sysadmin@firewall.loc
    }
    notification_email_from Alexandre.Cassen@firewall.loc
    smtp_server 192.168.17.129
    smtp_connect_timeout 30
    router_id LVS_DEVEL
}

#检测脚本和权重参数
vrrp_script chk_http_port {
    script "/usr/local/src/nginx_check.sh"
    interval 2 		#检测脚本执行的间隔
    weight -20	#权重
}

}
vrrp_instance VI_1 {
    state MASTER 	# 备份服务器上将MASTER 改为BACKUP
    interface ens33 	 # 网卡
    virtual_router_id 51	 # 主、备机的virtual_router_id必须相同
    priority 100 	# 主、备机取不同的优先级，主机值较大，备份机值较小
    advert_int 1advert_int 1
    authentication {authentication {
        auth_type PASSauth_type PASS
        auth_pass 1111auth_pass 1111
    }
    virtualvirtual_ipaddress {
    	192.168.17.50 	# VRRP H虚拟地址虚拟地址
    }
}
```

```sh
#!/bin/bash
A=`ps -C nginx -no-header |wc -1`
if [ $A -eq 0  ];then
    /usr/local/nginx/sbin/nginx
    sleep 2
    if [ `ps -C nginx --no-header |wc -1` -eq 0 ];then
        killall keepalived
    fi
fi
```

```sh
systemctl start keepalived.service
```



