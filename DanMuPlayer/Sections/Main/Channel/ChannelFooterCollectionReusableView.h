//
//  ChannelFooterCollectionReusableView.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/27.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickFooterBlock)(NSInteger);

@interface ChannelFooterCollectionReusableView : UICollectionReusableView

@property (nonatomic,copy)NSString *nameOfMessage;

// 赋值
- (void)setTitleOfFooter:(NSString *)titleOfFooter withSection:(NSInteger)section;

/** 页脚点击block */
@property (nonatomic,copy)ClickFooterBlock clickFooterBlock;

@end
