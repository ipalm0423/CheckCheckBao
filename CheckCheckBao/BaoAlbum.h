//
//  BaoAlbum.h
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/13.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaoImage.h"
@interface BaoAlbum : NSObject<NSCoding>



@property NSString *year;
@property NSString *month;
@property NSDate *nsDate;
@property float sum;
@property NSMutableArray *baoImages;


-(id)initByDate:(NSDate*)date;

//image
-(void)sortImagesByDate;
-(void)addNewBaoImage:(BaoImage*)baoImage;

//accounting
-(void)updateSumPrice;

//string
-(NSString*)getStringSumPrice;
-(NSString*)getStringTime;

@end
