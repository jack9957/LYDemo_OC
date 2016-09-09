//
//  LYTableViewCell.h
//  TableView的折叠收起
//
//  Created by liyang on 16/6/15.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYCellItem;
@interface LYTableViewCell : UITableViewCell
/** sectionItem */
@property (nonatomic, strong) LYCellItem *cellItem;

@end
