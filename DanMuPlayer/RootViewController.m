//
//  ViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/28.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "RootViewController.h"
#import "RecommendCollectionViewController.h"
#import "ChannelCollectionViewController.h"
#import "SortTableViewController.h"

@interface RootViewController ()<UIScrollViewDelegate>



@end

@implementation RootViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
#warning contentOffset go ONE PAGE **********************
//    NSLog(@"偏移");
    
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        self.mainScrollView.contentOffset = CGPointMake(kScreenWidth * 1 , 0);
        // 注册成为偏移量通知观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentOffset:) name:@"changeContentOffset" object:nil];
    });
    
}
// 即将显示时
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundColor:[kThemeColor colorWithAlphaComponent:1]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainScrollView.delegate = self;
    
    // 配置btn
    [self setUpBtn];
    
}

/** 偏移通知事件 */
- (void)changeContentOffset:(NSNotification *)sender {
    
    NSInteger channel_Id = [sender.userInfo[@"channel_Id"] integerValue];
    
    NSInteger index = 5;
    switch (channel_Id) {
        case 155:
            index = 2;
            break;
        case 60:
            index = 3;
            break;
        case 63:
            index = 4;
            break;
        default:
            break;
    }
    // 偏移
    self.mainScrollView.contentOffset = CGPointMake(kScreenWidth * index, 0);
    // 改变被选中的btn
    [self changeTitleColorForBtn:index];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
#warning need change ******************
    if ([segue.identifier isEqualToString:@"about_segue"]) {  // 关注
        
        
        
    } else if ([segue.identifier isEqualToString:@"recommend_segue"]) {  // 推荐
        
        RecommendCollectionViewController *recommendVC = segue.destinationViewController;
//        recommendVC.mainURLStr = kRegionsURLStr;
//        NSLog(@"segue");
        
    } else if ([segue.identifier isEqualToString:@"comic_segue"]) {  // 番剧
        
        RecommendCollectionViewController *recommendVC = segue.destinationViewController;
//        recommendVC.mainURLStr = [NSString stringWithFormat:kRegionsWithBelongURLStr,(long)155];
//        NSLog(@"segue");
        
    } else if ([segue.identifier isEqualToString:@"entertainment_segue"]) {  // 娱乐
        
        RecommendCollectionViewController *recommendVC = segue.destinationViewController;
//        recommendVC.mainURLStr = [NSString stringWithFormat:kRegionsWithBelongURLStr,(long)60];
//        NSLog(@"segue");
        
    } else if ([segue.identifier isEqualToString:@"article_segue"]) {  // 文章
        
        RecommendCollectionViewController *recommendVC = segue.destinationViewController;
        recommendVC.mainURLStr = [NSString stringWithFormat:kRegionsWithBelongURLStr,(long)63];
//        NSLog(@"segue");
        
    } else if ([segue.identifier isEqualToString:@"channel_segue"]) {  // 频道
        
        ChannelCollectionViewController *channelVC = segue.destinationViewController;
//        channelVC.mainURLStr = kChannelsURLStr;
//        NSLog(@"segue");
        
    } else if ([segue.identifier isEqualToString:@"sort_segue"]) {  // 综合排行榜
        
        SortTableViewController *sortVC = segue.destinationViewController;
//        [sortVC loadDataWithURLStr:[NSString stringWithFormat:kSortMainURLStr,(long)1]];
        
    }
}

/** 标签的点击事件 */
- (IBAction)clickMark:(UIButton *)sender {
    
    // tag值 140 ~ 145
    
    self.mainScrollView.contentOffset = CGPointMake(kScreenWidth * (sender.tag - 140), 0);
    
    [self changeTitleColorForBtn:sender.tag - 140];
    
}

#pragma mark <UIScrollViewDelegate>

/** 当减速结束时 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = self.mainScrollView.contentOffset.x / kScreenWidth;
    [self changeTitleColorForBtn:index];
    
//    NSLog(@"%ld",index);
}
/** 改变btn的颜色 */
- (void)changeTitleColorForBtn:(NSInteger)index {
    
    for (int i = 0; i < 6; i++) {
        UIButton *btn = [self.view viewWithTag:(140 + i)];
        if (i == index) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
}
/** 设置btn的默认属性 */
- (void)setUpBtn {
    
    for (int i = 140; i < 146; i++) {
        UIButton *btn = [self.view viewWithTag:i];
        [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
