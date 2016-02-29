//
//  ChannelSubCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/27.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ChannelSubCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface ChannelSubCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;


@end

@implementation ChannelSubCollectionViewCell

/** 赋值 */
- (void)setValueWithModel:(ChannelSubModel *)model {
    
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    self.bottomLabel.text = model.name;
    
    
}

/** 另一种赋值 */
- (void)setValueWithCellModel:(RecommendCellModel *)model {
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.bottomLabel.text = model.title;
}

@end
