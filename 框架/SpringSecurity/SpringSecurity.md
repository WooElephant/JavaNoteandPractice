# Spring Security

> SpringSecurity是一个能够为基于Spring的企业应用系统提供声明式的安全访问控制解决方案的安全框架
>
> 在SpringBoot项目中加入SpringSecurity更是十分简单



## SpringSecurity

### Hello World

#### 依赖

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.2.1.RELEASE</version>
    </parent>

    <groupId>org.example</groupId>
    <artifactId>SecurityTest</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>8</maven.compiler.source>
        <maven.compiler.target>8</maven.compiler.target>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
            <exclusions>
                <exclusion>
                    <groupId>org.junit.vintage</groupId>
                    <artifactId>junit-vintage-engine</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
        <dependency>
            <groupId>org.springframework.security</groupId>
            <artifactId>spring-security-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

</project>
```

#### 主启动

```java
@SpringBootApplication
public class SecurityMain {
    public static void main(String[] args) {
        SpringApplication.run(SecurityMain.class,args);
    }
}
```

#### 页面

```html
<form action="/login" method="post">
    用户名：<input type="text" name="username"/><br/>
    密码：<input type="password" name="password"><br/>
    <input type="submit" value="登陆">
</form>
```

> 登陆界面

```html
<h1>登陆成功</h1>
```

> 跳转界面



#### 测试

> 访问localhost:8080/login.html
>
> 发现出现了Security为我们设置的登陆界面
>
> 默认用户名为user，密码在控制台会输出



### UserDetailsService

> Sercurity为我们提供了这个接口
>
> 我们使用它来实现自定义登陆校验

```java
UserDetails loadUserByUsername(String var1) throws UsernameNotFoundException;
```

> 其中只有一个方法，返回UserDetails接口，该接口内定义了用户名，密码，权限等获取方法
>
> 我们会返回其实现类User



### PasswordEncoder

> 密码的传递需要进行加密
>
> 此接口就是用来加密的
>
> 我们一般使用BCryptPasswordEncoder实现类

```java
public interface PasswordEncoder {
    String encode(CharSequence var1);

    boolean matches(CharSequence var1, String var2);

    default boolean upgradeEncoding(String encodedPassword) {
        return false;
    }
}
```

> encode方法就是用来将密码加密的
>
> matches用于明文密码与加密密码比较
>
> upgradeEncoding用于二次加密，一般不用

```java
@Test
public void testPassWord(){
    PasswordEncoder encoder = new BCryptPasswordEncoder();
    String pw = encoder.encode("123456");
    System.out.println(pw);

    boolean matches = encoder.matches("123456", pw);
    System.out.println(matches);
}

/*
$2a$10$qLg7HILKAvkXvEPdfczqE.DaN8lYtxNA2i..R..g/rkF4ChPfMAXS
true
*/
```



### 自定义登陆逻辑

```java
@Configuration
public class SecurityConfig {

    @Bean
    public PasswordEncoder pe(){
        return new BCryptPasswordEncoder();
    }
}
```

> 向容器中声明一个PasswordEncoder

```java
@Service
public class UserService implements UserDetailsService {

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public UserDetails loadUserByUsername(String s) throws UsernameNotFoundException {

        if (!"admin".equals(s)){
            throw new UsernameNotFoundException("用户名错误！");
        }
        String password = passwordEncoder.encode("123456");

        return new User("admin",password,
                AuthorityUtils.commaSeparatedStringToAuthorityList("admin,normal"));
    }
}
```

> 正常来说，会将上面的步骤替换为从数据库中查找，然后与密码作比较，为了图方便，这里直接使用固定值
>
> 在User的第三个参数，我们需要一个权限列表，且不能为空，这里使用的AuthorityUtils.commaSeparatedStringToAuthorityList，可以将参数转换为权限列表，多个权限间使用逗号分割

> 返回的User对象就是数据库中的内容



### 自定义登陆界面

```java
@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.formLogin().loginPage("/login.html").loginProcessingUrl("/login").successForwardUrl("/toMain");
        http.authorizeRequests().antMatchers("/login.html").permitAll().anyRequest().authenticated();
        http.csrf().disable();
    }

    @Bean
    public PasswordEncoder pe(){
        return new BCryptPasswordEncoder();
    }
}
```

> 在配置类中，继承WebSecurityConfigurerAdapter
>
> 重写configure方法，参数是http的那个
>
> http.formLogin().loginPage("/login.html")指定登陆界面
>
> loginProcessingUrl("/login")指定登陆逻辑，前端请求为/login使其去找SpringSecurity的验证，与Controller无关
>
> successForwardUrl("/toMain")指定成功后页面跳转，必须为POST方式
>
> http.authorizeRequests().antMatchers("/login.html").permitAll()放行登陆界面，登录界面不需要验证
>
> .anyRequest().authenticated();表示拦截所有其他的请求
>
> http.csrf().disable();关闭csrf防护



### 登陆失败跳转

```java
@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.formLogin().loginPage("/login.html").loginProcessingUrl("/login").successForwardUrl("/toMain")
                .failureForwardUrl("/toError");
        http.authorizeRequests()
                .antMatchers("/login.html").permitAll()
                .antMatchers("/error.html").permitAll()
                .anyRequest().authenticated();
        http.csrf().disable();
    }

    @Bean
    public PasswordEncoder pe(){
        return new BCryptPasswordEncoder();
    }
}
```

> 增加一个.failureForwardUrl("/toError");处理失败的逻辑
>
> 并且.antMatchers("/error.html").permitAll()将页面放行

```html
<form action="/login" method="post">
    用户名：<input type="text" name="username"/><br/>
    密码：<input type="password" name="password"><br/>
    <input type="submit" value="登陆">
