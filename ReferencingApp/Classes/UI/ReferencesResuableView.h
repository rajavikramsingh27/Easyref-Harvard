//
//  ReferencesResuableView.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 18/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReferencesResuableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *quickScanButton;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UILabel *createLabel;
@property (weak, nonatomic) IBOutlet UIButton *projectButton;
@property (weak, nonatomic) IBOutlet UIButton *referenceButton;
@property (weak, nonatomic) IBOutlet UILabel *doLabel;

@end
