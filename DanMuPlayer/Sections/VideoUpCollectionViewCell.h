//
//  VideoUpCollectionViewCell.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/2.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVideoModel.h"

@interface VideoUpCollectionViewCell : UICollectionViewCell

/** 赋值 */
- (void)setValueWithModel:(DetailVideoModel *)model;

@end
