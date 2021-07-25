package MyHomework1EX;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Iterator;
import java.util.Scanner;

public class TestBook {
    public static void main(String[] args) {

//        新建ArrayList：图书库存
        ArrayList<Book> arr = new ArrayList<>();

//        初始化三本书
        Book book1 = new Book("Java核心技术",true,1,1);
        Book book2 = new Book("SQL必知必会",true,2,1);
        Book book3 = new Book("重构",true,1,1);

//        将初始化的书添加至arr
        arr.add(book1);
        arr.add(book2);
        arr.add(book3);

        int num;
        Scanner sc = new Scanner(System.in);

        while (true){
            welcome();
            num=sc.nextInt();
            switch (num)
            {
                case 1:
                    server1(arr);
                    break;
                case 2:
                    server2(arr);
                    break;
                case 3:
                    server3(arr);
                    break;
                case 4:
                    server4(arr);
                    break;
                case 5:
                    server5(arr);
                    break;
                case 6:
                    server6(arr);
                    break;
                case 7:
                    server7();
                case 8:
                    server8(arr);
                    break;
                default:break;
            }

        }


    }

    public static void welcome(){
        System.out.println("欢迎您使用本图书管理系统！");
        System.out.println("1、查看图书");
        System.out.println("2、添加图书");
        System.out.println("3、删除图书");
        System.out.println("5、借书");
        System.out.println("6、还书");
        System.out.println("7、排行榜");
        System.out.println("8、退出");
        System.out.println("请根据提示输入您需要的功能，并以回车键结束。");
    }

    public static void server1(ArrayList arr){

        Iterator it = arr.iterator();
        while (it.hasNext()){
            System.out.println(it.next().toString());
        }
        ifContinue();
    }

    public static void server2(ArrayList arr){
//        将字符串生成Book对象
        Scanner sc = new Scanner(System.in);
        System.out.println("请输入要添加/归还的图书名");
        Book bookTemp = new Book(sc.next());

//        判断是否存在此书
        if (arr.contains(bookTemp))
        {
//            如果存在书数量+1
            bookTemp = (Book) arr.get(arr.indexOf(bookTemp));
            bookTemp.setCount(1);
        }
        //        如果不存在，添加此书
        else arr.add(bookTemp);

        System.out.println("添加成功");

        ifContinue();

    }

    public static void server3(ArrayList arr){
        Scanner sc = new Scanner(System.in);
        System.out.println("请输入要删除的图书名");
        Book bookTemp = new Book(sc.next());

        if (arr.contains(bookTemp))
        {
            bookTemp = (Book) arr.get(arr.indexOf(bookTemp));

            if (bookTemp.getStatus())
            {

                if (bookTemp.getCount()>1)
                {
                    bookTemp.setCount(-1);
                    System.out.println("删除成功，书本数量-1");
                }
                else
                    {
                        arr.remove(bookTemp);
                        System.out.println("删除成功！");
                    }
            }
        }
        else
            {
                System.out.println("删除失败，查无此书！");
            }

        ifContinue();

    }

    public static void server4(ArrayList arr){
        Scanner sc = new Scanner(System.in);
        System.out.println("请输入要修改的图书名");
        Book bookTemp = new Book(sc.next());
        if (arr.contains(bookTemp))
        {
            bookTemp = (Book) arr.get(arr.indexOf(bookTemp));
            bookTemp.setCount(-1);
            System.out.println("请输入新的书名");
            server2(arr);
        }
        else System.out.println("查无此书！");

        ifContinue();
    }

    public static void server5(ArrayList arr){
        Scanner sc = new Scanner(System.in);
        System.out.println("请输入要借阅的图书名");
        Book bookTemp = new Book(sc.next());
        if (arr.contains(bookTemp))
        {
            bookTemp = (Book) arr.get(arr.indexOf(bookTemp));
            if (bookTemp.getStatus())
            {
                bookTemp.setCount(-1);
                System.out.println("《" + bookTemp.getName() + "》" +"借书成功");
            }
            else System.out.println("借书失败，此书暂不外借！");
        }
        else System.out.println("查无此书！");

        ifContinue();
    }

    public static void server6(ArrayList arr){
        server2(arr);
        ifContinue();
    }

    public static void server7(){
        System.exit(0);
    }

    public static void server8(ArrayList arr){
        arr.sort(new Comparator<Book> () {
            @Override
            public int compare(Book o1, Book o2) {
                return o2.getBorrowTimes() - o1.getBorrowTimes();
            }
        });
        server1(arr);

        ifContinue();
    }

    public static void ifContinue(){
        System.out.println("是否继续y/n");
        Scanner sc = new Scanner(System.in);
        String n = sc.next();
        if (n.equals("n")||n.equals("N")) System.exit(0);

    }




}


