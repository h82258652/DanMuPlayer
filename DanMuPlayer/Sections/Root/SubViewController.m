//
//  SubViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/2/29.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "SubViewController.h"
#import "RecommendCollectionViewController.h"
#import "SubCollectionViewController.h"
#import "NewComicListCollectionViewController.h"

#import "RecommendCellModel.h"
#import "ChannelSubModel.h"

#import "DataHelper.h"

@interface SubViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *FlagScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *MainScrollView;

@property (nonatomic,strong) UILabel *titleLable;  // 标题

@property (nonatomic,strong)NSMutableArray *flagArray;  // 标签数组

@property (nonatomic,assign)NSInteger countOfPage;  // 总页数

@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    NSLog(@"加载完成");
    
    self.FlagScrollView.showsHorizontalScrollIndicator = NO;
    self.MainScrollView.pagingEnabled = YES;
    self.MainScrollView.showsVerticalScrollIndicator = NO;
    self.MainScrollView.showsHorizontalScrollIndicator = NO;
    
    self.MainScrollView.delegate = self;
    
    // 创建titleLabel 作用是掩盖自带的 title
    self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 80) / 2, 0, kScreenWidth, 44)];
    self.navigationItem.titleView = self.titleLable;
    
//    NSLog(@"aaa");
//    self.FlagScrollView = [UIScrollView alloc]initWithFrame:CGRectMake(0, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
//    NSLog(@"%@",self.navigationItem.titleView.subviews);
}

#pragma mark - 自定义方法

/** 使用主model创建 */
- (void)setUpWithRecommendModel:(RecommendModel *)model withCustomIndex:(NSInteger)customIndex {
    
    CGRect frameOfFlagScrollView = self.FlagScrollView.frame;
    frameOfFlagScrollView.size = CGSizeMake(kScreenWidth, CGRectGetHeight(self.FlagScrollView.frame));
    self.FlagScrollView.frame = frameOfFlagScrollView;
    
    CGRect frameOfMainScrollView = self.MainScrollView.frame;
    frameOfMainScrollView.size = CGSizeMake(kScreenWidth, kScreenHeight - CGRectGetMaxY(self.FlagScrollView.frame));
    self.MainScrollView.frame = frameOfMainScrollView;
    self.MainScrollView.contentSize = CGSizeMake(0, 44);
    
    NSInteger numberOfStart = 0;
    
    if (model.channelId == 155 || model.channelId == 60 || model.channelId == 63) {
        numberOfStart = 0;
        self.countOfPage = model.contents.count;
    } else {
        // 创建推荐界面
        [self setUpRecommendPage:model.channelId];
        numberOfStart = 1;
        self.countOfPage = model.contents.count + 1;
    }
    
    // 创建其他界面
    
    [model.contents enumerateObjectsUsingBlock:^(RecommendCellModel *  _Nonnull sub_model, NSUInteger idx, BOOL * _Nonnull stop) {
        // 创建视图
        [self setUpSubPageWithModel_Id:[sub_model.url integerValue] withName:sub_model.title];
        
        // 创建btn
        [self setUpBtnWithTitle:sub_model.title andTag:(160 + numberOfStart + idx)];
    }];
    
    //    self.MainScrollView.contentSize = CGSizeMake(kScreenWidth * (model.childChannels.count + numberOfStart), CGRectGetHeight(self.MainScrollView.bounds));
    
    // 默认页面
    if (customIndex == -1) {
        UIButton *btn = [self.FlagScrollView viewWithTag:160];
        btn.selected = YES;
    } else {
        [self setCustomPageWithIndex:customIndex withNumberOfStart:numberOfStart];
    }
    
    
}

