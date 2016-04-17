//
//  SummaryViewController.h
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/13.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaoController.h"
#import "ImageHeaderCollectionReusableView.h"
#import "ImagePriceCollectionViewCell.h"


@interface SummaryViewController : UIViewController<BaoControllerDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableView;





@end
