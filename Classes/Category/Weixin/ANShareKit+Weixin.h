//
//  ANShareKit+Weixin.h
//  ANShareKit
//
//  Created by liuyan on 14-9-15.
//  Copyright (c) 2014年 Candyan. All rights reserved.
//

#import "ANShareKit.h"
#import <XXWeChatSDK/WXApi.h>

@interface ANShareKit (Weixin)

- (void)registerAppToWXAppID:(NSString *)wxAppID;

@end
