//
//  AudoPriceView.h
//  OrderMenu
//
//  Created by tiankong360 on 13-7-16.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AudoPriceViewDelegate;

@interface AudoPriceView : UIView
@property (nonatomic,strong) UILabel * detailLab;
@property (nonatomic)double sumprice;
@property (nonatomic)int sumnumber;
@property (nonatomic)id<AudoPriceViewDelegate> delegate;
+(AudoPriceView *)ShareView;
+(void)AnimateCancle;
+(void)AnimateCome;
-(void)ChangeLabTextSumPrice:(double)aSumPrice sumDishes:(int)aDishes;
+(void)AnimateCancleSpeed;
@end

@protocol AudoPriceViewDelegate <NSObject>
-(void)nextClick;
@end