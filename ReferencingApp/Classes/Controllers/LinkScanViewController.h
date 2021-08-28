//
//  LinkScanViewController.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 20/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReferencesTableViewCell.h"
#import "LinkedScanComputerView.h"
#import "FAQTableViewController.h"
#import "GCDAsyncSocket.h"

@interface LinkScanViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SlideableCellDelegate, NSNetServiceDelegate, GCDAsyncSocketDelegate, NSNetServiceBrowserDelegate, LinkedScanViewDelegate  >
{
    int noOfRows;
}


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linkedScanHeightCS;

@property (strong, nonatomic) NSNetService *service;
@property (strong, nonatomic) GCDAsyncSocket *socket;

@property (weak, nonatomic) IBOutlet LinkedScanComputerView *linkedScanView;
@property (weak, nonatomic) IBOutlet UIView *noComputerOverlayView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutCS;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopCS;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *findOutMoreButton;
@property (weak, nonatomic) IBOutlet UIButton *startScanButton;


@end
