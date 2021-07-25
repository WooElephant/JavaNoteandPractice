package com.augus01;

import java.io.*;
import java.util.Scanner;

public class Homework02 {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("请输入要拷贝的文件或路径：");
        String srcPath = sc.next();
        System.out.println("请输入要拷贝的目标路径：");
        String desPath = sc.next();
        cpDir(srcPath,desPath);
        cpAll(srcPath,desPath);

    }

    public static void cpAll(String srcPath, String desPath) {
        File file = new File(srcPath);
        File[] files = file.listFiles();
        for (File file1 : files) {
            //是文件就直接拷贝
            if (file1.isFile()){
                cpFile(srcPath+"\\"+file1.getName(),desPath+"\\"+file1.getName());
            }
            //不是文件，就剥开路径重新传递，递归
            if (file1.isDirectory()){
                cpAll(file1.getPath().toString(),desPath+"\\"+file1.getName());
            }
        }

    }

    public static void cpFile(String srcPath, String desPath) {
        FileInputStream fis = null;
        FileOutputStream fos = null;

        try {
            fis = new FileInputStream(srcPath);
            fos = new FileOutputStream(desPath);
            byte[] buff = new byte[1024];
            int dataLen = 0;
            while ((dataLen = fis.read(buff)) != -1) {
                fos.write(buff, 0, dataLen);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (fis != null) {
                try {
                    fis.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (fos != null) {
                try {
                    fos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public static void cpDir(String srcPath, String desPath) {
        File desFile = new File(desPath);
        //把目标目录创建好
        if (!desFile.exists()) {
            desFile.mkdirs();
        }

        File srcFile = new File(srcPath);
        File[] files = srcFile.listFiles();
        for (File file : files) {
            //如果是多级目录就递归
            if (file.isDirectory()) {
                cpDir(file.getPath(), desPath + "\\" + file.getName());
            }
        }
    }
}
