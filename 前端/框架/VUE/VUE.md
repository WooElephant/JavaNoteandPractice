# VUE

> Vue是一套用于**构建用户界面**的**渐进式**JavaScript框架

> Vue的特点：
>
> 1. 采用组件化模式，提高代码复用率，且让代码更好维护
> 2. 声明式编码，让编码人员无需直接操作DOM，提高开发效率
> 3. 使用虚拟DOM+优秀的Diff算法，尽量复用DOM节点



## Hello World

```html
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>01</title>
    <!--引入VUE-->
    <script type="text/javascript" src="../js/vue.js"></script>

</head>
<body>
    <!--准备一个容器-->
    <div id="root">
        <h1>Hello,{{name}}</h1>
    </div>

    <script type="text/javascript">
        Vue.config.productionTip = false;

        //创建VUE实例
        new Vue({
            el:'#root',  //el用于指定当前Vue实例，为哪个容器服务，值通常为css选择器字符串
            data:{  //用于存储数据，供el指定的容器使用，值暂时先写成一个对象
                name:'张三'
            }
        });
    </script>
</body>
</html>
```

> 想让Vue工作，就必须创建Vue实例，且要传入一个配置对象
>
> root容器里的代码依然符合html规范，只不过混入了Vue语法
>
> root容器里的代码被称为Vue模板

> 容器和Vue实例是一一对应的
>
> 如果多个容器class属性是一致的，Vue实例使用class选择器，只会对第一个生效
>
> 如果一个容器被多个Vue实例选择，只有一个Vue实例会生效
>
> 真实开发中只有一个Vue实例，配合组件一起使用

> 双大括号中除了可以写data中的属性和方法外，还可以写js表达式



## Vue核心

### 模板语法

#### 插值语法

> 我们在Hello World的例子中已经了解过双大括号，称作插值语法

```vue
<div id="root">
    <h1>插值语法</h1>
    <h3>你好，{{name}}</h3>
    <hr/>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    new Vue({
        el:'#root',
        data:{
            name:'张三'
        }
    });
</script>
```

#### 指令语法

```vue
<div id="root">
    <h1>指令语法</h1>
    <a v-bind:href="url">点我去百度</a>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    new Vue({
        el:'#root',
        data:{
            url:'http://www.baidu.com'
        }
    });
</script>
```

```vue
<a v-bind:href="url">点我去百度</a>
<a :href="url">点我去百度</a>
```

>  v-bind: 可以简写为 ：

> 会将属性中的值，变为js表达式，动态取data定义中的变量

#### 总结

> 插值语法用于解析标签体内容
>
> 指令语法用于解析标签



### 数据绑定

```vue
<div id="root">
    单向数据绑定：<input type="text" v-bind:value="name"/><br/>
    双向数据绑定：<input type="text" v-model:value="name"/>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    new Vue({
        el:'#root',
        data:{
            name:'张三'
        }
    });
</script>
```

> v-model: 可以实现双向数据绑定
>
> v-bind: 是单向数据绑定

> v-model: 只可以用在表单类元素上，以捕获用户输入，不然就没有意义

> 由于v-model: 收集的就是value值，所以可以简写
>
> ```vue
> <input type="text" v-model:value="name"/>
> <input type="text" v-model="name"/>
> ```



### el与data两种写法

```js
const v = new Vue({
    data:function () {  //data第二种写法，函数式写法，返回一个对象
        return{
            name:'张三'
        }
    }
});

v.$mount('#root');  //el的第二种写法
```



### MVVM模型

> M：model，对应data中的数据
>
> V：view，模板（也就是被绑定的dom对象）
>
> VM：ViewModel，Vue实例对象



### 数据代理

> 通过一个对象，代理对另一个对象中属性的操作

#### Object.defineproperty

```js
let person = {
    name: '张三',
    gender: '男'
}

Object.defineProperty(person,'age',{
    value: 18,
    enumerable: true,   //控制属性是否可以枚举，默认false
    writable: true,     //控制属性是否可以修改，默认false
    configurable: true  //控制属性是否可以删除，默认false
});
```

```js
let number = 18;

let person = {
    name: '张三',
    gender: '男'
}

Object.defineProperty(person,'age',{
    get(){
        return number;
    },
    set(value){
        number = value;
    }
});
```

> 可以通过Object.defineproperty 的getter和setter，为数据与变量进行绑定
>
> 这是ES中的方式



#### Vue中数据代理

```vue
<div id="root">
    <h1>名称：{{name}}</h1>
    <h1>年龄：{{age}}</h1>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            name:'张三',
            age:18
        }
    });

</script>
```

> 其实在获取和修改name，age时，也是通过getter和setter访问data中的name和age
>
> 此data在vm中封装的对象为_data（不准确，其实保存的是数据劫持）



### 事件处理

```vue
<div id="root">
    <h1>名称：{{name}}</h1>
    <button v-on:click="show">点我</button>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            name:'张三',
        },
        methods:{
            show(){
                alert('你好');
            }
        }
    });

</script>
```

> ```vue
> <button v-on:click="show">点我</button>
> <button @click="show">点我</button>
> ```
>
> v-on:可以简写为@

```vue
<div id="root">
    <h1>名称：{{name}}</h1>
    <button @click="show(100,$event)">点我</button>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            name:'张三',
        },
        methods:{
            show(number,event){
                alert(number);
            }
        }
    });

</script>
```

> 直接在方法名后面加括号，在括号内直接传参
>
> 如果只传参数，event对象将会丢失，需要将其明确写在参数内

#### 事件修饰符

```vue
<div id="root">
    <h1>名称：{{name}}</h1>
    <a href="http://www.baidu.com" @click.prevent="show">点我</a>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            name:'张三',
        },
        methods:{
            show(){
                alert(123);
            }
        }
    });
</script>
```

> 使用@click.prevent="show"
>
> prevent就是事件修饰符，用于阻止默认事件

> Vue中的事件修饰符
>
> prevent：阻止默认事件（常用）
>
> stop：阻止事件冒泡（常用）
>
> once：事件只触发一次（常用）
>
> capture：使用事件捕获模式
>
> self：只有event.target是当前操作的元素时，才触发事件
>
> passive：当事件的默认行为立即执行，无需等待事件回调执行完毕

```vue
<!--阻止事件冒泡-->
<div @click="show">
    <button @click.stop="show">点我</button>
</div>
```

```vue
<!--事件只触发一次-->
<button @click.once="show">点我</button>
```

```vue
<!--capture-->
<div class="box1" @click.capture="show(1)">
    div1
    <div class="box2" @click="show(2)">div2</div>
</div>
```

> 在事件捕获阶段就开始执行函数
>
> 普通情况下，是冒泡阶段开始执行，得到的结果是 2 1
>
> 如果改为捕获阶段，结果是 1 2

```vue
<!--self-->
<div @click.self="show">
    <button @click="show">点我</button>
</div>
```

```vue
<div id="root">
    <!--passive-->
    <ul @scroll.passive="demo" class="list">
        <li>1</li>
        <li>2</li>
        <li>3</li>
        <li>4</li>
    </ul>

</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        methods:{
            demo(){
                for (let i = 0; i < 10000; i++) {
                    console.log(i);
                }
            }
        }
    });
</script>
```

> 如果不使用passive，必须等到1万次循环结束，才会挪动滚动条

> 事件修饰符可以连写.stop.prevent



#### 键盘事件

```vue
<div id="root">
    <input type="text" placeholder="按下回车提示" @keyup.enter="show">

</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        methods:{
            show(e){
                console.log(e.target.value);
            }
        }
    });
</script>
```

> Vue为常用按键起了别名
>
> enter：回车
>
> delete：删除（delete键和退格键）
>
> esc：退出
>
> space：空格
>
> tab：制表符
>
> up，down，left，right：四个方向键

> 如果没有别名的按键，可以使用按键的名称，如果按键是两个单词（CapsLock需要写为caps-lock）

> 注意Tab键比较特殊，因为它自带切换焦点的功能，所以必须使用keydown来绑定，不然keyup的时候，焦点已经不在目标上了

> 还有四个按键比较特殊，ctrl，alt，shift，meta（win键）
>
> 因为他们经常与别的按键组合使用，是系统的修饰键
>
> 当它们绑定keyup，他们与别的按键按下后，别的按键松开才会触发
>
> 当绑定keydown，则正常触发

> 可以使用.ctrl.y表示只有ctrl和y一起按才有效



### 计算属性

