//
//  PYNetRequestProtocol.h
//
//  Created by yr on 16/5/11.
//  Copyright © 2016年 yr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYNetProtocalObj.h"


/**
 *  开始网络请求前,需要执行操作的协议
 */
@protocol  PYNetStartRequestPro  <NSObject>

@optional
///所有开始前的处理
- (void)oprBeforeRequestCreateWithInfo:(PYNetStartRequestInfo *)info;

///在创建request后的处理
- (void)oprAfterRequestCreateWithInfo:(PYNetStartRequestInfo *)info;

@end



/**
 *  网络请求结束,需要执行chu的协议
 */
@protocol  PYNetFinishRequestPro  <NSObject>

@optional
///请求结束后的处理
- (void)oprAfterFinishWithInfo:(PYNetFinishRequestInfo *)info;

@end


