//
//  ComicDetailFirstCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/5.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ComicDetailFirstCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "ComicDetailVideoModel.h"

@interface ComicDetailFirstCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;


@end

@implementation ComicDetailFirstCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/** 赋值 */
- (void)setValueWithModel:(ComicDetailModel *)model {
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.titleLabel.text = model.title;
    self.infoLabel.text = model.intro;
    
    ComicDetailVideoModel *videoModel = model.latestVideoComic;
    self.nowLabel.text = [NSString stringWithFormat:@"更新至%@",videoModel.title];
    
}


/** 动态计算高度 */
+ (CGFloat)heightOfCellWithStr:(NSString *)str {
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGFloat height = [str boundingRectWithSize:CGSizeMake(kScreenWidth - 140, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    return height + 50 > 140 ? height + 50 : 140;
}

@end
