//
//  MKViewController.m
//  TQSAASPro
//
//  Created by xiaomk on 2019/1/7.
//  Copyright © 2019 tqcar. All rights reserved.
//

#import "MKViewController.h"

@interface MKViewController ()

@end

@implementation MKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSNumber *)gestureRecognizerShouldBegin{
    return @(YES);
}

#pragma mark - ***** statusBar ******
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

#pragma mark - ***** Autorotate *****
- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
