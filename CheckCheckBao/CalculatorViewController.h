//
//  CalculatorViewController.h
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/5.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorViewController;

@protocol CalculatorDelegate <NSObject>

@required
-(void)didEndCalculate:(CalculatorViewController *)calculator sum:(float)sum;
@optional
-(float)setSumNumber;

@end

@interface CalculatorViewController : UIViewController

@property id<CalculatorDelegate> delegate;
@property float totalNumber;
-(void)addSubviewOnBottom:(UIView*)hostView;
-(void)returnNumberToZero;

@end
