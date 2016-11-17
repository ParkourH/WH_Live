//
//  WH_LiveViewController.m
//  iPodcast
//
//  Created by ParkourH on 16/10/25.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "WH_LiveViewController.h"
#import "Ipodcast.h"

@interface WH_LiveViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lookPeople;
@property (weak, nonatomic) IBOutlet UILabel *countsOfLive;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation WH_LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupViews];
}

- (void)setupViews {

    self.titleLabel.textColor = kSystemColor;
    self.lookPeople.textColor = kSystemColor;
    
    [self.backButton layoutIfNeeded];
    [self.backButton setTitleColor:kSystemColor forState:UIControlStateNormal];
    self.backButton.layer.masksToBounds = YES;
    self.backButton.layer.cornerRadius = self.backButton.bounds.size.height / 2;
    self.backButton.layer.borderWidth = 1;
    self.backButton.layer.borderColor = kSystemColor.CGColor;
    
}


- (IBAction)backButtonAction:(id)sender {

    [self dismissViewControllerAnimated:YES completion:^{
       
    }];
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
