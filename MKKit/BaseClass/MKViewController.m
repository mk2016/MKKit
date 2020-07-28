//
//  MKViewController.m
//  MKKit
//
//  Created by xiaomk on 2019/1/7.
//  Copyright © 2019 mk. All rights reserved.
//

#import "MKViewController.h"
#import "MKConst.h"

@interface MKViewController ()

@end

@implementation MKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
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
    DLog(@"dealloc ♻️");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
