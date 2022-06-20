


使用

配置布局

网格布局模式，如下 5 * 9，使用 null 断开 左上，右上，左下，右下 四个区域

~~~
[
[{"demo1":{}},	{"null":{}},	{"null":{}},	{"null":{}},	{"demo2":{}}],
[{"try":{}},	{"link":{}},	{"null":{}},	{"null":{}},	{"series":{}}],
[{"series":{}},	{"null":{}},	{"null":{}},	{"null":{}},	{"sport":{}}],
[{"ad":{}},		{"null":{}},	{"null":{}},	{"null":{}},	{"ad":{}}],
[{"null":{}},	{"null":{}},	{"null":{}},	{"null":{}},	{"discuss":{}}],
[{"null":{}},	{"null":{}},	{"null":{}},	{"null":{}},	{"camera":{}}],
[{"null":{}},	{"null":{}},	{"null":{}},	{"null":{}},	{"null":{}}],
[{"chat":{}},	{"null":{}},	{"null":{}},	{"null":{}},	{"ad2":{}}],
[{"ad3":{}},	{"null":{}},	{"null":{}},	{"null":{}},	{"zan":{}}]
]
~~~

控制

~~~
// 引用
#import "UIView+QHPileView.h"

// 初始化
struct QHPileViewMake pileMake;
pileMake.topV = self.viewTop;
pileMake.bottomV = self.viewBottom;
    
UIEdgeInsets edge = UIEdgeInsetsMake(20, 20, 20, 20);
    
self.pileMan = [[QHPileViewMan alloc] initWith:self.view make:pileMake 
edge:edge];

// 设置 Layout & Pile
// 1
BOOL ret = [view cqh_makePile:self.pileMan layout:layout pile:key];
if (!ret) {
    NSLog(@"cqh_makePile error");
}
// 2
view.cqhPileMan = self.pileMan;
view.cqhPileKey = key;
view.cqhLayoutKey = [NSString stringWithFormat:@"%lu", (unsigned long)layout];

// 提前判断 layout 是否符合配置
if (![self.pileMan check:layoutKey p:view.cqhPileKey]) {
    return;
}

// 显示
if ([view cqh_directCheckPile]) {
    BOOL ret = NO;
    view.cqh_addPile(&ret).cqh_showPile(bShow).cqh_updateSize(CGSizeMake(_slider.value * 2, _slider.value)).hidden = !bShow;
}

// 隐藏
view.cqh_showPile(NO).cqh_removePile();
~~~

注意

view 是否显示需要自己控制

~~~
view.hidden = !ret;
~~~


开发思考：

锚点作为占位，外部显示的view可以给予锚点进行 (x, y) 进行定位，然后撑大 size 和 marge

需解决动态化，即灵活添加，显示，隐藏，适用横竖屏的不同布局等，相当于更改锚点的坐标即可

到达集中处理和解耦

1、

类似 android，使用 xml 将所有锚点打桩，然后需要添加的view通过 xml 对应的 id 获取锚点进行布局

缺点：需要提前写好锚点，再添加子view，并且不同布局需要不同xml
优点：xml 可以动态下发，也容易修改

2、

实时创建锚点，添加view 时再创建，将锚点进行排队，插入后更新前后锚点的约束，及关联新锚点，

缺点：排序需要提前写好，否则无法确定顺序和插入的位置，这样就有耦合idx，对idx就很乱
优点：即用即给



需要达到：

可视化：工具可视化布局
配置化：下发配置的文件
低耦合：view根据配置，自相对锚点布局
高性能：？

