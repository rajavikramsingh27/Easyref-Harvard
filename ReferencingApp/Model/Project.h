//
//  Project.h
//  EasyRef
//
//  Created by Radu Mihaiu on 30/09/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Reference;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * projectID;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSNumber * onlineProject;
@property (nonatomic, retain) NSSet *references;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addReferencesObject:(Reference *)value;
- (void)removeReferencesObject:(Reference *)value;
- (void)addReferences:(NSSet *)values;
- (void)removeReferences:(NSSet *)values;

@end
