//
//  VideoCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/30.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "VideoCollectionViewCell.h"

@interface VideoCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end

@implementation VideoCollectionViewCell

// 赋值
- (void)setValueWithModel:(RecommendCellModel *)model {
    
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:[model valueForKey:@"image"]]];
    self.bottomLabel.text = [model valueForKey:@"title"];
    
}
/** submodel 赋值 */
- (void)setValueWithSubModel:(SubModel *)model {
    
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.bottomLabel.text = model.title;
}

/** 视频相关model赋值 */
- (void)setValueWithAboutModel:(DetailVideoAboutModel *)model {
    
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.titleImg]];
    self.bottomLabel.text = model.title;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    NSLog(@"nib");
//    NSLog(@"%@",NSStringFromCGRect(self.frame));
    
}



@end
