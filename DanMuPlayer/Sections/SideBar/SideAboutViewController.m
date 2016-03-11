//
//  SideAboutViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/11.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "SideAboutViewController.h"

@interface SideAboutViewController ()

@end

@implementation SideAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)dismissBeforePage:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
