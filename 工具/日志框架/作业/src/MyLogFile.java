import java.io.*;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Date;

public class MyLogFile implements MyLog {
    private String path;
    private int level = 6;//默认INFO级别
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private BufferedWriter bw;

    public void setPath(String path) {
        this.path = path;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public void close(){
        if (bw!=null){
            try {
                bw.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void trace(String str) {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        if (level>=10){
            String s = new String("[TRACE]\t" + sdf.format(new Date()) + "\t" + stackTrace[6] + "\t" + str);
            try {
                bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(path,true)));
                bw.write(s);
                bw.newLine();
                bw.flush();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void debug(String str) {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        if (level>=8){
            String s = new String("[DEBUG]\t" + sdf.format(new Date()) + "\t" + stackTrace[6] + "\t" + str);
            try {
                bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(path,true)));
                bw.write(s);
                bw.newLine();
                bw.flush();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void info(String str) {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        if (level>=6){
            String s = new String("[INFO]\t" + sdf.format(new Date()) + "\t" + stackTrace[6] + "\t" + str);
            try {
                bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(path,true)));
                bw.write(s);
                bw.newLine();
                bw.flush();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void warn(String str) {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        if (level>=4){
            String s = new String("[WARN]\t" + sdf.format(new Date()) + "\t" + stackTrace[6] + "\t" + str);
            try {
                bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(path,true)));
                bw.write(s);
                bw.newLine();
                bw.flush();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void error(String str) {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        if (level>=2){
            String s = new String("[ERROR]\t" + sdf.format(new Date()) + "\t" + stackTrace[6] + "\t" + str);
            try {
                bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(path,true)));
                bw.write(s);
                bw.newLine();
                bw.flush();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void fatal(String str) {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        if (level>=0){
            String s = new String("[FATAL]\t" + sdf.format(new Date()) + "\t" + stackTrace[6] + "\t" + str);
            try {
                bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(path,true)));
                bw.write(s);
                bw.newLine();
                bw.flush();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
