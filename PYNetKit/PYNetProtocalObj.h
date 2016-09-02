//
//  PYNetProtocalObj.h
//  PYNetDemo
//
//  Created by yr on 16/6/20.
//  Copyright © 2016年 yr. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 开始网络请求信息
 */
@interface PYNetStartRequestInfo : NSObject

@property (nonatomic, strong) NSDictionary *header;  //请求header
@property (nonatomic, strong) NSDictionary *param;   //请求参数
@property (nonatomic, strong) NSString     *path;    //请求路径

@property (nonatomic, copy)   void (^successBlock)(NSDictionary *res); //请求成功回调
@property (nonatomic, copy)   void (^failureBlock)(NSDictionary *res); //请求失败回调

@property (nonatomic, assign) BOOL needStop; //当具体一个操作,修改为true的时候,将停止处理和请求
@property (nonatomic, assign) BOOL isMultipartBody; //是否为多部件请求体

@property (nonatomic, strong) NSMutableURLRequest *request;

@end



/**
 * 结束网络请求信息
 */
@interface PYNetFinishRequestInfo : NSObject

@property (nonatomic, strong) NSDictionary *param;   //请求参数
@property (nonatomic, strong) NSString     *path;    //请求路径

@property (nonatomic, strong) id       responseObject; //请求返回数据
@property (nonatomic, assign) BOOL     needStop;      //当具体一个操作,修改为true的时候,将停止处理和请求
@property (nonatomic, strong) NSString *stopReason;    //停止处理的原因

@end



/**
 * 网络文件
 */
@interface PYNetFile : NSObject

@property (nonatomic, strong) NSString *name;      //接收name
@property (nonatomic, strong) NSString *fileName;  //文件名
@property (nonatomic, strong) NSString *type;      //文件类型
@property (nonatomic, strong) NSData   *data;      //文件数据

@end