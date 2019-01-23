//
//  MapZoomLevelViewController.m
//  MapDemo
//
//  Created by xiaoyuan on 2018/6/8.
//  Copyright © 2018 erlinyou. All rights reserved.
//

#import "MapZoomLevelViewController.h"
#import <ERMapSDK/ERMapSDK.h>
#import "SliderView.h"

@interface MapZoomLevelViewController () <ERMapViewDelegate>

@property (strong, nonatomic) ERMapView *mapView;
@property (strong, nonatomic) SliderView *maxSlider;
@property (strong, nonatomic) SliderView *minSlider;

@end

@implementation MapZoomLevelViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView registerSelf];
    self.mapView.camera = [ERCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(48.857792,2.341279) zoom:19];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.mapView.maxZoom = 27;
    self.mapView.minZoom = 1;
    [self.mapView removeSelf];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][exampleView][mapView]|" options:kNilOptions metrics:nil views:@{@"exampleView": exampleView, @"topLayoutGuide": topLayoutGuide, @"mapView":self.mapView}]];
    
    [exampleView addSubview:self.maxSlider];
    [exampleView addSubview:self.minSlider];
    UIButton *maxButton = [UIButton new];
    [maxButton setTitle:@"max zoom level" forState:UIControlStateNormal];
    [maxButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    maxButton.translatesAutoresizingMaskIntoConstraints = NO;
    [maxButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [maxButton.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
    [exampleView addSubview:maxButton];
    UIButton *minButton = [UIButton new];
    [minButton setTitle:@"min zoom level" forState:UIControlStateNormal];
    [exampleView addSubview:minButton];
    [minButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [minButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    minButton.translatesAutoresizingMaskIntoConstraints = NO;
    [minButton.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
    
    NSDictionary *viewsDict = @{@"maxSlider": self.maxSlider, @"maxButton": maxButton, @"minButton": minButton, @"minSlider": self.minSlider  };
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[maxSlider(==80.0)][maxButton]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDict]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[minSlider(==80.0)][minButton]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDict]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[maxSlider][minSlider]|" options:kNilOptions metrics:nil views:viewsDict]];
    [NSLayoutConstraint constraintWithItem:self.maxSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.minSlider attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0].active = YES;
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

-(SliderView *)minSlider {
    if (!_minSlider) {
        _minSlider = [self createSlider];
        _minSlider.minimumValue = 1;
        _minSlider.maximumValue = 26;
        _minSlider.value = self.mapView.minZoom;
        __weak typeof(self.maxSlider) weakMaxSlider = self.maxSlider;
        __weak typeof(self) weakSelf = self;
        _minSlider.valueChangeBlock = ^(SliderView *slider) {
            if (slider.value > weakMaxSlider.value) {
                weakMaxSlider.value = 27;
            }
            weakSelf.mapView.minZoom = slider.value;
        };
    }
    return _minSlider;
}

-(SliderView *)maxSlider {
    if (!_maxSlider) {
        _maxSlider = [self createSlider];
        _maxSlider.minimumValue = 2;
        _maxSlider.maximumValue = 27;
        _maxSlider.value = self.mapView.maxZoom;
        __weak typeof(self.minSlider) weakMinSlider = self.minSlider;
         __weak typeof(self) weakSelf = self;
        _maxSlider.valueChangeBlock = ^(SliderView *slider) {
            if (slider.value < weakMinSlider.value) {
                weakMinSlider.value = 1;
            }
            weakSelf.mapView.maxZoom = slider.value;
        };
    }
    return _maxSlider;
}

- (SliderView *)createSlider {
    SliderView *slider = [[SliderView alloc] init];
    slider.translatesAutoresizingMaskIntoConstraints = NO;
    slider.layer.cornerRadius = 3.0;
    slider.layer.masksToBounds = YES;
    [slider setMaximumValueColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [slider setMinimumValueColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [slider setMinimumValueColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [slider setMaximumValueColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    return slider;
}

@end
