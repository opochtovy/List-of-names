//
//  OPOTableVM.m
//  ListOfNames
//
//  Created by Aleh Pachtovy on 8/26/18.
//  Copyright © 2018 Aleh Pachtovy. All rights reserved.
//

#import "OPOTableVM.h"
#import "OPODataManager.h"

@interface OPOTableVM ()
{
    BOOL isSortingAscending;
}

@property (nonatomic) NSArray *listOfNames;

@end

@implementation OPOTableVM

#pragma mark - Custom Accessors

-(NSArray *)listOfNames {
    if (_listOfNames == nil)
    {
        _listOfNames = [[OPODataManager sharedManager] getListOfNames];
    }
    return _listOfNames;
}

#pragma mark - Public Methods

-(NSInteger)numberOfItems {
    return self.listOfNames.count;
}

-(NSString *)getItemNameFor:(NSInteger)index {
    NSString *name = [self.listOfNames objectAtIndex:index];
    return name;
}

-(void)saveAddedName:(NSString *)name {
    [[OPODataManager sharedManager] saveAddedName:name];
    isSortingAscending = NO;
    self.listOfNames = nil;
}

-(void)deleteItemFor:(NSInteger)index {
    [[OPODataManager sharedManager] deleteNameFor:index];
    self.listOfNames = nil;
}

-(void)changeListSorting {
    isSortingAscending = !isSortingAscending;
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:isSortingAscending selector:@selector(localizedStandardCompare:)];
    NSArray *descriptors = [NSArray arrayWithObjects:descriptor, nil];
    NSArray *sortedArray = [self.listOfNames sortedArrayUsingDescriptors:descriptors];
    [[OPODataManager sharedManager] updateArrayToFile:sortedArray];
    self.listOfNames = nil;
}

-(NSString *)getNameForSortButton {
    return isSortingAscending ? NSLocalizedString(@"table_vc_sort_descending", nil) : NSLocalizedString(@"table_vc_sort_ascending", nil);
}

@end
