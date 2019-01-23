//
//  SliderView.h
//  MapDemo
//
//  Created by xiaoyuan on 2018/6/8.
//  Copyright © 2018 erlinyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderView : UIView

@property (nonatomic) float value;
@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic,getter=isContinuous) BOOL continuous;
@property (nonatomic, copy) void (^ valueChangeBlock)(SliderView *slider);
@property (nonatomic, assign) BOOL autoHidden;
- (void)setMinimumValueColor:(UIColor *)minimumValueColor forState:(UIControlState)state;
- (void)setMaximumValueColor:(UIColor *)minimumValueColor forState:(UIControlState)state;

@end
