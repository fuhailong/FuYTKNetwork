//
//  FuHttpStatement.h
//  RAC+MVVM
//
//  Created by mmz on 2019/7/18.
//  Copyright © 2019 RAC+MVVM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FuHttpInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface FuHttpStatement : NSObject
@property (nonatomic, readonly) NSDictionary *httpInfos;

+ (FuHttpStatement *)shared;
- (NSString *)typeClassName:(FuHttpType)type;
- (Class)typeClass:(FuHttpType)type;
- (NSString *)requestUrl:(FuHttpType)type;
- (FuHttpMethod)method:(FuHttpType)type;

@end

NS_ASSUME_NONNULL_END
