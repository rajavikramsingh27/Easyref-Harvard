//
//  ReferencingApp.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 14/09/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "ReferencingApp.h"
#import "AFNetworking/AFNetworking.h"

#define kAPIBaseURLString @"http://reference-app.herokuapp.com/"
#define kWorldCatAPIKey @"lRrBaDb27qnHagjExrzG9FxHKbqGxyZeUm5YorgTjZbggyKLhDCVnMzEXf1rXfGuf6Z2BLnOUW0rBwtK"


static ReferencingApp *sharedInstance;


@implementation ReferencingApp


+(void)start
{
    
    ReferencingApp *newRefApp = [[ReferencingApp alloc] init];
    newRefApp.isOffline = FALSE;
    [newRefApp initialize];
    sharedInstance = newRefApp;
}


+(ReferencingApp *)sharedInstance
{
    return sharedInstance;
}

-(void) initialize
{
    self.user = [[User alloc] init];
    _onlineProjectsArray = [[NSMutableArray alloc] init];
    _linkedScanRefArray = [[NSMutableArray alloc] init];
    _projectsLeftToSync = 0;
    
    
    
    
    _typeData = @[
                 @{@"name":@"Annual Report",@"fields":@[@"Corporate Author",@"Year",@"Title",@"Place of Publication",@"Publisher"]},
                 @{@"name":@"Audio CD",@"fields":@[@"Artist",@"Year",@"Title",@"Place of Distribution",@"Distribution Company"]},
                 @{@"name": @"Mobile App",@"fields":@[@"Development Company",@"Year",@"App Title",@"Version Number",@"URL",@"Accessed Date"]},
                 @{@"name":@"Film",@"fields":@[@"Title",@"Year",@"Type of medium",@"Director",@"Country of origin",@"Film studio"]},
                 @{@"name":@"Email",@"fields":@[@"Sender's Surname",@"Sender's Initial",@"Year",@"Subject",@"Recipient",@"Accessed Date"]},
                 @{@"name":@"PDF",@"fields":@[@"Authorship",@"Year",@"Title",@"Place of Publication",@"Publisher",@"URL",@"Accessed Date"]},
                 
  
                 @{@"name":@"Encyclopedia",@"fields":@[@"Author Double Field",@"Year",@"Entry Title",@"Encyclopedia Title",@"Edition",@"Volume",@"Place of Publication",@"Publisher",@"Pages"],@"hasOnline":@TRUE},
                 
                 @{@"name":@"Encyclopedia Online",@"fields":@[@"Author Double Field",@"Year",@"Entry Title",@"Encyclopedia Title",@"Edition",@"Volume",@"Place of Publication",@"Publisher",@"URL",@"Accessed Date"]},
                 
                 
                 @{@"name":@"Podcast",@"fields":@[@"Author Double Field",@"Year",@"Episode Title",@"Podcast Title",@"Date of Post",@"URL",@"Accessed Date"]},
                 @{@"name":@"Map",@"fields":@[@"Author Double Field",@"Year",@"Scale",@"Title",@"Place of Publication",@"Publisher"]},
                 @{@"name":@"Newspaper",@"fields":@[@"Author Double Field",@"Year Published",@"Date/Month",@"Article Title",@"Newspaper",@"Page used"],@"hasOnline":@TRUE},
                 
                 @{@"name":@"Newspaper Online",@"fields":@[@"Author Double Field",@"Year Published",@"Date/Month",@"Article Title",@"Newspaper",@"Accessed Date",@"URL"]},
                 
                 @{@"name":@"Website",@"fields":@[@"Name of Website/Author",@"Year",@"Title",@"URL",@"Last Accessed"]},
                 @{@"name":@"Image",@"fields":@[@"Originator/Artist",@"Year of Distribution",@"Title of Image",@"Date of Image",@"Image URL",@"Accessed Date"]},
                 @{@"name":@"Dissertation",@"fields":@[@"Author Double Field",@"Year",@"Title",@"Level",@"Place of University",@"Name of University"],@"hasOnline":@TRUE},
                 
                 @{@"name":@"Dissertation Online",@"fields":@[@"Author Double Field",@"Year",@"Title",@"Level",@"Place of University",@"Name of University",@"Accessed Date",@"URL"]},
                 
                 
                 @{@"name":@"Blog",@"fields":@[@"Author Double Field",@"Year",@"Title of blog entry",@"Blog Title",@"Date of Post",@"URL",@"Accessed Date"]},
                 @{@"name":@"Video",@"fields":@[@"Originator/Artist",@"Year of Distribution",@"Title of Video",@"Date of Video",@"Video URL",@"Accessed Date"]},
                 @{@"name":@"Book",@"fields":@[@"Author Double Field",@"Year",@"Edition",@"Title",@"Place of Publication",@"Publisher"],@"hasOnline":@TRUE},
                 @{@"name":@"Book No Author",@"fields":@[@"Title",@"Year",@"Edition",@"Place of Publication",@"Publisher"],@"hasOnline":@TRUE},
                 @{@"name":@"Book Online",@"fields":@[@"Author Double Field",@"Year",@"Title",@"Place of Publication",@"Publisher",@"Accessed Date",@"URL"]},
                 @{@"name":@"Interview",@"fields":@[@"Interviewee's Surname",@"Interviewee's Initials",@"Year",@"Interview Title",@"Interviewer",@"Date of Transmission",@"Type of Interview"]},
                 @{@"name":@"Journal Online",@"fields":@[@"Author Double Field",@"Year",@"Article Title",@"Journal Title",@"Volume",@"Pages Used",@"Issue",@"Website",@"Accessed Date"]},
                 @{@"name":@"Journal",@"fields":@[@"Author Double Field",@"Year",@"Article Title",@"Journal Title",@"Volume",@"Pages Used",@"Issue"],@"hasOnline":@TRUE},
                 
                 @{@"name":@"Powerpoint",@"fields":@[@"Author Double Field",@"Year",@"Title",@"URL",@"Accessed Date"]},
                 @{@"name":@"Gov Document",@"fields":@[@"Authorship",@"Year",@"Title",@"Place of Publication",@"Publisher"]},
                 @{@"name":@"Kindle",@"fields":@[@"Author Double Field",@"Year",@"Title",@"URL",@"Accessed Date"]},
                 ];
    
    _referenceTypeArray = @[
                          @{ @"colorValue":@0x609eab , @"imgValue":[UIImage imageNamed:@"annual-report"], @"name": @"Annual Report" },
                          @{ @"colorValue":@0x7ab7c5 , @"imgValue":[UIImage imageNamed:@"audio-cd"], @"name": @"Audio CD" },
                          @{ @"colorValue":@0x86cbda , @"imgValue":[UIImage imageNamed:@"blog"], @"name": @"Blog" },
                          @{ @"colorValue":@0x377c86 , @"imgValue":[UIImage imageNamed:@"book"], @"name": @"Book" },
                          @{ @"colorValue":@0x377c86 , @"imgValue":[UIImage imageNamed:@"book"], @"name": @"Book Online" },
                          @{ @"colorValue":@0x377c86 , @"imgValue":[UIImage imageNamed:@"book"], @"name": @"Book No Author" },
                          @{ @"colorValue":@0x5196a0 , @"imgValue":[UIImage imageNamed:@"dissertation"], @"name": @"Dissertation" },
                          @{ @"colorValue":@0x5196a0 , @"imgValue":[UIImage imageNamed:@"dissertation"], @"name": @"Dissertation Online" },
                          @{ @"colorValue":@0x58a5b1 , @"imgValue":[UIImage imageNamed:@"email"], @"name": @"Email" },
                          @{ @"colorValue":@0x619b52 , @"imgValue":[UIImage imageNamed:@"encyclopedia"], @"name": @"Encyclopedia" },
                          @{ @"colorValue":@0x619b52 , @"imgValue":[UIImage imageNamed:@"encyclopedia"], @"name": @"Encyclopedia Online" },
                          @{ @"colorValue":@0x7ab56c , @"imgValue":[UIImage imageNamed:@"film"], @"name": @"Film" },
                          @{ @"colorValue":@0x87c876 , @"imgValue":[UIImage imageNamed:@"gov-document"], @"name": @"Gov Document" },
                          @{ @"colorValue":@0x9eab39 , @"imgValue":[UIImage imageNamed:@"image"], @"name": @"Image" },
                          @{ @"colorValue":@0xb7c552 , @"imgValue":[UIImage imageNamed:@"interview"], @"name": @"Interview" },
                          @{ @"colorValue":@0xcbda5a , @"imgValue":[UIImage imageNamed:@"journal"], @"name": @"Journal" },
                          @{ @"colorValue":@0xcbda5a , @"imgValue":[UIImage imageNamed:@"journal"], @"name": @"Journal Online" },
                          @{ @"colorValue":@0xc4ab31 , @"imgValue":[UIImage imageNamed:@"kindle"], @"name": @"Kindle" },
                          @{ @"colorValue":@0xdec54a , @"imgValue":[UIImage imageNamed:@"map"], @"name": @"Map" },
                          @{ @"colorValue":@0xf6da51 , @"imgValue":[UIImage imageNamed:@"mobile-app"], @"name": @"Mobile App" },
                          @{ @"colorValue":@0xc27029 , @"imgValue":[UIImage imageNamed:@"newspaper"], @"name": @"Newspaper" },
                          @{ @"colorValue":@0xc27029 , @"imgValue":[UIImage imageNamed:@"newspaper"], @"name": @"Newspaper Online" },
                          @{ @"colorValue":@0xdb8a42 , @"imgValue":[UIImage imageNamed:@"pdf"], @"name": @"PDF" },
                          @{ @"colorValue":@0xf39848 , @"imgValue":[UIImage imageNamed:@"podcast"], @"name": @"Podcast" },
                          @{ @"colorValue":@0x994e85 , @"imgValue":[UIImage imageNamed:@"powerpoint"], @"name": @"Powerpoint" },
                          @{ @"colorValue":@0xb2689e , @"imgValue":[UIImage imageNamed:@"video"], @"name": @"Video" },
                          @{ @"colorValue":@0xc672af , @"imgValue":[UIImage imageNamed:@"website"], @"name": @"Website" },
                          ];

    

    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstRun"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"isFirstRun"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;

        
        Project *newProject = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
        newProject.onlineProject = [NSNumber numberWithBool:FALSE];
        newProject.name = @"Uncategorized";
        newProject.projectID = @"1";
        
        [self saveDatabase];
        
    }
}



