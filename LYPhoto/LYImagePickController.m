//
//  LYImagePickController.m
//  LYImagePicker
//
//  Created by liyang on 16/10/12.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYImagePickController.h"

/** 展示相册的类 */
#import "LYShowAblumController.h"
/** 展示图片的类 */
#import "LYShowPhotosController.h"

#import "SVProgressHUD.h"
#import "UIView+LYViewFrame.h"

@interface LYImagePickController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) id popDelegate;

@end

// 最小选择数
static NSInteger minNo = 1;
// 最大选择数
static NSInteger maxNo = 9;

@implementation LYImagePickController

+ (void)initialize
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    bar.barTintColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIBarButtonItem *barItem = [UIBarButtonItem appearanceWhenContainedIn:self, nil];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [barItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
}

- (LYToolView *)toolView
{
    if (!_toolView) {
        LYToolView *tool = [[LYToolView alloc] initWithFrame:CGRectMake(0, kLYScreenHeight-44, kLYScreenWidth, 44)];
        [self.view addSubview:tool];
        self.toolView = tool;
    }
    return _toolView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self toolView];
    
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
}

- (instancetype)initWithMediaType:(LY_AssetType)type delegate:(id<LYImagePickControllerDelegate>)delegate
{
    LYShowAblumController *showAblum = [[LYShowAblumController alloc] init];
    self = [super initWithRootViewController:showAblum];
    if (self) {
        self.pickDelegate = delegate;
        self.minSelectNo = minNo;
        self.maxSelectNo = maxNo;
    }
    return self;
}

// 重写Push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 非根控制器跳转的时候，隐藏底部工具条
    if (self.viewControllers.count != 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = ({
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamedFromMyBundle:@"NavBack"] style:UIBarButtonItemStylePlain target:self action:@selector(navback:)];
            item;
        });
        
        // 清空代理
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    
    [super pushViewController:viewController animated:animated];
}
- (void)navback:(UIBarButtonItem *)sender
{
    [self popViewControllerAnimated:YES];
}
#pragma mark - NavgationDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 如果展示的控制器是根视图控制器，还原pop手势代理,左右滑动手势可用
    if (viewController == [self.viewControllers firstObject]) {
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end


@implementation LYToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self toolBtn];
        [self labelBJView];
        [self noLabel];
        self.backgroundColor = kLYRGBAColor(34, 34, 34, 1);
    }
    return self;
}
// 懒加载
- (UIButton *)toolBtn
{
    if (!_toolBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:btn];
        self.toolBtn = btn;
    }
    return _toolBtn;
}
- (UIImageView *)labelBJView
{
    if (!_labelBJView) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.image = [UIImage imageNamedFromMyBundle:@"photo_number_icon"];
        [self addSubview:imgV];
        self.labelBJView = imgV;
    }
    return _labelBJView;
}
- (UILabel *)noLabel
{
    if (!_noLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.text = @"0";
        [self.labelBJView addSubview:label];
        self.noLabel = label;
    }
    return _noLabel;
}
- (UIButton *)preBtn
{
    if (!_preBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"预览" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:btn];
        self.preBtn = btn;
    }
    return _preBtn;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.toolBtn.frame = CGRectMake(kLYScreenWidth-40-10, 0, 40, 44);
    self.labelBJView.frame = CGRectMake(self.toolBtn.ly_x-5-27, (self.ly_height-27)/2, 27, 27);
    self.noLabel.frame = CGRectMake(0, 0, 27, 27);
    self.preBtn.frame = CGRectMake(10, 0, 40, 44);
}

@end
