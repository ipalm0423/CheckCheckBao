//
//  BaoImage.m
//  CheckCheckBao
//
//  Created by 陳冠宇 on 2016/3/13.
//  Copyright © 2016年 陳冠宇. All rights reserved.
//

#import "BaoImage.h"

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
        //imageURL
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
    NSString *string = [NSString stringWithFormat:@"%.1f", self.price];
    
    
    return string;
}

-(NSString *)getStringTime{
    if (self.dateCreate) {
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        [format setTimeZone:[NSTimeZone localTimeZone]];
        [format setDateFormat:@"dd日 HH：mm"];
        
        NSString *dateString = [format stringFromDate:self.dateCreate];
        return dateString;
    }
    return @"no time";
}

-(NSString*)getStringTime2delete{
    NSLog(@"time: %@", self.dateCreate);
    /*
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setTimeZone:[NSTimeZone localTimeZone]];
    [format setDateFormat:@"dd日 HH：mm"];
    
    NSString *dateString = [format stringFromDate:self.dateCreate];
    */
    return @"test1";
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
