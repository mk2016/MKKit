//
//  MKTabBarController.m
//  MKKit
//
//  Created by xiaomk on 2016/11/4.
//  Copyright © 2016 mk. All rights reserved.
//

#import "MKTabBarController.h"
#import "UIImage+MKAdd.h"

@interface MKTabBarController ()

@end

@implementation MKTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 13.0, *)) {
        self.tabBar.unselectedItemTintColor = UIColor.blueColor;
    }else{
           // iOS13 以下
           UITabBarItem *item = [UITabBarItem appearance];
           [item setTitleTextAttributes:@{ NSForegroundColorAttributeName:UIColor.redColor} forState:UIControlStateNormal];
           [item setTitleTextAttributes:@{ NSForegroundColorAttributeName:UIColor.greenColor} forState:UIControlStateSelected];
     }
    
}

- (BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}

/** supported Orientations */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

/** preferred orientations */
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

- (UIViewController *)childViewControllerForStatusBarHidden{
    return self.selectedViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.selectedViewController;
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
