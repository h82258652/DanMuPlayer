//
//  UpCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/27.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "UpCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface UpCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelOfName;
@property (weak, nonatomic) IBOutlet UILabel *labelOfIntro;


@end

@implementation UpCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 赋值
- (void)setValueWithModel:(RecommendCellModel *)model {
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.labelOfName.text = model.owner_name;
    self.labelOfIntro.text = model.title;
    
}

@end
