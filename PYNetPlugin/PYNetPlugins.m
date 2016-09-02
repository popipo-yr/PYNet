//
//  PYNetPlugins.m
//  yr
//
//  Created by yr on 15/12/24.
//  Copyright © 2015年 yr. All rights reserved.
//

#import "PYNetPlugins.h"

#pragma mark -
#pragma mark - PYNetInOprPlugin
@implementation  PYNetInOprPlugin

///所有开始前的处理
- (void)oprBeforeRequestCreateWithInfo:(PYNetStartRequestInfo *)info
{
    NSMutableDictionary *addParameters = [NSMutableDictionary dictionary];

    //设置一些默认值
    [addParameters setValue:@"...."  forKey:@"version"];
    //other ...

    info.param = addParameters;
}

@end


#pragma mark -
#pragma mark - PYNetOutOprPlugin
@implementation PYNetOutOprPlugin

- (void)oprAfterFinishWithInfo:(PYNetFinishRequestInfo *)info
{
    //保证单一设备登陆
    BOOL isLoginAtOtherDevice = false;

    //isLoginAtOtherDevice = .....  //处理info信息进行判断

    info.needStop   = isLoginAtOtherDevice;
    info.stopReason = @"保证单一设备登陆";
}

@end


#pragma mark -
#pragma mark - PYEncryPlugin
@implementation PYEncryPlugin

//返回加密的字典数据 和dita
- (NSData *)_encryptionParamters:(NSDictionary *)paramters retTimeStamp:(NSString * *)retTimeStamp
{
    NSString *JSONString = _jsonStringFromParameters(paramters);
    NSString *key        = JSONString;
    *retTimeStamp = @"0.0.0";

    return [key dataUsingEncoding:NSUTF8StringEncoding];
}

static NSString *_jsonStringFromParameters(NSDictionary *parameters)
{
    NSError *error = nil;

    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];

    if (!error) {
        return [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

- (void)oprBeforeAllStartWithInfo:(PYNetStartRequestInfo *)info
{
    //如果是多部件请求体,按约定进行加密处理
    if (info.isMultipartBody == false) return;

    NSString *timeStamp   = nil;
    NSData   *encryptData = [self _encryptionParamters:info.param
                                          retTimeStamp:&timeStamp];

    NSDictionary *encryptDic = @{@"json" : encryptData};

    info.param = encryptDic;
}

- (void)oprAfterRequestCreateWithInfo:(PYNetStartRequestInfo *)info
{
    //如果不是多部件请求体,将加密param设置为http-body
    if (info.isMultipartBody == true) return;

    NSString *time = nil;

    NSData *data = [self _encryptionParamters:info.param
                                 retTimeStamp:&time];

    NSMutableDictionary *header = [NSMutableDictionary dictionaryWithDictionary:info.request.allHTTPHeaderFields];
    [header setObject:time forKey:@"time"];

    [info.request setAllHTTPHeaderFields:header];
    [info.request setHTTPBody:data];
}

@end


#pragma mark -
#pragma mark - PYHttpDNSPlugin
@implementation PYHttpDNSPlugin

- (void)afterURLRequestCreateOprWithStartInfo:(PYNetStartRequestInfo *)info
{
    NSString *urlStr = info.request.URL.absoluteString;

    NSRange range = [urlStr rangeOfString:@"www.abc.com"];
//    NSString* curIP = [RRHttpDNSService curIP];
    NSString *curIP = @"192.27.88.9";

    if (curIP && range.length > 0) {
        urlStr = [urlStr stringByReplacingCharactersInRange:range withString:curIP];

        if (range.location == 0) {
            urlStr = [@"http://" stringByAppendingString:urlStr];
        }

        NSMutableDictionary *allHeader = [NSMutableDictionary dictionaryWithDictionary:info.request.allHTTPHeaderFields];
        [allHeader setObject:curIP forKey:@"Host"];
        [info.request setAllHTTPHeaderFields:allHeader];
    }

    [info.request setURL:[NSURL URLWithString:urlStr]];
}

@end