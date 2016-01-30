//
//  RollPlayCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/29.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "RollPlayCollectionViewCell.h"

@interface RollPlayCollectionViewCell ()

@property (strong, nonatomic) IBOutlet RollPlayCollectionViewCell *rollPlayView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImage;
@property (weak, nonatomic) IBOutlet UIImageView *fifthImage;


@end

@implementation RollPlayCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [[NSBundle mainBundle] loadNibNamed:@"RollPlayCollectionViewCell" owner:self options:nil];
    self.rollPlayView.frame = self.frame;
    [self addSubview:self.rollPlayView];
    
    // 为image添加点击事件
    
}

@end
