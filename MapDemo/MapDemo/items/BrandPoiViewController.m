//
//  BrandPoiViewController.m
//  MapDemo
//
//  Created by KongPeng on 2018/7/19.
//  Copyright © 2018年 erlinyou. All rights reserved.
//

#import "BrandPoiViewController.h"
#import <ERMapSDK/ERMapSDK.h>
@interface BrandPoiViewController ()
@property (strong, nonatomic) ERMapView *mapView;
@end

@implementation BrandPoiViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView registerSelf];
    ERCameraPosition *camera = [ERCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(48.86100425838727,2.336038016831693) zoom:15 viewingAngle:0];
    self.mapView.camera = camera;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView removeSelf];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMapView];
    self.mapView.mapBrandPoiDisplay = YES;
    [self createUI];
}

- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[ERMapView alloc] initWithFrame:self.view.bounds];
        self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
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
    
    UIView *myLocationControl = [self createSingleViewWithTag:0 text:@"mapBrandPoiDisplay"];
    [controlView addSubview:myLocationControl];
    NSLayoutConstraint *myLocationTop = [NSLayoutConstraint constraintWithItem:myLocationControl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:controlView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *myLocationleft = [NSLayoutConstraint constraintWithItem:myLocationControl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:controlView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *myLocationHeight = [NSLayoutConstraint constraintWithItem:myLocationControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44.0];
    
    NSLayoutConstraint *myLocationRight = [NSLayoutConstraint constraintWithItem:myLocationControl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:controlView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *myLocationBottom = [NSLayoutConstraint constraintWithItem:myLocationControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:controlView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [NSLayoutConstraint activateConstraints:@[myLocationTop,myLocationleft,myLocationHeight,myLocationRight,myLocationBottom]];
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
    sw.on = self.mapView.mapBrandPoiDisplay;
    sw.translatesAutoresizingMaskIntoConstraints = NO;
    [sw addTarget:self action:@selector(clickSW:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:sw];
    NSLayoutConstraint *HconstraintsSW = [NSLayoutConstraint constraintWithItem:sw attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    HconstraintsSW.active = YES;
    
    NSLayoutConstraint *VconstraintsSW = [NSLayoutConstraint constraintWithItem:sw attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-8];
    VconstraintsSW.active = YES;
    return view;
}

- (void)clickSW:(UISwitch *)sw
{
    self.mapView.mapBrandPoiDisplay = sw.on;
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
