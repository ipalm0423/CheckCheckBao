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


-(id) init {
    self = [super init];
    if (self) {
        //modify
        self.dateCreate = [NSDate date];
        
        
    }
    return self;
}

-(id) initByDate:(NSDate*)date {
    self = [super init];
    if (self) {
        //modify
        self.dateCreate = date;
        
        
    }
    return self;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super init])) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.price = [aDecoder decodeFloatForKey:@"price"];
        self.dateCreate = [aDecoder decodeObjectForKey:@"dateCreate"];
        self.imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
    }
    return self;
    
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeFloat:self.price forKey:@"price"];
    [aCoder encodeObject:self.dateCreate forKey:@"dateCreate"];
    [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
}





@end
