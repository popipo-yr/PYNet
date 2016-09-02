//
//  PYNetClientImp_AF.m
//
//  Created by yr on 15/12/24.
//  Copyright © 2015年 yr. All rights reserved.
//

#import "PYNetClientImp_AF.h"
#import <AFNetworking/AFNetworking.h>

@implementation PYNetClientImp_AF {
    AFHTTPSessionManager *_clientImp;
}


- (id)initWithBaseURL:(NSURL *)url
{
    if (self = [super init]) {
        _clientImp = [[AFHTTPSessionManager alloc] initWithBaseURL:url];

        NSSet *types = _clientImp.responseSerializer.acceptableContentTypes;
        types = [types setByAddingObject:@"text/html"];
        types = [types setByAddingObject:@"application/octet-stream"];

        _clientImp.responseSerializer.acceptableContentTypes = types;

        _clientImp.responseSerializer = [AFCompoundResponseSerializer serializer];
        _clientImp.requestSerializer  = [AFJSONRequestSerializer serializer];
    }

    return self;
}


- (void)setDefaultHeader:(NSString *)header value:(NSString *)value
{
    [_clientImp.requestSerializer setValue:value forHTTPHeaderField:header];
}


- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                                     files:(NSArray<PYNetFile *> *)files
{
    void (^constructingBodyWithBlock)(id <AFMultipartFormData>) =
        ^(id <AFMultipartFormData> formData) {
        for (PYNetFile *aFile in files) {
            [formData appendPartWithFileData:aFile.data
                                        name:aFile.name
                                    fileName:aFile.fileName
                                    mimeType:aFile.type];
        }
    };

    return [_clientImp.requestSerializer
            multipartFormRequestWithMethod:method
                                 URLString:URLString
                                parameters:parameters
                 constructingBodyWithBlock:constructingBodyWithBlock
                                     error:nil];
}


- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
{
    return [_clientImp.requestSerializer requestWithMethod:method
                                                 URLString:URLString
                                                parameters:parameters
                                                     error:nil];
}


- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSURLResponse *response,
                                id responseObject,
                                NSError *error))completionHandler
{
    return [_clientImp dataTaskWithRequest:request
                         completionHandler:completionHandler];
}


- (BOOL)isSuccessStatusOfServeData:(NSDictionary*)serverData{

    return [[NSString stringWithFormat:@"%@", serverData[@"success"]] isEqualToString:@"true"];
}

@end