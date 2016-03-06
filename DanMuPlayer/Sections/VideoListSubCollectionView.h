//
//  VideoListSubCollectionView.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/3.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVideoModel.h"

@interface VideoListSubCollectionView : UICollectionView

/** 赋值 */
- (void)setValueWithModel:(DetailVideoModel *)model WithPageNum:(NSInteger)pageNum;



@end
