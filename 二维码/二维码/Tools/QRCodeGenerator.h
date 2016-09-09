//
//  QRCodeGenerator.h
//  二维码
//
//  Created by liyang on 16/9/9.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeGenerator : NSObject

/**
 *  根据一段文字的描述生出二维码图片
 *
 *  @param string 文字信息
 *  @param size   生成的图片大小
 *
 *  @return 二维码
 */
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size;

@end
