# 02 Spring-AOP

> Aspect Oriented Programming：面向切面编程
>
> 基于面向对象编程思想之上的编程思想
>
> 在程序运行期间，将某段代码切入到指定位置运行的编程方式，叫做面向切面编程



## 引入

> 计算器运行计算方法时，进行日志记录

```java
public class CalculatorImpl implements Calculator{
    @Override
    public int add(int i, int j) {
        int result = i + j;
        return result;
    }

    @Override
    public int sub(int i, int j) {
        int result = i - j;
        return result;
    }

    @Override
    public int mul(int i, int j) {
        int result = i * j;
        return result;
    }

    @Override
    public int div(int i, int j) {
        int result = i / j;
        return result;
    }
}
```

```java
public static Calculator getProxy(final Calculator calculator){

    InvocationHandler invocationHandler = new InvocationHandler(){

        @Override
        public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
            //利用反射执行目标方法
            Object invoke = method.invoke(calculator, args);
            //必须返回，让外界获取到方法执行后的返回值
            return invoke;
        }
    };
    Class<?>[] interfaces = calculator.getClass().getInterfaces();
    ClassLoader loader = calculator.getClass().getClassLoader();

    Object instance = Proxy.newProxyInstance(loader,interfaces,invocationHandler);
    return (Calculator) instance;
}
```

> Java底层为我们提供了代理
>
> 可以让我们在方法执行前后做一些事情

```java
@Override
public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {

    System.out.println("[" + method.getName() + "]方法开始执行了，用的参数为：" + Arrays.asList(args));
    Object invoke = method.invoke(calculator, args);
    System.out.println("[" + method.getName() + "]方法执行完成，结果为：" + invoke);
    return invoke;
}
```

> 我们就可以在代理中，插入我们想要的日志内容
>
> 而不改变任何源代码

```java
@Test
public void test01(){
    Calculator calculator = new CalculatorImpl();
    Calculator proxy = CalculatorProxy.getProxy(calculator);
    proxy.add(1,2);
}
```

> 我们也可以定义一个工具类

```java
public class LogUtil {

    public static void logStart(Method method,Object...objects){
        System.out.println("[" + method.getName() + "]方法开始执行了，用的参数为：" + Arrays.asList(objects));
    }
    public static void logReturn(Method method,Object result){
        System.out.println("[" + method.getName() + "]方法执行完成，结果为：" + result);
    }
}
```

```java
InvocationHandler invocationHandler = new InvocationHandler(){

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {

        LogUtil.logStart(method,args);
        Object invoke = method.invoke(calculator, args);
        LogUtil.logReturn(method,invoke);
        return invoke;
    }
};
```

> 在代理中直接调用工具类的方法

> 虽然这样能解耦合，很强大
>
> 但是**写起来太麻烦**
>
> 而且还有一个致命缺陷
>
> 如果这个类，没有实现任何接口，在实现动态代理时会无法传入参数
>
> 所以，**没有实现任何接口的类，无法实现代理**

> 所以出现了Spring的AOP功能，代码简单，也不强制要求实现接口



## 专业术语

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\SSM\Spring\笔记\AOP1.png)



## Hello World

> 不使用代理，将日志切入到Calculator



### 依赖

```xml
<!-- https://mvnrepository.com/artifact/org.springframework/spring-aspects -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-aspects</artifactId>
    <version>5.3.8</version>
</dependency>
```

> 这个包功能不是很强大

```xml
<!-- https://mvnrepository.com/artifact/cglib/cglib -->
<dependency>
    <groupId>cglib</groupId>
    <artifactId>cglib</artifactId>
    <version>3.3.0</version>
</dependency>
<!-- https://mvnrepository.com/artifact/aopalliance/aopalliance -->
<dependency>
    <groupId>aopalliance</groupId>
    <artifactId>aopalliance</artifactId>
    <version>1.0</version>
</dependency>
<!-- https://mvnrepository.com/artifact/org.aspectj/aspectjweaver -->
<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjweaver</artifactId>
    <version>1.9.7</version>
    <scope>runtime</scope>
</dependency>
```

> 他们是第三方加强版的面向切面编程
>
> （即使目标没有实现任何接口，也能实现代理）

> **注意aspectjweaver不要导入，spring-aspects有些版本默认包含，如果导入会冲突**



### 配置

> 1. 将目标类和切面类都注册进Spring容器

```java
@Component
public class LogUtil {
    ...
        
@Component
public class CalculatorImpl implements Calculator{
    ...
```

