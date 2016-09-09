//
//  LYSectionItem.m
//  TableView的折叠收起
//
//  Created by liyang on 16/6/15.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYSectionItem.h"
#import "LYCellItem.h"

@implementation LYSectionItem

+ (instancetype)sectionItemWithDic:(NSDictionary *)dict
{
    LYSectionItem *item = [[LYSectionItem alloc] init];
    item.name = dict[@"sectionName"];
    item.isOpen = YES;
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dic in dict[@"cellItems"]) {
        LYCellItem *cellItem = [LYCellItem cellItemWithDic:dic];
        [temp addObject:cellItem];
    }
    item.cellItems = temp;
    
    return item;
}

@end
