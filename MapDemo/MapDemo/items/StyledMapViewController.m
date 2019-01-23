//
//  StyledMapViewController.m
//  MapDemo
//
//  Created by KongPeng on 2018/11/12.
//  Copyright © 2018 erlinyou. All rights reserved.
//

#import "StyledMapViewController.h"
#import <ERMapSDK/ERMapSDK.h>

static NSString *const kNormalType = @"Normal";
static NSString *const kRetroType = @"Retro";
static NSString *const kGrayscaleType = @"Grayscale";
static NSString *const kNightType = @"Night";

@interface StyledMapViewController ()<ERMapViewDelegate>
@property (strong, nonatomic) ERMapView *mapView;

@end

@implementation StyledMapViewController{
    ERMapStyle *_retroStyle;
    ERMapStyle *_grayscaleStyle;
    ERMapStyle *_nightStyle;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView registerSelf];
    ERCameraPosition *camera = [ERCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(48.861000,2.33603) zoom:10];
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
    [self navigationRightButton];
    
    NSString *retroPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"whitegrey_retro.txt"];
    _retroStyle = [[ERMapStyle alloc] initWithStyleContentsOfColorScriptFileURL:[NSURL URLWithString:retroPath] adnScriptFileURL:nil];
    NSString *grayscalePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"whitegrey_grayscale.txt"];
    NSString *grayscaleAdnPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Admindisplay.xml"];
    _grayscaleStyle = [[ERMapStyle alloc] initWithStyleContentsOfColorScriptFileURL:[NSURL URLWithString:grayscalePath] adnScriptFileURL:[NSURL URLWithString:grayscaleAdnPath]];
    NSString *nightPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"whitegrey_night.txt"];
    NSString *nightAdnPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Admindisplay_night.xml"];
    _nightStyle = [[ERMapStyle alloc] initWithStyleContentsOfColorScriptFileURL:[NSURL URLWithString:nightPath] adnScriptFileURL:[NSURL URLWithString:nightAdnPath]];
    _mapView.mapStyle = _retroStyle;
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

- (void)navigationRightButton
{
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"Style" style:UIBarButtonItemStylePlain target:self action:@selector(clickEvent)];
    
    self.navigationItem.rightBarButtonItem = myButton;
    self.navigationItem.title = kRetroType;
}

- (void)clickEvent
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select map style" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    void (^ ActionHandler)(UIAlertAction *action) = ^(UIAlertAction *action){
        if ([action.title isEqualToString:kRetroType]) {
            self.mapView.mapStyle = _retroStyle;
            self.navigationItem.title = kRetroType;
        }else if ([action.title isEqualToString:kGrayscaleType]){
            self.mapView.mapStyle = _grayscaleStyle;
            self.navigationItem.title = kGrayscaleType;
        }else if ([action.title isEqualToString:kNightType]){
            self.mapView.mapStyle = _nightStyle;
            self.navigationItem.title = kNightType;
        }else {
            self.mapView.mapStyle = nil;
            self.navigationItem.title = kNormalType;
        }
    };
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:kRetroType style:UIAlertActionStyleDefault handler:ActionHandler];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:kGrayscaleType style:UIAlertActionStyleDefault handler:ActionHandler];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:kNightType style:UIAlertActionStyleDefault handler:ActionHandler];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:kNormalType style:UIAlertActionStyleDefault handler:ActionHandler];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [alert addAction:actionCancel];
    [self presentViewController:alert animated:YES completion:nil];
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
