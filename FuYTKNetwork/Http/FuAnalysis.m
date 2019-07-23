//
//  FuAnalysis.m
//  FuHttpDemo
//
//  Created by 付海龙 on 2019/3/27.
//  Copyright © 2019 付海龙. All rights reserved.
//

#import "FuAnalysis.h"
#import "NSString+FuAdd.h"

@interface FuAnalysis () {
    NSArray *_keyWords;
}
@property (nonatomic, strong) NSMutableArray *hItems;     //.h文件log
@property (nonatomic, strong) NSMutableArray *mItems;     //.m文件log
@end

@implementation FuAnalysis

- (NSMutableArray *)hItems {
    if (_hItems == nil) {
        _hItems = [NSMutableArray array];
    }
    return _hItems;
}

- (NSMutableArray *)mItems {
    if (_mItems == nil) {
        _mItems = [NSMutableArray array];
    }
    return _mItems;
}

- (void)analysisWithClassName:(NSString *)className object:(id)responseObjct {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self->_keyWords = @[@"id"];
        NSDictionary *dict = (NSDictionary *)responseObjct;
        [self printClassAllProperty:dict className:className];
    });
}

#pragma mark - .h

- (void)printClassAllProperty:(NSDictionary *)dict className:(NSString *)className {
    //.h
    __block NSString *log = @"\n---\n\n";
    
    log = [log stringByAppendingString:[NSString stringWithFormat:@"ClassName : %@ \n\n", className]];
    
    log = [log stringByAppendingString:@".h文件\n\n"];
    
    [self toHFileString:dict key:nil className:className];
    [self.hItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        log = [log stringByAppendingString:obj];
    }];
    
    log = [log stringByAppendingString:@"\n---\n\n"];
    
    //.m
    log = [log stringByAppendingString:@".m文件\n\n"];
    
    [self toMFileString:dict key:nil className:className];
    [[[self.mItems reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        log = [log stringByAppendingString:obj];
    }];
    
    log = [log stringByAppendingString:@"\n---\n"];
    
    NSLog(@"%@", log);
}

- (NSString *)getPropertyString:(id)value key:(NSString *)key className:(NSString *)className {
    NSString *propertyString = @"";
    
    if ([_keyWords containsObject:key]) {
        key = [NSString stringWithFormat:@"%@Obj", key];
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        propertyString = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;\n", key];
    }else if ([value isKindOfClass:[NSNumber class]]) {
        propertyString = [NSString stringWithFormat:@"@property (nonatomic, strong) NSNumber *%@;\n", key];
    }else if ([value isKindOfClass:[NSArray class]]) {
        propertyString = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;\n", key];
    }else if ([value isKindOfClass:[NSDictionary class]]) {
        NSString *newStr = className;
        if ([className hasSuffix:@"Model"]) {
            newStr = [className substringToIndex:className.length - 5];
        }
        NSString *name = [NSString stringWithFormat:@"%@%@Model", newStr, [key capitalizedString]];
        propertyString = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;\n", name, key];
    }
    
    return propertyString;
}

- (void)toHFileString:(NSDictionary *)dict key:(NSString *)key className:(NSString *)className {
    NSString *newClassName = className;
    __block NSString *log = @"";
    if (IsEmpty(key)) {
        log = [NSString stringWithFormat:@"@interface %@ : NSObject\n", className];
    }else {
        NSString *newStr = className;
        if ([className hasSuffix:@"Model"]) {
            newStr = [className substringToIndex:className.length - 5];
        }
        newClassName = [NSString stringWithFormat:@"%@%@Model", newStr, [key capitalizedString]];
        log = [log stringByAppendingString:[NSString stringWithFormat:@"@interface %@ : NSObject\n", newClassName]];
    }
    
    //遍历所有key
    NSArray *keys = dict.allKeys;
    //当前对象中是字典或数组的集合
    __block NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:keys.count];
    [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *oneKey = (NSString *)obj;
        id value = dict[oneKey];
        log = [log stringByAppendingString:[self getPropertyString:value key:oneKey className:className]];
        if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
            [mutArray addObject:@{oneKey:value}];
        }
    }];
    
    log = [log stringByAppendingString:@"@end\n\n"];
    [self.hItems insertObject:log atIndex:0];
    
    [mutArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *oneDict = (NSDictionary *)obj;
        NSString *oneKey = oneDict.allKeys.firstObject;
        id value = oneDict.allValues.firstObject;
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self toHFileString:value key:[oneKey capitalizedString] className:newClassName];
        }else {
            [self propertyIsArray:value name:[oneKey capitalizedString] className:newClassName];
        }
    }];
}

