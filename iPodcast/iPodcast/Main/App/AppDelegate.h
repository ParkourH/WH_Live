//
//  AppDelegate.h
//  iPodcast
//
//  Created by ParkourH on 16/10/18.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainTabBarController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MainTabBarController *tabBar;

@end

