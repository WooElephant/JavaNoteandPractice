# SpringBoot

> SpringBoot能帮我们快速构建Spring应用



## Hello World

### 依赖

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.3.4.RELEASE</version>
</parent>
```

```xml
<!-- https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-web -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <version>2.3.4.RELEASE</version>
</dependency>
```

> 在pom中添加内容

### 写代码

```java
//告诉Spring这是一个SpringBoot应用
@SpringBootApplication
public class MainApplication {
    public static void main(String[] args) {
        SpringApplication.run(MainApplication.class,args);
    }
}
```

> 这是程序的主方法，固定写法

```java
@RestController
public class HelloController {

    @RequestMapping("/hello")
    public String handle01(){
        return "hello Spring Boot";
    }
}
```

> 这里的**@RestController注解就是@Controller和@ResponseBody的合体**

> 所有的配置文件，都写在application.properties中
>
> 具体能写哪些东西参照官方文档

### 打包

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

> 在pom中引用Spring提供的插件
>
> 直接在Maven中点击package就可以生成可运行的jar包
>
> 我们使用cmd可以直接开启程序，访问localhost



### 依赖管理

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.3.4.RELEASE</version>
</parent>
```

> 在这里我们导入了父项目
>
> 它的作用是帮我们管理依赖，并且控制版本
>
> 它的内部几乎声明了所有依赖的版本号
>
> 可以让我们导入依赖时不需要注明版本号

> 如果我们需要更改某个依赖的版本号，可以在pom，properties标签中加入
>
> ```xml
> <mysql.version>5.1.43</mysql.version>
> ```
>
> 来覆盖其声明的默认版本号



### starter场景启动器

> Spring提供了很多的spring-boot-starter-*
>
> *就是某种场景
>
> 只要引入starter，这个场景需要的常规依赖都会被自动导入

> 还有一些第三方的starter
>
> 命名为
>
> \*-boot-starter-*



### 自动配置

> 通过Hello World我们可以看到
>
> Tomcat，SpringMVC常见配置已经被自动配置完成
>
> 主程序所在的包，及其所有子包中的内容都会被默认扫描

> 如果有些组件想不放在子目录下
>
> 可以在主程序注解中加入属性
>
> ```java
> @SpringBootApplication(scanBasePackages = "com.augus")
> ```



## 组件注册注解

### @Configuration

```java
@Configuration(proxyBeanMethods = false) 
public class MyConfig {
```

> proxyBeanMethods：代理bean的方法
>
> Full(proxyBeanMethods = true)【保证每个@Bean方法被调用多少次返回的组件都是单实例的】
>
> Lite(proxyBeanMethods = false)【每个@Bean方法被调用多少次返回的组件都是新创建的】

> false的好处是，不需要每次调用方法都去容器中找有没有对象，效率高
>
> true的好处是，如果该方法被别的组件依赖，可以保证拿到的组件，是容器中的组件，而不是一个新的
>
> **一般使用false，如果被依赖则改为true**



### @Conditional

```java
@ConditionalOnBean(name = "tomcatPet")
@Bean
public User user01(){
    User user = new User();
    user.setPet(tomcatPet());
    return user;
}

public Pet tomcatPet(){
    return new Pet("tomcat");
}
```

> 使用@Conditional，当表达式成立时才会注册组件
>
> 比如@ConditionalOnBean(name = "tomcatPet")，下方这个组件依赖tomcatPet这个组件
>
> 如果不存在则不创建

> @Conditional同样可以标注在类上
>
> 表达式不成立，则这个类中所有组件都不注册到容器中



## 配置文件引入

> @ImportResource("classpath:beans.xml")
>
> 使用此声明，可以导入之前的xml，将xml中声明的组件，导入容器



## 配置绑定

### 方式一

```properties
mycar.brand=BMW
mycar.price=300000
```

> 我们在配置文件中写了这些值

```java
@ConfigurationProperties(prefix = "mycar")
@Component
public class Car {
    private String brand;
    private Integer price;
```

> 只需要在bean中，添加@ConfigurationProperties(prefix = "mycar")注解，则可以将属性与配置文件中的值绑定

### 方式二

```java
@ConfigurationProperties(prefix = "mycar")
public class Car {
    private String brand;
    private Integer price;
```

```java
@EnableConfigurationProperties(Car.class)
@Configuration
public class MyConfig {
```

> 在配置类中开启Car的属性绑定，他会自动将其注册进容器



## 自动配置原理

### @SpringBootConfiguration

> 他就是一个特殊的@Configuration

### @ComponentScan

> 指定扫描哪些包

### @EnableAutoConfiguration

> 它的内部又包含了
>
> @AutoConfigurationPackage
>
> @Import(AutoConfigurationImportSelector.class)

#### @AutoConfigurationPackage

> 它的内部是@Import(AutoConfigurationPackages.Registrar.class)
>
> 利用Registrar给容器中批量注册组件
>
> 因为是一个复合注解，它的顶层是标在了我们配置类上
>
> Registrar会获取我们配置类所在的包，并将其内容全部注册进容器

#### @Import(AutoConfigurationImportSelector.class)

> 1. 利用getAutoConfigurationEntry(annotationMetadata)给容器中批量导入一些组件
>
> 2. 调用List\<String> configurations = getCandidateConfigurations(annotationMetadata, attributes)获取到所有需要导入到容器中的配置类
>
> 3. 利用工厂加载 Map<String, List\<String>> loadSpringFactories(@Nullable ClassLoader classLoader)得到所有的组件
>
> 4. 从META-INF/spring.factories位置来加载一个文件

