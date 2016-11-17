//
//  JYJ_RegisterViewController.m
//  iPodcast
//
//  Created by 冀永金 on 16/10/22.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "JYJ_RegisterViewController.h"
#import "Ipodcast.h"
@interface JYJ_RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *securityCodeTextField;
@property (nonatomic, strong) NSTimer *counterDownTimer;
@property (weak, nonatomic) IBOutlet UIButton *code;
@property (nonatomic, assign) NSUInteger freezeCounter;
@property (nonatomic, strong)  AVUser *user;
@end

@implementation JYJ_RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.finishButton.layer.borderWidth = 2;
    self.finishButton.layer.borderColor = [UIColor redColor].CGColor;
    [self.finishButton layoutIfNeeded];
    self.finishButton.layer.cornerRadius = self.finishButton.bounds.size.height / 2;
    self.passWordTextField.secureTextEntry = YES;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)psdHidden:(id)sender {
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        
        self.passWordTextField.secureTextEntry = YES;
        [btn setImage:[UIImage imageNamed:@"passwor_noeye"] forState:UIControlStateNormal];
    } else {
    
        self.passWordTextField.secureTextEntry = NO;
        [btn setImage:[UIImage imageNamed:@"password_eye"] forState:UIControlStateNormal];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden= YES;
}
- (IBAction)finishRegister:(id)sender {
    if (self.userNameTextField.text.length < 1) {
         [self alertWithTitle:@"提示" message:@"用户名不能为空"];
    }
    if (self.userNameTextField.text.length > 15) {
          [self alertWithTitle:@"提示" message:@"用户名长度过长"];
    }
    if (self.passWordTextField.text.length <1) {
        [self alertWithTitle:@"提示" message:@"密码不能为空"];
    }
    if (self.phoneTextField.text.length < 1) {
        [self alertWithTitle:@"提示" message:@"手机号码不能为空"];
    }
    NSString *smsCode = self.securityCodeTextField.text;
    if (smsCode.length < 6) {
        [self alertWithTitle:@"提示" message:@"验证码无效"];
    }else{
        [AVUser verifyMobilePhone:smsCode withBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                [self alertWithTitle:@"提示" message:error.localizedDescription];
            }else {
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    
}
- (IBAction)codeAction:(id)sender {
    self.user = [[AVUser alloc]init];
    self.user.username = self.userNameTextField.text;
    self.user.password = self.passWordTextField.text;
    self.user.mobilePhoneNumber = self.phoneTextField.text;
    [self.user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            if ([error.localizedDescription isEqualToString:@"Mobile phone number has already been taken"]) {
                [AVUser requestMobilePhoneVerify:self.user.mobilePhoneNumber withBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        [self alertWithTitle:@"提示" message:error.localizedDescription];
                    } else {
                        [self receiveCheckNumButton];
                       
                    }
                }];
            
            }else {
                [self alertWithTitle:@"提示" message:error.localizedDescription ];
            }

        }else {
            [self receiveCheckNumButton];
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
//获取验证码倒计时
- (void)receiveCheckNumButton{
    __block int timeout= 180; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.code setTitle:@"重新获取" forState:UIControlStateNormal];
                self.code.userInteractionEnabled = YES;
                
            });
        }else{
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //让按钮变为不可点击的灰色
                self.code.userInteractionEnabled = NO;
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.code setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
