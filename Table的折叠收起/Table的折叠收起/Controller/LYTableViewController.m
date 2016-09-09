//
//  LYTableViewController.m
//  Table的折叠收起
//
//  Created by liyang on 16/9/9.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYTableViewController.h"

#import "LYTableViewCell.h"
#import "LYHeaderView.h"

#import "LYSectionItem.h"
#import "LYCellItem.h"

static NSString *const cellIdentifier = @"frinedCell";

@interface LYTableViewController ()<HeaderViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation LYTableViewController

// 懒加载
- (NSArray *)dataArray
{
    if (!_dataArray) {
        
        NSArray *arr = @[ @{
                              @"sectionName":@"sectionName1",
                              @"cellItems":@[
                                      @{@"cellItemName":@"cellName1"},
                                      @{@"cellItemName":@"cellName2"},
                                      @{@"cellItemName":@"cellName3"}
                                      ]
                              },
                          @{
                              @"sectionName":@"sectionName2",
                              @"cellItems"  :@[
                                      @{@"cellItemName":@"cellName1"},
                                      @{@"cellItemName":@"cellName2"},
                                      @{@"cellItemName":@"cellName3"}
                                      ]
                              },
                          @{
                              @"sectionName":@"sectionName3",
                              @"cellItems":@[
                                      @{@"cellItemName":@"cellName1"},
                                      @{@"cellItemName":@"cellName2"},
                                      @{@"cellItemName":@"cellName3"}
                                      ]
                              }];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < 6; i++) {
            for (NSDictionary *dic in arr) {
                LYSectionItem *model = [LYSectionItem sectionItemWithDic:dic];
                [tempArr addObject:model];
            }
        }
        self.dataArray = tempArr;
        
        [self.tableView reloadData];
    }
    return _dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LYSectionItem *sectionItem = self.dataArray[section];
    // 条件表达式。得出row行数
    return sectionItem.isOpen ? sectionItem.cellItems.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    LYSectionItem *sectionItem = self.dataArray[indexPath.section];
    LYCellItem *cellItem = sectionItem.cellItems[indexPath.row];
    
    cell.cellItem = cellItem;
    NSLog(@"cell地址: %p", cell);
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LYSectionItem *sectionItem = self.dataArray[indexPath.section];
    LYCellItem *cellItem = sectionItem.cellItems[indexPath.row];
    return cellItem.cellHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LYSectionItem *sectionItem = self.dataArray[section];
    LYHeaderView *header = [LYHeaderView headerView:tableView];
    header.delegate = self;
    header.sectionItem = sectionItem;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
#pragma mark - HeaderViewDelegate
- (void)headerViewClick:(LYHeaderView *)headerView
{
    // 改变了isopen的值
    [self.tableView reloadData];//刷新数据
}

@end
