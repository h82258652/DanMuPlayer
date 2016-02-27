//
//  RollPlayCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/29.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "RollPlayCollectionViewCell.h"
#import "RecommendCellModel.h"

@interface RollPlayCollectionViewCell ()

@property (nonatomic,strong)UIScrollView *mainScrollView;  // 底层滚动视图
@property (nonatomic,strong)NSTimer *timer;  // 定时器
@property (nonatomic,assign)NSInteger index; // 当前图片的下标

@end

@implementation RollPlayCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 布局子视图
        [self setUpSubView];
    }
    return self;
}
// 布局子视图
- (void)setUpSubView {
    self.index = 0;
    
//    NSLog(@"%@",NSStringFromCGRect(self.frame));
    
    // scroll
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.frame))];
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth * 5, CGRectGetHeight(self.frame));
    [self addSubview:self.mainScrollView];
    // for循环设置imageView
    for (int i = 0; i < 5; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, CGRectGetHeight(self.frame))];
        imageView.tag = 120 + i;
        [self.mainScrollView addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"My_background"];
    }
    // 开始滚动
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(rollPalyAction) userInfo:nil repeats:YES];
    
}

// 图片轮播
- (void)rollPalyAction {
    if (self.index++ == 4) {
        self.index = 0;
    }
    [UIView animateWithDuration:1 animations:^{
        self.mainScrollView.contentOffset = CGPointMake(kScreenWidth * self.index, 0);
    }];
}

// imageView的点击事件
- (void)TapActionOfImageView:(UITapGestureRecognizer *)tap {
    
}

// 使用model赋值
- (void)setValueWithModel:(RecommendModel *)model {
    [model.contents enumerateObjectsUsingBlock:^(RecommendCellModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [self viewWithTag:120 + idx];
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj.image]];
    }];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    NSLog(@"aaa");
//    
//    [[NSBundle mainBundle] loadNibNamed:@"RollPlayCollectionViewCell" owner:self options:nil];
//    self.rollPlayView.frame = self.frame;
//    
//    [self addSubview:self.rollPlayView];
    
    // 为image添加点击事件
    
}

@end
