//
//  ComicCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/30.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ComicCollectionViewCell.h"

@interface ComicCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation ComicCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 赋值
- (void)setValueWithModel:(RecommendCellModel *)model {
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.titleLabel.text = model.title;
    self.timeLabel.text = [NSString stringWithFormat:@"更新至%@",model.latestBangumiVideo[@"title"]];
}

@end
