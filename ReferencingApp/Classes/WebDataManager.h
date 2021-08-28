//
//  WebDataManager.h
//  EasyRef
//
//  Created by Kashif Junaid on 10/05/2018.
//  Copyright © 2018 SquaredDimesions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebDataManager;

@protocol WebDataManagerDelegate <NSObject>

@optional

-(void)didExtractedDataFromURL:(WebDataManager *)dataManager dictionary:(NSDictionary *) responseDictionary;

@end

@interface WebDataManager : NSObject

@property(nonatomic,assign)id<WebDataManagerDelegate> delegate;
- (void) extractDataFromURL:(NSString *)strUrl;

@end
