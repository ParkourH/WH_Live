//
//  JYJ_LoginViewController.m
//  iPodcast
//
//  Created by 冀永金 on 16/10/21.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "JYJ_LoginViewController.h"
#import "Ipodcast.h"
#import "JYJ_RegisterViewController.h"
#import "ListViewController.h"
#import "AppDelegate.h"
#import "JYJ_RsetPassWordViewController.h"
@interface JYJ_LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;// 登录按钮
@property (weak, nonatomic) IBOutlet UIButton *registerButton;//立即注册
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation JYJ_LoginViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.passWord.secureTextEntry = YES;
    self.loginButton.layer.borderWidth = 2;
    self.loginButton.layer.borderColor = [UIColor redColor].CGColor;
    [self.loginButton layoutIfNeeded];
    self.loginButton.layer.cornerRadius = self.loginButton.bounds.size.height / 2;
    self.registerButton.layer.borderWidth = 2;
    self.registerButton.layer.borderColor = kSystemColor.CGColor;
    [self.registerButton setTitleColor:kSystemColor forState:UIControlStateNormal];
    [self.registerButton layoutIfNeeded];
    self.registerButton.layer.cornerRadius = self.registerButton.bounds.size.height / 2;
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSWeiXin withAppKey:@"wxa9b1de9ec36b9fe7" andAppSecret:@"f16b16a72dd35c2d2ed3f69a2bec79e5" andRedirectURI:nil];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:@"2081836416" andAppSecret:@"50a808a992db9db02529189812b5954a" andRedirectURI:@""];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSQQ withAppKey:@"1105705519" andAppSecret:@"VjXaAJ3MlFFyLy3h" andRedirectURI:nil];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)handleRegister:(id)sender {
    JYJ_RegisterViewController *registerVC = [[JYJ_RegisterViewController alloc]init];
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)pswHidden:(id)sender {
    
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        
        self.passWord.secureTextEntry = YES;
        [btn setImage:[UIImage imageNamed:@"passwor_noeye"] forState:UIControlStateNormal];
    } else {
        
        self.passWord.secureTextEntry = NO;
        [btn setImage:[UIImage imageNamed:@"password_eye"] forState:UIControlStateNormal];
    }

}
- (IBAction)loginIn:(id)sender {
    
//    [AVUser logInWithUsernameInBackground:self.userName.text password:self.passWord.text block:^(AVUser *user, NSError *error) {
//        if (error) {
//            
//        }else {
//            NSLog(@"登陆成功 %@",user);
//        }
    //}];
   [AVUser logInWithMobilePhoneNumberInBackground:self.userName.text password:self.passWord.text block:^(AVUser *user, NSError *error) {
       if (error) {
          [self alertWithTitle:@"提示" message:error.localizedDescription];
       }else {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
           [userDefaults setObject:self.userName.text forKey:@"userName"];
           [userDefaults setObject:self.passWord.text forKey:@"passWord"];
           AVQuery *query = [AVQuery queryWithClassName:@"_User"];
           [query getObjectInBackgroundWithId:[AVUser currentUser].objectId block:^(AVObject *object, NSError *error) {


               [userDefaults setObject:object[@"userID"] forKey:@"userId"];
              
               [self.navigationController popViewControllerAnimated:YES];
               
           }];
       }

   }];
}
// 公用方法

- (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [alert dismissViewControllerAnimated:YES completion:nil];
    return alert;
}
- (IBAction)loginBackAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"小主您确定离开" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:action1];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)weixinAction:(id)sender {
    
    [sender setImage:[UIImage imageNamed:@"login_weixin"] forState:UIControlStateNormal];
    if ([AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSWeiXin]) {
        //真机测试
        [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
            NSLog(@"object : %@ error:%@", object, error);
            if ([self filterError:error]) {
                [AVUser loginWithAuthData:object platform:AVOSCloudSNSPlatformWeiXin block:^(AVUser *user, NSError *error) {
                    if ([self filterError:error]) {
                        [self loginSucceedWithUser:user authData:object];
                    }
                }];
            }
        } toPlatform:AVOSCloudSNSWeiXin];
    }else {
        [self alertWithTitle:@"提示" message:@"没有安装微信，暂时不能登录"];
    }
    

}

- (IBAction)weiboAction:(id)sender {
    // 如果安装了微博，直接跳转到微博应用，否则跳转至网页登录
    if ([AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSSinaWeibo]) {
        
        [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
            if (error) {
                NSLog(@"failed to get authentication from weibo. error: %@", error.description);
            } else {
                [AVUser loginWithAuthData:object platform:AVOSCloudSNSPlatformWeiBo block:^(AVUser *user, NSError *error) {
                    if ([self filterError:error]) {
                        [self loginSucceedWithUser:user authData:object];
                    }
                }];
            }
        } toPlatform:AVOSCloudSNSSinaWeibo];
        
    }else {
        [self alertWithTitle:@"提示" message:@"没有安装微博，暂时不能登录"];
    }
}
- (IBAction)qqAction:(id)sender {
    if ([AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSQQ]) {
        [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
            if (error) {
                NSLog(@"failed to get authentication from weibo. error: %@", error.description);
            } else {
                [AVUser loginWithAuthData:object platform:AVOSCloudSNSPlatformQQ block:^(AVUser *user, NSError *error) {
                    if ([self filterError:error]) {
                        [self loginSucceedWithUser:user authData:object];
                        
                    }
                }];
            }
        } toPlatform:AVOSCloudSNSQQ];

    }else {
        [self alertWithTitle:@"提示" message:@"没有安装qq,暂时不能登录"];
    }
}

- (BOOL)filterError:(NSError *)error {
    if (error) {
        [self alertWithTitle:@"提示" message:error.localizedDescription];
        return NO;
    }
    return YES;
}
- (void)loginSucceedWithUser:(AVUser *)user authData:(NSDictionary *)authData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:authData.allValues[0]  forKey:@"userName"];
    [userDefaults setObject:user[@"userID"] forKey:@"userId"];
   [self.navigationController popViewControllerAnimated:NO];
    [self.tabBarController setSelectedIndex:0];
    
    
}
- (IBAction)forgerPassWdAction:(id)sender {
    JYJ_RsetPassWordViewController *rset =[[JYJ_RsetPassWordViewController alloc]init];
    [self presentViewController:rset animated:YES completion:nil];
    
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
