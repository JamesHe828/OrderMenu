//
//  PriceView.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-11.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PriceViewDelegate;

@interface PriceView : UIView
@property (nonatomic,strong) UILabel * detailLab;
@property (nonatomic,assign)double sumprice;
@property (nonatomic,assign)int sumnumber;
@property (nonatomic)id<PriceViewDelegate> delegate;
+(PriceView *)ShareView;
+(void)AnimateCancle;
+(void)AnimateCome;
-(void)ChangeLabTextSumPrice:(double)aSumPrice sumDishes:(int)aDishes;
+(void)AnimateCancleSpeed;
@end

@protocol PriceViewDelegate <NSObject>
-(void)nextClick;
@end