//
//  PYNetCachePlugin.m
//  PYNetDemo
//
//  Created by yr on 16/6/21.
//  Copyright © 2016年 yr. All rights reserved.
//

#import "PYNetCachePlugin.h"

@implementation PYNetReadCacheDataPlugin

- (void)oprBeforeRequestCreateWithInfo:(PYNetStartRequestInfo *)info
{
    NSString *path     = info.path;
    NSString *methoder = info.param[@"reqname"];
    NSString *fileName = [NSString stringWithFormat:@"/%@_%@.json", path, methoder];
    NSString *fullPath = nil;

//    //从cache读取
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
//                                                         NSUserDomainMask,
//                                                         YES);
//    NSString *cacheDirectory = [paths objectAtIndex:0];
//    fullPath = [cacheDirectory stringByAppendingString:fileName];

    //从bundle的gg目录读取
    fullPath = [[[NSBundle mainBundle] bundlePath]
                stringByAppendingString:[NSString stringWithFormat:@"/gg%@", fileName]];
    if (fullPath.length == 0) return;

    NSData *cacheData = [NSData dataWithContentsOfFile:fullPath
                                               options:NSDataReadingMappedIfSafe
                                                 error:nil];
    if (cacheData == nil) return;

    id dataObj = [NSJSONSerialization JSONObjectWithData:cacheData
                                                 options:NSJSONReadingMutableContainers
                                                   error:nil];

    if (info.successBlock) {
        info.successBlock(dataObj);
    }

    info.needStop = YES;
}


@end



@implementation PYNetCacheDataPlugin


- (void)oprAfterFinishWithInfo:(PYNetFinishRequestInfo *)info
{
    NSString *path     = info.path;
    NSString *methoder = info.param[@"reqname"];
    NSString *fileName = [NSString stringWithFormat:@"/%@_%@.json", path, methoder];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSString *fullPath       = [cacheDirectory stringByAppendingString:fileName];

    NSData *cacheData = info.responseObject;
    if (![cacheData isKindOfClass:[NSData class]]) {
        cacheData = [NSJSONSerialization dataWithJSONObject:info.responseObject
                                                    options:NSJSONWritingPrettyPrinted
                                                      error:nil];
    }

    [cacheData writeToFile:fullPath atomically:YES];
}


@end