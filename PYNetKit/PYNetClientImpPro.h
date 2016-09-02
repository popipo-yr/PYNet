//
//  PYNetClientImpPro.h
//
//  Created by yr on 15/12/24.
//  Copyright © 2015年 yr. All rights reserved.
//

#import "PYNetProtocalObj.h"


/**
 *  具体client需要实现的接口
 */
@protocol PYNetClientImpPro <NSObject>


- (void)setDefaultHeader:(NSString *)header value:(NSString *)value;


- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                                     files:(NSArray<PYNetFile *> *)files;

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters;


- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSURLResponse *response,
                                                        id responseObject,
                                                        NSError *error))completionHandler;

- (BOOL)isSuccessStatusOfServeData:(NSDictionary*)serverData;


@end
