//
//  ANShareKit+Weixin.m
//  ANShareKit
//
//  Created by liuyan on 14-9-15.
//  Copyright (c) 2014年 Candyan. All rights reserved.
//

#import "ANShareKit+Weixin.h"

@implementation ANShareKit (Weixin)

#pragma mark - Register

- (void)registerAppToWxAppID:(NSString *)wxAppID UniversalLink:(NSString *)link {
    if (wxAppID && link) {
        [WXApi registerApp:wxAppID universalLink:link];
    }
}

@end
