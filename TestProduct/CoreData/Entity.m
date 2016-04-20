//
//  Entity.m
//  TestProduct
//
//  Created by zhangke on 16/1/6.
//  Copyright © 2016年 zhangke. All rights reserved.
//

#import "Entity.h"
#import "CoreDataStorage.h"

@implementation Entity



// Insert code here to add functionality to your managed object subclass
+(void)insertObjectIntoDataBaseWithEntity:(Entity*)model{
    NSManagedObjectContext *moc = [CoreDataStorage sharedManager].managedObjectContext;
    Entity *entity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:moc];
    entity.name = model.name;
    entity.age = model.age;
    entity.height = model.height;
    entity.weight = model.weight;
    [self saveContext:moc];
    
}




+(void)removeObjectFromDataBase{
    NSManagedObjectContext *moc = [CoreDataStorage sharedManager].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:moc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ && age == 4",@"wang"];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    if (result.count > 0) {
        for (id object in result) {
            [moc deleteObject:object];
        }
        NSError *error2 = nil;
        if (![moc save:&error]) {
            NSLog(@"don't save:%@",error2);
        }
    }
    
}

+(void)updateObjectFromDataBase{
    NSManagedObjectContext *moc = [CoreDataStorage sharedManager].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:moc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ && age = 4",@"wang"];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    if (result.count > 0) {
        for (Entity *object in result) {
            object.age = @"3";
        }
        NSError *error2 = nil;
        if (![moc save:&error]) {
            NSLog(@"don't save:%@",error2);
        }
    }
}

+(void)seacherObjectFromDataBase{
    NSManagedObjectContext *moc = [CoreDataStorage sharedManager].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:moc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age = 3 && weight = nil",nil];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    if (result.count > 0) {
        NSLog(@"%lu",(unsigned long)result.count);
    }
}

+(void)saveContext:(NSManagedObjectContext*)moc{
    if ([moc hasChanges]) {
        NSError *error = nil;
        if (![moc save:&error]) {
            NSLog(@"don't save:%@",error);
            [moc rollback];
        }
    }
}


@end
