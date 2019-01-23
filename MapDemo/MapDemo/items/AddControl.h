//
//  AddControl.h
//  MapDemo
//
//  Created by KongPeng on 2018/7/17.
//  Copyright © 2018年 erlinyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddControl : UIView
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UISwitch *sw;

- (instancetype)initWithTitle:(NSString *)title isOn:(BOOL)isOn swValueChange:(void (^)(AddControl *control))valueChangeBlk;
@end
