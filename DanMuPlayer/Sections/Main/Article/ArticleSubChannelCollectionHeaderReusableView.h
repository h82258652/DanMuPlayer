//
//  ArticleSubChannelCollectionHeaderReusableView.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/7.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeSubChannelBlock)(NSInteger);
@interface ArticleSubChannelCollectionHeaderReusableView : UICollectionReusableView

/** 切换子频道block */
@property (nonatomic,copy)ChangeSubChannelBlock changeSubChannelBlock;

/** 当前的子频道 */
- (void)setNowSubChannelWithchannelId:(NSInteger)channelId;

@end
