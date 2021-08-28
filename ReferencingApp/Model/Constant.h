//  Constant.h
//  Harvard
//  Created by appentus technologies pvt. ltd. on 9/27/19.
//  Copyright © 2019 SquaredDimesions. All rights reserved.



#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static NSString * const kBaseURL = @"http://3.19.62.211:5000/";


//NS_ASSUME_NONNULL_BEGIN
@interface Constant : UIViewController

+(Constant*)shared;

@end

//NS_ASSUME_NONNULL_END
