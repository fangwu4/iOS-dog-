//
//  BinAttribute.h
//  UI
//
//  Created by hha6027875 on 21/4/18.
//  Copyright © 2018 hha6027875. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BinAttribute : NSObject
@property (nonatomic, copy) NSString * imgName;
@property (nonatomic, copy) NSString * imgClass;
@property (nonatomic, copy) NSString * imgLeft;
@property (nonatomic, copy) NSString * imgUp;
@property (nonatomic, copy) NSString * imgRight;
@property (nonatomic, copy) NSString * imgDown;
@property (nonatomic, copy) NSString * imgScore;

-(instancetype) initWithString: (NSString *) string;
@end
