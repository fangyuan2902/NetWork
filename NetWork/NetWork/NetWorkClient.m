//
//  NetWorkClient.m
//  NetWork
//
//  Created by yf on 2018/5/4.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

#import "NetWorkClient.h"

@implementation NetWorkClient

+ (NetWorkClient *)sharedClient {
    static NetWorkClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
                  ^{
                      _sharedClient = [[NetWorkClient alloc] init];
                      _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
                      _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
                  });
    return _sharedClient;
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (NSURLSessionTask *)getRequestWithPath:(NSString *)path parameters:(NSMutableDictionary *)parameters success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString *error))failure {
    //1.检查网络状态
    if ([self isNetwork] == NO) {
        failure(@"请检查网络");
        return nil;
    };
    
    AFHTTPSessionManager *session= [self configSessionManager];
    
    return  [session GET:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDic;
        NSError *responseError = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&responseError];
            
        } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
        } else {
            NSLog(@"=======返回数据存在问题，请检查接口 %@ =======", path);
        }
        success(responseDic);
        
        for (NSString *key in responseDic.allKeys) {
            
            if ([[responseDic objectForKey:key] isEqual:@"C_500"]) {
                NSLog(@"===> wrong url ===> %@ ", path);
            }
            if ([[responseDic objectForKey:key] isEqual:@"远程调用失败,返回结果为null"]) {
                NSLog(@"===> wrong url:远程调用失败,返回结果为null ===> %@ ", path);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@%@", error.localizedDescription, path);
        failure(error.localizedDescription);
    }];
}

- (NSURLSessionTask *)postRequestWithPath:(NSString *)path parameters:(NSMutableDictionary *)parameters success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString *error))failure {
    //1.检查网络状态
    if ([self isNetwork] == NO) {
        failure(@"请检查网络");
        return nil;
    };
    
    AFHTTPSessionManager *session= [self configSessionManager];
    
    return  [session POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDic;
        NSError *responseError = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&responseError];
            
        } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
        } else {
            NSLog(@"=======返回数据存在问题，请检查接口 %@ =======", path);
        }
        success(responseDic);
        
        for (NSString *key in responseDic.allKeys) {
            
            if ([[responseDic objectForKey:key] isEqual:@"C_500"]) {
                NSLog(@"===> wrong url ===> %@ ", path);
            }
            if ([[responseDic objectForKey:key] isEqual:@"远程调用失败,返回结果为null"]) {
                NSLog(@"===> wrong url:远程调用失败,返回结果为null ===> %@ ", path);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@%@", error.localizedDescription, path);
        failure(error.localizedDescription);
    }];
}

/*判断是否有网*/
- (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

- (AFHTTPSessionManager *)configSessionManager {
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *session = nil;
    dispatch_once(&onceToken, ^{
        session= [AFHTTPSessionManager manager];
        session.requestSerializer.timeoutInterval = 15;
        session.securityPolicy = [self shareSecurityPolicy];
        [session setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [session.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    });
    return session;
}

- (AFSecurityPolicy *)shareSecurityPolicy {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setValidatesDomainName:NO];
    
    return securityPolicy;
}


@end
