# Java GUI

> 这个技术很少很少能用到
>
> 只是考虑到可能会自己写个小工具
>
> 这里了解一下，会用即可

## AWT

### 第一个窗口

```java
public class WindowTest {
    public static void main(String[] args) {
        //创建一个窗口
        Frame frame = new Frame("第一个窗口");
        //指定大小位置
        frame.setLocation(100,100);
        frame.setSize(500,500);
        //设置可见
        frame.setVisible(true);
    }
}
```



### Container容器

#### Panel

```java
Frame frame = new Frame("我是窗口");

Panel panel = new Panel();
panel.add(new TextField("我是文本框"));
panel.add(new Button("我是按钮"));

frame.add(panel);
frame.setBounds(100,100,500,500);
frame.setVisible(true);
```

> Panel是一个容器，包含住一些组件
>
> 再添加到窗体frame中
>
> setBounds就是大小和位置一起设置

> 因为AWT会调用windows来生成窗口，windows默认中文是gbk
>
> 这里可能会出现乱码
>
> 在VM option中加入-Dfile.encoding=gbk即可解决

#### ScrollPane

```java
Frame frame = new Frame("我是窗口");

ScrollPane scrollPane = new ScrollPane(ScrollPane.SCROLLBARS_ALWAYS);
scrollPane.add(new TextField("文本"));
scrollPane.add(new Button("按钮"));
frame.add(scrollPane);


frame.setBounds(100,100,500,500);
frame.setVisible(true);
```

> 这是一个带滚动条的页面
>
> 使用ScrollPane.SCROLLBARS_ALWAYS，让滚动条一直显示



### 布局管理器

#### FlowLayout

> 流式布局管理器

```java
Frame frame = new Frame("我是窗口");

frame.setLayout(new FlowLayout(FlowLayout.LEFT,20,20));
for (int i = 1; i <= 100; i++) {
    frame.add(new Button("按钮" + i));
}
frame.pack();

frame.setVisible(true);
```

> 流式布局管理器，就是从指定方向，按指定间距顺序排列，遇到边缘就换行
>
> 三个参数分别代表，左对齐，水平间距，垂直间距



#### BorderLayout

> BorderLayout 将容器分为 EAST 、 SOUTH 、 WEST 、 NORTH 、 CENTER五个区域，普通组件可以被放置在这 5 个区域的任意一个中
>
> 如果没有指定，则会默认往Center中添加
>
> 如果向同一个区域中添加多个组件，后面的会覆盖掉前面的

```java
Frame frame = new Frame("我是窗口");

frame.setLayout(new BorderLayout(30,10));
frame.add(new Button("NORTH"),BorderLayout.NORTH);
frame.add(new Button("SOUTH"),BorderLayout.SOUTH);
frame.add(new Button("EAST"),BorderLayout.EAST);
frame.add(new Button("WEST"),BorderLayout.WEST);
frame.add(new Button("CENTER"),BorderLayout.CENTER);

frame.pack();
frame.setVisible(true);
```

#### GridLayout

> GridLayout 布局管理器将容器分割成纵横线分隔的网格 ， 每个网格所占的区域大小相同
>
> 当向使用 GridLayout 布局管理器的容器中添加组件时， 默认从左向右、 从上向下依次添加到每个网格中
>
> 与 FlowLayout不同的是，放置在 GridLayout 布局管理器中的各组件的大小由组件所处的区域决定(每 个组件将自动占满整个区域) 

```java
Frame frame = new Frame("我是窗口");

Panel panel = new Panel();
panel.add(new TextField(30));
frame.add(panel,BorderLayout.NORTH);

Panel panel2 = new Panel();
panel2.setLayout(new GridLayout(3,5,4,4));
for (int i = 0; i < 10; i++) {
    panel2.add(new Button("" + i ));
}
panel2.add(new Button("+"));
panel2.add(new Button("-"));
panel2.add(new Button("*"));
panel2.add(new Button("/"));
panel2.add(new Button("-"));

frame.add(panel2);

frame.pack();
frame.setVisible(true);
```

