//
//  RecommendCollectionReusableView.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/26.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "RecommendCollectionReusableView.h"

@interface RecommendCollectionReusableView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewOfSection;
@property (weak, nonatomic) IBOutlet UILabel *labelOfSection;



@end

@implementation RecommendCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSLog(@"加载页眉");
}

- (void)setValueWithModel:(RecommendModel *)model {
    [self.imageViewOfSection sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.labelOfSection.text = model.name;
}

- (void)setValueWithDic:(NSDictionary *)dic {
    
    self.imageViewOfSection.image = [UIImage imageNamed:dic[@"image"]];
    self.labelOfSection.text = dic[@"name"];
    
}


@end