```vue
<div id="root">
    姓：<input type="text" v-model="lastName"><br/><br/>
    名：<input type="text" v-model="firstName"><br/><br/>
    全名：<span>{{fullName}}</span>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            firstName:'三',
            lastName:'张'
        },
        computed:{
            fullName:{
                get(){
                    return this.lastName + '-' + this.firstName;
                }
            }
        }
    });
</script>
```

> 如果使用多次计算属性
>
> 不会执行get函数，而是从缓存中读取

> get调用时机
>
> 初次读取计算属性时，被调用
>
> 所依赖的数据发生变化时，被调用

> get中的this，已经被底层重新指向vue实例，所以可以直接获取data中的值

> set可以不写，大部分情况不会修改
>
> ```vue
> set(value){
>     const arr = value.split('-');
>     this.lastName = arr[0];
>     this.firstName = arr[1];
> }
> ```

> 如果不需要set可以使用简写

```vue
computed:{
    fullName() {
    	return this.lastName + '-' + this.firstName;
    }
}
```



### 监视属性

```vue
<div id="root">
    <h2>今天天气很{{weather}}</h2>
    <button @click="changeWeather">切换天气</button>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            isHot:true
        },
        computed:{
            weather(){
                return this.isHot ? '炎热' : '凉爽';
            }
        },
        methods:{
            changeWeather(){
                this.isHot = !this.isHot;
            }
        }
    });
</script>
```

> 点击按钮，使今天天气很炎热和今天天气很凉爽互相切换，这样写没有问题
>
> 其实ishot就是vm中的值，可以直接写在@click中
>
> ```vue
> <button @click="isHot = !isHot">切换天气</button>
> ```
> 但如果逻辑代码比较多，不建议这样用

```vue
<div id="root">
    <h2>今天天气很{{weather}}</h2>
    <button @click="changeWeather">切换天气</button>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            isHot:true
        },
        computed:{
            weather(){
                return this.isHot ? '炎热' : '凉爽';
            }
        },
        methods:{
            changeWeather(){
                this.isHot = !this.isHot;
            }
        },
        watch:{
            isHot:{
                handler(newValue,oldValue){
                    console.log('isHot被修改了，修改前：' + oldValue + ' 修改后：' + newValue);
                }
            }
        }
    });
</script>
```

> 可以使用watch进行属性的监视，监视属性的改变

```vue
watch:{
    immediate:true,
    isHot:{
        handler(newValue,oldValue){
            console.log('isHot被修改了，修改前：' + oldValue + ' 修改后：' + newValue);
        }
    }
}
```

> 在watch中加入immediate:true，表示在加载时，就让handler调用一次，默认是false

> watch也可以监视计算属性

```vue
vm.$watch('isHot',{
    handler(newValue,oldValue){
        console.log('isHot被修改了，修改前：' + oldValue + ' 修改后：' + newValue);
    }
});
```

> 也可以在Vue外部，定义watch

#### 深度监视

```vue
<div id="root">
    <h3>a的值：{{numbers.a}}</h3>
    <button @click="numbers.a++">点我让a+1</button>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            numbers:{
                a:1,
                b:2
            }
        },
        watch:{
            'numbers.a':{
                handler(){
                    console.log('a改变了');
                }
            }
        }
    });
</script>
```

> 我们之前watch中的变量没有加入引号，这其实是一种简写
>
> 如果涉及到层次结构，必须使用引号

> 如果numbers中有100个值，我怎么能全部监视呢

```vue
<div id="root">
    <h3>a的值：{{numbers.a}}</h3>
    <button @click="numbers.a++">点我让a+1</button>
    <h3>b的值：{{numbers.b}}</h3>
    <button @click="numbers.b++">点我让b+1</button>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            numbers:{
                a:1,
                b:2
            }
        },
        watch:{
            numbers:{
                deep:true,
                handler(){
                    console.log('numbers改变了');
                }
            }
        }
    });
</script>
```

> Vue中的watch默认不监视对象内部得改变
>
> 配置deep:true可以检测对象内部值的改变

#### 简写形式

```vue
watch:{
    isHot(newValue,oldValue){
        console.log('isHot被修改了，修改前：' + oldValue + ' 修改后：' + newValue);
    }
}
```

> 如果不需要额外的属性配置，可以这样简写

```vue
vm.$watch('isHot',function (newValue,oldValue) {
    console.log('isHot被修改了，修改前：' + oldValue + ' 修改后：' + newValue);
});
```

> 在Vue外部也可以这样简写



### 绑定样式

#### 绑定class样式

```vue
<div id="root">
    <div class="basic" :class="mood" @click="changeMood">{{name}}</div>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            name:'test',
            mood:'normal'
        },
        methods:{
            changeMood(){
                const arr = ['happy','normal','sad'];
                let index = Math.floor(Math.random()*3);
                this.mood = arr[index];
            }
        }
    });

</script>
```

> 适用于样式类名不确定，需要动态指定

```vue
<div id="root">
    <div class="basic" :class="arr">{{name}}</div>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            name:'test',
            mood:'normal',
            arr:['style1','style2','style3']
        }
    });

</script>
```

> 也可以写一个数组，这样适用于个数和样式都不确定，之后通过增减数组来操作样式

```vue
<div id="root">
    <div class="basic" :class="classObj">{{name}}</div>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            name:'test',
            classObj:{
                style1:false,
                style2:false
            }
        }
    });

</script>
```

> 也可以直接写一个对象，适用于样式确定，个数确定，名称确定。但要动态决定是否启用

#### 绑定style样式

```vue
<div id="root">
    <div class="basic" :style="styleObj">{{name}}</div>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            name:'test',
            styleObj:{
                fontSize:'80px',
                color:'red',
                backgroundColor:'orange'
            }
        }
    });

</script>
```



### 条件渲染

```vue
<div id="root">
    <h2 v-show="a">欢迎{{name}}</h2>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            name:'test',
            a:false
        }
    });
</script>
```

> 使用 v-show 指定一个布尔表达式，来控制内容是否显示

> 也可以使用 v-if 代替 v-show
>
> v-show保留结构，使用display:none来隐藏
>
> v-if连结构都不会显示

> v-if相应的也有v-else-if，v-else
>
> 如果v-if成立，v-else-if将不会执行
>
> 如果使用v-else-if，v-else，标签必须连续，中间不能有别的标签

> 如果要成组使用v-if，可以将他们包裹在template标签中，这样template标签，并不会渲染到页面
>
> 但是可以为其子标签设置v-if
>
> 使用template标签不能使用v-show，只能使用v-if



### 列表渲染

```vue
<div id="root">
    <ul>
        <li v-for="p in persons"  :key="p.id">{{p.name}}-{{p.age}}</li>
    </ul>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            persons:[
                {id:'001',name:'张三',age:18},
                {id:'002',name:'李四',age:19},
                {id:'003',name:'王五',age:20}
            ]
        }
    });
</script>
```

> 使用v-for遍历数据，自动生成
>
> 自动生成的标签，最好指定一下key，让其拥有唯一的标识符

```html
<li v-for="(p,index) in persons" :key="index">{{p.name}}-{{p.age}}</li>
```

> 循环可以接受两个参数，第一个是实际对象，第二个是index
>
> 我们也可以将index作为key

```vue
<div id="root">
    <ul>
        <li v-for="(value,key) in car" :key="key">{{key}}--{{value}}</li>
    </ul>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            car:{
                brand:'奥迪',
                price:'70万',
                color:'黑色'
            }
        }
    });
</script>
```

> 也可以遍历对象，第一个值为value，第二个值为key

> 也可以遍历字符串，第一个值为字符，第二个值为index

> 也可以遍历一个定值，比如(value,index) in 10 第一个是自然数，从1开始，第二个是index从零开始

#### key的原理

> Vue将数据遍历，生成虚拟dom，渲染到页面中
>
> 如果使用的是index，当往数组之前添加元素，它就会变为新的index = 0的第一个标签
>
> 虚拟dom会和之前虚拟dom做对比，仅仅只改了数据内容，如果此标签中含有其他内容
>
> 对比会发现没有变化，造成原来的0号元素的内部信息，被新的0号元素所使用
>
> 如果使用id作为key，id一定是唯一的，这样就能解决这个问题

> 如果插入的数据，打乱了原有的顺序，并且key用的还是index
>
> 那么从插入的位置，之后所有的对比都会发现和之前结果不一致，造成效率降低

#### 列表过滤