</form>
```

> 前端提交的用户名必须为username，密码为password，方式为post
>
> 否则过滤器获取不到其值

```java
@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.formLogin().loginPage("/login.html").loginProcessingUrl("/login").successForwardUrl("/toMain")
                .failureForwardUrl("/toError")
                .usernameParameter("username123").passwordParameter("password123");
        http.authorizeRequests()
                .antMatchers("/login.html").permitAll()
                .antMatchers("/error.html").permitAll()
                .anyRequest().authenticated();
        http.csrf().disable();
    }

    @Bean
    public PasswordEncoder pe(){
        return new BCryptPasswordEncoder();
    }
}
```

> .usernameParameter("username123").passwordParameter("password123");或者通过手动指定



### 自定义成功跳转

```java
public class MyAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    private final String url;

    public MyAuthenticationSuccessHandler(String url) {
        this.url = url;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Authentication authentication) throws IOException, ServletException {
        httpServletResponse.sendRedirect(url);
    }
}
```

> 默认的此处是转发，必须要求post方法
>
> 我们自定义一个handler，将成功方法改为重定向

```java
@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.formLogin().loginPage("/login.html").loginProcessingUrl("/login")
                .successHandler(new MyAuthenticationSuccessHandler("http://www.baidu.com"))
                .failureForwardUrl("/toError")
                .usernameParameter("username123").passwordParameter("password123");

        http.authorizeRequests()
                .antMatchers("/login.html").permitAll()
                .antMatchers("/error.html").permitAll()
                .anyRequest().authenticated();

        http.csrf().disable();

    }

    @Bean
    public PasswordEncoder pe(){
        return new BCryptPasswordEncoder();
    }
}
```

> .successHandler(new MyAuthenticationSuccessHandler("http://www.baidu.com"))使用successHandler去调用我们的Handler，来实现自定义的成功跳转逻辑

> handler中的authentication参数，可以获取权限和其他一些详细内容



### 自定义失败跳转

```java
public class MyAuthenticationFailureHandler implements AuthenticationFailureHandler {

    private final String url;

    public MyAuthenticationFailureHandler(String url) {
        this.url = url;
    }

    @Override
    public void onAuthenticationFailure(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, AuthenticationException e) throws IOException, ServletException {
        httpServletResponse.sendRedirect(url);
    }
}
```

> 与自定义成功跳转逻辑没有区别



### 授权URL匹配规则

```java
http.authorizeRequests()
        .antMatchers("/login.html").permitAll()
        .antMatchers("/error.html").permitAll()
        .anyRequest().authenticated();
```

> 权限会从上至下的执行，最后一般都是.anyRequest().authenticated()
>
> 所有请求必须授权后进行访问，在之前将不需要权限的页面提前放行

#### antMatchers()

> 其参数第一个值为请求方式，第二个值为可变长度，每个参数都是一个ant表达式，用于url匹配规则

> ?匹配一个字符
>
> *匹配0+个字符
>
> **匹配0+个目录

```java
.antMatchers("/js/**","/css/**").permitAll()
.antMatchers("/**/*.js").permitAll()
.antMatchers(HttpMethod.GET,"/**/*.jpg").permitAll()
```

#### regexMatchers()

> 其与antMatchers()的区别为，antMatchers()使用ant表达式，regexMatchers()使用正则表达式

```java
.regexMatchers(".+[.]js").permitAll()
```



### 权限访问控制

```java
http.authorizeRequests()
        .antMatchers("/login.html").permitAll()
        .antMatchers("/error.html").permitAll()
        .anyRequest().authenticated();