> 有些包中没有META-INF/spring.factories这个文件
>
> 有这些文件的包则会在这里被导入
>
> 重点在于spring-boot-autoconfigure这个包中的META-INF/spring.factories这个文件中定义了，需要被初始化加载的类
>
> 这些类会传递给之前的步骤进行注册

> 其实这些类中很多不会被真正的加载
>
> 因为很多包中使用了@Conditional注解
>
> 以此来达成按需加载的目的



## 开发~~外挂~~技巧

### Lombok

```xml
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
</dependency>
```

> 安装lombok插件，默认IDEA是安装了的

```java
@EqualsAndHashCode
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Data
@ConfigurationProperties(prefix = "mycar")
public class Car {
    private String brand;
    private Integer price;
}
```

> 我们可以在类上标注这些注解，只写属性就可以
>
> @Data：get和set方法
>
> @ToString：toString方法
>
> @EqualsAndHashCode：equals和hashCode方法
>
> @NoArgsConstructor：无参构造器
>
> @AllArgsConstructor：全参构造器

> 还可以写@Slf4j注释
>
> 在类中可以直接使用log.debug("debug")之类的日志记录



### dev-tools

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <optional>true</optional>
</dependency>
```

> 可以让我们在改变代码之后不需要重启
>
> 按ctrl+F9（build project快捷键）直接生效
>
> 其实它也是在重启，跟手动重启没啥区别
>
> 速度上会快一些

> **真正实现热部署的是JRebel，但是是要钱的**



## YAML

> YAML是“YAML Ain't Markup Language”的递归缩写
>
> 非常适合用来做以数据为中心的配置文件
>
> Spring的配置推荐使用yaml

> **基本语法**
>
> * key：Value  **：之后有空格**
> * 大小写敏感
> * 使用缩进表示层级关系
> * 缩进不允许用tab，只允许空格
> * 缩进空格数不重要，只要相同层级左对齐即可
> * #表示注释
> * ''与""表示字符串，一般来说不写，比如\n，单引号输出\n，双引号输出换行

#### 字面量

```yaml
k: v
```

#### 对象

```yaml
k: {k1: v1,k2: v2,k3: v3}
k:
   k1: v1
   k2: v2
   k3: v3
```

#### 数组

```yaml
k: [v1,v2,v3]
k:
   - v1
   - v2
   - v3
```

```yaml
person:
  userName: 张三
  boss: true
  birth: 2019/12/09
  age: 20
  interests: [篮球,足球]
  animal:
    - 猫
    - 狗
  score:
    english: 80
    math: 90
  salaries: [9999.98,9999.99]
  pet:
    name: 阿狗
    weight: 20
  allPets:
    sick:
      - {name: 阿狗,weight: 20}
      - name: 阿猫
        weight: 10
      - name: 阿虫
        weight: 1
    health: [{name: 阿花,weight: 10},{name: 阿牛,weight: 100}]
```

```java
private String userName;
private boolean boss;
private Date birth;
private Integer age;
private Pet pet;
private String[] interests;
private List<String> animal;
private Map<String,Object> score;
private Set<Double> salaries;
private Map<String,List<Pet>> allPets;
```

> 我们在写配置文件的时候没有代码提示

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-configuration-processor</artifactId>
    <optional>true</optional>
</dependency>
```

> 导入此包以后，启动一下服务再关闭，写配置的时候就有代码提示了

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <excludes>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-configuration-processor</artifactId>
                </excludes>
            </configuration>
        </plugin>
    </plugins>
