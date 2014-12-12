//
//  DOUShareSheet.m
//  ANShareKit
//
//  Created by liuyan on 14-12-12.
//  Copyright (c) 2014年 Candyan. All rights reserved.
//

#import "ANShareSheet.h"
#import <Masonry/Masonry.h>
#import <FXBlurView/FXBlurView.h>

@interface UIColor (DOUShareSheet)

+ (UIColor *)an_colorWithHex:(NSUInteger)rgbHexValue;

@end

@implementation UIColor (DOUShareSheet)

+ (UIColor *)an_colorWithHex:(NSUInteger)rgbHexValue
{
    return [UIColor colorWithRed:((float)((rgbHexValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((rgbHexValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(rgbHexValue & 0xFF)) / 255.0
                           alpha:1.0];
}

@end

@interface UIView (ANShareSheetSnapshot)

- (UIImage *)snapshotWithFrame:(CGRect)frame;

@end

@implementation UIView (ANShareSheetSnapshot)

- (UIImage *)snapshotWithFrame:(CGRect)frame
{
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, self.contentScaleFactor);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, -frame.origin.x, -frame.origin.y);
    [self.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation ANShareButton

+ (ANShareButton *)shareButtonWithImage:(UIImage *)image title:(NSString *)title
{
    ANShareButton *button = [[ANShareButton alloc] initWithFrame:CGRectZero];
    button.shareImageView.image = image;
    button.shareTitleLabel.text = title;

    return button;
}

- (CGSize)intrinsicContentSize
{
    CGSize imageViewIntrinsicContentSize = self.shareImageView.intrinsicContentSize;
    CGFloat width = imageViewIntrinsicContentSize.width;
    CGFloat height = imageViewIntrinsicContentSize.height + 4 + self.shareTitleLabel.intrinsicContentSize.height;
    return CGSizeMake(width, height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.shareImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds));

    CGSize titleIntrinsicContentSize = self.shareTitleLabel.intrinsicContentSize;
    self.shareTitleLabel.frame = CGRectMake((CGRectGetWidth(self.bounds) - titleIntrinsicContentSize.width) / 2.0,
                                            CGRectGetHeight(self.bounds) - titleIntrinsicContentSize.height,
                                            titleIntrinsicContentSize.width, titleIntrinsicContentSize.height);
}

- (UIImageView *)shareImageView
{
    if (_shareImageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _shareImageView = imageView;
        [self addSubview:_shareImageView];

        _shareImageView.userInteractionEnabled = NO;
        [_shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_width);
        }];
    }
    return _shareImageView;
}

- (UILabel *)shareTitleLabel
{
    if (_shareTitleLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:label];
        _shareTitleLabel = label;

        _shareTitleLabel.userInteractionEnabled = NO;
        _shareTitleLabel.textAlignment = NSTextAlignmentCenter;
        _shareTitleLabel.font = [UIFont fontWithName:@"helvetica" size:12];

        [_shareTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.centerX.equalTo(self);
        }];
    }
    return _shareTitleLabel;
}

@end

@implementation ANShareSheet

#pragma mark - init

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0)];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _buttonActionBlocks = [NSMutableDictionary dictionary];
        _shareButtons = [NSMutableArray array];

        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_backgroundImageView];
    }
    return self;
}

#pragma mark - Property

- (UIButton *)cancelButton
{
    if (_cancelButton == nil) {
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectZero];
        cancelButton.backgroundColor = [UIColor clearColor];
        [cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor an_colorWithHex:0x9b9b9b] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont fontWithName:@"helvetica-Bold" size:16];

        [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = cancelButton;

        [self addSubview:cancelButton];
    }
    return _cancelButton;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"helvetica-Bold" size:18.0f];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        titleLabel.textColor = [UIColor whiteColor];

        titleLabel.text = @"分享";

        _titleLabel = titleLabel;
        [self addSubview:titleLabel];
    }
    return _titleLabel;
}

- (UIScrollView *)shareContainer
{
    if (_shareContainer == nil) {
        UIScrollView *container = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _shareContainer = container;
        _shareContainer.backgroundColor = [UIColor clearColor];
        _shareContainer.pagingEnabled = YES;
        _shareContainer.showsHorizontalScrollIndicator = NO;
        _shareContainer.showsVerticalScrollIndicator = NO;

        _shareContainer.delegate = self;

        [self addSubview:_shareContainer];
    }
    return _shareContainer;
}

- (UIPageControl *)sharePageControl
{
    if (_sharePageControl == nil) {
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _sharePageControl = pageControl;

        [self addSubview:_sharePageControl];
    }
    return _sharePageControl;
}

#pragma mark - layout

