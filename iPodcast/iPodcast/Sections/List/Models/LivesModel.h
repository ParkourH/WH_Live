

#import <Foundation/Foundation.h>
#import "MJExtension.h"
//#import <MJExtension.h>
@interface UserModel : NSObject

@property(nonatomic,strong)NSString * nick;
@property(nonatomic,strong)NSString * ID;
@property(nonatomic,strong)NSString * portrait;
@property(nonatomic,strong)NSString * hometown;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) NSInteger gender;

@end


@interface LivesModel : NSObject



@property(nonatomic,strong)UserModel * creator;
@property(nonatomic,strong)NSString * ID;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * city;
@property(nonatomic,strong)NSString * share_addr;
@property(nonatomic,strong)NSString * stream_addr;
@property(nonatomic,strong)NSString * version;// 0,
@property(nonatomic,strong)NSString * slot;// 1,
@property(nonatomic,strong)NSString * optimal;// 0,
@property(nonatomic,strong)NSString * online_users;// 8607,
@property(nonatomic,strong)NSString * group;// 0

/** 自己的数据 */
@property (nonatomic, copy) NSString *username;


@end