</build>
```

> 建议在打包插件中添加配置
>
> 在打包时，不要把配置提示的这个依赖一起打包



## WEB开发

### 静态资源规则

> 静态资源目录
>
> /static	/public	/resources	/META-INF/resources
>
> 这些目录会被Spring当做静态资源目录

> 静态资源映射/**
>
> 请求来，先找Controller看能不能处理，如果不能，所有请求都会交给静态资源处理器，就会去上述目录中寻找

```yaml
spring:
  mvc:
    static-path-pattern: /res/**
```

> 默认静态资源访问路径是没有前缀的，容易被拦截器统一拦截
>
> 所以我们可以配置一下访问前缀

```yaml
spring:
    web:
      resources:
        static-locations: [classpath:/haha/]
```

> 我们也可以改变静态资源的路径



### index和Favicon

> 如果静态路径下有index.html
>
> 或者有controller能处理/index请求的
>
> 都会被当做首页自动显示

> 将图片命名为favicon.ico放到静态资源路径下，会自动显示为网站图标



### 静态资源原理

> SpringMVC功能的自动配置类是 WebMvcAutoConfiguration
>
> 它在容器中配置了REST请求处理，内容过滤器，视图解析器等内容

> 在WebMvcAutoConfiguration中又配置了WebMvcAutoConfigurationAdapter子配置
>
> 它将配置文件spring.mvc，spring.resources与一些属性进行了绑定

> 在 WebMvcAutoConfiguration中有一个方法addResourceHandlers
>
> 它负责将静态资源的配置注册进容器

> 在 WebMvcAutoConfiguration中有一个方法WelcomePageHandlerMapping
>
> 它会获取配置中静态资源的路径，然后去寻找index.html，并转发至欢迎页



### REST风格配置

> 在Spring底层，有一个OrderedHiddenHttpMethodFilter用来转换REST请求
>
> 但是它的注释有一条
>
> ```java
> @ConditionalOnProperty(prefix = "spring.mvc.hiddenmethod.filter", name = "enabled", matchIfMissing = false)
> ```
>
> 可以看到，默认是不开启的，需要去配置文件中手动开启
>
> ```yaml
> spring:
>   mvc:
>     hiddenmethod:
>       filter:
>         enabled: true
> ```

> 请求被HiddenHttpMethodFilter拦截
>
> 如果请求方式是POST，会获取_method的参数
>
> 判断该参数是否符合规定类型（使用了一个String的List来查看是否包含）
>
> 使用RequestWrapper，内部定义了method参数，并且重写getMethod方法为读取本类中的method
>
> 然后用此类将请求重写包装

> 如果使用工具，或者源生就可以发送REST请求的方式发送请求
>
> 源生Http请求中带有的就是REST请求
>
> 就不会被拦截器拦截
>
> 这也是为什么REST是默认关闭的
>
> 因为微服务中，很多时候并不是直接处理浏览器请求，而是处理其他服务的请求

```java
@RequestMapping(value = "/person",method = RequestMethod.GET)
@GetMapping("/person")
```

> 过去的写法也可以直接替换成更简单的注解，其实本质是一样的，只不过多嵌套了一层，我们写起来方便



### 请求映射原理

> HttpServlet中的doGet实际上会调用，FrameworkServlet中的processRequest方法
>
> processRequest方法最核心的业务又调用了doService方法，在本类中doService是抽象方法
>
> 由其子类DispatcherServlet实现，其核心业务又调用了**doDispatch**方法
>
> 在Spring中处理所有请求的方法实际上是doDispatch

>在doDispatch中getHandler方法，是真正寻找对应映射的方法

> 在Spring中所有处理请求的映射都被保存在HandlerMapping中
>
> 其中比较重要的是RequestMappingHandlerMapping，它内部的mappingRegistry下记录了所有添加了RequestMapping注解的映射
>
> getHandler会在所有HandlerMapping中的mappingRegistry中寻找哪个映射与请求对应



### 常用参数注解

#### @PathVariable

```java
@GetMapping("/person/{id}/owner/{name}")
public Person getPerson(@PathVariable("id") Integer id,@PathVariable("name") String name){
    
@GetMapping("/person/{id}/owner/{name}")
public Person getPerson(@PathVariable Map<String,String> map){
```

> 从访问路径中获取参数



#### @RequestHeader

```java
@GetMapping("/person")
public Person getPerson(@RequestHeader("userAgent") String userAgent){
    
@GetMapping("/person")
public Person getPerson(@RequestHeader Map<String,String> headers){
```

> 获取请求头信息



#### @RequestParam

```java
@GetMapping("/person")
public Person getPerson(@RequestParam("age") Integer age, @RequestParam("inters") List<String> inters){
    
@GetMapping("/person")
public Person getPerson(@RequestParam Map<String,String> map){
```

> 获取请求参数



#### @CookieValue

```java
@GetMapping("/person")
public Person getPerson(@CookieValue("_ga") Cookie cookie){
    
@GetMapping("/person")
public Person getPerson2(@CookieValue("_ga") String _ga){
```

> 获取Cookie



#### @RequestBody

```java
@GetMapping("/person")
public Person getPerson(@RequestBody String content){
```

> 获取POST请求体



#### @RequestAttribute

```java
@GetMapping("/goto")
public String goTo(HttpServletRequest req){
    req.setAttribute("msg","123");
    req.setAttribute("code","456");
    return "forward:/success";
}

@ResponseBody
@GetMapping("/success")
public String success(@RequestAttribute("msg") String msg,@RequestAttribute String code){
```

```java
@GetMapping("/goto")
public String goTo(HttpServletRequest req){
    req.setAttribute("msg","123");
    req.setAttribute("code","456");
    return "forward:/success";
}

@ResponseBody
@GetMapping("/success")
public String success(HttpServletRequest request){
    Object msg = request.getAttribute("msg");
    Object code = request.getAttribute("code");
```

> 获取请求域中的值



#### @MatrixVariable

> 矩阵变量需要在SpringBoot中手动开启
>
> 矩阵变量应当绑定在路径变量中
>
> 若有多个矩阵变量，使用；分割
>
> 若一个矩阵变量有多个值，使用，分割。或命名多个重复的Key

> /cars/{path}?xxx=xxx&xxx=xxx  这种方式称作QueryString
>
> /cars/{path；low=34；brand=BYD，Audi，BMW}  矩阵变量

> 典型作用：客户端禁用cookie，将SessionId保存在矩阵变量中

> 对于路径的处理，SpringMVC使用UrlPathHelper进行解析，它有一个属性removeSemicolonContent
>
> 默认是开启的，就会移除；号后所有内容
>
> 如果需要开启，让我们的配置类实现WebMvcConfigurer接口
>
> 重写configurePathMatch方法

```java
@Override
public void configurePathMatch(PathMatchConfigurer configurer) {
    UrlPathHelper urlPathHelper = new UrlPathHelper();
    urlPathHelper.setRemoveSemicolonContent(false);
    configurer.setUrlPathHelper(urlPathHelper);
}
```

```java
//请求：/cars/sell;low=34;brand=BYD,Audi,BMW

@GetMapping("/cars/{path}")
public Map carsSell(@MatrixVariable("low") Integer low,@MatrixVariable("brand") List<String> brand){
```

```java
//请求： /boss/1;age=20/2;age=10
@GetMapping("/boss/{bossId}/{empId}")
public Map carsSell(@MatrixVariable(value = "age",pathVar = "bossId") Integer bossAge,
                    @MatrixVariable(value = "age",pathVar = "empId") List<String> empAge){
```



### 参数解析原理

> doDispatch找到可以处理当前请求的Handler
>
> 为当前Handler通过getHandlerAdapter方法，找到适配器
>
> 通过HandlerAdapter执行目标方法

> 默认的HandlerAdapter有四个
>
> RequestMappingHandlerAdapter：用来处理标注@RequestMapping注解的方法
>
> HandlerFunctionAdapter：用来处理函数式编程
>
> HttpRequestHandlerAdapter：
>
> SimpleControllerHandlerAdapter：

> 在执行目标方法之前，为目标方法设置参数解析器，来确定目标方法参数的值
>
> 每个参数解析器对应一个注解
>
> 参数解析器接口定义了两个方法
>
> supportParameter：是否支持这种参数，如果支持就调用下面的
>
> resolveArgument：进行参数解析

> 真正执行方法的是invocableMethod.invokeAndHandle
>
> 在执行此函数时，会调用getMethodArgumentValues为目标方法准备参数
>
> 先获取所有参数的详细信息，创建Object数组保存所有参数
>
> 遍历此数组，找到能处理此参数的参数解析器
>
> 通过参数解析器为其赋值



### 数据响应

> 与参数解析器类似，Spring有自己的返回值解析器
>
> 在handleReturnValue中使用返回值解析器处理返回值
>
> RequestResponseBodyMethodProcess用来处理标注@ResponseBody注解
>
> 在此类中使用writeWithMessageConverters来处理响应数据
>
> 根据浏览器请求头的接受数据类型，在HttpMessageConverter中寻找哪个转换器可以处理
>
> 比如对象类型数据，MappingJackson2HttpMessageConverter可以将对象转换为JSON返回给浏览器

> HttpMessageConverter接口中定义了canRead，canWrite方法
>
> 表示自己可以处理哪些数据类型的相互转换



### 内容协商原理

> 在浏览器请求头中，Accept字段定义了能接收的数据类型
>
> 在返回之前，会先看有没有明确的要求返回类型
>
> 再获取接收端请求头Accept字段中所有可以接受的类型
>
> 然后查看程序自己能转换出的所有类型
>
> 查看所有类型转换器中CanWrite能不能处理目标类型
>
> 把能处理该数据的转换器，转换出的类型保存在一个列表中
>
> 在能产出的类型中遍历，看看哪个满足客户端需求的数据类型
>
> 最终知道输出哪个类型的数据
>
> 再来遍历转换器，看哪个转换器可以生成这个类型
>
> 通过转换器，转换成目标类型数据，并响应

```yaml
spring:
  mvc:
    contentnegotiation:
      favor-parameter: true
```

> 可以在配置文件中，开启基于参数的内容协商
>
> 可以在请求中直接携带参数format来指定接收的数据类型

> 之前获取客户端接受类型的时候，使用的是内容协商管理器
>
> 默认使用HeaderConverterNegotiationStrategy，它默认会以请求头中Accept字段来整理可接受的数据类型
>
> 当我们开启基于参数的协商后，会多出一个ParameterContentNegotiationStrategy，基于参数的内容协商策略，他其中默认规定了只可以有两种参数：xml和json
>
> ParameterContentNegotiationStrategy的优先级比HeaderConverterNegotiationStrategy高，只要获得了结果，就不会遍历下一个内容协商管理器
>
> 所以只要带了format参数，就一定会短路掉请求头的策略



### 自定义MessageConverter

> 根据之前的知识，我们知道只要定义了自定义的MessageConverter，就可以让程序实现某种制定类型的转换

> 如果我们导入常见的依赖比如jackson的xmlConverter，Spring底层会自动判断这个包是否存在，如果存在就在开启时，自动将其注册
>
> 我们自己写的MessageConverter，需要在配置类中，实现WebMvcConfigurer接口，并且复写extendMessageConverters方法即可

```java
public class MyConverter implements HttpMessageConverter<Person> {

    @Override
    public boolean canRead(Class<?> aClass, MediaType mediaType) {
        //我们不实现读的功能，直接返回false
        return false;
    }

    @Override
    public boolean canWrite(Class<?> aClass, MediaType mediaType) {
        return aClass.isAssignableFrom(Person.class);
    }

    @Override
    public List<MediaType> getSupportedMediaTypes() {
        //底层要统计所有可以实现的类型
        return MediaType.parseMediaTypes("application/x-haha");
    }

    @Override
    public Person read(Class<? extends Person> aClass, HttpInputMessage httpInputMessage) throws IOException, HttpMessageNotReadableException {
        return null;
    }

    @Override
    public void write(Person person, MediaType mediaType, HttpOutputMessage httpOutputMessage) throws IOException, HttpMessageNotWritableException {
        String data = person.getUserName() + ";" + person.getAge();
        //获得输出流将内容写出
        OutputStream body = httpOutputMessage.getBody();
        body.write(data.getBytes(StandardCharsets.UTF_8));
    }
}
```

```java
@Override
public void extendMessageConverters(List<HttpMessageConverter<?>> converters) {
    converters.add(new MyConverter());
}
```

> 这样只能虽然让请求头可以生效，但不可以通过参数的形式进行获取
>
> 我们之前知道基于参数的内容协商管理器只支持xml和json

```java
@Override
public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
    HashMap<String, MediaType> map = new HashMap<>();
    map.put("json",MediaType.APPLICATION_JSON);
    map.put("xml",MediaType.APPLICATION_XML);
    map.put("haha",MediaType.parseMediaType("application/x-haha"));
    ParameterContentNegotiationStrategy strategy = new ParameterContentNegotiationStrategy(map);
    configurer.strategies(Arrays.asList(strategy));
}
```

> 我们需要自定义一个内容协商策略
>
> 此策略会覆盖之前Spring定义的策略，所以要把xml和json添上（除非你根本不用参数的方法来获取这俩）



### 视图解析

> 我们的返回值为String时，会使用ViewNameMethodReturnValueHandle来处理
>
> 它会将数据封装在ModelAndView中
>
> 使用processDispatchResult真正处理响应结果
>
> 在其中调用render进行页面渲染
>
> 在render中获取视图名，得到View对象
>
> 然后在所有视图解析器中进行遍历，看哪个可以处理当前视图
>
> 视图对象调用render方法，进行页面渲染



### 拦截器

```java
@Override
public void addInterceptors(InterceptorRegistry registry) {
    registry.addInterceptor(new MyLoginInterceptor()).addPathPatterns("/**").excludePathPatterns("/","/login","/css/**","/fonts/**","/js/**","/images/**");
}
```

> 复写addInterceptors方法，来新增拦截器

> 在程序寻找对应handler的同时，也会找到相应的拦截器链
>
> 顺序执行所有拦截器的preHandle方法，如果返回true则执行下一个拦截器
>
> 如果返回false倒序执行已经执行拦截器的afterCompletion方法



### 文件上传

```java
@PostMapping("/upload")
public String upload(@RequestPart("image") MultipartFile img,@RequestPart("photos") MultipartFile[] photos) throws IOException {

    if (!img.isEmpty()){
        String filename = img.getOriginalFilename();
        img.transferTo(new File("D:\\" + filename));
    }

    if (photos.length > 0){
        for (MultipartFile photo : photos) {
            if (!photo.isEmpty()){
                String filename = photo.getOriginalFilename();
                photo.transferTo(new File("D:\\photo\\" + filename));
            }
        }
    }
    
    return "main";
}
```

> Spring在MultipartAutoConfiguration这个配置类中配置了文件上传相关属性
>
> 在其中自动配置了StandardServletMultipartResolver文件上传解析器
>
> 在寻找处理器handler之前会先进行判断，此请求是不是文件上传请求
>
> 如果是，则将其包装为MultipartHttpServletRequest
>
> 使用参数解析器，将文件解析为MultipartFile，并和名字一起封装进一个map中



### 异常处理

> 默认情况下，Spring会提供/error来处理所有的错误
>
> 我们也可以将我们写好的错误页面放在error/下，命名为4xx，5xx
>
> 可以使用确切的名称404.html或者写5xx.html，会将所有5xx的错误信息都定向到这个页面

> ErrorMvcAutoConfiguration中定义了自动配置
>
> 其中DefaultErrorAttributes它实现了ErrorAttributes, HandlerExceptionResolver端口，其中定义了错误页面现实的数据
>
> 还有BasicErrorController 用来处理/error的请求，是浏览器就显示错误页，不然则返回json对象
>
> 还会在容器中存放一个View对象，它的id是error
>
> 还有一个DefaultErrorViewResolver，用来以状态码寻找错误页面

> 执行目标方法时，如果发现异常
>
> 使用dispatchException进入错误解析流程
>
> 也同样会去寻找handlerExceptionResolvers，看哪个解析器可以处理这个异常
>
> 处理完成后返回View对象
>
> 如果没有解析器可以处理，那么就会发送/error，会被BasicErrorController接收处理
>
> 遍历所有的异常视图解析器来渲染页面
>
> 默认的DefaultErrorViewResolver是将状态码作为地址去寻找响应页面



### 原生组件注册

> 使用@ServletComponentScan("com.augus")来指定扫描哪些包，Servlet，listener，filter都会被扫描并注册
>
> 在Servlet中使用@WebServlet(urlPatterns = "/haha")，直接响应，不会被Spring拦截器拦截



## 数据访问

### 连接池

```xml
<dependency>
   <groupId>com.alibaba</groupId>
   <artifactId>druid-spring-boot-starter</artifactId>
   <version>1.1.17</version>
</dependency>
```

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/db_account
    username: root
    password: 123456
    driver-class-name: com.mysql.cj.jdbc.Driver
```



### Mybatis

```java
@Mapper
public interface CityMapper {
    @Select("select * from city where id = #{id}")
    public City getById(Long id);
}
```

> 也可以使用原先xml配置
>
> 也可以都用，简单的用注解，复杂的用xml

```yaml
mybatis:
  mapper-locations: Mybatis/mapper/*.xml
```

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.augus.boot.mapper.CityMapper">
    <select id="getById" resultType="com.augus.boot.bean.City">
        select * from  city where  id=#{id}
    </select>
</mapper>
```



## 单元测试Junit 5

> SpringBoot 2.2版本之后Junit 5作为默认测试库
>
> Junit 5与之前有很大不同
>
> 分为三个模块
>
> JUnit Platform：Junit Platform是在JVM上启动测试框架的基础，不仅支持Junit自制的测试引擎，其他测试引擎也都可以接入
>
> JUnit Jupiter：JUnit Jupiter提供了JUnit5的新的编程模型，是JUnit5新特性的核心。内部 包含了一个测试引擎，用于在Junit Platform上运行
>
> JUnit Vintage：由于JUint已经发展多年，为了照顾老的项目，JUnit Vintage提供了兼容JUnit4.x,Junit3.x的测试引擎

```java
@SpringBootTest
class SpringBoot03ApplicationTests {
    @Test
    void contextLoads() {
    }
}
```

> 只需要在方法上加@Test即可使用
>
> 类上加@SpringBootTest，这个注解中包含@ExtendWith（SpringExtension.class），让测试类中可以使用spring中的组件



### 常用注解

> - **@Test :**表示方法是测试方法。但是与JUnit4的@Test不同，他的职责非常单一不能声明任何属性，拓展的测试将会由Jupiter提供额外测试
> - **@ParameterizedTest :**表示方法是参数化测试，下方会有详细介绍
>
> - **@RepeatedTest :**表示方法可重复执行，下方会有详细介绍
> - **@DisplayName :**为测试类或者测试方法设置展示名称
>
> - **@BeforeEach :**表示在每个单元测试之前执行
> - **@AfterEach :**表示在每个单元测试之后执行
>
> - **@BeforeAll :**表示在所有单元测试之前执行
> - **@AfterAll :**表示在所有单元测试之后执行
>
> - **@Tag :**表示单元测试类别，类似于JUnit4中的@Categories
> - **@Disabled :**表示测试类或测试方法不执行，类似于JUnit4中的@Ignore
>
> - **@Timeout :**表示测试方法运行如果超过了指定时间将会返回错误
> - **@ExtendWith :**为测试类或测试方法提供扩展类引用



### 断言机制

> 断言（assertions）是测试方法中的核心部分，用来对测试需要满足的条件进行验证
>
> JUnit 5 内置的断言可以分成如下几个类别：
>
> 检查业务逻辑返回的数据是否合理
>
> 所有的测试运行结束以后，会有一个详细的测试报告

#### 简单断言

|      方法       |                 说明                 |
| :-------------: | :----------------------------------: |
|  assertEquals   |  判断两个对象或两个原始类型是否相等  |
| assertNotEquals | 判断两个对象或两个原始类型是否不相等 |
|   assertSame    |  判断两个对象引用是否指向同一个对象  |
|  assertNotSame  |  判断两个对象引用是否指向不同的对象  |
|   assertTrue    |     判断给定的布尔值是否为 true      |
|   assertFalse   |     判断给定的布尔值是否为 false     |
|   assertNull    |    判断给定的对象引用是否为 null     |
|  assertNotNull  |   判断给定的对象引用是否不为 null    |

```java
int cal(int i,int j){
    return i + j;
}

@Test
void testSimpleAssertions() {
    int cal = cal(1, 2);
    assertEquals(5,cal);
}
/*
org.opentest4j.AssertionFailedError: 
Expected :5
Actual   :3
*/
```
```java
int cal(int i,int j){
    return i + j;
}

