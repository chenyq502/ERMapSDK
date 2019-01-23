//
//  SearchViewController.m
//  MapDemo
//
//  Created by KongPeng on 2018/11/26.
//  Copyright © 2018 erlinyou. All rights reserved.
//

#import "SearchViewController.h"
#import <ERMapSDK/ERMapSDK.h>
#import <ERMapPlacesSDK/ERMapPlacesSDK.h>

static NSString *const kYellowAndBrownType = @"YellowAndBrown";
static NSString *const kWhiteOnBlackType = @"WhiteOnBlack";
static NSString *const kBlueColorsType = @"BlueColors";
static NSString *const kHotDogStandType = @"HotDogStand";

@interface SearchViewController ()<ERMapViewDelegate,ERAutocompleteViewControllerDelegate>
@property (strong, nonatomic) ERMapView *mapView;
@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView registerSelf];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView setGpsCenterAsMapCenter];
    [self.mapView removeSelf];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMapView];
    [self navigationRightButton];
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
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"search" style:UIBarButtonItemStylePlain target:self action:@selector(clickEvent)];
    
    self.navigationItem.rightBarButtonItem = myButton;
}

- (void)clickEvent
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select map style" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    void (^ ActionHandler)(UIAlertAction *action) = ^(UIAlertAction *action){
        if ([action.title isEqualToString:kYellowAndBrownType]) {
            [self openBrownTheme];
        }else if ([action.title isEqualToString:kWhiteOnBlackType]){
            [self openBlackTheme];
        }else if ([action.title isEqualToString:kBlueColorsType]){
            [self openBlueTheme];
        }else if ([action.title isEqualToString:kHotDogStandType]){
            [self openHotDogTheme];
        }else {
            [self openNormalTheme];
        }
    };
    
//    static NSString *const kYellowAndBrownType = @"YellowAndBrown";
//    static NSString *const kWhiteOnBlackType = @"WhiteOnBlack";
//    static NSString *const kBlueColorsType = @"BlueColors";
//    static NSString *const kHotDogStandType = @"HotDogStand";
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:kYellowAndBrownType style:UIAlertActionStyleDefault handler:ActionHandler];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:kWhiteOnBlackType style:UIAlertActionStyleDefault handler:ActionHandler];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:kBlueColorsType style:UIAlertActionStyleDefault handler:ActionHandler];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:kHotDogStandType style:UIAlertActionStyleDefault handler:ActionHandler];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"Default" style:UIAlertActionStyleDefault handler:ActionHandler];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [alert addAction:action5];
    [alert addAction:actionCancel];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)openBrownTheme{
    UIColor *backgroundColor =
    [UIColor colorWithRed:215.0f / 255.0f green:204.0f / 255.0f blue:200.0f / 255.0f alpha:1.0f];
    UIColor *selectedTableCellBackgroundColor =
    [UIColor colorWithRed:236.0f / 255.0f green:225.0f / 255.0f blue:220.0f / 255.0f alpha:1.0f];
    UIColor *darkBackgroundColor =
    [UIColor colorWithRed:93.0f / 255.0f green:64.0f / 255.0f blue:55.0f / 255.0f alpha:1.0f];
    UIColor *primaryTextColor = [UIColor colorWithWhite:0.33f alpha:1.0f];
    
    UIColor *highlightColor =
    [UIColor colorWithRed:255.0f / 255.0f green:235.0f / 255.0f blue:0.0f / 255.0f alpha:1.0f];
    UIColor *secondaryColor = [UIColor colorWithWhite:114.0f / 255.0f alpha:1.0f];
    UIColor *tintColor =
    [UIColor colorWithRed:219 / 255.0f green:207 / 255.0f blue:28 / 255.0f alpha:1.0f];
    UIColor *searchBarTintColor = [UIColor yellowColor];
    UIColor *separatorColor = [UIColor colorWithWhite:182.0f / 255.0f alpha:1.0f];
    
    [self presentAutocompleteControllerWithBackgroundColor:backgroundColor
                          selectedTableCellBackgroundColor:selectedTableCellBackgroundColor
                                       darkBackgroundColor:darkBackgroundColor
                                          primaryTextColor:primaryTextColor
                                            highlightColor:highlightColor
                                            secondaryColor:secondaryColor
                                                 tintColor:tintColor
                                        searchBarTintColor:searchBarTintColor
                                            separatorColor:separatorColor];
}

