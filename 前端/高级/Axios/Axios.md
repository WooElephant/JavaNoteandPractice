# Axios

> 前端最流行的AJAX请求库

## 准备工作

> 启动一个GitHub上快速部署REST风格的JSON Server

```js
npm install -g json-server
```

> 新建db.json文件

```json
{
  "posts": [
    { "id": 1, "title": "json-server", "author": "typicode" }
  ],
  "comments": [
    { "id": 1, "body": "some comment", "postId": 1 }
  ],
  "profile": { "name": "typicode" }
}
```

> json-server --watch db.json
>
> 使用命令启动服务

> 这个db.json就像一个小型数据库，可以在其中增加修改



## 导入

```html
<script src="https://cdn.bootcdn.net/ajax/libs/axios/0.21.1/axios.min.js"></script>
<script>
    console.log(axios);
</script>
```



## 基本使用

```html
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>1</title>
    <script src="https://cdn.bootcdn.net/ajax/libs/axios/0.21.1/axios.min.js"></script>
</head>
<body>
    <div class="container">
        <h2>基本使用</h2>
        <button>GET请求</button>
        <button>POST请求</button>
        <button>PUT请求</button>
        <button>DELETE请求</button>
    </div>
    <script>
        const btns = document.querySelectorAll('button');

        //查询id为2的posts
        btns[0].onclick = function (){
            axios({
                method: 'GET',
                url: 'http://localhost:3000/posts/2',
            }).then(response => {
                console.log(response);
            });
        }

        //添加posts
        btns[1].onclick = function (){
            axios({
                method: 'POST',
                url: 'http://localhost:3000/posts',
                data: {
                    title: '标题3',
                    author: '张三'
                }
            }).then(response => {
                console.log(response);
            });
        }

        //更新posts
        btns[2].onclick = function (){
            axios({
                method: 'PUT',
                url: 'http://localhost:3000/posts/3',
                data: {
                    title: '标题3',
                    author: '李四'
                }
            }).then(response => {
                console.log(response);
            });
        }

        //删除
        btns[3].onclick = function (){
            axios({
                method: 'delete',
                url: 'http://localhost:3000/posts/3'
            }).then(response => {
                console.log(response);
            });
        }
    </script>
</body>
</html>
```



## 默认配置

```js
//默认配置
axios.defaults.method = 'GET';//设置默认的请求类型为 GET
axios.defaults.baseURL = 'http://localhost:3000';//设置基础 URL
axios.defaults.params = {id:100};
axios.defaults.timeout = 3000;//

btns[0].onclick = function(){
    axios({
        url: '/posts'
    }).then(response => {
        console.log(response);
    })
}
```



## 实例对象

```js
//创建实例对象  /getJoke
const duanzi = axios.create({
    baseURL: 'https://api.apiopen.top',
    timeout: 2000
});

duanzi.get('/getJoke').then(response => {
    console.log(response.data)
});
```



## 拦截器

```js
// 设置请求拦截器  config 配置对象
axios.interceptors.request.use(function (config) {
    console.log('请求拦截器 成功 - 1号');
    //修改 config 中的参数
    config.params = {a:100};

    return config;
}, function (error) {
    console.log('请求拦截器 失败 - 1号');
    return Promise.reject(error);
});

axios.interceptors.request.use(function (config) {
    console.log('请求拦截器 成功 - 2号');
    //修改 config 中的参数
    config.timeout = 2000;
    return config;
}, function (error) {
    console.log('请求拦截器 失败 - 2号');
    return Promise.reject(error);
});

// 设置响应拦截器
axios.interceptors.response.use(function (response) {
    console.log('响应拦截器 成功 1号');
    return response.data;
    // return response;
}, function (error) {
    console.log('响应拦截器 失败 1号')
    return Promise.reject(error);
});

axios.interceptors.response.use(function (response) {
    console.log('响应拦截器 成功 2号')
    return response;
}, function (error) {
    console.log('响应拦截器 失败 2号')
    return Promise.reject(error);
});

//发送请求
axios({
    method: 'GET',
    url: 'http://localhost:3000/posts'
}).then(response => {
    console.log('自定义回调处理成功的结果');
    console.log(response);
});
```



## 取消请求

```js
//声明全局变量
let cancel = null;
//发送请求
btns[0].onclick = function(){
    //检测上一次的请求是否已经完成
    if(cancel !== null){
        //取消上一次的请求
        cancel();
    }
    axios({
        method: 'GET',
        url: 'http://localhost:3000/posts',
        //1. 添加配置对象的属性
        cancelToken: new axios.CancelToken(function(c){
            //3. 将 c 的值赋值给 cancel
            cancel = c;
        })
    }).then(response => {
        console.log(response);
        //将 cancel 的值初始化
        cancel = null;
    })
}

//绑定第二个事件取消请求
btns[1].onclick = function(){
    cancel();
}
```

