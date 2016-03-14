//
//  NewComicListCollectionViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/7.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "NewComicListCollectionViewController.h"
#import "ComicDetailFirstCollectionViewCell.h"
#import "ComicDetailViewController.h"
#import "DataHelper.h"
#import "NewComicListModel.h"

#define kBangumiURLStr @"http://api.aixifan.com/searches/bangumi?&pageNo=%ld&pageSize=10&sort=4&bangumiTypes=1&isNewBangumi=1"

@interface NewComicListCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSMutableArray *dataSource;

//@property (nonatomic,assign)NSInteger sub_Id;  // 频道id

// 网址参数
@property (nonatomic,assign)NSInteger channelIds;  // 频道id
@property (nonatomic,assign)NSInteger pageNo;  // 页码
@property (nonatomic,assign)NSInteger pageSize;  // 每次请求数据量;
@property (nonatomic,assign)NSInteger sort;  // 排序类型
@property (nonatomic,assign)NSInteger range;  // 时间范围

@end

@implementation NewComicListCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray arrayWithCapacity:1];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ComicDetailFirstCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"comicCell"];
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 自定义方法

/** 请求数据 */
- (void)loadDataWithChannelId:(NSInteger)channelId {
    
    self.channelIds = channelId;
    self.pageSize = 4;
    self.pageNo = 1;
    self.sort = 1;
    
    NSString *urlStr = [NSString stringWithFormat:kBangumiURLStr,(long)self.pageNo];
    
    [DataHelper getDataSourceWithURLStr:urlStr withBlock:^(NSDictionary *dic) {
        
        NSArray *array = dic[@"data"][@"list"];
//        NSLog(@"%@",dic);
        for (NSDictionary *dic in array) {
            NewComicListModel *model = [[NewComicListModel alloc]initWithDic:dic];
            [self.dataSource addObject:model];
        }
        [self.collectionView reloadData];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ComicDetailFirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"comicCell" forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NewComicListModel *model = self.dataSource[indexPath.item];
    [(ComicDetailFirstCollectionViewCell *)cell setValueWithNewComicListModel:model];
    
}

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return CGSizeMake(kScreenWidth - 4, 140);
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NewComicListModel *model = self.dataSource[indexPath.item];
    
    UIStoryboard *sub = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
    ComicDetailViewController *subVC = [sub instantiateViewControllerWithIdentifier:@"comic_detail"];
    //            NSLog(@"%ld",[subModel.url integerValue]);
    [subVC loadDataWithBangumisId:model.bangumiId];
//    NSLog(@"+-*+-*  %ld",model.bangumiId);
//    [self.navigationController pushViewController:subVC animated:NO];
    [self presentViewController:subVC animated:YES completion:nil];
    
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