-(void)saveDatabase
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
}

#pragma mark DATABASE METHODS

-(NSArray *)getDataBaseWithName:(NSString *)name
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //2
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    fetchRequest.sortDescriptors = @[sort];

    NSEntityDescription *entity = [NSEntityDescription entityForName:name
                                              inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    NSArray *fetchedRecords = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"%@",fetchedRecords);
    
    return fetchedRecords;
}

#pragma  mark NETWORK METHODS

-(void)refreshUserAfterDelay {
  int64_t delayInSeconds = 1.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [[ReferencingApp sharedInstance] getUserData];
  });
}


-(void)getUserForID:(int)userID
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%i",kAPIBaseURLString,@"users/show/",userID]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
   
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
         if (connectionError == nil)
         {
             NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];

             NSData *newData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
             
             NSError *error = nil;
             NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:newData options:0 error:&error];
             
             if ([[parsedObject objectForKey:@"errorCode"] intValue] == 0)
             {
                 
             }
             
             
             NSLog(@"%@",parsedObject);
             
             
         }
     }];
}


-(void)loginUserWithEmail:(NSString *)email andPassword:(NSString *)password
{
    NSString *parameterString = [NSString stringWithFormat:@"users/login/?email=%@&password=%@",email,password];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIBaseURLString,parameterString]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
         if (connectionError == nil)
         {
             NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];

             NSData *newData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
             NSError *error = nil;
             NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:newData options:0 error:&error];
             NSLog(@"%@",parsedObject);
             
             int errorCode = [[parsedObject objectForKey:@"errorCode"] intValue];
             
             if (errorCode == 0) // Sucess
             {
                 if( [_delegate respondsToSelector:@selector(accountSucessfullyCreatedWithData:)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         
                         //Your code goes in here
                         [_delegate loginSucessfullWithData:[parsedObject objectForKey:@"data"]];
                         
                     }];
                     
                     
                 }
                 
             }
             else
             {
                 if( [_delegate respondsToSelector:@selector(accountCreationFailedWithError:)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate loginFailedWithError:[parsedObject objectForKey:@"errorMessages"]];
                     }];
                 }
             }

             
         }
         else
         {
             if( [_delegate respondsToSelector:@selector(loginFailedWithError:)])
             {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                     [_delegate loginFailedWithError:@"Connection error"];
                 }];
             }

         }
         
     }];
    

}