@Test
void testSimpleAssertions() {
    int cal = cal(1, 2);
    assertEquals(5,cal,"cal计算有误");
}
/*
org.opentest4j.AssertionFailedError: cal计算有误 ==> 
Expected :5
Actual   :3
*/
```
```java
@Test
void testSimpleAssertions() {
    Object o = new Object();
    Object o1 = new Object();
    assertSame(o,o1);
}
/*
org.opentest4j.AssertionFailedError: 
Expected :java.lang.Object@16f7c8c1
Actual   :java.lang.Object@2f0a87b3
*/
```

> 如果连续写多个断言
>
> 一个失败了，之后的都不会运行



#### 数组断言

```java
@Test
public void array() {
    assertArrayEquals(new int[]{1, 2}, new int[] {1, 2});
}
```



#### 组合断言

```java
@Test
public void all() {
    assertAll("Math",
            () -> assertEquals(2, 1 + 1),
            () -> assertTrue(1 > 0)
    );
}
```

> 所有的断言都成功才算成功，一个失败并不影响之后的执行



#### 异常断言

```java
@Test
public void exceptionTest() {
    ArithmeticException exception = Assertions.assertThrows(
            ArithmeticException.class, () -> System.out.println(1 / 0));
}
```

#### 超时断言

```java
@Test
public void timeoutTest() {
    assertTimeout(Duration.ofMillis(1000), () -> Thread.sleep(500));
}
```

#### 快速失败

```java
@Test
public void shouldFail() {
    fail("This should fail");
}
```

> 直接使测试失败



### 前置条件

> JUnit 5 中的前置条件（assumptions【假设】）类似于断言，不同之处在于不满足的断言会使得测试方法失败，而不满足的前置条件只会使得测试方法的执行终止
>
> 前置条件可以看成是测试方法执行的前提，当该前提不满足时，就没有继续执行的必要

```java
@Test
void testAssumptions(){
    Assumptions.assumeTrue(false,"结果不是true");
    System.out.println("111");
}
```



### 嵌套测试

```java
@DisplayName("A stack")
class TestingAStackDemo {

