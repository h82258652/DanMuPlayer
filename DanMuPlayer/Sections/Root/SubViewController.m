//
//  SubViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/29.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "SubViewController.h"
#import "RecommendCollectionViewController.h"

@interface SubViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *FlagScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *MainScrollView;

@property (nonatomic,strong)NSMutableArray *flagArray;  // 标签数组



@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 自定义方法

/** 使用主model创建 */
- (void)setUpWithRecommendModel:(RecommendModel *)model {
    
}

/** 使用频道model创建 */
- (void)setUpWithChannelModel:(ChannelModel *)model {
    
    
    
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
