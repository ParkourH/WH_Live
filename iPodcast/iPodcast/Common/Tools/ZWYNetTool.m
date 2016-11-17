

#import "ZWYNetTool.h"
#import "AFNetworking.h"

@implementation ZWYNetTool

+(void)GET:(NSString *)url
   andBody:(id)body
 andHeader:(NSDictionary *)headers
andResponse:(ZWYResponseStyle)responseStyle
andSuccessBlock:(successBlock)success
andFailureBlock:(failureBlock)failure
{

    // 1. 设置网络管理者
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    // 2. 设置请求头
    
    if (headers) {
        
        for (NSString *key in headers.allKeys) {
            
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
            
        }
    }
    
    // 3. 设置返回数据的类型
    switch (responseStyle) {
        case ZWYJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case ZWYXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case ZWYDATA:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
            
        default:
            break;
    }
    
    // 4. 设置响应数据类型
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"image/jpeg", @"text/vnd.wap.wml", @"text/xml", @"application/x-javascript", nil]];
    
    
    // 5. UTF-8转码
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    // 6. 使用AFN进行网络请求
    [manager GET:url parameters:body success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (responseObject) {
            success(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }

    }];
}


+(void)POST:(NSString *)url andBody:(id)body andBodyStyle:(ZWYRequestStyle)bodyStyle andHeader:(NSDictionary *)headers andResponse:(ZWYResponseStyle)responseStyle andSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure
{
    // 1. 设置网络管理者
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    // 2. 设置body的数据类型
    
    switch (bodyStyle) {
        case ZWYBodyJSON:
            
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            break;
            
        case ZWYBodyString:
            
            [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable * _Nullable error) {
                
                return parameters;
                
            }];
            
            break;
            
        default:
            break;
    }
    
    // 3. 设置请求头
    
    if (headers) {
        
        for (NSString *key in headers.allKeys) {
            
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
            
        }
    }
    
    // 3. 设置返回数据的类型
    switch (responseStyle) {
        case ZWYJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case ZWYXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case ZWYDATA:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
            
        default:
            break;
    }
    
    // 4. 设置响应数据类型
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"image/jpeg", @"text/vnd.wap.wml", @"application/x-javascript", nil]];
    
    
    // 5. UTF-8转码
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    // 6. 使用AFN进行网络请求
    [manager POST:url parameters:body success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (responseObject) {
            success(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }

    }];
}






@end
