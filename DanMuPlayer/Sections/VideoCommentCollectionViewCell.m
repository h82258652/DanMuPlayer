//
//  VideoCommentCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/2.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "VideoCommentCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface VideoCommentCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation VideoCommentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/** 赋值 */
- (void)setValueWithModel:(DetailVideoCommentModel *)model {
    
    if (model == nil) {
        
        self.nameLabel.text = @"";
        self.timeLabel.text = @"";
        self.floorLabel.text = @"";
        
        self.contentLabel.text = @" 💖 暂时没有评论";
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        
        
//        NSLog(@"没有评论");
        return;
    }
    
    
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.nameLabel.text = model.username;
    self.floorLabel.text = [NSString stringWithFormat:@"#%ld",(long)model.floor];
    self.contentLabel.text = model.content;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.time / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    self.timeLabel.text = [formatter stringFromDate:date];
    
    
}

/** 动态返回cell高度 */
+ (CGFloat)heightOfCellWithComment:(NSString *)comment {
    
    // 计算文字的高度
    CGFloat height = [self heightOfText:comment];
    
    return height + 50;
    
}

/** 计算文字的高度 */
+ (CGFloat)heightOfText:(NSString *)text {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    return [text boundingRectWithSize:CGSizeMake(kScreenWidth - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
}



@end
