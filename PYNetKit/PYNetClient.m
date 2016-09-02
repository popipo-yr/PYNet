//
//  PYNetClient.m
//
//  Created by yr on 15/12/24.
//  Copyright © 2015年 yr. All rights reserved.
//

#import "PYNetClient.h"

#define _M_SafeCall(block, param) if (nil != block) {block(param); }

@implementation PYNetClient {
    NSMutableArray<id<PYNetStartRequestPro> >  *_inOprs;
    NSMutableArray<id<PYNetFinishRequestPro> > *_outOprs;

    id<PYNetClientImpPro> _realClient;
}

#pragma mark - Outer

- (id)initWithRealImp:(id<PYNetClientImpPro>)realImp;
{
    if (self = [super init]) {
        _inOprs     = [NSMutableArray array];
        _outOprs    = [NSMutableArray array];
        _realClient = realImp;
    }

    return self;
}


- (void)addInOpr:(id<PYNetStartRequestPro>)inOpr
{
    [_inOprs addObject:inOpr];
}


- (void)addOutOpr:(id<PYNetFinishRequestPro>)outOpr
{
    [_outOprs addObject:outOpr];
}


- (void)removeInOpr:(id<PYNetStartRequestPro>)inOpr
{
    [_inOprs removeObject:inOpr];
}


- (void)removeOutOpr:(id<PYNetFinishRequestPro>)outOpr
{
    [_outOprs removeObject:outOpr];
}


- (void)setDefaultHeader:(NSString *)header value:(NSString *)value
{
    [_realClient setDefaultHeader:header value:value];
}


//////////////////////////

- (NSURLSessionTask *)postFileTo:(NSString *)path
                      parameters:(NSDictionary *)parameters
                    fileEntities:(NSArray<PYNetFile *> *)fileEntities
                    successBlock:(void (^)(NSDictionary *res))successBlock
                    failureBlock:(void (^)(NSDictionary *res))failureBlock
                    netFailBlock:(void (^)(NSError *error))netFailBlock
{
    PYNetStartRequestInfo *startInfo = [self _createReqInfoWithPath:path
                                                         parameters:parameters
                                                       successBlock:successBlock
                                                       failureBlock:failureBlock];
    startInfo.isMultipartBody = YES;

    [self _oprBeforeAllStartWithInfo:startInfo];
    if (startInfo.needStop) return nil;

    NSMutableURLRequest *req = [_realClient requestWithMethod:@"POST"
                                                    URLString:path
                                                   parameters:startInfo.param
                                                        files:fileEntities];

    [self _oprAfterRequestCreate:req withInfo:startInfo];
    if (startInfo.needStop) return nil;

    return [self _startJsonRequest:req
                          withPath:path
                        parameters:parameters
                      successBlock:successBlock
                      failureBlock:failureBlock
                      netFailBlock:netFailBlock];
}


- (NSURLSessionTask *)postTo:(NSString *)path
                  parameters:(NSDictionary *)parameters
                successBlock:(void (^)(NSDictionary *res))successBlock
                failureBlock:(void (^)(NSDictionary *res))failureBlock
                netFailBlock:(void (^)(NSError *error))netFailBlock
{
    PYNetStartRequestInfo *startInfo = [self _createReqInfoWithPath:path
                                                         parameters:parameters
                                                       successBlock:successBlock
                                                       failureBlock:failureBlock];

    [self _oprBeforeAllStartWithInfo:startInfo];
    if (startInfo.needStop) return nil;

    NSMutableURLRequest *request = [_realClient requestWithMethod:@"POST"
                                                        URLString:path
                                                       parameters:parameters];

    [self _oprAfterRequestCreate:request withInfo:startInfo];
    if (startInfo.needStop) return nil;

    return [self _startJsonRequest:request
                          withPath:path
                        parameters:parameters
                      successBlock:successBlock
                      failureBlock:failureBlock
                      netFailBlock:netFailBlock];
}


///下载
- (NSURLSessionTask *)getFileAt:(NSString *)path
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    PYNetStartRequestInfo *startInfo = [self _createReqInfoWithPath:path
                                                         parameters:parameters
                                                       successBlock:success
                                                       failureBlock:nil];

    [self _oprBeforeAllStartWithInfo:startInfo];
    if (startInfo.needStop) return nil;

    NSMutableURLRequest *request = [_realClient requestWithMethod:@"GET"
                                                        URLString:path
                                                       parameters:parameters];

    [self _oprAfterRequestCreate:request withInfo:startInfo];
    if (startInfo.needStop) return nil;

    return [self _createAndStartTaskWithRequest:request
                                netSuccessBlock:success
                                   netFailBlock:failure];
}


