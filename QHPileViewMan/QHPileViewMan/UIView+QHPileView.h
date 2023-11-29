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

- (BOOL)cqh_makePile:(QHPileViewMan * _Nullable)man layout:(QHPileViewManLayout)layout pile:(NSString *)pileKey;
- (BOOL)cqh_directCheckPile;
//- (UIView * (^)(BOOL * _Nullable ret))cqh_checkPile;
- (UIView * (^)(BOOL * _Nullable ret))cqh_addPile;
- (UIView * (^)(void))cqh_removePile;
- (UIView * (^)(BOOL))cqh_hidePile;
- (UIView * (^)(CGSize))cqh_updateSize;

@end

NS_ASSUME_NONNULL_END
