//
//  VideoCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/30.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "VideoCollectionViewCell.h"

@interface VideoCollectionViewCell ()

@property (nonatomic,strong)UIImageView *bottomImageView;  // 图片
@property (nonatomic,strong)UILabel *titleLabel;  // 名称

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end

@implementation VideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 布局子视图
//        [self setUpSubView];
    }
    return self;
}
- (void)setUpSubView {
    
    CGSize size = self.frame.size;
    
    // 图片
    self.bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height * 5 / 6)];
    [self addSubview:self.bottomImageView];
    // 标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bottomImageView.frame), size.width, size.height / 6)];
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
}
// 赋值
- (void)setValueWithModel:(RecommendCellModel *)model {
    
//    [self.bottomImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
//    self.titleLabel.text = model.title;
    
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.bottomLabel.text = model.title;
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    NSLog(@"nib");
//    NSLog(@"%@",NSStringFromCGRect(self.frame));
    
}



@end
