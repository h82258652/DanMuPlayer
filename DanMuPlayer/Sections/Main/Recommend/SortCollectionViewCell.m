//
//  SortCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/30.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "SortCollectionViewCell.h"

@interface SortCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *LabelOfNumberOfView;
@property (weak, nonatomic) IBOutlet UILabel *LabelOfUP;


@end

@implementation SortCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 赋值
- (void)setValueWithModel:(RecommendCellModel *)model {
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.titleLabel.text = model.title;
    NSInteger views = [model.visit[@"views"] integerValue];
    self.LabelOfNumberOfView.text = views >= 10000 ? [NSString stringWithFormat:@"%ld万",views / 10000] : [NSString stringWithFormat:@"%ld",views];
    self.LabelOfUP.text = [NSString stringWithFormat:@"UP主:%@",model.owner_name];
}

/** submodel 赋值 */
- (void)setValueWithSubModel:(SubModel *)model {
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.titleLabel.text = model.title;
    self.LabelOfNumberOfView.text = model.views >= 10000 ? [NSString stringWithFormat:@"%ld万",model.views / 10000] : [NSString stringWithFormat:@"%ld",model.views];
    self.LabelOfUP.text = [NSString stringWithFormat:@"UP主:%@",model.username];
    
}

@end