-(void)createUserWithName:(NSString *)name Password:(NSString *)password Email:(NSString *)email
{
    
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    NSString *parameterString = [NSString stringWithFormat:@"users/new/?name=%@&password=%@&email=%@",name,password,email];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIBaseURLString,parameterString]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
         if (connectionError == nil)
         {
             NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
             NSData *newData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
             NSError *error = nil;
             NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:newData options:0 error:&error];
             NSLog(@"%@",parsedObject);
             
             int errorCode = [[parsedObject objectForKey:@"errorCode"] intValue];
             
             if (errorCode == 0) // Sucess
             {
                if( [_delegate respondsToSelector:@selector(accountSucessfullyCreatedWithData:)])
                {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                        [_delegate accountSucessfullyCreatedWithData:[parsedObject objectForKey:@"data"]];
                    }];

                  
                }
                 
             }
             else
             {
                 if( [_delegate respondsToSelector:@selector(accountCreationFailedWithError:)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate accountCreationFailedWithError:[parsedObject objectForKey:@"errorMessages"]];
                     }];
                 }
             }
             
         }
         else
         {
             if( [_delegate respondsToSelector:@selector(accountCreationFailedWithError:)])
             {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                     [_delegate accountCreationFailedWithError:@"Connection error"];
                 }];
             }
             
         }

     }];

}


