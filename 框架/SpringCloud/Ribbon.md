# Ribbon

> `简介`
>
> Spring Cloud Ribbon 是基于Netflix Ribbon实现的一套客户端负载均衡工具
>
> 主要提供客户端负载均衡算法，和服务调用
>
> 我们很容易使用Ribbon实现自定义负载均衡算法
>
> Ribbon是一个软负载均衡客户端组件
>
> 它可以和其他客户端结合使用，比如和Eureka结合

> `未来趋势`
>
> Spring Cloud 计划使用 Loadbalancer 将 Ribbon 替换掉
>
> 但Ribbon现在使用基数仍然十分广泛

> `Ribbon VS Nginx`
>
> Ribbon是本地负载均衡，Nginx是服务器负载均衡
>
> 客户端所有请求会交给Nginx，Nginx来实现转发
>
> Ribbon在调用服务时，会将注册信息缓存到本地，通过RPC实现远程访问



## 依赖

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-netflix-ribbon</artifactId>
</dependency>
```

> 其实在spring-cloud-starter-netflix-eureka-client中已经依赖了此依赖



## RestTemplate



```java
@GetMapping("/consumer/payment/create")
public CommonResult<Payment> create(Payment payment){
    return restTemplate.postForObject(PAYMENT_URL + "/payment/create",payment,CommonResult.class);
}

@GetMapping("/consumer/payment/get/{id}")
public CommonResult<Payment> getPayment(@PathVariable("id") Long id){
    return restTemplate.getForObject(PAYMENT_URL + "/payment/get/" + id,CommonResult.class);
}
```

> 我们之前已经用过 postForObject 方法和 getForObject 方法

> getForObject方法会将数据转换成对象，基本可以理解为返回的是Json
>
> getForEntity方法返回的是ResponseEntity对象，包含了响应头，响应体，状态码等其他详细信息

```java
@GetMapping("/consumer/payment/getForEntity/{id}")
public CommonResult<Payment> getPayment2(@PathVariable("id") Long id){
    ResponseEntity<CommonResult> entity = restTemplate.getForEntity(PAYMENT_URL + "/payment/get/" + id, CommonResult.class);

    if (entity.getStatusCode().is2xxSuccessful()){
        return entity.getBody();
    }else {
        return new CommonResult<>(444,"操作失败");
    }
}
```

> postForObject 和  postForEntity 同理



## 负载均衡规则

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\框架\SpringCloud\Ribbon.assets\IRule.jpg)

### 常用规则

> com.netflix.loadbalancer.RoundRobbinRule	轮询
>
> com.netflix.loadbalancer.RandomRule	随机
>
> com.netflix.loadbalancer.RetryRule	先按照轮询策略获取，如果获取失败则在指定时间内重试
>
> WeightedResponseTimeRule	对轮询的扩展，响应速度越快，权重越大
>
> BestAvailableRule	先过滤由于多次访问故障而处于断路器跳闸状态的服务，再选择并发量最小的服务
>
> AvailabilityFilteringRule	先过滤掉故障实例，再选择并发量小的实例
>
> ZoneAvoidanceRule	默认，判断server所在区域的性能，和server的可用性，选择服务器

### 选择负载规则

#### 配置类

> 注意：
>
> 自定义配置类不能放在@ComponentScan所扫描的包或子包下
>
> 否则此配置会被所有Ribbon客户端共享
>
> 也就是说，在SpringBoot环境中，不能放在主程序所在包及其子包下，在主程序的外部创建新的包存放配置类

```java
package com.augus.myrule;

import com.netflix.loadbalancer.IRule;
import com.netflix.loadbalancer.RandomRule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MyselfRule {

    @Bean
    public IRule myRule(){
        return new RandomRule();
    }
}
```
#### 主程序

```java
@SpringBootApplication
@EnableEurekaClient
@RibbonClient(name = "CLOUD-PAYMENT-SERVICE",configuration = MyselfRule.class)
public class OrderMain80 {
    public static void main(String[] args) {
        SpringApplication.run(OrderMain80.class,args);
    }
}
```

> 在主程序上添加@RibbonClient注释
>
> name：填写要访问的服务名
>
> configuration：填写配置类

> 这里name要写成全大写，我也不知道为什么，不然不会生效，应该是Eureka自动转成了大写



### 原理

> rest接口第几次请求	对	集群中服务器总数量	取余
>
> 得到实际使用的服务器index

> List\<ServiceInstance> instances = discoveryClient.getInstances("CLOUD-PAYMENT-SERVICE")
>
> 请求数1：	1	%	2	=	1	调用instance[1]
>
> 请求数2：	2	%	2	=	0	调用instance[0]
>
> 请求数3：	3	%	2	=	1	调用instance[1]
>
> 请求数4：	4	%	2	=	0	调用instance[0]



### 自定义算法

```java
@Configuration
public class ApplicationContextConfig {

    @Bean
//    @LoadBalanced
    public RestTemplate getRestTemplate(){
        return new RestTemplate();
    }
}
```

> 将原先的负载均衡注释掉，方便我们检查结果

```java
@Component
public class MyLB implements LoadBalance {

    private AtomicInteger atomicInteger = new AtomicInteger(0);

    public final int getAndIncrement(){
        int current;
        int next;

        do{
            current = this.atomicInteger.get();
            next = current >= 2147483647 ? 0 : current + 1;
        } while (!this.atomicInteger.compareAndSet(current,next));

        return next;
    }

    @Override
    public ServiceInstance instances(List<ServiceInstance> serviceInstances) {
        int index = getAndIncrement() % serviceInstances.size();
        return serviceInstances.get(index);
    }
}
```

> 实现轮询算法

```java
@Autowired
private LoadBalance loadBalance;
@Autowired
private DiscoveryClient discoveryClient;

@GetMapping(value = "/consumer/payment/lb")
public String getPaymentLB(){
    List<ServiceInstance> instances = discoveryClient.getInstances("CLOUD-PAYMENT-SERVICE");
    if (instances == null || instances.size() <= 0){
        return null;
    }

    ServiceInstance serviceInstance = loadBalance.instances(instances);
    URI uri = serviceInstance.getUri();
    return restTemplate.getForObject(uri + "/payment/lb",String.class);
}
```

> 测试我们自己写的轮询有没有生效

