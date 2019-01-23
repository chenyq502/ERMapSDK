//
//  DisplayTextMapViewController.m
//  MapDemo
//
//  Created by xiaoyuan on 2018/6/8.
//  Copyright © 2018 erlinyou. All rights reserved.
//

#import "MapCameraInfoViewController.h"
#import <ERMapBaseSDK/ERCoordinateBounds.h>

@interface MapCameraInfoViewController ()<ERMapViewDelegate>

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation MapCameraInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.textLabel];
    [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0].active = YES;
    id topLayoutGuide = self.topLayoutGuide;
    [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:175.0].active = YES;
    self.mapView.mapViewDelegate = self;
    self.mapView.rotateGesturesEnabled = YES;
    [self updateTextLabelText];
}

- (void)updateTextLabelText
{
    ERCoordinateBounds * mapRange = [self.mapView GetMapDisplayRange];
    CLLocationCoordinate2D coordinate2D = self.mapView.camera.target;
    CLLocationDirection angle = self.mapView.camera.viewingAngle;
    CGFloat level = self.mapView.camera.zoom;
    self.textLabel.text = [NSString stringWithFormat:@"MapDisplayRange:\n    BottomLeft:lat = %f,long= %f\n    TopRight:lat = %f,long= %f\ncameraPosition:\n    latitude:%f\n    longitude:%f\nmapAngle:%f\nmapLevel:%f",mapRange.southWest.latitude,mapRange.southWest.longitude,mapRange.northEast.latitude,mapRange.northEast.longitude,coordinate2D.latitude,coordinate2D.longitude,angle,level];
}

- (void)mapView:(ERMapView *)mapView didChangeCameraPosition:(ERCameraPosition *)cameraPosition
{
    [self updateTextLabelText];
}

- (void)mapView:(ERMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"didTapAtCoordinate:latitude = %.15f  longitude = %.15f",coordinate.latitude,coordinate.longitude);
}

- (void)mapView:(ERMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"didLongPressAtCoordinate:latitude = %.15f  longitude = %.15f",coordinate.latitude,coordinate.longitude);
}

- (void)mapView:(ERMapView *)mapView handleZoom:(UIGestureRecognizerState)state
{
    NSLog(@"%s",__func__);
}

- (void)mapView:(ERMapView *)mapView handleScroll:(UIGestureRecognizerState)state
{
     NSLog(@"%s",__func__);
}

- (void)mapView:(ERMapView *)mapView handleRotate:(UIGestureRecognizerState)state
{
     NSLog(@"%s",__func__);
}

- (void)mapView:(ERMapView *)mapView handleDoubleClick:(UIGestureRecognizerState)state
{
     NSLog(@"%s",__func__);
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

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.translatesAutoresizingMaskIntoConstraints = false;
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}
@end
