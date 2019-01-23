//
//  PaddingMapViewController.m
//  MapDemo
//
//  Created by xiaoyuan on 2018/4/4.
//  Copyright © 2018年 erlinyou. All rights reserved.
//

#import "PaddingMapViewController.h"
#import <ERMapSDK/ERMapSDK.h>

@interface PaddingMapViewController () <ERMapViewDelegate>

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;
@property (nonatomic, strong) NSMutableArray<UITextField *> *textFieldArray;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *constraints;
@property (strong, nonatomic) ERMapView *mapView;

@end

@implementation PaddingMapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mapView.camera = [ERCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(48.857792,2.341279) zoom:19];
    [self.mapView registerSelf];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView removeSelf];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)dealloc {
    self.buttonArray = nil;
    self.textFieldArray = nil;
    self.constraints = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIEdgeInsets)getNewPadding {
    __block UIEdgeInsets newPadding = UIEdgeInsetsZero;
    [self.textFieldArray enumerateObjectsUsingBlock:^(UITextField * _Nonnull tf, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([tf.accessibilityIdentifier isEqualToString:@"top"]) {
            newPadding.top = tf.text.doubleValue;
        }
        else if ([tf.accessibilityIdentifier isEqualToString:@"bottom"]) {
            newPadding.bottom = tf.text.doubleValue;
        }
        else if ([tf.accessibilityIdentifier isEqualToString:@"left"]) {
            newPadding.left = tf.text.doubleValue;
        }
        else if ([tf.accessibilityIdentifier isEqualToString:@"right"]) {
            newPadding.right = tf.text.doubleValue;
        }
    }];
    return newPadding;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - ERMapViewDelegate
////////////////////////////////////////////////////////////////////////

- (void)mapView:(ERMapView *)mapView handleScroll:(UIGestureRecognizerState)state {
    if (state == UIGestureRecognizerStateBegan) {
        [self.textFieldArray enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj resignFirstResponder];
        }];
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////
- (void)textFieldDidChange:(UITextField *)textField {
    [self updatePadding];
}

- (void)clickUpdatePadding:(UIButton *)button {
    [self updatePadding];
    [self.textFieldArray enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj resignFirstResponder];
    }];
}

- (void)updatePadding {
    [self.mapView setPadding:[self getNewPadding] animated:YES];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UI
////////////////////////////////////////////////////////////////////////

- (void)setupUI {
    [self.view addSubview:self.mapView];
    id topLayoutGuide = self.topLayoutGuide;
    
    UIView *exampleView = [UIView new];
    [self.view addSubview:exampleView];
    exampleView.translatesAutoresizingMaskIntoConstraints = false;
    exampleView.backgroundColor = [UIColor whiteColor];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mapView]-0-|" options:kNilOptions metrics:nil views:@{@"mapView":self.mapView}]];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[exampleView]|" options:kNilOptions metrics:nil views:@{@"exampleView": exampleView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][exampleView(80.0)][mapView]|" options:kNilOptions metrics:nil views:@{@"exampleView": exampleView, @"topLayoutGuide": topLayoutGuide, @"mapView":self.mapView}]];
    
    NSArray *titles = @[@"top", @"right", @"left", @"bottom"];
    for (NSInteger i = 0; i < titles.count; i++) {
        NSString *title = titles[i];
        UIButton *btn = [self createButton];
        btn.tag = i;
        btn.accessibilityIdentifier = title;
        [btn setTitle:title forState:UIControlStateNormal];
        [self.buttonArray addObject:btn];
        UITextField *tf = [self createTextField];
        tf.placeholder = @"0";
        tf.accessibilityIdentifier = title;
        tf.tag = i;
        [tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.textFieldArray addObject:tf];
        [exampleView addSubview:btn];
        [exampleView addSubview:tf];
        [btn addTarget:self action:@selector(clickUpdatePadding:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view setNeedsUpdateConstraints];
    [self.textFieldArray.firstObject becomeFirstResponder];
}

- (void)updateViewConstraints {
    
    [NSLayoutConstraint deactivateConstraints:self.constraints];
    [self.constraints removeAllObjects];
    NSMutableString *buttonHFormat = @"".mutableCopy;
    NSMutableString *tfHFormat = @"".mutableCopy;
    NSMutableDictionary *subviewsDict = @{}.mutableCopy;
    NSDictionary *metrics = @{@"padding": @10.0};
    UIButton *dependentBtn = nil;
    for (NSInteger i = 0; i < self.buttonArray.count; i++) {
        UIButton *btn = self.buttonArray[i];
        UITextField *tf = self.textFieldArray[i];
        NSString *btnKey = [NSString stringWithFormat:@"%@_%ld", NSStringFromClass(btn.class).lowercaseString, i];
        NSString *tfKey = [NSString stringWithFormat:@"%@_%ld", NSStringFromClass(tf.class).lowercaseString, i];
        [subviewsDict setObject:btn forKey:btnKey];
        [subviewsDict setObject:tf forKey:tfKey];
        [buttonHFormat appendFormat:@"-(padding)-[%@]", btnKey];
        if (i == self.buttonArray.count - 1) {
            [buttonHFormat appendFormat:@"-(padding)-"];
        }
        [tfHFormat appendFormat:@"-(padding)-[%@]", tfKey];
        if (i == self.buttonArray.count - 1) {
            [tfHFormat appendFormat:@"-(padding)-"];
        }
        
        NSString *vFormat = [NSString stringWithFormat:@"V:|-(padding)-[%@(==25.0)]-(padding)-[%@]-(padding)-|", tfKey, btnKey];
        [self.constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vFormat options:NSLayoutFormatAlignAllCenterX metrics:metrics views:subviewsDict]];
        if (dependentBtn) {
            [self.constraints addObject:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:dependentBtn attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        }
        
        dependentBtn = btn;
    }
    
    if (tfHFormat.length) {
        [self.constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|%@|",tfHFormat] options:kNilOptions metrics:metrics views:subviewsDict]];
    }
    
    if (buttonHFormat.length) {
        [self.constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|%@|",buttonHFormat] options:kNilOptions metrics:metrics views:subviewsDict]];
    }
    
    [NSLayoutConstraint activateConstraints:self.constraints];
    
    [super updateViewConstraints];
}

- (NSMutableArray<UIButton *> *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = @[].mutableCopy;
    }
    return _buttonArray;
}

- (NSMutableArray<UITextField *> *)textFieldArray {
    if (!_textFieldArray) {
        _textFieldArray = @[].mutableCopy;
    }
    return _textFieldArray;
}

- (NSMutableArray *)constraints {
    if (!_constraints) {
        _constraints = @[].mutableCopy;
    }
    return _constraints;
}


- (UIButton *)createButton {
    UIButton *btn = [UIButton new];
    btn.translatesAutoresizingMaskIntoConstraints = false;
    btn.layer.cornerRadius = 6.0;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [btn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    return btn;
}

- (UITextField *)createTextField {
    UITextField *tf = [UITextField new];
    tf.translatesAutoresizingMaskIntoConstraints = false;
    tf.borderStyle = UITextBorderStyleRoundedRect;
    [tf setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [tf setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    tf.keyboardType = UIKeyboardTypeDecimalPad;
    tf.returnKeyType = UIReturnKeyGo;
    
    return tf;
}

- (ERMapView *)mapView {
    if (_mapView == nil)
    {
        _mapView = [[ERMapView alloc] initWithFrame:self.view.bounds];
        _mapView.translatesAutoresizingMaskIntoConstraints = NO;
        _mapView.mapViewDelegate = self;
    }
    return _mapView;
}

@end
