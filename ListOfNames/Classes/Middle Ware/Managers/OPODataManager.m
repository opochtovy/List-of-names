//
//  OPODataManager.m
//  ListOfNames
//
//  Created by Aleh Pachtovy on 8/26/18.
//  Copyright © 2018 Aleh Pachtovy. All rights reserved.
//

#import "OPODataManager.h"

static OPODataManager *sharedManager = nil;

@interface OPODataManager ()

@property (nonatomic) NSString *filePath;
@property (nonatomic) NSArray *names;

@end

@implementation OPODataManager

+(OPODataManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[OPODataManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Custom Accessors

-(NSString *)filePath {
    return [NSHomeDirectory() stringByAppendingPathComponent:NSLocalizedString(@"data_manager_file_path", nil)];
}

-(NSArray *)names {
    if (_names == nil)
    {
        _names = [self getListOfNamesFromFile];
    }
    return _names;
}

#pragma mark - Private Methods

-(NSArray *)getListOfNamesFromFile
{
    return [[NSArray alloc] initWithContentsOfFile:[self filePath]];
}

#pragma mark - Public Methods

-(NSArray *)getListOfNames
{
    return self.names;
}

-(void)saveAddedName:(NSString *)name {
    if (name == nil) {
        return;
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.names];
    [array insertObject:name atIndex:0];
    [self updateArrayToFile:[array copy]];
}

-(void)deleteNameFor:(NSInteger)index {
    if (index < 0 || index > self.names.count)
    {
        return;
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.names];
    [array removeObjectAtIndex:index];
    [self updateArrayToFile:array];
}

-(void)updateArrayToFile:(NSArray *)array {
    [array writeToFile:[self filePath] atomically:YES];
    self.names = array;
}

@end
