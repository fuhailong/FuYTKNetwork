//
//  FuHttpApi.m
//  RAC+MVVM
//
//  Created by mmz on 2019/7/18.
//  Copyright © 2019 RAC+MVVM. All rights reserved.
//

#import "FuHttpApi.h"

@implementation FuHttpApi

///请求列表数据
- (id)initToGetListData:(NSDictionary *)param {
    return [super initWithParam:param type:FU_HTTP_GET_DATA];
}

@end
