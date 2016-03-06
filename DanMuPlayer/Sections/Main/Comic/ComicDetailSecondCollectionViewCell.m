//
//  ComicDetailSecondCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/5.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ComicDetailSecondCollectionViewCell.h"



@implementation ComicDetailSecondCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setValueWithTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
