//
//  MainTabBarController.m
//  ZHIBO
//
//  Created by qianfeng on 16/9/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainNavigationController.h"
#import "CameraViewController.h"
#import "LiveViewController.h"
#import "MineViewController.h"
//#import "UIImage+Image.h"
//#import "UIView+Frame.h"
#import "UIView+XJExtension.h"

//重复点击tabBar上按钮，刷新当前界面功能
NSString * const repeateClickTabBarButtonNote = @"repeateClickTabBarButton";

@interface MainTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic,weak)UIViewController *lastViewController;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加所有的子控制器
    [self setupAllViewController];
    //设置tabBar上的内容
    [self setupAllTabBarButton];
    //添加视频采集按钮
    [self addCameraButton];
    //设置tabBar背景图片
    [self setupTabBarBackgroundImage];
    //设置代理 监听tabBar的点击事件
    self.delegate = self;
    _lastViewController = self.childViewControllers.firstObject;
}

#pragma mark ---- <添加视频采集按钮>
- (void)addCameraButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"tab_room"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"tab_room_p"] forState:UIControlStateHighlighted];
    [btn sizeToFit];
    btn.center = CGPointMake(self.tabBar.xj_width * 0.5, self.tabBar.xj_height * 0.5 + 5);
    [btn addTarget:self action:@selector(clickCamerBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:btn];
}

#pragma mark ---- <点击了CameraBtn>
- (void)clickCamerBtn{
    
    CameraViewController *caCtrl = [[CameraViewController alloc]init];
    [self presentViewController:caCtrl animated:YES completion:nil];
}

#pragma mark ---- <设置tabBar上按钮的内容>
- (void)setupAllTabBarButton{
    LiveViewController *liveCtrl = self.childViewControllers[0];
    liveCtrl.tabBarItem.image = [UIImage imageNamed:@"tab_live"];
    liveCtrl.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_live_p"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    liveCtrl.tabBarItem.imageInsets = UIEdgeInsetsMake(10, 0, -10, 0);
    
    CameraViewController *cameraCtrl = self.childViewControllers[1];
    cameraCtrl.tabBarItem.enabled = NO;
    cameraCtrl.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    MineViewController *mineCtrl = self.childViewControllers[2];
    mineCtrl.tabBarItem.image = [UIImage imageNamed:@"tab_me"];
    mineCtrl.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_me_p"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineCtrl.tabBarItem.imageInsets = UIEdgeInsetsMake(10, 0, -10, 0);
    //隐藏隐藏线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
}

#pragma mark ---- <添加所有的子控制>
- (void)setupAllViewController {
    
    //Live
    LiveViewController *liveVc = [[LiveViewController alloc] init];
    MainNavigationController *liveNav = [[MainNavigationController alloc] initWithRootViewController:liveVc];
    
    [self addChildViewController:liveNav];
    
    //Camera
    CameraViewController *cameraVc = [[CameraViewController alloc] init];
    MainNavigationController *cameraNav = [[MainNavigationController alloc] initWithRootViewController:cameraVc];
    
    [self addChildViewController:cameraNav];
    
    //Main
    MineViewController *mineVc = [[MineViewController alloc] init];
    MainNavigationController *mineNav = [[MainNavigationController alloc] initWithRootViewController:mineVc];
    
    [self addChildViewController:mineNav];
    
}

#pragma mark ---- <设置tabBar背景图片>
- (void)setupTabBarBackgroundImage {
    UIImage *image = [UIImage imageNamed:@"tab_bg"];
    
    CGFloat top = 40; // 顶端盖高度
    CGFloat bottom = 40 ; // 底端盖高度
    CGFloat left = 100; // 左端盖宽度
    CGFloat right = 100; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    UIImage *TabBgImage = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.tabBar.backgroundImage = TabBgImage;
    
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
}
#pragma mark ---- <自定义tabBar高度>
- (void)viewWillLayoutSubviews{
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 60;
    tabFrame.origin.y = self.view.frame.size.height - 60;
    self.tabBar.frame = tabFrame;
}

#pragma mark ---- <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (_lastViewController == viewController) {
        //发出重复点击通知
        [[NSNotificationCenter defaultCenter] postNotificationName:repeateClickTabBarButtonNote object:nil];
    }
    _lastViewController = viewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
