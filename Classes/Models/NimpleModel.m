//
//  NimpleModel.m
//  nimple-iOS
//
//  Created by Ben John on 14/08/14.
//  Copyright (c) 2014 nimple. All rights reserved.
//

#import "NimpleAppDelegate.h"
#import "NimpleModel.h"

#define NimpleContactEntityName @"NimpleContact"
#define NimpleContactCreatedColumn @"created"
#define NimpleExampleUserCreatedKey @"example_contact_once_existed"

@interface NimpleModel () {
    NSManagedObjectContext *_mainContext;
}
@end

@implementation NimpleModel

+ (id)sharedModel
{
    static id sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedModel = [[self alloc] init];
    });
    return sharedModel;
}

- (id)init
{
    self = [super init];
    if (self) {
        _mainContext = [self managedObjectContext];
    }
    return self;
}

#pragma mark - Core Data initialization

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context;
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    [context setPersistentStoreCoordinator:coordinator];
    return context;
}

- (NSManagedObjectModel *)managedObjectModel
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    NSURL *storeURL = [self storeURL];
    NSDictionary *storeOptions = [self storeOptions];
    NSError *error = nil;
    NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:storeOptions error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return storeCoordinator;
}

- (NSDictionary *)storeOptions
{
    // we use lightweight core-data migration, should fit in our case
    return @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
}

- (NSURL *)storeURL
{
    NimpleAppDelegate *appDelegate = (NimpleAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [[appDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"NimpleContact.sqlite"];
}

#pragma mark - Core Data operations

- (NSManagedObject *)objectWithID:(NSManagedObjectID *)objectID
{
    return [_mainContext objectWithID:objectID];
}

- (id)addObjectWithEntityName:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:_mainContext];
}

- (void)removeObjectWithID:(NSManagedObjectID *)objectID
{
    NSManagedObject *object = [self objectWithID:objectID];
    [_mainContext deleteObject:object];
}

- (void)save
{
    NSError *error;
    if (![_mainContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Contacts

- (BOOL)exampleUserCreated
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:NimpleExampleUserCreatedKey];
}

- (void)createExampleContact
{
    if (![self exampleUserCreated]) {
        NimpleContact *contact = [self getEntityForNewContact];
        contact.prename = @"Nimple";
        contact.surname = @"App";
        contact.phone = @"";
        contact.email = @"feedback.ios@nimple.de";
        contact.job = @"";
        contact.company = NimpleLocalizedString(@"company_first_contact_label");
        contact.facebook_URL = @"http://www.facebook.de/nimpleapp";
        contact.facebook_ID = @"286113114869395";
        contact.twitter_URL = @"https://twitter.com/Nimpleapp";
        contact.twitter_ID = @"2444364654";
        contact.xing_URL = @"https://www.xing.com/companies/appstronautengbr";
        contact.linkedin_URL = @"https://www.linkedin.com/company/appstronauten-gbr";
        contact.created = [NSDate date];
        contact.website = @"http://www.nimple.de";
        contact.note = @"";
        contact.street = @"";
        contact.postal = @"";
        contact.city = @"";
        [self save];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NimpleExampleUserCreatedKey];
    }
}

- (NimpleContact *)getTemporaryContact
{
    return [[NimpleContact alloc] initWithEntity:[NSEntityDescription entityForName:NimpleContactEntityName inManagedObjectContext:_mainContext] insertIntoManagedObjectContext:nil];
}

- (NimpleContact *)getEntityForNewContact
{
    return [self addObjectWithEntityName:NimpleContactEntityName];
}

- (void)deleteContact:(NimpleContact *)contact
{
    [self removeObjectWithID:contact.objectID];
}

- (NSSortDescriptor *)contactsSortDescriptor
{
    return [[NSSortDescriptor alloc] initWithKey:NimpleContactCreatedColumn ascending:NO];
}

- (NSArray *)contactsSortDescriptors
{
    return @[[self contactsSortDescriptor]];
}

- (NSArray *)contacts
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:NimpleContactEntityName inManagedObjectContext:_mainContext];
    fetchRequest.sortDescriptors = [self contactsSortDescriptors];
    NSError *error = nil;
    NSArray* contacts = [_mainContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Contacts fetch error %@", error);
        return @[];
    }
    return contacts;
}

- (BOOL)doesContactExistWithHash:(NSString *)contactHash
{
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [NSEntityDescription entityForName:@"NimpleContact" inManagedObjectContext:_mainContext];
    fetch.predicate = [NSPredicate predicateWithFormat:@"contactHash == %@", contactHash];
    NSArray *result = [_mainContext executeFetchRequest:fetch error:nil];
    return (result.count > 0);
}

@end
