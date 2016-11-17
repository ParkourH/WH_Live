//
//  LoginAlertController.h
//  iPodcast
//
//  Created by 冀永金 on 16/10/22.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginAlertController;
@protocol LoginAlertDelegate <NSObject>

- (void)clickConfirmButton:(LoginAlertController *)alert;

@end

@interface LoginAlertController : UIAlertController
@property (nonatomic, weak) id <LoginAlertDelegate>delegate;

@end
