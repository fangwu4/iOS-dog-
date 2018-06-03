//
//  BinGroup.h
//  UI
//
//  Created by hha6027875 on 29/3/18.
//  Copyright © 2018 hha6027875. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BinGroup : NSObject
@property (nonatomic, strong) NSArray * dogs;
@property (nonatomic, copy)NSString * title;
-(instancetype) initWithDict:(NSDictionary*)dict;
+(instancetype) groupWithDict:(NSDictionary *) dict;
@end
