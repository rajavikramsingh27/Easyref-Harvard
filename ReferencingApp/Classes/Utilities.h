//
//  Utilities.h
//  EasyRef
//
//  Created by Kashif Junaid on 10/05/2018.
//  Copyright © 2018 SquaredDimesions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+ (NSString *) dateToString:(NSDate *) date format:(NSString *) strFormat;
+ (BOOL) validateUrl: (NSString *) candidate;

@end
