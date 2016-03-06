//
//  VideoUpCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/2.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "VideoUpCollectionViewCell.h"

@interface VideoUpCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;  // 头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;  // 昵称
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;  // 时间

@property (nonatomic,strong)DetailVideoModel *mainModel;  // 主model

@end

@implementation VideoUpCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/** 赋值 */
- (void)setValueWithModel:(DetailVideoModel *)model {
    
    self.mainModel = model;
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.owner_avatar]];
    self.photoImageView.layer.cornerRadius = CGRectGetHeight(self.frame) / 3;
    self.photoImageView.layer.masksToBounds = YES;
    
    self.nameLabel.text = model.owner_name;
//    NSLog(@"%@",[NSDate dateWithTimeIntervalSince1970:model.releaseDate / 1000]);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.releaseDate / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    self.timeLabel.text = [NSString stringWithFormat:@"发布于%@",[formatter stringFromDate:date]];
    
    
}

@end
