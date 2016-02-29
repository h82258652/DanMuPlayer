//
//  ComicCollectionViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/27.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "ComicCollectionViewController.h"
#import "RollPlayCollectionViewCell.h"
#import "VideoCollectionViewCell.h"
#import "BannerCollectionViewCell.h"
#import "ComicCollectionViewCell.h"
#import "ArticleCollectionViewCell.h"
#import "SortCollectionViewCell.h"
#import "UpCollectionViewCell.h"
#import "DataHelper.h"

#import "RecommendCollectionReusableView.h"

#import "RecommendModel.h"

@interface ComicCollectionViewController ()

@property (nonatomic,strong)NSMutableArray *dataSource;  // 数据源

@end

@implementation ComicCollectionViewController

static NSString * const nameOfMessage = @"changeModelOfComic";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray arrayWithCapacity:1];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // 注册cell
    [self.collectionView registerClass:[RollPlayCollectionViewCell class] forCellWithReuseIdentifier:@"rollCell"];  // 轮播cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"videoCell"]; // 视频cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"BannerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bannerCell"]; // 横幅cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ComicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"comicCell"];  // 番剧cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ArticleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"articleCell"];  // 文章cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"SortCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"sortCell"];  // 排行榜cell
    
    // 注册页眉页脚
    [self.collectionView registerNib:[UINib nibWithNibName:@"RecommendCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeModel:) name:nameOfMessage object:nil];  // 请求到新的数据
}

#pragma mark - 自定义事件
// 请求数据
- (void)loadData {
    
    dispatch_queue_t queue = dispatch_queue_create("com.Comic.loadData", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [DataHelper getDataSourceForCommendWithURLStr:[NSString stringWithFormat:kRegionsWithBelongURLStr,155] withName:nameOfMessage withBlock:^(NSDictionary *dic) {
            self.dataSource = [NSMutableArray arrayWithArray:dic[@"dataArray"]];
            //            NSLog(@"%@",[NSThread currentThread]);
            [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }];
    });
    
    
}
// 当请求到新的内容时，刷新界面
- (void)changeModel:(NSNotification *)sender {
    
    NSDictionary *dic = sender.userInfo;
    
    for (RecommendModel *model in self.dataSource) {
        if (model.recommend_id == [dic[@"model_id"] integerValue]) {
            model.contents = dic[@"dataArray"];
            // 刷新界面
            [self.collectionView reloadData];
        }
    }
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
#warning Incomplete implementation, return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"comicCell" forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
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
