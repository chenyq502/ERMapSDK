//
//  AutoCompleteDemoViewController.m
//  MapDemo
//
//  Created by xiaoyuan on 2018/10/25.
//  Copyright © 2018 erlinyou. All rights reserved.
//

#import "AutoCompleteDemoViewController.h"
#import <ERMapPlacesSDK/ErlinyouPlaces.h>

@interface AutoCompleteDemoViewController () <ERAutocompleteViewControllerDelegate>

@end

@implementation AutoCompleteDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ERAutocompleteViewController *acController = [[ERAutocompleteViewController alloc] init];
    acController.delegate = self;
    acController.tableCellBackgroundColor = [UIColor whiteColor];
    acController.tableCellSeparatorColor = [UIColor lightGrayColor];
    acController.primaryTextColor = [UIColor blackColor];
    acController.primaryTextHighlightColor = [UIColor yellowColor];
    acController.secondaryTextColor = [UIColor darkGrayColor];
    acController.tintColor = [UIColor purpleColor];
    UINavigationController *nac = [[UINavigationController alloc] initWithRootViewController:acController];
    [self presentViewController:nac animated:YES completion:nil];
}
#pragma mark - ERAutocompleteViewControllerDelegate

- (void)viewController:(ERAutocompleteViewController *)viewController
didAutocompleteWithPlace:(ERPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self autocompleteDidSelectPlace:place];
}

- (void)viewController:(ERAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self autocompleteDidFail:error];
}

- (void)wasCancelled:(ERAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self autocompleteDidCancel];
}

- (void)didRequestAutocompletePredictions:(ERAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(ERAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
@end
