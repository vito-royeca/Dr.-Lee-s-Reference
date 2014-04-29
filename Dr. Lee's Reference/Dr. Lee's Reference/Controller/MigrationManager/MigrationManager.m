//
//  MigrationManager.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/29/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "MigrationManager.h"
#import "NSManagedObjectModel+MHWAdditions.h"

@interface MigrationManager()

@property (nonatomic, readonly, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (BOOL)progressivelyMigrateURL:(NSURL *)sourceStoreURL
                         ofType:(NSString *)type
                        toModel:(NSManagedObjectModel *)finalModel
                          error:(NSError **)error;

- (NSURL *)sourceStoreURL;
//- (void)migrationManager:(MHWMigrationManager *)migrationManager migrationProgress:(float)migrationProgress;

@end

@implementation MigrationManager

@synthesize managedObjectModel         = _managedObjectModel;
@synthesize managedObjectContext       = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    _managedObjectContext.persistentStoreCoordinator = coordinator;
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    NSString *momPath = [[NSBundle mainBundle] pathForResource:@"Model"
                                                        ofType:@"momd"];
    
    if (!momPath)
    {
        momPath = [[NSBundle mainBundle] pathForResource:@"Model"
                                                  ofType:@"mom"];
    }
    
    NSURL *url = [NSURL fileURLWithPath:momPath];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSError *error = nil;
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:[self sourceStoreType]
                                                   configuration:nil
                                                             URL:[self sourceStoreURL]
                                                         options:nil
                                                           error:&error]) {
        
        NSLog(@"error: %@", error);
        NSFileManager *fileManager = [NSFileManager new];
        [fileManager removeItemAtPath:[self sourceStoreURL].path error:nil];
        
        [[[UIAlertView alloc] initWithTitle:@"Ouch"
                                    message:error.localizedDescription
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)sourceStoreURL
{
    return [[self urlToDocumentDirectory] URLByAppendingPathComponent:kDatabaseStore];
}

- (BOOL)progressivelyMigrateURL:(NSURL *)sourceStoreURL
                         ofType:(NSString *)type
                        toModel:(NSManagedObjectModel *)finalModel
                          error:(NSError **)error
{
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:type
                                                                                              URL:sourceStoreURL
                                                                                            error:error];
    if (!sourceMetadata)
    {
        return NO;
    }
    
    if ([finalModel isConfiguration:nil
        compatibleWithStoreMetadata:sourceMetadata])
    {
        if (NULL != error)
        {
            *error = nil;
        }
        return YES;
    }
    NSManagedObjectModel *sourceModel = [self sourceModelForSourceMetadata:sourceMetadata];
    NSManagedObjectModel *destinationModel = nil;
    NSMappingModel *mappingModel = nil;
    NSString *modelName = nil;
    if (![self getDestinationModel:&destinationModel
                      mappingModel:&mappingModel
                         modelName:&modelName
                    forSourceModel:sourceModel
                             error:error])
    {
        return NO;
    }
    
    NSArray *mappingModels = @[mappingModel];
    NSArray *explicitMappingModels = [self mappingModelsForSourceModel:sourceModel];
    if (0 < explicitMappingModels.count)
    {
        mappingModels = explicitMappingModels;
    }
    NSURL *destinationStoreURL = [self destinationStoreURLWithSourceStoreURL:sourceStoreURL
                                                                   modelName:modelName];
    NSMigrationManager *manager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel
                                                                 destinationModel:destinationModel];
    [manager addObserver:self
              forKeyPath:@"migrationProgress"
                 options:NSKeyValueObservingOptionNew
                 context:nil];
    BOOL didMigrate = NO;
    for (NSMappingModel *mappingModel in mappingModels)
    {
        didMigrate = [manager migrateStoreFromURL:sourceStoreURL
                                             type:type
                                          options:nil
                                 withMappingModel:mappingModel
                                 toDestinationURL:destinationStoreURL
                                  destinationType:type
                               destinationOptions:nil
                                            error:error];
    }
    [manager removeObserver:self
                 forKeyPath:@"migrationProgress"];
    if (!didMigrate)
    {
        return NO;
    }
    // Migration was successful, move the files around to preserve the source in case things go bad
    if (![self backupSourceStoreAtURL:sourceStoreURL
          movingDestinationStoreAtURL:destinationStoreURL
                                error:error])
    {
        return NO;
    }
    // We may not be at the "current" model yet, so recurse
    return [self progressivelyMigrateURL:sourceStoreURL
                                  ofType:type
                                 toModel:finalModel
                                   error:error];
}

#pragma mark - Pubic methods
- (BOOL)isMigrationNeeded
{
    NSError *error = nil;
    
    // Check if we need to migrate
    NSDictionary *sourceMetadata = [self sourceMetadata:&error];
    BOOL isMigrationNeeded = NO;
    
    if (sourceMetadata != nil)
    {
        NSManagedObjectModel *destinationModel = [self managedObjectModel];
        // Migration is needed if destinationModel is NOT compatible
        isMigrationNeeded = ![destinationModel isConfiguration:nil
                                   compatibleWithStoreMetadata:sourceMetadata];
    }
    return isMigrationNeeded;
}

- (BOOL)migrate:(NSError *__autoreleasing *)error
{
    // Enable migrations to run even while user exits app
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    //    MHWMigrationManager *migrationManager = [MHWMigrationManager new];
    //    migrationManager.delegate = self;
    
    BOOL OK = [self progressivelyMigrateURL:[self sourceStoreURL]
                                     ofType:[self sourceStoreType]
                                    toModel:[self managedObjectModel]
                                      error:error];
    if (OK)
    {
        NSLog(@"migration complete");
    }
    
    // Mark it as invalid
    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
    return OK;
}