    Stack<Object> stack;

    @Test
    @DisplayName("is instantiated with new Stack()")
    void isInstantiatedWithNew() {
        new Stack<>();
    }

    @Nested
    @DisplayName("when new")
    class WhenNew {

        @BeforeEach
        void createNewStack() {
            stack = new Stack<>();
        }

        @Test
        @DisplayName("is empty")
        void isEmpty() {
            assertTrue(stack.isEmpty());
        }

        @Test
        @DisplayName("throws EmptyStackException when popped")
        void throwsExceptionWhenPopped() {
            assertThrows(EmptyStackException.class, stack::pop);
        }

        @Test
        @DisplayName("throws EmptyStackException when peeked")
        void throwsExceptionWhenPeeked() {
            assertThrows(EmptyStackException.class, stack::peek);
        }

        @Nested
        @DisplayName("after pushing an element")
        class AfterPushing {

            String anElement = "an element";

            @BeforeEach
            void pushAnElement() {
                stack.push(anElement);
            }

            @Test
            @DisplayName("it is no longer empty")
            void isNotEmpty() {
                assertFalse(stack.isEmpty());
            }

            @Test
            @DisplayName("returns the element when popped and is empty")
            void returnElementWhenPopped() {
                assertEquals(anElement, stack.pop());
                assertTrue(stack.isEmpty());
            }

