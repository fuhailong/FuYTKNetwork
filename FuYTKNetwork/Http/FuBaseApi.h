//
//  FuBaseApi.h
//  RAC+MVVM
//
//  Created by mmz on 2019/7/18.
//  Copyright © 2019 RAC+MVVM. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "FuHttpStatement.h"
#import "FuError.h"

NS_ASSUME_NONNULL_BEGIN

@interface FuBaseApi : YTKRequest

- (id)initWithParam:(NSDictionary *)param type:(FuHttpType)type;
- (void)startWithCompletionBlock:(void(^)(BOOL isSuccess, id object))block;

@end

NS_ASSUME_NONNULL_END
