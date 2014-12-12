//
//  ANShareKit+Tencent.m
//  ANShareKit
//
//  Created by liuyan on 14-9-15.
//  Copyright (c) 2014年 Candyan. All rights reserved.
//

#import "ANShareKit+Tencent.h"
#import <objc/runtime.h>

@implementation ANShareKit (Tencent)

#pragma mark - Register
- (void)registerAppToTencentAppID:(NSString *)tencentAppID
{
    static char gTencentOAuthHandler;
    if (tencentAppID) {
        TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:tencentAppID andDelegate:nil];

        // must handle a tencent oauth instance.
        objc_setAssociatedObject(self, &gTencentOAuthHandler, tencentOAuth, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
