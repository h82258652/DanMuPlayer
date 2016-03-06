//
//  DetailVideoCollectionViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/2.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "DetailVideoInfoCollectionViewController.h"
#import "VideoUpCollectionViewCell.h"
#import "VideoListCollectionViewCell.h"
#import "VideoCommentCollectionViewCell.h"

#import "DetailVideoInfoFirstHeaderViewCollectionReusableView.h"
#import "VideoInfoFirstCollectionViewCell.h"

#import "DetailVideoInfoCollectionReusableView.h"
#import "DetailVideoListModel.h"

#import "DataHelper.h"

@interface DetailVideoInfoCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)DetailVideoModel *mainModel;  // 主model
@property (nonatomic,strong)NSMutableArray *heightOfCellArr;  // cell的高度数组
@property (nonatomic,assign)BOOL showInfoCell;

@property (nonatomic,assign)NSInteger pageSize;  // 每页的数量
@property (nonatomic,assign)NSInteger pageNo;  // 页码

@property (nonatomic,strong)NSDictionary *commentDic;  // 评论所在的字典

@end

@implementation DetailVideoInfoCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 初始化参数
    self.pageSize = 50;
    self.pageNo = 1;
    self.showInfoCell = NO;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // 注册cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoInfoFirstCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"video_Info"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoUpCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"video_Up"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"video_List"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCommentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"video_Comment"];
    
    
    // 注册页眉
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailVideoInfoCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailVideoInfoFirstHeaderViewCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"info_header"];
    
    
    self.heightOfCellArr = [NSMutableArray arrayWithObjects:@(70),@(80),@(80),@(80), nil];
}

#pragma mark - 自定义方法
/** 请求数据 */
- (void)loadDataWithModel:(DetailVideoModel *)model {
    
    NSLog(@"接收到model");
    
    self.mainModel = model;
    
    // 请求评论数据
    [self loadCommentData];
    
    // 刷新界面
    [self.collectionView reloadData];
    
}
/** 请求评论数据 */
- (void)loadCommentData {
    NSString *urlStr = [NSString stringWithFormat:kVideoCommentURLStr,self.mainModel.contentId,self.pageNo];
    [DataHelper getDataSourceForCommentWithURLStr:urlStr withBlock:^(NSDictionary *dic) {
        
        if (self.commentDic) {
            NSMutableArray *mapArr = [NSMutableArray arrayWithArray:self.commentDic[@"map"]];
            [mapArr addObjectsFromArray:dic[@"map"]];
            
            NSMutableArray *listArr = [NSMutableArray arrayWithArray:self.commentDic[@"list"]];
            [listArr addObjectsFromArray:dic[@"list"]];
            
            [self.commentDic setValue:listArr forKey:@"list"];
            [self.commentDic setValue:mapArr forKey:@"map"];
            
            [self.collectionView reloadData];
            
            return;
        }
        self.commentDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self.collectionView reloadData];
        
    }];
    
}

/** 观察cell的动态高度 */
//- (void)motifyHeightOfCell:(NSNotification *)sender {
//    
////    NSLog(@"%@",sender.userInfo);
//    CGFloat height = [sender.userInfo[@"height"] floatValue];
//    NSInteger index = [sender.userInfo[@"index"] integerValue];
//    CGFloat heightOfOld = [self.heightOfCellArr[index] floatValue];
//    
//    if (heightOfOld != height) {
//        [self.heightOfCellArr replaceObjectAtIndex:index withObject:@(height)];
//        
//        [self.collectionView reloadData];
//    }
//    
//}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>
// 分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.mainModel) {
        return 4;
    }
    return 0;
}

