//
//  DetailVideoInfoFirstHeaderViewCollectionReusableView.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/5.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "DetailVideoInfoFirstHeaderViewCollectionReusableView.h"

@interface DetailVideoInfoFirstHeaderViewCollectionReusableView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;  // 标题
@property (weak, nonatomic) IBOutlet UILabel *playNumLabel;  // 播放次数
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;  // 评论次数
@property (weak, nonatomic) IBOutlet UILabel *bananaNumLabel;  // 香蕉数
@property (weak, nonatomic) IBOutlet UIView *downTapView;  // 简介视图（带tap）
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfTitleLabel;
@property (nonatomic,assign) NSInteger hiddenDownTapView;

@property (nonatomic,strong) DetailVideoModel *mainModel;

@property (nonatomic,copy)MotifyCellNumBlock motifyBlock;

@end

@implementation DetailVideoInfoFirstHeaderViewCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    // 为简介添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.downTapView addGestureRecognizer:tap];
    
    //    NSLog(@"重新走nib");
    
}

/** 赋值 */
- (void)setValueWithModel:(DetailVideoModel *)model withBlock:(MotifyCellNumBlock)block {
    
    self.mainModel = model;
    self.motifyBlock = block;
    self.titleLabel.text = model.title;
    
    NSDictionary *dic = model.visit;
    
    NSInteger number = [dic[@"views"] integerValue];
    self.playNumLabel.text = number < 10000 ? [NSString stringWithFormat:@"%ld",number] : [NSString stringWithFormat:@"%0.1f万",number * 1.0 / 10000];
    number = [dic[@"comments"] integerValue];
    self.commentNumLabel.text = number < 10000 ? [NSString stringWithFormat:@"%ld",number] : [NSString stringWithFormat:@"%0.1f万",number * 1.0 / 10000];
    number = [dic[@"goldBanana"] integerValue];
    self.bananaNumLabel.text = number < 10000 ? [NSString stringWithFormat:@"%ld",number] : [NSString stringWithFormat:@"%0.1f万",number * 1.0 / 10000];
    
    if (self.hiddenInfoView) {
        self.downTapView.hidden = YES;
    } else {
        self.downTapView.hidden = NO;
    }
}


- (void)tapAction:(UITapGestureRecognizer *)sender {
    
    // 展开cell
    NSDictionary *dic = [NSDictionary dictionary];
    
//    hiddenOrNo = YES;
    
    //    NSLog(@"%d",self.downTapView.hidden);
    
    self.motifyBlock(dic);
}
/** 改变显隐性 */
- (void)modifyDisplay:(NSNotification *)sender {
    
    //    NSLog(@"***%d",self.downTapView.hidden);
    // 显示cell
//    hiddenOrNo = NO;
}

@end
