//
//  Utilities.m
//  EasyRef
//
//  Created by Kashif Junaid on 10/05/2018.
//  Copyright © 2018 SquaredDimesions. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (NSString *) dateToString:(NSDate *) date format:(NSString *) strFormat
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:strFormat];//Dec 14 2011 1:50 PM
    NSString *str_date = [dateFormat stringFromDate:date];
    
    return str_date;
}
+ (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

@end
