//
//  ViewController.m
//  二维码
//
//  Created by liyang on 16/9/9.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "ViewController.h"
#import "QRScanViewController.h"
#import "ZBarReaderController.h"

#import "QRCodeGenerator.h"
#import "UIView+LYViewFrame.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, QRCodeScanDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.iconImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTapAction:)];
    [self.iconImage addGestureRecognizer:tap];
}

- (void)iconTapAction:(UITapGestureRecognizer *)sender
{
    if (self.iconImage.image) {
        // 点击图片保存到系统图库
        UIImageWriteToSavedPhotosAlbum(self.iconImage.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextIfon
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到系统相册";
    }else{
        message = [error description];
    }
    NSLog(@"message is:%@", message);
}

#pragma mark - 生成二维码
- (IBAction)creat:(id)sender
{
    NSString *strUrl3 = @"http://www.baidu.com";
    UIImage *img = [QRCodeGenerator qrImageForString:strUrl3 imageSize:250.0];
    self.iconImage.image = img;
}
#pragma mark - 扫描二维码
- (IBAction)find:(id)sender
{
    QRScanViewController *vc = [[QRScanViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
// 代理方法
- (void)scanController:(QRScanViewController *)scanController didScanResult:(NSString *)result isTwoDCode:(BOOL)isTwoDCode
{
    NSLog(@"%@", result);
    NSLog(@"%d", isTwoDCode);
    if ([result hasPrefix:@"http"]) {
        NSLog(@"头部");
        // 然后这里就可以打开网页了
        
    }
    
}

#pragma mark - 读取二维码
- (IBAction)read:(id)sender
{
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPicker.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:photoPicker animated:YES completion:NULL];
}
#pragma mark - 弹出系统相册的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * srcImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    /** 利用ZBar读取二维码中的信息 */
    ZBarReaderController* read = [ZBarReaderController new];
    CGImageRef cgImageRef = srcImage.CGImage;
    ZBarSymbol* symbol = nil;
    for(symbol in [read scanImage:cgImageRef]) break;
    // 拿到二维码中包含的信息
    NSString *result = symbol.data;
    
    if ( result )
    {
        UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"提示" message:result preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alterVC addAction:confirmAction];
        [self presentViewController:alterVC animated:YES completion:nil];
    }
}

@end