            @Test
            @DisplayName("returns the element when peeked but remains not empty")
            void returnElementWhenPeeked() {
                assertEquals(anElement, stack.peek());
                assertFalse(stack.isEmpty());
            }
        }
    }
}
```

> 说白了，就是从外执行到内
>
> 外层数据内层依旧有效
>
> 内层操作不会影响到外层



### 参数化测试

> 可以传入多种参数，来测试方法

> @ValueSource: 为参数化测试指定入参来源，支持八大基础类以及String类型,Class类型
> @NullSource: 表示为参数化测试提供一个null的入参
> @EnumSource: 表示为参数化测试提供一个枚举入参
> @CsvFileSource：表示读取指定CSV文件内容作为参数化测试入参
> @MethodSource：表示读取指定方法的返回值作为参数化测试入参(注意方法返回需要是一个流)

```java
@ParameterizedTest
@ValueSource(ints = {1,2,3,4,5})
void testParameterized(int i){
    System.out.println(i);
}
```

```java
static Stream<String> stringProvider(){
    return Stream.of("apple","banana","peach");
}

@ParameterizedTest
@MethodSource("stringProvider")
void testParameterized(String fruit){
    System.out.println(fruit);
}
```



### 迁移指南

> 在进行迁移的时候需要注意如下的变化：
>
> 注解在 org.junit.jupiter.api 包中，断言在 org.junit.jupiter.api.Assertions 类中，前置条件在 org.junit.jupiter.api.Assumptions 类中
>
> 把@Before 和@After 替换成@BeforeEach 和@AfterEach
>
> 把@BeforeClass 和@AfterClass 替换成@BeforeAll 和@AfterAll
>
> 把@Ignore 替换成@Disabled
>
> 把@Category 替换成@Tag
>
> 把@RunWith、@Rule 和@ClassRule 替换成@ExtendWith



## 指标监控

> 未来每一个微服务在云上部署以后，我们都需要对其进行监控、追踪、审计、控制等
>
> SpringBoot就抽取了Actuator场景，使得我们每个微服务快速引用即可获得生产级别的应用监控、审计等功能

```yaml
management:
  endpoints:
    enabled-by-default: true #默认开启所有监控端点，可以不用写
    web:
      exposure:
        include: '*' #以web模式暴露所有端点