#pragma mark - Helper methods
-(NSURL *) urlToDocumentDirectory
{
	NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                               NSUserDomainMask,
                                                               YES) objectAtIndex:0];
	BOOL isDir = NO;
	NSError *error = nil;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
	if (![fileManager fileExistsAtPath:directory
                           isDirectory:&isDir] && isDir == NO) {
		[fileManager createDirectoryAtPath:directory
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:&error];
	}
    return [NSURL fileURLWithPath:directory];
}

- (NSString *)sourceStoreType
{
    return NSSQLiteStoreType;
}

- (NSDictionary *)sourceMetadata:(NSError **)error
{
    return [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:[self sourceStoreType]
                                                                      URL:[self sourceStoreURL]
                                                                    error:error];
}

- (NSManagedObjectModel *)sourceModelForSourceMetadata:(NSDictionary *)sourceMetadata
{
    return [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]
                                       forStoreMetadata:sourceMetadata];
}

- (BOOL)getDestinationModel:(NSManagedObjectModel **)destinationModel
               mappingModel:(NSMappingModel **)mappingModel
                  modelName:(NSString **)modelName
             forSourceModel:(NSManagedObjectModel *)sourceModel
                      error:(NSError **)error
{
    NSArray *modelPaths = [self modelPaths];
    if (!modelPaths.count)
    {
        //Throw an error if there are no models
        if (NULL != error)
        {
            *error = [NSError errorWithDomain:@"Zarra"
                                         code:8001
                                     userInfo:@{ NSLocalizedDescriptionKey : @"No models found!" }];
        }
        return NO;
    }
    
    //See if we can find a matching destination model
    NSManagedObjectModel *model = nil;
    NSMappingModel *mapping = nil;
    NSString *modelPath = nil;
    for (modelPath in modelPaths)
    {
        model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
        mapping = [NSMappingModel mappingModelFromBundles:@[[NSBundle mainBundle]]
                                           forSourceModel:sourceModel
                                         destinationModel:model];
        //If we found a mapping model then proceed
        if (mapping)
        {
            break;
        }
    }
    //We have tested every model, if nil here we failed
    if (!mapping)
    {
        if (NULL != error)
        {
            *error = [NSError errorWithDomain:@"Zarra"
                                         code:8001
                                     userInfo:@{ NSLocalizedDescriptionKey : @"No mapping model found in bundle" }];
        }
        return NO;
    }
    else
    {
        *destinationModel = model;
        *mappingModel = mapping;
        *modelName = modelPath.lastPathComponent.stringByDeletingPathExtension;
    }
    return YES;
}

- (NSArray *)modelPaths
{
    //Find all of the mom and momd files in the Resources directory
    NSMutableArray *modelPaths = [NSMutableArray array];
    NSArray *momdArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"momd"
                                                            inDirectory:nil];
    for (NSString *momdPath in momdArray) {
        NSString *resourceSubpath = [momdPath lastPathComponent];
        NSArray *array = [[NSBundle mainBundle] pathsForResourcesOfType:@"mom"
                                                            inDirectory:resourceSubpath];
        [modelPaths addObjectsFromArray:array];
    }
    NSArray *otherModels = [[NSBundle mainBundle] pathsForResourcesOfType:@"mom"
                                                              inDirectory:nil];
    [modelPaths addObjectsFromArray:otherModels];
    return modelPaths;
}

- (NSArray*) mappingModelsForSourceModel:(NSManagedObjectModel *)sourceModel
{
    NSMutableArray *mappingModels = [@[] mutableCopy];
    NSString *modelName = [sourceModel mhw_modelName];
    
    if ([modelName isEqual:@"2"])
    {
        // Migrating to Model3
        NSArray *urls = [[NSBundle bundleForClass:[self class]]
                         URLsForResourcesWithExtension:@"cdm"
                         subdirectory:nil];
        
        for (NSURL *url in urls)
        {
            if ([url.lastPathComponent rangeOfString:@"2to3"].length != 0)
            {
                NSMappingModel *mappingModel = [[NSMappingModel alloc] initWithContentsOfURL:url];
                if ([url.lastPathComponent rangeOfString:@"User"].length != 0)
                {
                    // User first so we create new relationship
                    [mappingModels insertObject:mappingModel atIndex:0];
                }
                else
                {
                    [mappingModels addObject:mappingModel];
                }
            }
        }
    }
    return mappingModels;
}

- (NSURL *)destinationStoreURLWithSourceStoreURL:(NSURL *)sourceStoreURL
                                       modelName:(NSString *)modelName
{
    // We have a mapping model, time to migrate
    NSString *storeExtension = sourceStoreURL.path.pathExtension;
    NSString *storePath = sourceStoreURL.path.stringByDeletingPathExtension;
    // Build a path to write the new store
    storePath = [NSString stringWithFormat:@"%@.%@.%@", storePath, modelName, storeExtension];
    return [NSURL fileURLWithPath:storePath];
}

- (BOOL)backupSourceStoreAtURL:(NSURL *)sourceStoreURL
   movingDestinationStoreAtURL:(NSURL *)destinationStoreURL
                         error:(NSError **)error
{
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *backupPath = [NSTemporaryDirectory() stringByAppendingPathComponent:guid];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager moveItemAtPath:sourceStoreURL.path
                              toPath:backupPath
                               error:error])
    {
        //Failed to copy the file
        return NO;
    }
    
    //Move the destination to the source path
    if (![fileManager moveItemAtPath:destinationStoreURL.path
                              toPath:sourceStoreURL.path
                               error:error])
    {
        //Try to back out the source move first, no point in checking it for errors
        [fileManager moveItemAtPath:backupPath
                             toPath:sourceStoreURL.path
                              error:nil];
        return NO;
    }
    
    return YES;
}

@end
