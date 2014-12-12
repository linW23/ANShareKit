//
//  ANShareKit.h
//  ANShareKit
//
//  Created by liuyan on 14-12-12.
//  Copyright (c) 2014年 Candyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANShareSheet.h"

@interface ANShareKit : NSObject

+ (ANShareKit *)sharedKit;

@end

#ifdef AN_WEIXIN_SHARE
#import "ANShareKit+Weixin.h"
#endif

#ifdef AN_SINAWB_SHARE
#import "ANShareKit+SinaWeibo.h"
#endif

#ifdef AN_TENCENT_SHARE
#import "ANShareKit+Tencent.h"
#endif
