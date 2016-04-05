//
//  BaoAlbum.m
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/13.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import "BaoAlbum.h"

@implementation BaoAlbum

@synthesize year;
@synthesize month;
@synthesize sum;
@synthesize baoImages;
@synthesize nsDate;


-(id)init {
    self = [super init];
    if (self) {
        self.year = @"";
        self.month = @"";
        self.nsDate = [NSDate date];
        self.sum = 0;
        self.baoImages = [[NSMutableArray alloc] init];
        
        
    }
    
    return self;
}

-(id)initByDate:(NSDate*)date {
    self = [self init];
    if (self) {
        NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
        [yearFormatter setDateFormat:@"yyyy"];
        
        NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
        [monthFormatter setDateFormat:@"MM"];
        
        self.nsDate = date;
        self.year = [yearFormatter stringFromDate:date];
        self.month = [monthFormatter stringFromDate:date];

        NSLog(@"create album: year: %@, month:%@", self.year, self.month);
        
    }
    
    return self;
}

#pragma mark - data
-(void)sortImagesByDate{
    //新的放前面 0, 1, 2 ....
    NSMutableArray *sortArray = [NSMutableArray new];
    for (int i = 0; i < self.baoImages.count; i++) {
        
        BaoImage *baoImage = [self.baoImages objectAtIndex:i];
        BOOL flag = NO;
        for (int j = 0; j < sortArray.count; j++) {
            BaoImage *imageInSort = [sortArray objectAtIndex:j];
            if ([imageInSort.dateCreate timeIntervalSinceDate:baoImage.dateCreate] < 0) {
                [sortArray insertObject:baoImage atIndex:j];
                flag = YES;
                break;
            }
        }
        if (flag == NO) {//place to end of array
            [sortArray addObject:baoImage];
        }
    }
    
    self.baoImages = sortArray;
}

-(void)addNewBaoImage:(BaoImage *)baoImage{
    [self.baoImages addObject:baoImage];
    [self sortImagesByDate];
    [self updateSumPrice];
}


#pragma mark - calculation
-(void)updateSumPrice {
    float newSum = 0;
    for (BaoImage *baoImage in self.baoImages) {
        newSum += baoImage.price;
    }
    
    self.sum = newSum;
}

#pragma mark - string
-(NSString *)getStringSumPrice{
    NSString *string = [NSString stringWithFormat:@"Sum：%.1f", self.sum];
    
    return string;
}

-(NSString*)getStringTime{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setTimeZone:[NSTimeZone localTimeZone]];
    [format setDateFormat:@"yyyy/MM"];
    
    NSString *dateString = [format stringFromDate:self.nsDate];
    
    return dateString;
}



#pragma mark - nscode delegate
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.year = [aDecoder decodeObjectForKey:@"year"];
        self.month = [aDecoder decodeObjectForKey:@"month"];
        self.nsDate = [aDecoder decodeObjectForKey:@"nsDate"];
        self.sum = [aDecoder decodeFloatForKey:@"sum"];
        self.baoImages = [aDecoder decodeObjectForKey:@"baoImages"];
        
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.year forKey:@"year"];
    [aCoder encodeObject:self.month forKey:@"month"];
    [aCoder encodeObject:self.nsDate forKey:@"nsDate"];
    [aCoder encodeFloat:self.sum forKey:@"sum"];
    [aCoder encodeObject:self.baoImages forKey:@"baoImages"];
     
}



@end
