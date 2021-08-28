//
//  SearchBarTableViewCell.h
//  EasyRef
//
//  Created by Kashif Junaid on 10/05/2018.
//  Copyright © 2018 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchBarTableViewCell;

@protocol SearchBarTableViewCellDelegate <NSObject>

@optional

-(void)didEndEditingSearchBarCell:(SearchBarTableViewCell *)cell strValue:(NSString *) strValue;

@end

@interface SearchBarTableViewCell : UITableViewCell


@property(nonatomic,assign)id<SearchBarTableViewCellDelegate> delegate;

@property (nonatomic, weak) IBOutlet UISearchBar *searchField;
@property (nonatomic, weak) IBOutlet UIButton *btnSearch;

- (IBAction)seachAction:(id)sender;

@end