```vue
<div id="root">
    <input type="text" placeholder="请输入姓名" v-model="keyWord">
    <ul>
        <li v-for="p in filPersons" :key="p.id">{{p.name}}--{{p.age}}--{{p.gender}}</li>
    </ul>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            keyWord:'',
            persons:[
                {id:'001',name:'马冬梅',age:18,gender:'女'},
                {id:'002',name:'周冬雨',age:19,gender:'女'},
                {id:'003',name:'周杰伦',age:20,gender:'男'},
                {id:'004',name:'温兆伦',age:21,gender:'男'}
            ],
            filPersons:[]
        },
        watch:{
            keyWord:{
                immediate:true,
                handler(val){
                    this.filPersons = this.persons.filter((p) => {
                        return p.name.indexOf(val) !== -1;
                    })
                }
            }
        }
    });
</script>
```

> 使用watch监听keyWord，改变后，进行数组匹配，将匹配的结果显示在屏幕上
>
> 注意：字符串是包含空串的

```vue
<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            keyWord:'',
            persons:[
                {id:'001',name:'马冬梅',age:18,gender:'女'},
                {id:'002',name:'周冬雨',age:19,gender:'女'},
                {id:'003',name:'周杰伦',age:20,gender:'男'},
                {id:'004',name:'温兆伦',age:21,gender:'男'}
            ]
        },
        computed:{
            filPersons(){
                return this.persons.filter((p) => {
                    return p.name.indexOf(this.keyWord) !== -1;
                })
            }
        }
    });
</script>
```

> 也可以使用计算属性来获取

 

#### 列表排序

```vue
<div id="root">
    <input type="text" placeholder="请输入姓名" v-model="keyWord">
    <button @click="sortType = 2">年龄升序</button>
    <button @click="sortType = 1">年龄降序</button>
    <button @click="sortType = 0">原顺序</button>
    <ul>
        <li v-for="p in filPersons" :key="p.id">{{p.name}}--{{p.age}}--{{p.gender}}</li>
    </ul>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    const vm = new Vue({
        el:'#root',
        data:{
            keyWord:'',
            sortType:0,     //0原顺序，1降序，2升序
            persons:[
                {id:'001',name:'马冬梅',age:18,gender:'女'},
                {id:'002',name:'周冬雨',age:19,gender:'女'},
                {id:'003',name:'周杰伦',age:20,gender:'男'},
                {id:'004',name:'温兆伦',age:21,gender:'男'}
            ]
        },
        computed:{
            filPersons(){
                const arr = this.persons.filter((p) => {
                    return p.name.indexOf(this.keyWord) !== -1;
                });
                //判断sortType
                if (this.sortType){
                    arr.sort((p1,p2) => {
                        return this.sortType === 1 ? p2.age - p1.age : p1.age - p2.age;
                    })
                }
                return arr;
            }
        }
    });
</script>
```



### 监视数据原理

> Vue会使用set方法监视data中的数据，并做页面刷新的工作
>
> Vue会为data中的所有内容递归生成get set方法

> 如果新加入的数据需要Vue监视，需要使用set或者$set
>
> ```
> Vue.set(target，propertyName/index，value)
> vm.$set(target，propertyName/index，value)
> ```
> 注意此方法只可以给data中的对象加属性，不允许给data根数据添加对象

> Vue对数组的监视略有不同，因为一般对数组的操作使用原生api的函数
>
> 所以刷新页面，和监视的工作，换到了这些原生api中
>
> Vue为这些原生api的函数，进行了二次包装来实现
>
> 这些api函数包括：push()、pop()、shift()、unshift()、splice()、sort()、reverse()
>
> 当然数组的修改也可以使用set来控制



### 收集表单数据

```vue
<div id="root">
    <form @submit.prevent="submitForm">
        <label>
            账号：
            <input type="text" v-model.trim="userInfo.account">
        </label><br><br>
        <label>
            密码：
            <input type="password" v-model="userInfo.password">
        </label><br><br>
        <label>
            年龄：
            <input type="number" v-model.number="userInfo.age">
        </label><br><br>
        性别：
        <label>
            男
            <input type="radio" name="gender" value="男" v-model="userInfo.gender">
        </label>
        <label>
            女
            <input type="radio" name="gender" value="女" v-model="userInfo.gender">
        </label><br><br>
        爱好：
        <label>学习<input type="checkbox" value="学习" v-model="userInfo.hobby"></label>
        <label>打游戏<input type="checkbox" value="打游戏" v-model="userInfo.hobby"></label>
        <label>吃饭<input type="checkbox" value="吃饭" v-model="userInfo.hobby"></label><br><br>
        <label>
            国籍：
            <select v-model="userInfo.nation">
                <option value="china">中国</option>
                <option value="American">美国</option>
            </select>
        </label><br><br>
        <label>
            其他信息：
            <textarea v-model.lazy="userInfo.other"></textarea>
        </label><br><br>
        <label>
            <input type="checkbox" v-model="userInfo.agree">
            阅读并接受<a href="02.html">《用户协议》</a>
        </label><br><br>
        <button>提交</button>
    </form>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    new Vue({
        el:'#root',
        data:{
            userInfo:{
                account:'',
                password:'',
                gender:'',
                hobby:[],
                nation:'',
                other:'',
                agree:'',
                age:'',
            }
        },
        methods:{
            submitForm(){
                console.log(JSON.stringify(this.userInfo));
            }
        }

    })
</script>
```

> v-model.lazy	当标签失去焦点后再更新数据
>
> v-model.number	只收集数字部分，并且属性收到的值也是数字类型



### 过滤器

> 比如现在我们需要格式化时间显示，可以简单的使用第三方库dayjs

```vue
<div id="root">
    <h1>现在是：{{fmtTime}}</h1>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    new Vue({
        el:'#root',
        data:{
            time:Date.now()
        },
        computed:{
            fmtTime(){
                return dayjs(this.time).format('YYYY-MM-DD HH:mm:ss');
            }
        }
    })
</script>
```

> 也可以使用Vue的过滤器，配合第三方库

```vue
<div id="root">
    <h1>现在是：{{time | timeFormatter('YYYY-MM-DD') | mySlice}}</h1>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    new Vue({
        el:'#root',
        data:{
            time:Date.now()
        },
        filters:{
            timeFormatter(value,str='YYYY-MM-DD HH:mm:ss'){
                return dayjs(value).format(str);
            },
            mySlice(value){
                return value.slice(0,4);
            }
        }
    })
</script>
```

> 如果不传参，默认会接受到过滤器前的值
>
> 如果传参，第一个参数是过滤器前的值，第二个参数是指定的值
>
> 也可以直接为参数指定默认值

> 多个过滤器可以串联写

```vue
<script type="text/javascript">
    Vue.config.productionTip = false;
    Vue.filter('mySlice',function (value) {
        return value.slice(0,4);
    })

    new Vue({
        el:'#root',
        data:{
            time:Date.now()
        },
        filters:{
            timeFormatter(value,str='YYYY-MM-DD HH:mm:ss'){
                return dayjs(value).format(str);
            }
        }
    })
</script>
```

> 也可以这样定义全局的过滤器

> 过滤器还可以用在标签属性绑定上



### 其他常用内置指令

> 我们已经了解的内置指令
>
> v-bind	单向绑定
>
> v-model	双向绑定
>
> v-for	遍历数组，对象，字符串
>
> v-on	绑定时间，简写为@
>
> v-if，v-else，v-show	条件渲染

#### v-text

```vue
<div id="root">
    <div v-text="name"></div>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    new Vue({
        el:'#root',
        data:{
            name:'123'
        }
    })
</script>
```

> 可以替换掉整个标签中的内容

#### v-html

```vue
<div id="root">
    <div v-html="name"></div>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    new Vue({
        el:'#root',
        data:{
            name:'<h1>123</h1>'
        }
    })
</script>
```

> 可以解析字符串中的结构，添加到指定标签内部
>
> 但一般不会这样做，这样做会有安全性问题

#### v-cloak

```html
<head>
    <meta charset="UTF-8">
    <title>01</title>
    <style>
        [v-cloak]{
            display: none;
        }
    </style>
</head>
<body>
    <div id="root">
        <div v-cloak>{{name}}</div>
    </div>

    <script type="text/javascript">
        Vue.config.productionTip = false;

        new Vue({
            el:'#root',
            data:{
                name:'123'
            }
        })
    </script>
    <script type="text/javascript" src="../js/vue.js"></script>
</body>
```

> 如果在网络加载有延迟的情况下，没有加载好vue.js，也就无法完成插值语法赋值
>
> 这时候页面中就会显示{{name}}这种东西，当vue.js引入完成的一瞬间，这些插值语法会被vue替换掉
>
> 我们不想出现这种页面闪烁
>
> 在插值语法标签加入v-cloak属性，这个属性在vue加载完成时会被删掉
>
> 结合css属性选择器，不显示v-cloak属性的标签，即可做到，vue加载完成再显示

