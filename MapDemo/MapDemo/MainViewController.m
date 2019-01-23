//
//  MainViewController.m
//  MapDemo
//
//  Created by KongPeng on 2018/1/11.
//  Copyright © 2018年 erlinyou. All rights reserved.
//

#import "MainViewController.h"
#import <ERMapSDK/ERMapSDK.h>

#define MainViewControllerTitle @"boobuz Maps SDK Demos"

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *classNames;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MainViewController

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sections[section][0] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mainCellIdentifier = @"mainCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mainCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = _sections[indexPath.section][0][indexPath.row];
    cell.detailTextLabel.text = _sections[indexPath.section][1][indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = self.classNames[indexPath.section][indexPath.row];
    
    UIViewController *subViewController = [[NSClassFromString(className) alloc] init];
    NSString *xibBundlePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",className] ofType:@"xib"];
    if (xibBundlePath.length) {
        subViewController = [[NSClassFromString(className) alloc] initWithNibName:className bundle:nil];
    }
    
    subViewController.title = _sections[indexPath.section][0][indexPath.row];
    
    [self.navigationController pushViewController:subViewController animated:YES];
}

#pragma mark - Initialization

- (void)initTitles
{
    NSArray *sec1CellTitles = @[@"Basic Map",
                                @"Styled Map",
                                @"My location",
                                @"Visible Regions",
                                @"Gesture Controls",
                                @"Markers",
                                @"Indoor",
                                @"UI Controls",
                                @"Camera",
                                @"POI layer",
                                @"Camera Clamping",
                                @"Events",
                                @"Brand POI",
                                @"Polygon",
                                @"PolyLine"];
    NSArray *sec1CellDesc = @[@"Launches a map.",
                              @"Styled Map",
                              @"My location layer display.",
                              @"Demonstrates how to use Visible Regions.",
                              @"Demonstrates how to control map gestures.",
                              @"Demonstrates how to add Markers to a map.",
                              @"Demonstrates how to use the Indoor API.",
                              @"Demonstrates how to alter user interface controls.",
                              @"Demonstrates camera functions.",
                              @"boobuz POI layer display.",
                              @"Demonstrates how to constrain the camera to specific zoom levels.",
                              @"Demonstrates event handling.",
                              @"Brand POI in high zoom level display.",
                              @"Draw Polygon.",
                              @"Draw PolyLine."];
    NSArray *section1 = @[sec1CellTitles,sec1CellDesc];
    self.sections = [NSArray arrayWithObjects:section1, nil];
    
    NSArray *sec1ClassNames = @[@"BaseMapViewController",
                                @"StyledMapViewController",
                                @"UserLocationViewController",
                                @"PaddingMapViewController",
                                @"OperateMapViewController",
                                @"AnnotationViewController",
                                @"IndoorMapViewController",
                                @"AddControlsViewController",
                                @"InitializeCameraPositionViewController",
                                @"PoiDisplayViewController",
                                @"MapZoomLevelViewController",
                                @"MapCameraInfoViewController",
                                @"BrandPoiViewController",
                                @"PolygonsViewController",
                                @"PolylinesViewController"];
    self.classNames = [NSArray arrayWithObjects:sec1ClassNames, nil];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}


#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init])
    {
        self.title = MainViewControllerTitle;
        
        [self initTitles];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden       = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbarHidden             = YES;
}

@end
