//
//  PYNetPlugins.h
//
//  Created by yr on 15/12/24.
//  Copyright © 2015年 yr. All rights reserved.
//


#import "PYNetRequestProtocol.h"

/**
 *  添加固定的数据
 */
@interface PYNetInOprPlugin : NSObject <PYNetStartRequestPro>
@end

/**
 *  读取固定的数据
 */
@interface PYNetOutOprPlugin : NSObject <PYNetFinishRequestPro>
@end


/**
 *  参数加密处理
 */
@interface PYEncryPlugin : NSObject <PYNetStartRequestPro>
@end

/**
 * HttpDNS处理
 */
@interface PYHttpDNSPlugin : NSObject <PYNetStartRequestPro>
@end