#### v-once

```vue
<div id="root">
    <h1 v-once>n初始的值为：{{n}}</h1>
    <h1>n现在的值为：{{n}}</h1>
    <button @click="n++">点我n+1</button>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    new Vue({
        el:'#root',
        data:{
            n:1024
        }
    })
</script>
```

> v-once所在的节点初次动态渲染后，就视为静态内容，以后数据的改变不会引起其更新

#### v-pre

> v-pre指令可以跳过当前节点编译过程，加快编译速度



### 自定义指令

#### 函数式

```vue
<div id="root">
    <h1>n现在的值为：{{n}}</h1>
    <h1>n的10倍值为：<span v-big="n"></span></h1>
    <button @click="n++">点我n+1</button>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    new Vue({
        el:'#root',
        data:{
            n:1024
        },
        directives:{
            big(element,binding) {
                element.innerText = binding.value * 10;
            }
        }
    })
</script>
```

> 该函数常用有两个参数，第一个为当前节点dom对象，第二个为v-big绑定的对象

> big函数何时调用
>
> - 指令与元素成功绑定时
> - 指令所在的模板被重新解析时

#### 对象式

```vue
<div id="root">
    <input type="text" v-fbind:value="n">
    <button @click="n++">n+1</button>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    new Vue({
        el:'#root',
        data:{
            n:1024
        },
        directives:{
            fbind(element,binding){
                element.value = binding.value
                element.focus();
            }
        }
    })
</script>
```

> 这样进行获取焦点是不行的，因为第一次调用时绑定时，绑定时标签仅存在于模板中，页面中并没有输入框所以不可以获取焦点

```js
directives:{
    fbind:{
        //绑定成功时调用
        bind(element,binding){
            element.value = binding.value;
        },
        //元素插入页面时调用
        inserted(element,binding){
            element.focus();
        },
        //模板被重新解析时调用
        update(element,binding){
            element.value = binding.value;
        }
    }
}
```

> 所以要写成对象的形式，可以在不同时间点，调用不同的函数

#### 注意事项

> 指令命名不能使用驼峰命名，推荐使用引号包裹，单词之间用 - 隔开

> 指令函数中的this是window而不是vm

```vue
Vue.directive(fbind,{
    bind(element,binding){
        element.value = binding.value;
    },
    inserted(element,binding){
        element.focus();
    },
    update(element,binding){
        element.value = binding.value;
    }
});
```

> 之前定义的都是局部指令，需要全局指令，需要这样写



### 生命周期

```vue
![lifecycle](C:\Users\augus\Desktop\lifecycle.png)![lifecycle](C:\Users\augus\Desktop\lifecycle.png)<div id="root">
    <h1 :style="{opacity: opacity}">Vue</h1>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;


    const vm = new Vue({
        el:'#root',
        data:{
            opacity: 1
        },
        mounted(){
            setInterval(() => {
                if (vm.opacity >= 0){
                    vm.opacity -= 0.01;
                }else {
                    vm.opacity = 1;
                }
            },16);
        }
    });

</script>
```

> Vue给我们提供了mounted方法，在Vue完成模板的解析，并把**初始的**真实DOM元素放入页面后，调用mounted

> 类似于mounted函数，在别的不同时刻也有特定的函数调用。这些函数称为生命周期回调函数，又称生命周期钩子

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\前端\框架\VUE\VUE.assets\生命周期.png)

> 如官网此图所示，展示了Vue实例的完整生命周期
>
> 红框白底红字，则显示了每个节点回调的生命周期函数

> 常用的生命周期钩子：
>
> 1. mounted: 发送ajax请求、启动定时器、绑定自定义事件、订阅消息等【初始化操作】
> 2. beforeDestroy: 清除定时器、解绑自定义事件、取消订阅消息等【收尾工作】

> 关于销毁Vue实例
>
> - 销毁后借助Vue开发者工具看不到任何信息
> - 销毁后自定义事件会失效，但原生DOM事件依然有效
> - 一般不会在beforeDestroy操作数据，因为即便操作数据，也不会再触发更新流程了



## Vue组件化编程

> 组件是实现应用中局部功能代码和资源的集合

### 非单文件组件

> 一个文件中包含n个组件
>
> 这种方式不常用

```vue
<div id="root">
    <!--编写组件标签-->
    <School></School>
    <hr>
    <Student></Student>
</div>

<script type="text/javascript">
    Vue.config.productionTip = false;

    //创建school组件
    const school = Vue.extend({
        template:`
          <div>
              <h2>学校名称：{{schoolName}}</h2>
              <h2>学校地址：{{address}}</h2>
          </div>
        `,
        data(){
            return{
                schoolName:'xxx',
                address:'北京'
            }
        }
    });

    //创建student组件
    const student = Vue.extend({
        template:`
          <div>
              <h2>学生姓名：{{studentName}}</h2>
              <h2>学生年龄：{{age}}</h2>
          </div>
        `,
        data(){
            return{
                studentName:'张三',
                age:18
            }
        }
    });

    //注册组件
    new Vue({
        el:'#root',
        components:{
            School:school,
            Student:student
        }
    });



</script>
```

```vue
const hello = Vue.extend({
    template:`
        <div>
            <h2>你好！{{name}}</h2>
        </div>
    `,
    data(){
        return{
            name:'李四'
        }
    }
});

Vue.component('hello',Hello);
```

> 也可以这样注册全局组件

#### 注意事项

> 组件名是单个单词推荐使用首字母大写
>
> 如果是多个单词，使用引号包裹，单词之间使用 - 分割
>
> 或者在脚手架环境中使用驼峰命名，并且首字母大写

```vue
//创建student组件
const student = Vue.extend({
    name:'haha',
    template:`
      <div>
          <h2>学生姓名：{{studentName}}</h2>
          <h2>学生年龄：{{age}}</h2>
      </div>
    `,
    data(){
        return{
            studentName:'张三',
            age:18
        }
    }
});
```

> 创建组件时使用name属性为组件在Vue开发者工具中的命名

> 组件标签写成\<Student>\</Student>
>
> 仅在脚手架环境中可以写成\</Student>

```vue
//创建student组件
const student = {
    name:'haha',
    template:`
      <div>
          <h2>学生姓名：{{studentName}}</h2>
          <h2>学生年龄：{{age}}</h2>
      </div>
    `,
    data(){
        return{
            studentName:'张三',
            age:18
        }
    }
}
```

> 创建组件可以省略Vue.extend()
>
> 在该组件被引用时，会自动加入Vue.extend()

#### 组件的嵌套

```vue
<div id="root">

 </div>

 <script type="text/javascript">
     Vue.config.productionTip = false;

     //定义student组件
     const student = Vue.extend({
         name:'student',
         template:`
           <div>
              <h2>学生姓名：{{name}}</h2>
              <h2>学生年龄：{{age}}</h2>
           </div>
        `,
         data(){
             return {
                 name:'张三',
                 age:18
             }
         }
     })

     //定义school组件
     const school = Vue.extend({
         name:'school',
         template:`
           <div>
              <h2>学校名称：{{name}}</h2>
              <h2>学校地址：{{address}}</h2>
              <student></student>
           </div>
        `,
         data(){
             return {
                 name:'xxx',
                 address:'北京'
             }
         },
         //注册组件（局部）
         components:{
             student
         }
     })

     //定义hello组件
     const hello = Vue.extend({
         template:`
           <h1>{{msg}}</h1>
         `,
         data(){
             return {
                 msg:'欢迎来到xxx学习！'
             }
         }
     })

     //定义app组件
     const app = Vue.extend({
         template:`
           <div>
              <hello></hello>
              <school></school>
           </div>
        `,
         components:{
             school,
             hello
         }
     })

     //创建vm
     new Vue({
         template:`
           <app></app>
         `,
         el:'#root',
         //注册组件（局部）
         components:{app}
     })

 </script>
```

#### VueComponent

> 组件本质是一个名为VueComponent的构造函数，且不是程序员定义的，是Vue.extend生成的

> 我们只需要写\<school/>或\<school>\</school>
>
> Vue解析时会帮我们创建school组件的实例对象，即Vue帮我们执行的：new VueComponent(options)

> 特别注意：每次调用Vue.extend，返回的都是一个全新的VueComponent！！！！