-(void)editProjectWithID:(NSString *)projectID andNewName:(NSString *)projectName
{
    projectName = [projectName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    NSString *parameterString = [NSString stringWithFormat:@"projects/edit/%@?name=%@",projectID,projectName];
    
    NSLog(@"%@",parameterString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIBaseURLString,parameterString]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
         if (connectionError == nil)
         {
             NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
             NSData *newData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
             NSError *error = nil;
             NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:newData options:0 error:&error];
             NSLog(@"%@",parsedObject);
             
             
             int errorCode = [[parsedObject objectForKey:@"errorCode"] intValue];
             
             if (errorCode == 0) // Sucess
             {
                 if( [_delegate respondsToSelector:@selector(projectScuessfullyEdited)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate projectScuessfullyEdited];
                     }];
                 }
             }
             else
             {
                 if( [_delegate respondsToSelector:@selector(projectEditingFailedWithError:)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate projectEditingFailedWithError:[parsedObject objectForKey:@"errorMessages"]];
                     }];
                 }
             }
             
         }
         else
         {
             if( [_delegate respondsToSelector:@selector(projectEditingFailedWithError:)])
             {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                     [_delegate projectEditingFailedWithError:@"Connection error"];
                 }];
             }
             
         }

         
         
     }];

}

-(void)deleteProjectWithID:(NSString *)projectID
{
    
    NSString *parameterString = [NSString stringWithFormat:@"projects/delete/%@",projectID];
    
    NSLog(@"%@",parameterString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIBaseURLString,parameterString]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
         if (connectionError == nil)
         {
             NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
             NSData *newData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
             NSError *error = nil;
             NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:newData options:0 error:&error];
             NSLog(@"%@",parsedObject);
             
             
             int errorCode = [[parsedObject objectForKey:@"errorCode"] intValue];
             
             if (errorCode == 0) // Sucess
             {
                 if( [_delegate respondsToSelector:@selector(projectSucessfullyDeleted)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate projectSucessfullyDeleted];
                     }];
                 }
             }
             else
             {
                 if( [_delegate respondsToSelector:@selector(projectDeletionFailedWithError:)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate projectDeletionFailedWithError:[parsedObject objectForKey:@"errorMessages"]];
                     }];
                 }
             }
             
         }
         else
         {
             if( [_delegate respondsToSelector:@selector(projectDeletionFailedWithError:)])
             {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                     [_delegate projectDeletionFailedWithError:@"Connection error"];
                 }];
             }
             
         }

         
     }];
    
}

-(void)createProjectWithName:(NSString *)projectName
{
    
    projectName = [projectName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    NSString *parameterString = [NSString stringWithFormat:@"projects/new/?name=%@&user_id=%@",projectName,_user.userID];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIBaseURLString,parameterString]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
         if (connectionError == nil)
         {
             NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
             NSData *newData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
             NSError *error = nil;
             NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:newData options:0 error:&error];
             NSLog(@"%@",parsedObject);
             
             
             int errorCode = [[parsedObject objectForKey:@"errorCode"] intValue];
             
             if (errorCode == 0) // Sucess
             {
                 if( [_delegate respondsToSelector:@selector(projectSucessfullyCreatedWithData:)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate projectSucessfullyCreatedWithData:[parsedObject objectForKey:@"data"]];
                     }];
                 }
             }
             else
             {
                 if( [_delegate respondsToSelector:@selector(projectCreationFailedWithError:)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate projectCreationFailedWithError:[parsedObject objectForKey:@"errorMessages"]];
                     }];
                 }
             }
             
         }
         else
         {
             if( [_delegate respondsToSelector:@selector(projectCreationFailedWithError:)])
             {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                     [_delegate projectCreationFailedWithError:@"Connection error"];
                 }];
             }
             
         }
         
     }];

}

-(void)deleteReferenceWithID:(NSString *)referenceID
{
    NSString *parameterString = [NSString stringWithFormat:@"references/delete/%@",referenceID];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIBaseURLString,parameterString]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
         if (connectionError == nil)
         {
             NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];

             NSData *newData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
             NSError *error = nil;
             NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:newData options:0 error:&error];
             NSLog(@"%@",parsedObject);
             
             int errorCode = [[parsedObject objectForKey:@"errorCode"] intValue];
             
             if (errorCode == 0) // Sucess
             {
                 if( [_delegate respondsToSelector:@selector(referenceSucessfullyDeleted)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate referenceSucessfullyDeleted];
                     }];
                     
                     
                 }
                 
             }
             else
             {
                 if( [_delegate respondsToSelector:@selector(referenceDeletionFailedWithError:)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate referenceDeletionFailedWithError:[parsedObject objectForKey:@"errorMessages"]];
                     }];
                 }
             }
         }
         else
         {
             if( [_delegate respondsToSelector:@selector(referenceDeletionFailedWithError:)])
             {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                     [_delegate referenceDeletionFailedWithError:@"Connection error"];
                 }];
             }
             
         }

     }];

    

}



