//
//  ChannelFooterCollectionReusableView.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/27.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ChannelFooterCollectionReusableView.h"

@interface ChannelFooterCollectionReusableView ()


@property (weak, nonatomic) IBOutlet UIButton *btnOfMore;
@property (nonatomic,assign)NSInteger section;

@end

@implementation ChannelFooterCollectionReusableView

- (void)setTitleOfFooter:(NSString *)titleOfFooter withSection:(NSInteger)section{
    [self.btnOfMore setTitle:[NSString stringWithFormat:@"%@",titleOfFooter] forState:UIControlStateNormal];
    self.section = section;
    
}

- (IBAction)handleAction:(UIButton *)sender {
//    NSLog(@"%ld",self.section);
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:self.nameOfMessage object:nil userInfo:@{@"section":@(self.section)}];
    
    self.clickFooterBlock(self.section);
}


@end
