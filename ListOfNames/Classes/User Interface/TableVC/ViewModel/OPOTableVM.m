//
//  OPOTableVM.m
//  ListOfNames
//
//  Created by Aleh Pachtovy on 8/26/18.
//  Copyright © 2018 Aleh Pachtovy. All rights reserved.
//

#import "OPOTableVM.h"
#import "OPODataManager.h"

@implementation OPOTableVM

-(NSArray *)getListOfNames
{
    NSArray *result = [[OPODataManager sharedManager] getListOfNames];
    return result;
}

-(void)saveAddedName:(NSString *)name {
    [[OPODataManager sharedManager] saveAddedName:name];
}

-(NSInteger)numberOfItems {
    return [self getListOfNames].count;
}

-(NSString *)getItemNameFor:(NSInteger)index
{
    NSString *name = [[self getListOfNames] objectAtIndex:index];
    return name;
}

-(void)deleteItemFor:(NSInteger)index {
    [[OPODataManager sharedManager] deleteNameFor:index];
}

@end