/** 使用频道model创建 */
- (void)setUpWithChannelModel:(ChannelModel *)model WithCustomIndex:(NSInteger)customIndex{
    
    CGRect frameOfFlagScrollView = self.FlagScrollView.frame;
    frameOfFlagScrollView.size = CGSizeMake(kScreenWidth, CGRectGetHeight(self.FlagScrollView.frame));
    self.FlagScrollView.frame = frameOfFlagScrollView;
    
    CGRect frameOfMainScrollView = self.MainScrollView.frame;
    frameOfMainScrollView.size = CGSizeMake(kScreenWidth, kScreenHeight - CGRectGetMaxY(self.FlagScrollView.frame));
    self.MainScrollView.frame = frameOfMainScrollView;
    
    self.MainScrollView.contentSize = CGSizeMake(0, 44);
    
    NSInteger numberOfStart = 0;
    
    if (model.channel_Id == 155 || model.channel_Id == 60 || model.channel_Id == 63) {
        numberOfStart = 0;
        self.countOfPage = model.childChannels.count;
    } else {
        // 创建推荐界面
        [self setUpRecommendPage:model.channel_Id];
        numberOfStart = 1;
        self.countOfPage = model.childChannels.count + 1;
    }
    
    // 创建其他界面
    
    [model.childChannels enumerateObjectsUsingBlock:^(ChannelSubModel *  _Nonnull sub_model, NSUInteger idx, BOOL * _Nonnull stop) {
        // 创建视图
        [self setUpSubPageWithModel_Id:sub_model.sub_Id withName:sub_model.name];
        
        // 创建btn
        [self setUpBtnWithTitle:sub_model.name andTag:(160 + numberOfStart + idx)];
    }];
    
//    self.MainScrollView.contentSize = CGSizeMake(kScreenWidth * (model.childChannels.count + numberOfStart), CGRectGetHeight(self.MainScrollView.bounds));
    
    // 默认页面
    if (customIndex == -1) {
        UIButton *btn = [self.FlagScrollView viewWithTag:160];
        btn.selected = YES;
    } else {
        [self setCustomPageWithIndex:customIndex withNumberOfStart:numberOfStart];
    }
    
}



/** 创建推荐界面并请求数据 */
- (void)setUpRecommendPage:(NSInteger)model_Id {
    
    NSLog(@"ccc");
    
    // 创建推荐界面并请求数据
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    RecommendCollectionViewController *rVC = [[RecommendCollectionViewController alloc]initWithCollectionViewLayout:layout];
    
    rVC.view.frame = self.MainScrollView.bounds;
    rVC.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewController:rVC];
    
    self.MainScrollView.contentSize = self.MainScrollView.frame.size;
    [self.MainScrollView addSubview:rVC.collectionView];
    
    // 创建推荐btn
    [self setUpBtnWithTitle:@"推荐" andTag:160];
    
    // 设置数据
    rVC.mainURLStr = [NSString stringWithFormat:kRegionsWithBelongURLStr,model_Id];
    
//    NSLog(@"%@",NSStringFromCGRect(self.MainScrollView.frame));
}

/** 创建其他界面并请求数据 */
- (void)setUpSubPageWithModel_Id:(NSInteger)model_Id withName:(NSString *)name{
    
//    NSLog(@"%ld ----- %@",model_Id,name);
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    if (model_Id == 156) {  // 新番列表
        NewComicListCollectionViewController *newVC = [[NewComicListCollectionViewController alloc]initWithCollectionViewLayout:layout];
        newVC.view.frame = CGRectMake(self.MainScrollView.contentSize.width, 0, kScreenWidth, CGRectGetHeight(self.MainScrollView.bounds));
        [self.MainScrollView addSubview:newVC.view];
        [self addChildViewController:newVC];
        
        self.MainScrollView.contentSize = CGSizeMake(self.MainScrollView.contentSize.width + kScreenWidth, CGRectGetHeight(self.MainScrollView.bounds));
        
        // 设置数据
        newVC.name = name;
        [newVC loadDataWithChannelId:model_Id];
        
    } else {
        
        
        // 创建collectionView
        SubCollectionViewController *subVC = [[SubCollectionViewController alloc]initWithCollectionViewLayout:layout];
        subVC.view.frame = CGRectMake(self.MainScrollView.contentSize.width, 0, kScreenWidth, CGRectGetHeight(self.MainScrollView.bounds));
        
        [self.MainScrollView addSubview:subVC.view];
        [self addChildViewController:subVC];
        
        self.MainScrollView.contentSize = CGSizeMake(self.MainScrollView.contentSize.width + kScreenWidth, CGRectGetHeight(self.MainScrollView.bounds));
        
        // 设置数据
        subVC.name = name;
        [subVC loadDataWithChannelId:model_Id];
        
    }
    
    
}

