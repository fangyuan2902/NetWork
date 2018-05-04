//
//  NetWorkClient.h
//  NetWork
//
//  Created by yf on 2018/5/4.
//  Copyright © 2018年 yuanfang. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface NetWorkClient : AFHTTPSessionManager

- (NSURLSessionTask *)postRequestWithPath:(NSString *)path parameters:(NSMutableDictionary *)parameters success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString *error))failure;

- (NSURLSessionTask *)getRequestWithPath:(NSString *)path parameters:(NSMutableDictionary *)parameters success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString *error))failure;

@end
