import java.io.FileReader;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Locale;
import java.util.Properties;


public class Test {
    public static void main(String[] args) throws Exception{

        //读配置文件
        Properties properties = new Properties();
        try {
            properties.load(new FileReader("src/MyLogConfig.properties"));
        } catch (IOException e) {
            e.printStackTrace();
        }

        //level负责记录日志等级
        //path负责记录输出路径
        //claz负责记录appender实现类
        String levelStr = properties.getProperty("mylog.level");
        int level = levelToIntLevel(levelStr);
        String path = properties.getProperty("mylog.file");
        String claz = properties.getProperty("mylog.rootLogger");

        //反射出实现类，也就等于决定了输出位置
        Class<?> aClass = Class.forName(claz);
        MyLog o = (MyLog) aClass.newInstance();

        //爆破注入两个属性
        Field ObjLevel = aClass.getDeclaredField("level");
        ObjLevel.setAccessible(true);
        ObjLevel.set(o,level);
        
        Field[] fields = aClass.getDeclaredFields();
        for (Field field : fields) {
            if (field.getName().equals("path")){
                Field ObjPath = aClass.getDeclaredField("path");
                ObjPath.setAccessible(true);
                ObjPath.set(o,path);
            }
        }

        //反射调用方法
        Method trace = aClass.getMethod("trace",String.class);
        Method debug = aClass.getMethod("debug",String.class);
        Method info = aClass.getMethod("info",String.class);
        Method warn = aClass.getMethod("warn",String.class);
        Method error = aClass.getMethod("error",String.class);
        Method fatal = aClass.getMethod("fatal",String.class);

        trace.invoke(o,"这是trace消息");
        debug.invoke(o,"这是debug消息");
        info.invoke(o,"这是info消息");
        warn.invoke(o,"这是warn消息");
        error.invoke(o,"这是error消息");
        fatal.invoke(o,"这是fatal消息");

        //如果实现类有close就调用
        for (Field field : fields) {
            if (field.getName().equals("close")){
                Method close = aClass.getMethod("close");
                close.invoke(o);
            }
        }

    }

    //这是一个将配置文件中日志等级，转换为对应数字级别
    public static int levelToIntLevel(String level){
        level = level.toUpperCase(Locale.ROOT);
        switch (level){
            case "ALL":
                return 100;
            case "TRACE":
                return 10;
            case "DEBUG":
                return 8;
            case "INFO":
                return 6;
            case "WARN":
                return 4;
            case "ERROR":
                return 2;
            case "FATAL":
                return 0;
            default:
                return 6;
        }
    }
}
