# Spring注解驱动

## 组件注册

### 注册

#### 老方法

```xml
<bean class="com.augus.bean.Person" id="person01">
    <property name="name" value="张三"/>
    <property name="age" value="18"/>
</bean>
```

> 之前我们需要这样来注册一个bean

```java
ClassPathXmlApplicationContext applicationContext = new ClassPathXmlApplicationContext("spring.xml");
Person p1 = applicationContext.getBean(Person.class);
System.out.println(p1);
```

> 这样来调用



#### 配置类

```java
//配置类
@Configuration
public class MainConfig {
    //注册为一个bean，class为返回值类型，id默认为方法名，或者使用value属性手动指定
    @Bean(value = "person01")
    public Person person(){
        return new Person("李四",20);
    }
}
```

```java
AnnotationConfigApplicationContext applicationContext = new AnnotationConfigApplicationContext(MainConfig.class);
Person p1 = applicationContext.getBean(Person.class);
System.out.println(p1);
Object p2 = applicationContext.getBean("person01");
System.out.println(p2);
```

> 调用时，要使用AnnotationConfigApplicationContext



---



### 包扫描

#### 老方法

```xml
<context:component-scan base-package="com.augus"/>
```

#### 配置类

```java
@ComponentScan(value = "com.augus")
public class MainConfig {
    ...
```

> 在**配置类上添加@ComponentScan(value = "com.augus")**即可

```java
@ComponentScan(value = "com.augus",excludeFilters = {
        @ComponentScan.Filter(type = FilterType.ANNOTATION,classes = {Controller.class, Service.class})
})
public class MainConfig {
```

> 在注解中也可以添加不包含哪些

```java
@ComponentScan(value = "com.augus",includeFilters = {
        @ComponentScan.Filter(type = FilterType.ANNOTATION,classes = {Controller.class, Service.class})
},useDefaultFilters = false)
```

> 指定只需要哪些组件，和之前一样，加入**useDefaultFilters = false**

> 也可以使用**ComponentScans注解，内部内容就是ComponentScan数组**
>
> 或者直接**添加多个ComponentScan注解**

> 我们使用了**FilterType.ANNOTATION**，根据注解类型来过滤
>
> 还可以指定
>
> **FilterType.ASSIGNABLE_TYPE：**按照给定类型
>
> ```java
> @ComponentScan.Filter(type = FilterType.ASSIGNABLE_TYPE,classes = {BookService.class})
> ```
>
> **这两个是我们最常用的**

> 还有以下的选项
>
> FilterType.ASPECTJ：使用ASPECTJ表达式
>
> FilterType.REGEX：使用正则表达式
>
> FilterType.CUSTOM：使用自定义规则
>
> 自定义规则需要我们自己写一个类，继承TypeFilter

```java
public class MyTypeFilter implements TypeFilter {
    @Override
    public boolean match(MetadataReader metadataReader, MetadataReaderFactory metadataReaderFactory) throws IOException {
        //metadataReader:读取到当前正在扫描类的信息
        //metadataReaderFactory:可以获取其他任何类的信息
        //获取当前类注解信息
        AnnotationMetadata annotationMetadata = metadataReader.getAnnotationMetadata();
        //获取当前类的类信息
        ClassMetadata classMetadata = metadataReader.getClassMetadata();
        //获取当前类的资源信息
        Resource resource = metadataReader.getResource();
        //获取类名
        String className = classMetadata.getClassName();

        if (className.contains("Service")){
            return true;
        }
        return false;
    }
}
```



---



### 组件作用域

```java
@Bean("person01")
public Person person(){
    return new Person("李四",20);
}
```

> **默认是单实例的**

```java
@Scope("prototype")
@Bean("person01")
public Person person(){
    return new Person("李四",20);
}
```

> 使用**@Scope("prototype")**改为多实例



---



### 懒加载

> 单实例对象默认容器启动就创建对象

```java
@Lazy
@Bean("person01")
public Person person(){
    return new Person("李四",20);
}
```

> 加入**@Lazy**，则可以改变为懒加载



---



### 按条件注册

> **@Conditional()**注解可以按照条件进行判断，满足条件则给容器中注册

```java
public class WindowsCondition implements Condition {
    @Override
    public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        //context:判断条件能使用的上下文
        //metadata:注释信息
        //获取当前IOC的工厂
        ConfigurableListableBeanFactory beanFactory = context.getBeanFactory();
        //获取类加载器
        ClassLoader classLoader = context.getClassLoader();
        //获取环境
        Environment environment = context.getEnvironment();
        //获取bean定义的注册类
        BeanDefinitionRegistry registry = context.getRegistry();

        String property = environment.getProperty("os.name");
        if (property.contains("Windows")){
            return true;
        }
        return false;
    }
}
```

