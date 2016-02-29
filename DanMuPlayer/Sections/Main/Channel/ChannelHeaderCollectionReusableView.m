//
//  ChannelHeaderCollectionReusableView.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/27.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ChannelHeaderCollectionReusableView.h"

@interface ChannelHeaderCollectionReusableView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation ChannelHeaderCollectionReusableView

- (void)setTitleOfHeader:(NSString *)titleOfHeader {
    self.titleLabel.text = titleOfHeader;
}

@end
