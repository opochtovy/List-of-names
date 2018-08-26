//
//  OPODataManager.h
//  ListOfNames
//
//  Created by Aleh Pachtovy on 8/26/18.
//  Copyright © 2018 Aleh Pachtovy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPODataManager : NSObject

+(OPODataManager *)sharedManager;

-(NSArray *)getListOfNames;
-(void)saveAddedName:(NSString *)name;
-(void)deleteNameFor:(NSInteger)index;

@end
