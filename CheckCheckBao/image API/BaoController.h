//
//  BaoController.h
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/13.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaoAlbum.h"
#import <UIKit/UIKit.h>

@class BaoController;

@protocol BaoControllerDelegate <NSObject>



@end

@interface BaoController : NSObject


@property id<BaoControllerDelegate> delegateBaoController;
@property NSMutableArray *baoAlbums;

//Singleton
+ (id)sharedController;


-(BaoAlbum*) findBaoAlbumFromAlbumsByDate:(NSDate*)date;
-(void)saveImageToAlbum:(UIImage*)image byDate:(NSDate*)date price:(float)price;
-(void) saveAllChange;
-(UIImage*)fetchImageFromAssetURL:(NSURL*)url;
@end
