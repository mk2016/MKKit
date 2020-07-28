//
//  MKNavigationController.m
//  MKKit
//
//  Created by xiaomk on 2016/9/29.
//  Copyright © 2016 mk. All rights reserved.
//

#import "MKNavigationController.h"
#import "MKViewController.h"
#import "UIImage+MKAdd.h"
#import "UINavigationController+MKAdd.h"

@interface MKNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) CALayer *bottomeLineLayer;
@end

@implementation MKNavigationController

+ (void)initialize{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setTitleTextAttributes:@{
                                     NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                                     NSForegroundColorAttributeName : [UIColor blackColor],
                                     }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (void)setCustomNavigationBarLineHidden:(BOOL)hidden{
    if (hidden && _bottomeLineLayer) {
        [_bottomeLineLayer removeFromSuperlayer];
    }else{
        [self.navigationBar.layer addSublayer:self.bottomeLineLayer];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [super pushViewController:viewController animated:animated];
}

#pragma mark - ***** UINavigationControllerDelegate ******
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (self.viewControllers.count > 1) {
            self.interactivePopGestureRecognizer.enabled = YES;
        }else{
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

#pragma mark - ***** UIGestureRecognizerDelegate ******
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL ok = YES;
    if ([self.topViewController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
        ok = [[self.topViewController performSelector:@selector(gestureRecognizerShouldBegin)] boolValue];
    }
    return ok;
}

#pragma mark - ***** UIStatusBarStyle *****
- (UIStatusBarStyle)preferredStatusBarStyle{
    return [self.topViewController preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

#pragma mark - ***** Autorotate *****
- (BOOL)shouldAutorotate{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

#pragma mark - ***** lazy ******
- (CALayer *)bottomeLineLayer{
    if (!_bottomeLineLayer) {
        CGRect frame = self.navigationBar.bounds;
        CGFloat lineHeight = 0.7;
        CGRect lineFrame = CGRectMake(0, frame.size.height-lineHeight, frame.size.width, lineHeight);
        _bottomeLineLayer = [CALayer layer];
        _bottomeLineLayer.frame = lineFrame;
        _bottomeLineLayer.backgroundColor = [[UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1] CGColor];
    }
    return _bottomeLineLayer;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
