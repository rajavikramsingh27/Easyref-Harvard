//
//  QuickScanViewController.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 19/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
#import <ZXingObjC/ZXingObjC.h>
#import "Project.h"

@interface QuickScanViewController : UIViewController < ZXCaptureDelegate >
{
    NSString *barcodeResult;
}

@property (nonatomic) bool linkedScan;

@property (nonatomic, strong) ZXCapture *captureView;
@property (strong, nonatomic) Project *currentProject;

@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIButton *isbnButton;
@property (weak, nonatomic) IBOutlet UIButton *manualButton;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UIImageView *scanImageView;

- (IBAction)enterISBNButtonPressed:(id)sender;
- (IBAction)manualButtonPressed:(id)sender;
@end