-(void)switchReferenceWithID:(NSString *)referenceID andType:(NSString *)referenceType toProject:(NSString *)newProjectID
{
    NSError * error = nil;
    NSString *parameterString = [NSString stringWithFormat:@"references/edit/?id=%@&project_id=%@",referenceID,newProjectID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIBaseURLString,parameterString]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:@{
                                                                   @"project_id":referenceType,
                                                                   } options:(NSJSONWritingOptions)0 error:&error]];

    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
         if (connectionError == nil)
         {
             NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
             NSData *newData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
             NSError *error = nil;
             NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:newData options:0 error:&error];
             NSLog(@"%@",parsedObject);
             
             
             int errorCode = [[parsedObject objectForKey:@"errorCode"] intValue];
             
             if (errorCode == 0) // Sucess
             {
                 if( [_delegate respondsToSelector:@selector(switchSuccessfull)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate switchSuccessfull];
                     }];
                 }
             }
             else
             {
                 if( [_delegate respondsToSelector:@selector(switchFailedWithError:)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate switchFailedWithError:[parsedObject objectForKey:@"errorMessages"]];
                     }];
                 }
             }
             
         }
         else
         {
             if( [_delegate respondsToSelector:@selector(switchFailedWithError:)])
             {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                     [_delegate switchFailedWithError:@"Connection error"];
                 }];
             }
             
         }

         
         
     }];

    

}

-(void)editReferenceWithData:(NSString *)dataString referenceType:(NSString *)refType projectID:(NSString *)projectID andReferenceID:(NSString *)referenceID
{
    NSError * error = nil;
    NSString *parameterString = [NSString stringWithFormat:@"references/edit/%@",referenceID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIBaseURLString,parameterString]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:@{
                                                                   @"data":dataString,
                                                                   @"project_id":projectID,
                                                                   @"reference_type":refType,
                                                                   } options:(NSJSONWritingOptions)0 error:&error]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
         if (connectionError == nil)
         {
             NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
             NSData *newData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
             NSError *error = nil;
             NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:newData options:0 error:&error];
             NSLog(@"%@",parsedObject);
             
             
             int errorCode = [[parsedObject objectForKey:@"errorCode"] intValue];
             
             if (errorCode == 0) // Sucess
             {
                 if( [_delegate respondsToSelector:@selector(referenceSucessfullyEdited:)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate referenceSucessfullyEdited:[parsedObject objectForKey:@"data"]];
                     }];
                 }
             }
             else
             {
                 if( [_delegate respondsToSelector:@selector(referenceEditingFailedWithErrror:)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate referenceEditingFailedWithErrror:[parsedObject objectForKey:@"errorMessages"]];
                     }];
                 }
             }
             
         }
         else
         {
             if( [_delegate respondsToSelector:@selector(referenceEditingFailedWithErrror:)])
             {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                     [_delegate referenceEditingFailedWithErrror:@"Connection error"];
                 }];
             }
             
         }

         
         
     }];

}


-(void)createReferenceWithData:(NSString *)dataString referenceType:(NSString *)refType andProjectID:(NSString *)projectID
{
    

    NSError * error = nil;
    NSString *parameterString = [NSString stringWithFormat:@"references/create/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIBaseURLString,parameterString]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Content-Type"];

    
    NSLog(@"%@",projectID);
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:@{
                                                                   @"data":dataString,
                                                                   @"project_id":projectID,
                                                                   @"reference_type":refType,
                                                                   } options:(NSJSONWritingOptions)0 error:&error]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
         if (connectionError == nil)
         {
             NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
             NSData *newData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
             NSError *error = nil;
             NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:newData options:0 error:&error];
             NSLog(@"%@",parsedObject);
             
             
             int errorCode = [[parsedObject objectForKey:@"errorCode"] intValue];
             
             if (errorCode == 0 && parsedObject != nil) // Sucess
             {
                 if( [_delegate respondsToSelector:@selector(referenceSucessfullyCreated:)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate referenceSucessfullyCreated:[parsedObject objectForKey:@"data"]];
                     }];
                 }
             }
             else if (parsedObject != nil) {
                 if( [_delegate respondsToSelector:@selector(referenceCreationFailedWithEror:)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate referenceCreationFailedWithEror:[parsedObject objectForKey:@"errorMessages"]];
                     }];
                 }
             }
             else {
                 if( [_delegate respondsToSelector:@selector(referenceCreationFailedWithEror:)])
                 {
                     [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                         [_delegate referenceCreationFailedWithEror:@"Unknown error"];
                     }];
                 }
             }
             
         }
         else
         {
             if( [_delegate respondsToSelector:@selector(referenceCreationFailedWithEror:)])
             {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                     [_delegate referenceCreationFailedWithEror:@"Connection error"];
                 }];
             }
             
         }

         
         
     }];
    
}


