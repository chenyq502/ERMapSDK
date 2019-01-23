//
//  SliderView.m
//  MapDemo
//
//  Created by xiaoyuan on 2018/6/8.
//  Copyright © 2018 erlinyou. All rights reserved.
//

#import "SliderView.h"

@interface SliderView ()

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *subButton;
@property (nonatomic, strong) UITextField *valueField;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesOfAddButton;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesOfSubButton;

@end

@implementation SliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.minimumValue = 0.0;
        self.maximumValue = 1.0;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.addButton];
        [self addSubview:self.subButton];
        [self addSubview:self.valueField];
        [self _addConstraints];
        
        [self.addButton addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventTouchDown];
        [self.subButton addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventTouchDown];
        
        self.continuous = YES;
    }
    return self;
}

- (void)dealloc {
    [_subButton removeObserver:self forKeyPath:@"highlighted"];
    [_addButton removeObserver:self forKeyPath:@"highlighted"];
    [_addButton removeObserver:self forKeyPath:@"selected"];
    [_subButton removeObserver:self forKeyPath:@"selected"];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.autoHidden) {    
        [self hiddenValueLabel];
    }
}

- (void)_addConstraints {
    [NSLayoutConstraint constraintWithItem:self.addButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.addButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.addButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.addButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.addButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.addButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:20.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.subButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.subButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.subButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.subButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.addButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.subButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.addButton attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.valueField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.valueField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.valueField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.valueField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.38 constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.addButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.valueField attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.subButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.valueField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0].active = YES;
}

- (void)setContinuous:(BOOL)continuous {
    _continuous = continuous;
    if (continuous == YES) {
        [self _addLongGesture];
    }
    else {
        [self _removeLongGesture];
    }
}

- (void)setMinimumValueColor:(UIColor *)minimumValueColor forState:(UIControlState)state {
    [self.subButton setTitleColor:minimumValueColor forState:state];
}
- (void)setMaximumValueColor:(UIColor *)minimumValueColor forState:(UIControlState)state {
    [self.addButton setTitleColor:minimumValueColor forState:state];
}

- (void)_addLongGesture {
    if (self.longPressGesOfAddButton == nil) {
        UILongPressGestureRecognizer *longPressGesUp1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressUp:)];
        longPressGesUp1.minimumPressDuration = 0.3;
        [self.addButton addGestureRecognizer:longPressGesUp1];
        self.longPressGesOfAddButton = longPressGesUp1;
    }
    
    if (self.longPressGesOfSubButton == nil) {
        UILongPressGestureRecognizer *longPressGesUp2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressUp:)];
        longPressGesUp2.minimumPressDuration = 0.3;
        [self.subButton addGestureRecognizer:longPressGesUp2];
        self.longPressGesOfSubButton = longPressGesUp2;
    }
    
}
- (void)_removeLongGesture {
    if (self.longPressGesOfAddButton) {
        [self.addButton removeGestureRecognizer:self.longPressGesOfAddButton];
        self.longPressGesOfAddButton = nil;
    }
    if (self.longPressGesOfSubButton) {
        [self.subButton removeGestureRecognizer:self.longPressGesOfSubButton];
        self.longPressGesOfSubButton = nil;
    }
}

- (void)longPressUp:(UILongPressGestureRecognizer *)longGesture {
    [self sliderValueChange:(id)longGesture.view];
    UIButton *btn = (id)longGesture.view;
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan: {
            btn.selected = YES;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            btn.selected = NO;
            break;
        }
        default:
            break;
    }
}

- (void)sliderValueChange:(id)sender {
    
    if ([sender tag] == 1001) {
        self.value ++;
    }
    else if ([sender tag] == 1002) {
        self.value --;
    }
    else if (sender == self.valueField) {
        self.value = self.valueField.text.integerValue;
    }
    if (self.autoHidden) {
        [self showValueView];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenValueLabel) object:nil];
        [self performSelector:@selector(hiddenValueLabel) withObject:nil afterDelay:2.0];
    }
}

- (void)hiddenValueLabel {
    self.valueField.alpha = 0.0;
    [UIView animateWithDuration:0.1 animations:^{
        [self.valueField layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.valueField.hidden = YES;
    }];
}

- (void)showValueView {
    self.valueField.alpha = 1.0;
    [UIView animateWithDuration:0.1 animations:^{
        [self.valueField layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.valueField.hidden = NO;
    }];
}

- (void)setMinimumValue:(float)minimumValue {
    _minimumValue = minimumValue;
    self.value = self.value;
}

- (void)setMaximumValue:(float)maximumValue {
    _maximumValue = maximumValue;
    self.value = self.value;
}

- (void)setValue:(float)value {
    [self setValue:value limit:YES];
}

- (void)setValue:(float)value limit:(BOOL)limit {
    NSString *valueKey = NSStringFromSelector(@selector(value));
    [self willChangeValueForKey:valueKey];
    if (limit) {
        if (value > self.maximumValue) {
            value = self.maximumValue;
        }
        if (value < self.minimumValue) {
            value = self.minimumValue;
        }
    }
    
    self.valueField.text = @(value).stringValue;
    if (self.valueChangeBlock) {
        self.valueChangeBlock(self);
    }
    [self didChangeValueForKey:valueKey];
}

- (float)value {
    return self.valueField.text.floatValue;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton new];
        _addButton.translatesAutoresizingMaskIntoConstraints = NO;
        _addButton.tag = 1001;
        [_addButton setTitle:@"＋" forState:UIControlStateNormal];
        [_addButton setTitleColor:[[UIColor yellowColor] colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
        _addButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _addButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
        _addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_addButton addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
        [_addButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
        _addButton.layer.cornerRadius = 3.0;
        _addButton.layer.masksToBounds = YES;
    }
    return _addButton;
}

- (UIButton *)subButton {
    if (!_subButton) {
        _subButton = [UIButton new];
        _subButton.translatesAutoresizingMaskIntoConstraints = NO;
        _subButton.tag = 1002;
        [_subButton setTitle:@"－" forState:UIControlStateNormal];
        [_subButton setTitleColor:[[UIColor yellowColor] colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
        _subButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _subButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
        _subButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_subButton addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
        [_subButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
        _subButton.layer.cornerRadius = 3.0;
        _subButton.layer.masksToBounds = YES;
    }
    return _subButton;
}

- (UITextField *)valueField {
    if (!_valueField) {
        _valueField = [UITextField new];
        _valueField.translatesAutoresizingMaskIntoConstraints = NO;
        _valueField.adjustsFontSizeToFitWidth = YES;
//        _valueField.backgroundColor = [UIColor clearColor];
        _valueField.text = @(self.value).stringValue;
        _valueField.textColor = [[UIColor orangeColor] colorWithAlphaComponent:0.7];
        _valueField.textAlignment = NSTextAlignmentCenter;
        [_valueField setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_valueField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _valueField.keyboardType = UIKeyboardTypeDecimalPad;
        _valueField.returnKeyType = UIReturnKeyGo;
        _valueField.userInteractionEnabled = NO;
    }
    return _valueField;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////
- (void)textFieldDidChange:(UITextField *)textField {
    [self sliderValueChange:textField];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Observer
////////////////////////////////////////////////////////////////////////
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"highlighted"] || [keyPath isEqualToString:@"selected"]) {
        UIButton *btn = object;
        if (btn.isHighlighted == YES || btn.isSelected == YES) {
            btn.backgroundColor = UIColor.orangeColor;
        }
        else {
            btn.backgroundColor = UIColor.clearColor;
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
