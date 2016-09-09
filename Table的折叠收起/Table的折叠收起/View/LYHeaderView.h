//
//  LYHeaderView.h
//  TableView的折叠收起
//
//  Created by liyang on 16/6/15.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYSectionItem;
@class LYHeaderView;

//处理点击事件
@protocol HeaderViewDelegate <NSObject>
@optional

- (void)headerViewClick:(LYHeaderView *)headerView;

@end

@interface LYHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign) id<HeaderViewDelegate>delegate;

@property (nonatomic, strong) LYSectionItem *sectionItem;

+ (instancetype)headerView:(UITableView *)tableView;

@end