- (void)layoutShareSheet
{
    CGRect frame = self.frame;
    frame.size.height = 257;
    self.frame = frame;

    _backgroundImageView.frame = self.bounds;

    NSUInteger pageCount = ceilf(_shareButtons.count / 3.0);

    self.titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 59);
    self.shareContainer.frame = CGRectMake(0, 59, CGRectGetWidth(self.bounds), 139);
    self.cancelButton.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 59, CGRectGetWidth(self.bounds), 59);

    self.sharePageControl.frame =
        CGRectMake(0, CGRectGetMinY(self.cancelButton.frame) - 4 - 9, CGRectGetWidth(self.bounds), 9);

    self.sharePageControl.hidden = (pageCount <= 1);
    self.sharePageControl.numberOfPages = pageCount;
    self.sharePageControl.currentPage = 0;

    static CGFloat const kSharedButtonGap = 50.0f;
    CGFloat totalWidth = MIN(_shareButtons.count, 3) * 51 + (MIN(_shareButtons.count, 3) - 1) * kSharedButtonGap;

    CGFloat initalOriginX = (CGRectGetWidth(self.bounds) - totalWidth) / 2;

    [_shareButtons enumerateObjectsUsingBlock:^(UIButton *shareButton, NSUInteger idx, BOOL *stop) {
        CGRect buttonFrame = shareButton.frame;
        buttonFrame.origin.x =
            initalOriginX + (idx % 3) * (50 + kSharedButtonGap) + floorf(idx / 3) * CGRectGetWidth(self.bounds);
        buttonFrame.size.height = 70;
        buttonFrame.size.width = 50;
        shareButton.frame = buttonFrame;

        CGPoint buttonCenter = shareButton.center;
        buttonCenter.y = CGRectGetMidY(self.shareContainer.bounds);
        shareButton.center = buttonCenter;
    }];
}

#pragma mark - Add Button

- (ANShareButton *)an_shareButtonWithTitle:(NSString *)title icon:(UIImage *)icon
{
    ANShareButton *shareButton = [ANShareButton shareButtonWithImage:icon title:title];
    [shareButton addTarget:self
                    action:@selector(an_shareButtonTapAction:)
          forControlEvents:UIControlEventTouchUpInside];
    return shareButton;
}

#pragma mark - Action Handler

- (void)an_shareButtonTapAction:(UIButton *)sender
{
    void (^actionBlock)() = _buttonActionBlocks[[NSValue valueWithNonretainedObject:sender]];
    if (actionBlock)
        actionBlock();
    [self dismiss];
}

#pragma mark - add

- (ANShareButton *)addShareButtonForType:(ANShareType)shareType action:(void (^)())action
{
    switch (shareType) {
        case ANDoubanShareType:
            return [self addShareButton:@"豆瓣" icon:nil action:action];

        case ANQQShareType:
            return [self addShareButton:@"QQ" icon:nil action:action];

        case ANWeiboShareType:
            return [self addShareButton:@"新浪微博" icon:[UIImage imageNamed:@"sina_weibo"] action:action];

        case ANWeixinShareType:
            return [self addShareButton:@"微信" icon:[UIImage imageNamed:@"wechat"] action:action];

        case ANWeixinFriendsShareType:
            return [self addShareButton:@"朋友圈" icon:[UIImage imageNamed:@"weixin_timeline"] action:action];
    }
}

- (ANShareButton *)addShareButton:(NSString *)title icon:(UIImage *)icon action:(void (^)())action
{
    ANShareButton *shareButton = [self an_shareButtonWithTitle:title icon:icon];
    if (action) {
        [_buttonActionBlocks setObject:[action copy] forKey:[NSValue valueWithNonretainedObject:shareButton]];
    }
    [_shareButtons addObject:shareButton];
    [self.shareContainer addSubview:shareButton];
    return shareButton;
}

#pragma mark - Show & Dismiss

- (void)showInView:(UIView *)inView
{
    if (_shareButtons.count == 0 || [self isDescendantOfView:inView])
        return;

    self.backgroundColor = [UIColor blackColor];

    [self setFrame:CGRectMake(0, inView.frame.size.height, inView.frame.size.width, 0)];
    [self setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];

    [self layoutShareSheet];

    UIButton *backgroundTrigger = [[UIButton alloc] initWithFrame:inView.bounds];
    [backgroundTrigger setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [backgroundTrigger addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

    [backgroundTrigger setUserInteractionEnabled:NO];

    [inView addSubview:backgroundTrigger];
    [backgroundTrigger addSubview:self];

    backgroundTrigger.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.36];

    UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
    [self insertSubview:maskView aboveSubview:_backgroundImageView];
    maskView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];

    UIImage *snapshot = [inView
        snapshotWithFrame:CGRectMake(0, CGRectGetHeight(inView.bounds) - 257, CGRectGetWidth(inView.bounds), 257)];
    _backgroundImageView.image = [snapshot blurredImageWithRadius:10 iterations:50 tintColor:[UIColor blackColor]];

    [UIView animateWithDuration:.2f
        delay:0
        options:UIViewAnimationOptionCurveEaseOut
        animations:^{
            CGRect frame = self.frame;
            frame.origin.y = CGRectGetHeight(inView.bounds) - self.frame.size.height;
            self.frame = frame;
        }
        completion:^(BOOL finished) { [backgroundTrigger setUserInteractionEnabled:YES]; }];
}

- (void)dismiss
{
    [self.superview setUserInteractionEnabled:NO];
    [UIView animateWithDuration:.2f
        delay:0
        options:UIViewAnimationOptionCurveEaseIn
        animations:^{
            CGRect frame = self.frame;
            frame.origin.y = self.superview.bounds.size.height;
            self.frame = frame;
        }
        completion:^(BOOL finished) {
            [self.superview removeFromSuperview];
            [self removeFromSuperview];
        }];
}

#pragma mark - UIScroll Delegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.sharePageControl.currentPage = floorf(targetContentOffset->x / CGRectGetWidth(self.bounds));
}

@end
