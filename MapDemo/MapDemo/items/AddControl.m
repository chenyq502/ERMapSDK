//
//  AddControl.m
//  MapDemo
//
//  Created by KongPeng on 2018/7/17.
//  Copyright © 2018年 erlinyou. All rights reserved.
//

#import "AddControl.h"

@implementation AddControl {
    void (^_swValueChangeBlk)(AddControl *control);
}

- (instancetype)initWithTitle:(NSString *)title isOn:(BOOL)isOn swValueChange:(void (^)(AddControl *control))valueChangeBlk {
    if (self = [super init]) {
        [self addSubview:self.sw];
        [self addSubview:self.label];
        
        CGFloat padding = 5.0;
        
        [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:padding].active = YES;
        [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.sw attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-padding].active = YES;
        [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0].active = YES;
        
        [NSLayoutConstraint constraintWithItem:self.sw attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0].active = YES;
        [NSLayoutConstraint constraintWithItem:self.sw attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-padding].active = YES;
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.sw attribute:NSLayoutAttributeHeight multiplier:1.0 constant:padding*2].active = YES;
        
        self.label.text = title;
        [self.sw setOn:isOn];
        _swValueChangeBlk = valueChangeBlk;
        [self.sw addTarget:self action:@selector(swValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)swValueChange:(UISwitch *)sw {
    if (_swValueChangeBlk) {
        _swValueChangeBlk(self);
    }
}

- (UISwitch *)sw {
    if (!_sw) {
        UISwitch *sw = [UISwitch new];
        sw.translatesAutoresizingMaskIntoConstraints = false;
        _sw = sw;
    }
    return _sw;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = false;
        _label = label;
    }
    return _label;
}
@end
