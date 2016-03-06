//
//  ComicDetailSecondCollectionViewCell.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/5.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComicDetailSecondCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setValueWithTitle:(NSString *)title;

@end
