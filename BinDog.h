//
//  BinDog.h
//  UI
//
//  Created by hha6027875 on 29/3/18.
//  Copyright © 2018 hha6027875. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BinDog : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * detail;
@property (nonatomic, copy) NSString * intro;
@property (nonatomic, copy) NSString * simg;
@property (nonatomic, copy) NSString * bimgf;
@property (nonatomic, copy) NSString * bimgs;
@property (nonatomic, copy) NSString * bimgt;
@property (nonatomic, copy) NSString * bimgfo;

-(instancetype) initWithDict:(NSDictionary*)dict;
+(instancetype) dogWithDict:(NSDictionary *) dict;
@end
