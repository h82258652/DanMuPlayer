//
//  VideoListCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/2.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "VideoListCollectionViewCell.h"
#import "VideoListSubCollectionView.h"


@interface VideoListCollectionViewCell ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *btnScrollView;  // btn所在的滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *collectionScrollView; // collectionView所在的滚动视图

@property (nonatomic,strong)DetailVideoModel *mainModel;  // 主model

@property (nonatomic,assign)BOOL isHadSubView;

@end

@implementation VideoListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    NSLog(@"aaa");
    self.collectionScrollView.pagingEnabled = YES;
    self.collectionScrollView.showsVerticalScrollIndicator = NO;
    self.collectionScrollView.showsHorizontalScrollIndicator = NO;
    
}

/** 赋值 */
- (void)setValueWithModel:(DetailVideoModel *)model {
    
    self.mainModel = model;
    
    if (!self.isHadSubView) {
        
        if (model.videos.count > 1) {
            // 布局子视图
            [self setUpSubView];
        }
        
//        NSLog(@"bbb");
        self.isHadSubView = YES;
        
    }
   
    
}
/** 布局子视图 */
- (void)setUpSubView {
    
    self.collectionScrollView.delegate = self;
    
    NSInteger countOfVideo = self.mainModel.videos.count;
    
    for (int i = 0; i < countOfVideo / 10 + 1; i++) {
        
        NSString *titleOfBtn = [[NSString alloc]init];
        
        // cell加上间距的高度
        CGFloat height = 40;
        
        if (countOfVideo < 10) {
            
            height = height * (countOfVideo + 1) / 2 ;
            
        } else {
            
            if (countOfVideo > (i + 1) * 10) {
                titleOfBtn = [NSString stringWithFormat:@"%d-%d",i * 10 + 1, i * 10 + 10];
            } else {
                titleOfBtn = [NSString stringWithFormat:@"%d-%lu",i * 10 + 1, countOfVideo];
            }
            
            height = height * 5;
        }
        
        
        
        // btn
        CGFloat widthOfBtnScroll = self.btnScrollView.contentSize.width;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(widthOfBtnScroll, 0, 70, CGRectGetHeight(self.btnScrollView.frame));
        btn.tag = 170 + i;
//        NSAttributedString *str = [[NSAttributedString alloc]initWithString:titleOfBtn attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        //        [btn setAttributedTitle:titleOfBtn forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:titleOfBtn forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:kThemeColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnScrollView addSubview:btn];
        self.btnScrollView.contentSize = CGSizeMake(widthOfBtnScroll + 75, CGRectGetHeight(self.btnScrollView.frame));
        
        if (i == 0) {
            btn.selected = YES;
        }
        
        // collectionView
        
//        CGRect frameOfSCV = self.collectionScrollView.frame;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        VideoListSubCollectionView *subCV = [[VideoListSubCollectionView alloc]initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, height ) collectionViewLayout:layout];
        [self.collectionScrollView addSubview:subCV];
        
        self.collectionScrollView.contentSize = CGSizeMake(kScreenWidth * (i + 1) , height);
        
        // 赋值
        [subCV setValueWithModel:self.mainModel WithPageNum:i];
        
        
    }
    
    
}
/** btn事件 */
- (void)handleAction:(UIButton *)sender {
    
//    NSLog(@"点击了btn");
    
    // 调整btn的状态
    [self modifyStateOfBtnWithTag:sender.tag];
    
    // 偏移视图
    [UIView animateWithDuration:0.5 animations:^{
        
        self.collectionScrollView.contentOffset = CGPointMake(kScreenWidth * (sender.tag - 170), 0);
    }];
    
}
/** 调整btn的状态 */
- (void)modifyStateOfBtnWithTag:(NSInteger)tag {
    
//    NSLog(@"%@",self.btnScrollView.subviews);
    
    for (UIView *view in self.btnScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            
            if (view.tag == tag) {
                [(UIButton *)view setSelected:YES];
            } else {
                [(UIButton *)view setSelected:NO];
            }
            
        }
    }
    
}

#pragma mark <UIScrollViewDelegate>
// 当滑动停止时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = self.collectionScrollView.contentOffset.x / kScreenWidth;
    
    [self modifyStateOfBtnWithTag:(170 + index)];
    
}


@end
