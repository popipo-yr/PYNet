//
//  PYNetCachePlugin.h
//  PYNetDemo
//
//  Created by yr on 16/6/21.
//  Copyright © 2016年 yr. All rights reserved.
//

#import "PYNetRequestProtocol.h"

/**
 *  用于读取本地的文件作为请求的返回数据,主要用于调试时候不用从服务器请求数据
 */
@interface PYNetReadCacheDataPlugin : NSObject <PYNetStartRequestPro>

@end

/**
 *  用于将服务器获取的数据存于本地,用于后面读取
 */
@interface PYNetCacheDataPlugin : NSObject <PYNetFinishRequestPro>

@end




