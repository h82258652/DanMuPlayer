//
//  CollectionTableViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/7.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "CollectionTableViewCell.h"

@interface CollectionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *upLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewsLabel;


@end

@implementation CollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/** 赋值 */
- (void)setValueWithArticleEntity:(ArticleEntity *)articleEntity
{
    self.titleLabel.text = articleEntity.title;
    self.upLabel.text = [NSString stringWithFormat:@"up主：%@",articleEntity.up];
    
    NSInteger views = [articleEntity.views integerValue];
    self.viewsLabel.text = views >= 10000 ? [NSString stringWithFormat:@"%.1f万",views * 1.0 / 10000] : [NSString stringWithFormat:@"%ld",(long)views];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
