//
//  NSString+FuAdd.h
//  RAC+MVVM
//
//  Created by mmz on 2019/7/19.
//  Copyright © 2019 RAC+MVVM. All rights reserved.
//

#define FLog(format, ...) printf("%s [Line %d] %s \n", __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#define IsEmpty(str) [NSString isEmpty:str]

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FuAdd)

///判断字符串是否为空
+ (BOOL)isEmpty:(NSString *)str;

///获取.string内对应的字符串
- (NSString *)localString;

///获取App版本信息
+ (NSString *)appVersion;

///获取App名字
+ (NSString *)appName;

///获取设备系统版本号
+ (NSString *)deviceVersion;

@end

NS_ASSUME_NONNULL_END