-(void)getReferencesForProjectID:(NSString *)projectID andProjectToAdd:(Project *)projectToAdd
{
    NSString *parameterString = [NSString stringWithFormat:@"references/?project_id=%@",projectID];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIBaseURLString,parameterString]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
         if (connectionError == nil)
         {
             NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];

             NSData *newData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
             NSError *error = nil;
             NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:newData options:0 error:&error];
             NSLog(@"%@",parsedObject);
             
             
             int errorCode = [[parsedObject objectForKey:@"errorCode"] intValue];
             
             if (errorCode == 0) // Sucess
             {
                 NSArray *refArray = [parsedObject objectForKey:@"data"];
                 
                 for (NSDictionary *refDict in refArray)
                 {
                     AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                     NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
                     
                     
                     NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reference" inManagedObjectContext:managedObjectContext];
                     Reference *newRef = [[Reference alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
                     
                     newRef.projectID = [[refDict objectForKey:@"project_id"] stringValue];
                     newRef.referenceType = [refDict objectForKey:@"reference_type"];
                     newRef.data = [refDict objectForKey:@"data"];
                     newRef.referenceID = [[refDict objectForKey:@"id"] stringValue];
                     
                     NSString *dateString = [refDict objectForKey:@"created_at"];
                     dateString = [dateString substringToIndex:[dateString length]-5];
                     
                     NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                     [dateFormat setDateFormat:@"yyyy-M-d'T'H:m:s"];
                     
                     newRef.dateCreated = [dateFormat dateFromString:dateString];

                     [projectToAdd addReferencesObject:newRef];
                 }
                 
                 _projectsLeftToSync --;
                 
                 if (_projectsLeftToSync == 0)
                 {
                     if( [_delegate respondsToSelector:@selector(userSyncComplete)])
                     {
                         [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                             [_delegate userSyncComplete];
                         }];
                     }
                 }
            }
           else if ([_delegate respondsToSelector:@selector(loginFailedWithError:)]) {
             [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
               [_delegate loginFailedWithError:@"Connection error"];
             }];
           }
         }
         else if ( [_delegate respondsToSelector:@selector(loginFailedWithError:)]) {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                     [_delegate loginFailedWithError:@"Connection error"];
                 }];
         }
     }];

    
}


-(void)getUserData
{
    NSString *parameterString = [NSString stringWithFormat:@"users/projects/%@",_user.userID];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIBaseURLString,parameterString]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
         if (connectionError == nil)
         {
             NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
             dataString = [dataString stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];

             NSData *newData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
             NSError *error = nil;
             NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:newData options:0 error:&error];
             NSLog(@"%@",parsedObject);

             
             int errorCode = [[parsedObject objectForKey:@"errorCode"] intValue];
             
             if (errorCode == 0) // Sucess
             {
                 
                 _onlineProjectsArray = [[NSMutableArray alloc] init];
                 
                 NSArray *projectsArray = [parsedObject objectForKey:@"data"];
                 AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                 NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;

                 _projectsLeftToSync = [projectsArray count];
                 
                 for (NSDictionary *projectDict in projectsArray)
                 {
                     NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:managedObjectContext];
                     Project *newProject = [[Project alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];

                     newProject.onlineProject = [NSNumber numberWithBool:TRUE];
                     newProject.name = [projectDict objectForKey:@"name"];
                     newProject.projectID = [[projectDict objectForKey:@"id"] stringValue];
                     
                     
                     [self getReferencesForProjectID:newProject.projectID andProjectToAdd:newProject];
                     
            
                     [_onlineProjectsArray addObject:newProject];
                    
                     
                 }
             }
             else if( [_delegate respondsToSelector:@selector(loginFailedWithError:)])
             {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                  [_delegate loginFailedWithError:@"Connection error"];
                }];
             }

         }
         else
         {
             if( [_delegate respondsToSelector:@selector(loginFailedWithError:)])
             {
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                     [_delegate loginFailedWithError:@"Connection error"];
                 }];
             }
             
         }

     }];
}

#pragma mark WORDCAT METHODS


