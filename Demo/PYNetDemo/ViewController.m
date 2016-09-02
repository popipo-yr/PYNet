//
//  ViewController.m
//  PYNet
//
//  Created by yr on 16/6/7.
//  Copyright © 2016年 yr. All rights reserved.
//

#import "ViewController.h"

#import "PYNetKit.h"
#import "PYNetPlugins.h"
#import "PYNetCachePlugin.h"
#import "PYNetClientImp_AF.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    PYNetClient *client = [[self class] client];
    [client postTo:@"" parameters:nil successBlock:nil failureBlock:nil netFailBlock:nil];
}


/////////////////////////
+ (PYNetClient *)client
{
    static PYNetClient *client = nil;

    dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        PYNetClientImp_AF *af = [[PYNetClientImp_AF alloc] initWithBaseURL:nil];
        
        client = [[PYNetClient alloc] initWithRealImp:af];

        [client addInOpr:[PYNetInOprPlugin new]];
        [client addInOpr:[PYEncryPlugin new]];
        [client addInOpr:[PYHttpDNSPlugin new]];

        [client addOutOpr:[PYNetOutOprPlugin new]];

        //缓存测试数据
        [client addOutOpr:[PYNetCacheDataPlugin new]];
        [client addInOpr:[PYNetReadCacheDataPlugin new]];
    });

    return client;
}


@end