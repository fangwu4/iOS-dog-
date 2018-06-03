//
//  BinDog.m
//  UI
//
//  Created by hha6027875 on 29/3/18.
//  Copyright © 2018 hha6027875. All rights reserved.
//

#import "BinDog.h"

@implementation BinDog
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)dogWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
@end
