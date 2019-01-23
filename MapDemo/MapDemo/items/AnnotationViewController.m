//
//  AnnotationViewController.m
//  MapDemo
//
//  Created by KongPeng on 2018/4/4.
//  Copyright © 2018年 erlinyou. All rights reserved.
//

#import "AnnotationViewController.h"
#import "MBProgressHUD.h"
@interface AnnotationViewController ()

@end

@implementation AnnotationViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addElements];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView registerSelf];
    ERCameraPosition *camera = [ERCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(48.8635007971,2.3103475571) zoom:11 viewingAngle:0];
    self.mapView.camera = camera;
    self.navigationController.toolbar.translucent   = NO;
    self.navigationController.toolbarHidden         = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self clearElements];
    [self.mapView removeSelf];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initToolBar];
    // Do any additional setup after loading the view.
}

- (void)initToolBar
{
    UIBarButtonItem *flexble = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *reGeocodeItem = [[UIBarButtonItem alloc] initWithTitle:@"Add markers"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(addElements)];
    
    UIBarButtonItem *locItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear markers"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(clearElements)];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexble, reGeocodeItem, flexble, locItem, flexble, nil];
}

- (void)clearElements{
    [self.mapView ClearMapOverlayElements];
}

- (void)addElements{
    [self.mapView FillMapOverlayElements:[self FillMapOverlayElements]];
    ERCameraPosition *camera = [ERCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(48.8635007971,2.3103475571) zoom:11 viewingAngle:0];
    [self.mapView setCamera:camera animated:YES];
}

- (NSArray *)FillMapOverlayElements
{
    NSArray *locationArr = @[@(CGPointMake(48.8583905296, 2.2944688797)),
                     @(CGPointMake(48.8738044456, 2.2950267792)),
                     @(CGPointMake(48.8606492757, 2.3375988007)),
                     @(CGPointMake(48.8529691231, 2.3498725891))];
    NSArray *imageArr = @[@"icon_marka",
                          @"icon_markb",
                          @"icon_markc",
                          @"icon_markd"];
    NSMutableArray *mArr = @[].mutableCopy;
    for (int i = 0; i < locationArr.count; i++) {
        CLLocationCoordinate2D mapCenter = self.mapView.camera.target;
        ERMapEle *mapEle = [[ERMapEle alloc] init];
        mapEle.nID =  90+i;
        CGPoint p = [locationArr[i] CGPointValue];
        mapCenter.latitude = p.x;
        mapCenter.longitude = p.y;
        mapEle.coordinate = mapCenter;
        UIImage *image = [UIImage imageNamed:imageArr[i]];
        mapEle.icon = image;
        [mArr addObject:mapEle];
    }
    
    return mArr;
}

#pragma mark  -------------mapViewDelegate --------------
- (void)mapView:(ERMapView *)mapView handleClickWithPoiResults:(ERSelectEle *)selectEle
{
    MBProgressHUD *view = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    view.mode = MBProgressHUDModeText;
    view.label.text = @(selectEle.nID).stringValue;
    [view hideAnimated:YES afterDelay:1.0f];
}

- (void)mapView:(ERMapView *)mapView didChangeCameraPosition:(ERCameraPosition *)cameraPosition {
    
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
