//
//  LYPhotoBrowseController.m
//  LYImagePicker
//
//  Created by liyang on 16/10/14.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYPhotoBrowseController.h"
#import "LYImagePickController.h"
#import "LYShowPhotosController.h"

#import "UIView+LYViewFrame.h"

@interface LYPhotoBrowseController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIButton *_backButton;
}

/** toolBarView */
@property (nonatomic, strong) LYToolView *toolBarView;

/** navBar */
@property (nonatomic, strong) UIView *navBarView;

/** NavBar上的自定义按钮 */
@property (nonatomic, strong) UIButton *rightBarBtnItem;

/** UICollectView */
@property (nonatomic, strong) UICollectionView *browseCollectView;

@end

@implementation LYPhotoBrowseController


- (UIView *)navBarView
{
    if (!_navBarView) {
        UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLYScreenWidth, 64)];
        bar.backgroundColor = kLYRGBAColor(34, 34, 34, 1);
        [self.view addSubview:bar];
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
        [_backButton setImage:[UIImage imageNamedFromMyBundle:@"NavBack"] forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamedFromMyBundle:@"photo_sel_photoPickerVc"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightBarBtnItemAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(kLYScreenWidth-47, (64-27)/2, 27, 27);
        [bar addSubview:_backButton];
        [bar addSubview:btn];
        
        self.navBarView = bar;
        self.rightBarBtnItem = btn;
    }
    return _navBarView;
}

// collectView
- (UICollectionView *)browseCollectView
{
    if (!_browseCollectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(kLYScreenWidth, kLYScreenHeight-64-44);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.headerReferenceSize = CGSizeMake(0, 0);
        layout.footerReferenceSize = CGSizeMake(0, 0);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.ly_width, self.view.ly_height-64-44) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor blackColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        collectionView.scrollsToTop = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:collectionView];
        [collectionView registerClass:[LYPhotoBrowseCell class] forCellWithReuseIdentifier:@"LYPhotoBrowseCell"];
        self.browseCollectView = collectionView;
        
        [self.view bringSubviewToFront:self.toolBarView];
    }
    return _browseCollectView;
}

- (UIButton *)rightBarBtnItem
{
    if (!_rightBarBtnItem) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamedFromMyBundle:@"photo_sel_photoPickerVc"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightBarBtnItemAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0, 27, 27);
        self.rightBarBtnItem = btn;
    }
    return _rightBarBtnItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBase];
    
    [self setupViewWithModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

#pragma mark 基本设置
- (void)setupBase
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarBtnItem];
    
    [self navBarView];
    
    if (!self.selectItems.count) {
        // 没有数据的话，不显示这个界面
        [SVProgressHUD showInfoWithStatus:@"请先添加数据"];
        [self backBtnAction:nil];
    }
    
    
    LYImagePickController *imgPick = (LYImagePickController *)self.navigationController;
    self.toolBarView = imgPick.toolView;
    [self.toolBarView.toolBtn setTitle:@"发送" forState:UIControlStateNormal];
    self.toolBarView.noLabel.text = [NSString stringWithFormat:@"%lu", self.items.count];
    self.toolBarView.preBtn.hidden = YES;
    
    if (self.selectItems.count && !self.items.count) {
        self.items = [self.selectItems mutableCopy];
        self.toolBarView.noLabel.text = [NSString stringWithFormat:@"%lu",self.items.count];
    }else if(self.selectItems.count&&self.items.count){
        self.toolBarView.noLabel.text = [NSString stringWithFormat:@"%lu",self.selectItems.count];
    }
    
    
    // 判断是被modal还是被push
    if (self.navigationController.childViewControllers.count < 2) {
        // modal出
        self.toolBarView.hidden = YES;
        self.rightBarBtnItem.hidden = YES;
    }
}

