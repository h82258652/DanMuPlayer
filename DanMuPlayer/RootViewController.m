//
//  ViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/28.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.mainScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    NSLog(@"偏移");
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"%@",NSStringFromCGPoint(self.mainScrollView.contentOffset));
//    self.mainScrollView.contentOffset = CGPointMake(kScreenWidth * 2, 0);
//    NSLog(@"%@",NSStringFromCGPoint(self.mainScrollView.contentOffset));
//    NSLog(@"偏移");
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
