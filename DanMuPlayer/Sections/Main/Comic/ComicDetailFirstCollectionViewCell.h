//
//  ComicDetailFirstCollectionViewCell.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/5.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicDetailModel.h"
#import "NewComicListModel.h"

@interface ComicDetailFirstCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfInfoLabel;


/** 动态计算高度 */
+ (CGFloat)heightOfCellWithStr:(NSString *)str;

/** 赋值 */
- (void)setValueWithModel:(ComicDetailModel *)model;

/** 频道赋值 */
- (void)setValueWithNewComicListModel:(NewComicListModel *)model;

@end
