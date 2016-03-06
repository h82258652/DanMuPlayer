//
//  VideoListSubCollectionView.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/3.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "VideoListSubCollectionView.h"
#import "VideoListCVCollectionViewCell.h"
#import "DetailVideoListModel.h"

@interface VideoListSubCollectionView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,strong)DetailVideoModel *mainModel;  // 主model
@property (nonatomic,assign)NSInteger pageNum;  // 当前页码（每页10个）

@end

@implementation VideoListSubCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - 自定义方法

/** 赋值 */
- (void)setValueWithModel:(DetailVideoModel *)model WithPageNum:(NSInteger)pageNum{
    
    self.mainModel = model;
    self.pageNum = pageNum;
    
    // 初始化
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = kBGColor;
    
    // 注册cell
    [self registerNib:[UINib nibWithNibName:@"VideoListCVCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cvc_cell"];
    
//    NSLog(@"注册cell");
    
    // 刷新界面
    [self reloadData];
    
}

#pragma mark UICollectionViewDelegateFlowLayout

// cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((kScreenWidth - 20) / 2, 30);
}
// cell边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
// 选中了cell
- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition {
 
    // 更改播放地址
}

#pragma mark <UICollectionViewDataSource>

// 分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (self.mainModel) {
        return 1;
    }
    
    return 0;
}
// 行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = self.mainModel.videos.count;
    
    if (count > (self.pageNum + 1) * 10) {
        return 10;
    } else {
//        NSLog(@"%ld",count - self.pageNum * 10);
        return count - self.pageNum * 10;
    }
    
    return 0;
}

// 选取cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailVideoListModel *model = self.mainModel.videos[indexPath.row + self.pageNum * 10];
    
    VideoListCVCollectionViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"cvc_cell" forIndexPath:indexPath];
    
    cell.titleLabel.text = model.title;
    
    return cell;
}


@end
