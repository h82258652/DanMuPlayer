//
//  SortTableViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/6.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "SortTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface SortTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;  // 图片
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;  // 标题
@property (weak, nonatomic) IBOutlet UILabel *upLabel;  // up主


@end

@implementation SortTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/** 赋值 */
- (void)setValueWithSubModel:(SubModel *)model
{
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.titleLabel.text = model.title;
    self.upLabel.text = [NSString stringWithFormat:@"up主:%@",model.username];
    
}











- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