#### GridBagLayout

> 与 GridLayout 布局管理器不同的是， 在GridBagLayout 布局管理器中，一个组件可以跨越一个或多个网格 
>
> 并可以设置各网格的大小互不相同，从而增加了布局的灵活性 
>
> 当窗口的大小发生变化时 ，GridBagLayout 布局管理器也可以准确地控制窗口各部分的拉伸 

> 由于在GridBagLayout 布局中，每个组件可以占用多个网格
>
> 此时，我们往容器中添加组件的时候，就需要具体的控制每个组件占用多少个网格
>
> java提供的GridBagConstaints类，与特定的组件绑定，可以完成具体大小和跨越性的设置

> 因为实现起来非常麻烦，使用Swing可以轻松达到同样的效果，这里就不作演示

#### CardLayout

> CardLayout 布局管理器以时间而非空间来管理它里面的组件
>
> 它将加入容器的所有组件看成一叠卡片（每个卡片其实就是一个组件）
>
> 每次只有最上面的那个 Component 才可见
>
> 就好像一副扑克牌，它们叠在一起，每次只有最上面的一张扑克牌才可见

```java
Frame frame = new Frame("我是窗口");

Panel panel = new Panel();
CardLayout cardLayout = new CardLayout();
panel.setLayout(cardLayout);
String[] names = {"第一张","第二张","第三张","第四张","第五张"};
for (int i = 0; i < names.length; i++) {
    panel.add(names[i],new Button(names[i]));
}
frame.add(panel);

Panel panel2 = new Panel();
Button b1 = new Button("上一张");
Button b2 = new Button("第一张");
Button b3 = new Button("最后一张");
Button b4 = new Button("下一张");

ActionListener listener = new ActionListener() {
    @Override
    public void actionPerformed(ActionEvent e) {
        //这个字符串就是按钮上的文字
        String actionCommand = e.getActionCommand();
        switch (actionCommand){
            case "上一张":
                cardLayout.previous(panel);
                break;
            case "第一张":
                cardLayout.first(panel);
                break;
            case "最后一张":
                cardLayout.last(panel);
                break;
            case "下一张":
                cardLayout.next(panel);
                break;
        }
    }
};
b1.addActionListener(listener);
b2.addActionListener(listener);
b3.addActionListener(listener);
b4.addActionListener(listener);
panel2.add(b1);
panel2.add(b2);
panel2.add(b3);
panel2.add(b4);
frame.add(panel2,BorderLayout.SOUTH);



frame.pack();
frame.setVisible(true);
```

#### BoxLayout

> 为了简化开发，Swing 引入了 一个新的布局管理器 : BoxLayout 
>
>  BoxLayout 可以在垂直和 水平两个方向上摆放 GUI 组件

```java
Frame frame = new Frame("我是窗口");

BoxLayout boxLayout = new BoxLayout(frame,BoxLayout.Y_AXIS);
frame.setLayout(boxLayout);

frame.add(new Button("按钮1"));
frame.add(new Button("按钮2"));

frame.pack();
frame.setVisible(true);
```

```java
Frame frame = new Frame("我是窗口");

Box horizontalBox = Box.createHorizontalBox();
horizontalBox.add(new Button("horizon 1"));
horizontalBox.add(new Button("horizon 2"));

Box verticalBox = Box.createVerticalBox();
verticalBox.add(new Button("vertical 1"));
verticalBox.add(new Button("vertical 2"));

frame.add(horizontalBox,BorderLayout.NORTH);
frame.add(verticalBox);


frame.pack();
frame.setVisible(true);
```

```java
Frame frame = new Frame("我是窗口");

Box horizontalBox = Box.createHorizontalBox();
horizontalBox.add(new Button("horizon 1"));
horizontalBox.add(Box.createHorizontalGlue());
horizontalBox.add(new Button("horizon 2"));

Box verticalBox = Box.createVerticalBox();
verticalBox.add(Box.createVerticalGlue());
verticalBox.add(new Button("vertical 1"));
verticalBox.add(Box.createVerticalStrut(30));
verticalBox.add(new Button("vertical 2"));

frame.add(horizontalBox,BorderLayout.NORTH);
frame.add(verticalBox);


frame.pack();
frame.setVisible(true);
```

