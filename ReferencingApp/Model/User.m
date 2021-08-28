//
//  User.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 21/09/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "User.h"

@implementation User


-(id)init
{
    self = [super init];
    if (self)
    {
        _loggedIn = false;
        [self loadUserData];
    }
    
    return self;
}

-(BOOL)isLoggedIn
{
    return (!self.userID == nil);
}


-(void)storeUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setObject:self.createdAt forKey:@"createdAt"];
    [defaults setObject:self.email forKey:@"email"];
    [defaults setObject:self.lastSync forKey:@"lastSync"];
    [defaults setObject:self.name forKey:@"name"];
    [defaults setObject:self.updatedAt forKey:@"updatedAt"];
    [defaults setObject:self.userID forKey:@"userID"];

    [defaults synchronize];
}

-(void)deleteUserData
{
    self.createdAt = nil;
    self.email = nil;
    self.lastSync = nil;
    self.userID = nil;
    self.name = nil;
    self.updatedAt = nil;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults removeObjectForKey:@"createdAt"];
    [defaults removeObjectForKey:@"email"];
    [defaults removeObjectForKey:@"lastSync"];
    [defaults removeObjectForKey:@"name"];
    [defaults removeObjectForKey:@"updatedAt"];
    [defaults removeObjectForKey:@"userID"];
    
    [defaults synchronize];
}

-(void)loadUserData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    self.createdAt = [defaults objectForKey:@"createdAt"];
    self.email = [defaults objectForKey:@"email"];
    self.lastSync = [defaults objectForKey:@"lastSync"];
    self.userID = [defaults objectForKey:@"userID"];
    self.name = [defaults objectForKey:@"name"];
    self.updatedAt = [defaults objectForKey:@"updatedAt"];

}

@end
