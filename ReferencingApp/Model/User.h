//
//  User.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 21/09/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * emailVerified;
@property (nonatomic, retain) NSDate * lastSync;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic) bool loggedIn;


-(BOOL)isLoggedIn;


-(void)storeUser;
-(void)deleteUserData;
-(void)loadUserData;

@end
