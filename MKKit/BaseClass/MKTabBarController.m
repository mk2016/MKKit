//
//  MKTabBarController.m
//  MKKit
//
//  Created by xmk on 2016/11/4.
//  Copyright © 2016年 mk. All rights reserved.
//

#import "MKTabBarController.h"
#import "UIImage+MKAdd.h"

@interface MKTabBarController ()

@end

@implementation MKTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.tabBar.bounds);
    self.tabBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.tabBar.layer.shadowColor = color.CGColor;
    self.tabBar.layer.shadowOffset = offset;
    self.tabBar.layer.shadowRadius = radius;
    self.tabBar.layer.shadowOpacity = opacity;
    self.tabBar.clipsToBounds = NO;
    
    [self hideBlackLine];
}

- (void)hideBlackLine{
    if (@available(iOS 13.0, *)) {
          UITabBarAppearance *tabbar = self.tabBar.standardAppearance;
          tabbar.backgroundImage = [UIImage mk_imageWithColor:UIColor.clearColor];
          tabbar.shadowImage = [UIImage mk_imageWithColor:UIColor.clearColor];
          self.tabBar.standardAppearance = tabbar;
      }else{
          [UITabBar appearance].shadowImage = [UIImage new];
          [UITabBar appearance].backgroundImage = [UIImage new];
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
