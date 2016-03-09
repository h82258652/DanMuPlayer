//
//  ArticleSubChannelCollectionHeaderReusableView.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/7.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ArticleSubChannelCollectionHeaderReusableView.h"
#define kArr @[@"110",@"73",@"74",@"75",@"164"]
//@{@"73":@"工作·情感",@"74":@"动漫文化",@"75":@"漫画小说",@"110":@"综合",@"164":@"游戏"}

@interface ArticleSubChannelCollectionHeaderReusableView ()



@end

@implementation ArticleSubChannelCollectionHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    for (int i = 190; i < 195; i++) {
        
        UIButton *btn = [self viewWithTag:i];
        [btn setTitleColor:kThemeColor forState:UIControlStateSelected];
    }
    
    
}

/** 当前的子频道 */
- (void)setNowSubChannelWithchannelId:(NSInteger)channelId
{
    NSInteger tag = 0;
    switch (channelId) {
        case 110:
            tag = 190;
            break;
        case 73:
            tag = 191;
            break;
        case 74:
            tag = 192;
            break;
        case 75:
            tag = 193;
            break;
        case 164:
            tag = 194;
            break;
        default:
            break;
    }
    
    if (tag != 0) {
        [self modifyBtnStateWithTag:tag];
    }
    
}

/** btn点击事件 */
- (IBAction)changeSubChannelAction:(UIButton *)sender
{
    NSLog(@"%ld",sender.tag);
    [self modifyBtnStateWithTag:sender.tag];
    NSLog(@"++++%ld",sender.tag);
    self.changeSubChannelBlock([kArr[sender.tag - 190] integerValue]);
    
}

/** 切换btn的选中状态 */
- (void)modifyBtnStateWithTag:(NSInteger)tag
{
    for (int i = 190; i < 195; i++) {
        
        UIButton *btn = [self viewWithTag:i];
        if (i == tag) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
}

@end
