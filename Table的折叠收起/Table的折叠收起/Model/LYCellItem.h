//
//  LYCellItem.h
//  TableView的折叠收起
//
//  Created by liyang on 16/6/15.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LYCellItem : NSObject

@property (nonatomic, copy) NSString *name;

/** cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;


+ (instancetype)cellItemWithDic:(NSDictionary *)dict;

@end
