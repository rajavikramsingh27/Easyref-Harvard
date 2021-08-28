//
//  ReferencesTableViewCell.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 19/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectTableViewCell.h"

@interface ReferencesTableViewCell : ProjectTableViewCell
{
    BOOL canDrag;
}

@property (weak, nonatomic) IBOutlet UIImageView *checkmarkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *referenceLabel;

-(void)setCanDrag:(BOOL)boolVal;

@end