#pragma mark - Private

///开始json数据的请求
- (NSURLSessionTask *)_startJsonRequest:(NSMutableURLRequest *)request
                               withPath:(NSString *)path
                             parameters:(NSDictionary *)parameters
                           successBlock:(void (^)(NSDictionary *res))successBlock
                           failureBlock:(void (^)(NSDictionary *res))failureBlock
                           netFailBlock:(void (^)(NSError *error))netFailBlock
{
    void (^httpSuccessBlock)(id) = ^(id responseObject) {
        PYNetFinishRequestInfo *finishInfo = nil;

        finishInfo = [self _oprAfterFinishWithResponser:responseObject
                                               withPath:path
                                             parameters:parameters];

        if (finishInfo.needStop == YES) {
            _M_SafeCall(netFailBlock, [NSError errorWithDomain:finishInfo.stopReason
                                                          code:0
                                                      userInfo:nil]);
            return;
        }

        NSDictionary *serverData = responseObject;

        if ([responseObject isKindOfClass:[NSData class]]) {
            serverData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
        }

        if (![serverData isKindOfClass:[NSDictionary class]]) {
            serverData = @{};
        }

        if ([_realClient isSuccessStatusOfServeData:serverData]) {
            _M_SafeCall(successBlock, serverData);
        } else {
            _M_SafeCall(failureBlock, serverData);
        }
    };

    return [self _createAndStartTaskWithRequest:request
                                netSuccessBlock:httpSuccessBlock
                                   netFailBlock:netFailBlock];
}


///创建task,并运行
- (NSURLSessionDataTask *)_createAndStartTaskWithRequest:(NSURLRequest *)request
                                         netSuccessBlock:(void (^)(id responseObject))netSB
                                            netFailBlock:(void (^)(NSError *error))netFB
{
    NSURLSessionDataTask *task;
    task = [_realClient dataTaskWithRequest:request
                          completionHandler:^(NSURLResponse *response,
                                              id responseObject,
                                              NSError *error) {
                if (error == nil) {
                    _M_SafeCall(netSB, responseObject);
                } else {
                    _M_SafeCall(netFB, error);
                }
            }];

    [task resume];

    return task;
}


#pragma mark -

- (PYNetStartRequestInfo *)_createReqInfoWithPath:(NSString *)path
                                       parameters:(NSDictionary *)parameters
                                     successBlock:(void (^)(NSDictionary *res))successBlock
                                     failureBlock:(void (^)(NSDictionary *res))failureBlock
{
    PYNetStartRequestInfo *reqInfo = [PYNetStartRequestInfo new];
    reqInfo.successBlock = successBlock;
    reqInfo.failureBlock = failureBlock;
    reqInfo.param        = parameters;
    reqInfo.path         = path;

    return reqInfo;
}


///进行需要的处理在一切开始,并创建RequestInfo
- (void)_oprBeforeAllStartWithInfo:(PYNetStartRequestInfo *)info
{
    for (id<PYNetStartRequestPro> opr in _inOprs) {
        if ([opr respondsToSelector:@selector(oprBeforeRequestCreateWithInfo:)]) {
            [opr oprBeforeRequestCreateWithInfo:info];
            if (info.needStop) break;
        }
    }
}


///进行需要的处理在request创建后
- (void)_oprAfterRequestCreate:(NSMutableURLRequest *)req
                      withInfo:(PYNetStartRequestInfo *)info
{
    info.request = req;

    for (id<PYNetStartRequestPro> opr in _inOprs) {
        if ([opr respondsToSelector:@selector(oprAfterRequestCreateWithInfo:)]) {
            [opr oprAfterRequestCreateWithInfo:info];
            if (info.needStop) break;
        }
    }
}


///进行需要的处理在http请求完成
- (PYNetFinishRequestInfo *)_oprAfterFinishWithResponser:(id)responseObject
                                                withPath:(NSString *)path
                                              parameters:(NSDictionary *)parameters
{
    PYNetFinishRequestInfo *finishInfo = [PYNetFinishRequestInfo new];
    finishInfo.responseObject = responseObject;
    finishInfo.path           = path;
    finishInfo.param          = parameters;

    for (id<PYNetFinishRequestPro> opr in _outOprs) {
        if ([opr respondsToSelector:@selector(oprAfterFinishWithInfo:)]) {
            [opr oprAfterFinishWithInfo:finishInfo];
            if (finishInfo.needStop) break;
        }
    }

    return finishInfo;
}


@end