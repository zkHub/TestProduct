//
//  Entity+CoreDataProperties.h
//  TestProduct
//
//  Created by zhangke on 16/1/8.
//  Copyright © 2016年 zhangke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Entity.h"

NS_ASSUME_NONNULL_BEGIN

@interface Entity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *age;
@property (nullable, nonatomic, retain) NSString *height;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *weight;

@end

NS_ASSUME_NONNULL_END
