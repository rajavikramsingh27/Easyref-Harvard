//
//  Reference.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 21/09/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface Reference : NSManagedObject

@property (nonatomic, retain) NSString * data;
@property (nonatomic, retain) NSString * projectID;
@property (nonatomic, retain) NSString * referenceID;
@property (nonatomic, retain) NSString * referenceType;
@property (nonatomic, retain) NSDate * dateCreated;

-(NSMutableAttributedString *)getReferenceString;
-(NSString *)getShortReferenceString;
@end
