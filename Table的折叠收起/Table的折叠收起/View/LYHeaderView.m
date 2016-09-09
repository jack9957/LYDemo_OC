//
//  LYHeaderView.m
//  TableView的折叠收起
//
//  Created by liyang on 16/6/15.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYHeaderView.h"
#import "LYSectionItem.h"

@interface LYHeaderView ()
@property (nonatomic, strong) UIButton *arrowBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation LYHeaderView

+ (instancetype)headerView:(UITableView *)tableView
{
    static NSString *kHeadIdentifier = @"header";
    
    LYHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeadIdentifier];
    if (!headerView) {
        headerView = [[self alloc] initWithReuseIdentifier:kHeadIdentifier];
    }
    return headerView;
}

- (UIButton *)arrowBtn
{
    if (!_arrowBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 距离
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        //内容的水平对齐方式
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        button.imageView.contentMode = UIViewContentModeCenter;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        //不裁剪图片
        button.imageView.clipsToBounds = NO;
        [self addSubview:button];
        self.arrowBtn = button;
    }
    return _arrowBtn;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *labelRight = [[UILabel alloc] init];
        labelRight.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labelRight];
        self.titleLabel = labelRight;
    }
    return _titleLabel;
}

- (void)setSectionItem:(LYSectionItem *)sectionItem
{
    _sectionItem = sectionItem;
    
    [self.arrowBtn setTitle:sectionItem.name forState:UIControlStateNormal];
    self.titleLabel.text = [NSString stringWithFormat:@"%ld", sectionItem.cellItems.count];
    
    // 添加观察者，观察isOpen属性的变化，来调节指示器的状态
    [self addObserver:self forKeyPath:@"sectionItem.isOpen" options:NSKeyValueObservingOptionInitial context:nil];
}

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    // 改变button图片的旋转读
    self.arrowBtn.imageView.transform = self.sectionItem.isOpen ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformMakeRotation(0);
}

//布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.arrowBtn.frame = self.bounds;
    self.titleLabel.frame = CGRectMake(self.bounds.size.width - 70, 0, 60, self.frame.size.height);
}

#pragma mark - buttonAction
- (void)buttonAction:(UIButton *)sender
{
    //修改groupModel的isOpen属性
    self.sectionItem.isOpen = !self.sectionItem.isOpen;
    if ([self.delegate respondsToSelector:@selector(headerViewClick:)]) {
        [self.delegate headerViewClick:self];
    }
}
@end
