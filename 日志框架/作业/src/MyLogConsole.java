import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 这是控制台输出实现类
 */
public class MyLogConsole implements MyLog{

    private int level = 6;//默认INFO级别
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public void setLevel(int level) {
        this.level = level;
    }

    @Override
    public void trace(String str) {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        if (level>=10){
            System.out.println("[TRACE]\t" + sdf.format(new Date()) + "\t" + stackTrace[6] + "\t" + str);
        }
    }

    @Override
    public void debug(String str) {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        if (level>=8){
            System.out.println("[DEBUG]\t" + sdf.format(new Date()) + "\t" + stackTrace[6] + "\t" + str);
        }
    }

    @Override
    public void info(String str) {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        if (level>=6){
            System.out.println("[INFO]\t" + sdf.format(new Date()) + "\t" + stackTrace[6] + "\t" + str);
        }
    }

    @Override
    public void warn(String str) {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        if (level>=4){
            System.out.println("[WARN]\t" + sdf.format(new Date()) + "\t" + stackTrace[6] + "\t" + str);
        }
    }

    @Override
    public void error(String str) {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        if (level>=2){
            System.out.println("[ERROR]\t" + sdf.format(new Date()) + "\t" + stackTrace[6] + "\t" + str);
        }
    }

    @Override
    public void fatal(String str) {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        if (level>=0){
            System.out.println("[FATAL]\t" + sdf.format(new Date()) + "\t" + stackTrace[6] + "\t" + str);
        }
    }
}
