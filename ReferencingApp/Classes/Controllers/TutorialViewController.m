//
//  TutorialViewController.m
//  EasyRef
//
//  Created by Radu Mihaiu on 12/01/2015.
//  Copyright (c) 2015 SquaredDimesions. All rights reserved.
//

#import "TutorialViewController.h"
#import "IndexViewController.h"

@implementation TutorialViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    titleArray = @[
                   @"Create References",
                   @"Quick Scan",
                   @"Manual Input",
                   @"Projects",
                   @"Sharing & Editing",
                   @"Reference Type",
                   @"Edit Single Reference",
                   @"Profile",
                   @"Sync References"
                   ];
    
    descriptionArray = @[
                         @"Create references quickly by using quick scan or manually input the data",
                         @"Quick Scan allows you to automatically generate book citations by scanning a barcode or searching By Author, Title or ISBN number",
                         @"Manually generate a reference by inputting data into the text fields.",
                         @"Create Online or Offline projects to save your references in",
                         @"Slide left on a project name to show the sharing and editing controls",
                         @"Slide right on a single reference to show its type",
                         @"Select a single reference to edit it",
                         @"Use the profile button to show your stats and access the settings menu",
                         @"Download Easy Harvard Referencing for Mac to sync your references between devices",
                         ];
    
    
    [self.titleLabel setText:[titleArray objectAtIndex:0]];
    [self.descriptionLabel setText:[descriptionArray objectAtIndex:0]];
    
    
    tutorialImages = [[NSMutableArray alloc] init];
    int nimages = 1;
    for (; ; nimages++) {
        
        NSString *imageName = [NSString stringWithFormat:@"tutorial_%d.png", nimages];
        UIImage *image = [UIImage imageNamed:imageName];
        
        if (image == nil)
            break;
        else
            [tutorialImages addObject:image];
        
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_scrollView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollviewHeightCS.constant = self.view.frame.size.height;
    [self.view updateConstraintsIfNeeded];
    
    
    NSLog(@"VIEW HEIGHT IS %f",self.view.frame.size.height);
    NSLog(@"SCroll HEIGHT IS %f",_scrollView.frame.size.height);
    
    for (int i = 0; i < [tutorialImages count] ; i ++ )
    {
        UIImage *image = [tutorialImages objectAtIndex:i];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _scrollView.frame.size.height * i, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:image];
        
        NSLog(@"Image HEIGHT IS %f",imageView.frame.size.height);
        
        
        [_scrollView addSubview:imageView];
    }
    
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height * [tutorialImages count])];
    _scrollView.delegate = self;
    
    
    _pageControl.transform = CGAffineTransformMakeRotation(M_PI_2);
    _pageControl.numberOfPages = [tutorialImages count];
    
}




-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = floor((self.scrollView.contentOffset.y - self.scrollView.frame.size.height / 2) / self.scrollView.frame.size.height) + 1;
    self.pageControl.currentPage = page;
    
    [self.titleLabel setText:[titleArray objectAtIndex:page]];
    [self.descriptionLabel setText:[descriptionArray objectAtIndex:page]];
    
}

- (IBAction)closeButtonPressed:(id)sender {
    
    [[IndexViewController sharedIndexVC] closeTutorial];
}
@end
