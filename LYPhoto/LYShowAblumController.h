//
//  LYShowAblumController.h
//  LYImagePicker
//
//  Created by liyang on 16/10/13.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYAlbumModel;

@interface LYShowAblumController : UITableViewController

@end


@interface LYShowAblumCell : UITableViewCell

/** 模型数据 */
@property (nonatomic, strong) LYAlbumModel *model;

@end
