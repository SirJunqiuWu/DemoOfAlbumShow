//
//  NSArray+NSArray_Utils.h
//  HaoWu_4.0
//
//  Created by caijingpeng.haowu on 14-6-10.
//  Copyright (c) 2014年 caijingpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Utils)

- (id)pObjectAtIndex:(NSInteger)index;

- (NSArray *)arrayWithObjectProperty:(NSString *)pName;
- (NSInteger)indexOfObjectProperty:(NSString *)pName value:(id)value;
- (id)objectOfProperty:(NSString *)pName value:(id)value;
- (NSArray *)arrayOfDictionaryFillObject:(Class)objClass;

@end