> 2. 告诉Spring哪个是切面类

```java
@Aspect
@Component
public class LogUtil {
```



> 3. 告诉Spring切面类中的方法，何时运行

```java
@Aspect
@Component
public class LogUtil {

    @Before("execution(public int com.augus.calc.CalculatorImpl.*(int,int))")
    public static void logStart(){
        System.out.println("[]方法开始执行了，用的参数为：xxx");
    }

    @AfterReturning("execution(public int com.augus.calc.CalculatorImpl.*(int,int))")
    public static void logReturn(){
        System.out.println("[]方法执行完成，结果为：");
    }

    @AfterThrowing("execution(public int com.augus.calc.CalculatorImpl.*(int,int))")
    public static void logException(){
        System.out.println("方法出现异常");
    }

    @After("execution(public int com.augus.calc.CalculatorImpl.*(int,int))")
    public static void logEnd(){
        System.out.println("方法结束了");
    }
```

> 通知注解：
>
> **@Before：前置通知**  在目标方法之前运行
>
> **@After：后置通知**  在目标方法结束之后运行
>
> **@AfterReturning：返回通知**  在目标方法正常返回之后运行
>
> **@AfterThrowing：异常通知**  在目标方法抛出异常之后运行
>
> **@Around：环绕通知**



> 4. 开启AOP

```xml
<aop:aspectj-autoproxy></aop:aspectj-autoproxy>
```



## AOP细节



### 容器中保存的是代理对象

```java
@Test
public void test01(){
    Calculator bean = ioc.getBean(Calculator.class);
    bean.add(1,2);
    System.out.println(bean.getClass());
}
//class com.sun.proxy.$Proxy20
```

> AOP的底层就是动态代理
>
> 容器中保存的组件是它的代理对象
>
> 所以无法通过目标类从容器中获取对象
>
> 只能通过接口来获取，或者通过id获取
>
> 通过id获取，也只能转为接口类，不能转为实现类



### 为没有实现接口的类创建代理

```java
@Component
public class CalculatorImpl{

    public int add(int i, int j) {
        int result = i + j;
        return result;
    }
    
    public int sub(int i, int j) {
        int result = i - j;
        return result;
    }
    
    public int mul(int i, int j) {
        int result = i * j;
        return result;
    }
    
    public int div(int i, int j) {
        int result = i / j;
        return result;
    }
}
```

```java
CalculatorImpl bean = ioc.getBean(CalculatorImpl.class);
bean.add(1,2);
System.out.println(bean.getClass());
```

> 会发现也可以执行切入的内容
>
> class的类型为：class com.augus.calc.CalculatorImpl\$\$EnhancerBySpringCGLIB$$efd6273a
>
> 是cglib为我们创建的代理对象



### 切入点表达式

> 固定格式
>
> execution(方法权限符 返回值类型 方法全类名(参数表))

> **\***
>
> 1. 匹配一个或多个字符
>
>    ```java
>    execution(public int com.augus.calc.Cal*Impl.*(int,int))
>    ```
>
> 2. 匹配任意参数
>
>    ```java
>    execution(public int com.augus.calc.Cal*.*(*,int))
>    ```
>
> 3. 匹配任意一层路径
>
>    ```java
>    execution(public int com.*.calc.Cal*.*(*,int))
>    ```
>
> 4. 任意返回值类型
>
>    ```java
>    execution(public * com.*.calc.Cal*.*(*,int))
>    ```
>
> 5. 权限不可以使用*来匹配所有，可以不写权限符
>
> 6. 以*开头，可以代表所有包
>
>    ```java
>    execution(* *.*(..))
>    //千万别这样写
>    ```

> **..**
>
> 1. 匹配任意多个参数，任意类型
>
>    ```java
>    execution(public int com.augus.calc.Cal*.*(..))
>    ```
>
> 2. 匹配任意多层路径
>
>    ```java
>    execution(public int com.augus..Cal*.*(..))
>    ```

> 表达式之间可以使用&&，||来连接
>
> 或者使用！来取反



### 通知方法执行顺序

> 1. 正常执行情况
>
>    @Before  --->   @After  --->   @AfterReturning
>
> 2. 有异常情况
>
>    @Before  --->   @After  --->   @AfterThrowing



### JoinPoint获取目标方法信息

> 我们发现现在写的AOP不像之前动态代理，获取了方法名，返回值，参数列表等各种信息
>
> 在AOP中我们使用JoinPoint来获取这些信息
>
> 我们需要在通知方法参数加入JoinPoint参数，这个参数中封装了当前方法的详细信息

