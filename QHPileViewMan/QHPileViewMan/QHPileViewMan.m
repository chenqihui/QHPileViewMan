//
//  QHPileViewMan.m
//  QHPileViewMan
//
//  Created by qihuichen on 2022/5/27.
//

#import "QHPileViewMan.h"

#import "Masonry.h"

#import "UIView+QHPileView.h"

@interface QHPileViewMan ()

@property (nonatomic, strong) NSMutableArray<NSMutableArray<NSMutableDictionary<NSString *, id> *> *> *pileCfgs;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<NSMutableArray<NSString *> *> *> *pileKeyLayoutDic;
@property (nonatomic, strong, readwrite) NSArray *pileKeys;

@property (nonatomic, weak) UIView *superV;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, UIView *> *> *pileViewDic;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, NSMutableArray<MASConstraint *> *> *> *pileConstraintsDic;

@end

@implementation QHPileViewMan

- (instancetype)initWith:(UIView *)superV make:(struct QHPileViewMake)pileMake edge:(UIEdgeInsets)edge {
    self = [super init];
    if (self) {
        self.superV = superV;
        UIView *topPileV = [UIView new];
        topPileV.backgroundColor = [UIColor orangeColor];
        [superV addSubview:topPileV];
        
        [topPileV mas_makeConstraints:^(MASConstraintMaker *make) {
            if (pileMake.topV) {
                make.top.equalTo(pileMake.topV.mas_bottom).mas_offset(edge.top);
            }
            else {
                make.top.equalTo(topPileV.superview).mas_offset(edge.top);
            }
            if (pileMake.leftV) {
                make.left.equalTo(pileMake.leftV).mas_offset(edge.left);
            }
            else {
                make.left.equalTo(topPileV.superview).mas_offset(edge.left);
            }
            make.width.height.mas_equalTo(0);
        }];
        
        UIView *bottomPileV = [UIView new];
        bottomPileV.backgroundColor = [UIColor greenColor];
        [superV addSubview:bottomPileV];
        [bottomPileV mas_makeConstraints:^(MASConstraintMaker *make) {
            if (pileMake.bottomV) {
                make.bottom.equalTo(pileMake.bottomV.mas_top).mas_offset(-edge.bottom);
            }
            else {
                make.bottom.equalTo(bottomPileV.superview).mas_offset(-edge.bottom);
            }
            if (pileMake.rightV) {
                make.right.equalTo(pileMake.rightV).mas_offset(-edge.right);
            }
            else {
                make.right.equalTo(topPileV.superview).mas_offset(-edge.right);
            }
            make.width.height.mas_equalTo(0);
        }];
        
        self.topView = topPileV;
        self.bottomView = bottomPileV;
        
        [self p_setup];
    }
    return self;
}

#pragma mark - Public

- (void)clean {
    NSDictionary *pileCfgDic = self.pileKeyLayoutDic;
    NSArray *layoutKeys = pileCfgDic.allKeys;
    for (NSString *layoutKey in layoutKeys) {
        NSArray *piles = self.pileViewDic[layoutKey].allValues;
        for (UIView *pile in piles) {
            [pile removeFromSuperview];
        }
    }
    self.pileViewDic = nil;
    self.pileConstraintsDic = nil;
}

- (BOOL)check:(NSString *)layoutKey p:(NSString *)pileKey {
    NSDictionary *pileCfgDic = self.pileKeyLayoutDic;
    NSArray *p_key_rows = pileCfgDic[layoutKey];
    
    for (NSArray *piles in p_key_rows) {
        for (NSString *key in piles) {
            if ([key isEqualToString:pileKey]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)checkV:(UIView *)v {
    return [self check:v.cqhLayoutKey p:v.cqhPileKey];
}

- (BOOL)addV:(UIView *)v {
    //    NSLog(@"%s-%@-%@", __func__, v.layoutKey, v.pileKey);
    if (v == nil) { return NO; }
    UIView *pileV = [self p_pileV:v];
    if (pileV == nil) { return NO; }
    
    [v removeFromSuperview];
    [self.superV addSubview:v];
    
    NSUInteger layoutType = [v.cqhLayoutKey integerValue];
    
    if (layoutType == QHPileViewManLayoutTopLeft) {
        [v mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pileV);
            make.left.equalTo(pileV);
        }];
    }
    else if (layoutType == QHPileViewManLayoutTopRight) {
        [v mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pileV);
            make.right.equalTo(pileV);
        }];
    }
    else if (layoutType == QHPileViewManLayoutBottomLeft) {
        [v mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(pileV);
            make.left.equalTo(pileV);
        }];
    }
    else if (layoutType == QHPileViewManLayoutBottomRight) {
        [v mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(pileV);
            make.right.equalTo(pileV);
        }];
    }
    
    return YES;
}

