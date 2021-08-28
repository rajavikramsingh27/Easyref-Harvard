//
//  SettingsTableViewController.m
//  EasyRef
//
//  Created by Radu Mihaiu on 07/01/2015.
//  Copyright (c) 2015 SquaredDimesions. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "IndexViewController.h"
#import "iRate.h"
#import "FAQTableViewController.h"
#import "WebViewController.h"

@implementation SettingsTableViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Settings";
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarVisible:false animated:true];
    [[IndexViewController sharedIndexVC] hideTopMenu];

    
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

- (BOOL)tabBarIsVisible {
    return self.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    // if you have index/header text in your tableview change your index text color
    UITableViewHeaderFooterView *headerIndexText = (UITableViewHeaderFooterView *)view;
    
    [headerIndexText.textLabel setFont:[UIFont fontWithName:@"MuseoSlab-700" size:15.0f]];
    [headerIndexText.textLabel setTextColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f]];
    [headerIndexText.textLabel setText:[headerIndexText.textLabel.text capitalizedString]];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [[IndexViewController sharedIndexVC] hideTopMenu];
            [[IndexViewController sharedIndexVC] showTutorial];
        }
        if (indexPath.row == 2)
        {
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            [mc setSubject:@"Easy Harvard Referencing iOS"];
            [mc setToRecipients:[NSArray arrayWithObject:@"ayclassapps@gmail.com"]];
            mc.mailComposeDelegate = self;

            [self presentViewController:mc animated:YES completion:NULL];

        }
        if (indexPath.row == 3)
        {
            
            NSURL *url = [NSURL URLWithString:@"twitter://user?screen_name=ayclassapps"];
            if ([[UIApplication sharedApplication] canOpenURL:url])
                [[UIApplication sharedApplication] openURL:url];
            else
                [self performSegueWithIdentifier:@"twitterSegue" sender:self];
        }
        if (indexPath.row == 4)
        {
            NSURL *url = [NSURL URLWithString:@"fb://profile/275038472536522"];
            if ([[UIApplication sharedApplication] canOpenURL:url])
                [[UIApplication sharedApplication] openURL:url];
            else
                [self performSegueWithIdentifier:@"fbSegue" sender:self];
        }
        if (indexPath.row ==5)
        {
            [[iRate sharedInstance] openRatingsPageInAppStore];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"aboutSegue"])
    {
        FAQTableViewController *vc = segue.destinationViewController;
        vc.titleString = @"Easy Harvard Referencing";
        vc.contentString = @"Easy Harvard Referencing is a reference generator to the Harvard Referencing System. First create/select your project and then choose your reference option. If you want to create a quick reference you can do so, the reference will be saved in the ‘Uncategorised’ project. You can reference by quick scanning a barcode, entering an ISBN number, searching for your book, or manually entering information. Once you have created your reference you can save it as a bibliography which is available in the projects menu. In this menu you can also edit, delete or move references.\n\nPlease see the tutorial page for more details on how to use Easy Harvard Referencing.\n\nAs reference styles may vary slightly in different universities, it is advised that you check which style your university wants you to use and how it may vary from this application.";
        
    }
    if ([segue.identifier isEqualToString:@"twitterSegue"])
    {
        WebViewController *vc = segue.destinationViewController;
        vc.destinationString = @"https://twitter.com/intent/user?screen_name=ayclassapps";
    }
    if ([segue.identifier isEqualToString:@"fbSegue"])
    {
        WebViewController *vc = segue.destinationViewController;
        vc.destinationString = @"https://www.facebook.com/pages/Easy-Harvard-Referencing-iPhone-App/275038472536522";
    }
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