> Glue是二维可变的
>
> Strut是一维可变的



### 常用组件

|    组件名     |                             功能                             |
| :-----------: | :----------------------------------------------------------: |
|    Button     |                            Button                            |
|    Canvas     |                        用于绘图的画布                        |
|   Checkbox    |             复选框组件（也可当做单选框组件使用）             |
| CheckboxGroup | 用于将多个Checkbox 组件组合成一组， 一组 Checkbox 组件将只有一个可以 被选中 ， 即全部变成单选框组件 |
|    Choice     |                          下拉选择框                          |
|     Frame     |            窗口 ， 在 GUI 程序里通过该类创建窗口             |
|     Label     |                  标签类，用于放置提示性文本                  |
|     List      |                 JU表框组件，可以添加多项条目                 |
|     Panel     |          不能单独存在基本容器类，必须放到其他容器中          |
|   Scrollbar   | 滑动条组件。如果需要用户输入位于某个范围的值 ， 就可以使用滑动条组件 ，比如调 色板中设置 RGB 的三个值所用的滑动条。当创建一个滑动条时，必须指定它的方向、初始值、 滑块的大小、最小值和最大值。 |
|  ScrollPane   |                 带水平及垂直滚动条的容器组件                 |
|   TextArea    |                          多行文本域                          |
|   TextField   |                          单行文本框                          |

#### 案例

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\工具\GUI\BasicComponent.jpg)

```java
Frame frame = new Frame("这里测试基本组件");

//组件
TextArea textArea = new TextArea(5, 20);
Choice colorChooser = new Choice();
colorChooser.add("红色");
colorChooser.add("蓝色");
colorChooser.add("绿色");
CheckboxGroup checkboxGroup = new CheckboxGroup();
//第一个参数是value，第二个是属于哪个组，第三个是是否默认选中
Checkbox male = new Checkbox("男",checkboxGroup,true);
Checkbox female = new Checkbox("女",checkboxGroup,false);
Checkbox isMarried = new Checkbox("是否已婚？");
TextField textField = new TextField(20);
Button button = new Button("确认");
//第二个参数是，是否可以多选
List colorList = new List(6,true);
colorList.add("红色");
colorList.add("蓝色");
colorList.add("绿色");

//组装
//正下方
Box southBox = Box.createHorizontalBox();
southBox.add(textField);
southBox.add(button);
frame.add(southBox,BorderLayout.SOUTH);
//左上部分的下半部分
Box leftUpDown = Box.createHorizontalBox();
leftUpDown.add(colorChooser);
leftUpDown.add(male);
leftUpDown.add(female);
leftUpDown.add(isMarried);
//左上部分
Box leftUp = Box.createVerticalBox();
leftUp.add(textArea);
leftUp.add(leftUpDown);
//上部整体
Box north = Box.createHorizontalBox();
north.add(leftUp);
north.add(colorList);
frame.add(north);



frame.pack();
frame.setVisible(true);
```

#### Dialog

>  Dialog是可以独立存在的顶级窗口， 因此用法与普通窗口的用法几乎完全一样

> - Dialog通常依赖于其他窗口，就是通常需要有一个父窗口；
> - Dialog有非模式(non-modal)和模式(modal)两种，当某个模式对话框被打开后，该模式对话框总是位于它的父窗口之上，在模式对话框被关闭之前，父窗口无法获得焦点。

```java
Frame frame = new Frame("这里测试基本组件");

Dialog dialog = new Dialog(frame,"模式对话框",true);
Dialog dialog2 = new Dialog(frame,"非模式对话框",false);
dialog.setBounds(100,100,300,300);
dialog2.setBounds(100,100,300,300);

Button b1 = new Button("打开模式对话框");
Button b2 = new Button("打开非模式对话框");

b1.addActionListener(new ActionListener() {
    @Override
    public void actionPerformed(ActionEvent e) {
        dialog.setVisible(true);
    }
});
b2.addActionListener(new ActionListener() {
    @Override
    public void actionPerformed(ActionEvent e) {
        dialog2.setVisible(true);
    }
});

frame.add(b1,BorderLayout.NORTH);
frame.add(b2);

frame.pack();
frame.setVisible(true);
```