- (void)propertyIsArray:(NSArray *)array name:(NSString *)name className:(NSString *)className {
    __weak NSString *newStr = className;
    if ([className hasSuffix:@"Model"]) {
        newStr = [className substringToIndex:className.length - 5];
    }
    newStr = [NSString stringWithFormat:@"%@%@Model", newStr, [name capitalizedString]];
    __block NSString *log = [NSString stringWithFormat:@"@interface %@ : NSObject\n", newStr];
    
    __block NSMutableArray *valueIsDicts = [NSMutableArray array];
    __block NSMutableArray *propertys = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            //array中的某一个对象
            NSDictionary *dict = (NSDictionary *)obj;
            [dict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *oneKey = (NSString *)obj1;
                if (![propertys containsObject:oneKey]) {
                    id value = dict[oneKey];
                    if ([value isKindOfClass:[NSDictionary class]]) {
                        [valueIsDicts addObject:value];
                    }
                    log = [log stringByAppendingString:[self getPropertyString:value key:oneKey className:newStr]];
                    [propertys addObject:oneKey];
                }
            }];
        }
    }];
    
    log = [log stringByAppendingString:@"@end\n\n"];
    [self.hItems insertObject:log atIndex:0];
}

#pragma mark - .m

- (void)toMFileString:(id)object key:(NSString *)key className:(NSString *)className {
    NSString *newClassName = className;
    __block NSString *log = @"";
    if (IsEmpty(key)) {
        log = [NSString stringWithFormat:@"\n@implementation %@\n\n", className];
    }else {
        NSString *newStr = className;
        if ([className hasSuffix:@"Model"]) {
            newStr = [className substringToIndex:className.length - 5];
        }
        newClassName = [NSString stringWithFormat:@"%@%@Model", newStr, [key capitalizedString]];
        log = [log stringByAppendingString:[NSString stringWithFormat:@"\n@implementation %@\n\n", newClassName]];
    }
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        //当前对象中是字典或数组的集合
        __block NSMutableArray *mutArray = nil;
        __block NSMutableArray *tmpKeyWords = nil;
        
        NSDictionary *dict = (NSDictionary *)object;
        //遍历所有key
        NSArray *keys = dict.allKeys;
        mutArray = [NSMutableArray arrayWithCapacity:keys.count];
        [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *oneKey = (NSString *)obj;
            id value = dict[oneKey];
            if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
                [mutArray addObject:@{oneKey:value}];
            }else {
                if ([self->_keyWords containsObject:value]) {
                    [tmpKeyWords addObject:value];
                }
            }
        }];
        
        if (mutArray != nil && mutArray.count > 0) {
            [mutArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *oneDict = (NSDictionary *)obj;
                NSString *oneKey = oneDict.allKeys.firstObject;
                id value = oneDict.allValues.firstObject;
                if ([value isKindOfClass:[NSDictionary class]]) {
                    [self toMFileString:value key:[oneKey capitalizedString] className:newClassName];
                }else {
                    log = [log stringByAppendingString:@"+ (NSDictionary *)modelContainerPropertyGenericClass {\n"];
                    
                    log = [log stringByAppendingString:@"   return @{\n"];
                    
                    NSString *newStr = newClassName;
                    if ([className hasSuffix:@"Model"]) {
                        newStr = [newClassName substringToIndex:newClassName.length - 5];
                    }
                    log = [log stringByAppendingString:[NSString stringWithFormat:@"            @\"%@\":[%@ class],\n", oneKey, [NSString stringWithFormat:@"%@%@Model", newStr, [oneKey capitalizedString]]]];
                    log = [log stringByAppendingString:@"           };\n"];
                    log = [log stringByAppendingString:@"}\n\n"];
                    
                    [self toMFileString:value key:[oneKey capitalizedString] className:newClassName];
                }
            }];
        }
        
        if (tmpKeyWords != nil && tmpKeyWords.count > 0) {
            log = [log stringByAppendingString:@"+ (NSDictionary *)modelCustomPropertyMapper {\n"];
            log = [log stringByAppendingString:@"   return @{\n"];
            [tmpKeyWords enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *keyWord = (NSString *)obj;
                if ([self->_keyWords containsObject:keyWord]) {
                    log = [log stringByAppendingString:[NSString stringWithFormat:@"            @\"%@Obj\": @\"%@\"\n", keyWord, keyWord]];
                }
            }];
            log = [log stringByAppendingString:@"           };\n"];
            log = [log stringByAppendingString:@"}\n\n"];
        }
    }else if ([object isKindOfClass:[NSArray class]]) {
        //数组 遍历所有的key，查看是否有关键字
        NSArray *array = (NSArray *)object;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = (NSDictionary *)obj;
            if ([dict.allKeys containsObject:@"id"]) {
                log = [log stringByAppendingString:@"+ (NSDictionary *)modelCustomPropertyMapper {\n"];
                log = [log stringByAppendingString:@"   return @{\n"];
                log = [log stringByAppendingString:@"            @\"idObj\": @\"id\"\n"];
                log = [log stringByAppendingString:@"           };\n"];
                log = [log stringByAppendingString:@"}\n\n"];
                *stop = YES;
            }
        }];
    }
    
    log = [log stringByAppendingString:@"@end\n"];
    [self.mItems insertObject:log atIndex:0];
}

@end