// 行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 2 && self.mainModel.videos.count == 1) {
        return 0;
    } else if (section == 3 && [self.commentDic[@"page"] isKindOfClass:[NSDictionary class]]) {
        return [self.commentDic[@"list"] count];
    } else if (section == 0 && !self.showInfoCell) {
        return 0;
    }
    return 1;
}
// 选择不同的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {  // 视频简介
            VideoInfoFirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"video_Info" forIndexPath:indexPath];
            [cell setValueWithModel:self.mainModel withBlock:^(NSDictionary *dic) {
                self.showInfoCell = NO;
                [self.collectionView reloadData];
            }];
            
            return cell;
            break; }
        case 1: {  // up主信息
            VideoUpCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"video_Up" forIndexPath:indexPath];
            [cell setValueWithModel:self.mainModel];
            return cell;
            break; }
        case 2: {  // 视频列表
            VideoListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"video_List" forIndexPath:indexPath];
            [cell setValueWithModel:self.mainModel];
            return cell;
            break; }
        case 3: {  // 视频评论
            VideoCommentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"video_Comment" forIndexPath:indexPath];
            return cell;
            break; }
        default:
            break;
    }
    
    return nil;
}
// 为cell赋值
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3) {
        
        if ([self.commentDic[@"totalCount"] integerValue] == 0) {
            [(VideoCommentCollectionViewCell *)cell setValueWithModel:nil];
            return;
        }
        
        DetailVideoCommentModel *model = self.commentDic[@"map"][indexPath.row];
        
        [(VideoCommentCollectionViewCell *)cell setValueWithModel:model];
        
    }
    
}

// 选则页眉
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            DetailVideoInfoFirstHeaderViewCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"info_header" forIndexPath:indexPath];
            // 是否隐藏简介
            headerView.hiddenInfoView = self.showInfoCell;
            
            [headerView setValueWithModel:self.mainModel withBlock:^(NSDictionary *dic) {
                self.showInfoCell = YES;
                [self.collectionView reloadData];
            }];
            
            
            return headerView;
        } else {
            DetailVideoInfoCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
            
            switch (indexPath.section) {
                case 2:
                    headerView.labelOfTitle.text = @"选段";
                    headerView.labelOfNum.text = [NSString stringWithFormat:@"%ld",self.mainModel.videos.count];
                    break;
                case 3:
                    headerView.labelOfTitle.text = @"评论";
                    NSInteger comment = [self.mainModel.visit[@"comment"] integerValue];
                    headerView.labelOfNum.text = comment < 10000 ? [NSString stringWithFormat:@"%ld",comment] : [NSString stringWithFormat:@"%.1f万",comment * 1.0 / 10000];
                    break;
                default:
                    break;
            }
            
            return headerView;
        }
    }
    return nil;
    
}


#pragma mark <UICollectionViewDelegateFlowLayout>
// cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self.heightOfCellArr[indexPath.section] floatValue];
    
    if (indexPath.section == 2) {
        if (self.mainModel.videos.count > 10) {
            return CGSizeMake(kScreenWidth, 40 * 5 + 32);
        } else {
            return CGSizeMake(kScreenWidth, 40 * (self.mainModel.videos.count + 1) / 2 + 32);
        }
    } else if (indexPath.section == 3) {
        
        if ([self.commentDic[@"totoalCount"] integerValue] == 0) {
            return CGSizeMake(kScreenWidth - 4, 70);
        }
        
        DetailVideoCommentModel *model = self.commentDic[@"map"][indexPath.row];
        return CGSizeMake(kScreenWidth - 4, [VideoCommentCollectionViewCell heightOfCellWithComment:model.content]);
    } else if (indexPath.section == 0) {
        
        return CGSizeMake(kScreenWidth - 4, [VideoInfoFirstCollectionViewCell heightOfCellWithModel:self.mainModel]);
        
    }
    
    
    return CGSizeMake(kScreenWidth, height);
}
// 页眉的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return CGSizeMake(kScreenWidth, 55);
        case 1:
            
            break;
        case 2:
            if (self.mainModel.videos.count > 1) {
                return CGSizeMake(kScreenWidth, 40);
            } else {
                return CGSizeZero;
            }
            break;
        case 3:
            return CGSizeMake(kScreenWidth, 50);
            break;
        default:
            break;
    }
    
    return CGSizeZero;
}





#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        // 如果是选集分区，就可以点击切换
        DetailVideoListModel *model = self.mainModel.videos[indexPath.item];
        if (self.changeVideoIdBlock) {
            self.changeVideoIdBlock(model.videoId);
        }
    }
    
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
}


@end
