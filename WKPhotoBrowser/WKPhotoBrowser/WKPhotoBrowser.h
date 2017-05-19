//
//  WKPhotoBrowser.h
//  WKPhotoBrowser
//
//  Created by 吴珂 on 2017/5/16.
//  Copyright © 2017年 吴珂. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKPhotoBrowser;
@protocol WKPhotoBrowserDataSouruce <NSObject>

@required
/**
 图片个数

 @param photoBrowser 浏览器
 @return 图片个数
 */
- (NSInteger)numberOfphotosInPhotoBrowser:(WKPhotoBrowser *)photoBrowser;

/**
 大图url

 @param photoBrowser 浏览器
 @param index index
 @return url
 */
- (NSString *)photoBrowser:(WKPhotoBrowser *)photoBrowser imageUrlAtIndex:(NSInteger)index;

/**
 缩略图

 @param photoBrowser 浏览器
 @param index index
 @return 缩略图url
 */
- (NSString *)photoBrowser:(WKPhotoBrowser *)photoBrowser thumbImageUrlAtIndex:(NSInteger)index;

@end

@interface WKPhotoBrowser : UIViewController

@property (weak, nonatomic) id<WKPhotoBrowserDataSouruce> dataSource;
@property (assign, nonatomic) NSInteger currentIndex;

+ (instancetype)photoBrowser;

@end