#### FileDialog

> 它代表一个文件对话框，用于打开或者保存文件

```java
Frame frame = new Frame("这里测试基本组件");

FileDialog fileDialog = new FileDialog(frame,"选择要打开的文件",FileDialog.LOAD);
FileDialog fileDialog2 = new FileDialog(frame,"选择要保存的路径",FileDialog.SAVE);

Button b1 = new Button("打开文件");
Button b2 = new Button("保存文件");

b1.addActionListener(new ActionListener() {
    @Override
    public void actionPerformed(ActionEvent e) {
        fileDialog.setVisible(true);
        String directory = fileDialog.getDirectory();
        String file = fileDialog.getFile();
        System.out.println("打开的文件为：" + directory + file);
    }
});
b2.addActionListener(new ActionListener() {
    @Override
    public void actionPerformed(ActionEvent e) {
        fileDialog2.setVisible(true);
        String directory = fileDialog.getDirectory();
        String file = fileDialog.getFile();
        System.out.println("保存的文件为：" + directory + file);
    }
});

frame.add(b1,BorderLayout.NORTH);
frame.add(b2);

frame.pack();
frame.setVisible(true);
```



### 事件

#### Hello World

```java
Frame frame = new Frame("这是一个窗口");

TextField textField = new TextField(30);
Button button = new Button("确定");

class MyListener implements ActionListener{
    @Override
    public void actionPerformed(ActionEvent e) {
        textField.setText("Hello World");
    }
}

button.addActionListener(new MyListener());

frame.add(textField,BorderLayout.NORTH);
frame.add(button);

frame.pack();
frame.setVisible(true);
```

#### 低级事件

| 事件           | 触发时机                                                     |
| :------------- | :----------------------------------------------------------- |
| ComponentEvent | 组件事件 ， 当 组件尺寸发生变化、位置发生移动、显示/隐藏状态发生改变时触发该事件 |
| ContainerEvent | 容器事件 ， 当容器里发生添加组件、删除组件时触发该事件       |
| WindowEvent    | 窗口事件， 当窗 口状态发生改变 ( 如打开、关闭、最大化、最 小化)时触发该事件 |
| FocusEvent     | 焦点事件 ， 当组件得到焦点或失去焦点 时触发该事件            |
| KeyEvent       | 键盘事件 ， 当按键被按下、松开、单击时触发该事件             |
| MouseEvent     | 鼠标事件，当进行单击、按下、松开、移动鼠标等动作 时触发该事件 |
| PaintEvent     | 组件绘制事件 ， 该事件是一个特殊的事件类型 ， 当 GUI 组件调 用 update/paint 方法 来呈现自身时触发该事件，该事件并非专用于事件处理模型 |

#### 高级事件

| 事件           | 触发时机                                                     |
| -------------- | ------------------------------------------------------------ |
| ActionEvent    | 动作事件 ，当按钮、菜单项被单击，在 TextField 中按 Enter 键时触发 |
| AjustmentEvent | 调节事件，在滑动条上移动滑块以调节数值时触发该事件           |
| ltemEvent      | 选项事件，当用户选中某项， 或取消选中某项时触发该事件        |
| TextEvent      | 文本事件， 当文本框、文本域里的文本发生改变时触发该事件      |

#### 事件监听器

> 不同的事件需要使用不同的监听器监听，不同的监听器需要实现不同的监听器接口， 当指定事件发生后 ， 事件监听器就会调用所包含的事件处理器(实例方法)来处理事件 