- (void) searchBooksWithISBN:(NSString *)reqString {
    
    
    reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.worldcat.org/webservices/catalog/search/worldcat/opensearch?q=%@&wskey=%@",reqString,kWorldCatAPIKey]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    dataBuffer = nil;
    searchConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)getBookWithIdentifier:(NSString *)identifier
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.worldcat.org/webservices/catalog/content/%@?wskey=%@",identifier,kWorldCatAPIKey]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    dataBuffer = nil;
    getConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"RESPONSE %@",response);
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    
    if (code != 200)
    {
        if( [_delegate respondsToSelector:@selector(searchBooksFailedWithError:)])
        {
            [_delegate searchBooksFailedWithError:@"Could not get book information"];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSError *error;
    NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:data options:XMLReaderOptionsProcessNamespaces error:&error];
    
    
    if (xmlDictionary != nil)
    {
        if (connection == searchConnection)
            [self parseSearchResponseWithDictionary:xmlDictionary];
        else
            [self parseGetResponseWithDictionary:xmlDictionary];
    }
    else
    {
        if (dataBuffer == nil)
        {
            dataBuffer = [NSMutableData data];
            [dataBuffer appendData:data];
        }
        else
        {
            [dataBuffer appendData:data];
            
            NSString *dataString = [[NSString alloc] initWithData:dataBuffer encoding:NSUTF8StringEncoding];
            NSLog(@"!->%@",dataString);
            
            
            NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:dataBuffer options:XMLReaderOptionsProcessNamespaces error:&error];
            
            if (xmlDictionary != nil)
            {
                if (connection == searchConnection)
                    [self parseSearchResponseWithDictionary:xmlDictionary];
                else
                    [self parseGetResponseWithDictionary:xmlDictionary];
                
                return;
            }
            
            
            //            dataBuffer = nil;
            //
            //            if( [_delegate respondsToSelector:@selector(searchBooksFailedWithError:)])
            //            {
            //                [_delegate searchBooksFailedWithError:@"Could not get book information"];
            //            }
        }
    }
}

-(void)parseGetResponseWithDictionary:(NSDictionary *)xmlDictionary
{
    @try{
        
        xmlDictionary = [xmlDictionary objectForKey:@"record"];
        NSDictionary *typeDictionary;
        NSMutableDictionary *refDataDictionary = [[NSMutableDictionary alloc] init];
        NSMutableArray *authorArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in _typeData)
        {
            if ([[dict objectForKey:@"name"] isEqualToString:@"Book"])
            {
                typeDictionary = dict;
                
                for (NSString *fields in [dict objectForKey:@"fields"])
                {
                    if ([fields isEqualToString:@"Accessed Date"])
                    {
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        formatter.dateStyle = NSDateFormatterLongStyle;
                        formatter.timeStyle = NSDateFormatterNoStyle;
        
                        NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
                        [refDataDictionary setObject:stringFromDate forKey:fields];
                    }
                    else
                        [refDataDictionary setObject:@"" forKey:fields];
                }
            }
        }
        
        NSArray *dataFields = [xmlDictionary objectForKey:@"datafield"];
        
        for (NSDictionary  *dataDict in dataFields)
        {
            if([self authorshipTagFound:[[dataDict objectForKey:@"tag"] intValue]])
            {
                NSArray *subfields;
                if ([[dataDict objectForKey:@"subfield"] isKindOfClass:[NSDictionary class]]){
                    subfields = @[[dataDict objectForKey:@"subfield"]];
                }
                else{
                    subfields = [dataDict objectForKey:@"subfield"];
                }
                
                for (NSDictionary  *subfieldDict in subfields){
                    
                    if ([[subfieldDict objectForKey:@"code"] isEqualToString:@"a"]){
                        
                        NSString *processedString = [self removeCharacters:@[@",",@"."] FromString:[subfieldDict objectForKey:@"text"]];
        
                        NSArray *nameArray = [processedString componentsSeparatedByString:@" "];
                        NSString *initialsString = @"";
                  
                        for (int i = 1; i < [nameArray count]; i ++)
                        {
                            if (i > 1)
                                initialsString = [initialsString stringByAppendingString:@" "];
                            
                            initialsString = [initialsString stringByAppendingString:[[nameArray objectAtIndex:i] substringToIndex:1]];
                        }
                        [authorArray addObject:@{@"Surname":[nameArray objectAtIndex:0],@"Initials":initialsString}];
                    }
                }
            }
            
            if([self citationTagFound:[[dataDict objectForKey:@"tag"] intValue]])   {
                NSArray *subfields;
                if ([[dataDict objectForKey:@"subfield"] isKindOfClass:[NSDictionary class]]){
                    subfields = @[[dataDict objectForKey:@"subfield"]];
                }
                else{
                    subfields = [dataDict objectForKey:@"subfield"];
                }
                
                for (NSDictionary  *subfieldDict in subfields){
                    
                    if ([[subfieldDict objectForKey:@"code"] isEqualToString:@"a"]){
                        [refDataDictionary setObject:[self removeCharacters:@[@" :"] FromString:[subfieldDict objectForKey:@"text"]] forKey:@"Place of Publication"];
                    }
                
                    if ([[subfieldDict objectForKey:@"code"] isEqualToString:@"b"]){
                        [refDataDictionary setObject:[self removeCharacters:@[@","] FromString:[subfieldDict objectForKey:@"text"]] forKey:@"Publisher"];
                    }
                    
                    if ([[subfieldDict objectForKey:@"code"] isEqualToString:@"c"]){
                        [refDataDictionary setObject:[self removeCharacters:@[@".",@"c",@"©"] FromString:[subfieldDict objectForKey:@"text"]] forKey:@"Year"];
                    }
                }
            }
            
            if([self titleTagFound:[[dataDict objectForKey:@"tag"] intValue]])
            {
                NSArray *subfields;
                
                if ([[dataDict objectForKey:@"subfield"] isKindOfClass:[NSDictionary class]])
                {
                    subfields = @[[dataDict objectForKey:@"subfield"]];
                }
                else
                {
                    subfields = [dataDict objectForKey:@"subfield"];
                }
                
                for (NSDictionary  *subfieldDict in subfields){
                    
                    if ([[subfieldDict objectForKey:@"code"] isEqualToString:@"a"]){
                        
                        [refDataDictionary setObject:[self removeCharacters:@[@" :"] FromString:[subfieldDict objectForKey:@"text"]] forKey:@"Title"];
                    }
                }
            }
        }
        
        if ([authorArray count] == 0) {
            
            [authorArray addObject:@{@"Surname":@"",@"Initials":@""}];
            
        }
        
        [refDataDictionary setObject:authorArray forKey:@"Author Double Field"];
        [refDataDictionary setObject:[NSNumber numberWithInt:0]  forKey:@"hasEditors"];
       
        NSError *error;
        NSString *dataString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:refDataDictionary options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
        
        if ([_delegate respondsToSelector:@selector(getBookSucessfullWithData:)]){
            
            [_delegate getBookSucessfullWithData:dataString];
        }
    }
    
    @catch (NSException *exception)
    {
        if( [_delegate respondsToSelector:@selector(searchBooksFailedWithError:)]){
            
            [_delegate searchBooksFailedWithError:@"Could not parse book information"];
        }
    }
}

