//
//  FuHttpApi.h
//  RAC+MVVM
//
//  Created by mmz on 2019/7/18.
//  Copyright © 2019 RAC+MVVM. All rights reserved.
//

#import "FuBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface FuHttpApi : FuBaseApi

///请求列表数据
- (id)initToGetListData:(NSDictionary *)param;

@end

NS_ASSUME_NONNULL_END
