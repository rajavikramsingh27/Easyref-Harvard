//
//  Constant.m
//  Harvard
//
//  Created by appentus technologies pvt. ltd. on 9/27/19.
//  Copyright © 2019 SquaredDimesions. All rights reserved.
//

#import "Constant.h"

@interface Constant ()

@end

@implementation Constant

+(Constant*)shared {
    static Constant *shared=nil;
    static dispatch_once_t  oncePredecate;
    
    dispatch_once(&oncePredecate,^{
        shared=[[Constant alloc] init];
        
    });
    return shared;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
