//
//  BaoImage.h
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/13.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BaoImage;


@interface BaoImage : NSObject <NSCoding>



@property NSString *name;
@property float price;
@property NSDate *dateCreate;
@property __block NSURL *imageURL;
@property NSString *note;


-(id) initByDate:(NSDate*)date name:(NSString*)newName price:(float)newPrice imageURL:(NSURL*)url note:(NSString*)newNote;

//string
-(NSString*)getStringPrice;
-(NSString*)getStringTime;

//image
-(UIImage*)getUIImageBySize:(CGSize)targetSize;
-(UIImage*)getSmallSizeUIImage;
-(UIImage*)getFullSizeImage;

@end
