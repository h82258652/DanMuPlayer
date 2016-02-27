//
//  BannerCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/26.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "BannerCollectionViewCell.h"


@interface BannerCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;


@end

@implementation BannerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 赋值
- (void)setValueWithModel:(RecommendCellModel *)model {
    [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
}

@end
