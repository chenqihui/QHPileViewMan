//
//  QHPileViewMan.h
//  QHPileViewMan
//
//  Created by qihuichen on 2022/5/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Masonry.h"

NS_ASSUME_NONNULL_BEGIN

struct QHPileViewMake {
    UIView *topV;
    UIView *leftV;
    UIView *bottomV;
    UIView *rightV;
};

typedef enum : NSUInteger {
    QHPileViewManLayoutTopLeft = 0,
    QHPileViewManLayoutTopRight,
    QHPileViewManLayoutBottomLeft,
    QHPileViewManLayoutBottomRight,
} QHPileViewManLayout;

@interface QHPileViewMan : NSObject

@property (nonatomic, strong, readonly) NSArray *pileKeys;

- (instancetype)initWith:(UIView *)superV make:(struct QHPileViewMake)pileMake edge:(UIEdgeInsets)edge path:(NSString *)jsonPath;
- (instancetype)initWith:(UIView *)superV make:(struct QHPileViewMake)pileMake edge:(UIEdgeInsets)edge path:(NSString *)jsonPath bLeftAlign:(BOOL)bLeft;
- (void)setGlobalPile:(QHPileViewManLayout)layout edge:(UIEdgeInsets)edge;
- (void)clean;
- (BOOL)check:(NSString *)layoutKey p:(NSString *)pileKey;

- (BOOL)checkV:(UIView *)v;
- (BOOL)addV:(UIView *)v;
- (void)removeV:(UIView *)v;
- (void)showV:(UIView *)v;
- (void)hideV:(UIView *)v;

// 临时增加
- (void)test;
- (void)updateTopPile:(UIView *)leftV edge:(CGFloat)w;
- (UIView *)getPile:(NSString *)layoutKey pileKey:(NSString *)pileKey;

@end

NS_ASSUME_NONNULL_END
