//
//  CollectionTableViewCell.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/7.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleEntity.h"

@interface CollectionTableViewCell : UITableViewCell

/** 赋值 */
- (void)setValueWithArticleEntity:(ArticleEntity *)articleEntity;


@end
