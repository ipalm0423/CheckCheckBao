//
//  ImagePriceCollectionViewCell.h
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/13.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaoController.h"

@interface ImagePriceCollectionViewCell : UICollectionViewCell



@property (strong, nonatomic) IBOutlet UIImageView *imageView;


@property (strong, nonatomic) IBOutlet UILabel *labelPrice;

@property (strong, nonatomic) IBOutlet UILabel *labelTime;

@property (strong, nonatomic) IBOutlet UIButton *buttonDelete;

@end
