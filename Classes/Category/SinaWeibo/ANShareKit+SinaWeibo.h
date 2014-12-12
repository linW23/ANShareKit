//
//  ANShareKit+SinaWeibo.h
//  ANShareKit
//
//  Created by liuyan on 14-9-15.
//  Copyright (c) 2014年 Candyan. All rights reserved.
//

#import "ANShareKit.h"
#import <Weibo/WeiboSDK.h>

@interface ANShareKit (SinaWeibo)

- (void)registerAppToWeiboAppID:(NSString *)weiboAppID;

@end
