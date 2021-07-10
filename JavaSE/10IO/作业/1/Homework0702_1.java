import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class Homework0702_1 {
    public static void main(String[] args) {
        File srcFile = new File("C:\\我的文件夹");
        File[] files = srcFile.listFiles();

        //两个filter筛选对应的类型
        FilenameFilter mp3Filter = (dir, name) -> name.endsWith(".mp3");

        FilenameFilter txtFilter = (dir, name) -> name.endsWith(".txt");

        //两个list保存文件对象
        List<File> mp3List = new ArrayList<>();
        List<File> txtList = new ArrayList<>();

        for (File file : files) {
            if (mp3Filter.accept(srcFile,file.getName())){
                mp3List.add(file);
            }
            if (txtFilter.accept(srcFile,file.getName())){
                txtList.add(file);
            }
        }

        String mp3DesPath = "e:\\mp3";
        String txtDesPath = "e:\\txt";

        FileInputStream fis = null;
        FileOutputStream fos = null;

        byte[] buff = new byte[1024];
        int dataLen = 0;

        for (File file : mp3List) {
            try {
                fis = new FileInputStream(file);
                fos = new FileOutputStream(mp3DesPath+"\\"+file.getName());
                while ((dataLen=fis.read()) != -1){
                    fos.write(buff,0,dataLen);
                }
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                try {
                    fis.close();
                    fos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        for (File file : txtList) {
            try {
                fis = new FileInputStream(file);
                fos = new FileOutputStream(txtDesPath+"\\"+file.getName());
                while ((dataLen=fis.read()) != -1){
                    fos.write(buff,0,dataLen);
                }
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                try {
                    fis.close();
                    fos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