> 关于this指向：
>
> - 组件配置中：它们的this是【VueComponent实例对象】
> - new Vue(options)配置中：它们的this是【Vue实例对象】

> - VueComponent的实例对象，以后简称vc（也可称之为：组件实例对象）
> - Vue的实例对象，以后简称vm

#### 内置关系

> 因为组件是可复用的Vue实例，所以他们与new Vue接收相同的选项，仅有的例外是像el这样实例特有的选项

>  VueComponent.prototype.\__proto__ === Vue.prototype
>
> 让组件实例对象（vc）可以访问到 Vue 原型上的属性、方法



### 单文件组件

```vue
<template>
  <!--组件的结构-->
</template>

<script>
  //组件交互的代码
</script>

<style>
  /*组件的样式*/
</style>
```

> 在一个vue文件中可以使用这三个标签

```vue
<template>
  <div class="demo">
    <h2>学校名称:{{name}}</h2>
    <h2>学校地址:{{address}}</h2>
    <button @click="showName">点我提示学校名</button>
  </div>
</template>

<script>
  export default {
    name:'School',
    data(){
      return {
        name:'xxx',
        address:'北京'
      }
    },
    methods:{
      showName(){
        alert(this.name);
      }
    }
  }
</script>

<style>
  .demo{
    background-color: orange;
  }
</style>
```

```vue
<template>
  <div class="demo">
    <h2>学生姓名:{{name}}</h2>
    <h2>学生年龄:{{age}}</h2>
  </div>
</template>

<script>
  export default {
    name:'Student',
    data(){
      return {
        name:'张三',
        age:18
      }
    }
  }
</script>
```

```vue
<template>
  <div>
    <School></School>
    <Student></Student>
  </div>
</template>

<script>
  import School from "./School";
  import Student from "./Student";

  export default {
    name:'App',
    components:{
      School,
      Student
    }
  }
</script>
```

> 设置Student，School，App组件

```js
import App from "./App";

new Vue({
    el:'#root',
    components:{App},
    template:`<App></App>`
});
```

> 再创建一个main.js用于建立Vue实例

```html
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>index</title>
</head>
<body>
    <div id="root"></div>
    <script type="text/javascript" src="../js/vue.js"></script>
    <script type="text/javascript" src="./main.js"></script>
</body>
</html>
```

> 构建一个html用来显示

> 到目前为止已经写完了一个模块，但是并不能在浏览器中运行
>
> 我们需要在脚手架中运行



## 脚手架

> Vue脚手架是Vue官方提供的标准化开发工具
>
> 脚手架CLI（Command Line Interface）

> 使用命令安装
>
> npm install -g @vue/cli

> 注意有没有切换npm的镜像地址
>
> npm config set registry http://registry.npm.taobao.org

> 在要创建项目的目录中执行
>
> vue create xxxx

> 在创建出的项目目录中执行
>
> npm run serve	开启一个服务器运行脚手架中内容
>
> npm run build	将脚手架内容编译为常规html，css，js等

> src目录下存放我们的代码
>
> - main.js是整个程序的入口
> - app.vue是所有模块的父级
> - components文件夹中放所有的子组件
> - assets文件夹中放所有的静态资源
>
> public中存放html和favicon

```html
 <!DOCTYPE html>
<html lang="">
  <head>
    <meta charset="utf-8">
		<!-- 针对IE浏览器的一个特殊配置，含义是让IE浏览器以最高的渲染级别渲染页面 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
		<!-- 开启移动端的理想视口 -->
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
		<!-- 配置页签图标 -->
    <link rel="icon" href="<%= BASE_URL %>favicon.ico">
		<!-- 引入第三方样式 -->
		<link rel="stylesheet" href="<%= BASE_URL %>css/bootstrap.css">
		<!-- 配置网页标题 -->
    <title>硅谷系统</title>
  </head>
  <body>
    <!-- 当浏览器不支持js时noscript中的元素就会被渲染 -->
    <noscript>
      <strong>We're sorry but <%= htmlWebpackPlugin.options.title %> doesn't work properly without JavaScript enabled. Please enable it to continue.</strong>
    </noscript>
    <!-- 容器 -->
    <div id="app"></div>
    <!-- built files will be auto injected -->
  </body>
</html>
```

### render函数

```js
import Vue from 'vue'
import App from './App.vue'

Vue.config.productionTip = false

new Vue({
  render: h => h(App),
}).$mount('#app')
```

> 这是Vue Cli帮我们生成的main.js

```js
import App from "./App";

new Vue({
    el:'#root',
    components:{App},
    template:`<App></App>`
});
```

> 这是我们自己写的main.js

> 如果按照我们的写法，会报错，因为生成的main.js中引入的Vue并不是完整的
>
> 在这个js中残缺了Vue的模板解析器
>
> 要么将import Vue from 'vue'
>
> 改写为import Vue from 'vue/dist/vue'
>
> 引入完整版Vue

> 另一个解决方案就是使用render函数
>
> Vue会调用render函数，传入createElement参数，使用这个参数可以创建具体的元素
>
> 所以 render: h => h(App) 这样就是渲染App模块中的所有元素

> 当我们将Vue模块最终编译为html，css，js等文件时，模板解析器就有些浪费空间



### 修改默认配置

> 在项目目录中创建vue.config.js文件
>
> 在官网查到需要改的属性，将其复制进这个文件，删除不需要修改的值，并修改需要修改应的值



### ref属性

```vue
<template>
	<div>
		<h1 v-text="msg" ref="title"></h1>
		<button ref="btn" @click="showDOM">点我输出上方的DOM元素</button>
		<School ref="sch"/>
	</div>
</template>

<script>
	import School from './components/School'

	export default {
		name:'App',
		components:{School},
		data() {
			return {
				msg:'欢迎学习Vue！'
			}
		},
		methods: {
			showDOM(){
				console.log(this.$refs.title) //真实DOM元素
				console.log(this.$refs.btn) //真实DOM元素
				console.log(this.$refs.sch) //School组件的实例对象（vc）
			}
		},
	}
</script>
```

> ref属性用来给元素或子组件注册引用信息（替代id）
>
> 应用在html标签上，获取真实DOM元素
>
> 应用在组件标签上，获取组件实例对象



### props配置项

```vue
<template>
  <div>
    <h2>学生姓名:{{name}}</h2>
    <h2>学生年龄:{{age}}</h2>
  </div>
</template>

<script>
  export default {
    name:'Student',
    props:['name','age']
  }
</script>
```

```vue
<template>
  <div id="app">
    <Student name="李四" age="18"></Student>
  </div>
</template>

<script>
  import Student from "./components/Student";

  export default {
    name:'App',
    components:{
      Student
    }
  }
</script>
```

> 我们在Student中不写数据具体的值，而是使用props:['name','age']
>
> 这样可以在外层App中，直接对子模块标签进行属性传递

```vue
props:{
  name:String,
  age:Number
}
```

> 也可以为props中每一个值指定具体类型限制
>
> \<Student name="李四" age="18">\</Student>
>
> \<Student name="李四" :age="18">\</Student>
>
> 这样age在传入时就应该带前冒号，由字符串变为表达式

```vue
props:{
  name:{
    type:String,
    required:true
  },
  age:{
    type:Number,
    default:99
  }
}
```

> 也可以写的更加详细

> 传入的数据是不建议进行更改的，如果非得更改可以在data中使用
>
> myAge = this.age
>
> 再修改myAge的值



### 混入

```js
export const mixin = {
    methods:{
        showName(){
            alert(this.name);
        }
    }
}
```

> 定义一个mixin.js的文件保存重复编写的方法

```vue
<template>
  <div>
    <h2 @click="showName">学生姓名:{{name}}</h2>
    <h2>学生年龄:{{age}}</h2>
  </div>
</template>

<script>
  import {mixin} from '../mixin';

  export default {
    name:'Student',
    data(){
      return {
        name:'张三',
        age:18
      }
    },
    mixins:[mixin]
  }
</script>
```

> 在Student中直接引入这个js文件
>
> 并且使用mixins关键字，注册该混合

> 混合中如果定义的内容，如果与模块中的内容重复，优先以模块中为主
>
> 但是钩子是例外，钩子都会生效

```js
import {mixin} from "./mixin";

Vue.mixin(mixin);
```

> 也可以在main.js中使用这种方法进行全局混合



### 插件

> 创建plugins.js文件
>
> 插件必须含有install方法

```js
export default {
    install(){
        console.log('install');
    }
}
```

> 在main.js中引入此插件

```js
import plugins from "./plugins";

Vue.use(plugins);
```

