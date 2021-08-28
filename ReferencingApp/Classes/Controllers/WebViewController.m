//
//  WebViewController.m
//  EasyRef
//
//  Created by Radu Mihaiu on 21/01/2015.
//  Copyright (c) 2015 SquaredDimesions. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL*url=[NSURL URLWithString:_destinationString];
    NSURLRequest*request=[NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    
}
@end
