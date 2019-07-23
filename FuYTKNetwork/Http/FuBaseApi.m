//
//  FuBaseApi.m
//  RAC+MVVM
//
//  Created by mmz on 2019/7/18.
//  Copyright © 2019 RAC+MVVM. All rights reserved.
//

#import "FuBaseApi.h"
#import "FuAnalysis.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "NSString+FuAdd.h"
#import <YYKit/YYKit.h>

@implementation FuBaseApi{
    NSDictionary *_param;
    FuHttpType _type;
}

- (id)initWithParam:(NSDictionary *)param type:(FuHttpType)type {
    self = [super init];
    if (self) {
        _param = param;
        _type = type;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[FuHttpStatement shared] requestUrl:_type];
}

- (YTKRequestMethod)requestMethod {
    FuHttpMethod method = [[FuHttpStatement shared] method:_type];
    YTKRequestMethod ytkMethod = YTKRequestMethodGET;
    switch (method) {
        case FU_HTTP_GET:
            ytkMethod = YTKRequestMethodGET;
            break;
        case FU_HTTP_POST:
            ytkMethod = YTKRequestMethodPOST;
            break;
        case FU_HTTP_HEAD:
            ytkMethod = YTKRequestMethodHEAD;
            break;
        case FU_HTTP_PUT:
            ytkMethod = YTKRequestMethodPUT;
            break;
        case FU_HTTP_DELETE:
            ytkMethod = YTKRequestMethodDELETE;
            break;
        case FU_HTTP_PATCH:
            ytkMethod = YTKRequestMethodPATCH;
            break;
        default:
            break;
    }
    return ytkMethod;
}

- (id)requestArgument {
    return _param;
}

- (NSInteger)cacheTimeInSeconds {
    return 60 * 3;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{
             @"Php-Ios-Client-Id": @"",
             @"Php-Auth-User": @"",
             @"Php-Auth-Pw": @"",
             @"Mmz-Ios-Version": @"",
             @"App-From": @"",
             @"Shu-Meng-Did": @""
             };
}

#pragma mark -

- (void)startWithCompletionBlock:(void(^)(BOOL isSuccess, id object))block {
    @weakify(self)
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self)
        if ([request.responseObject isKindOfClass:[NSDictionary class]] == NO) {
            FuError *error = FuError(@"未知的网络错误", 9999);
            block(NO, error);
        }else {
            FuHttpStatement *statement = [FuHttpStatement shared];
#if DEBUG
            FLog(@"接收到网络消息[%@]---json=%@", [statement requestUrl:self->_type], [request.responseObject jsonStringEncoded]);
#endif
            FuError *error = [self checkResponseData:request.responseObject];
            if (error == nil) {
                Class class = [statement typeClass:self->_type];
                NSDictionary *dict = (NSDictionary *)request.responseObject;
                id model = [class modelWithDictionary:dict[@"data"]];
                if (model != nil) {
                    block(YES, model);
                }else {
#if DEBUG
                    [[FuAnalysis alloc] analysisWithClassName:[statement typeClassName:self->_type] object:dict];
#endif
                    block(YES, dict[@"data"]);
                }
            }else {
                block(NO, error);
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        block(NO, FuError(@"未知的网络错误", 9999));
    }];
}

- (FuError *)checkResponseData:(NSDictionary *)dict {
    if (dict == nil) {
        return FuError(@"未知的网络错误", 9999);
    }else {
        if ([dict.allKeys containsObject:@"RC"] && [dict[@"RC"] integerValue] == 1) {
            //正确的数据格式
            
        }else {
            return FuError(@"服务器数据错误", 9998);
        }
        return nil;
    }
}

@end
