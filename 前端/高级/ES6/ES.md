# ES

## let

```js
let a;
let b,c,d;
let f = 123, g = "aaa" , h = [];
```

> let不能重复声明变量
>
> 块内let声明的变量，块外无效
>
> let声明变量不存在变量提升
>
> 不影响作用域链



## 结构赋值

```js
const F4 = ['小沈阳','刘能','赵四','宋小宝'];
let [xiao,liu,zhao,song] = F4;
```

```js
const ZHAO = {
    name: '赵本山',
    age: 50,
    xiaopin: function (){
        console.log('演小品')
    }
};

let {name,age,xiaopin} = ZHAO;
```

> 批量为各个变量依次赋值



## 模板字符串

```js
let str = `<ul>
                <li>1</li>
                <li>2</li>
                <li>3</li>
                <li>4</li>
           </ul>`
```

> 可以使用`来定义字符串
>
> 内容中可以直接出现换行符

```js
let name = '张三';
let show = `我是${name}`;
```

> 可以进行变量拼接



## 简化对象写法

```js
let name = '张三';
let age = 18;
let show = function (){
    console.log(name + age);
}

let person = {
    name,
    age,
    show
};

person.show();
```

> 在定义对象时，可以直接写变量

```js
let person = {
    eat(){
        console.log("吃饭");
    }
};
```

> 在方法声明时，可以直接这样写



## 箭头函数

```js
let fn = (a,b) => {
    return a + b;
}
```

> this是静态的，this始终执行函数声明时，所在作用域下的this的值

> 不能作为构造函数实例化对象

> 不能使用arguments



### 简写

```js
let add = n => {
    return n + n;
}
```

> 省略小括号，当形参有且仅有一个时

```js
let pow = n => n * n;
```

> 省略花括号，当代码体只有一条语句时



### 案例

```js
//点击div，2s后改变颜色为粉色
let d1 = document.getElementById('d1');

d1.addEventListener("click",function (){
    let _this = this;
    setTimeout(function () {
        _this.style.background = 'pink';
    },2000);
});
```

```js
let d1 = document.getElementById('d1');

d1.addEventListener("click",function (){
    setTimeout(() => {
        this.style.background = 'pink';
    },2000);
});
```

> this是静态的，this始终执行函数声明时，所在作用域下的this的值

```js
//返回数组中偶数
const arr = [1,2,3,4,5,6,7,8,9];

let result = arr.filter(function (item) {
    if (item % 2 === 0){
        return true;
    }else {
        return false;
    }
});
```

```js
const arr = [1,2,3,4,5,6,7,8,9];

let result = arr.filter(item => item % 2 === 0);
```



### 使用说明

> 箭头函数适合于this无关的回调
>
> 不适合与this有关的回调，事件回调，对象的方法



## 函数初始值

> ES允许给函数参数赋初始值

```js
function add(a,b,c = 10) {
    return a + b + c;
}

add(1, 2);
```

```js
function connect({host = "127.0.0.1", username = "root", password = "root", port = 3306}) {
    console.log(host);
    console.log(username);
    console.log(password);
    console.log(port);
}
```

> 与结构赋值结合使用，达到默认值的效果



## rest参数

> ES6引入rest参数，用于获取函数实参，代替arguments

```js
function f(...args) {
    console.log(args);
}

f(1,2,3);
```

> rest参数，必须要放到最后



## 扩展运算符

> 将数组转换为逗号分割的参数序列

```js
const tfboys = ['易烊千玺','王俊凯','王源'];

function chunwan(){
    console.log(arguments);
}

chunwan(...tfboys);//chunwan('易烊千玺','王俊凯','王源')
```

### 应用

```js
const kuaizi = ['王太利','肖央'];
const fenghuang = ['曾毅','玲花'];

const arr = [...kuaizi,...fenghuang];//const arr = kuaizi.concat(fenghuang);
```

> 数组合并

```js
const a = ['a','b','c'];
const b = [...a];
```

> 数组克隆

```js
const divs = document.querySelectorAll('div');
const divArr = [...divs];
```

> 将伪数组转为真数组



## Symbol

> ES6引入了一种新的数据类型Symbol，表示独一无二的值

> Symbol的特点
>
> - Symbol的值是唯一的
> - Symbol的值不能与其他数据进行运算
> - Symbol定义的对象不能用for...in遍历，但可以使用Reflect.ownKeys来获取所有键名

```js
let s1 = Symbol();
let s2 = Symbol('aaa');
let s3 = Symbol('aaa');

console.log(s2 === s3); //false

let s4 = Symbol.for('aaa'); //创建Symbol对象
let s5 = Symbol.for('aaa');
console.log(s4 === s5); //true
```

### 使用场景

```js
let game = {
    ...
}

let methods = {
    up: Symbol(),
    down:Symbol()
}

game[methods.up] = function (){
    console.log("我可以向上");
}
game[methods.down] = function (){
    console.log("我可以向下");
}
```

> 可以向一个不确定的对象中添加方法，属性。以避免冲突

```js
let game = {
    name:'狼人杀',
    [Symbol('say')]:function (){
        console.log("我可以发言");
    },
    [Symbol('boom')]:function (){
        console.log("我可以自爆");
    }
}
```

### 内置属性

```js
class Person{
    static [Symbol.hasInstance](param){
        console.log(param);
        console.log("用来检测类型");
        return false;
    }
}