> install方法可以获取一个参数，该参数为Vue的构造函数

```js
export default {
	install(Vue){
		//全局过滤器
		Vue.filter('mySlice',function(value){
			return value.slice(0,4)
		})

		//定义全局指令
		Vue.directive('fbind',{
			//指令与元素成功绑定时（一上来）
			bind(element,binding){
				element.value = binding.value
			},
			//指令所在元素被插入页面时
			inserted(element,binding){
				element.focus()
			},
			//指令所在的模板被重新解析时
			update(element,binding){
				element.value = binding.value
			}
		})

		//定义混入
		Vue.mixin({
			data() {
				return {
					x:100,
					y:200
				}
			},
		})

		//给Vue原型上添加一个方法（vm和vc就都能用了）
		Vue.prototype.hello = ()=>{alert('你好啊')}
	}
}
```

> 在其中就可以做很多使用全局定义的功能

> install，在第一个参数之后还可以继续传参，在Vue.use(plugins);之后继续添加需要的参数，并在install中使用



### scoped样式

> 各个模块所使用的style标签中的css最终会被合并，也就是同名的内容会被最后一个引入的覆盖掉

```vue
<template>
  <div class="demo">
    <h2>学校名称：{{name}}</h2>
    <h2>学校地址：{{address}}</h2>
  </div>
</template>

<script>

export default {
  name:'School',
  data() {
    return {
      name:'xxx',
      address:'北京'
    }
  }
}
</script>

<style scoped>
  .demo{
    background-color: orange;
  }
</style>
```

> 只需要在style后面加入scoped，则可以让其仅对当前模块生效
>
> 原理是，对当前的template的根元素标签上增加了一个属性

> 一般来说App中不使用style scoped，不然仅对其子标签生效，但是App是包含其他子模块的，一般不会有子标签
>
> 而且定义在App style中的css我们希望它能全局生效，才会写在这里

> Vue可以在style标签中写less，需要使用\<style lang="less">
>
> 需要我们按照less-loader
>
> 因为Vue脚手架使用的是webpack 4.46版，而最新的less-loader使用的是webpack 5版本
>
> 所以在安装时候要注意，使用npm i less-loader@7
>
> 安装低版本的less-loader



### Todo-list案例

> 模拟待办事项
>
> 需求，输入待办事项，会被添加到列表中
>
> 每一项打钩，底部会统计已完成的数量
>
> 也会动态统计全部事项的数量
>
> 实现全选，全不选的操作
>
> 实现删除所选完成事项



#### 框架

```vue
<template>
  <div id="root">
		<div class="todo-container">
			<div class="todo-wrap">
				<MyHeader/>
				<MyList/>
				<MyFooter/>
			</div>
		</div>
	</div>
</template>

<script>
  import MyHeader from './components/MyHeader';
  import MyList from './components/MyList';
  import MyFooter from './components/MyFooter';

  export default {
    name: 'App',
    components:{MyHeader,MyList,MyFooter}
  }
</script>

<style>
  /*base*/
	body {
		background: #fff;
	}
	.btn {
		display: inline-block;
		padding: 4px 12px;
		margin-bottom: 0;
		font-size: 14px;
		line-height: 20px;
		text-align: center;
		vertical-align: middle;
		cursor: pointer;
		box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
		border-radius: 4px;
	}
	.btn-danger {
		color: #fff;
		background-color: #da4f49;
		border: 1px solid #bd362f;
	}
	.btn-danger:hover {
		color: #fff;
		background-color: #bd362f;
	}
	.btn:focus {
		outline: none;
	}
	.todo-container {
		width: 600px;
		margin: 0 auto;
	}
	.todo-container .todo-wrap {
		padding: 10px;
		border: 1px solid #ddd;
		border-radius: 5px;
	}
</style>
```

```vue
<template>
    <ul class="todo-main">
		<MyItem />
		<MyItem />
		<MyItem />
		<MyItem />
	</ul>
</template>

<script>
    import MyItem from './MyItem';

    export default {
        name:'MyList',
        components:{MyItem}
    }
</script>

<style scoped>
    	/*main*/
	.todo-main {
		margin-left: 0px;
		border: 1px solid #ddd;
		border-radius: 2px;
		padding: 0px;
	}

	.todo-empty {
		height: 40px;
		line-height: 40px;
		border: 1px solid #ddd;
		border-radius: 2px;
		padding-left: 5px;
		margin-top: 10px;
	}
</style>
```

```vue
<template>
    <li>
		<label>
			<input type="checkbox"/>
			<span>xxxx</span>
		</label>
		<button class="btn btn-danger">删除</button>
	</li>
</template>

<script>
    export default {
        name:'MyItem',
    }
</script>

<style scoped>
    /*item*/
	li {
		list-style: none;
		height: 36px;
		line-height: 36px;
		padding: 0 5px;
		border-bottom: 1px solid #ddd;
	}

	li label {
		float: left;
		cursor: pointer;
	}

	li label li input {
		vertical-align: middle;
		margin-right: 6px;
		position: relative;
		top: -1px;
	}

	li button {
		float: right;
		display: none;
		margin-top: 3px;
	}

	li:before {
		content: initial;
	}

	li:last-child {
		border-bottom: none;
	}

	li:hover{
		background-color: #ddd;
	}
	
	li:hover button{
		display: block;
	}
</style>
```

```vue
<template>
    <div class="todo-header">
		<input type="text" placeholder="请输入你的任务名称，按回车键确认"/>
	</div>
</template>

<script>
    export default {
        name:'MyHeader',
    }
</script>

<style scoped>
    /*header*/
	.todo-header input {
		width: 560px;
		height: 28px;
		font-size: 14px;
		border: 1px solid #ccc;
		border-radius: 4px;
		padding: 4px 7px;
	}

	.todo-header input:focus {
		outline: none;
		border-color: rgba(82, 168, 236, 0.8);
		box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 8px rgba(82, 168, 236, 0.6);
	}
</style>
```

```vue
<template>
    <div class="todo-footer">
		<label>
			<!-- <input type="checkbox" :checked="isAll" @change="checkAll"/> -->
			<input type="checkbox"/>
		</label>
		<span>
			<span>已完成</span>
		</span>
		<button class="btn btn-danger">清除已完成任务</button>
	</div>
</template>

<script>
    export default {
        name:'MyFooter',
    }
</script>

<style scoped>
    /*footer*/
	.todo-footer {
		height: 40px;
		line-height: 40px;
		padding-left: 6px;
		margin-top: 5px;
	}

	.todo-footer label {
		display: inline-block;
		margin-right: 20px;
		cursor: pointer;
	}

	.todo-footer label input {
		position: relative;
		top: -1px;
		vertical-align: middle;
		margin-right: 5px;
	}

	.todo-footer button {
		float: right;
		margin-top: 5px;
	}
</style>
```

#### 初始化数据

> 将数据写入list和item

```vue
<template>
    <ul class="todo-main">
      <MyItem v-for="todo in todos" :key="todo.id" :todo="todo"/>
    </ul>
</template>

<script>
    import MyItem from './MyItem';

    export default {
        name:'MyList',
        components:{MyItem},
        data(){
          return {
            todos:[
              {id:'001',title:'吃饭',done:true},
              {id:'002',title:'睡觉',done:false},
              {id:'003',title:'学习',done:true}
            ]
          }
        }
    }
</script>
```

```vue
<template>
    <li>
  <label>
   <input type="checkbox" :checked="todo.done"/>
   <span>{{todo.title}}</span>
  </label>
  <button class="btn btn-danger">删除</button>
 </li>
</template>

<script>
    export default {
      name:'MyItem',
      props:['todo']
    }
</script>
```

#### 新增数据

> 这样写，之后传递数据是个问题
>
> 因为header中的input包装成数据无法传递给list，因为他们两个没有直接的关系（暂时没学，其实是有办法的）
>
> 所以我们应该将数据定义在app中，方便传递

```vue
<template>
  <div id="root">
    <div class="todo-container">
      <div class="todo-wrap">
        <MyHeader :receive="receive"/>
        <MyList :todos="todos"/>
        <MyFooter/>
      </div>
    </div>
  </div>
</template>

<script>
import MyHeader from './components/MyHeader';
import MyList from './components/MyList';
import MyFooter from './components/MyFooter';

export default {
  name: 'App',
  components: {MyHeader, MyList, MyFooter},
  data(){
    return {
      todos:[
        {id:'001',title:'吃饭',done:true},
        {id:'002',title:'睡觉',done:false},
        {id:'003',title:'学习',done:true}
      ]
    }
  },
  methods:{
    receive(todoObj){
      this.todos.unshift(todoObj);
    }
  }
}
</script>
```

