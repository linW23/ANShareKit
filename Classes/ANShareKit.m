//
//  ANShareKit.m
//  ANShareKit
//
//  Created by liuyan on 14-12-12.
//  Copyright (c) 2014年 Candyan. All rights reserved.
//

#import "ANShareKit.h"

@implementation ANShareKit

#pragma Singleton

+ (ANShareKit *)sharedKit
{
    static ANShareKit *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = [[ANShareKit alloc] init]; });
    return instance;
}

@end
