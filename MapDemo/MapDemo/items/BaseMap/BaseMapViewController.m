//
//  BaseMapViewController.m
//  MapDemo
//
//  Created by KongPeng on 2018/1/11.
//  Copyright © 2018年 erlinyou. All rights reserved.
//

#import "BaseMapViewController.h"
@interface BaseMapViewController ()<ERMapViewDelegate>

@end

@implementation BaseMapViewController

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
        NSString *Vvfl = @"V:|-0-[mapView]-0-|";
        NSDictionary *viewKeys = @{@"mapView":self.mapView};
        NSArray *Hconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Hvfl options:kNilOptions metrics:nil views:viewKeys];
        NSArray *Vconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Vvfl options:kNilOptions metrics:nil views:viewKeys];
        [self.view addConstraints:Hconstraints];
        [self.view addConstraints:Vconstraints];
    }
}


@end