> 向list传递数据，用于显示
>
> 向header中传递函数，用于接收数据

```vue
<template>
    <ul class="todo-main">
      <MyItem v-for="todo in todos" :key="todo.id" :todo="todo"/>
    </ul>
</template>

<script>
    import MyItem from './MyItem';

    export default {
        name:'MyList',
        components:{MyItem},
        props:['todos']
    }
</script>
```

> list中删除data部分，加入props接收数据

```vue
<template>
    <div class="todo-header">
  <input type="text" placeholder="请输入你的任务名称，按回车键确认" v-model="title" @keyup.enter="add"/>
 </div>
</template>

<script>
    import {nanoid} from 'nanoid';

    export default {
      name:'MyHeader',
      props:['receive'],
      data(){
        return {
          title: ''
        }
      },
      methods:{
        add(e){
          if (!this.title.trim()) return alert('输入不能为空');
          //包装用户的输入
          const todoObj = {id:nanoid(),title:e.target.value,done:false};
          this.receive(todoObj);
          this.title = '';
        }
      }
    }
</script>
```

> 在header中包装用户的输入，调用app传递过来的函数，将数据交给app
>
> 这里的id，因为没有数据库动态生成，所以引入nanoid第三方库，生成uuid，保证唯一

#### 勾选

> 接下来我们完成点击前方的勾，将其done值改变
>
> 因为数据保存在app中，所以还是由app声明函数，item来调用

```vue
<template>
  <div id="root">
    <div class="todo-container">
      <div class="todo-wrap">
        <MyHeader :receive="receive"/>
        <MyList :todos="todos" :checkTodo="checkTodo"/>
        <MyFooter/>
      </div>
    </div>
  </div>
</template>

<script>
import MyHeader from './components/MyHeader';
import MyList from './components/MyList';
import MyFooter from './components/MyFooter';

export default {
  name: 'App',
  components: {MyHeader, MyList, MyFooter},
  data(){
    return {
      todos:[
        {id:'001',title:'吃饭',done:true},
        {id:'002',title:'睡觉',done:false},
        {id:'003',title:'学习',done:true}
      ]
    }
  },
  methods:{
    receive(todoObj){
      this.todos.unshift(todoObj);
    },
    //改变done的状态
    checkTodo(id){
      this.todos.forEach((todo) => {
        if (todo.id === id) todo.done = !todo.done;
      })
    }
  }
}
</script>
```

> 在app中加入checkTodo函数，并将其传给list

```vue
<template>
    <ul class="todo-main">
      <MyItem v-for="todo in todos" :key="todo.id" :todo="todo" :checkTodo="checkTodo"/>
    </ul>
</template>

<script>
    import MyItem from './MyItem';

    export default {
        name:'MyList',
        components:{MyItem},
        props:['todos','checkTodo']
    }
</script>
```

> list只是中转一下checkTodo方法

```vue
<template>
    <li>
  <label>
   <input type="checkbox" :checked="todo.done" @change="handleCheck(todo.id)"/>
   <span>{{todo.title}}</span>
  </label>
  <button class="btn btn-danger">删除</button>
 </li>
</template>

<script>
    export default {
      name:'MyItem',
      props:['todo','checkTodo'],
      methods:{
        handleCheck(id){
          //通知App将done值取反
          this.checkTodo(id);
        }
      }
    }
</script>
```

> 在item中接收函数，并绑定事件，改变done值



----



> 其实我们有更简单的方法实现

```vue
<template>
    <li>
  <label>
   <input type="checkbox" v-model="todo.done"/>
   <span>{{todo.title}}</span>
  </label>
  <button class="btn btn-danger">删除</button>
 </li>
</template>

<script>
    export default {
      name:'MyItem',
      props:['todo']
    }
</script>
```

> 只在item中使用v-model="todo.done"，就可以了
>
> 但不建议这样做，因为我们修改了props中的数据



#### 删除

```vue
//删除
deleteTodo(id){
  this.todos = this.todos.filter(todo => todo.id !== id);
}
```

> 同样的，在App中添加方法，向下传递
>
> 因为js删除元素，会用undefined填充，长度不会改变。别的做法太麻烦
>
> 我们之间用过滤后的新数组覆盖老数组

```vue
<template>
    <li>
  <label>
   <input type="checkbox" :checked="todo.done" @change="handleCheck(todo.id)"/>
   <span>{{todo.title}}</span>
  </label>
  <button class="btn btn-danger" @click="handleDelete(todo.id)">删除</button>
 </li>
</template>

<script>
    export default {
      name:'MyItem',
      props:['todo','checkTodo','deleteTodo'],
      methods:{
        handleCheck(id){
          //通知App将done值取反
          this.checkTodo(id);
        },
        handleDelete(id){
          if (confirm('确定删除么？')){
            this.deleteTodo(id);
          }
        }
      }
    }
</script>
```

> 在item中删除



#### 底部统计

>app将todos传递给footer

```vue
<template>
    <div class="todo-footer">
  <label>
   <input type="checkbox"/>
  </label>
  <span>
   <span>已完成{{doneTotal}}</span> / 全部{{todos.length}}
  </span>
  <button class="btn btn-danger">清除已完成任务</button>
 </div>
</template>

<script>
    export default {
      name:'MyFooter',
      props:['todos'],
      computed:{
        doneTotal(){
          let i = 0;
          this.todos.forEach((todo) => {
            if (todo.done) i++;
          });
          return i;
        }
      }
    }
</script>
```

> 在footer中使用计算属性，遍历todos，统计done为真的数量



#### 底部交互

```vue
//全选，取消全选
checkAllTodo(done){
  this.todos.forEach((todo) => {
    todo.done = done;
  })
},
//清除完成项
clearAllDone(){
  this.todos = this.todos.filter((todo) => {
    return !todo.done;
  })
}
```

> 在app中定义全选，全不选方法和清除完成项。并传递给footer

```vue
<template>
    <div class="todo-footer" v-show="total">
  <label>
   <input type="checkbox" v-model="isAll"/>
  </label>
  <span>
   <span>已完成{{doneTotal}}</span> / 全部{{total}}
  </span>
  <button class="btn btn-danger" @click="clearAll">清除已完成任务</button>
 </div>
</template>

<script>
    export default {
      name:'MyFooter',
      props:['todos','checkAllTodo','clearAllDone'],
      computed:{
        total(){
          return this.todos.length;
        },
        doneTotal(){
          let i = 0;
          this.todos.forEach((todo) => {
            if (todo.done) i++;
          });
          return i;
        },
        isAll:{
          get(){
            return this.doneTotal === this.total && this.total > 0;
          },
          set(value){
            this.checkAllTodo(value);
          }
        }
      },
      methods:{
        clearAll(){
          this.clearAllDone();
        }
      }
    }
</script>
```

> 在foot中完成剩下的逻辑
>
> isAll这个计算变量，因为不仅要获取该值，还要设置该值，所以要写成完整形式



### 组件自定义事件

```vue
<template>
  <div class="app">
    <h1>{{msg}}</h1>
    <School></School>
    <Student @haha="getStudent"></Student>
  </div>
</template>

<script>
import Student from "./components/Student";
import School from "./components/School";

export default {
  name:'App',
  components:{School,Student},
  data(){
    return {
      msg:'你好！'
    }
  },
  methods:{
    getStudent(name){
      console.log(name);
    }
  }
}
</script>
```

> 在App中，为Student绑定自定义事件，haha

```vue
<template>
  <div class="student">
    <h2>学生姓名：{{name}}</h2>
    <h2>学生年龄：{{age}}</h2>
    <button @click="sendStudentName">点我传递学生名</button>
  </div>
</template>

<script>
export default {
  name: "Student",
  data(){
    return {
      name: '张三',
      age: 18
    }
  },
  methods:{
    sendStudentName(){
      this.$emit('haha',this.name);
    }
  }
}
</script>
```

> 在Student中，使用this.$emit('haha',this.name); 来触发这个事件
>
> 可以实现数据从子传递到父

```vue
<template>
  <div class="app">
    <h1>{{msg}}</h1>
    <School></School>
    <Student ref="student"/>
  </div>
</template>

<script>
import Student from "./components/Student";
import School from "./components/School";

export default {
  name:'App',
  components:{School,Student},
  data(){
    return {
      msg:'你好！'
    }
  },
  methods:{
    getStudent(name){
      console.log(name);
    }
  },
  mounted() {
    this.$refs.student.$on('haha',this.getStudent);
  }
}
</script>
```