```

|         ID         |                             描述                             |
| :----------------: | :----------------------------------------------------------: |
|   `auditevents`    | 暴露当前应用程序的审核事件信息。需要一个`AuditEventRepository组件`。 |
|      `beans`       |          显示应用程序中所有Spring Bean的完整列表。           |
|      `caches`      |                       暴露可用的缓存。                       |
|    `conditions`    |     显示自动配置的所有条件信息，包括匹配或不匹配的原因。     |
|   `configprops`    |             显示所有`@ConfigurationProperties`。             |
|       `env`        |          暴露Spring的属性`ConfigurableEnvironment`           |
|      `flyway`      | 显示已应用的所有Flyway数据库迁移。 需要一个或多个`Flyway`组件。 |
|      `health`      |                  显示应用程序运行状况信息。                  |
|    `httptrace`     | 显示HTTP跟踪信息（默认情况下，最近100个HTTP请求-响应）。需要一个`HttpTraceRepository`组件。 |
|       `info`       |                      显示应用程序信息。                      |
| `integrationgraph` | 显示Spring `integrationgraph` 。需要依赖`spring-integration-core`。 |
|     `loggers`      |               显示和修改应用程序中日志的配置。               |
|    `liquibase`     | 显示已应用的所有Liquibase数据库迁移。需要一个或多个`Liquibase`组件。 |
|     `metrics`      |                显示当前应用程序的“指标”信息。                |
|     `mappings`     |             显示所有`@RequestMapping`路径列表。              |
|  `scheduledtasks`  |                  显示应用程序中的计划任务。                  |
|     `sessions`     | 允许从Spring Session支持的会话存储中检索和删除用户会话。需要使用Spring Session的基于Servlet的Web应用程序。 |
|     `shutdown`     |                使应用程序正常关闭。默认禁用。                |
|     `startup`      | 显示由`ApplicationStartup`收集的启动步骤数据。需要使用`SpringApplication`进行配置`BufferingApplicationStartup`。 |
|    `threaddump`    |                        执行线程转储。                        |

> 最常用的Endpoint
>
> Health：监控状况
>
> Metrics：运行时指标
>
> Loggers：日志记录



### Health Endpoint

> 健康检查端点，我们一般用于在云平台，平台会定时的检查应用的健康状况，我们就需要Health Endpoint可以为平台返回当前应用的一系列组件健康状况的集合。
>
> 重要的几点：
>
> - health endpoint返回的结果，应该是一系列健康检查后的一个汇总报告
> - 很多的健康检查默认已经自动配置好了，比如：数据库、redis等
>
> - 可以很容易的添加自定义的健康检查机制

```yaml
management:
  endpoints:
    enabled-by-default: true 
    web:
      exposure:
        include: '*' 
  endpoint:
    health:
      show-details: always
