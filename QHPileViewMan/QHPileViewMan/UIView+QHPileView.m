//
//  UIView+QHPileView.m
//  QHPileViewMan
//
//  Created by qihuichen on 2022/5/31.
//

#import "UIView+QHPileView.h"

/*
 [ios开发runtime学习四：动态添加属性 - Hello_IOS - 博客园](https://www.cnblogs.com/cqb-learner/p/5871917.html)
 */

#import <objc/message.h>

static const char *CQHLayoutKey = "CQHLayoutKey";
static const char *CQHPileKey = "CQHPileKey";
static const char *CQHPileManKey = "CQHPileManKey";

@implementation UIView (QHPileView)

- (NSString *)cqhLayoutKey {
    return objc_getAssociatedObject(self, CQHLayoutKey);
}

- (void)setCqhLayoutKey:(NSString *)layoutKey {
    objc_setAssociatedObject(self, CQHLayoutKey, layoutKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)cqhPileKey {
    // 根据关联的key，获取关联的值。
    return objc_getAssociatedObject(self, CQHPileKey);
}

- (void)setCqhPileKey:(NSString *)pileKey {
    // 第一个参数：给哪个对象添加关联
    // 第二个参数：关联的key，通过这个key获取
    // 第三个参数：关联的value
    // 第四个参数：关联的策略
    objc_setAssociatedObject(self, CQHPileKey, pileKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QHPileViewMan *)cqhPileMan {
    return objc_getAssociatedObject(self, CQHPileManKey);
}

- (void)setCqhPileMan:(QHPileViewMan *)cqhPileMan {
    objc_setAssociatedObject(self, CQHPileManKey, cqhPileMan, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setCqhPileHidden:(BOOL)hidden {
    if (hidden) {
        [self.cqhPileMan hideV:self];
    }
    else {
        [self.cqhPileMan showV:self];
    }
    self.hidden = hidden;
}

#pragma mark - Public

- (BOOL)cqh_pile_make:(QHPileViewMan * _Nullable)man layout:(QHPileViewManLayout)layout pile:(NSString *)pileKey {
    if (man == nil && self.cqhPileMan == nil) {
        return NO;
    }
    if (man != nil) {
        self.cqhPileMan = man;
    }
    NSString *l = [NSString stringWithFormat:@"%lu", (unsigned long)layout];
    BOOL ret = [self.cqhPileMan check:l p:pileKey];
    if (ret) {
        self.cqhLayoutKey = l;
        self.cqhPileKey = pileKey;
    }
    return ret;
}

- (BOOL)cqh_pile_check {
    return [self.cqhPileMan checkV:self];
}

- (BOOL)cqh_pile_add {
    return [self.cqhPileMan addV:self];;
}

- (void)cqh_pile_remove {
    [self.cqhPileMan removeV:self];;
}

- (void)cqh_pile_updateSize:(CGSize)size {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];
}

@end
