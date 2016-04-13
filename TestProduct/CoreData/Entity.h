//
//  Entity.h
//  TestProduct
//
//  Created by zhangke on 16/1/6.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Entity : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)insertObjectIntoDataBaseWithEntity:(id)model;
+(void)removeObjectFromDataBase;
+(void)updateObjectFromDataBase;
+(void)seacherObjectFromDataBase;

@end

NS_ASSUME_NONNULL_END

#import "Entity+CoreDataProperties.h"
