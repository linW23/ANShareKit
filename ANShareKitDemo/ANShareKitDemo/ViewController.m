//
//  ViewController.m
//  ANShareKitDemo
//
//  Created by liuyan on 14-12-12.
//  Copyright (c) 2014年 Canydan. All rights reserved.
//

#import "ViewController.h"
#import "ANShareSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIButton *showButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [self.view addSubview:showButton];
    [showButton setTitle:@"显示" forState:UIControlStateNormal];
    [showButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    showButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) + 200);

    [showButton addTarget:self action:@selector(an_showShareSheet) forControlEvents:UIControlEventTouchUpInside];

    self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)an_showShareSheet
{
    ANShareSheet *shareSheet = [[ANShareSheet alloc] init];

    [shareSheet addShareButtonForType:ANWeiboShareType action:^{}];

    [shareSheet addShareButtonForType:ANWeixinShareType
                               action:^{

                               }];

    [shareSheet addShareButtonForType:ANWeixinFriendsShareType action:^{}];

    [shareSheet showInView:self.view];
}

@end
