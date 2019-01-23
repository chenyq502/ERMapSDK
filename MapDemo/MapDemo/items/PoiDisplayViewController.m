//
//  LocationLayerViewController.m
//  MapDemo
//
//  Created by KongPeng on 2018/4/4.
//  Copyright © 2018年 erlinyou. All rights reserved.
//

#import "PoiDisplayViewController.h"
#import <ERMapSDK/ERMapSDK.h>
#import "AddControl.h"

@interface PoiDisplayViewController ()<ERMapViewDelegate>
@property (strong, nonatomic) ERMapView *mapView;
@property (nonatomic, strong) NSMutableArray<AddControl *> *controlArray;
@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *constraints;
@end

@implementation PoiDisplayViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView registerSelf];
    
    ERCameraPosition *camera = [ERCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(48.86100425838727, 2.336038016831693) zoom:17];
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
    [self setupUI];
}

- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[ERMapView alloc] initWithFrame:self.view.bounds];
        self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
        self.mapView.mapViewDelegate = self;
        [self.view addSubview:self.mapView];
    }
}

- (void)setupUI {
    id topLayoutGuide = self.topLayoutGuide;
    
    UIView *exampleView = [UIView new];
    [self.view addSubview:exampleView];
    exampleView.translatesAutoresizingMaskIntoConstraints = false;
    exampleView.backgroundColor = [UIColor whiteColor];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mapView]-0-|" options:kNilOptions metrics:nil views:@{@"mapView":self.mapView}]];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[exampleView]|" options:kNilOptions metrics:nil views:@{@"exampleView": exampleView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][exampleView][mapView]|" options:kNilOptions metrics:nil views:@{@"exampleView": exampleView, @"topLayoutGuide": topLayoutGuide, @"mapView":self.mapView}]];
    
    NSArray *controls = @[@"Poi display", @"PoiPicdisplay"];
    for (NSInteger i = 0; i < controls.count; i++) {
        NSString *title = controls[i];
        __weak typeof(self) weakSelf = self;
        BOOL isOn;
        if (i == 0) {
            isOn = self.mapView.mapPoiDisplay;
        }else{
            isOn = self.mapView.mapPoiPictureDisplay;
        }
        AddControl *control = [[AddControl alloc] initWithTitle:title isOn:isOn swValueChange:^(AddControl *control) {
            if ([control.accessibilityIdentifier isEqualToString:@"Poi display"]) {
                weakSelf.mapView.mapPoiDisplay = control.sw.isOn;
            }
            else if ([control.accessibilityIdentifier isEqualToString:@"PoiPicdisplay"]) {
                weakSelf.mapView.mapPoiPictureDisplay = control.sw.isOn;
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

- (void)clickRightBtn:(UIBarButtonItem *)barItem
{
    if (self.mapView.mapPoiDisplay) {
        self.mapView.mapPoiDisplay = NO;
        barItem.title = @"ShowPoi";
    }else{
        self.mapView.mapPoiDisplay = YES;
        barItem.title = @"HidePoi";
    }
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
        NSString *controlKey = [NSString stringWithFormat:@"%@_%ld", NSStringFromClass(control.class).lowercaseString, (long)i];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

