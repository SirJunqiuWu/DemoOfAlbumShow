//
//  NSArray+NSArray_Utils.m
//  HaoWu_4.0
//
//  Created by caijingpeng.haowu on 14-6-10.
//  Copyright (c) 2014年 caijingpeng. All rights reserved.
//

#import "NSArray+Utils.h"

@implementation NSArray (Utils)

- (id)pObjectAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.count || [[self objectAtIndex:index] isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    return [self objectAtIndex:index];
}

- (NSArray *)arrayWithObjectProperty:(NSString *)pName
{
    NSMutableArray *array = [NSMutableArray array];
    for (id obj in self)
    {
        id p = [obj valueForKeyPath:pName];
        [array addObject:p];
    }
    return array;
}

- (NSInteger)indexOfObjectProperty:(NSString *)pName value:(id)value
{
    for (NSInteger i = 0; i < self.count; i++)
    {
        id obj = [self objectAtIndex:i];
        if ([[obj valueForKey:pName] isEqual:value])
        {
            return i;
        }
    }
    return -1;
}

- (id)objectOfProperty:(NSString *)pName value:(id)value
{
    for (NSInteger i = 0; i < self.count; i++)
    {
        id obj = [self objectAtIndex:i];
        if ([[obj valueForKey:pName] isEqual:value])
        {
            return obj;
        }
    }
    return nil;
}

- (NSArray *)arrayOfDictionaryFillObject:(Class)objClass
{
    NSMutableArray *tempArray = [NSMutableArray array];
//    for (int i = 0; i < self.count; i++)
//    {
//        NSDictionary *dic = [self objectAtIndex:i];
//        id model = [objClass mj_objectWithKeyValues:dic];
//        [tempArray addObject:model];
//    }
    return tempArray;
}

@end