- (void)removeV:(UIView *)v {
    if (v == nil) { return; }
    
    [v removeFromSuperview];
}

- (void)showV:(UIView *)v {
    if (v == nil) { return; }
    UIView *pileV = [self p_pileV:v];
    if (pileV == nil) { return; }
    
    [pileV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(v.mas_width).mas_offset(20);
        make.height.equalTo(v.mas_height).mas_offset(20);
    }];
    NSArray *constraints = self.pileConstraintsDic[v.cqhLayoutKey][v.cqhPileKey];
    for (MASConstraint *constraint in constraints) {
        [constraint install];
    }
}

- (void)hideV:(UIView *)v {
    if (v == nil) { return; }
    UIView *pileV = [self p_pileV:v];
    if (pileV == nil) { return; }
    
    [pileV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    NSArray *constraints = self.pileConstraintsDic[v.cqhLayoutKey][v.cqhPileKey];
    for (MASConstraint *constraint in constraints) {
        [constraint install];
    }
}

#pragma mark - Private

- (void)p_setup {
    _pileViewDic = [NSMutableDictionary new];
    _pileConstraintsDic = [NSMutableDictionary new];
    
    [self p_makePileCfgs];
    [self p_makePileView];
}

- (void)p_makePileCfgs {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"QHPileViewManDemo" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    id obj = [self json2Obj:data];
    _pileCfgs = [obj mutableCopy];
    
    _pileKeyLayoutDic = [NSMutableDictionary new];
    
    NSArray *layoutKeys = @[[NSString stringWithFormat:@"%lu", (unsigned long)QHPileViewManLayoutTopLeft],
                            [NSString stringWithFormat:@"%lu", (unsigned long)QHPileViewManLayoutTopRight],
                            [NSString stringWithFormat:@"%lu", (unsigned long)QHPileViewManLayoutBottomLeft],
                            [NSString stringWithFormat:@"%lu", (unsigned long)QHPileViewManLayoutBottomRight]];

    for (NSString *layoutKey in layoutKeys) {
        [_pileKeyLayoutDic setValue:[NSMutableArray new] forKey:layoutKey];
        [_pileViewDic setValue:[NSMutableDictionary new] forKey:layoutKey];
        [_pileConstraintsDic setValue:[NSMutableDictionary new] forKey:layoutKey];
    }
    
    NSMutableArray *pileKeys = [NSMutableArray new];
    
    for (NSString *layoutKey in layoutKeys) {
        QHPileViewManLayout layout = [layoutKey integerValue];
        NSArray *obj_tmp = (layout == QHPileViewManLayoutTopLeft || layout == QHPileViewManLayoutTopRight) ? obj : [((NSArray *)obj).reverseObjectEnumerator allObjects];
        
        for (NSArray *rows in obj_tmp) { // column
            NSArray *rows_tmp = (layout == QHPileViewManLayoutTopLeft || layout == QHPileViewManLayoutBottomLeft) ? rows : [rows.reverseObjectEnumerator allObjects];
            NSInteger count = rows_tmp.count;
            NSMutableArray *p_key_rows = [NSMutableArray new];
            BOOL stop = NO;
            
            for (NSInteger i = 0; i < count; i++) { // row
                NSDictionary *p = rows_tmp[i];
                NSString *key = [p.allKeys[0] lowercaseString]; // p
                if ([key isEqualToString:@"null"]) {
                    stop = (0 == i);
                    break;
                }
                [p_key_rows addObject:key];
                if (![pileKeys containsObject:key]) {
                    [pileKeys addObject:key];
                }
            }
            if (stop) {
                break;
            }
            [self.pileKeyLayoutDic[layoutKey] addObject:p_key_rows];
        }
    }
    _pileKeys = [pileKeys copy];
}

- (void)p_makePileView {
    NSDictionary *pileCfgDic = self.pileKeyLayoutDic;
    NSArray *layoutKeys = pileCfgDic.allKeys;
    UIView *superV = self.superV;
    
    for (NSString *layoutKey in layoutKeys) {
        NSArray *p_key_rows = pileCfgDic[layoutKey];
        NSUInteger layout = [layoutKey integerValue];
        
        for (int i = 0; i < p_key_rows.count; i++) {
            NSArray *piles = p_key_rows[i];
            NSArray *lastPiles = nil;
            if (i > 0) { lastPiles = p_key_rows[i - 1]; }
            UIView *lastV = nil;
            
            for (int j = 0; j < piles.count; j++) {
                UIView *pileV = [UIView new];
                pileV.backgroundColor = [UIColor blackColor];
                [superV addSubview:pileV];
                NSMutableArray<MASConstraint *> *constraints = [NSMutableArray new];
//                NSLog(@"chen>%i>%i", i, j);
                
                [pileV mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (lastPiles) {
                        if (layout == QHPileViewManLayoutTopLeft || layout == QHPileViewManLayoutTopRight) {
                            for (NSString *last_pile_key in lastPiles) {
                                UIView *v = self.pileViewDic[layoutKey][last_pile_key];
                                MASConstraint *c = make.top.lessThanOrEqualTo(v.mas_bottom);
                                [constraints addObject:c];
                            }
                        }
                        else if (layout == QHPileViewManLayoutBottomLeft || layout == QHPileViewManLayoutBottomRight) {
                            for (NSString *last_pile_key in lastPiles) {
                                UIView *v = self.pileViewDic[layoutKey][last_pile_key];
                                MASConstraint *c = make.bottom.lessThanOrEqualTo(v.mas_top);
                                [constraints addObject:c];
                            }
                        }
                    }
                    else {
                        if (layout == QHPileViewManLayoutTopLeft || layout == QHPileViewManLayoutTopRight) {
                            MASConstraint *c = make.top.equalTo(self.topView);
                            [constraints addObject:c];
                        }
                        else if (layout == QHPileViewManLayoutBottomLeft || layout == QHPileViewManLayoutBottomRight) {
                            MASConstraint *c = make.bottom.equalTo(self.bottomView);
                            [constraints addObject:c];
                        }
                    }
                    if (layout == QHPileViewManLayoutTopLeft || layout == QHPileViewManLayoutBottomLeft) {
                        if (lastV) {
                            MASConstraint *l = make.left.equalTo(lastV.mas_right);
                            [constraints addObject:l];
                        }
                        else {
                            MASConstraint *l = make.left.equalTo(self.topView).mas_offset(0);
                            [constraints addObject:l];
                        }
                    }
                    else if (layout == QHPileViewManLayoutTopRight || layout == QHPileViewManLayoutBottomRight) {
                        if (lastV) {
                            MASConstraint *l = make.right.equalTo(lastV.mas_left);
                            [constraints addObject:l];
                        }
                        else {
                            MASConstraint *l = make.right.equalTo(self.bottomView).mas_offset(0);
                            [constraints addObject:l];
                        }
                    }
                }];
                NSString *key = piles[j];
                [self.pileViewDic[layoutKey] setValue:pileV forKey:key];
                [self.pileConstraintsDic[layoutKey] setValue:constraints forKey:key];
                lastV = pileV;
            }
        }
    }
}

- (UIView *)p_pileV:(UIView *)v {
    UIView *pileV = self.pileViewDic[v.cqhLayoutKey][v.cqhPileKey];
    return pileV;
}

#pragma mark - Util

- (NSDictionary *)json2Obj:(NSData *)data {
    NSError *error;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    if (error) {
        NSLog(@"%s:%@", __func__, error);
    }
    return obj;
}

@end