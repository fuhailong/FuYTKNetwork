//
//  FuHttpInfo.h
//  RAC+MVVM
//
//  Created by mmz on 2019/7/18.
//  Copyright © 2019 RAC+MVVM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FuHttpType) {
    FU_HTTP_BEGIN = -1,
    
    FU_HTTP_GET_DATA,
    
    FU_HTTP_END,
};

typedef NS_ENUM(NSInteger, FuHttpMethod) {
    FU_HTTP_POST,
    FU_HTTP_GET,
    FU_HTTP_HEAD,
    FU_HTTP_PUT,
    FU_HTTP_DELETE,
    FU_HTTP_PATCH
};

static const NSString *FuHttpInfoKey = @"FuHttp";

@interface FuHttpInfo : NSObject
@property (nonatomic, readonly) NSString *className;
@property (nonatomic, readonly) NSString *url;
@property (nonatomic, readonly) NSNumber *type;
@property (nonatomic, readonly) FuHttpMethod method;
- (id)initWithInfo:(nonnull NSString *)className url:(nonnull NSString *)url type:(FuHttpType)type method:(FuHttpMethod)method;
- (NSString *)dictKey;
@end

NS_ASSUME_NONNULL_END
