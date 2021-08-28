//
//  ReferencingApp.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 14/09/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "User.h"
#import "Project.h"
#import "Reference.h"
#import "IndexViewController.h"
#import "XMLReader.h"

@protocol ReferencingAppNetworkDelegate <NSObject , NSURLConnectionDataDelegate>

@optional

-(void)referenceSucessfullyDeleted;
-(void)referenceDeletionFailedWithError:(NSString *)errorString;

-(void)referenceSucessfullyEdited:(NSDictionary *)dictionary;
-(void)referenceEditingFailedWithErrror:(NSString *)errorString;

-(void)referenceSucessfullyCreated:(NSDictionary *)dictionary;
-(void)referenceCreationFailedWithEror:(NSString *)errorString;

-(void)projectScuessfullyEdited;
-(void)projectEditingFailedWithError:(NSString *)errorString;

-(void)projectSucessfullyDeleted;
-(void)projectDeletionFailedWithError:(NSString *)errorString;

-(void)projectSucessfullyCreatedWithData:(NSDictionary *)dictionary;
-(void)projectCreationFailedWithError:(NSString *)errorString;

-(void)accountSucessfullyCreatedWithData:(NSDictionary *)dictionary;
-(void)accountCreationFailedWithError:(NSString *)errorString;

-(void)loginSucessfullWithData:(NSDictionary *)dictionary;
-(void)loginFailedWithError:(NSString *)errorString;

-(void)switchSuccessfull;
-(void)switchFailedWithError:(NSString *)errorString;

-(void)searchBooksSucessfullWithData:(NSArray *)array;
-(void)searchBooksFailedWithError:(NSString *)errorString;

-(void)getBookSucessfullWithData:(NSString *)dataString;


-(void)userSyncComplete;
-(void)userSyncFailedWithError:(NSString *)errorString;

@end

@interface ReferencingApp : NSObject
{
    NSURLConnection *searchConnection;
    NSURLConnection *getConnection;
    NSMutableData *dataBuffer;
}
+(ReferencingApp *)sharedInstance;
+(void)start;

@property (nonatomic) NSUInteger projectsLeftToSync;
@property (nonatomic) bool isOffline;
@property  id<ReferencingAppNetworkDelegate > delegate;
@property (nonatomic,retain) User *user;
@property (nonatomic,retain) NSArray *typeData;
@property (nonatomic,retain) NSArray *referenceTypeArray;

@property (nonatomic,retain) NSMutableArray *onlineProjectsArray;
@property (nonatomic,retain) NSMutableArray *linkedScanRefArray;


-(void)saveDatabase;
// Database Requests
-(NSArray *)getDataBaseWithName:(NSString *)name;

// Network Requests
-(void)createReferenceWithData:(NSString *)dataString referenceType:(NSString *)refType andProjectID:(NSString *)projectID;
-(void)editProjectWithID:(NSString *)projectID andNewName:(NSString *)projectName;
-(void)deleteProjectWithID:(NSString *)projectID;
-(void)getUserData;
-(void)getUserForID:(int)userID;
-(void)createUserWithName:(NSString *)name Password:(NSString *)password Email:(NSString *)email;
-(void)createProjectWithName:(NSString *)projectName;
-(void)loginUserWithEmail:(NSString *)email andPassword:(NSString *)password;
-(void)editReferenceWithData:(NSString *)dataString referenceType:(NSString *)refType projectID:(NSString *)projectID andReferenceID:(NSString *)referenceID;
-(void)deleteReferenceWithID:(NSString *)referenceID;
-(void)switchReferenceWithID:(NSString *)referenceID andType:(NSString *)referenceType toProject:(NSString *)newProjectID;
-(void)searchBooksWithISBN:(NSString *)ISBN;
-(void)getBookWithIdentifier:(NSString *)identifier;
-(void)refreshUserAfterDelay;
@end
