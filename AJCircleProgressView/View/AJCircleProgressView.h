//
//  AJCircleProgressView.h
//  ObjCPlayground
//
//  Created by ChuanJie Jhuang on 2020/5/20.
//  Copyright © 2020 ChuanJie Jhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE

@interface AJCircleProgressView : UIView

/// Unfilled track color
@property (nonatomic, strong) IBInspectable UIColor *trackColor;

/// Filled track stroke color
@property (nonatomic, strong) IBInspectable UIColor *strokeColor;

/// Filled progress from 0 to 1.
@property (nonatomic, assign) IBInspectable CGFloat progress;

/// Animate circle progress.
/// @param endProgress to end progress
/// @param duration duration time
/// @param completion animation completion block
- (void)animateCircleToEndProgress:(CGFloat)endProgress andDuration:(CFTimeInterval)duration withCompletion:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
