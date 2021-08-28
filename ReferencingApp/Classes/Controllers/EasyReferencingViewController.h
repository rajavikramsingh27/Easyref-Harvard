//
//  EasyReferencingViewController.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 11/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReferencingApp.h"
#import "Project.h"

@interface EasyReferencingViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource, UIGestureRecognizerDelegate >
{
    NSArray *referenceTypeArray;
    NSIndexPath *senderIndexPath;
}

@property (weak, nonatomic) IBOutlet UIView *whiteView;

@property (nonatomic,strong) Project *currentProject;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutCS;

@property (weak, nonatomic) IBOutlet UIView *dragView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong,nonatomic) NSString *str_Selected_Style;

@end
