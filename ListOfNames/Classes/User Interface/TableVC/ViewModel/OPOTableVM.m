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
//    NSArray *sortedArray = [self sortUsingDescriptor];
    NSArray *sortedArray = [self sortUsingFunction];
    [[OPODataManager sharedManager] updateArrayToFile:sortedArray];
    self.listOfNames = nil;
}

-(NSString *)getNameForSortButton {
    return isSortingAscending ? NSLocalizedString(@"table_vc_sort_descending", nil) : NSLocalizedString(@"table_vc_sort_ascending", nil);
}

#pragma mark - Private Methods

-(NSArray *)sortUsingDescriptor {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:isSortingAscending selector:@selector(localizedStandardCompare:)];
    NSArray *descriptors = [NSArray arrayWithObjects:descriptor, nil];
    return [self.listOfNames sortedArrayUsingDescriptors:descriptors];
}

-(NSArray *)sortUsingFunction {
    BOOL reverseSort = !isSortingAscending;
    return [self.listOfNames sortedArrayUsingFunction:nameSort context:&reverseSort];
}

NSInteger nameSort(NSString *name1, NSString *name2, void *reverse)
{
    NSComparisonResult comparison = [name1 localizedStandardCompare:name2];
    
    if (*(BOOL *)reverse == YES) {
        return 0 - comparison;
    }
    return comparison;
}

@end