let o = {};
console.log(o instanceof Person);
```

> param在这里就是o
>
> 可以理解为这是重写了hasInstance方法，修改了默认判断实例的逻辑

```js
const arr = [1,2,3];
const arr2 = [4,5,6];
arr2[Symbol.isConcatSpreadable] = false;

console.log(arr.concat(arr2));
```

> Symbol.isConcatSpreadable，设置是否可以展开，这里不展开，就作为一个整体与arr合并

> 还有很多属性，都是用来控制对象的行为和表现



## 迭代器

> 任何数据结构只要部署Iterator接口，就可以完成遍历操作
>
> ES6使用for...of供Iterator接口消费

```js
const arr = [1,2,3,4];

for (let v of arr) {
    console.log(v);
}
```

> for in循环，变量保存的是键名
>
> for of循环，变量保存的是键值

```js
const emp = {
    dept: '研发部',
    name:[
        '张三',
        '李四',
        '王五',
        '赵六'
    ],
    [Symbol.iterator](){
        let index = 0;
        let _this = this;
        return {
            next: function (){
                if (index < _this.name.length){
                    let result = { value:_this.name[index], done:false };
                    index++;
                    return result;
                } else {
                    return { value: undefined, done:true };
                }
            }
        }
    }
}

for (let v of emp) {
    console.log(v);
}
```

> 自定义一个迭代器



## 生成器

> ES6提供了一种异步编程解决方案
>
> 生成器是一种特殊的函数，用来做异步编程

```js
function * gen(){
    console.log(111);
    yield '分割1';
    console.log(222);
    yield '分割2';
    console.log(333);
    yield '分割3';
    console.log(444);
}

let iterator = gen();
iterator.next();	//111
iterator.next();	//222
iterator.next();	//333
iterator.next();	//444
```

> 使用yield可以分割业务代码
>
> 调用迭代器的next方法来执行函数的某部分

```js
function * gen(){
    yield '分割1';
    yield '分割2';
    yield '分割3';
}

for (let v of gen()) {
    console.log(v);
}

/*
分割1
分割2
分割3
*/
```

```js
function * gen(arg){
    console.log(arg);
    let one = yield 111;
    console.log(one);
    let two = yield 222;
    console.log(two);
    let three = yield 333;
    console.log(three);
}

let iterator = gen('AAA');
console.log(iterator.next());
console.log(iterator.next('BBB'));
console.log(iterator.next('CCC'));
console.log(iterator.next('DDD'));
```

> next中可以传入参数，该参数为上一个yield的返回值

### 案例

> 1s 后输出 111
>
> 再等2s 后输出 222
>
> 再等3s 后输出 333

```js
function one(){
    setTimeout(() => {
        console.log(111);
        iterator.next();
    },1000);
}
function two(){
    setTimeout(() => {
        console.log(222);
        iterator.next();
    },2000);
}
function three(){
    setTimeout(() => {
        console.log(333);
        iterator.next();
    },3000);
}

function * gen(){
    yield one();
    yield two();
    yield three();
}

let iterator = gen();
iterator.next();
```

### 案例2

```js
function getUsers(){
    setTimeout(() => {
        let data = '用户数据';
        iterator.next(data);
    },1000);
}
function getOrders(){
    setTimeout(() => {
        let data = '订单数据';
        iterator.next(data);
    },1000);
}
function getGoods(){
    setTimeout(() => {
        let data = '商品数据';
        iterator.next(data);
    },1000);
}

function * gen(){
    let user = yield getUsers();
    console.log(user);
    let order = yield getOrders();
    console.log(order);
    let goods = yield getGoods();
    console.log(goods);
}

let iterator = gen();
iterator.next();
```

> 在异步调用用户数据，订单数据，商品数据时，将他们的结果可以传递给下一环



## SET

```js
let s = new Set();
let s2 = new Set(['a','b','c']);

s2.add('d');
s2.delete('b');

console.log(s2);

console.log(s2.has('a'));

// s2.clear();

for (let v of s2){
    console.log(v);
}
```



## MAP

```js
let m = new Map();

m.set('name','zhangsan');
m.set('age',18);

m.delete('age');

console.log(m.size);
console.log(m.get('name'));

for (let v of m){
    console.log(v);
}
```



## Class

```js
class Phone{
    constructor(brand,price) {
        this.brand = brand;
        this.price = price;
    }

    call(){
        console.log('打电话');
    }
}

let onePlus = new Phone('onePlus',4999);
```

```js
class Phone{
    constructor(brand,price) {
        this.brand = brand;
        this.price = price;
    }

    call(){
        console.log('打电话');
    }
}

class SmartPhone extends Phone{
    constructor(brand,price,color,size) {
        super(brand,price);
        this.color = color;
        this.size = size;
    }

    photo(){
        console.log('拍照');
    }

    game(){
        console.log('玩游戏');
    }
}
```



## 模块化

> export：对外接口
>
> inport：导入其他模块

```js
export let str = '123';
export function f1() {
    console.log('f1');
}
```

```html
<script type="module">
    import * as m1 from "./1.js";

    console.log(m1);
</script>
```



### 暴露方式

> 除了上面这种，在前面加export

```js
let str = '123';
function f1() {
    console.log('f1');
}

export {str,f1};
```

```js
export default {
    str: '123',
    f1: function (){
        console.log('f1');
    }
}
```



### 引入方式

> 除了上面的这种，import * as m1 from "./1.js";

```js
import {str,f1} from "./1.js";
```

```js
import a from "./1.js";
```

> 注意，import a from "./1.js";
>
> 只能用于上面暴露方式中的最后一种

