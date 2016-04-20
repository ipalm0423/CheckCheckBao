//
//  BaoController.h
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/13.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaoAlbum.h"
#import "BaoImage.h"
#import <UIKit/UIKit.h>

@class BaoController;

@protocol BaoControllerDelegate <NSObject>



@end

@interface BaoController : NSObject


@property id<BaoControllerDelegate> delegateBaoController;
@property NSMutableArray *baoAlbums;
@property BaoAlbum *unPriceBaoAlbum;

//Singleton
+ (id)shareController;
-(id)initWithDefaultBaoAlbums;

//save / load
-(BaoAlbum*) findBaoAlbumFromAlbumsByDate:(NSDate*)date;
-(void)saveImageToAlbum:(UIImage*)image byDate:(NSDate*)date price:(float)price note:(NSString*)note;
-(void)saveImageToAlbumByAssetURL:(NSURL*)assetURL date:(NSDate*)date price:(float)price note:(NSString*)note;
//delete
-(void)deleteBaoImage:(BaoImage*)image;

//calculate
-(void)updateUnPriceBaoImageArray;
-(void)sortBaoAlbumsByDate;

-(void) saveAllChange;
-(UIImage*)fetchImageFromAssetURL:(NSURL*)url;


@end
