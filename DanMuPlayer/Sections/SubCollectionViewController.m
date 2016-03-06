//
//  SubCollectionViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/29.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "SubCollectionViewController.h"
#import "VideoCollectionViewCell.h"
#import "SortCollectionViewCell.h"
#import "RecommendCollectionReusableView.h"  
#import "ChannelFooterCollectionReusableView.h"
#import "MoreHotCollectionViewController.h"

#import "DetailVideoViewController.h"
#import "DataHelper.h"

@interface SubCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSMutableArray *dataSource;

//@property (nonatomic,assign)NSInteger sub_Id;  // 频道id

// 网址参数
@property (nonatomic,assign)NSInteger channelIds;  // 频道id
@property (nonatomic,assign)NSInteger pageNo;  // 页码
@property (nonatomic,assign)NSInteger pageSize;  // 每次请求数据量;
@property (nonatomic,assign)NSInteger sort;  // 排序类型
@property (nonatomic,assign)NSInteger range;  // 时间范围

@end

@implementation SubCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化一些参数
    
    NSArray *array1 = [NSArray array];
    NSArray *array2 = [NSArray array];
    
    self.dataSource = [NSMutableArray arrayWithObjects:array1,array2, nil];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    
    // 注册cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"videocell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SortCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"sortcell"];
    
    // 注册页眉页脚
    [self.collectionView registerNib:[UINib nibWithNibName:@"RecommendCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ChannelFooterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 自定义方法

/** 请求数据 */
- (void)loadDataWithChannelId:(NSInteger)channelId {
    
    self.channelIds = channelId;
    self.pageSize = 4;
    self.pageNo = 1;
    self.sort = 1;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setValue:@(self.channelIds) forKey:@"channelIds"];
    [dic setValue:@(self.pageSize) forKey:@"pageSize"];
    [dic setValue:@(self.pageNo) forKey:@"pageNo"];
    [dic setValue:@(self.sort) forKey:@"sort"];
    [dic setValue:@(604800000) forKey:@"range"];
    // 请求数据
    [DataHelper getDataSourceForSubWithURLStr:kSearchURLStr andParameters:dic withBlock:^(NSDictionary *dic) {
        NSMutableArray *array = dic[@"data"];
        [self.dataSource replaceObjectAtIndex:0 withObject:array];
        [self.collectionView reloadData];
    }];
    
    self.pageSize = 10;
    self.sort = 4;
    [dic setValue:@(self.pageSize) forKey:@"pageSize"];
    [dic setValue:@(self.sort) forKey:@"sort"];
    [dic removeObjectForKey:@"range"];
    
    [DataHelper getDataSourceForSubWithURLStr:kSearchURLStr andParameters:dic withBlock:^(NSDictionary *dic) {
        NSMutableArray *array = dic[@"data"];
        [self.dataSource replaceObjectAtIndex:1 withObject:array];
        [self.collectionView reloadData];
    }];
    
}


/** 初始化布局 */
- (void)setSub_Id:(NSInteger)sub_Id {
    
    
}

#pragma mark <UICollectionViewDelegateFlowLayout>

// cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return CGSizeMake((kScreenWidth - 5 * 4) / 2, kScreenWidth / 2.5);
    } else {
        return CGSizeMake(kScreenWidth - 20, kScreenWidth * 5 / 19);
    }
    
}
// 页眉大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth, 50);
}
// 页脚大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(kScreenWidth, 50);
    }
    
    return CGSizeZero;
}
// item边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    } else {
        return UIEdgeInsetsZero;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
}


#pragma mark <UICollectionViewDataSource>
// 分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
// 行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([self.dataSource[section] count] != 0) {
        return [self.dataSource[section] count];
    }
    return 0;
}
// 选择cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videocell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 1) {
        SortCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sortcell" forIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}
// 为cell赋值
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.dataSource[indexPath.section][indexPath.item] isKindOfClass:[SubModel class]]) {
        SubModel *model = self.dataSource[indexPath.section][indexPath.item];
        if (indexPath.section == 0) {
            [(VideoCollectionViewCell *)cell setValueWithSubModel:model];
        } else {
            [(SortCollectionViewCell *)cell setValueWithSubModel:model];
        }
    }
    
}
// 设置页眉页脚
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        RecommendCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        return headerView;
        
    } else {
        
        ChannelFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        return footerView;
        
    }
    
}
// 为页眉页脚赋值
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:@"section_placeholder" forKey:@"image"];
        if (indexPath.section == 0) {
            [dic setValue:@"本区最热" forKey:@"name"];
        } else {
            [dic setValue:@"最近更新" forKey:@"name"];
        }
        
        [(RecommendCollectionReusableView *)view setValueWithDic:dic];
    } else {
        
        [(ChannelFooterCollectionReusableView *)view setTitleOfFooter:@"查看更多热门" withSection:indexPath.section];
        [(ChannelFooterCollectionReusableView *)view setClickFooterBlock:^(NSInteger section){
           
            // 点击了查看更多热门
#warning next page ****************************
            
            
            
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
            MoreHotCollectionViewController *hotVC = [[MoreHotCollectionViewController alloc]initWithCollectionViewLayout:layout];
            
            hotVC.name = self.name;
            [hotVC loadDataWithChannelId:self.channelIds];
            
            [self.navigationController pushViewController:hotVC animated:YES];
            
        }];
    }
    
    
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"选中了%ld,%ld",indexPath.section,indexPath.item);
    SubModel *model = self.dataSource[indexPath.section][indexPath.item];
    NSString *str = [model.contentId substringFromIndex:2];
    UIStoryboard *sub = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
    DetailVideoViewController *subVC = [sub instantiateViewControllerWithIdentifier:@"detail_Video"];
    [subVC loadDataWithVideoId:[str integerValue]];
    [self.navigationController pushViewController:subVC animated:NO];
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

@end