- (void)openBlueTheme{
    UIColor *backgroundColor =
    [UIColor colorWithRed:225.0f / 255.0f green:241.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
    UIColor *selectedTableCellBackgroundColor =
    [UIColor colorWithRed:213.0f / 255.0f green:219.0f / 255.0f blue:230.0f / 255.0f alpha:1.0f];
    UIColor *darkBackgroundColor =
    [UIColor colorWithRed:187.0f / 255.0f green:222.0f / 255.0f blue:248.0f / 255.0f alpha:1.0f];
    UIColor *primaryTextColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    UIColor *highlightColor =
    [UIColor colorWithRed:76.0f / 255.0f green:175.0f / 255.0f blue:248.0f / 255.0f alpha:1.0f];
    UIColor *secondaryColor = [UIColor colorWithWhite:0.5f alpha:0.65f];
    UIColor *tintColor =
    [UIColor colorWithRed:0 / 255.0f green:142 / 255.0f blue:248.0f / 255.0f alpha:1.0f];
    UIColor *searchBarTintColor = tintColor;
    UIColor *separatorColor = [UIColor colorWithWhite:0.5f alpha:0.65f];
    
    [self presentAutocompleteControllerWithBackgroundColor:backgroundColor
                          selectedTableCellBackgroundColor:selectedTableCellBackgroundColor
                                       darkBackgroundColor:darkBackgroundColor
                                          primaryTextColor:primaryTextColor
                                            highlightColor:highlightColor
                                            secondaryColor:secondaryColor
                                                 tintColor:tintColor
                                        searchBarTintColor:searchBarTintColor
                                            separatorColor:separatorColor];
}

- (void)openBlackTheme{
    UIColor *backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    UIColor *selectedTableCellBackgroundColor = [UIColor colorWithWhite:0.35f alpha:1.0f];
    UIColor *darkBackgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    UIColor *primaryTextColor = [UIColor whiteColor];
    UIColor *highlightColor = [UIColor colorWithRed:0.75f green:1.0f blue:0.75f alpha:1.0f];
    UIColor *secondaryColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    UIColor *tintColor = [UIColor whiteColor];
    UIColor *searchBarTintColor = tintColor;
    UIColor *separatorColor = [UIColor colorWithRed:0.5f green:0.75f blue:0.5f alpha:0.30f];
    
    [self presentAutocompleteControllerWithBackgroundColor:backgroundColor
                          selectedTableCellBackgroundColor:selectedTableCellBackgroundColor
                                       darkBackgroundColor:darkBackgroundColor
                                          primaryTextColor:primaryTextColor
                                            highlightColor:highlightColor
                                            secondaryColor:secondaryColor
                                                 tintColor:tintColor
                                        searchBarTintColor:searchBarTintColor
                                            separatorColor:separatorColor];
}

- (void)openHotDogTheme{
    UIColor *backgroundColor = [UIColor yellowColor];
    UIColor *selectedTableCellBackgroundColor = [UIColor whiteColor];
    UIColor *darkBackgroundColor = [UIColor redColor];
    UIColor *primaryTextColor = [UIColor blackColor];
    UIColor *highlightColor = [UIColor redColor];
    UIColor *secondaryColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    UIColor *tintColor = [UIColor redColor];
    UIColor *searchBarTintColor = [UIColor whiteColor];
    UIColor *separatorColor = [UIColor redColor];
    
    [self presentAutocompleteControllerWithBackgroundColor:backgroundColor
                          selectedTableCellBackgroundColor:selectedTableCellBackgroundColor
                                       darkBackgroundColor:darkBackgroundColor
                                          primaryTextColor:primaryTextColor
                                            highlightColor:highlightColor
                                            secondaryColor:secondaryColor
                                                 tintColor:tintColor
                                        searchBarTintColor:searchBarTintColor
                                            separatorColor:separatorColor];
}

- (void)openNormalTheme
{
    ERAutocompleteViewController *acController = [[ERAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

- (void)presentAutocompleteControllerWithBackgroundColor:(UIColor *)backgroundColor
                        selectedTableCellBackgroundColor:(UIColor *)selectedTableCellBackgroundColor
                                     darkBackgroundColor:(UIColor *)darkBackgroundColor
                                        primaryTextColor:(UIColor *)primaryTextColor
                                          highlightColor:(UIColor *)highlightColor
                                          secondaryColor:(UIColor *)secondaryColor
                                               tintColor:(UIColor *)tintColor
                                      searchBarTintColor:(UIColor *)searchBarTintColor
                                          separatorColor:(UIColor *)separatorColor {
    // Use UIAppearance proxies to change the appearance of UI controls in
    // ERAutocompleteViewController. Here we use appearanceWhenContainedIn to localise changes to
    // just this part of the Demo app. This will generally not be necessary in a real application as
    // you will probably want the same theme to apply to all elements in your app.
    UIActivityIndicatorView *appearence = [UIActivityIndicatorView
                                           appearanceWhenContainedIn:[ERAutocompleteViewController class], nil];
    [appearence setColor:primaryTextColor];
    
    [[UINavigationBar appearanceWhenContainedIn:[ERAutocompleteViewController class], nil]
     setBarTintColor:darkBackgroundColor];
    [[UINavigationBar appearanceWhenContainedIn:[ERAutocompleteViewController class], nil]
     setTintColor:searchBarTintColor];
    
    // Color of typed text in search bar.
    NSDictionary *searchBarTextAttributes = @{
                                              NSForegroundColorAttributeName : searchBarTintColor,
                                              NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]
                                              };
    [[UITextField appearanceWhenContainedIn:[ERAutocompleteViewController class], nil]
     setDefaultTextAttributes:searchBarTextAttributes];
    
    // Color of the "Search" placeholder text in search bar. For this example, we'll make it the same
    // as the bar tint color but with added transparency.
    CGFloat increasedAlpha = CGColorGetAlpha(searchBarTintColor.CGColor) * 0.75f;
    UIColor *placeHolderColor = [searchBarTintColor colorWithAlphaComponent:increasedAlpha];
    
    NSDictionary *placeholderAttributes = @{
                                            NSForegroundColorAttributeName : placeHolderColor,
                                            NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]
                                            };
    NSAttributedString *attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Search" attributes:placeholderAttributes];
    
    [[UITextField appearanceWhenContainedIn:[ERAutocompleteViewController class], nil]
     setAttributedPlaceholder:attributedPlaceholder];
    
    // Change the background color of selected table cells.
    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = selectedTableCellBackgroundColor;
    id tableCellAppearance =
    [UITableViewCell appearanceWhenContainedIn:[ERAutocompleteViewController class], nil];
    [tableCellAppearance setSelectedBackgroundView:selectedBackgroundView];
    
    // Depending on the navigation bar background color, it might also be necessary to customise the
    // icons displayed in the search bar to something other than the default. The
    // setupSearchBarCustomIcons method contains example code to do this.
    
    ERAutocompleteViewController *acController = [[ERAutocompleteViewController alloc] init];
    acController.delegate = self;
    acController.tableCellBackgroundColor = backgroundColor;
    acController.tableCellSeparatorColor = separatorColor;
    acController.primaryTextColor = primaryTextColor;
    acController.primaryTextHighlightColor = highlightColor;
    acController.secondaryTextColor = secondaryColor;
    acController.tintColor = tintColor;
    //    UINavigationController *nac = [[UINavigationController alloc] initWithRootViewController:acController];
    [self presentViewController:acController animated:YES completion:nil];
}

/*
 * This method shows how to replace the "search" and "clear text" icons in the search bar with
 * custom icons in the case where the default gray icons don't match a custom background.
 */
- (void)setupSearchBarCustomIcons {
    id searchBarAppearanceProxy =
    [UISearchBar appearanceWhenContainedIn:[ERAutocompleteViewController class], nil];
    [searchBarAppearanceProxy setImage:[UIImage imageNamed:@"custom_clear_x_high"]
                      forSearchBarIcon:UISearchBarIconClear
                                 state:UIControlStateHighlighted];
    [searchBarAppearanceProxy setImage:[UIImage imageNamed:@"custom_clear_x"]
                      forSearchBarIcon:UISearchBarIconClear
                                 state:UIControlStateNormal];
    [searchBarAppearanceProxy setImage:[UIImage imageNamed:@"custom_search"]
                      forSearchBarIcon:UISearchBarIconSearch
                                 state:UIControlStateNormal];
}

#pragma mark - ERAutocompleteViewControllerDelegate

- (void)viewController:(ERAutocompleteViewController *)viewController
didAutocompleteWithPlace:(ERPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(ERAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)wasCancelled:(ERAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didRequestAutocompletePredictions:(ERAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(ERAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
