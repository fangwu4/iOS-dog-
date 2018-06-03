//
//  BinAttribute.m
//  UI
//
//  Created by hha6027875 on 21/4/18.
//  Copyright © 2018 hha6027875. All rights reserved.
//

#import "BinAttribute.h"

@implementation BinAttribute
-(instancetype) initWithString: (NSString *) string
{
    if(self = [super init])
    {
        NSArray *aArray = [string componentsSeparatedByString:@" "];
        self.imgName = aArray[0];
        self.imgClass = aArray[2];
        self.imgLeft = aArray[4];
        self.imgUp = aArray[6];
        self.imgRight = aArray[8];
        self.imgDown = aArray[10];
        self.imgScore = aArray[12];
        
    }
    return self;
}
@end
