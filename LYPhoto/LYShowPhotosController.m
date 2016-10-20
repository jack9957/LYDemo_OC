//
//  LYShowPhotosController.m
//  LYImagePicker
//
//  Created by liyang on 16/10/12.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYShowPhotosController.h"
#import "LYPhotoBrowseController.h" // 图片浏览器
#import "LYImagePickController.h" // navgationController
/** 辅助布局用的类别 */
#import "UIView+LYViewFrame.h"
#import "SVProgressHUD.h"

@interface LYShowPhotosController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSInteger minPhotoNo;
    NSInteger maxPhotoNo;
}
/** collectView */
@property (nonatomic, strong) UICollectionView *photsCollectView;

/** 所有的图片数据 */
@property (nonatomic, strong) NSMutableArray<LYAssetModel *> *assetArray;

/** 选中的图片的数组 */
@property (nonatomic, strong) NSMutableArray<LYAssetModel *> *selectedAssets;

/** toolBarView */
@property (nonatomic, strong) LYToolView *toolBarView;

@end


@implementation LYShowPhotosController

- (UICollectionView *)photsCollectView
{
    if (!_photsCollectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 间隔
        CGFloat margin = 5;
        CGFloat itemWH = (self.view.ly_width - (4 + 1) * margin) / 4;
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        layout.minimumInteritemSpacing = margin;
        layout.minimumLineSpacing = margin;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:collectionView];
        
        //注册Class,实现重用
        [collectionView registerClass:[LYAssetCell class] forCellWithReuseIdentifier:@"assetCell"];
        self.photsCollectView = collectionView;
    }
    return _photsCollectView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LYImagePickController *imgPick = (LYImagePickController *)self.navigationController;
    minPhotoNo = imgPick.minSelectNo;
    maxPhotoNo = imgPick.maxSelectNo;
    
    self.toolBarView = imgPick.toolView;
    
    [self setupBase];
    
    [self setupViewWithData];
}

#pragma mark - 界面的基本设置
- (void)setupBase
{
    self.navigationItem.title = self.albumModel.name;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleBarBtnItem:)];
    
    [self.toolBarView.toolBtn addTarget:self action:@selector(toolBarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView.preBtn addTarget:self action:@selector(toolBarPreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectedAssets = [NSMutableArray array];
}

// NavBar上--取消按钮事件
- (void)cancleBarBtnItem:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// 工具条上--完成按钮事件
- (void)toolBarBtnAction:(UIButton *)sender
{
    LYImagePickController *pick = (LYImagePickController *)self.navigationController;
    if ([pick.pickDelegate respondsToSelector:@selector(kLYImagePickController:selectItems:)]) {
        [pick.pickDelegate kLYImagePickController:pick selectItems:self.selectedAssets];
    }
    [pick dismissViewControllerAnimated:YES completion:nil];
}

// 工具条上--预览按钮事件
- (void)toolBarPreBtnAction:(UIButton *)sender
{
    [self pushBrowsePhotoVcByIndex:0 clickByCell:NO];
}

#pragma mark - 获取数据
- (void)setupViewWithData
{
    [[LYImageManager sharedImageManager] getAllMediaByAlbumModel:self.albumModel completion:^(NSArray<LYAssetModel *> *medias) {
        self.assetArray = [NSMutableArray arrayWithArray:medias];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.photsCollectView reloadData];
        });
    }];
}

#pragma mark - CollectView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LYAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"assetCell" forIndexPath:indexPath];
    if (indexPath.row%2==0) {
        cell.backgroundColor = [UIColor greenColor];
    }else{
        cell.backgroundColor = [UIColor blueColor];
    }
    cell.assetModel = self.assetArray[indexPath.item];
    
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    cell.assetCellBlock = ^(BOOL select){
        // 1、判断此时选择assetModel的是否在选中数组中
        if ([self.selectedAssets containsObject:weakCell.assetModel]){
            // 在
            weakCell.assetModel.selectedAsset = !weakCell.assetModel.selectedAsset;
            [weakSelf.selectedAssets removeObject:weakCell.assetModel];
            weakCell.selectStateImg.image = [UIImage imageNamedFromMyBundle:@"photo_original_def"];
        }else{
            // 不在
            // 2、判断此时最大存储数
            if (self.selectedAssets.count > maxPhotoNo-1) {
                // 2-1、不可以继续存储
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"最多选择%ld项", maxPhotoNo]];
            }else{
                // 2-2、可以继续存储,更改此时asset的状态
                weakCell.assetModel.selectedAsset = !weakCell.assetModel.selectedAsset;
                // 3、判断此时的状态，YES继续存，NO删除当前asset
                if (weakCell.assetModel.selectedAsset == YES) {
                    // 3-1、添加
                    [weakSelf.selectedAssets addObject:weakCell.assetModel];
                    weakCell.selectStateImg.image = [UIImage imageNamedFromMyBundle:@"photo_sel_photoPickerVc"];
                }else{
                    // 3-2、移除
                    [weakSelf.selectedAssets removeObject:weakCell.assetModel];
                    weakCell.selectStateImg.image = [UIImage imageNamedFromMyBundle:@"photo_original_def"];
                }
            }
        }
        weakSelf.toolBarView.noLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)weakSelf.selectedAssets.count];
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushBrowsePhotoVcByIndex:indexPath.item clickByCell:YES];
}

