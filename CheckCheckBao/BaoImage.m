//
//  BaoImage.m
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/13.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import "BaoImage.h"
#import <Photos/Photos.h>

@implementation BaoImage


@synthesize name;
@synthesize price;
@synthesize dateCreate;
@synthesize imageURL;
@synthesize note;

-(id) init {
    self = [super init];
    if (self) {
        //modify
        self.name = @"";
        self.price = 0;
        self.dateCreate = [NSDate date];
        self.imageURL = [NSURL new];
        self.note = @"";
    }
    return self;
}

-(id) initByDate:(NSDate*)date name:(NSString*)newName price:(float)newPrice imageURL:(NSURL*)url note:(NSString*)newNote{
    self = [self init];
    if (self) {
        //modify
        self.name = newName;
        self.price = newPrice;
        self.dateCreate = date;
        self.imageURL = url;
        self.note = newNote;
        
    }
    return self;
}


#pragma mark - string
-(NSString*)getStringPrice{
    NSString *string = [NSString stringWithFormat:@"＄%.1f", self.price];
    
    
    return string;
}

-(NSString *)getStringTime{
    if (self.dateCreate) {
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        [format setTimeZone:[NSTimeZone localTimeZone]];
        [format setDateFormat:@"MM/dd HH:mm"];
        
        NSString *hourString = [format stringFromDate:self.dateCreate];
        NSString *sumString = [NSString stringWithFormat:@"%@, %@", [self getStringWeekDay:self.dateCreate], hourString];
        return sumString;
    }
    return @"no time";
}

-(NSString*)getStringWeekDay:(NSDate*)date{
    
    NSCalendar* currentCalendar = [NSCalendar currentCalendar];
    NSInteger weekInteger = [[currentCalendar components:NSWeekdayCalendarUnit fromDate:date] weekday];
    
    NSString *dateString = @"";
    
    switch (weekInteger) {
        case 1:
            dateString = [NSString stringWithFormat:@"Sun"];
            break;
        case 2:
            dateString = [NSString stringWithFormat:@"Mon"];
            break;
        case 3:
            dateString = [NSString stringWithFormat:@"Tue"];
            break;
        case 4:
            dateString = [NSString stringWithFormat:@"Wed"];
            break;
        case 5:
            dateString = [NSString stringWithFormat:@"Thu"];
            break;
        case 6:
            dateString = [NSString stringWithFormat:@"Fri"];
            break;
        case 7:
            dateString = [NSString stringWithFormat:@"Sat"];
            break;
            
        default:
            break;
    }
    return dateString;
    
}

#pragma mark - image
-(UIImage*)getUIImageBySize:(CGSize)targetSize{
    if (self.imageURL) {
        __block UIImage *image = [[UIImage alloc]init];
        NSLog(@"fetch image");
        PHAsset *asset = [PHAsset fetchAssetsWithALAssetURLs:@[self.imageURL] options:nil].firstObject;
        CGSize size = targetSize;
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.resizeMode = PHImageRequestOptionsResizeModeNone;
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            image = result;
        }];
        return image;
    }
    return nil;
}
-(UIImage*)getSmallSizeUIImage{
    if (self.imageURL) {
        PHImageManager *manager = [PHImageManager defaultManager];
        PHAsset *asset = [PHAsset fetchAssetsWithALAssetURLs:@[self.imageURL] options:nil].firstObject;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        options.synchronous = YES;
        options.networkAccessAllowed = YES;
        options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            NSLog(@"%f", progress);
        };
        
        __block UIImage *image = [[UIImage alloc]init];
        
        [manager requestImageDataForAsset:asset
                                  options:options
                            resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info)
         {
             image = [UIImage imageWithData:imageData];
             
         }];
        return image;
    }
    return nil;
}

-(UIImage*)getFullSizeImage{
    if (self.imageURL) {
        PHImageManager *manager = [PHImageManager defaultManager];
        PHAsset *asset = [PHAsset fetchAssetsWithALAssetURLs:@[self.imageURL] options:nil].firstObject;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous = YES;
        options.networkAccessAllowed = YES;
        options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            NSLog(@"%f", progress);
        };
        
        __block UIImage *image = [[UIImage alloc]init];
        
        [manager requestImageDataForAsset:asset
                                  options:options
                            resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info)
         {
             image = [UIImage imageWithData:imageData];

         }];
        return image;
    }
    return nil;
}


#pragma mark - nscode delegate
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super init])) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.price = [aDecoder decodeFloatForKey:@"price"];
        self.dateCreate = [aDecoder decodeObjectForKey:@"dateCreate"];
        self.imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
        self.note = [aDecoder decodeObjectForKey:@"note"];
    }
    return self;
    
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeFloat:self.price forKey:@"price"];
    [aCoder encodeObject:self.dateCreate forKey:@"dateCreate"];
    [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
    [aCoder encodeObject:self.note forKey:@"note"];
}





@end
