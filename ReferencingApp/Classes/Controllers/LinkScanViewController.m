//
//  LinkScanViewController.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 20/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "LinkScanViewController.h"
#import "IndexViewController.h"
#import "NoComputerTableViewCell.h"
#import "ReferencingApp.h"
#import "QuickScanViewController.h"
#import "SettingsTableViewController.h"

#define SERVICE_NAME @"_probonjore._tcp."
#define ACK_SERVICE_NAME @"_ack._tcp."

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface LinkScanViewController ()

@property(nonatomic,strong) NSNetServiceBrowser* coServiceBrowser;
@property(nonatomic,strong) NSMutableDictionary* dictSockets;
@property(nonatomic, strong) NSMutableArray* arrDevices;


@end

@implementation LinkScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    _linkedScanView.delegate = self;
    _startScanButton.hidden = true;

    
    [_findOutMoreButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    noOfRows = 0;
    
    [self startService];
    _dictSockets = [NSMutableDictionary dictionary];


}





-(void)startService{
    if (self.arrDevices) {
        [self.arrDevices removeAllObjects];
        
    }else{
        _arrDevices=[NSMutableArray array];
    }
    
    _coServiceBrowser = [[NSNetServiceBrowser alloc]init];
    self.coServiceBrowser.delegate = self;
    [self.coServiceBrowser searchForServicesOfType:SERVICE_NAME inDomain:@"local."];
    
}

#pragma mark - Service Delegate

-(void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict{
    
    NSLog(@"Didnot resolved: %@", errorDict);
    [sender setDelegate:self
     ];
}

-(void)netServiceDidResolveAddress:(NSNetService *)sender{
    NSLog(@"netServiceDidResolveAddress %@", sender.name);
    if ([self connectWithServer:sender]) {
        NSLog(@"Connected with server");
        NSLog(@"Device");
        
        //        self.lblConnected.stringValue=str ;
        //        self.lblConnected.textColor=[NSColor greenColor];
    }
}




-(BOOL)connectWithServer:(NSNetService*)service{
    BOOL isConnected=NO;
    
    NSArray* arrAddress =[[service addresses] mutableCopy];
    GCDAsyncSocket * coSocket= [self.dictSockets objectForKey:service.name];
    
    
    if (!coSocket  || ![coSocket isConnected]) {
        GCDAsyncSocket * coSocket=[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //Connect
        while (!isConnected && [arrAddress count]) {
            NSData* address= [arrAddress objectAtIndex:0];
            NSError* error;
            if ([coSocket connectToAddress:address error:&error]) {
                [self.dictSockets setObject:coSocket forKey:service.name];
                isConnected=YES;
                _startScanButton.hidden = false;
                _linkedScanView.computerLabel.text = service.name;

                
            }else if(error){
                NSLog(@"Unable to connect with Device %@ userinfo %@", error,error.userInfo);
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                               message: error.localizedDescription
                                                              delegate: self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
                [alert show];

                
            }
        }
    }else{
        isConnected = [coSocket isConnected];
    }
    
    
    return isConnected;
}


#pragma mark GCDAsyncSocket delegate
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"Connected to host: %@ port: %hu", host, port);
    [sock readDataToLength:sizeof(uint64_t) withTimeout:-1.0 tag:0];
    
    
    //    self.txtLogs.stringValue=@"";
    //    self.lblConnected.stringValue=@"Connected with ";
    
}


-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"Disconnected to host: %@", err.userInfo);
    
    
}


-(GCDAsyncSocket*)getSelectedSocket{
    NSNetService* coService =[self.arrDevices objectAtIndex:0];
    return  [self.dictSockets objectForKey:coService.name];
    
}
-(void) socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"Read data");
    
    if ([self getSelectedSocket]== sock) {
        NSString* strInfo =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",strInfo);
    }
    
    [sock readDataWithTimeout:-1.0f tag:0];
    
    
}


-(void)socketDidCloseReadStream:(GCDAsyncSocket *)sock{
    NSLog(@"Read stream is closed");
    
    
}
#pragma mark- Service browser delegate;

-(void)stopBrowsing{
    if (self.coServiceBrowser) {
        [self.coServiceBrowser stop];
        self.coServiceBrowser.delegate=nil;
        [self setCoServiceBrowser:nil];
    }
}