```

> 我们已经知道permitAll与authenticated
>
> permitAll：允许全部
>
> denyAll：拒绝全部
>
> anonymous：允许匿名
>
> authenticated：必须授权
>
> fullyAuthenticated：必须授权且不能为保存密码自动登录
>
> rememberMe：可以为自动登录

> 还有一些常用的
>
> hasAuthority()：参数中填入权限名的字符串
>
> hasAnyAuthority()：参数中填入多种权限名字符串，以逗号分割
>
> hasRole()：根据角色来判断
>
> hasAnyRole()：根据多种角色其中一种角色来判断，以逗号分割
>
> hasIpAddress()：根据ip地址来控制权限

```java
@Service
public class UserService implements UserDetailsService {

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public UserDetails loadUserByUsername(String s) throws UsernameNotFoundException {

        if (!"admin".equals(s)){
            throw new UsernameNotFoundException("用户名错误！");
        }
        String password = passwordEncoder.encode("123456");

        return new User("admin",password,
                AuthorityUtils.commaSeparatedStringToAuthorityList("admin,normal,ROLE_ABC"));
    }
}
```

> 在权限中，使用大写ROLR加下划线加角色名，来指定角色



### 自定义403

```java
public class MyAccessDeniedHandler implements AccessDeniedHandler {
    @Override
    public void handle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, AccessDeniedException e) throws IOException, ServletException {
        httpServletResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
        httpServletResponse.setContentType("application/json;charset=utf8");
        PrintWriter writer = httpServletResponse.getWriter();
        writer.write("{\"status\":\"403\",\"msg\":\"权限不足！\"}");
        writer.flush();
        writer.close();
    }
}
```

> 自定义一个类，实现AccessDeniedHandler接口

```java
@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.formLogin().loginPage("/login.html").loginProcessingUrl("/login")
                .successForwardUrl("/toMain")
                .failureForwardUrl("/toError")
                .usernameParameter("username").passwordParameter("password");

        http.authorizeRequests()
                .antMatchers("/login.html").permitAll()
                .antMatchers("/main1.html").hasAuthority("aaa")
                .anyRequest().authenticated();

        http.exceptionHandling().accessDeniedHandler(new MyAccessDeniedHandler());

        http.csrf().disable();

    }

    @Bean
    public PasswordEncoder pe(){
        return new BCryptPasswordEncoder();
    }
}
```

> 在配置中http.exceptionHandling().accessDeniedHandler(new MyAccessDeniedHandler());
>
> 使用我们自己的类，来处理异常



### 自定义权限验证

> 在access方法中不仅可以写我们之前提到的所有，也可以自定义权限控制

```java
@Service
public class MyServiceImpl implements MyService {
    @Override
    public boolean hasPermission(HttpServletRequest request, Authentication authentication) {
        String uri = request.getRequestURI();
        Object principal = authentication.getPrincipal();

        if (principal instanceof UserDetails){
            UserDetails userDetails = (UserDetails) principal;
            Collection<? extends GrantedAuthority> authorities = userDetails.getAuthorities();
            return authorities.contains(new SimpleGrantedAuthority(uri));
        }

        return false;
    }
}
```

> 写一个类，参数传入HttpServletRequest和Authentication
>
> 可以对其自定义处理
>
> userDetails.getAuthorities();就是获取UserDetails中我们定义的所有权限
>
> SimpleGrantedAuthority是GrantedAuthority（每一个权限的类型）的实现类

```java
@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.formLogin().loginPage("/login.html").loginProcessingUrl("/login")
                .successForwardUrl("/toMain")
                .failureForwardUrl("/toError")
                .usernameParameter("username").passwordParameter("password");

        http.authorizeRequests()
                .antMatchers("/login.html").permitAll()
                .antMatchers("/main1.html").hasAuthority("aaa")
                .anyRequest().access("@myServiceImpl.hasPermission(request,authentication)");

        http.exceptionHandling().accessDeniedHandler(new MyAccessDeniedHandler());

        http.csrf().disable();

    }

    @Bean
    public PasswordEncoder pe(){
        return new BCryptPasswordEncoder();
    }
}
```

> 使用的时候，使用.access("@myServiceImpl.hasPermission(request,authentication)");替代之前的控制



### 基于注解的访问控制

#### @Secured

```java
@SpringBootApplication
@EnableGlobalMethodSecurity(securedEnabled = true)
public class SecurityMain {
    public static void main(String[] args) {
        SpringApplication.run(SecurityMain.class,args);
    }
}
```

> 注解默认是不开启的，需要在启动类上加@EnableGlobalMethodSecurity(securedEnabled = true)

```java
@RequestMapping("/toMain")
@Secured("ROLE_aaa")
public String toMain(){
    return "redirect:main.html";
}
```

> 然后可以直接在controller的方法上加入@Secured注解，并设置role参数



#### @PreAuthorize

> 还可以使用@PreAuthorize和@PostAuthorize
>
> @PreAuthorize表示访问方法或类在执行之前判断权限，大多数情况下使用这个，注解的参数与access方法相同
>
> @PostAuthorize表示在方法执行之后判断权限，很少使用

```java
@SpringBootApplication
@EnableGlobalMethodSecurity(securedEnabled = true,prePostEnabled = true)
public class SecurityMain {
    public static void main(String[] args) {
        SpringApplication.run(SecurityMain.class,args);
    }
}
```

> 在启动类上增加参数prePostEnabled = true

```java
@RequestMapping("/toMain")
@PreAuthorize("hasRole('abc')")
public String toMain(){
    return "redirect:main.html";
}
```

> 在controller中使用@PreAuthorize注解



### remember me

```xml
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
    <version>2.2.0</version>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>