```java
@Before("execution(public int com.augus.calc.CalculatorImpl.*(int,int))")
public static void logStart(JoinPoint joinPoint){
    Object[] args = joinPoint.getArgs();
    Signature signature = joinPoint.getSignature();
    String name = signature.getName();
    System.out.println("[" + name + "]方法开始执行了，用的参数为：" + Arrays.asList(args));
}
```



### 返回值、异常获取

```java
@AfterReturning(value = "execution(public int com.augus.calc.CalculatorImpl.*(int,int))",returning = "result")
public static void logReturn(JoinPoint joinPoint,Object result){
    System.out.println("[" + joinPoint.getSignature().getName() + "]方法执行完成，结果为：" + result);
}
```

> 我们可以直接把返回值写在参数里
>
> 但是要去注解中声明，哪个变量是返回值
>
> 返回值的类型尽量写大
>
> 比如如果限定为int，只有在返回int时，此方法才会被调用

```java
@AfterThrowing(value = "execution(public int com.augus.calc.CalculatorImpl.*(int,int))", throwing = "e")
public static void logException(JoinPoint joinPoint,Exception e){
    System.out.println("[" + joinPoint.getSignature().getName() + "]方法出现异常,异常信息是：" + e);
}
```

> 异常也是一样，属性换为了throwing
>
> 异常如果写的详细，只有出现这个指定的异常时，通知才会被调用



### 通知方法的约束

> Spring对通知方法要求不严格，返回值，修饰符都可以随意写
>
> 唯一的要求是：方法的参数列表不可以乱写
>
> 因为Spring是通过反射调用方法，所以每一个参数Spring都需要知道这是什么



### 抽取切入点表达式

> 1. 随便声明一个没有实现的，返回void的空方法
> 2. 在方法上标注Pointcut注解
> 3. 然后用方法名（）替换掉之前的表达式

```java
@Aspect
@Component
public class LogUtil {

    @Pointcut("execution(public int com.augus.calc.CalculatorImpl.*(int,int))")
    public void haha(){};

    @Before("haha()")
    public static void logStart(JoinPoint joinPoint){
        Object[] args = joinPoint.getArgs();
        Signature signature = joinPoint.getSignature();
        String name = signature.getName();
        System.out.println("[" + name + "]方法开始执行了，用的参数为：" + Arrays.asList(args));
    }

    @AfterReturning(value = "haha()",returning = "result")
    public static void logReturn(JoinPoint joinPoint,Object result){
        System.out.println("[" + joinPoint.getSignature().getName() + "]方法执行完成，结果为：" + result);
    }

    @AfterThrowing(value = "haha()", throwing = "e")
    public static void logException(JoinPoint joinPoint,Exception e){
        System.out.println("[" + joinPoint.getSignature().getName() + "]方法出现异常,异常信息是：" + e);
    }

    @After("haha()")
    public static void logEnd(JoinPoint joinPoint){
        System.out.println("[" + joinPoint.getSignature().getName() + "]方法结束了");
    }

}
```



### 环绕通知

> 环绕通知是Spring中最强大的通知
>
> 前面的四种通知，四合一就是环绕通知

```java
@Around("haha()")
public Object myAround(ProceedingJoinPoint pjp){
    Object[] args = pjp.getArgs();
    Object proceed = null;
    try {
        System.out.println("[环绕前置][" + pjp.getSignature().getName() + "]方法开始");
        proceed = pjp.proceed(args);
        System.out.println("[环绕返回][" + pjp.getSignature().getName() + "]方法返回，返回值：" + proceed);
    } catch (Throwable throwable) {
        System.out.println("[环绕异常][" + pjp.getSignature().getName() + "]方法异常，异常信息：" + throwable);
        throwable.printStackTrace();
    } finally {
        System.out.println("[环绕后置][" + pjp.getSignature().getName() + "]方法结束");
    }
    return proceed;
}
```

> 环绕通知和其他通知并存时
>
> 环绕通知优先执行
>
> （    环绕前置  --->   普通前置  --->     ） 目标方法  --->   环绕返回/环绕异常  --->   环绕后置  --->   普通返回/普通异常  --->   普通后置

