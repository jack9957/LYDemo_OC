//
//  LYTableViewCell.m
//  TableView的折叠收起
//
//  Created by liyang on 16/6/15.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYTableViewCell.h"
#import "LYCellItem.h"

@interface LYTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation LYTableViewCell

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (void)setCellItem:(LYCellItem *)cellItem
{
    _cellItem = cellItem;
    
    self.titleLabel.text = cellItem.name;
    
    cellItem.cellHeight = 50;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(10, 5, self.bounds.size.width - 20, self.bounds.size.height - 10);
}
@end
