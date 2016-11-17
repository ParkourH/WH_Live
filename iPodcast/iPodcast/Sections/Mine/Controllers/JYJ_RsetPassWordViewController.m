//
//  JYJ_RsetPassWordViewController.m
//  iPodcast
//
//  Created by 冀永金 on 16/10/26.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "JYJ_RsetPassWordViewController.h"
#import "Ipodcast.h"
@interface JYJ_RsetPassWordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *createCodeButton;

@property (weak, nonatomic) IBOutlet UITextField *passWordOfNew;





@end

@implementation JYJ_RsetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)createCodeAction:(id)sender {
    [AVUser requestLoginSmsCode:[AVUser currentUser].mobilePhoneNumber withBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [self alertWithTitle:@"提示" message:error.localizedDescription];
        }else {
            [self receiveCheckNumButton];
        }
    }];
    
    
    
}
- (IBAction)restPassWd:(id)sender {
    if (self.codeTextFiled.text.length < 6) {
        [self alertWithTitle:@"提示" message:@"验证码无效"];
    }
    [AVUser resetPasswordWithSmsCode:self.codeTextFiled.text newPassword:self.passWordOfNew.text block:^(BOOL succeeded, NSError *error) {
        if (error) {
            [self alertWithTitle:@"提示" message:error.localizedDescription];
        }else {
            //[self alertWithTitle:@"成功" message:@"已经成功重置当前用户的密码！"];
            [self dismissViewControllerAnimated:YES completion:nil];
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
                [self.createCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
                self.createCodeButton.userInteractionEnabled = YES;
                
            });
        }else{
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //让按钮变为不可点击的灰色
                self.createCodeButton.userInteractionEnabled = NO;
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.createCodeButton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
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
