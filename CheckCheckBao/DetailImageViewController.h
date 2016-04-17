//
//  DetailImageViewController.h
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/4/16.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaoController.h"

@interface DetailImageViewController : UIViewController <UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *imageViewItem;


@property (strong, nonatomic) IBOutlet UIButton *buttonEdit;

@property (strong, nonatomic) IBOutlet UITextField *textFieldPrice;

@property (strong, nonatomic) IBOutlet UITextView *textViewDescription;

@property (strong, nonatomic) IBOutlet UILabel *labelModifyCost;

@property (strong, nonatomic) IBOutlet UILabel *labelModifyDescription;

@property (strong, nonatomic) IBOutlet UILabel *labelNoImage;

@property BaoImage *baoImage;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contraintTextViewToSuperViewBottom;

@end
