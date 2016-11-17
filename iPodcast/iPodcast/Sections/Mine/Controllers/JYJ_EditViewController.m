//
//  JYJ_EditViewController.m
//  iPodcast
//
//  Created by 冀永金 on 16/10/21.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "JYJ_EditViewController.h"
#import "Ipodcast.h"
#import "JYJ_EditTableViewCell.h"
#import "Ipodcast.h"
#import "JYJ_HeadTableView.h"
@interface JYJ_EditViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *marrOfFirst;
@property (nonatomic, strong) NSMutableArray *marrOfSceond;
@property (nonatomic, strong) JYJ_EditTableViewCell *cell;
@property (nonatomic, copy) NSString *imagePath;

@property (nonatomic, strong) UIImage *image;
@end

@implementation JYJ_EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.marrOfFirst = [NSMutableArray arrayWithObjects:@"昵称",@"播客号",@"性别",@"个性签名", nil];
    self.marrOfSceond = [NSMutableArray arrayWithObjects:@"年龄",@"情感状态",@"家乡",@"职业", nil];
    self.view.backgroundColor = [UIColor whiteColor];
   self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = kSystemColor;
    self.navigationItem.title = @"编辑资料";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    

    [self createTableView];
    // Do any additional setup after loading the view.
}
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(withImage:)]) {
//        [self.delegate withImage:self.cell.rightImage.image];
//    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    
}
- (void)createTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 60) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JYJ_EditTableViewCell class] forCellReuseIdentifier:@"pool"];
    self.tableView.showsVerticalScrollIndicator = NO;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 4;
    }else {
        return 4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [tableView dequeueReusableCellWithIdentifier:@"pool" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        _cell.rightImage.hidden = YES;
        _cell.rightLabel.hidden = YES;
        _cell.editTitleLabel.text = @"更改头像";
        
    }else if(indexPath.section == 1) {
        _cell.rightImage.hidden = YES;
       
        _cell.editTitleLabel.text = self.marrOfFirst[indexPath.row];
        
    }else if (indexPath.section == 2) {
        _cell.rightImage.hidden = YES;
        _cell.editTitleLabel.text = self.marrOfSceond[indexPath.row];
        
    }
     _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return _cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }else {
        return 60;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"拍照");
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"选择手机相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self handleAction];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)handleAction{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark -------编辑完照片就会走的方法  保存编辑过的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //保存编辑照片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image != nil) {
        self.cell.rightImage.image = image;
    
    }
    NSData *data;
    if (UIImagePNGRepresentation(image)) {
        data = UIImagePNGRepresentation(image);
    }
    else {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    NSArray *pathArr =   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [[pathArr firstObject] stringByAppendingPathComponent:@"imageData"];
    [data writeToFile:dataPath atomically:YES];
    AVFile *file = [AVFile fileWithName:dataPath data:data];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:@"image"];
    

//   AVQuery *query = [AVQuery queryWithClassName:@"_User"];
//    AVObject *todo = [AVObject objectWithClassName:@"_User" objectId:[user objectForKey:@"objectId"]];
//
//    [query getObjectInBackgroundWithId:[user objectForKey:@"objectId"] block:^(AVObject *object, NSError *error) {
//        [todo setObject:file forKey:@"file"];
//        [user setObject:data forKey:@"image"];
//        [todo save];
//    }];
//    
    AVObject *todo = [AVObject objectWithClassName:@"_User" objectId:[AVUser currentUser].objectId];
    
    [todo setObject:file forKey:@"file"];
    // 保存到云端
    [todo saveInBackground];

//    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
//        AVObject *todo =[AVObject objectWithClassName:@"_User" objectId:[AVUser currentUser].objectId];
//        [todo setObject:file forKey:@"file"];
//        
//        [user setObject:data forKey:@"image"];
//
//        // 保存到云端
//        [todo saveInBackground];
//    }];
   
  
    
       [self dismissViewControllerAnimated:YES completion:nil];
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