| 事件类别        | 描述信息                 | 监听器接口名        |
| --------------- | ------------------------ | ------------------- |
| ActionEvent     | 激活组件                 | ActionListener      |
| ItemEvent       | 选择了某些项目           | ItemListener        |
| MouseEvent      | 鼠标移动                 | MouseMotionListener |
| MouseEvent      | 鼠标点击等               | MouseListener       |
| KeyEvent        | 键盘输入                 | KeyListener         |
| FocusEvent      | 组件收到或失去焦点       | FocusListener       |
| AdjustmentEvent | 移动了滚动条等组件       | AdjustmentListener  |
| ComponentEvent  | 对象移动缩放显示隐藏等   | ComponentListener   |
| WindowEvent     | 窗口收到窗口级事件       | WindowListener      |
| ContainerEvent  | 容器中增加删除了组件     | ContainerListener   |
| TextEvent       | 文本字段或文本区发生改变 | TextListener        |

#### 案例

```java
Frame frame = new Frame("这是一个窗口");

TextField textField = new TextField(30);
Choice names = new Choice();
names.add("张三");
names.add("李四");
names.add("王五");

textField.addTextListener(new TextListener() {
    @Override
    public void textValueChanged(TextEvent e) {
        System.out.println("文本框中内容：" + textField.getText());
    }
});
names.addItemListener(new ItemListener() {
    @Override
    public void itemStateChanged(ItemEvent e) {
        Object item = e.getItem();
        System.out.println("选择了：" + item + "条目！");
    }
});
frame.addContainerListener(new ContainerListener() {
    @Override
    public void componentAdded(ContainerEvent e) {
        Component child = e.getChild();
        System.out.println("添加了：" + child);
    }

    @Override
    public void componentRemoved(ContainerEvent e) {

    }
});


Box horizontalBox = Box.createHorizontalBox();
horizontalBox.add(names);
horizontalBox.add(textField);
frame.add(horizontalBox);

frame.pack();
frame.setVisible(true);
```

#### 关闭窗口

```java
        Frame frame = new Frame("这是一个窗口");
        frame.setBounds(200,200,300,300);

        frame.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });

        frame.setVisible(true);
```



### 菜单组件

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\工具\GUI\菜单1.png)

```java
Frame frame = new Frame("这是一个窗口");

TextArea textArea = new TextArea(6, 40);

MenuBar menuBar = new MenuBar();

Menu fileMenu = new Menu("文件");
Menu editMenu = new Menu("编辑");
Menu formatMenu = new Menu("格式");

MenuItem auto = new MenuItem("自动换行");
MenuItem copy = new MenuItem("复制");
MenuItem paste = new MenuItem("粘贴");

MenuItem comment = new MenuItem("注释",new MenuShortcut(KeyEvent.VK_Q,true));
MenuItem cancelComment = new MenuItem("取消注释");

comment.addActionListener(new ActionListener() {
    @Override
    public void actionPerformed(ActionEvent e) {
        textArea.append("点击了" + e.getActionCommand());
    }
});

formatMenu.add(comment);
formatMenu.add(cancelComment);

editMenu.add(auto);
editMenu.add(copy);
editMenu.add(paste);
editMenu.add(formatMenu);

menuBar.add(fileMenu);
menuBar.add(editMenu);

frame.setMenuBar(menuBar);
frame.add(textArea);

frame.pack();
frame.setVisible(true);
```

#### PopupMenu

```java
Frame frame = new Frame("这是一个窗口");

TextArea textArea = new TextArea("这是默认的字符串",6, 30);
Panel panel = new Panel();
PopupMenu popupMenu = new PopupMenu();
MenuItem comment = new MenuItem("注释");
MenuItem cancelComment = new MenuItem("取消注释");
MenuItem copy = new MenuItem("复制");
MenuItem save = new MenuItem("保存");

popupMenu.add(comment);
popupMenu.add(cancelComment);
popupMenu.add(copy);
popupMenu.add(save);

ActionListener actionListener = new ActionListener() {
    @Override
    public void actionPerformed(ActionEvent e) {
        textArea.append("点击了" + e.getActionCommand() + "\n");
    }
};
comment.addActionListener(actionListener);
cancelComment.addActionListener(actionListener);
copy.addActionListener(actionListener);
save.addActionListener(actionListener);

panel.add(popupMenu);
panel.setPreferredSize(new Dimension(400,300));

panel.addMouseListener(new MouseAdapter() {
    @Override
    public void mouseReleased(MouseEvent e) {
        //判断是否是右键
        boolean popupTrigger = e.isPopupTrigger();
        if (popupTrigger){
            popupMenu.show(panel,e.getX(),e.getY());
        }
    }
});

frame.add(textArea);
frame.add(panel,BorderLayout.SOUTH);

frame.pack();
frame.setVisible(true);
```



