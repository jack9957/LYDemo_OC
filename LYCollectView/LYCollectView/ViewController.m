//
//  ViewController.m
//  LYCollectView
//
//  Created by liyang on 16/9/27.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "ViewController.h"

#import "LYCollectionViewCell.h"

#import "LYFlowLayout.h" // 自定义的布局

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static NSString *const cellID = @"LYCollectionViewCell";

@implementation ViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 1; i<21; i++) {
            [temp addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i]]];
        }
        self.dataArray = temp;
    }
    return _dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupview];
}

- (void)setupview
{
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - 160)/2;
    
    //Layout负责定义视图中cell的大小、行、列、最小间距、滚动方向、内容与四个边缘的位置关系………………
    LYFlowLayout *layout = [[LYFlowLayout alloc] init];
    
    //大小
    layout.itemSize = CGSizeMake(160,160);
    //滚动方向为纵向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 50;
    layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) collectionViewLayout:layout];
    collectionView.center = self.view.center;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:collectionView];
    
    
    //注册Class,实现重用
    [collectionView registerNib:[UINib nibWithNibName:@"LYCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.imgView.image = self.dataArray[indexPath.item];
    return cell;
}
@end