```

> SpringSecurity实现Remember Me需要依赖数据库连接

```java
@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private UserService userService;

    @Autowired
    private DataSource dataSource;

    @Autowired
    private PersistentTokenRepository tokenRepository;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.formLogin().loginPage("/login.html").loginProcessingUrl("/login")
                .successForwardUrl("/toMain")
                .failureForwardUrl("/toError");

        http.authorizeRequests()
                .antMatchers("/login.html").permitAll()
                .antMatchers("/error.html").permitAll()
                .anyRequest().authenticated();

        http.exceptionHandling().accessDeniedHandler(new MyAccessDeniedHandler());

        http.rememberMe().userDetailsService(userService).tokenRepository(tokenRepository);

        http.csrf().disable();

    }

    @Bean
    public PasswordEncoder pe(){
        return new BCryptPasswordEncoder();
    }

    @Bean
    public PersistentTokenRepository tokenRepository(){
        JdbcTokenRepositoryImpl tokenRepository = new JdbcTokenRepositoryImpl();
        //设置数据源
        tokenRepository.setDataSource(dataSource);
        //启动时创建表
        tokenRepository.setCreateTableOnStartup(true);
        return tokenRepository;
    }
}
```

> http.rememberMe().userDetailsService(userService).tokenRepository(tokenRepository);
>
> 为其指定登陆逻辑userService和持久化逻辑tokenRepository
>
> 因为tokenRepository要接收一个PersistentTokenRepository接口，该接口有两个实现类，分别为存在内存中和数据库中，我们使用JdbcTokenRepositoryImpl实现类，存在数据库中

```html
<form action="/login" method="post">
    用户名：<input type="text" name="username"/><br/>
    密码：<input type="password" name="password"><br/>
    记住我：<input type="checkbox" name="remember-me" value="true"><br/>
    <input type="submit" value="登陆">
</form>
```

> 前端这个CheckBox名称要为remember-me

```java
http.rememberMe().userDetailsService(userService).tokenRepository(tokenRepository).tokenValiditySeconds(60*60*24*7);
```

> 其默认有效时间是两周
>
> 可以通过tokenValiditySeconds(60\*60\*24*7)来设置，单位是秒



### 退出登陆

```html
<h1>登陆成功</h1>
<a href="/logout">退出登录</a>
```

> 框架为我们提供了/logout的接口，直接使用即可

```java
http.logout().logoutUrl("/logout").logoutSuccessUrl("/login.html");
```

> 也可以自定义登出的api，和登出跳转的页面



### CSRF

> CSRF（Cross-site request forgery）跨站请求伪造，通过伪造用户请求访问授信站点的非法请求访问
>
> CSRF防护默认开启，要求用户携带参数名为_csrf的token，如果与服务器不一致，则拒绝访问

```html
<form action="/login" method="post">
    <input type="hidden" th:if="${_csrf}" name="_csrf" th:value="${_csrf.getToken()}">
    用户名：<input type="text" name="username"/><br/>
    密码：<input type="password" name="password"><br/>
    记住我：<input type="checkbox" name="remember-me" value="true"><br/>
    <input type="submit" value="登陆">
</form>
```

> 在前端页面中，携带_csrf来访问



## Oauth2

> 用于解决第三方认证问题，为众多第三方授权认证提供标准协议



### 授权模式

#### 授权码模式