> 也可以在标签中使用ref
>
> 之后进行手动绑定事件



#### 解绑事件

```vue
<template>
  <div class="student">
    <h2>学生姓名：{{name}}</h2>
    <h2>学生年龄：{{age}}</h2>
    <button @click="sendStudentName">点我传递学生名</button>
    <button @click="unbind">解绑事件</button>
  </div>
</template>

<script>
export default {
  name: "Student",
  data(){
    return {
      name: '张三',
      age: 18
    }
  },
  methods:{
    sendStudentName(){
      this.$emit('haha',this.name);
    },
    unbind(){
      this.$off('haha');//解绑一个事件
      this.$off(['haha','haha2']);//解绑多个事件
      this.$off();//解绑所有事件
    }
  }
}
</script>
```

#### 注意点

> 组件上也可以绑定原生DOM事件，需要使用native修饰符

```html
<Student ref="student" @click.native="xxx"/>
```

> 它会将此事件，传入组件中的根元素



### 全局事件总线

> 可以实现任意组件间的通信

> 我们要实现组件间的通信，就要把方法定义在一个全局都能看见的地方
>
> Vue.prototype.x = xxx
>
> 定义在Vue的原型对象上就可以，因为VC的原型也指向了Vue的原型

```js
new Vue({
  render: h => h(App),
  beforeCreate() {
    Vue.prototype.$bus = this;
  }
}).$mount('#app')
```

> 只需要在main.js中，在beforeCreate这个钩子上，让Vue的原型对象中新增一个属性$bus，并且指向当前Vm实例，我们一般习惯将x名称定为\$bus

```vue
<template>
  <div class="school">
    <h2>学校名称：{{name}}</h2>
    <h2>学校地址：{{address}}</h2>
  </div>
</template>

<script>
export default {
  name: "School",
  data(){
    return {
      name:'xxx',
      address:'北京'
    }
  },
  methods:{
    getData(data){
      console.log('School接收到data：',data);
    }
  },
  mounted() {
    this.$bus.$on('hello',this.getData);
  },
  beforeDestroy() {
    this.$bus.$off('hello');
  }
}
</script>
```

> 在School中添绑定hello事件至$bus上，并在模块销毁之前注销事件

```vue
<template>
  <div class="student">
    <h2>学生姓名：{{name}}</h2>
    <h2>学生年龄：{{age}}</h2>
    <button @click="sendStudentName">传递学生名给School</button>
  </div>
</template>

<script>
export default {
  name: "Student",
  data(){
    return {
      name: '张三',
      age: 18
    }
  },
  methods:{
    sendStudentName(){
      this.$bus.$emit('hello',this.name);
    }
  }
}
</script>
```

> 在Student中，直接使用函数触发hello事件，即可完成数据的传递



### 消息订阅与发布

> 有很多第三方库可以实现此功能
>
> 我们在此使用pubsub-js

```vue
<template>
  <div class="school">
    <h2>学校名称：{{name}}</h2>
    <h2>学校地址：{{address}}</h2>
  </div>
</template>

<script>
  import pubsub from 'pubsub-js'
  export default {
    name: "School",
    data(){
      return {
        name:'xxx',
        address:'北京'
      }
    },
    methods:{
      getData(msgName,data){
        console.log('School接收到data：',data);
      }
    },
    mounted() {
      this.pubId = pubsub.subscribe('hello',this.getData);
    },
    beforeDestroy() {
      pubsub.unsubscribe(this.pubId);
    }
  }
</script>
```

> 引入pubsub，订阅hello消息，处理回调，第一个参数是参数名，参数名就是hello，我们不需要用，第二个是传递来的数据
>
> 注意，在取消订阅时，传的是pubId，而不是消息名

```vue
<template>
  <div class="student">
    <h2>学生姓名：{{name}}</h2>
    <h2>学生年龄：{{age}}</h2>
    <button @click="sendStudentName">传递学生名给School</button>
  </div>
</template>

<script>
  import pubsub from 'pubsub-js'
  export default {
    name: "Student",
    data(){
      return {
        name: '张三',
        age: 18
      }
    },
    methods:{
      sendStudentName(){
        pubsub.publish('hello',666);
      }
    }
  }
</script>
```

> 发送端，直接发送消息名，加参数即可



### $nextTick

> 语法：this.$nextTick(回调函数)
>
> 作用：在下一次 DOM 更新结束后执行其指定的回调
>
> 什么时候用：当改变数据后，要基于更新后的新DOM进行某些操作时，要在nextTick所指定的回调函数中执行



### 过渡与动画

```vue
<template>
  <div>
    <button @click="isShow = !isShow">显示/隐藏</button>
    <h1 v-show="isShow" class="come">你好</h1>
  </div>
</template>

<script>
  export default {
    name: "Test",
    data(){
      return {
        isShow:false
      }
    }
  }
</script>

<style scoped>
  h1{
    background-color: orange;
  }

  .come{
    animation: AniIn 1s;
  }
  .go{
    animation: AniIn 1s reverse;
  }
  
  @keyframes AniIn {
    from{
      transform: translateX(-100%);
    }
    to{
      transform: translateX(0px);
    }
  }
</style>
```

> 用css写好动画，之后我们只需要控制css是come与go之间切换即可

```vue
<template>
  <div>
    <button @click="isShow = !isShow">显示/隐藏</button>
    <transition>
      <h1 v-show="isShow">你好</h1>
    </transition>
  </div>
</template>

<script>
  export default {
    name: "Test",
    data(){
      return {
        isShow:false
      }
    }
  }
</script>

<style scoped>
  h1{
    background-color: orange;
  }

  .v-enter-active{
    animation: AniIn 1s;
  }
  .v-leave-active{
    animation: AniIn 1s reverse;
  }
  
  @keyframes AniIn {
    from{
      transform: translateX(-100%);
    }
    to{
      transform: translateX(0px);
    }
  }
</style>
```

> 使用transition标签包裹需要执行动画的部分
>
> 注意，入和出的名称必须为.v-enter-active与 .v-leave-active，动画就会自动触发
>
> 如果在transition标签中使用了name='xxx'，为transition起了名
>
> 动画的css必须为.xxx-enter-active与 .xxx-leave-active
>
> 在transition标签中加入appear，可以实现页面刷新第一次也执行动画

```vue
<template>
  <div>
    <button @click="isShow = !isShow">显示/隐藏</button>
    <transition name="hello">
      <h1 v-show="isShow">你好</h1>
    </transition>
  </div>
</template>

<script>
  export default {
    name: "Test",
    data(){
      return {
        isShow:true
      }
    }
  }
</script>

<style scoped>
  h1{
    background-color: orange;
  }

  .hello-enter,.hello-leave-to{
    transform: translateX(-100%);
  }
  .hello-enter-to,.hello-leave{
    transform: translateX(0);
  }
  .hello-enter-active,.hello-leave-active{
    transition: 1s;
  }
</style>
```

> 或者使用过渡来写，指定进入动画的入点出点。和离开动画的入点出点
>
> 并且在动画激活中，指定持续时间

```vue
<template>
  <div>
    <button @click="isShow = !isShow">显示/隐藏</button>
    <transition-group name="hello">
      <h1 v-show="isShow" key="1">你好</h1>
      <h1 v-show="isShow" key="2">你好！</h1>
    </transition-group>
  </div>
</template>
```

> 如果要为多个元素指定动画，需要使用transition-group
>
> 并且为每一个元素指定一个key

#### 第三方动画

> 有很多第三方好用的动画第三方库
>
> 我们以Animate.css为例
>
> 它的官网是animate.style

```vue
<template>
  <div>
    <button @click="isShow = !isShow">显示/隐藏</button>
    <transition
        appear
        name="animate__animated animate__bounce"
        enter-active-class="animate__swing"
        leave-active-class="animate__backOutDown"
    >
      <h1 v-show="isShow">你好！</h1>
    </transition>
  </div>
</template>

<script>
  import 'animate.css'

  export default {
    name: "Test",
    data(){
      return {
        isShow:true
      }
    }
  }
</script>

<style scoped>
  h1{
    background-color: orange;
  }
</style>
```

> 引入'animate.css
>
> 在transition标签中添加
>
> name="animate\__animated animate__bounce" 	固定写法，官网要求
>
> enter-active-class="animate\__swing"	指定入动画
>
> leave-active-class="animate__backOutDown"	指定出动画
>
> 具体动画名，官网首页，看哪个好，直接点击右侧粘贴即可



## AJAX

