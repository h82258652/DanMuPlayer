//
//  ArticleCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/30.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ArticleCollectionViewCell.h"
#define kFromDic @{@"73":@"工作·情感",@"74":@"动漫文化",@"75":@"漫画小说",@"110":@"综合",@"164":@"游戏"}

@interface ArticleCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelOfFrom;
@property (weak, nonatomic) IBOutlet UILabel *LabelOfNumberOfComment;
@property (weak, nonatomic) IBOutlet UILabel *LabelOfTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelOfUP;
@property (weak, nonatomic) IBOutlet UILabel *LabelOfNumberOfRead;


@end

@implementation ArticleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 赋值
- (void)setValueWithModel:(RecommendCellModel *)model {
    self.labelOfFrom.text = [NSString stringWithFormat:@"/来自%@",[kFromDic valueForKey:[NSString stringWithFormat:@"%ld",model.channelId]]];
    NSInteger comments = [model.visit[@"comments"] integerValue];
    self.LabelOfNumberOfComment.text = comments > 10000 ? [NSString stringWithFormat:@"%.1f万",comments * 1.0 / 10000] : [NSString stringWithFormat:@"%ld",comments];
    self.LabelOfTitle.text = model.title;
    self.labelOfUP.text = [NSString stringWithFormat:@"UP主:%@",model.owner_name];
    NSInteger views = [model.visit[@"views"] integerValue];
    self.LabelOfNumberOfRead.text = views >= 10000 ? [NSString stringWithFormat:@"%.1f万",views * 1.0 / 10000] : [NSString stringWithFormat:@"%ld",views];
    
}

//- (void)setValueWithSubModel:(SubModel *)model
//{
//    
////    self.labelOfFrom.text = [NSString stringWithFormat:@"/来自%@",[kFromDic valueForKey:[NSString stringWithFormat:@"%ld",model.channelId]]];
//    self.labelOfFrom.text = @"";
//    NSInteger comments = model.comments;
//    self.LabelOfNumberOfComment.text = comments > 10000 ? [NSString stringWithFormat:@"%.1f万",comments * 1.0 / 10000] : [NSString stringWithFormat:@"%ld",comments];
//    self.LabelOfTitle.text = model.title;
//    self.labelOfUP.text = [NSString stringWithFormat:@"UP主:%@",model.username];
//    NSInteger views = model.views;
//    self.LabelOfNumberOfRead.text = views >= 10000 ? [NSString stringWithFormat:@"%.1f万",views * 1.0 / 10000] : [NSString stringWithFormat:@"%ld",views];
//  
//}


@end
