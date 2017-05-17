//
//  WKTapDetectingView.h
//  WKPhotoBrowser
//
//  Created by 吴珂 on 2017/5/17.
//  Copyright © 2017年 吴珂. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WKTapDetectingViewDelegate <NSObject>

@optional

- (void)tapDetectingView:(UIView *)tapDetectingView singleTapDetected:(UITouch *)touch;
- (void)tapDetectingView:(UIView *)tapDetectingView doubleTapDetected:(UITouch *)touch;
- (void)tapDetectingView:(UIView *)tapDetectingView tripleTapDetected:(UITouch *)touch;

@end


@interface WKTapDetectingView : UIView

@property (nonatomic, weak) id <WKTapDetectingViewDelegate> tapDelegate;

@end