-(void)parseSearchResponseWithDictionary:(NSDictionary *)xmlDictionary
{
    @try
    {
        xmlDictionary = [xmlDictionary objectForKey:@"feed"];
        NSArray *entryArray;
        
        if ([[xmlDictionary objectForKey:@"entry"] isKindOfClass:[NSDictionary class]])
            entryArray = @[[xmlDictionary objectForKey:@"entry"]];
        else
            entryArray = [xmlDictionary objectForKey:@"entry"];
        
        if( [_delegate respondsToSelector:@selector(searchBooksSucessfullWithData:)])
        {
            
            //Your code goes in here
            [_delegate searchBooksSucessfullWithData:entryArray];
            
            
            
        }
    }
    @catch (NSException *exception)
    {
        if( [_delegate respondsToSelector:@selector(searchBooksFailedWithError:)])
        {
            
            //Your code goes in here
            [_delegate searchBooksFailedWithError:@"Could not parse book information"];
            
        }
    }

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"ERROR %@",error);
    
    if( [_delegate respondsToSelector:@selector(searchBooksFailedWithError:)])
    {
        [_delegate searchBooksFailedWithError:@"Could not get book information"];
    }
}




#pragma mark Utility methods

-(NSString *)removeCharacters:(NSArray *)charactersToRemove FromString:(NSString *)string
{
    
    for (NSString *character in charactersToRemove)
    {
        string = [string stringByReplacingOccurrencesOfString:character withString:@""];
    }
    
    return string;
}

- (BOOL) titleTagFound:(int) tagVal{

    BOOL isTagFound = FALSE;
    
    if(tagVal == 222 || tagVal == 240 || tagVal == 243 || tagVal == 245 || tagVal == 246 || tagVal == 730 || tagVal == 740){
        isTagFound = TRUE;
    }
    return isTagFound;
}

- (BOOL) citationTagFound:(int) tagVal{
    
    BOOL isTagFound = FALSE;
    
    if(tagVal == 250 || tagVal == 254 || tagVal == 255 || tagVal == 260 || tagVal == 261 || tagVal == 262 || tagVal == 263 || tagVal == 264 || tagVal == 300 || tagVal == 502 || tagVal == 773 || tagVal == 856){
        isTagFound = TRUE;
    }
    return isTagFound;
}

- (BOOL) authorshipTagFound:(int) tagVal{
    
    BOOL isTagFound = FALSE;
    
    if(tagVal == 100 || tagVal == 700 || tagVal == 110 || tagVal == 710 || tagVal == 111 || tagVal == 711 || tagVal == 720 || tagVal == 130){
        isTagFound = TRUE;
    }
    return isTagFound;
}

@end