```



### Metrics Endpoint

> 提供详细的、层级的、空间指标信息，这些信息可以被pull（主动推送）或者push（被动获取）方式得到；
>
> - 通过Metrics对接多种监控系统
> - 简化核心Metrics开发
>
> - 添加自定义Metrics或者扩展已有Metrics



### 开启关闭

```yaml
management:
  endpoints:
    enabled-by-default: false
    web:
      exposure:
        include: '*'
  endpoint:
    health:
      show-details: always
      enabled: true
    info:
      enabled: true
    beans:
      enabled: true
```

> 不默认开启所有，仅手动开启需要的端点



### 定制Endpoint

#### 定制Health

```java
@Component
public class MyHealthIndicator extends AbstractHealthIndicator {
    @Override
    protected void doHealthCheck(Health.Builder builder) throws Exception {
        //在这里测试你想测试的组件
        Map<String, Object> map = new HashMap<>();
        if (1==1){
            builder.status(Status.UP);
            map.put("count",1);
            map.put("ms",100);
        }else {
            builder.status(Status.DOWN);
            map.put("error","timeout");
        }

        builder.withDetails(map);
    }
}
```



#### 定制Info

```yaml
info:
  ProjectName: @project.artifactId@
  ProjectVersion: @project.version@
```

> @@之间包裹的动态取值pom文件

```java
@Component
public class AppInfoContributor implements InfoContributor {
    @Override
    public void contribute(Info.Builder builder) {
        Map<String,Object> map = new HashMap<>();
        map.put("msg","你好");
        map.put("版本","1.0.0");
        builder.withDetails(map);
    }
}
```

> 也可以吧info信息通过一个类写进去



#### 定制Metrics

```java
@Service
public class CityService {
    @Autowired
    CityMapper cityMapper;

    Counter cityServiceCounter;

    public CityService(MeterRegistry meterRegistry) {
        cityServiceCounter = meterRegistry.counter("CityService.Count");
    }

    public City getCityById(Long id){
        cityServiceCounter.increment();
        return cityMapper.getById(id);
    }
}
```



#### 定制Endpoint

```java
@Component
@Endpoint(id = "myService")
public class MyServiceEndpoint {

    @ReadOperation
    public Map getInfo(){
        return Collections.singletonMap("info","started...");
    }

    @WriteOperation
    public void restart(){
        System.out.println("close");
    }
}
```



### 可视化界面

#### 客户端

```properties
spring.boot.admin.client.url=http://localhost:8080
management.endpoints.web.exposure.include=*
```

> 在需要被监控的客户端填写这些信息，将endpoint传入指定服务器

```xml
<dependency>
    <groupId>de.codecentric</groupId>
    <artifactId>spring-boot-admin-starter-client</artifactId>
    <version>2.3.1</version>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

> 客户端需要导入这些依赖

#### 服务端

```xml
<dependency>
    <groupId>de.codecentric</groupId>
    <artifactId>spring-boot-admin-starter-server</artifactId>
    <version>2.3.1</version>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

> 将这些依赖导入服务端

> 在配置类上添加@EnableAdminServer注解



## Profiles

> 可以写多个配置文件
>
> application-text
>
> application-prod

> 然后在application中使用
>
> spring.profiles.actice=text
>
> 来指定哪个配置文件生效

> 也可以在运行命令中
>
> java -jar xxx.jar --spring.profiles.actice=text

> 也可以在类上标注
>
> @Profile("production")
>
> 表示此类只在production环境中生效

> 也可以给配置文件分组
>
> spring.profiles.group.mytest[0]=test
>
> spring.profiles.group.mytest[1]=mytest
>
> spring.profiles.group.prod[1]=ppd
>
> 当使用spring.profiles.actice=mytext
>
> 会激活mytest分组下所有配置文件



## 外部化配置

> 配置文件查找位置
>
> (1) classpath 根路径
>
> (2) classpath 根路径下config目录
>
> (3) jar包当前目录
>
> (4) jar包当前目录的config目录
>
> (5) /config子目录的直接子目录

