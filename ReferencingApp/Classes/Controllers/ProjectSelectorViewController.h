//
//  ProjectSelectorViewController.h
//  EasyRef
//
//  Created by Radu Mihaiu on 18/01/2016.
//  Copyright © 2016 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

@protocol ProjectSelectorDelegate <NSObject>
- (void)projectSelectorDidSelectProject:(Project *)project;

@end

@interface ProjectSelectorViewController : UIViewController < UITableViewDelegate, UITableViewDataSource >
@property (nonatomic,assign) id <ProjectSelectorDelegate> delegate;


@end
