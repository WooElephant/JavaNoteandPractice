import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.Scanner;
public class Homework0702_2_1 {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        try {
            System.setOut(new PrintStream("d:\\aaa.txt"));
            String str = sc.next();
            System.out.println(str);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }
}
