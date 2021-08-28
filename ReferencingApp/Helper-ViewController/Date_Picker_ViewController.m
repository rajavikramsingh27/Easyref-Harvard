//
//  Date_Picker_ViewController.m
//  Harvard
//
//  Created by appentus technologies pvt. ltd. on 10/14/19.
//  Copyright © 2019 SquaredDimesions. All rights reserved.
//

#import "Date_Picker_ViewController.h"

@interface Date_Picker_ViewController ()

@end

@implementation Date_Picker_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btn_Done:) name:@"BeginEditing" object:nil];
}



- (IBAction)selectDate:(UIDatePicker*)sender {
    NSDateFormatter * formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy MM dd"];
    NSString *dateString = [formatter stringFromDate:sender.date];
    
    NSDictionary *dict_Info = @{self.str_ID:dateString};
    NSLog(@"%@",dict_Info);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Date_Blog" object:dict_Info];
}

- (IBAction)btn_Done:(id)sender {
    [self.view removeFromSuperview];
}

@end
