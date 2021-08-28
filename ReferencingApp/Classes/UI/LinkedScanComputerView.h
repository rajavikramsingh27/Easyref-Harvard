//
//  LinkedScanComputerView.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 20/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LinkedScanViewDelegate <NSObject>
@optional

-(void)linkedScanViewSelectedRow:(int)row;
-(void)linkedScanExpandToHeight:(float)height;
@end

@interface LinkedScanComputerView : UIView
{
    UIView *backgroundView;
    UIButton *arrowButton;
    
    NSMutableArray *buttonsArray;
        
    bool isShowingSelection;
}

@property (nonatomic, strong) UILabel *computerLabel;
@property (nonatomic,strong) NSArray *computerArray;
@property (nonatomic,assign) id < LinkedScanViewDelegate > delegate;

-(void)refresh;
-(void)initialize;

@end
