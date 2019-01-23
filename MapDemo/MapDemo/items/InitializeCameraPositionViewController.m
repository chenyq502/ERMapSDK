//
//  InitializeCameraPositionViewController.m
//  MapDemo
//
//  Created by xiaoyuan on 2018/4/4.
//  Copyright © 2018年 erlinyou. All rights reserved.
//

#import "InitializeCameraPositionViewController.h"
#import <ERMapSDK/ERMapSDK.h>

@interface InitializeCameraPositionViewController () <ERMapViewDelegate>

@property (strong, nonatomic) ERMapView *mapView;

@property (nonatomic, strong) UITextField *longitudeTF;
@property (nonatomic, strong) UITextField *latitudeTF;
@property (nonatomic, strong) UIButton *goButton;
@property (nonatomic, strong) UITextField *angleTF;
@property (nonatomic, strong) UIButton *angleButton;
@property (nonatomic, strong) UITextField *levelTF;
@property (nonatomic, strong) UIButton *levelButton;

@end

@implementation InitializeCameraPositionViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView registerSelf];
    self.mapView.camera = [ERCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(48.857792,2.341279) zoom:19];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView removeSelf];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

////////////////////////////////////////////////////////////////////////
#pragma mark - ERMapViewDelegate
////////////////////////////////////////////////////////////////////////