> 需要自己写一个条件类

```java
@Conditional({WindowsCondition.class})
@Bean("person01")
public Person person(){
    return new Person("李四",20);
}
```

> 再将这个条件类，写入@Conditional
>
> 如果符合条件，才会注册对象

> @Conditional也可以放在类上
>
> 如果满足条件，此类中的配置才会生效



---



### 导入组件

#### 直接导入类

```java
@Configuration
@Import({Color.class,Red.class})
public class MainConfig {
    ...
```

> 在类上添加@Import()注解
>
> 快速导入指定类

#### ImportSelector

```java
public class MyImportSelector implements ImportSelector {
    @Override
    public String[] selectImports(AnnotationMetadata importingClassMetadata) {
        //importingClassMetadata:标注@import类的所有注解信息
        return new String[]{"com.augus.bean.Color","com.augus.bean.Person"};
    }
```

```java
@Configuration
@Import(MyImportSelector.class)
public class MainConfig {
```

> 也可以自己写一个ImportSelector，传入@Import注解中

#### ImportBeanDefinitionRegistrar

```java
public class MyImportBeanDefinitionRegistrar implements ImportBeanDefinitionRegistrar {

    @Override
    public void registerBeanDefinitions(AnnotationMetadata importingClassMetadata, BeanDefinitionRegistry registry) {
        //AnnotationMetadata:当前类的注解信息
        //BeanDefinitionRegistry:bean定义的注册类，调用其registerBeanDefinition方法，手动注册需要注册的类
        boolean color = registry.containsBeanDefinition("color");
        if (!color){
            //第一个参数，是注册bean的id
            //第二个参数需要传入BeanDefinition接口
            RootBeanDefinition beanDefinition = new RootBeanDefinition(Color.class);
            registry.registerBeanDefinition("color",beanDefinition);
        }
    }
}
```

```java
@Import(MyImportBeanDefinitionRegistrar.class)
```

> 写一个ImportBeanDefinitionRegistrar的实现，再将其传入@Import注解
>
> 可以手动注册组件



---



### FactoryBean

```java
public class ColorFactory implements FactoryBean<Color> {
    @Override
    public Color getObject() throws Exception {
        return new Color();
    }

    @Override
    public Class<?> getObjectType() {
        return Color.class;
    }

    @Override
    public boolean isSingleton() {
        return FactoryBean.super.isSingleton();
    }
}
```

```java
@Bean
public ColorFactory colorFactory(){
    return new ColorFactory();
}
```

```java
Object c1 = applicationContext.getBean("colorFactory");
System.out.println(c1);
```

> 这样就能注册一个自定义的工厂bean，但是获得的对象都是通过工厂创建出来的Color

```java
Object c1 = applicationContext.getBean("&colorFactory");
System.out.println(c1);
```

> 可以在获取id的开头加上&符号，来获取factory本身的对象



## 生命周期

### 指定初始化和销毁方法

#### 手动指定

```java
@Bean(initMethod = "init" , destroyMethod = "destroy")
public Car car(){
    return new Car();
}
```
#### 接口实现

```java
public class Cat implements InitializingBean, DisposableBean {
    public Cat() {
        System.out.println("cat constructor");
    }

    @Override
    public void destroy() throws Exception {
        System.out.println("destroy");
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        System.out.println("afterProperties");
    }
}
```

#### 注解实现

> @PostConstruct：在bean创建完成并且赋值完成，执行初始化方法
>
> @PreDestroy：在bean从容器中移除之前，执行方法

```java
@Component
public class Dog {
    public Dog() {
        System.out.println("Dog constructor");
    }

    @PostConstruct
    public void init(){
        System.out.println("Dog postConstruct");
    }

    @PreDestroy
    public void destroy(){
        System.out.println("Dog preDestroy");
    }
}
```

#### 后置处理器

```java
@Component
public class MyBeanProcessor implements BeanPostProcessor {
    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("BeforeInit..." + beanName + ":" + bean);
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("AfterInit..." + beanName + ":" + bean);
        return bean;
    }
}
```

> 实现BeanPostProcessor 接口，可以定义初始化之前和之后的处理器



## 属性赋值

```java
public class Person {
    @Value("张三")
    private String name;
    @Value("#{20-2}")
    private Integer age;
```

> 可以使用@Value为属性赋值
>
> 支持基本数值，SpEL表达式，${}取出配置文件中的值

```java
@PropertySource(value = {"p.properties"})
```

> 如果要用${}取值需要添加指定配置文件路径



#### Autowire

> Autowire标注在方法上，spring创建当前对象就会调用方法完成赋值，会从容器中寻找对应类型的参数
>
> Autowire标注在构造器上，spring创建当前对象就会调用构造器完成对象创建
>
> Autowire标注在参数上，spring也会自动从容器中寻找