#pragma mark push出图片浏览器
- (void)pushBrowsePhotoVcByIndex:(NSInteger)index clickByCell:(BOOL)clickByCell
{    
    LYPhotoBrowseController *photoBrowse = [[LYPhotoBrowseController alloc] init];
    if (clickByCell==YES) {
        photoBrowse.index = index;
        photoBrowse.items = self.assetArray;
        photoBrowse.selectItems = self.selectedAssets;
    }else{
        photoBrowse.index = 0;
        photoBrowse.selectItems = self.selectedAssets;
    }
    __weak typeof(self) weakSelf = self;
    photoBrowse.BrowseBlock = ^(NSMutableArray<LYAssetModel *> *selectItems){
        weakSelf.selectedAssets = selectItems;
        [weakSelf.photsCollectView reloadData];
    };
    [self.navigationController pushViewController:photoBrowse animated:YES];
}

@end


#pragma mark - LYAssetCell
@interface LYAssetCell ()

@property (weak, nonatomic) UIImageView *photoImg;
@property (weak, nonatomic) UIButton *selectBtn;
@property (weak, nonatomic) UIView *video_view;
@property (weak, nonatomic) UIImageView *video_img;
@property (weak, nonatomic) UILabel *video_timeLength;

@end

@implementation LYAssetCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.photoImg.clipsToBounds = YES;
}

- (void)setAssetModel:(LYAssetModel *)assetModel
{
    _assetModel = assetModel;
    
    if (assetModel.type == LY_VideoType) {
        self.video_view.hidden = NO;
        [self video_img];
        self.video_timeLength.text = assetModel.video_time;
    }else{
        self.video_view.hidden = YES;
    }
    [self selectBtn];
    [self selectStateImg];
    
    if (assetModel.selectedAsset == YES) {
        self.selectStateImg.image = [UIImage imageNamedFromMyBundle:@"photo_sel_photoPickerVc"];
    }else{
        self.selectStateImg.image = [UIImage imageNamedFromMyBundle:@"photo_original_def"];
    }
    
    [[LYImageManager sharedImageManager] getPhotoWithAsset:assetModel.asset photoWidth:self.ly_width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        self.photoImg.image = photo;
        assetModel.thumbImage = photo;
    }];
    
    [[LYImageManager sharedImageManager] getOriginalPhotoWithAsset:assetModel.asset completion:^(UIImage *photo, NSDictionary *info) {
        assetModel.originImg = photo;
    }];
}

- (void)selectPhotoButtonClick:(UIButton *)sender
{
    
    if (self.assetCellBlock) {
        self.assetCellBlock(YES);
    }
}

// 懒加载
- (UIButton *)selectBtn
{
    if (_selectBtn == nil) {
        UIButton *selectPhotoButton = [[UIButton alloc] init];
        selectPhotoButton.frame = CGRectMake(self.ly_width - 44, 0, 44, 44);
        [selectPhotoButton addTarget:self action:@selector(selectPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selectPhotoButton];
        self.selectBtn = selectPhotoButton;
    }
    return _selectBtn;
}

- (UIImageView *)photoImg
{
    if (_photoImg == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, self.ly_width, self.ly_height);
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        self.photoImg = imageView;
        
        [self.contentView bringSubviewToFront:self.selectBtn];
        [self.contentView bringSubviewToFront:self.selectStateImg];
    }
    return _photoImg;
}

- (UIImageView *)selectStateImg
{
    if (_selectStateImg == nil) {
        UIImageView *selectImageView = [[UIImageView alloc] init];
        selectImageView.frame = CGRectMake(self.ly_width - 27, 0, 27, 27);
        selectImageView.image = [UIImage imageNamedFromMyBundle:@"photo_original_def"];
        [self.contentView addSubview:selectImageView];
        _selectStateImg = selectImageView;
    }
    return _selectStateImg;
}

- (UIView *)video_view
{
    if (_video_view == nil) {
        UIView *bottomView = [[UIView alloc] init];
        bottomView.frame = CGRectMake(0, self.ly_height - 17, self.ly_width, 17);
        bottomView.backgroundColor = [UIColor blackColor];
        bottomView.alpha = 0.8;
        [self.contentView addSubview:bottomView];
        _video_view = bottomView;
    }
    return _video_view;
}

- (UIImageView *)video_img
{
    if (_video_img == nil) {
        UIImageView *viewImgView = [[UIImageView alloc] init];
        viewImgView.frame = CGRectMake(8, 0, 17, 17);
        [viewImgView setImage:[UIImage imageNamedFromMyBundle:@"VideoSendIcon"]];
        [self.video_view addSubview:viewImgView];
        _video_img = viewImgView;
    }
    return _video_img;
}

- (UILabel *)video_timeLength
{
    if (_video_timeLength == nil) {
        UILabel *timeLength = [[UILabel alloc] init];
        timeLength.font = [UIFont boldSystemFontOfSize:11];
        timeLength.frame = CGRectMake(self.video_img.ly_frameMaxX, 0, self.ly_width - self.video_img.ly_frameMaxX - 5, 17);
        timeLength.textColor = [UIColor whiteColor];
        timeLength.textAlignment = NSTextAlignmentRight;
        [self.video_view addSubview:timeLength];
        _video_timeLength = timeLength;
    }
    return _video_timeLength;
}

@end
