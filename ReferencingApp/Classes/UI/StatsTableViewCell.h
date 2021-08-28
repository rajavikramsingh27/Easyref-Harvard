//
//  StatsTableViewCell.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 28/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface StatsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;

@property (weak, nonatomic) IBOutlet UIView *colorView;
@end
