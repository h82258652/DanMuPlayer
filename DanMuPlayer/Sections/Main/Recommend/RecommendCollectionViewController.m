//
//  RecommendCollectionViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/29.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "RecommendCollectionViewController.h"
#import "AFHTTPSessionManager.h"
#import "RollPlayCollectionViewCell.h"
#import "VideoCollectionViewCell.h"
#import "BannerCollectionViewCell.h"
#import "ComicCollectionViewCell.h"
#import "ArticleCollectionViewCell.h"
#import "SortCollectionViewCell.h"
#import "DataHelper.h"

#import "RecommendCollectionReusableView.h"

#import "RecommendModel.h"



@interface RecommendCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSMutableArray *dataSoruce; // 数据源

@end

@implementation RecommendCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSoruce = [NSMutableArray arrayWithCapacity:1];
    
    // 注册cell
    [self.collectionView registerClass:[RollPlayCollectionViewCell class] forCellWithReuseIdentifier:@"rollPlay"];  // 轮播cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"videoCell"]; // 视频cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"BannerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bannerCell"]; // 横幅cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ComicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"comicCell"];  // 番剧cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ArticleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"articleCell"];  // 文章cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"SortCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"sortCell"];  // 排行榜cell
    
    // 注册页眉页脚
    [self.collectionView registerNib:[UINib nibWithNibName:@"RecommendCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"yuan"];
    
    // 注册接收消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeModel:) name:@"changeModel" object:nil];
    
    // 请求数据
    [self loadData];
    
}

#pragma mark - 请求数据
- (void)loadData {
    
    [DataHelper getDataSourceForCommendWithURLStr:kRegionsURLStr withBlock:^(NSMutableArray *array) {
        self.dataSoruce = [NSMutableArray arrayWithArray:array];
        [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }];
    
    
}

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

#pragma mark <UICollectionViewDelegateFlowLayout>

// cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendModel *model = self.dataSoruce[indexPath.section];
    // 根据不同的类型设置分区页眉是否显示
    switch (model.type_id) {
        case 1:  // 视频
            return CGSizeMake((kScreenWidth - 5 * 4) / 2, kScreenWidth / 2.5);
            break;
        case 2:  // 文章
            return CGSizeMake(kScreenWidth - 20, kScreenWidth * 6 / 19);
            break;
        case 3:  // 番剧
            return CGSizeMake((kScreenWidth - 6 * 6 ) / 3, kScreenWidth * 3 / 5);
            break;
        case 5:  // 轮播图
            return CGSizeMake(kScreenWidth, kScreenWidth * 8 / 19);
            break;
        case 6:  // 横幅
            return CGSizeMake(kScreenWidth - 10, kScreenWidth * 4.5 / 19);
            break;
        case 12:  // 排行榜
            return CGSizeMake(kScreenWidth - 20, kScreenWidth * 5 / 19);
            break;
        default:
            break;
    }
    NSLog(@"cell大小为0");
    return CGSizeZero;
    
}

// cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

// 页眉的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    RecommendModel *model = self.dataSoruce[section];
    // 根据不同的类型设置分区页眉是否显示
    switch (model.type_id) {
        case 1:
        case 2:
        case 3:
        case 12:
            return CGSizeMake(0, 50);
            break;
        case 4: {
            
            break;}
        case 5:
            break;
        case 6:
            break;
        default:
            break;
    }
    return CGSizeZero;
}


#pragma mark <UICollectionViewDataSource>

// 分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSoruce.count;
}

// cell数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    RecommendModel *model = self.dataSoruce[section];
    
    if (model.type_id == 5) {  // 当为轮播图分区时，强制设置cell数为1
        return 1;
    }
    return model.contentCount;
}

// 为即将显示在界面上的cell赋值
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommendModel *model = self.dataSoruce[indexPath.section];
    // 根据不同种类的cell，调用不同的cell
    if ([cell isKindOfClass:[RollPlayCollectionViewCell class]]) {
        
        [(RollPlayCollectionViewCell *)cell setValueWithModel:model];
        
    } else if ([cell isKindOfClass:[VideoCollectionViewCell class]]) {
        
        [(VideoCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
        
    } else if ([cell isKindOfClass:[BannerCollectionViewCell class]]) {
        
        [(BannerCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
        
    } else if ([cell isKindOfClass:[ComicCollectionViewCell class]]) {
        
        [(ComicCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
        
    } else if ([cell isKindOfClass:[ArticleCollectionViewCell class]]) {
        
        [(ArticleCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
        
    } else if ([cell isKindOfClass:[SortCollectionViewCell class]]) {
        
        [(SortCollectionViewCell *)cell setValueWithModel:model.contents[indexPath.row]];
        
    }
}

// 选取不同的cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendModel *model = self.dataSoruce[indexPath.section];
//    NSLog(@"***** %ld",model.type_id);
    // 判断使用哪种cell
    switch (model.type_id) {
        case 1: {
            VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
            return cell;
            break;}
        case 2: {
            ArticleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"articleCell" forIndexPath:indexPath];
            return cell;
            break;}
        case 3: {
            ComicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"comicCell" forIndexPath:indexPath];
            return cell;
            break;}
        case 4: {
            
            break;}
        case 5:{
            RollPlayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rollPlay" forIndexPath:indexPath];
            return cell;
            break;}
        case 6: {
            BannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerCell" forIndexPath:indexPath];
            return cell;
            break;}
        case 12: {
            SortCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sortCell" forIndexPath:indexPath];
            return cell;
            break;}
        default:
            break;
    }
    
    return nil;
}
// 设置页眉
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        RecommendCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        return headerView;
    }
    return nil;
}

// 为页眉赋值
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    RecommendModel *model = self.dataSoruce[indexPath.section];
    switch (model.type_id) {
        case 1:
        case 2:
        case 3:
        case 12:
            [(RecommendCollectionReusableView *)view setValueWithModel:model];
            break;
        case 4: {
            
            break;}
        case 5:{
            
            break;}
        case 6: {
            
            break;}
        default:
            break;
    }
}

#pragma mark - 其他方法
// 当请求到新的内容时，刷新界面
- (void)changeModel:(NSNotification *)sender {
    
    NSDictionary *dic = sender.userInfo;
    
    for (RecommendModel *model in self.dataSoruce) {
        if (model.recommend_id == [dic[@"model_id"] integerValue]) {
            model.contents = dic[@"dataArray"];
            // 刷新界面
            [self.collectionView reloadData];
        }
    }
    
    
}

#pragma mark <UICollectionViewDelegate>

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

@end
