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
@synthesize dateCreate;


-(id)init {
    self = [super init];
    if (self) {
        NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
        [yearFormatter setDateFormat: [NSDateFormatter dateFormatFromTemplate:@"yyyy" options:0 locale:[NSLocale currentLocale]]];
        
        NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
        [monthFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MM" options:0 locale:[NSLocale currentLocale]]];
        
        NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"dd" options:0 locale:[NSLocale currentLocale]]];
        
        NSDate *now = [NSDate date];
        self.dateCreate = now;
        self.year = [yearFormatter stringFromDate:now];
        self.month = [monthFormatter stringFromDate:now];
        self.baoImages = [[NSMutableArray alloc] init];
        self.sum = 0;
        
    }
    
    return self;
}

-(id)initByDate:(NSDate*)date {
    self = [super init];
    if (self) {
        NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
        [yearFormatter setDateFormat: [NSDateFormatter dateFormatFromTemplate:@"yyyy" options:0 locale:[NSLocale currentLocale]]];
        
        NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
        [monthFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"MM" options:0 locale:[NSLocale currentLocale]]];
        
        NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"dd" options:0 locale:[NSLocale currentLocale]]];
        
        
        self.dateCreate = date;
        self.year = [yearFormatter stringFromDate:date];
        self.month = [monthFormatter stringFromDate:date];
        self.baoImages = [[NSMutableArray alloc] init];
        self.sum = 0;
        
    }
    
    return self;
}





-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.year = [aDecoder decodeObjectForKey:@"year"];
        self.month = [aDecoder decodeObjectForKey:@"month"];
        self.sum = [aDecoder decodeFloatForKey:@"sum"];
        self.baoImages = [aDecoder decodeObjectForKey:@"baoImages"];
        
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.year forKey:@"year"];
    [aCoder encodeObject:self.month forKey:@"month"];
    [aCoder encodeFloat:self.sum forKey:@"sum"];
    [aCoder encodeObject:self.baoImages forKey:@"baoImages"];
     
}



@end
