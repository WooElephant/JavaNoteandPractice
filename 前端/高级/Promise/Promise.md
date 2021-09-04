# Promise

> Promise是ES6引入的全新异步编程解决方案

##  Hello World

```js
const btn = document.querySelector("#btn");
//绑定单击事件
btn.addEventListener('click',function () {
    //声明Promise，resolve代表成功，reject代表失败
    const p = new Promise((resolve, reject) => {
        setTimeout(() => {
            //获取1-100随机数
            let n = Math.floor(Math.random()*99 + 1);

            if (n <= 30){
                //小于等于30则成功，将promise对象的状态设置为成功
                resolve(n);
            }else {
                //其余则失败，将promise对象的状态设置为失败
                reject(n);
            }
        },1000);
    });

    //调用promise，有两个参数，第一个为成功的回调，第二个为失败的回调
    p.then((value) => {
        alert('中奖了！号码为：' + value);
    },(reason) => {
        alert('再接再厉！号码为：' + reason);
    });

});
```

## fs读取文件

```js
const fs = require('fs');

let p = new Promise((resolve, reject) => {
    fs.readFile('./aaa.txt',(err, data) => {
        if (err) reject(err);
        resolve(data);
    });
});

p.then(value => {
    console.log(value.toString());
},reason => {
    console.log(reason);
});
```

## AJAX请求

```js
const fs = require('fs');

const btn = document.querySelector('#btn');

btn.addEventListener('click',function () {

    const p = new Promise((resolve, reject) => {

        const xhr = new XMLHttpRequest();
        xhr.open('GET','xxxxx');
        xhr.send();
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4){
                if (xhr.status >= 200 && xhr.status < 300 ){
                    resolve(xhr.response);
                }else {
                    reject(xhr.status);
                }
            }
        }

    });

    p.then(value => {
        console.log(value);
    },reason => {
        console.warn(reason);
    });

});
```



## promisify

```js
const util = require('util');
const fs = require('fs');

let readFile = util.promisify(fs.readFile);

readFile('./aaa.txt').then(value => {
    console.log(value.toString());
});
```

> 我们可以使用util中的promisify，将一个函数自动包装为Promise的形式



## Promise的属性

### Promise的状态属性

> 在Promise实例对象中有一个属性 PromiseState 它有三种可能的值
>
> pending：未决定的
>
> resolved：成功
>
> rejected：失败
>
> 它的值总会从pending变为resolved，或rejected。而且只能改变一次



### Promise对象的值

> 在Promise实例对象中有一个属性 PromiseResult
>
> 它保存了对象成功或失败的结果



### Promise基本流程

> 创建Promise对象，状态为pending
>
> 进行异步操作
>
> 成功，调用resolve方法，修改状态为resolved，并调用then中第一个回调函数
>
> 失败，调用reject方法，修改状态为rejected，并调用then中第二个回调函数
>
> 返回一个新的Promise对象



## Promise API

### 构造函数

```js
Promise ((resolve, reject) => {})
```



### then方法

```js
Promise.prototype.then(value => {},reason => {});
```



### catch方法

```js
Promise.prototype.catch(reason => {});
```



### resolve方法

```js
Promise.resolve(x);
```

> 返回新的Promise对象，状态为resolved，值为传入的x
>
> 如果传入的x为Promise对象，则参数的结果决定了resolve的结果



### reject方法

```js
Promise.reject(x);
```

> 返回新的Promise对象，状态为rejected，值为传入的x



### all方法

```js
Promise.all(promises);
```

> 传入一个Promise的数组，只有所有的Promise都成功，才成功

```js
let p1 = new Promise((resolve, reject) => {
    resolve('ok!');
});
let p2 = Promise.resolve('success');

const result = Promise.all([p1,p2]);
```



### race方法

```js
Promise.race(promises);
```

> 传入一个Promise的数组，第一个完成的Promise的结果，就是最终结果



## 异常穿透

```js
let p1 = new Promise((resolve, reject) => {
    throw 'error';
});

p1.then(value => {
    console.log(111);
}).then(value => {
    console.log(222);
}).then(value => {
    console.log(333);
}).catch(reason => {
    console.warn(reason);
});
```



## 中断Promise链

```js
p1.then(value => {
    console.log(111);
    return new Promise(() => {});
}).then(value => {
    console.log(222);
}).then(value => {
    console.log(333);
}).catch(reason => {
    console.warn(reason);
});
```

> 只有返回一个pending状态的Promise对象，才可以中断Promise链



## await和async

```js
btn.addEventListener('click',async function () {
   let a = await sendAJAX('xxxx');
   console.log(a);
});
```

> await必须写在async标识的函数中
>
> 用于直接获取右侧Promise对象的值

> 这样获取便于批量处理错误

```js
async function main(){
    try {
        let data1 = await readFile('./aaa.txt');
        let data2 = await readFile('./bbb.txt');
        let data3 = await readFile('./ccc.txt');
        console.log(data1 + data2 + data3);
    }catch (e) {
        console.log(e);
    }
}
```

