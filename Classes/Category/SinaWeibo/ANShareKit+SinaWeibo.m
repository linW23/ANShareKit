//
//  ANShareKit+SinaWeibo.m
//  ANShareKit
//
//  Created by liuyan on 14-9-15.
//  Copyright (c) 2014年 Candyan. All rights reserved.
//

#import "ANShareKit+SinaWeibo.h"

@implementation ANShareKit (SinaWeibo)

#pragma mark - Register

- (void)registerAppToWeiboAppID:(NSString *)weiboAppID
{
    if (weiboAppID)
        [WeiboSDK registerApp:weiboAppID];
}

@end
