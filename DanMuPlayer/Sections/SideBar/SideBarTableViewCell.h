//
//  SideBarTableViewCell.h
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/7.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideBarTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;  // 图片
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;  // cell标题

@end