// 返回按钮的方法
- (void)backBtnAction:(UIButton *)sender
{
    self.toolBarView.preBtn.hidden = NO;
    if (self.navigationController.childViewControllers.count < 2) {
        // modal出
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        // push出
        if (self.BrowseBlock) {
            self.BrowseBlock(self.selectItems);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 右边NavBar上的按钮方法
- (void)rightBarBtnItemAction:(UIButton *)sender
{
    NSInteger offset_x = self.browseCollectView.contentOffset.x / kLYScreenWidth;
    LYAssetModel *model = self.items[offset_x];
    model.selectedAsset = !model.selectedAsset;
    if (model.selectedAsset == YES) {
        [self.rightBarBtnItem setImage:[UIImage imageNamedFromMyBundle:@"photo_sel_photoPickerVc"] forState:UIControlStateNormal];
        if (self.selectItems && ![self.selectItems containsObject:model]) {
            [self.selectItems addObject:model];
        }
    }else{
        [self.rightBarBtnItem setImage:[UIImage imageNamedFromMyBundle:@"photo_original_def"] forState:UIControlStateNormal];
        if (self.selectItems && [self.selectItems containsObject:model]) {
            [self.selectItems removeObject:model];
        }
    }
    self.toolBarView.noLabel.text = [NSString stringWithFormat:@"%lu", self.selectItems.count];
}

#pragma mark - 初始化collectview
- (void)setupViewWithModel
{
    [self.browseCollectView reloadData];
    
    if (self.index) {
        [self.browseCollectView setContentOffset:CGPointMake(kLYScreenWidth*self.index, 0)];
        LYAssetModel *model = self.items[self.index];
        if (model.selectedAsset) {
            [self.rightBarBtnItem setImage:[UIImage imageNamedFromMyBundle:@"photo_sel_photoPickerVc"] forState:UIControlStateNormal];
        }else{
            [self.rightBarBtnItem setImage:[UIImage imageNamedFromMyBundle:@"photo_original_def"] forState:UIControlStateNormal];
        }
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LYPhotoBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYPhotoBrowseCell" forIndexPath:indexPath];
    cell.assetModel = self.items[indexPath.item];
    __weak typeof(self) weakSelf = self;
    cell.photoBrowseBlock = ^(){
        // 判断是被modal还是被push
        if (self.navigationController.childViewControllers.count < 2) {
            // modal出
            // 不做操作
        }else{
            // push出
            weakSelf.toolBarView.hidden = !weakSelf.toolBarView.hidden;
            weakSelf.navBarView.hidden = !weakSelf.navBarView.hidden;
        }
    };
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger offset_x = self.browseCollectView.contentOffset.x / kLYScreenWidth;
    LYAssetModel *model = self.items[offset_x];
    if (model.selectedAsset == YES) {
        [self.rightBarBtnItem setImage:[UIImage imageNamedFromMyBundle:@"photo_sel_photoPickerVc"] forState:UIControlStateNormal];
    }else{
        [self.rightBarBtnItem setImage:[UIImage imageNamedFromMyBundle:@"photo_original_def"] forState:UIControlStateNormal];
    }
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end


#pragma mark - LYPhotoBrowseCell
@interface LYPhotoBrowseCell ()<UIScrollViewDelegate>
/** 图片 */
@property (nonatomic, strong) UIImageView *photoImg;

/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation LYPhotoBrowseCell

// scrollView
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = self.contentView.bounds;
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.delegate = self;
        scrollView.minimumZoomScale = 0.1;
        scrollView.maximumZoomScale = 10;
        [self.contentView addSubview:scrollView];
        self.scrollView = scrollView;
    }
    return _scrollView;
}

// 图片
- (UIImageView *)photoImg
{
    if (!_photoImg) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = self.scrollView.bounds;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.layer.masksToBounds = YES;
        [self.scrollView addSubview:imgView];
        self.photoImg = imgView;
    }
    return _photoImg;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1GrAction:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2GrAction:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
    }
    return self;
}

- (void)tap1GrAction:(UITapGestureRecognizer *)tap
{
    if (self.photoBrowseBlock) {
        self.photoBrowseBlock();
    }
}

- (void)tap2GrAction:(UITapGestureRecognizer *)tap
{
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.photoImg];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)setAssetModel:(LYAssetModel *)assetModel
{
    _assetModel = assetModel;
    self.photoImg.image = assetModel.thumbImage;
}

#pragma mark - scrollView的代理方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
         return self.photoImg;
    }
    return nil;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.ly_width > scrollView.contentSize.width) ? (scrollView.ly_width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.ly_height > scrollView.contentSize.height) ? (scrollView.ly_height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.photoImg.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

@end