### 绘图

| 方法名称           | 方法功能               |
| ------------------ | ---------------------- |
| setColor(Color c)  | 设置颜色               |
| setFont(Font font) | 设置字体               |
| drawLine()         | 绘制直线               |
| drawRect()         | 绘制矩形               |
| drawRoundRect()    | 绘制圆角矩形           |
| drawOval()         | 绘制椭圆形             |
| drawPolygon()      | 绘制多边形             |
| drawArc()          | 绘制圆弧               |
| drawPolyline()     | 绘制折线               |
| fillRect()         | 填充矩形区域           |
| fillRoundRect()    | 填充圆角矩形区域       |
| fillOval()         | 填充椭圆区域           |
| fillPolygon()      | 填充多边形区域         |
| fillArc()          | 填充圆弧对应的扇形区域 |
| drawImage()        | 绘制位图               |

#### 案例

```java
public class WindowTest {
    private static String shape = "";

    public static void main(String[] args) {
        Frame frame = new Frame("这是一个窗口");

        Button rectangle = new Button("绘制矩形");
        Button oval = new Button("绘制椭圆");

        class MyCanvas extends Canvas{
            @Override
            public void paint(Graphics g) {
                g.setColor(Color.RED);
                if (shape.equals("rectangle")){
                    g.drawRect(100,100,200,200);
                }else if (shape.equals("oval")){
                    g.drawOval(100,100,200,200);
                }
            }
        }
        MyCanvas myCanvas = new MyCanvas();

        rectangle.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                shape = "rectangle";
                myCanvas.repaint();
            }
        });
        oval.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                shape = "oval";
                myCanvas.repaint();
            }
        });



        Box horizontalBox = Box.createHorizontalBox();
        horizontalBox.add(rectangle);
        horizontalBox.add(oval);

        frame.add(myCanvas);
        frame.add(horizontalBox,BorderLayout.SOUTH);

        frame.pack();
        frame.setVisible(true);
    }
}
```

#### 处理位图

```java
public class WindowTest {
    private static Color color = Color.red;
    private static int  preX = -1;
    private static int  preY = -1;


    public static void main(String[] args) {
        Frame frame = new Frame("这是一个窗口");

        PopupMenu popupMenu = new PopupMenu();
        MenuItem red = new MenuItem("红色");
        MenuItem blue = new MenuItem("蓝色");
        MenuItem green = new MenuItem("绿色");

        BufferedImage bufferedImage = new BufferedImage(500,500,BufferedImage.TYPE_INT_RGB);
        Graphics graphics = bufferedImage.getGraphics();

        class MyCanvas extends Canvas{
            @Override
            public void paint(Graphics g) {
                g.drawImage(bufferedImage,0,0,null);
            }
        }
        MyCanvas myCanvas = new MyCanvas();

        ActionListener actionListener = new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String actionCommand = e.getActionCommand();
                switch (actionCommand){
                    case "红色":
                        color = Color.red;
                        break;
                    case "蓝色":
                        color = Color.blue;
                        break;
                    case "绿色":
                        color = Color.green;
                        break;
                }
            }
        };

        red.addActionListener(actionListener);
        blue.addActionListener(actionListener);
        green.addActionListener(actionListener);
        popupMenu.add(red);
        popupMenu.add(blue);
        popupMenu.add(green);

        myCanvas.add(popupMenu);
        myCanvas.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                boolean popupTrigger = e.isPopupTrigger();
                if (popupTrigger){
                    popupMenu.show(myCanvas,e.getX(),e.getY());
                }
                preX = -1;
                preY = -1;
            }
        });

        graphics.setColor(Color.white);
        graphics.fillRect(0,0,500,500);

        myCanvas.addMouseMotionListener(new MouseAdapter() {
            @Override
            public void mouseDragged(MouseEvent e) {
                if (preX > 0 && preY > 0){
                    graphics.setColor(color);
                    graphics.drawLine(preX,preY,e.getX(),e.getY());
                }
                preX = e.getX();
                preY = e.getY();
                myCanvas.repaint();
            }
        });

        myCanvas.setPreferredSize(new Dimension(500,500));
        frame.add(myCanvas);




        frame.pack();
        frame.setVisible(true);
    }
}
```

