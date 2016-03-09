//
//  ArticleSubChannelCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/7.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ArticleSubChannelCollectionViewCell.h"

@interface ArticleSubChannelCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *LabelOfNumberOfComment;
@property (weak, nonatomic) IBOutlet UILabel *LabelOfTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelOfUP;
@property (weak, nonatomic) IBOutlet UILabel *LabelOfNumberOfRead;

@end

@implementation ArticleSubChannelCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setValueWithSubModel:(SubModel *)model
{
    
    NSInteger comments = model.comments;
    self.LabelOfNumberOfComment.text = comments > 10000 ? [NSString stringWithFormat:@"%.1f万",comments * 1.0 / 10000] : [NSString stringWithFormat:@"%ld",comments];
    self.LabelOfTitle.text = model.title;
    self.labelOfUP.text = [NSString stringWithFormat:@"UP主:%@",model.username];
    NSInteger views = model.views;
    self.LabelOfNumberOfRead.text = views >= 10000 ? [NSString stringWithFormat:@"%.1f万",views * 1.0 / 10000] : [NSString stringWithFormat:@"%ld",views];
    
}

@end
