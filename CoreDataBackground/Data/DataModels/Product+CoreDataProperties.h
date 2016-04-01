//
//  Product+CoreDataProperties.h
//  CoreDataBackground
//
//  Created by Sumesh on 17/03/16.
//  Copyright © 2016 Sumesh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@interface Product (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
