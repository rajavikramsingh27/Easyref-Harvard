//  Picker_VC.m
//  Harvard

//  Created by appentus technologies pvt. ltd. on 9/27/19.
//  Copyright © 2019 SquaredDimesions. All rights reserved.



#import "Picker_VC.h"
#import "Constant.h"

@interface Picker_VC () <UIPickerViewDelegate,UIPickerViewDataSource>

@end



@implementation Picker_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.pickerView setHidden:NO];
    self.arr_Style_Picker = [[NSMutableArray alloc]init];
    
    [self func_get_styles];
    
//    arr_Project_Titles = [NSArray arrayWithObjects:
//                          @"annual-report",
//                          @"audio-cd",
//                          @"blog",
//                          @"book",
//                          @"dissertation",
//                          @"email",
//                          @"encyclopedia",
//                          @"film",
//                          @"gov",
//                          @"image",
//                          @"interview",
//                          @"journal",
//                          @"kindle",
//                          @"map",
//                          @"mobile",
//                          @"newspaper",
//                          @"pdf",
//                          @"podcast",
//                          @"powerpoint",
//                          @"video",
//                          @"website", nil];

}



- (IBAction)btn_done:(id)sender {
    [self.view removeFromSuperview];
}

- (IBAction)btn_cancel:(id)sender {
    [self.view removeFromSuperview];
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _arr_Style_Picker.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.arr_Style_Picker[row] uppercaseString];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"picker_Recieve" object:[self.arr_Style_Picker[row] uppercaseString]];
}

-(void) func_get_styles {
    NSString *full_URL = [NSString stringWithFormat:@"%@get_styles",kBaseURL];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:full_URL]];
    
//    NSString *userUpdate =[NSString stringWithFormat:@"user=%@&password=%@&api_id=%@&to=%@&text=%@",_username,_password,_apiID,[_numbers componentsJoinedByString:@","],_txtMsg.text, nil];
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    
    //Convert the String to Data
//    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
//    [urlRequest setHTTPBody:data1];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200) {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSInteger success = [[responseDictionary objectForKey:@"status"] integerValue];
            if(success == 1) {
                NSArray *arrStyles = [responseDictionary objectForKey:@"styles"];
                for (NSString *strStyle in arrStyles) {
                    NSMutableString *strStyle_Filter = [[NSMutableString alloc]init];
                    strStyle_Filter = [[strStyle stringByReplacingOccurrencesOfString:@"/home/ubuntu/.local/lib/python2.7/site-packages/citeproc/data/styles/" withString:@""] mutableCopy];
                    strStyle_Filter = [[strStyle_Filter stringByReplacingOccurrencesOfString:@".csl" withString:@""] mutableCopy];
                    [self.arr_Style_Picker addObject:strStyle_Filter];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pickerView setHidden:YES];
                    [self.pickerView reloadAllComponents];
                });
            }
        }
    }];
    [dataTask resume];
}



@end
