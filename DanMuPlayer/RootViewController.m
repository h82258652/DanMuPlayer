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

@interface RootViewController ()<UIScrollViewDelegate>



@end

@implementation RootViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
#warning contentOffset go ONE PAGE **********************
    self.mainScrollView.contentOffset = CGPointMake(kScreenWidth , 0);
    NSLog(@"偏移");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainScrollView.delegate = self;
    
    // 配置btn
    [self setUpBtn];
    
    // 监测sroll的偏移量
    [self.mainScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"about_segue"]) {  // 关注
        
        
        
    } else if ([segue.identifier isEqualToString:@"recommend_segue"]) {  // 推荐
        
        RecommendCollectionViewController *recommendVC = segue.destinationViewController;
        recommendVC.mainURLStr = kRegionsURLStr;
//        NSLog(@"segue");
        
    } else if ([segue.identifier isEqualToString:@"comic_segue"]) {  // 番剧
        
        RecommendCollectionViewController *recommendVC = segue.destinationViewController;
        recommendVC.mainURLStr = [NSString stringWithFormat:kRegionsWithBelongURLStr,155];
//        NSLog(@"segue");
        
    } else if ([segue.identifier isEqualToString:@"entertainment_segue"]) {  // 娱乐
        
        RecommendCollectionViewController *recommendVC = segue.destinationViewController;
        recommendVC.mainURLStr = [NSString stringWithFormat:kRegionsWithBelongURLStr,60];
//        NSLog(@"segue");
        
    } else if ([segue.identifier isEqualToString:@"article_segue"]) {  // 文章
        
        RecommendCollectionViewController *recommendVC = segue.destinationViewController;
        recommendVC.mainURLStr = [NSString stringWithFormat:kRegionsWithBelongURLStr,63];
//        NSLog(@"segue");
        
    } else if ([segue.identifier isEqualToString:@"channel_segue"]) {  // 频道
        
        ChannelCollectionViewController *channelVC = segue.destinationViewController;
        channelVC.mainURLStr = kChannelsURLStr;
//        NSLog(@"segue");
        
    }
}

/** 标签的点击事件 */
- (IBAction)clickMark:(UIButton *)sender {
    
    // tag值 140 ~ 145
    
    self.mainScrollView.contentOffset = CGPointMake(kScreenWidth * (sender.tag - 140), 0);
    
    [self changeTitleColorForBtn:sender.tag - 140];
    
}
/** 监测滚动视图的偏移量 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    
    
}

#pragma mark <UIScrollViewDelegate>
//  当拖动停止时
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    
//    NSInteger index = self.mainScrollView.contentOffset.x / kScreenWidth;
//    
//    
//}
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
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
