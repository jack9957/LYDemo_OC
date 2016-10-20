//
//  LYShowAblumController.m
//  LYImagePicker
//
//  Created by liyang on 16/10/13.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYShowAblumController.h"
#import "LYImagePickController.h"
// 展示图片
#import "LYShowPhotosController.h"

#import "LYImageManager.h"
#import "UIView+LYViewFrame.h"

@interface LYShowAblumController ()

@property (nonatomic, strong) NSArray<LYAlbumModel *> *albumsArray;

@end

@implementation LYShowAblumController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 70;
    
    [self.tableView registerClass:[LYShowAblumCell class] forCellReuseIdentifier:@"LYShowAblumCellId"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.navigationItem.title = @"所有相册";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleBarBtnItem:)];
    
    [self setupviewWithData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LYImagePickController *imgPick = (LYImagePickController *)self.navigationController;
    imgPick.toolView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    LYImagePickController *imgPick = (LYImagePickController *)self.navigationController;
    imgPick.toolView.hidden = NO;
}

- (void)cancleBarBtnItem:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 获取数据
- (void)setupviewWithData
{
    [[LYImageManager sharedImageManager] getAllAlbumsType:LY_AllMediaType completion:^(NSArray<LYAlbumModel *> *albums) {
        self.albumsArray = albums;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LYShowAblumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LYShowAblumCellId" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.albumsArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LYShowPhotosController *PhotoVc = [[LYShowPhotosController alloc] init];
    PhotoVc.albumModel = self.albumsArray[indexPath.row];
    [self.navigationController pushViewController:PhotoVc animated:YES];
}


@end


@interface LYShowAblumCell ()

@property (weak, nonatomic) UIImageView *coverImageView;
@property (weak, nonatomic) UILabel *titleLable;
@property (weak, nonatomic) UIImageView *arrowImageView;

@end

@implementation LYShowAblumCell

- (void)setModel:(LYAlbumModel *)model
{
    _model = model;
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:model.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%zd)",model.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [nameString appendAttributedString:countString];
    self.titleLable.attributedText = nameString;
    [self arrowImageView];
    [[LYImageManager sharedImageManager] getImageWithAlbumModel:model completion:^(UIImage *photo) {
        self.coverImageView.image = photo;
    }];
}

// 懒加载
- (UIImageView *)coverImageView {
    if (_coverImageView == nil) {
        UIImageView *posterImageView = [[UIImageView alloc] init];
        posterImageView.contentMode = UIViewContentModeScaleAspectFill;
        posterImageView.clipsToBounds = YES;
        posterImageView.frame = CGRectMake(0, 0, 70, 70);
        [self.contentView addSubview:posterImageView];
        _coverImageView = posterImageView;
    }
    return _coverImageView;
}

- (UILabel *)titleLable {
    if (_titleLable == nil) {
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.font = [UIFont boldSystemFontOfSize:17];
        titleLable.frame = CGRectMake(80, 0, self.ly_width - 80 - 50, self.ly_height);
        titleLable.textColor = [UIColor blackColor];
        titleLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleLable];
        _titleLable = titleLable;
    }
    return _titleLable;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        CGFloat arrowWH = 15;
        arrowImageView.frame = CGRectMake(self.ly_width - arrowWH - 12, 28, arrowWH, arrowWH);
        [arrowImageView setImage:[UIImage imageNamedFromMyBundle:@"Icon_tableViewArrow"]];
        [self.contentView addSubview:arrowImageView];
        _arrowImageView = arrowImageView;
    }
    return _arrowImageView;
}

@end
