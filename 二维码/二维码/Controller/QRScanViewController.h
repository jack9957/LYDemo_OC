//
//  QRScanViewController.m
//  QR二维码
//
//  Created by liyang on 16/8/17.
//  Copyright © 2016年 liyang. All rights reserved.
//
/*
 使用注意，这个Vc是被push出来的，通过代理方法，把扫描结果传回给上级界面，上级界面可以通过对字符串进行判断，知道这是什么信息
 */

// 负责读取二维码

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class QRScanViewController;

@protocol QRCodeScanDelegate <NSObject>

- (void)scanController:(QRScanViewController *)scanController
         didScanResult:(NSString *)result
            isTwoDCode:(BOOL)isTwoDCode;

@end


@interface QRScanViewController : UIViewController

@property (nonatomic, weak) id<QRCodeScanDelegate> delegate;

- (void)startScan;
- (void)stopScan;

@end

