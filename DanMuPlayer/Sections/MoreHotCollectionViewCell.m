//
//  MoreHotCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/1.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "MoreHotCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface MoreHotCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *upLabel;


@end

@implementation MoreHotCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/** 赋值 */
- (void)setValueWithModel:(SubModel *)model {
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.titleLabel.text = model.title;
    self.upLabel.text = [NSString stringWithFormat:@"up主:%@",model.username];
    
}

@end
