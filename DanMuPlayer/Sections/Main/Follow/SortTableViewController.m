//
//  SortTableViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/3/6.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "SortTableViewController.h"
#import "SortTableViewCell.h"
#import "DataHelper.h"
#import "SubModel.h"

#import "DetailVideoViewController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"

@interface SortTableViewController ()

@property (nonatomic,strong)NSMutableArray *dataSource;  // 数据源
@property (nonatomic,assign)NSInteger pageNO;  // 页码

@end

@implementation SortTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    self.pageNO = 1;
    self.dataSource = [NSMutableArray arrayWithCapacity:1];
    
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addDataSource)];
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshPage)];
}

#pragma mark - 自定义方法
/** 请求数据 */
- (void)loadDataWithURLStr:(NSString *)urlStr
{
    
    [DataHelper getDataSourceForSubWithURLStr:urlStr andParameters:nil withBlock:^(NSDictionary *dic) {
        
        if ([dic[@"data"] count] < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView.mj_header endRefreshing];
        
        [self.dataSource addObjectsFromArray:dic[@"data"]];
        [self.tableView reloadData];
    }];
    
}
/** 上拉加载 */
- (void)addDataSource {
    
    self.pageNO++;
    [self loadDataWithURLStr:[NSString stringWithFormat:kSortMainURLStr,self.pageNO]];
}
/** 下拉刷新 */
- (void)refreshPage {
    [self.dataSource removeAllObjects];
    self.pageNO = 1;
    [self loadDataWithURLStr:[NSString stringWithFormat:kSortMainURLStr,self.pageNO]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
// 分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

// 选择cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sort_tb_cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
// 为cell赋值
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SubModel *model = self.dataSource[indexPath.row];
    [(SortTableViewCell *)cell setValueWithSubModel:model];
    
}
// 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SubModel *model = self.dataSource[indexPath.item];
    NSString *str = [model.contentId substringFromIndex:2];
    UIStoryboard *sub = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
    DetailVideoViewController *subVC = [sub instantiateViewControllerWithIdentifier:@"detail_Video"];
    [subVC loadDataWithVideoId:[str integerValue]];
    [self.navigationController pushViewController:subVC animated:NO];
    
}
// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 80;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
