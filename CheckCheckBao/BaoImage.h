//
//  BaoImage.h
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/13.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaoImage : NSObject <NSCoding>



@property NSString *name;
@property float price;
@property NSDate *dateCreate;
@property __block NSURL *imageURL;



-(id) initByDate:(NSDate*)date;


@end
