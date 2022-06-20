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

#pragma mark - Public

- (BOOL)cqh_makePile:(QHPileViewMan * _Nullable)man layout:(QHPileViewManLayout)layout pile:(NSString *)pileKey {
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

- (BOOL)cqh_directCheckPile {
    return [self.cqhPileMan checkV:self];
}

// 链式调用不能返回 nil，否则下一个调用者会导致崩溃

- (UIView * (^)(BOOL * _Nullable ret))cqh_checkPile {
    return ^id(BOOL *ret) {
        BOOL r = [self.cqhPileMan checkV:self];
        if (ret != nil) {
            *ret = r;
        }
        return self;
    };
}

- (UIView * (^)(BOOL * _Nullable ret))cqh_addPile {
    return ^id(BOOL *ret) {
        BOOL r = [self.cqhPileMan addV:self];
        if (ret != nil) {
            *ret = r;
        }
        return self;
    };
}

- (UIView * (^)(void))cqh_removePile {
    return ^id {
        [self.cqhPileMan removeV:self];
        return self;
    };
}

- (UIView * (^)(BOOL))cqh_showPile {
    return ^id(BOOL bShow) {
        if (bShow) {
            [self.cqhPileMan showV:self];
        }
        else {
            [self.cqhPileMan hideV:self];
        }
        return self;
    };
}

- (UIView * (^)(CGSize))cqh_updateSize {
    return ^id(CGSize size) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(size.width);
            make.height.mas_equalTo(size.height);
        }];
        return self;
    };
}

@end
