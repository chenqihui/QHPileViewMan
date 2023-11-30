//
//  ViewController.m
//  QHPileViewMan
//
//  Created by qihuichen on 2022/5/27.
//

#import "ViewController.h"

#import "UIView+QHPileView.h"

#define kSegCtrTag 200

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *viewTop;
@property (nonatomic, strong) UIView *viewBottom;

@property (nonatomic, strong) UIView *testView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIPickerView *keyPV;

@property (nonatomic, strong) NSMutableDictionary *viewDic;
@property (nonatomic, strong) NSArray *viewKeys;
@property (nonatomic) NSUInteger currentSelectKeyRow;

@property (nonatomic, strong) QHPileViewMan *pileMan;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewDic = [NSMutableDictionary new];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.superview);
        make.left.equalTo(view.superview);
        make.width.mas_equalTo(view.superview);
        make.height.mas_equalTo(30);
    }];
    self.viewTop = view;
    
    UIView *view2 = [UIView new];
    view2.backgroundColor = [UIColor redColor];
    [self.view addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view2.superview);
        make.bottom.equalTo(view2.superview);
        make.width.mas_equalTo(view.superview);
        make.height.mas_equalTo(30);
    }];
    self.viewBottom = view2;
    
    // 初始化
    struct QHPileViewMake pileMake;
    pileMake.topV = self.viewTop;
    pileMake.bottomV = self.viewBottom;
    
    UIEdgeInsets edge = UIEdgeInsetsMake(20, 20, 20, 20);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"QHPileViewManDemo" ofType:@"json"];
    self.pileMan = [[QHPileViewMan alloc] initWith:self.view make:pileMake edge:edge path:path];
    [self.pileMan setGlobalPile:QHPileViewManLayoutTopRight edge:UIEdgeInsetsMake(20, 0, 0, 0)];
    self.viewKeys = [self.pileMan.pileKeys copy];

    [self p_createView];
    [self p_addControlUI];
    [self p_updateUI];
    
    [self.keyPV selectRow:0 inComponent:0 animated:NO];
    self.currentSelectKeyRow = 0;
    
    [self.pileMan test];
}

- (UIView *)p_makeV:(NSString *)key layout:(QHPileViewManLayout)layout {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor orangeColor].CGColor;
    view.hidden = YES;
    BOOL ret = [view cqh_makePile:self.pileMan layout:layout pile:key];
    if (!ret) {
        NSLog(@"cqh_makePile error>%lu>%@", (unsigned long)layout, key);
    }
    
    UILabel *titleL = [UILabel new];
    titleL.backgroundColor = [UIColor yellowColor];
    titleL.textColor = [UIColor blackColor];
    titleL.text = key;
    [view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(titleL.superview);
    }];
    [self.viewDic setValue:view forKey:key];
    return view;
}

- (void)p_createView {
    // Left top
    UIView *demo1 = [self p_makeV:@"demo1" layout:QHPileViewManLayoutTopLeft];
    BOOL ret = NO;
    demo1.cqh_addPile(nil).cqh_hidePile(NO).cqh_updateSize(CGSizeMake(60, 20));
    
    [self p_makeV:@"try" layout:QHPileViewManLayoutTopLeft];
    [self p_makeV:@"link2" layout:QHPileViewManLayoutTopLeft];
    [self p_makeV:@"series" layout:QHPileViewManLayoutTopLeft];
    [self p_makeV:@"ad" layout:QHPileViewManLayoutTopLeft];

    // Right top
    UIView *demo2 = [self p_makeV:@"demo2" layout:QHPileViewManLayoutTopRight];
    ret = NO;
    demo2.cqh_addPile(&ret).cqh_hidePile(NO).cqh_updateSize(CGSizeMake(60, 20));
    
    // viewSeries
    // viewAd
    [self p_makeV:@"sport" layout:QHPileViewManLayoutTopRight];
    [self p_makeV:@"discuss" layout:QHPileViewManLayoutTopRight];
    [self p_makeV:@"camera" layout:QHPileViewManLayoutTopRight];
    
    // left bottom
    [self p_makeV:@"chat" layout:QHPileViewManLayoutBottomLeft];
    [self p_makeV:@"input" layout:QHPileViewManLayoutBottomLeft];
    // rigth bottom
    [self p_makeV:@"ad2" layout:QHPileViewManLayoutBottomRight];
    [self p_makeV:@"zan" layout:QHPileViewManLayoutBottomRight];
    [self p_makeV:@"menu" layout:QHPileViewManLayoutBottomRight];
    [self p_makeV:@"link" layout:QHPileViewManLayoutBottomRight];
    [self p_makeV:@"zan2" layout:QHPileViewManLayoutBottomRight];
    [self p_makeV:@"t1" layout:QHPileViewManLayoutBottomLeft];
    
    // top left symmetry
    [self p_makeV:@"info" layout:QHPileViewManLayoutTopLeftSymmetry];
    // bottom left symmetry
    [self p_makeV:@"progress" layout:QHPileViewManLayoutBottomLeftSymmetry];
}

