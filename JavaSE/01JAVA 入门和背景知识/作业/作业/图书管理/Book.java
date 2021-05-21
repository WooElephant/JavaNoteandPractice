package MyHomework1EX;


import java.util.Objects;

public class Book {
//    name书名
//    status可否借阅 true：可 false：不可
//    brrowTimes借阅次数
//    count图书个数
    private String name;
    private boolean status;
    private int borrowTimes,count;

    public Book(String name, boolean status, int borrowTimes, int count) {
        this.name = name;
        this.status = status;
        this.borrowTimes = borrowTimes;
        this.count = count;
    }

    public Book(String name) {
        this.name = name;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Book book = (Book) o;
        return Objects.equals(name, book.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name);
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean getStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public int getBorrowTimes() {
        return borrowTimes;
    }

    public void setBorrowTimes(int borrowTimes) {
        this.borrowTimes = borrowTimes;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int b) {
        if (b==1) count++;
        else count--;
    }


    @Override
    public String toString() {
        return name + " : " + count + "本" + "  借阅次数：" + borrowTimes;
    }
}
