//
//  PYNetClientImp_AF.h
//
//  Created by yr on 15/12/24.
//  Copyright © 2015年 yr. All rights reserved.
//

#import "PYNetClientImpPro.h"

/**
 * 用AFNetworking库实现PYNetClientImpPro协议
 */
@interface PYNetClientImp_AF : NSObject <PYNetClientImpPro>

- (id)initWithBaseURL:(NSURL *)url;


@end