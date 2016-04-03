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
@synthesize unPriceBaoAlbum;

//Singleton
static BaoController *sharedBaoController = nil;
static BaoController *shareBaoController = nil;

+ (id)sharedController {
    @synchronized(self) {
        if (sharedBaoController == nil){
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                sharedBaoController = [[self alloc] initWithDefaultBaoAlbums];//set to default user
            });
            
        }
    }
    return sharedBaoController;
}
+ (id)shareController {
    @synchronized(self) {
        if (sharedBaoController == nil){
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                shareBaoController = [[self alloc] initWithDefaultBaoAlbums];//set to default user
            });
            
        }
    }
    return shareBaoController;
}


- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

-(id)initWithDefaultBaoAlbums{
    self = [self init];
    if (self) {
        if (defaultUser == nil) {
            
            //user default
            defaultUser = [NSUserDefaults standardUserDefaults];
            
            //image asset
            [self setupCheckBaoPHAssetAlbum];
            
            //load default
            [self loadDefaultAlbums];
            
            //sort bao image
            [self sortBaoAlbumsByDate];
            
            //update unPric image
            [self updateUnPriceBaoImageArray];
            
            [self saveAllChange];
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
    BaoImage *baoImage = [[BaoImage alloc] initByDate:date name:@"" price:price imageURL:nil note:@""];
    
    //save to album
    BaoAlbum *baoAlbum = [self findBaoAlbumFromAlbumsByDate:date];
    if (baoAlbum != nil) {
        NSLog(@"find old album");
        [baoAlbum addNewBaoImage:baoImage];
        
    }else {
        //can't find album, create new
        NSLog(@"create new album");
        BaoAlbum *newBaoAlbum = [[BaoAlbum alloc] initByDate:date];
        [newBaoAlbum addNewBaoImage:baoImage];
        [self.baoAlbums addObject:newBaoAlbum];
    }
    
    
    //save to asset, and save url to baoImage
    [self saveImageToAssetCollection:image forBaoImage:baoImage];
    [self saveAllChange];
}


#pragma mark - calculation
-(void)sortBaoAlbumsByDate{
    //新的放前面 0, 1, 2 ....
    NSMutableArray *sortArray = [NSMutableArray new];
    for (int i = 0; i < self.baoAlbums.count; i++) {
        BaoAlbum *baoAlbum = [self.baoAlbums objectAtIndex:i];
        BOOL flag = NO;
        for (int j = 0; j < sortArray.count; j++) {
            BaoAlbum *albumInSort = [sortArray objectAtIndex:j];
            if ([albumInSort.nsDate timeIntervalSinceDate:baoAlbum.nsDate] < 0) {
                [sortArray insertObject:baoAlbum atIndex:j];
                flag = YES;
                break;
            }
        }
        if (flag == NO) {//place to end of array
            [sortArray addObject:baoAlbum];
        }
    }
    
    self.baoAlbums = sortArray;
    
}

-(void)updateUnPriceBaoImageArray{
    BaoAlbum *newbaoAlbum = [[BaoAlbum alloc]init];
    
    //calculate
    for (BaoAlbum *baoAlbum in self.baoAlbums) {
        for (BaoImage *baoImage in baoAlbum.baoImages) {
            if (baoImage.price == 0) {
                [newbaoAlbum.baoImages addObject:baoImage];
            }
        }
    }
    
    [newbaoAlbum updateSumPrice];
    
    self.unPriceBaoAlbum = newbaoAlbum;
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
            
            baoImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"assets-library://asset/asset.JPG?id=%@&ext=JPG", uuid]];
            [self saveAllChange];
        }else {
            NSLog(@"save image error:%@",error);
        }
    }];
    
}

-(UIImage*)fetchImageFromAssetURL:(NSURL*)url{
    
    __block UIImage *image = [[UIImage alloc]init];
    NSLog(@"fetch image");
    PHAsset *asset = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil].firstObject;
    CGSize size = CGSizeMake(200, 200);
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeNone;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        image = result;
    }];
    return image;
}





#pragma mark - date
-(NSString*)getYearStringFromDate:(NSDate*)date{
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [yearFormatter setDateFormat:@"yyyy"];
    
    return [yearFormatter stringFromDate:date];
}

-(NSString*)getMonthStringFromDate:(NSDate*)date{
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MM"];
    
    return [monthFormatter stringFromDate:date];
}




#pragma mark - save/load
-(void) saveAllChange{
    [self saveDefaultAlbums];
    
    //save more....
    
    [defaultUser synchronize];
}

@end