```java
@Around("haha()")
public Object myAround(ProceedingJoinPoint pjp){
    Object[] args = pjp.getArgs();
    Object proceed = null;
    try {
        System.out.println("[环绕前置][" + pjp.getSignature().getName() + "]方法开始");
        proceed = pjp.proceed(args);
        System.out.println("[环绕返回][" + pjp.getSignature().getName() + "]方法返回，返回值：" + proceed);
    } catch (Throwable throwable) {
        System.out.println("[环绕异常][" + pjp.getSignature().getName() + "]方法异常，异常信息：" + throwable);
        throw new RuntimeException(throwable);
    } finally {
        System.out.println("[环绕后置][" + pjp.getSignature().getName() + "]方法结束");
    }
    return proceed;
}
```

> 因为环绕做了try catch，外界无法感知异常
>
> 所以要再次抛出，让外界感知到异常



### 多个切面执行顺序

> 先进入的后出去
>
> 进入的顺序由切面类名的字符串顺序来决定
>
> 或者在类上加入@Order() 注解 括号中填入大于零的整数，数字越小优先级越高

> 环绕的优先级，仅影响当前切面的优先级，并不影响整体的优先级





## 主要使用场景

> 1. 日志
> 2. 权限验证
> 3. 事务控制



## XML配置

> 1. 将目标和切面都加入到容器中
> 2. 告诉Spring哪个是切面类
> 3. 在切面类中配置通知方法何时何地运行
> 4. 开启AOP功能

```xml
<bean id="logUtil" class="com.augus.util.LogUtil"></bean>
<bean id="calculator" class="com.augus.calc.CalculatorImpl"></bean>

<aop:config>
    <aop:pointcut id="exp1" expression="execution(* com.augus.*.*(..))"/>
    <aop:aspect ref="logUtil"  order="2">
        <aop:before method="logStart" pointcut-ref="exp1"/>
        <aop:after-returning method="logReturn" pointcut-ref="exp1" returning="result"/>
        <aop:after-throwing method="logException" throwing="e" pointcut-ref="exp1"/>
        <aop:after method="logEnd" pointcut-ref="exp1"/>
        <aop:around method="myAround" pointcut-ref="exp1"/>
    </aop:aspect>
</aop:config>
```

> xml配置多个切面，如果不写order
>
> 优先级会从上往下执行

> **重要的用配置，不重要的用注解**



## 声明式事务



### JDBCTemplate （了解）

#### 依赖

```xml
<!-- https://mvnrepository.com/artifact/org.springframework/spring-jdbc -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jdbc</artifactId>
    <version>5.3.8</version>
</dependency>
<!-- https://mvnrepository.com/artifact/org.springframework/spring-orm -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-orm</artifactId>
    <version>5.3.8</version>
</dependency>
```

#### 注册JDBCTemplate

```xml
<bean class="org.springframework.jdbc.core.JdbcTemplate" id="jdbcTemplate">
    <constructor-arg name="dataSource" ref="dataSource"></constructor-arg>
</bean>
```

#### 使用JDBCTemplate

```java
String sql = "update employee set salary = ? where emp_id = ?";
int update = jdbcTemplate.update(sql, 1300.00, 5);
System.out.println("更新完成");
```



### 环境搭建

```java
@Repository
public class BookDao {

    @Autowired
    JdbcTemplate jdbcTemplate;

    public void updateBalance(String username, int price){
        String sql = "update account set balance = balance - ? where username = ?";
        int update = jdbcTemplate.update(sql, price, username);
    }

    public int getPrice(String isbn){
        String sql = "select price from book where isbn = ?";
        Integer price = jdbcTemplate.queryForObject(sql, Integer.class, isbn);
        return price;
    }

    public void updateStock(String isbn){
        String sql = "update book_stock set stock = stock - 1 where isbn = ?";
        int update = jdbcTemplate.update(sql, isbn);
    }
}
```

```java
@Service
public class BookService {

    @Autowired
    BookDao bookDao;

    public void checkout(String username,String isbn){
        bookDao.updateStock(isbn);
        int price = bookDao.getPrice(isbn);
        bookDao.updateBalance(username,price);
    }
}
```

```java
BookService bean = ioc.getBean(BookService.class);
bean.checkout("Tom","ISBN-001");
System.out.println("结账完成");
```



### 什么是声明式事务

> 以前通过复杂的编程来编写一个事务
>
> 现在只需要告诉Spring哪个方法是事务方法即可
>
> Spring自动进行事务控制

> 事务管理代码的固定模式作为一种横切关注点
>
> 可以通过AOP方法模块化
>
> 进而借助Spring AOP框架实现声明事务管理

