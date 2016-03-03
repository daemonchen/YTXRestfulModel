//
//  YTXTestStudentModel.m
//  YTXRestfulModel
//
//  Created by CaoJun on 16/2/25.
//  Copyright © 2016年 caojun. All rights reserved.
//

#import "YTXTestStudentModel.h"

#import <YTXRestfulModel/NSObject+YTXRestfulModelFMDBSync.h>

@implementation YTXTestStudentModel

+ (instancetype) shared
{
    static YTXTestStudentModel * model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model =  [[[self class] alloc] init];
    });
    return model;
}

- (instancetype)init
{
    if (self = [super init]) {
        _IQ = @"100";
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"identify": @"id"};
}

+ (NSString *)primaryKey
{
    return @"identify";
}

+ (nullable NSMutableDictionary<NSString *, NSValue *> *) tableKeyPathsByPropertyKey
{
    NSMutableDictionary<NSString *, NSValue *> * tmpDictionary = [[super tableKeyPathsByPropertyKey] mutableCopy];
    
    struct YTXRestfulModelDBSerializingStruct genderStruct;
    
    [tmpDictionary[@"gender"] getValue:&genderStruct];
    
    genderStruct.defaultValue = [[@(GenderFemale) sqliteValue] UTF8String];
    
    tmpDictionary[@"gender"] = [NSValue value:&genderStruct withObjCType:@encode(struct YTXRestfulModelDBSerializingStruct)];
    
    
    struct YTXRestfulModelDBSerializingStruct scoreStruct;
    
    [tmpDictionary[@"score"] getValue:&scoreStruct];
    
    scoreStruct.unique = YES;
    
    tmpDictionary[@"score"] = [NSValue value:&scoreStruct withObjCType:@encode(struct YTXRestfulModelDBSerializingStruct)];
    
    return tmpDictionary;
}

+ (nullable NSNumber *) currentMigrationVersion
{
    return @0;
}

+ (BOOL) autoCreateTable
{
    return YES;
}

+ (MTLValueTransformer *)startSchoolDateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *timestamp) {
        return [NSDate dateWithTimeIntervalSince1970: timestamp.longLongValue / 1000];
    } reverseBlock:^(NSDate *date) {
        return @((SInt64)(date.timeIntervalSince1970 * 1000));
    }];
}

+ (MTLValueTransformer *)birthdayJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *timestamp) {
        return [NSDate dateWithTimeIntervalSince1970: timestamp.longLongValue / 1000];
    } reverseBlock:^(NSDate *date) {
        return @((SInt64)(date.timeIntervalSince1970 * 1000));
    }];
}

@end