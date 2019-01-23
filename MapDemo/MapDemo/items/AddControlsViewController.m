//
//  AddControlsViewController.m
//  MapDemo
//
//  Created by xiaoyuan on 2018/4/4.
//  Copyright © 2018年 erlinyou. All rights reserved.
//

#import "AddControlsViewController.h"
#import <ERMapSDK/ERMapSDK.h>
#import "AddControl.h"

@interface AddControlsViewController () <ERMapViewDelegate>
@property (strong, nonatomic) ERMapView *mapView;
@property (nonatomic, strong) NSMutableArray<AddControl *> *controlArray;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *constraints;
@end

@implementation AddControlsViewController

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
    // Do any additional setup after loading the view.
    [self setupUI];
}

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
    
    NSArray *controls = @[@"Map center", @"Compass"];
    for (NSInteger i = 0; i < controls.count; i++) {
        NSString *title = controls[i];
        __weak typeof(self) weakSelf = self;
        AddControl *control = [[AddControl alloc] initWithTitle:title isOn:YES swValueChange:^(AddControl *control) {
            if ([control.accessibilityIdentifier isEqualToString:@"Map center"]) {
                [weakSelf.mapView setMapRecenterDisplay:control.sw.isOn];
            }
            else if ([control.accessibilityIdentifier isEqualToString:@"Compass"]) {
                [weakSelf.mapView setMapCompassDisplay:control.sw.isOn];
            }
        }];
        control.translatesAutoresizingMaskIntoConstraints = false;
        control.tag = i;
        control.accessibilityIdentifier = title;
        [self.controlArray addObject:control];
        [exampleView addSubview:control];
        
    }
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    
    [NSLayoutConstraint deactivateConstraints:self.constraints];
    [self.constraints removeAllObjects];
    NSMutableString *hFormat = @"".mutableCopy;
    NSMutableDictionary *subviewsDict = @{}.mutableCopy;
    NSDictionary *metrics = @{@"padding": @20.0};
    UIView *dependentView = nil;
    for (NSInteger i = 0; i < self.controlArray.count; i++) {
        AddControl *control = self.controlArray[i];
        NSString *controlKey = [NSString stringWithFormat:@"%@_%ld", NSStringFromClass(control.class).lowercaseString, i];
        [subviewsDict setObject:control forKey:controlKey];
        [hFormat appendFormat:@"-(padding)-[%@]", controlKey];
        if (i == self.controlArray.count - 1) {
            [hFormat appendFormat:@"-(padding)-"];
        }
        
        NSString *vFormat = [NSString stringWithFormat:@"V:|-(5.0)-[%@]-(5.0)-|", controlKey];
        [self.constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vFormat options:kNilOptions metrics:metrics views:subviewsDict]];
        if (dependentView) {
            [self.constraints addObject:[NSLayoutConstraint constraintWithItem:control attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:dependentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        }

        dependentView = control;
    }
    
    
    if (hFormat.length) {
        [self.constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|%@|",hFormat] options:kNilOptions metrics:metrics views:subviewsDict]];
    }
    
    [NSLayoutConstraint activateConstraints:self.constraints];
    
    [super updateViewConstraints];
}


////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////

- (NSMutableArray<AddControl *> *)controlArray {
    if (!_controlArray) {
        _controlArray = @[].mutableCopy;
    }
    return _controlArray;
}

- (NSMutableArray *)constraints {
    if (!_constraints) {
        _constraints = @[].mutableCopy;
    }
    return _constraints;
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
