//
//  MoreHotCollectionViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/1.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "MoreHotCollectionViewController.h"
#import "MoreHotCollectionViewCell.h"
#import "DetailVideoViewController.h"

#import "RecommendCollectionReusableView.h"

#import "DataHelper.h"

#import "SubModel.h"
#import "MJRefresh.h"

@interface MoreHotCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,assign)NSInteger channel_Id;  // 频道id

@property (nonatomic,strong)NSMutableArray *dataSource;  // 数据源

@property (nonatomic,assign)NSInteger pageNo;  // 页码
@property (nonatomic,assign)NSInteger pageSize;  // 每页请求数量
@property (nonatomic,assign)NSInteger sort;  // 排序

@end

@implementation MoreHotCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray arrayWithCapacity:1];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"MoreHotCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // 注册页眉
    [self.collectionView registerNib:[UINib nibWithNibName:@"RecommendCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self.dataSource removeAllObjects];
        self.pageNo = 1;
        [self loadDataWithChannelId:self.channel_Id];
    }];
    // 上拉加载
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNo++;
        [self loadDataWithChannelId:self.channel_Id];
    }];
    
}

#pragma mark -自定义方法
- (void)loadDataWithChannelId:(NSInteger)channelId {
//    NSLog(@"%ld",self.pageNo);
    self.channel_Id = channelId;
    if (self.pageNo == 0) {
        self.pageNo = 1;
    }
    self.pageSize = 10;
    self.sort = 1;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setValue:@(self.channel_Id) forKey:@"channelIds"];
    [dic setValue:@(self.pageSize) forKey:@"pageSize"];
    [dic setValue:@(self.pageNo) forKey:@"pageNo"];
    [dic setValue:@(self.sort) forKey:@"sort"];
    [dic setValue:@(604800000) forKey:@"range"];
    
    
    [DataHelper getDataSourceForSubWithURLStr:kSearchURLStr andParameters:dic withBlock:^(NSDictionary *info) {
       
        
        if ([info[@"data"] isKindOfClass:[NSError class]]) {  //加载错误
            
            if (self.pageNo == 1) {
                [self.collectionView.mj_header endRefreshing];
            } else {
                [self.collectionView.mj_footer endRefreshing];
            }
            // 提示加载失败
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"抱歉，加载失败" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            [UIView animateWithDuration:3 animations:^{} completion:^(BOOL finished) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
        } else {  // 加载成功
            
            if (self.pageNo == 1) {
                [self.collectionView.mj_header endRefreshing];
                [self.dataSource removeAllObjects];
            } else {
                [self.collectionView.mj_footer endRefreshing];
            }
            
            if ([info[@"data"] count] < 10) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.collectionView.mj_footer endRefreshing];
            }
            [self.dataSource addObjectsFromArray:info[@"data"]];
            [self.collectionView reloadData];
        }
        
        
        
    }];
    
//    NSLog(@"***%ld",channelId);
    
}

/** 返回上一页 */
- (void)backBeforePage {
    
    [self.navigationController popViewControllerAnimated:YES];
    
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MoreHotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}
// 为cell赋值
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SubModel *model = self.dataSource[indexPath.row];
    [(MoreHotCollectionViewCell *)cell setValueWithModel:model];
    
}
// 选择页眉
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    RecommendCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    [headerView setValueWithDic:@{@"name":@"本区最热",@"image":@"section_placeholder"}];
    
    return headerView;
    
}


#pragma mark <UICollectionViewDelegateFlowLayout>
// cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth - 20, kScreenWidth * 5 / 19);
}
// cell 的边界

// 页眉的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth, 50);
    
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"选中了%ld,%ld",indexPath.section,indexPath.row);
    
    SubModel *model = self.dataSource[indexPath.item];
    NSString *str = [model.contentId substringFromIndex:2];
    UIStoryboard *sub = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
    DetailVideoViewController *subVC = [sub instantiateViewControllerWithIdentifier:@"detail_Video"];
    [subVC loadDataWithVideoId:[str integerValue]];
//    [self.navigationController pushViewController:subVC animated:NO];
    [self presentViewController:subVC animated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 状态栏切换
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backgroundColor = kThemeColor;
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