#### imageIO

```java
public class WindowTest {
    static BufferedImage bufferedImage = null;

    public static void main(String[] args) {
        Frame frame = new Frame("这是一个窗口");

        MenuBar menuBar = new MenuBar();
        Menu menu = new Menu("文件");
        MenuItem open = new MenuItem("打开");
        MenuItem save = new MenuItem("另存为");


        class MyCanvas extends Canvas{
            @Override
            public void paint(Graphics g) {
                g.drawImage(bufferedImage,0,0,null);
            }
        }
        MyCanvas myCanvas = new MyCanvas();

        open.addActionListener(e -> {
            FileDialog fileDialog = new FileDialog(frame,"打开图片",FileDialog.LOAD);
            fileDialog.setVisible(true);
            String directory = fileDialog.getDirectory();
            String file = fileDialog.getFile();
            try {
                bufferedImage = ImageIO.read(new File(directory,file));
                myCanvas.repaint();
            } catch (IOException ioException) {
                ioException.printStackTrace();
            }
        });

        save.addActionListener(e -> {
            FileDialog fileDialog = new FileDialog(frame,"保存图片",FileDialog.SAVE);
            fileDialog.setVisible(true);
            String directory = fileDialog.getDirectory();
            String file = fileDialog.getFile();
            try {
                ImageIO.write(bufferedImage,"JEPG",new File(directory,file));
            } catch (IOException ioException) {
                ioException.printStackTrace();
            }
        });

        menu.add(open);
        menu.add(save);
        menuBar.add(menu);
        frame.setMenuBar(menuBar);
        frame.add(myCanvas);


        frame.setBounds(200,200,1440,900);
        frame.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });
        frame.pack();
        frame.setVisible(true);
    }
}
```



## Swing

> Swing是由100%纯 Java实现的，不再依赖于本地平台的 GUI， 因此可以在所有平台上都保持相同的界面外观

### 组件使用

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\工具\GUI\swing_c_1.jpg)

![](C:\Users\augus\Documents\GitHub\JavaNoteandPractice\工具\GUI\swing_c_2.jpg)

