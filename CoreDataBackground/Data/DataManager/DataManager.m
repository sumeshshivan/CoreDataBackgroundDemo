//
//  DataManager.m
//  CoreDataBackground
//
//  Created by Sumesh on 17/03/16.
//  Copyright © 2016 Sumesh. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (DataManager *)sharedManager {
    
    static DataManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
        
    });
    return _sharedManager;
}

- (id)init{
    self = [super init];
    if(self){
    }
    return self;
}


#pragma mark Functions
- (void)saveContext {
    NSLog(@" Saving context");
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        //		DLog(@" Context not nil and changes = %d", [managedObjectContext hasChanges]);
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            //DLog(@"Error in saving");
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)saveBackgroundContext {
    NSLog(@" Saving background context");

    NSManagedObjectContext *backgroundManagedObjectContext = self.backgroundManagedObjectContext;
    
    [backgroundManagedObjectContext performBlock:^{
        
        NSError *error = nil;
        if (backgroundManagedObjectContext != nil) {
            
            NSLog(@" Context not nil and changes = %d", [backgroundManagedObjectContext hasChanges]);
            
            if ([backgroundManagedObjectContext hasChanges] && ![backgroundManagedObjectContext save:&error]) {
                /*
                 Replace this implementation with code to handle the error appropriately.
                 
                 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
                 */
                //DLog(@"Error in saving");
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
        
    }];
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    NSLog(@" Creating managed Context");
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


- (NSManagedObjectContext *)backgroundManagedObjectContext {
    
    if (backgroundManagedObjectContext_ != nil) {
        return backgroundManagedObjectContext_;
    }
    NSLog(@" Creating background managed Context");
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        backgroundManagedObjectContext_ = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [backgroundManagedObjectContext_ setPersistentStoreCoordinator:coordinator];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
    }
    return backgroundManagedObjectContext_;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel_;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator dosn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Data.sqlite"];
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return persistentStoreCoordinator_;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)_mocDidSaveNotification:(NSNotification *)notification
{
    NSManagedObjectContext *savedContext = [notification object];
    
    NSLog(@"Inside context save notification reciever");
    
    // ignore change notifications for the main managed object context
    if (managedObjectContext_ == savedContext)
    {
        return;
    }
    
    if (managedObjectContext_.persistentStoreCoordinator != savedContext.persistentStoreCoordinator)
    {
        // that's another database
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"Merging contexts");
        [managedObjectContext_ mergeChangesFromContextDidSaveNotification:notification];
    });
}

@end
