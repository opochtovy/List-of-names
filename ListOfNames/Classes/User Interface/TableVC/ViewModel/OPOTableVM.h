//
//  OPOTableVM.h
//  ListOfNames
//
//  Created by Aleh Pachtovy on 8/26/18.
//  Copyright © 2018 Aleh Pachtovy. All rights reserved.
//

#import "OPOBaseVM.h"

@interface OPOTableVM : OPOBaseVM

-(NSArray *)getListOfNames;
-(void)saveAddedName:(NSString *)name;
-(NSInteger)numberOfItems;
-(NSString *)getItemNameFor:(NSInteger)index;
-(void)deleteItemFor:(NSInteger)index;

@end
