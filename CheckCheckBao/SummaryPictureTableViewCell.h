//
//  SummaryPictureTableViewCell.h
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/19.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryPictureTableViewCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>


@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *baoImages;
@property NSMutableArray *uiImageArray;
@property BOOL isDeleteActive;


@end
