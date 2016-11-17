//
//  LoginAlertController.m
//  iPodcast
//
//  Created by 冀永金 on 16/10/22.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "LoginAlertController.h"

@interface LoginAlertController ()

@end

@implementation LoginAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self createAction];
}

- (void)createAction {

    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickConfirmButton:)]) {
            
            [self.delegate clickConfirmButton:self];
        }
    }];
    
    UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [self addAction:actionOK];
    [self addAction:actionCancle];
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