```java
public class WindowTest {
        JFrame jFrame = new JFrame("我是窗口");

        JMenuBar jMenuBar = new JMenuBar();
        JMenu fileMenu = new JMenu("文件");
        JMenu editMenu = new JMenu("编辑");
        JMenuItem auto = new JMenuItem("自动换行");
        JMenuItem copy = new JMenuItem("复制");
        JMenuItem paste = new JMenuItem("粘贴");
        JMenu formatMenu = new JMenu("格式");
        JMenuItem comment = new JMenuItem("注释");
        JMenuItem cancelComment = new JMenuItem("取消注释");
        JTextArea jTextArea = new JTextArea(8,20);
        String[] colors = {"红色","绿色","蓝色"};
        JList<String> colorList = new JList<>(colors);
        JComboBox<String> colorSelect = new JComboBox<>();
        ButtonGroup buttonGroup = new ButtonGroup();
        JRadioButton male = new JRadioButton("男",true);
        JRadioButton female = new JRadioButton("女",false);
        JCheckBox isMarried = new JCheckBox("是否已婚",true);
        JTextField jTextField = new JTextField(30);
        JButton jButton = new JButton("ok");
        JPopupMenu jPopupMenu = new JPopupMenu();
        ButtonGroup popupBG = new ButtonGroup();
        JRadioButtonMenuItem metalItem = new JRadioButtonMenuItem("Metal风格");
        JRadioButtonMenuItem nimbusItem = new JRadioButtonMenuItem("Nimbus风格");
        JRadioButtonMenuItem windowsItem = new JRadioButtonMenuItem("Windows风格",true);
        JRadioButtonMenuItem windowsClassicItem = new JRadioButtonMenuItem("Windows经典风格");
        JRadioButtonMenuItem motifItem = new JRadioButtonMenuItem("Motif风格");



    public void init(){
        colorSelect.addItem("红色");
        colorSelect.addItem("绿色");
        colorSelect.addItem("蓝色");
        buttonGroup.add(male);
        buttonGroup.add(female);


        //组装
        //底部
        JPanel down = new JPanel();
        down.add(jTextField);
        down.add(jButton);
        jFrame.add(down,BorderLayout.SOUTH);
        //左上下半部分
        JPanel leftUpDown = new JPanel();
        leftUpDown.add(colorSelect);
        leftUpDown.add(male);
        leftUpDown.add(female);
        leftUpDown.add(isMarried);
        //左上整体
        Box leftUp = Box.createVerticalBox();
        leftUp.add(jTextArea);
        leftUp.add(leftUpDown);
        //上部整体
        Box up = Box.createHorizontalBox();
        up.add(leftUp);
        up.add(colorList);
        jFrame.add(up);
        //顶部菜单
        formatMenu.add(comment);
        formatMenu.add(cancelComment);
        editMenu.add(auto);
        editMenu.addSeparator();
        editMenu.add(copy);
        editMenu.add(paste);
        editMenu.addSeparator();
        editMenu.add(formatMenu);
        jMenuBar.add(fileMenu);
        jMenuBar.add(editMenu);
        jFrame.setJMenuBar(jMenuBar);
        //右键菜单
        popupBG.add(metalItem);
        popupBG.add(nimbusItem);
        popupBG.add(windowsItem);
        popupBG.add(windowsClassicItem);
        popupBG.add(motifItem);


        ActionListener actionListener = new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String actionCommand = e.getActionCommand();
                try {
                    switch (actionCommand){
                        case "Metal风格":
                            UIManager.setLookAndFeel("javax.swing.plaf.metal.MetalLookAndFeel");
                            break;
                        case "Nimbus风格":
                            UIManager.setLookAndFeel("javax.swing.plaf.nimbus.NimbusLookAndFeel");
                            break;
                        case "Windows风格":
                            UIManager.setLookAndFeel("com.sun.java.swing.plaf.windows.WindowsLookAndFeel");
                            break;
                        case "Windows经典风格":
                            UIManager.setLookAndFeel("com.sun.java.swing.plaf.windows.WindowsClassicLookAndFeel");
                            break;
                        case "Motif风格":
                            UIManager.setLookAndFeel("com.sun.java.swing.plaf.motif.MotifLookAndFeel");
                            break;
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                SwingUtilities.updateComponentTreeUI(jFrame.getContentPane());
                SwingUtilities.updateComponentTreeUI(jMenuBar);
                SwingUtilities.updateComponentTreeUI(jPopupMenu);
            }
        };

        metalItem.addActionListener(actionListener);
        nimbusItem.addActionListener(actionListener);
        windowsItem.addActionListener(actionListener);
        windowsClassicItem.addActionListener(actionListener);
        motifItem.addActionListener(actionListener);

        jPopupMenu.add(metalItem);
        jPopupMenu.add(nimbusItem);
        jPopupMenu.add(windowsItem);
        jPopupMenu.add(windowsClassicItem);
        jPopupMenu.add(motifItem);

        //不需要监听鼠标了
        jTextArea.setComponentPopupMenu(jPopupMenu);

        jFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        jFrame.pack();
        jFrame.setVisible(true);
    }

    public static void main(String[] args) {
        WindowTest windowTest = new WindowTest();
        windowTest.init();
    }

}
```

