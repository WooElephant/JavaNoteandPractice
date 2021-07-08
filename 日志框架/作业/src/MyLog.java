/**
 * 这是一个接口，方便控制
 */
public interface MyLog {

    public void trace(String str);
    public void debug(String str);
    public void info(String str);
    public void warn(String str);
    public void error(String str);
    public void fatal(String str);

}
