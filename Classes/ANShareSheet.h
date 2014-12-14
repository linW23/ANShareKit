//
//  ANShareSheet.h
//  ANShareKit
//
//  Created by liuyan on 14-12-12.
//  Copyright (c) 2014年 Candyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ANShareType) {
    ANDoubanShareType = 1,
    ANWeiboShareType,
    ANWeixinShareType,
    ANWeixinFriendsShareType,
    ANQQShareType,
};

typedef NS_ENUM(NSInteger, ANShareSheetDismissMode) {
    ANShareSheetDismissModeNone,
    ANShareSheetDismissModeTap, // dismisses the share sheet when tap mask background view
};

@interface ANShareButton : UIControl

@property (weak, nonatomic) UIImageView *shareImageView;
@property (weak, nonatomic) UILabel *shareTitleLabel;

+ (ANShareButton *)shareButtonWithImage:(UIImage *)image title:(NSString *)title;

@end

@interface ANShareSheet : UIView <UIScrollViewDelegate> {
    NSMutableArray *_shareButtons;
    NSMutableDictionary *_buttonActionBlocks;

    UIButton *_cancelButton;
    UILabel *_titleLabel;
    UIScrollView *_shareContainer;
    UIPageControl *_sharePageControl;
    UIImageView *_backgroundImageView;
}

@property (nonatomic, weak, readonly) UIButton *cancelButton;
@property (nonatomic, weak, readonly) UILabel *titleLabel;
@property (nonatomic, weak, readonly) UIScrollView *shareContainer;
@property (nonatomic, weak, readonly) UIPageControl *sharePageControl;
@property (nonatomic, assign) ANShareSheetDismissMode dismissMode;

- (ANShareButton *)addShareButtonForType:(ANShareType)shareType action:(void (^)())action;
- (ANShareButton *)addShareButton:(NSString *)title icon:(UIImage *)icon action:(void (^)())action;

- (void)showInView:(UIView *)inView;

- (void)layoutShareSheet;

@end
