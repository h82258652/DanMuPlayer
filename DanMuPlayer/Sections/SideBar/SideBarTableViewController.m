//
//  SideBarTableViewController.m
//  DanMuPlayer
//
//  Created by 韩少帅 on 16/1/30.
//  Copyright © 2016年 HAN. All rights reserved.
//

#import "SideBarTableViewController.h"
#import "SideBarTableViewCell.h"
#import "SDImageCache.h"
#import "CollectionTableViewController.h"
#import "UMFeedback.h"

@interface SideBarTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topBGImageView;


@end

@implementation SideBarTableViewController

- (void)loadView {
    [super loadView];
//    self.tableView.frame = CGRectMake(0, 0, 300, 200);
 
//    [[[NSBundle mainBundle] loadNibNamed:@"" owner:self options:nil]lastObject];
//    [[UINib nibWithNibName:@"" bundle:nil] ]
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景图片模糊
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    UIVisualEffectView *effectivew = [[UIVisualEffectView alloc]initWithEffect:blur];
//    effectivew.frame = CGRectMake(0, 0, self.topBGImageView.frame.size.width, self.topBGImageView.frame.size.height);
//    [self.topBGImageView addSubview:effectivew];
    
    self.logoImageView.layer.cornerRadius = CGRectGetHeight(self.logoImageView.frame) / 2;
    self.logoImageView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SideBarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sidebar_cell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.cellLabel.text = @"我的收藏";
            cell.cellImageView.image = [UIImage imageNamed:@"collection_did"];
            break;
        case 1:
            cell.cellLabel.text = @"清除缓存";
            cell.cellImageView.image = [UIImage imageNamed:@"sidebar_clear"];
            break;
        case 2:
            cell.cellLabel.text = @"意见反馈";
            cell.cellImageView.image = [UIImage imageNamed:@"sidebar_feedback"];
            break;
        case 3:
            cell.cellLabel.text = @"关于我们";
            cell.cellImageView.image = [UIImage imageNamed:@"sidebar_about"];
            break;
        default:
            break;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"点击了侧边栏");
    switch (indexPath.row) {
        case 0:
        { // 我的收藏
//            CollectionTableViewController *cTB = [[CollectionTableViewController alloc]initWithStyle:UITableViewStylePlain];
//            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:cTB];
//            navi.navigationBar.translucent = NO;
////            [navi.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar_image"] forBarMetrics:UIBarMetricsDefault];
//            
//            [self presentViewController:navi animated:YES completion:nil];
//            [self presentViewController:cTB animated:YES completion:nil];
            
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            UINavigationController *cNA = [storyboard instantiateViewControllerWithIdentifier:@"side_collection_navi"];
//            [self presentViewController:cNA animated:YES completion:nil];
            [self performSegueWithIdentifier:@"side_go_collection_segue" sender:self];
            
            
            break;
        }
        case 1:
            // 清除缓存
            [[SDImageCache sharedImageCache] clearDisk];
            if ([[SDImageCache sharedImageCache] getDiskCount] == 0) {
//                NSLog(@"清除缓存");
                // 清除成功
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"清除缓存成功" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dismissAlert:) userInfo:@{@"alert":alert} repeats:NO];
            }
            
            break;
        case 2:
            // 意见反馈
            [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
            
            
            break;
        case 3:
            // 关于我们
            
            [self performSegueWithIdentifier:@"side_about_navi_segue" sender:self];
            
            break;
        default:
            break;
    }
    
    
    
}

/** 隐藏alert */
- (void)dismissAlert:(NSTimer *)timer
{
    
    UIAlertController *alert = timer.userInfo[@"alert"];
    [alert dismissViewControllerAnimated:YES completion:nil];
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
