//
//  IndoorMapViewController.m
//  MapDemo
//
//  Created by KongPeng on 2018/4/4.
//  Copyright © 2018年 erlinyou. All rights reserved.
//

#import "IndoorMapViewController.h"
#import <ERMapSDK/ERMapSDK.h>
@interface IndoorMapViewController ()<ERMapViewDelegate>
@property (strong, nonatomic) ERMapView *mapView;
@end

@implementation IndoorMapViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView registerSelf];
    ERCameraPosition *camera = [ERCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(48.86100425838727, 2.336038016831693) zoom:17 viewingAngle:0];
    [self.mapView setCamera:camera animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView removeSelf];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMapView];
    self.mapView.indoorFunEnabled = YES;
    [self createUI];
}

- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[ERMapView alloc] initWithFrame:self.view.bounds];
        self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
        self.mapView.mapViewDelegate = self;
        [self.view addSubview:self.mapView];
        NSString *Hvfl = @"H:|-0-[mapView]-0-|";
        NSString *Vvfl = @"V:|-44-[mapView]-0-|";
        NSDictionary *viewKeys = @{@"mapView":self.mapView};
        NSArray *Hconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Hvfl options:kNilOptions metrics:nil views:viewKeys];
        NSArray *Vconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Vvfl options:kNilOptions metrics:nil views:viewKeys];
        [self.view addConstraints:Hconstraints];
        [self.view addConstraints:Vconstraints];
    }
}


- (void)createUI
{
    UIView *controlView = [[UIView alloc] init];
    controlView.translatesAutoresizingMaskIntoConstraints = NO;
    controlView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:controlView];
    
    NSLayoutConstraint *controlTop = [NSLayoutConstraint constraintWithItem:controlView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view  attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *controlLeft = [NSLayoutConstraint constraintWithItem:controlView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view  attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *controlRight = [NSLayoutConstraint constraintWithItem:controlView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view  attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    [NSLayoutConstraint activateConstraints:@[controlTop,controlLeft,controlRight]];
    
    UIView *indoorUIControl = [self createSingleViewWithTag:0 text:@"FloorControl"];
    [controlView addSubview:indoorUIControl];
    NSLayoutConstraint *indoorUITop = [NSLayoutConstraint constraintWithItem:indoorUIControl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:controlView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *indoorUIleft = [NSLayoutConstraint constraintWithItem:indoorUIControl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:controlView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *indoorUIHeight = [NSLayoutConstraint constraintWithItem:indoorUIControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44.0];
    [NSLayoutConstraint activateConstraints:@[indoorUITop,indoorUIleft,indoorUIHeight]];
    
    UIView *indoorFunControl = [self createSingleViewWithTag:1 text:@"IndoorMap"];
    [controlView addSubview:indoorFunControl];
    NSLayoutConstraint *indoorFunTop = [NSLayoutConstraint constraintWithItem:indoorFunControl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:indoorUIControl attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *indoorFunleft = [NSLayoutConstraint constraintWithItem:indoorFunControl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:indoorUIControl attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *indoorFunRight = [NSLayoutConstraint constraintWithItem:indoorFunControl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:controlView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *indoorFunBottom = [NSLayoutConstraint constraintWithItem:indoorFunControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:controlView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    NSLayoutConstraint *indoorFunHeight = [NSLayoutConstraint constraintWithItem:indoorFunControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44.0];
    NSLayoutConstraint *indoorFunWidth = [NSLayoutConstraint constraintWithItem:indoorFunControl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:indoorUIControl attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    [NSLayoutConstraint activateConstraints:@[indoorFunTop,indoorFunleft,indoorFunRight,indoorFunBottom,indoorFunHeight,indoorFunWidth]];
}

- (UIView *)createSingleViewWithTag:(NSInteger )tag text:(NSString *)text;
{
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    [view addSubview:label];
    
    NSString *Hvfl = @"H:|-10-[label]|";
    NSString *Vvfl = @"V:|-0-[label]-0-|";
    NSDictionary *viewKeys = @{@"label":label};
    NSArray *Hconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Hvfl options:kNilOptions metrics:nil views:viewKeys];
    NSArray *Vconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Vvfl options:kNilOptions metrics:nil views:viewKeys];
    [view addConstraints:Hconstraints];
    [view addConstraints:Vconstraints];
    
    UISwitch *sw = [[UISwitch alloc] init];
    sw.tag = tag;
    sw.translatesAutoresizingMaskIntoConstraints = NO;
    [sw addTarget:self action:@selector(clickSW:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:sw];
    NSLayoutConstraint *HconstraintsSW = [NSLayoutConstraint constraintWithItem:sw attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    HconstraintsSW.active = YES;
    
    NSLayoutConstraint *VconstraintsSW = [NSLayoutConstraint constraintWithItem:sw attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-8];
    VconstraintsSW.active = YES;
    switch (tag) {
        case 0:
            sw.on = self.mapView.indoorUIEnabled;
            break;
        case 1:
            sw.on = self.mapView.indoorFunEnabled;
            break;
            
        default:
            break;
    }
    
    return view;
}

- (void)clickSW:(UISwitch *)sw
{
    switch (sw.tag) {
        case 0:
            self.mapView.indoorUIEnabled = sw.isOn;
            break;
        case 1:
            self.mapView.indoorFunEnabled = sw.isOn;
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
