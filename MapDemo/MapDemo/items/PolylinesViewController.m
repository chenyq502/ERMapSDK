//
//  PolylinesViewController.m
//  MapDemo
//
//  Created by KongPeng on 2018/12/29.
//  Copyright © 2018 erlinyou. All rights reserved.
//

#import "PolylinesViewController.h"
#import <ERMapSDK/ERMapSDK.h>

@interface PolylinesViewController ()
@property (strong, nonatomic) ERMapView *mapView;
@property (strong, nonatomic) NSArray *polys;
@end

@implementation PolylinesViewController{
    double _pos, _step;
}

static CLLocationCoordinate2D kSydneyAustralia = {-33.866901, 151.195988};
static CLLocationCoordinate2D kHawaiiUSA = {21.291982, -157.821856};
static CLLocationCoordinate2D kFiji = {-18, 179};
static CLLocationCoordinate2D kMountainViewUSA = {37.423802, -122.091859};
static CLLocationCoordinate2D kLimaPeru = {-12, -77};

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView registerSelf];
    ERCameraPosition *camera = [ERCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(27.8717,-60.217) zoom:1 viewingAngle:0];
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
    [self initLines];
}

- (void)initLines {
    if (!_polys) {
        NSMutableArray *polys = [NSMutableArray array];
        ERMutablePath *path = [ERMutablePath path];
        [path addCoordinate:kSydneyAustralia];
        [path addCoordinate:kFiji];
        [path addCoordinate:kHawaiiUSA];
        [path addCoordinate:kMountainViewUSA];
        [path addCoordinate:kLimaPeru];
        [path addCoordinate:kSydneyAustralia];
        for (int i = 0; i < 15; ++i) {
            ERPolyline *poly = [[ERPolyline alloc] init];
            poly.path = [path pathOffsetByLatitude:(i * 3) longitude:0];
            poly.strokeWidth = 8;
            poly.strokeColor = (i%2 == 0)?[UIColor yellowColor]:[UIColor redColor];
            poly.map = _mapView;
            [polys addObject:poly];
        }
        _polys = polys;
    }
}

- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[ERMapView alloc] initWithFrame:self.view.bounds];
        self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.mapView];
        NSString *Hvfl = @"H:|-0-[mapView]-0-|";
        NSString *Vvfl = @"V:|-0-[mapView]-0-|";
        NSDictionary *viewKeys = @{@"mapView":self.mapView};
        NSArray *Hconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Hvfl options:kNilOptions metrics:nil views:viewKeys];
        NSArray *Vconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Vvfl options:kNilOptions metrics:nil views:viewKeys];
        [self.view addConstraints:Hconstraints];
        [self.view addConstraints:Vconstraints];
    }
}
@end