- (void)p_updateUI {
    for (NSString *key in self.viewKeys) {
        UIView *view = self.viewDic[key];
        if (view) {
            if ([view cqh_directCheckPile]) {
                BOOL ret = NO;
                view.cqh_addPile(&ret).cqh_hidePile(NO).cqh_updateSize(CGSizeMake(60, 20));
            }
        }
    }
    UIView *view = self.viewDic[@"try"];
    view.cqh_updateSize(CGSizeMake(100, 10));
    UIView *link = self.viewDic[@"link"];
    if (link) { link.cqh_updateSize(CGSizeMake(100, 10)); }
    CGFloat w = [UIScreen mainScreen].bounds.size.width - 60;
    UIView *progress = self.viewDic[@"progress"];
    if (progress) { progress.cqh_updateSize(CGSizeMake(w, 30)); }
    UIView *info = self.viewDic[@"info"];
    if (info) { info.cqh_updateSize(CGSizeMake(w, 30)); }
}

- (void)p_addControlUI {
    UIView *mainV = [UIView new];
    [self.view addSubview:mainV];
    [mainV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(mainV.superview);
        make.width.mas_equalTo(360);
    }];
    self.testView = mainV;
    
    UIPickerView *keyPV = [UIPickerView new];
    keyPV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    keyPV.tintColor = [UIColor greenColor];
    keyPV.delegate = self;
    keyPV.dataSource = self;
    [mainV addSubview:keyPV];
    [keyPV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(keyPV.superview);
        make.height.mas_equalTo(200);
    }];
    _keyPV = keyPV;
    
    NSArray *list2 = @[@"topleft", @"topright", @"bottomleft", @"bottomright"];
    UISegmentedControl *segCtr2 = [[UISegmentedControl alloc] initWithItems:list2];
    segCtr2.tag = kSegCtrTag + 2;
    [mainV addSubview:segCtr2];
    [segCtr2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(keyPV.mas_bottom).mas_offset(10);
        make.left.right.equalTo(segCtr2.superview);
        make.height.mas_equalTo(30);
    }];
    
    NSArray *list4 = @[@"show", @"hide"];
    UISegmentedControl *segCtr4 = [[UISegmentedControl alloc] initWithItems:list4];
    segCtr4.tag = kSegCtrTag + 4;
    [mainV addSubview:segCtr4];
    [segCtr4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segCtr2.mas_bottom).mas_offset(10);
        make.left.right.equalTo(segCtr4.superview);
        make.height.mas_equalTo(30);
    }];
    
    UISlider *slider = [UISlider new];
    slider.maximumValue = 50;
    slider.minimumValue = 0;
    slider.value = 25;
    [mainV addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segCtr4.mas_bottom).mas_offset(10);
        make.left.right.equalTo(slider.superview);
        make.height.mas_equalTo(20);
    }];
    _slider = slider;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Refresh" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor blackColor];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    [mainV addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(slider.mas_bottom).mas_offset(10);
        make.left.right.equalTo(btn.superview);
        make.bottom.equalTo(btn.superview);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - Delegate

#pragma mark - Action

- (void)refreshAction {
    UISegmentedControl *sc2 = [self.testView viewWithTag:kSegCtrTag + 2];
    UISegmentedControl *sc3 = [self.testView viewWithTag:kSegCtrTag + 3];
    UISegmentedControl *sc4 = [self.testView viewWithTag:kSegCtrTag + 4];
    
    if (sc2.selectedSegmentIndex < 0 ||
        sc3.selectedSegmentIndex < 0 ||
        sc4.selectedSegmentIndex < 0) {
        return;
    }
    
    // 找到对应的 view
    UIView *view = self.viewDic[self.viewKeys[self.currentSelectKeyRow]];
    
    NSString *layoutKey = [NSString stringWithFormat:@"%ld", (long)sc2.selectedSegmentIndex];
    // 提前判断 layout 是否符合配置
    if (![self.pileMan check:layoutKey p:view.cqhPileKey]) {
        return;
    }
    view.cqhLayoutKey = layoutKey;
    
    BOOL bHide = !(sc4.selectedSegmentIndex == 0);
    if (sc3.selectedSegmentIndex == 0) {
        if ([view cqh_directCheckPile]) {
            BOOL ret = NO;
            view.cqh_addPile(&ret).cqh_hidePile(bHide).cqh_updateSize(CGSizeMake(_slider.value * 2, _slider.value));
        }
    }
    else {
        view.cqh_hidePile(bHide).cqh_removePile();
    }
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.viewKeys[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.currentSelectKeyRow = row;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.viewKeys.count;
}

@end
