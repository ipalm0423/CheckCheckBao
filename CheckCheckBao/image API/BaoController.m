//
//  BaoController.m
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/13.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import "BaoController.h"
#import <Photos/Photos.h>

@implementation BaoController{
    __block NSUserDefaults *defaultUser;
    __block PHAssetCollection *assetCollection;
    __block PHObjectPlaceholder *assetPlaceHolder;
    
}


@synthesize delegateBaoController;
@synthesize baoAlbums;

//Singleton
static BaoController *sharedBaoController = nil;

+ (id)sharedController {
    @synchronized(self) {
        if (sharedBaoController == nil){
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                sharedBaoController = [[self alloc] init];//set to default user
            });
            
        }
    }
    return sharedBaoController;
}

- (id)init {
    if (self = [super init]) {
        if (defaultUser == nil) {
            
            //user default
            defaultUser = [NSUserDefaults standardUserDefaults];
            [self loadDefaultAlbums];
            
            //image asset
            [self setupCheckBaoPHAssetAlbum];
        }
        
        
        
    }
    return self;
}



#pragma mark - default controller

-(void)loadDefaultAlbums{
    
    NSData *encodedObject = [defaultUser objectForKey:@"defaultAlbums"];
    if (encodedObject != nil) {
        NSMutableArray *albums = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        if (albums != nil) {
            self.baoAlbums = albums;
            NSLog(@"load default albums, album count: %li", albums.count);
            BaoAlbum *firstAlbum = (BaoAlbum*) [albums objectAtIndex:0];
            NSLog(@"test image count: %li", firstAlbum.baoImages.count);
        }else {
            self.baoAlbums = [[NSMutableArray alloc] init];
        }
    }else {
        self.baoAlbums = [[NSMutableArray alloc] init];
    }
    
}

-(void) saveDefaultAlbums {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.baoAlbums];
    [defaultUser setObject:encodedObject forKey:@"defaultAlbums"];
}



#pragma mark - album controll

-(BaoAlbum*) findBaoAlbumFromAlbumsByDate:(NSDate*)date{
    NSString *year = [self getYearStringFromDate:date];
    NSString *month = [self getMonthStringFromDate:date];
    
    
    //find album from array
    for (BaoAlbum* album in self.baoAlbums) {
        if (album.year == year) {
            if (album.month == month) {
                return album;
            }
        }
    }
    
    
    
    return nil;
}

-(void)saveImageToAlbum:(UIImage*)image byDate:(NSDate*)date price:(float)price{
    
    //create new bao image
    BaoImage *baoImage = [[BaoImage alloc] initByDate:date];
    baoImage.dateCreate = date;
    baoImage.price = price;
    
    //save to album
    BaoAlbum *baoAlbum = [self findBaoAlbumFromAlbumsByDate:date];
    if (baoAlbum) {
        [baoAlbum.baoImages addObject:baoImage];
    }else {
        //can't find album, create new
        BaoAlbum *newBaoAlbum = [[BaoAlbum alloc] initByDate:date];
        [newBaoAlbum.baoImages addObject:baoImage];
        [self.baoAlbums addObject:newBaoAlbum];
    }
    
    //save to asset, and save url to baoImage
    [self saveImageToAssetCollection:image forBaoImage:baoImage];
    
}



#pragma mark - PHAsset
-(PHAssetCollection*)fetchPHAssetAlbum:(NSString*)name {
    PHFetchOptions *fetchOptons = [[PHFetchOptions alloc] init];
    fetchOptons.predicate = [NSPredicate predicateWithFormat:@"title = %@", name];
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:fetchOptons];
    PHAssetCollection *album = (PHAssetCollection*) result.firstObject;
    return album;
}

-(void) setupCheckBaoPHAssetAlbum {
    
    assetCollection = [self fetchPHAssetAlbum:@"CheckBao"];
    
    if (assetCollection) {
        NSLog(@"get old asset album");
        
    }else {
        
        assetCollection = [self createNewPHAssetAlbum:@"CheckBao"];
    }
    
}

-(PHAssetCollection*) createNewPHAssetAlbum:(NSString*)name {
    NSLog(@"create new asset album");
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name];
        assetPlaceHolder = [request placeholderForCreatedAssetCollection];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"create album successs");
            
        }
    }];
    return [self fetchPHAssetAlbum:name];
    
}

-(void)saveImageToAssetCollection2:(UIImage*)image forBaoImage:(BaoImage*)baoImage {
    NSLog(@"save image to asset...");
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        assetPlaceHolder = [request placeholderForCreatedAsset];
        PHFetchResult *assetPhoto = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        PHAssetCollectionChangeRequest *addImage = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection assets:assetPhoto];
        [addImage addAssets:@[assetPlaceHolder]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"save image to asset success");
            NSString *uuid = [assetPlaceHolder.localIdentifier substringToIndex:36];
            
            baoImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"assets-library://asset/asset.PNG?id=%@&ext=JPG", uuid]];
            [self saveAllChange];
        }else {
            NSLog(error);
        }
    }];
    
}

-(void)saveImageToAssetCollection:(UIImage*)image forBaoImage:(BaoImage*)baoImage {
    NSLog(@"save image to asset...");
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        assetPlaceHolder = [request placeholderForCreatedAsset];
        PHFetchResult *assetPhoto = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        PHAssetCollectionChangeRequest *addImage = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection assets:assetPhoto];
        [addImage addAssets:@[assetPlaceHolder]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"save image to asset success");
            NSString *uuid = [assetPlaceHolder.localIdentifier substringToIndex:36];
            
            baoImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"assets-library://asset/asset.PNG?id=%@&ext=JPG", uuid]];
            [self saveAllChange];
        }else {
            NSLog(error);
        }
    }];
    
}


#pragma mark - date
-(NSString*)getYearStringFromDate:(NSDate*)date{
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [yearFormatter setDateFormat: [NSDateFormatter dateFormatFromTemplate:@"yyyy" options:0 locale:[NSLocale currentLocale]]];
    return [yearFormatter stringFromDate:date];
}

-(NSString*)getMonthStringFromDate:(NSDate*)date{
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat: [NSDateFormatter dateFormatFromTemplate:@"MM" options:0 locale:[NSLocale currentLocale]]];
    return [monthFormatter stringFromDate:date];
}

-(NSString*)getDayStringFromDate:(NSDate*)date{
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat: [NSDateFormatter dateFormatFromTemplate:@"dd" options:0 locale:[NSLocale currentLocale]]];
    return [dayFormatter stringFromDate:date];
}


#pragma mark - save/load
-(void) saveAllChange{
    [self saveDefaultAlbums];
    
    //save more....
    
    [defaultUser synchronize];
}

@end
