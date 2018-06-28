//
//  ANShareKit+Tencent.h
//  ANShareKit
//
//  Created by liuyan on 14-9-15.
//  Copyright (c) 2014年 Candyan. All rights reserved.
//

#import "ANShareKit.h"
#import <FBTencentOpenAPI/TencentOAuth.h>
#import <FBTencentOpenAPI/QQApiInterface.h>

@interface ANShareKit (Tencent)

- (void)registerAppToTencentAppID:(NSString *)tencentAppID;

@end
