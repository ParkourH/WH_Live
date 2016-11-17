//
//  AppDelegate.m
//  iPodcast
//
//  Created by ParkourH on 16/10/18.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "Ipodcast.h"
#import "JYJ_LoginViewController.h"
#import <QPLive/QPLive.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UMConfigInstance.appKey = @"581d789ae88bad56f00023ba";
    UMConfigInstance.channelId = @"App Store";
    // 游戏的话这儿还有设置一项
//    UMConfigInstance.eSType = E_UM_GAME;
    
    [MobClick startWithConfigure:UMConfigInstance];
    
    
    [AVOSCloud setApplicationId:APP_ID clientKey:APP_KEY];
    [AVOSCloud setAllLogsEnabled:YES];
    [AVOSCloud setLogLevel:YES];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    

    self.tabBar = [[MainTabBarController alloc] init];
    self.window.rootViewController = _tabBar;
    
    [[QPAuth shared] registerAppWithKey:@"20cb655e1335967" secret:@"e41b3e6fb31341878f97e4bae1e4e8b5" space:@"spacename250039415" success:^(NSString *accessToken) {
        NSLog(@"%@",accessToken);
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [AVOSCloudSNS handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [AVOSCloudSNS handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [AVOSCloudSNS handleOpenURL:url];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
