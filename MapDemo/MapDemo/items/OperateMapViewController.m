//
//  OperateMapViewController.m
//  MapDemo
//
//  Created by KongPeng on 2018/4/4.
//  Copyright © 2018年 erlinyou. All rights reserved.
//

#import "OperateMapViewController.h"
#import <ERMapSDK/ERMapSDK.h>
@interface OperateMapViewController ()<ERMapViewDelegate>
@property (strong, nonatomic) ERMapView *mapView;
@end

@implementation OperateMapViewController

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
    [self initMapView];
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
    
    UIView *scrollView = [self createSingleViewWithTag:0 text:@"Drag"];
    [controlView addSubview:scrollView];
    NSLayoutConstraint *scrTop = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:controlView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *scrleft = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:controlView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *scrHeight = [NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44.0];
    [NSLayoutConstraint activateConstraints:@[scrTop,scrleft,scrHeight]];
    
    UIView *zoomView = [self createSingleViewWithTag:1 text:@"Zoom"];
    [controlView addSubview:zoomView];
    NSLayoutConstraint *zoomTop = [NSLayoutConstraint constraintWithItem:zoomView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *zoomleft = [NSLayoutConstraint constraintWithItem:zoomView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *zoomHeight = [NSLayoutConstraint constraintWithItem:zoomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44.0];
    NSLayoutConstraint *zoomWidth = [NSLayoutConstraint constraintWithItem:zoomView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    [NSLayoutConstraint activateConstraints:@[zoomTop,zoomleft,zoomWidth,zoomHeight]];
    
    UIView *rotateView = [self createSingleViewWithTag:2 text:@"Rotate"];
    [controlView addSubview:rotateView];
    NSLayoutConstraint *rotateTop = [NSLayoutConstraint constraintWithItem:rotateView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:zoomView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *rotateleft = [NSLayoutConstraint constraintWithItem:rotateView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:zoomView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
     NSLayoutConstraint *rotateWidth = [NSLayoutConstraint constraintWithItem:rotateView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    NSLayoutConstraint *rotateHeight = [NSLayoutConstraint constraintWithItem:rotateView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44.0];
    [NSLayoutConstraint activateConstraints:@[rotateTop,rotateleft,rotateHeight,rotateWidth]];
    
    
    UIView *tiltView = [self createSingleViewWithTag:3 text:@"Tilt"];
    [controlView addSubview:tiltView];
    NSLayoutConstraint *tiltTop = [NSLayoutConstraint constraintWithItem:tiltView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:rotateView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *tiltleft = [NSLayoutConstraint constraintWithItem:tiltView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:rotateView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *tiltWidth = [NSLayoutConstraint constraintWithItem:tiltView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    NSLayoutConstraint *tiltRight = [NSLayoutConstraint constraintWithItem:tiltView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:controlView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *tiltHeight = [NSLayoutConstraint constraintWithItem:tiltView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44.0];
    NSLayoutConstraint *tiltBottom = [NSLayoutConstraint constraintWithItem:tiltView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:controlView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [NSLayoutConstraint activateConstraints:@[tiltTop,tiltleft,tiltWidth,tiltRight,tiltHeight,tiltBottom]];
    
}

- (UIView *)createSingleViewWithTag:(NSInteger )tag text:(NSString *)text;
{
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    NSString *Hvfl = @"H:|-3-[label]|";
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
    
    NSLayoutConstraint *VconstraintsSW = [NSLayoutConstraint constraintWithItem:sw attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    VconstraintsSW.active = YES;
    switch (tag) {
        case 0:
            sw.on = self.mapView.scrollGesturesEnabled;
            break;
        case 1:
            sw.on = self.mapView.zoomGesturesEnabled;
            break;
        case 2:
            sw.on = self.mapView.rotateGesturesEnabled;
            break;
        case 3:
            sw.on = self.mapView.map3DGesturesEnabled;
            break;
        default:
            break;
    }
    
    return view;
}

- (void)clickSW:(UISwitch*)sw
{
    switch (sw.tag) {
        case 0:
            self.mapView.scrollGesturesEnabled = sw.isOn;
            break;
        case 1:
            self.mapView.zoomGesturesEnabled = sw.isOn;
            break;
        case 2:
            self.mapView.rotateGesturesEnabled = sw.isOn;
            break;
        case 3:
            self.mapView.map3DGesturesEnabled = sw.isOn;
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
