//
//  UIView+QHPileView.h
//  QHPileViewMan
//
//  Created by qihuichen on 2022/5/31.
//

#import <UIKit/UIKit.h>

#import "QHPileViewMan.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (QHPileView)

@property NSString *cqhLayoutKey;
@property NSString *cqhPileKey;
@property QHPileViewMan *cqhPileMan;
@property BOOL cqhPileHidden;

- (BOOL)cqh_pile_make:(QHPileViewMan * _Nullable)man layout:(QHPileViewManLayout)layout pile:(NSString *)pileKey;
- (BOOL)cqh_pile_check;
- (BOOL)cqh_pile_add;
- (void)cqh_pile_remove;
- (void)cqh_pile_updateSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
