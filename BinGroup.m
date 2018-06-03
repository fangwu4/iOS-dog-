//
//  BinGroup.m
//  UI
//
//  Created by hha6027875 on 29/3/18.
//  Copyright © 2018 hha6027875. All rights reserved.
//

#import "BinGroup.h"
#import "BinDog.h"
@implementation BinGroup
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
        NSMutableArray *arrayModels = [NSMutableArray array];
        for(NSDictionary * item_dict in dict[@"dogs"])
        {
            BinDog *model = [BinDog dogWithDict:item_dict];
            [arrayModels addObject: model];
        }
        self.dogs = arrayModels;
        self.title =dict[@"title"];
    }
    return  self;
}
+(instancetype)groupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
@end
