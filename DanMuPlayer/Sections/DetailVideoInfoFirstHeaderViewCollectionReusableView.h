//
//  DetailVideoInfoFirstHeaderViewCollectionReusableView.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/5.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVideoModel.h"

typedef void(^MotifyCellNumBlock)(NSDictionary *);

@interface DetailVideoInfoFirstHeaderViewCollectionReusableView : UICollectionReusableView

/** 是否隐藏简介 */
@property (nonatomic,assign)BOOL hiddenInfoView;
/** 赋值 */
- (void)setValueWithModel:(DetailVideoModel *)model withBlock:(MotifyCellNumBlock)block;

@end
