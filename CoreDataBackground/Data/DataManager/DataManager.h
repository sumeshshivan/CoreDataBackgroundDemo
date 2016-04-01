//
//  DataManager.h
//  CoreDataBackground
//
//  Created by Sumesh on 17/03/16.
//  Copyright © 2016 Sumesh. All rights reserved.//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject {
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectContext *backgroundManagedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectContext *backgroundManagedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (DataManager *) sharedManager;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;
- (void)saveBackgroundContext;


@end
