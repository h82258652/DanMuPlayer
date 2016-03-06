//
//  VideoCommentCollectionViewCell.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/2.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVideoCommentModel.h"

@interface VideoCommentCollectionViewCell : UICollectionViewCell

/** 赋值 */
- (void)setValueWithModel:(DetailVideoCommentModel *)model;

/** 动态返回cell高度 */
+ (CGFloat)heightOfCellWithComment:(NSString *)comment;


@end
