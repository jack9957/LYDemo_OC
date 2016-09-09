//
//  LYCellItem.m
//  TableView的折叠收起
//
//  Created by liyang on 16/6/15.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYCellItem.h"

@implementation LYCellItem

+ (instancetype)cellItemWithDic:(NSDictionary *)dict
{
    LYCellItem *item = [[LYCellItem alloc] init];
    item.name = dict[@"cellItemName"];
    return item;
}
@end
