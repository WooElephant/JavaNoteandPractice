package com.augus01;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Scanner;

public class Homework01 {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.print("请输入您要拷的源文件：");
        String srcPath = sc.next();
        System.out.print("请输入您要拷贝的目标位置：");
        String desPath = sc.next();

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
}
