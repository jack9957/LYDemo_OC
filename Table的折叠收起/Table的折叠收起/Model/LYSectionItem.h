//
//  LYSectionItem.h
//  TableView的折叠收起
//
//  Created by liyang on 16/6/15.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LYSectionItem : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSArray *cellItems;

@property (nonatomic, assign) BOOL isOpen;

+ (instancetype)sectionItemWithDic:(NSDictionary *)dict;

@end
