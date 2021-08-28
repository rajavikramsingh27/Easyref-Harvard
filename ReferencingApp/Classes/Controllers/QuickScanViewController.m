///
//  QuickScanViewController.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 19/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "QuickScanViewController.h"
#import "IndexViewController.h"
#import "ISBNViewController.h"

@interface QuickScanViewController ()

@end

@implementation QuickScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IndexViewController sharedIndexVC] hideTopMenu];
    
    barcodeResult = @"";

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarVisible:false animated:true];
    
    self.captureView.delegate = self;
    self.captureView.layer.frame = self.view.bounds;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_manualButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
    
    self.captureView = [[ZXCapture alloc] init];
    self.captureView.camera = self.captureView.back;
    self.captureView.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.captureView.rotation = 90.0f;
    
    self.captureView.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.captureView.layer];
    
    [self.view bringSubviewToFront:self.isbnButton];
    [self.view bringSubviewToFront:self.helpLabel];
    [self.view bringSubviewToFront:self.scanImageView];
    

        // initialize the capture manager in order to use the iPhones camera
//	[self setCaptureManager:[[CaptureSessionManager alloc] init]];
//    
//	[[self captureManager] addVideoInput];
//    [[self captureManager] addImageOutput];
//    
//    self.captureManager.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
//    
//    // creates the preview layer
//	[[self captureManager] addVideoPreviewLayer];
//	CGRect layerRect = self.view.bounds;
//   
//	[[[self captureManager] previewLayer] setBounds:layerRect];
//	[[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
//                                                                  CGRectGetMidY(layerRect))];
//    [[[self captureManager] previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//    
//        self.captureView = [[UIView alloc] initWithFrame:self.view.bounds];
//    
//    
//	[[[self captureView] layer] addSublayer:[[self captureManager] previewLayer]];
//    [self.view insertSubview:_captureView belowSubview:_isbnButton];
//    [self.view addSubview:_helpLabel];
//    [[self.captureManager captureSession] startRunning];
    
}

#pragma mark - Private Methods

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
    
    // We got a result. Display information about the result onscreen.
    if (![barcodeResult isEqualToString:@""])
        return;
    
    
    barcodeResult = result.text;
    
    [self performSegueWithIdentifier:@"isbnSegue" sender:self];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"isbnSegue"])
    {
        ISBNViewController *vc = segue.destinationViewController;
        vc.scanString = barcodeResult;
        if (_currentProject != nil)
          vc.currentProject = _currentProject;

        if (self.linkedScan == true)
            vc.linkedScan = true;
    }
}


-(void)viewDidDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated {
    
    // bail if the current state matches the desired state
    if ([self tabBarIsVisible] == visible) return;
    
    // get a frame calculation ready
    CGRect frame = self.tabBarController.tabBar.frame;
    CGFloat height = frame.size.height;
    CGFloat offsetY = (visible)? -height : height;
    
    // zero duration means no animation
    CGFloat duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    }];
}

// know the current state
- (BOOL)tabBarIsVisible {
    return self.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)enterISBNButtonPressed:(id)sender {
}

- (IBAction)manualButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}
@end
