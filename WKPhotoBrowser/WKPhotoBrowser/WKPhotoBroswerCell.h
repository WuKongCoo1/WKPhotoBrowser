//
//  WKPhotoBroswerCell.h
//  WKPhotoBrowser
//
//  Created by 吴珂 on 2017/5/16.
//  Copyright © 2017年 吴珂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKPhotoBrowserScrollView.h"
@class WKPhotoBroswerCell;
@protocol WKPhotoBroswerCellDelegate <NSObject>

- (void)photoBroswerCell:(WKPhotoBroswerCell *)imageView singleTapDetected:(UITouch *)touch;
- (void)photoBroswerCell:(WKPhotoBroswerCell *)imageView doubleTapDetected:(UITouch *)touch;
- (void)photoBroswerCell:(WKPhotoBroswerCell *)imageView tripleTapDetected:(UITouch *)touch;

@end

@interface WKPhotoBroswerCell : UICollectionViewCell

@property (copy, nonatomic) NSString *imageName;

@property (weak, nonatomic) id<WKPhotoBroswerCellDelegate> delegate;

@end
