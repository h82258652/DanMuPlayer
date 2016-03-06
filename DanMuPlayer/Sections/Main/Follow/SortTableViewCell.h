//
//  SortTableViewCell.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/6.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubModel.h"

@interface SortTableViewCell : UITableViewCell

/** 赋值 */
- (void)setValueWithSubModel:(SubModel *)model;

@end
