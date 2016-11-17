

#import <Foundation/Foundation.h>

typedef void(^successBlock)(id result);
typedef void(^failureBlock)(NSError *error);

typedef NS_ENUM(NSUInteger, ZWYResponseStyle) {
    ZWYJSON,
    ZWYDATA,
    ZWYXML,
};

typedef NS_ENUM(NSUInteger, ZWYRequestStyle) {
    ZWYBodyString,
    ZWYBodyJSON,
};

@interface ZWYNetTool : NSObject

+(void)GET:(NSString *)url
   andBody:(id)body
 andHeader:(NSDictionary *)headers
andResponse:(ZWYResponseStyle)responseStyle
andSuccessBlock:(successBlock)success
andFailureBlock:(failureBlock)failure;

+(void)POST:(NSString *)url
   andBody:(id)body
andBodyStyle:(ZWYRequestStyle)bodyStyle
 andHeader:(NSDictionary *)headers
andResponse:(ZWYResponseStyle)responseStyle
andSuccessBlock:(successBlock)success
andFailureBlock:(failureBlock)failure;


@end
