//
//  VideoInfoFirstCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/5.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "VideoInfoFirstCollectionViewCell.h"

@interface VideoInfoFirstCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *videoIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic,copy)MotifyCellNumBlock motifyBlock;

@end

@implementation VideoInfoFirstCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 为点击视图加上一个事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.bottomView addGestureRecognizer:tap];
    
}

/** 赋值 */
- (void)setValueWithModel:(DetailVideoModel *)model withBlock:(MotifyCellNumBlock)block {
    self.motifyBlock = block;
    
    self.videoIdLabel.text = [NSString stringWithFormat:@"av%ld",model.contentId];
    self.infoLabel.text = model.info;
    
    //    NSLog(@"%@",self.backgroundColor);
    
}


// tap点击事件
- (void)tapAction:(UITapGestureRecognizer *)sender {
    NSLog(@"点击了cell");
    // 收起cell
    NSDictionary *dic = [NSDictionary dictionary];
    self.motifyBlock(dic);
    
}

/** 动态高度 */
+ (CGFloat)heightOfCellWithModel:(DetailVideoModel *)model {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    
    CGFloat height = [model.info boundingRectWithSize:CGSizeMake(kScreenWidth - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    
    return height + 55;
}

@end
