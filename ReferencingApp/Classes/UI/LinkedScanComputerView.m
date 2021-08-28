//
//  LinkedScanComputerView.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 20/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "LinkedScanComputerView.h"
#import "ReferencingApp.h"

@implementation LinkedScanComputerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];

    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    
    return self;
}

-(void)initialize
{
    self.clipsToBounds = true;
    isShowingSelection = false;
    self.backgroundColor = [UIColor clearColor];
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    [backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    backgroundView.backgroundColor = [UIColor colorWithRed:20.0f/255.0f green:93.0f/255.0f blue:142.0f/255.0f alpha:1.0f];
    [self addSubview:backgroundView];
    
    _computerArray = [[NSArray alloc] init];
    
    _computerLabel = [[UILabel alloc] initWithFrame:self.bounds];
    [_computerLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    _computerLabel.text = @"No computers available";
    _computerLabel.textColor = [UIColor whiteColor];
    [_computerLabel setFont:[UIFont fontWithName:@"MuseoSlab-500" size:18.0f]];
    [_computerLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_computerLabel];
    
    
    arrowButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    [arrowButton setTranslatesAutoresizingMaskIntoConstraints:NO];

    arrowButton.hidden = true;
    [arrowButton setImageEdgeInsets:UIEdgeInsetsMake(0, 250, 0, 0)];
    [arrowButton setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    [arrowButton addTarget:self action:@selector(downArrowPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:arrowButton];
    
    [self setNoComputersActive];
    
   
   
    [self contraintView:backgroundView];
    [self contraintView:_computerLabel];
    [self contraintView:arrowButton];


    
    
    
}

-(void)contraintView:(UIView *)viewToContrain
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:viewToContrain
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:viewToContrain
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:kNilOptions
                                                     attribute:kNilOptions
                                                    multiplier:0
                                                      constant:50]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:viewToContrain
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:viewToContrain
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
}

-(void)refresh
{
    if ([_computerArray count] == 0)
    {
        [self setNoComputersActive];
    }
    else
    {
        [self setComputersActive];
    }
}

-(void)downArrowPressed
{
    if (isShowingSelection == true)
    {
        [self closeSelection];
        return;
    }
    
    isShowingSelection = true;

    buttonsArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_computerArray count]; i ++)
    {
        
        NSString *string = _computerArray[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        
        
        [button setFrame:CGRectMake(0, 50 + (i * 50), self.frame.size.width, 50)];
        [button setBackgroundColor:[UIColor colorWithRed:20.0f/255.0f green:93.0f/255.0f blue:142.0f/255.0f alpha:0.8f]];
        [button setTitle:string forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"MuseoSlab-500" size:18.0f];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
        [buttonsArray addObject:button];
        [self addSubview:button];
        
    }
    
//    self.frame = CGRectMake(0, self.frame.origin.y, 320, 50 + (50 * [_computerArray count]));

    
    if ([_delegate respondsToSelector:@selector(linkedScanExpandToHeight:)])
    {
        [_delegate linkedScanExpandToHeight:50 +50 * [_computerArray count]];
    }
}

-(void)buttonPressed:(UIButton *)button
{
    
    if ([_delegate respondsToSelector:@selector(linkedScanViewSelectedRow:)])
    {
        [_delegate linkedScanViewSelectedRow:button.tag];
    }
    
    [self closeSelection];
   
}

-(void)closeSelection
{
    [UIView animateWithDuration:0.3 animations:^{
        if ([_delegate respondsToSelector:@selector(linkedScanExpandToHeight:)])
        {
            [_delegate linkedScanExpandToHeight:50];
        }
    } completion:^(BOOL finished) {
        
        for (UIButton *button in buttonsArray)
            [button removeFromSuperview];
        
        isShowingSelection = false;
        
    }];

    
}


-(void)setComputersActive
{
    [ReferencingApp sharedInstance].linkedScanRefArray = [[NSMutableArray alloc] init];

    arrowButton.hidden = false;
    _computerLabel.text = @"No computer selected";
    backgroundView.backgroundColor = [UIColor colorWithRed:20.0f/255.0f green:93.0f/255.0f blue:142.0f/255.0f alpha:1.0f];

    
}

-(void)setNoComputersActive
{
    [ReferencingApp sharedInstance].linkedScanRefArray = [[NSMutableArray alloc] init];

    backgroundView.backgroundColor = [UIColor colorWithRed:155.0f/255.0f green:89.0f/255.0f blue:182.0f/255.0f alpha:1.0f];
    arrowButton.hidden = true;
    _computerLabel.text = @"No computers available";

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