#pragma mark - 配置btn
/** 创建btn */
- (void)setUpBtnWithTitle:(NSString *)title andTag:(NSInteger)tag {
    
    
    // 创建推荐btn
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 计算btn的长度
    CGFloat widthOfBtn = [self calculateWidthForStr:title];
    btn.frame = CGRectMake(self.FlagScrollView.contentSize.width + 10, -64, widthOfBtn, CGRectGetHeight(self.FlagScrollView.frame));
    
//    NSLog(@"%@",NSStringFromCGRect(btn.frame));
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
    
    NSLog(@"%@",title);
    
    btn.tag = tag;
    [self.FlagScrollView addSubview:btn];
    
    
    self.FlagScrollView.contentSize = CGSizeMake(CGRectGetMaxX(btn.frame), CGRectGetHeight(self.FlagScrollView.bounds));
    
    // btn点击事件
    [btn addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
/** 动态计算btn宽度 */
- (CGFloat)calculateWidthForStr:(NSString *)str {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
    return [str boundingRectWithSize:CGSizeMake(2000, CGRectGetHeight(self.FlagScrollView.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.width;
}

/** btn点击事件 */
- (void)handleAction:(UIButton *)sender {
    
    NSInteger tag = sender.tag;
    [self changeStateForBtnWithTag:tag];
    // 移动flag
    [self moveFlagViewWithTag:tag];
    
    self.MainScrollView.contentOffset = CGPointMake(kScreenWidth * (tag - 160), 0);
    
}
/** 改变btn的状态 */
- (void)changeStateForBtnWithTag:(NSInteger)tag {
    
    for (int i = 160; i < self.countOfPage + 160; i++) {
        UIButton *btn = [self.FlagScrollView viewWithTag:i];
        if (i == tag) {
            btn.selected = YES;
            
//            NSLog(@"%@",btn.titleLabel);
            self.navigationItem.title = btn.titleLabel.text;
        } else {
            btn.selected = NO;
        }
    }
}

/** 设置默认界面 */
- (void)setCustomPageWithIndex:(NSInteger)index withNumberOfStart:(NSInteger)numberOfStart {
    
//    UIButton *btn = [self.FlagScrollView viewWithTag:(160 + index + numberOfStart)];
//    btn.selected = YES;
    
    [self changeStateForBtnWithTag:(160 + index + numberOfStart)];
    [self moveFlagViewWithTag:(160 + index + numberOfStart)];
    self.MainScrollView.contentOffset = CGPointMake(kScreenWidth * (index + numberOfStart), 0);
    
    
}


#pragma mark <UIScrollViewDelegate>
// 滚动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = self.MainScrollView.contentOffset.x / kScreenWidth;
    [self changeStateForBtnWithTag:index + 160];
    
    // 判断是否移动flagView
    [self moveFlagViewWithTag:index + 160];
    
}

/** 判断是否移动flagView */
- (void)moveFlagViewWithTag:(NSInteger)tag {
    
    UIButton *btn = [self.FlagScrollView viewWithTag:tag];
    CGFloat widthOfFlag = self.FlagScrollView.contentSize.width;
    CGFloat xOfCenterOfBtn = btn.center.x;
//    NSLog(@"%f",self.FlagScrollView.center.y);
    if (widthOfFlag > kScreenWidth) {
        
        CGPoint point;
//        CGFloat yOfFlag = self.FlagScrollView.center.y;
        
        if (xOfCenterOfBtn > kScreenWidth / 2 && widthOfFlag - xOfCenterOfBtn > kScreenWidth / 2) {
            point = CGPointMake(xOfCenterOfBtn - kScreenWidth / 2, 0);
        } else if (widthOfFlag - xOfCenterOfBtn < kScreenWidth / 2) {
            point = CGPointMake(widthOfFlag - kScreenWidth, 0);
        } else {
            point = CGPointMake(0, 0);
        }
        NSLog(@"%@",NSStringFromCGPoint(point));
        [UIView animateWithDuration:0.5 animations:^{
            self.FlagScrollView.contentOffset = point;
        }];
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 状态栏切换
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backgroundColor = kThemeColor;
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

@end