> 自己要写切面还是很麻烦
>
> Spring已经帮我们把切面写好了，这个事务切面叫事务管理器（PlatformTransactionManager）
>
> 我们使用其实现类DataSourceTransactionManager



### 添加事务管理

> 1. 配置事务管理器
>
>    导入面向切面的依赖

```xml
<bean class="org.springframework.jdbc.datasource.DataSourceTransactionManager" id="transactionManager">
    <property name="dataSource" ref="dataSource"></property>
</bean>
```

> 只要控制数据源，就可以做到控制事务
>
> 数据源是其一个属性，所以为其赋值即可



> 2. 开启基于注解的事务控制

```xml
<tx:annotation-driven transaction-manager="transactionManager"/>
```



> 3. 给事务方法加注解

```java
@Transactional
public void checkout(String username,String isbn){
    bookDao.updateStock(isbn);
    int price = bookDao.getPrice(isbn);
    bookDao.updateBalance(username,price);
}
```



## 事务细节

> 在@Transactional()中我们可以设置很多属性
>
> **isolation：**事务的隔离级别
>
> **propagation：**事务的传播行为
>
> **rollbackFor：**哪些异常事务需要回滚
>
> **rollbackForClassName：**哪些异常事务需要回滚（String全类名）
>
> **noRollbackFor：**哪些异常事务不回滚
>
> **noRollbackForClassName：**哪些异常事务不回滚（String全类名）
>
> **readOnly：**设置事务为只读
>
> **timeout：**事务超出指定时长后自动中止并回滚



### 超时设置

```java
@Transactional(timeout = 3)
```

> 以秒为单位，超时后自动中止，并回滚



### 只读事务

> 可以进行事务优化，如果事务只读，可以设置此属性，不管事务，可以加快运行速度



### 回滚控制

> 运行时异常默认都回滚
>
> 编译时异常默认不回滚

```java
@Transactional(noRollbackFor = {ArithmeticException.class,NullPointerException.class})
```

> 这样声明，数学运算异常和空指针异常则不会回滚

```java
@Transactional(rollbackFor = {FileNotFoundException.class})
```

> 这样声明，文件未找到异常则会回滚



### 隔离级别

```java
@Transactional(isolation = Isolation.READ_UNCOMMITTED)
```

> 通过isolation可以自己业务特性，控制事务的隔离级别



### 传播行为

> 如果有多个事务进行嵌套运行，子事务是否要和大事务共用一个事务
>
> 当事务方法被另一个事务方法调用时，必须指定事务传播行为

> Spring中定义了7种传播行为

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\SSM\Spring\笔记\aop2.png)

> **Required：**如果对方有事务，就加入，否则就自己创建事务**（常用）**
>
> **Required_New：**无论如何，自己启动一个新事务，其余事务暂停**（常用）**
>
> **Suppors：**如有对方有事务，就加入，否则自己也不创建事务
>
> **Not_Supports：**无论如何不运行在事务内，如果对方有事务，则将其暂停
>
> **Mandatory：**无论如何必须运行在事务内，如果没有事务，则抛异常
>
> **Never：**无论如何不运行在事务内，如果有事务，则抛异常
>
> **Nested：**运行一个嵌套事务

> 如果子事务加入父级事务
>
> 事务的配置都是父事务属性生效，子事务属性都会失效

> 如果是本类方法的嵌套调用
>
> 他们就是一个事务
>
> Required_New是不会生效的
>
> 因为他们属于一个类，只有这个类被代理控制了事务
>
> 函数并不能被代理直接控制



## XML事务控制

```xml
<!--事务管理器-->
<bean class="org.springframework.jdbc.datasource.DataSourceTransactionManager" id="transactionManager">
    <property name="dataSource" ref="dataSource"></property>
</bean>

<bean class="com.augus.service.BookService" id="service"></bean>

<!--将事务切到哪里去-->
<aop:config>
    <aop:pointcut id="exp1" expression="execution(* com.augus.*.*.*(..))"/>
    <aop:advisor advice-ref="myAdvice" pointcut-ref="exp1"/>
</aop:config>

<!--注册哪些方法需要添加事务-->
<tx:advice id="myAdvice" transaction-manager="transactionManager">
    <tx:attributes>
        <tx:method name="*"/>
        <tx:method name="checkout" propagation="REQUIRED"/>
        <tx:method name="get*" read-only="true"/>
    </tx:attributes>
</tx:advice>
```

