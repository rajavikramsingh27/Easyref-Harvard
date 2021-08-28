//
//  Picker_VC.h
//  Harvard
//
//  Created by appentus technologies pvt. ltd. on 9/27/19.
//  Copyright © 2019 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Picker_VC : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong) NSMutableArray *arr_Style_Picker;

- (IBAction)btn_done:(id)sender;
- (IBAction)btn_cancel:(id)sender;

@end

NS_ASSUME_NONNULL_END
