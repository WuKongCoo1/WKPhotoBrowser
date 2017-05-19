//
//  ViewController.m
//  WKPhotoBrowser
//
//  Created by 吴珂 on 2017/5/16.
//  Copyright © 2017年 吴珂. All rights reserved.
//

#import "ViewController.h"
#import "WKPhotoBrowser.h"
#import <SDWebImage/SDImageCache.h>

@interface ViewController ()
<
WKPhotoBrowserDataSouruce,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (copy, nonatomic) NSArray *thumbImages;
@property (copy, nonatomic) NSArray *images;
- (IBAction)push:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WKPhotoBrowserDataSouruce
/**
 图片个数
 
 @param photoBrowser 浏览器
 @return 图片个数
 */
- (NSInteger)numberOfphotosInPhotoBrowser:(WKPhotoBrowser *)photoBrowser
{
    return _images.count;
}

/**
 大图url
 
 @param photoBrowser 浏览器
 @param index index
 @return url
 */
- (NSString *)photoBrowser:(WKPhotoBrowser *)photoBrowser imageUrlAtIndex:(NSInteger)index
{
    return _images[index];
}

/**
 缩略图
 
 @param photoBrowser 浏览器
 @param index index
 @return 缩略图url
 */
- (NSString *)photoBrowser:(WKPhotoBrowser *)photoBrowser thumbImageUrlAtIndex:(NSInteger)index
{
    return _thumbImages[index];
}

- (IBAction)push:(id)sender {
    
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        WKPhotoBrowser *photoBrowser = [WKPhotoBrowser photoBrowser];
        
        photoBrowser.currentIndex = 3;
        photoBrowser.dataSource = self;
        
        _images = @[@"http://sjsh-test.img-cn-hangzhou.aliyuncs.com/ChatResources/oss-4B40D894-B38C-4DB5-89ED-2BEF8E3A62FB_576.00_324.00.jpg", @"http://sjsh-test.img-cn-hangzhou.aliyuncs.com/avatar/1929886/oss-01371385-f11e-4ee4-8b68-93cf39890080_600_600.jpg", @"assets-library://asset/asset.PNG?id=C1BA9B55-EDC9-4AF0-8997-037520CFC449&ext=PNG", @"http://sjsh-test.img-cn-hangzhou.aliyuncs.com/ChatResources/oss-6B07F02B-6289-4860-B673-BA863259916B_2823.00_2117.00.jpg", @"http://sjsh-test.img-cn-hangzhou.aliyuncs.com/ChatResources/oss-CC6A27A6-5686-47FE-A35D-3F3859B17718_2016.00_1512.00.jpg"];
        _thumbImages = @[@"http://sjsh-test.img-cn-hangzhou.aliyuncs.com/ChatResources/oss-4B40D894-B38C-4DB5-89ED-2BEF8E3A62FB_576.00_324.00.jpg", @"http://sjsh-test.img-cn-hangzhou.aliyuncs.com/avatar/1929886/oss-01371385-f11e-4ee4-8b68-93cf39890080_600_600.jpg@100w_100h", @"assets-library://asset/asset.PNG?id=C1BA9B55-EDC9-4AF0-8997-037520CFC449&ext=PNG", @"http://sjsh-test.img-cn-hangzhou.aliyuncs.com/ChatResources/oss-6B07F02B-6289-4860-B673-BA863259916B_2823.00_2117.00.jpg", @"http://sjsh-test.img-cn-hangzhou.aliyuncs.com/ChatResources/oss-CC6A27A6-5686-47FE-A35D-3F3859B17718_2016.00_1512.00.jpg"];
        
        [self.navigationController pushViewController:photoBrowser animated:YES];
    }];
}


@end