- (void)mapView:(ERMapView *)mapView handleScroll:(UIGestureRecognizerState)state {
    if (state == UIGestureRecognizerStateBegan) {
        [self.view endEditing:YES];
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////

- (void)angleClick {
    if (self.angleTF.text.length <= 0) {
        return;
    }
    ERCameraPosition *camera = [ERCameraPosition cameraWithTarget:self.mapView.camera.target zoom:self.mapView.camera.zoom viewingAngle:self.angleTF.text.doubleValue];
    [self.mapView setCamera:camera animated:YES];
    
}

- (void)levelClick {
    if (self.levelTF.text.length <= 0) {
        return;
    }
    CGFloat level = self.levelTF.text.floatValue;
    if (level < 1) {
        self.levelTF.text = @"1";
    }
    
    if (level > 27) {
        self.levelTF.text = @"27";
    }
    ERCameraPosition *camera = [ERCameraPosition cameraWithTarget:self.mapView.camera.target zoom:self.levelTF.text.doubleValue viewingAngle:self.mapView.camera.viewingAngle];
    [self.mapView setCamera:camera animated:YES];
}

- (void)goClick {
    if (self.longitudeTF.text.length == 0 || self.latitudeTF.text.length == 0) {
        return;
    }
    CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake(self.latitudeTF.text.doubleValue, self.longitudeTF.text.doubleValue);
    ERCameraPosition *camera = [ERCameraPosition cameraWithTarget:coordinate2D zoom:self.mapView.camera.zoom viewingAngle:self.mapView.camera.viewingAngle];
    [self.mapView setCamera:camera animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UITextField *)longitudeTF {
    if (!_longitudeTF) {
        UITextField *tf = [UITextField new];
        _longitudeTF = tf;
        _longitudeTF.borderStyle = UITextBorderStyleRoundedRect;
        _longitudeTF.placeholder = @"longitude";
        _longitudeTF.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _longitudeTF;
}

- (UITextField *)latitudeTF {
    if (!_latitudeTF) {
        _latitudeTF = [UITextField new];
        _latitudeTF.borderStyle = UITextBorderStyleRoundedRect;
        _latitudeTF.placeholder = @"latitude";
        _latitudeTF.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _latitudeTF;
}

- (UIButton *)goButton {
    if (!_goButton) {
        _goButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_goButton setTitle:@"Set camera\nposition" forState:UIControlStateNormal];
        [_goButton addTarget:self action:@selector(goClick) forControlEvents:UIControlEventTouchUpInside];
        [_goButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _goButton.titleLabel.numberOfLines = 2;
        _goButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _goButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _goButton;
}

- (UITextField *)angleTF {
    if (!_angleTF) {
        _angleTF = [UITextField new];
        _angleTF.borderStyle = UITextBorderStyleRoundedRect;
        _angleTF.placeholder = @"Set angle";
        _angleTF.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _angleTF;
}

- (UIButton *)angleButton {
    if (!_angleButton) {
        _angleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_angleButton setTitle:@"Set angle" forState:UIControlStateNormal];
        [_angleButton addTarget:self action:@selector(angleClick) forControlEvents:UIControlEventTouchUpInside];
        [_angleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    }
    return _angleButton;
}

- (UITextField *)levelTF {
    if (!_levelTF) {
        _levelTF = [UITextField new];
        _levelTF.borderStyle = UITextBorderStyleRoundedRect;
        _levelTF.placeholder = @"Set level";
        _levelTF.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _levelTF;
}

- (UIButton *)levelButton {
    if (!_levelButton) {
        _levelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_levelButton setTitle:@"Set level" forState:UIControlStateNormal];
        [_levelButton addTarget:self action:@selector(levelClick) forControlEvents:UIControlEventTouchUpInside];
        [_levelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    }
    return _levelButton;
}

- (void)mapView:(ERMapView *)mapView didChangeCameraPosition:(ERCameraPosition *)cameraPosition
{
    ERCameraPosition *camera = cameraPosition;
    CLLocationCoordinate2D currentCoordinate2d = camera.target;
    
    self.latitudeTF.text =  [NSString stringWithFormat:@"%.6f",currentCoordinate2d.latitude];
    self.longitudeTF.text = [NSString stringWithFormat:@"%.6f",currentCoordinate2d.longitude];

    CGFloat angle = camera.viewingAngle;
    self.angleTF.text = [self roundFloat:angle];
    CGFloat level = camera.zoom;
    self.levelTF.text = [self roundFloat:level];
}
////////////////////////////////////////////////////////////////////////
#pragma mark -
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
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][exampleView][mapView]|" options:kNilOptions metrics:nil views:@{@"exampleView": exampleView, @"topLayoutGuide": topLayoutGuide, @"mapView":self.mapView}]];
    
    [exampleView addSubview:self.longitudeTF];
    [exampleView addSubview:self.latitudeTF];
    [exampleView addSubview:self.goButton];
    [exampleView addSubview:self.angleTF];
    [exampleView addSubview:self.angleButton];
    [exampleView addSubview:self.levelButton];
    [exampleView addSubview:self.levelTF];
    
    self.longitudeTF.translatesAutoresizingMaskIntoConstraints = false;
    self.latitudeTF.translatesAutoresizingMaskIntoConstraints = false;
    self.goButton.translatesAutoresizingMaskIntoConstraints = false;
    self.angleTF.translatesAutoresizingMaskIntoConstraints = false;
    self.angleButton.translatesAutoresizingMaskIntoConstraints = false;
    self.levelTF.translatesAutoresizingMaskIntoConstraints = false;
    self.levelButton.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.goButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [NSLayoutConstraint constraintWithItem:self.longitudeTF attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:exampleView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:3.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.longitudeTF attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:exampleView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.latitudeTF attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.longitudeTF attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:5.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.latitudeTF attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.longitudeTF attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:5.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.latitudeTF attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.longitudeTF attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.latitudeTF attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.longitudeTF attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.goButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:exampleView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-3.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.goButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.longitudeTF attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0].active = YES;

    
    [NSLayoutConstraint constraintWithItem:self.latitudeTF attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.goButton attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-15.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.latitudeTF attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.longitudeTF attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.longitudeTF attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.angleTF attribute:NSLayoutAttributeTop multiplier:1.0 constant:-5.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.angleTF attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.levelTF attribute:NSLayoutAttributeTop multiplier:1.0 constant:-5.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.angleTF attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.longitudeTF attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.angleTF attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.angleButton attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-15.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.angleButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.angleTF attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.angleButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:exampleView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-5.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.angleTF attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.longitudeTF attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.angleTF attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.longitudeTF attribute:NSLayoutAttributeWidth multiplier:1.0 constant:20.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.levelTF attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:exampleView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.levelTF attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.longitudeTF attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.levelTF attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.levelButton attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-15.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.levelButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.levelTF attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.levelButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:exampleView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-5.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.levelTF attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.longitudeTF attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.levelTF attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.longitudeTF attribute:NSLayoutAttributeWidth multiplier:1.0 constant:20.0].active = YES;
    
    ERCameraPosition *camera = [self.mapView.camera copy];
    CLLocationCoordinate2D currentCoordinate2d = camera.target;
    
    self.latitudeTF.text =  [NSString stringWithFormat:@"%.6f",currentCoordinate2d.latitude];
    self.longitudeTF.text = [NSString stringWithFormat:@"%.6f",currentCoordinate2d.longitude];
    
    CGFloat angle = camera.viewingAngle;
    self.angleTF.text = [self roundFloat:angle];
    CGFloat level = camera.zoom;
    self.levelTF.text = [self roundFloat:level];
}

-(NSString *)roundFloat:(CGFloat)price{
    CGFloat sp=( (float)( (int)( (price+0.005)*100 ) ) )/100;
    return [NSString stringWithFormat:@"%.2f",sp];
}

@end
