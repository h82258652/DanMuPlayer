//
//  ChannelCollectionViewCell.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/27.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ChannelCollectionViewCell.h"
#import "ChannelSubModel.h"
#import "UIImageView+WebCache.h"

#import "ChannelSubCollectionViewCell.h"

typedef enum : NSUInteger {
    ChannelModelType,
    MainModelType,
} WhichModelType;

@interface ChannelCollectionViewCell ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)ChannelModel *model;  // 传进来的model

@property (nonatomic,strong)RecommendModel *mainModel;  // 传进来的另一种model

@property (nonatomic,assign)WhichModelType whichModelType;  // 记录传进来的是那种model

@property (weak, nonatomic) IBOutlet UICollectionView *subCollectionView;  // 子视图

@property (nonatomic,assign)CGFloat heightOfSelf;  // 子cell的高度

@end

@implementation ChannelCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.subCollectionView.delegate = self;
    self.subCollectionView.dataSource = self;
    self.subCollectionView.contentOffset = CGPointMake(0, 0);
    
    // 注册cell
    [self.subCollectionView registerNib:[UINib nibWithNibName:@"ChannelSubCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"channelCell"];
}

/** 一种赋值方式 */
- (void)setValueWithModel:(ChannelModel *)model {
    
    self.whichModelType = ChannelModelType;
    
    _model = model;
    
    self.subCollectionView.contentOffset = CGPointMake(0, 0);
    
    self.heightOfSelf = CGRectGetHeight(self.frame) - 10;
    
    [self.subCollectionView reloadData];
    
}

/** 另一种赋值 */
- (void)setValueWithMainModel:(RecommendModel *)model {
    
    self.whichModelType = MainModelType;
    
    _mainModel = model;
    
    self.heightOfSelf = CGRectGetHeight(self.frame) - 10;
    
//    NSLog(@"%@", [NSThread currentThread]);
    
    [self.subCollectionView reloadData];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (self.whichModelType) {
        case ChannelModelType:
            return self.model.childChannels.count;
            break;
        case MainModelType:
            return self.mainModel.contents.count;
            break;
        default:
            break;
    }
    
    return self.model.childChannels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ChannelSubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"channelCell" forIndexPath:indexPath];
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate

// 选中cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.whichModelType) {
        case ChannelModelType: {
//            ChannelSubModel *model = self.model.childChannels[indexPath.item];
            // 通知中心发送消息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clickSubChannel" object:nil userInfo:@{@"model":self.model,@"index":@(indexPath.item)}];
            
            break; }
        case MainModelType: {
            
            // 触发block
            NSDictionary *dic = @{@"model":self.mainModel,@"index":@(indexPath.item)};
            if (self.subChannelBlock) {
                self.subChannelBlock(dic);
            }
            
            break; }
        default:
            break;
    }
    
    
    
}
// 为cell赋值
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (self.whichModelType) {
        case ChannelModelType: {
            ChannelSubModel *model = self.model.childChannels[indexPath.item];
//            NSLog(@"%@",model.name);
            [(ChannelSubCollectionViewCell *)cell setValueWithModel:model];
            break; }
        case MainModelType: {
            RecommendCellModel *model = self.mainModel.contents[indexPath.item];
            
//            NSLog(@"%@",model.title);
            [(ChannelSubCollectionViewCell *)cell setValueWithCellModel:model];
            break; }
        default:
            break;
    }
    
    
    
    
    if (indexPath.row == self.model.childChannels.count - 1) {
        if (self.subCollectionView.contentSize.width < kScreenWidth) {
//            NSLog(@"%f",self.subCollectionView.contentSize.width);
            self.subCollectionView.contentOffset = CGPointMake((self.subCollectionView.contentSize.width - kScreenWidth) / 2, 0);
        }
    }
}

#pragma mark -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.heightOfSelf * 2 / 3, self.heightOfSelf);
}


@end