-(void) netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser{
    [self stopBrowsing];
}
-(void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didNotSearch:(NSDictionary *)errorDict{
    [self stopBrowsing];
}


-(void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing{
    if (aNetService) {
        
        [self.arrDevices removeObject:aNetService];
    }
    
    if (!moreComing) {
        [self reloadTopView];
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing{
    
    if (aNetService) {
        [self.arrDevices addObject:aNetService];
    }
    
    if (!moreComing) {
        [self.arrDevices sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        [self reloadTopView];
    }
}

/////
-(void)reloadTopView
{
    if ([self.arrDevices count] == 0)
    {
        self.noComputerOverlayView.hidden = false;
        _startScanButton.hidden = true;
        _linkedScanView.computerArray = @[];
        [[[ReferencingApp sharedInstance] linkedScanRefArray] removeAllObjects];
        [self.tableView reloadData];
    }
    else
    {
        self.noComputerOverlayView.hidden = true;

        NSMutableArray *placeholderArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [self.arrDevices count]; i ++)
        {
            NSNetService* coService=[self.arrDevices objectAtIndex:i];
            [placeholderArray addObject:coService.name];
        }
        
        _linkedScanView.computerArray = placeholderArray;

    }
    
    [_linkedScanView refresh];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarVisible:true animated:true];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNavBar) name:@"hideNavBar" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNavBar) name:@"showNavBar" object:nil];
    [[IndexViewController sharedIndexVC] showTopMenuWithString:@"Linked Scan"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSettings) name:@"showSettings" object:nil];

    
    [self.tableView reloadData];

}


-(void)showSettings
{
    
    [self performSelector:@selector(goToSettings) withObject:nil afterDelay:0.3f];
    
}

-(void)goToSettings
{
    
    [self showNavBar];
    SettingsTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsVC"];
    [self.navigationController pushViewController:vc animated:TRUE];
    
}


-(void)linkedScanViewSelectedRow:(int)row
{
    [[[ReferencingApp sharedInstance] linkedScanRefArray] removeAllObjects];
    [self.tableView reloadData];

    
    NSNetService* coService =[self.arrDevices objectAtIndex:row];
    coService.delegate=self;
    [coService resolveWithTimeout:30.0f];
    
}

-(void)linkedScanExpandToHeight:(float)height
{
    self.linkedScanHeightCS.constant = height;

    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view updateConstraintsIfNeeded];
    }];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[IndexViewController sharedIndexVC] hideTopMenu];
    
    if ([segue.identifier isEqualToString:@"scanSegue"])
    {
        QuickScanViewController *vc = segue.destinationViewController;
        vc.linkedScan = true;
    }
    if ([segue.identifier isEqualToString:@"helpSegue"])
    {
        FAQTableViewController *vc = segue.destinationViewController;
        vc.titleString = @"Easy Harvard Referencing for OSX";
        vc.contentString = @"Easy Harvard Referencing is also available for OSX (Macbook)\n\nWhen both applications are open you can automatically sync your references between devices. This can be useful to use your iPhone as a barcode scanner and your Macbook to manage references.\n\nPlease ensure that both devices are connected to the same WIFI network to sync.";
    
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ReferencingApp sharedInstance].linkedScanRefArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ReferencesTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"projectCell" forIndexPath:indexPath];
    [cell setCanDrag:FALSE];
    Reference *ref = [[ReferencingApp sharedInstance].linkedScanRefArray objectAtIndex:indexPath.row];
    
    cell.typeImageView.backgroundColor =  UIColorFromRGB([@0x377c86 intValue]);
    cell.referenceLabel.attributedText = [ref getReferenceString];
    
    if ([ref.projectID isEqualToString:@"0"])
        [cell.checkmarkImageView setImage:nil];
    else
        [cell.checkmarkImageView setImage:[UIImage imageNamed:@"sync_confirm"]];

    return cell;
}

-(void)goToHelp
{
    [self performSegueWithIdentifier:@"helpSegue" sender:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Reference *selectedRef = [[ReferencingApp sharedInstance].linkedScanRefArray objectAtIndex:indexPath.row];
    selectedRef.projectID = @"1";
    
    NSData* data=[selectedRef.data dataUsingEncoding:NSUTF8StringEncoding];
    [[self getSelectedSocket] writeData:data withTimeout:-1.0f tag:0];
    
    [self.tableView reloadData];
    [[ReferencingApp sharedInstance] refreshUserAfterDelay];
  
}


-(void)deleteButtonPressedAtCell:(ProjectTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    noOfRows -= 1;
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)hideNavBar
{
    self.topLayoutCS.constant = 44;
    [self.tableView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    [self.view layoutSubviews];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

-(void)showNavBar
{
    self.topLayoutCS.constant = 0;
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];

    [self.view layoutSubviews];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

@end
