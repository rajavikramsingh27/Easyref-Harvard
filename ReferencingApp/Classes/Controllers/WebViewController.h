//
//  WebViewController.h
//  EasyRef
//
//  Created by Radu Mihaiu on 21/01/2015.
//  Copyright (c) 2015 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong,nonatomic) NSString *destinationString;

@end
