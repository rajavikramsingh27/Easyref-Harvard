//
//  LoadingView.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 27/09/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
        
        NSMutableArray *animImages = [[NSMutableArray alloc] init];
        
        
        int nimages = 0;
        for (; ; nimages++) {
            
            int numberofzeros = 2;
            if (nimages/10 >= 1)
                numberofzeros --;
            
            NSString *zeroString = @"";
            while (numberofzeros)
            {
                zeroString = [NSString stringWithFormat:@"%@%@", zeroString,@"0"];
                numberofzeros --;
            }
            
            NSString *imageName = [NSString stringWithFormat:@"loading-%@%d.png",zeroString, nimages];
            UIImage *image = [UIImage imageNamed:imageName];
            
            if (image == nil)
                break;
            else
                [animImages addObject:image];
            
        }
        
        self.alpha = 0.0f;
        
        loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 135, 135)];
        loadingImageView.animationImages = animImages;
        loadingImageView.animationRepeatCount = 0;
        loadingImageView.animationDuration = 2;
        loadingImageView.center = self.center;
        [self addSubview:loadingImageView];
        
    }
    
    return self;
}

-(void)fadeIn
{
    loadingImageView.center = self.center;
    [loadingImageView startAnimating];
    
    [UIView animateWithDuration:1.0f animations:^{
        self.alpha = 1.0f;
    }];
}




@end
