//
//  LiveWeatherViewController.m
//  LiveWeather
//
//  Created by sushrut dhanandhare on 04/06/14.
//  Copyright (c) 2014 sushrut. All rights reserved.
//

#import "LiveWeatherViewController.h"

//NSString *const BASE_URL_STRING = @"http://openweathermap.org/data/2.3/forecast/city?";

@interface LiveWeatherViewController ()

@end

@implementation LiveWeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cityOne.delegate =self;
    
    
    // Padding for text field
    
    UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 20)];
    self.cityOne.leftViewMode =UITextFieldViewModeAlways;
    self.cityOne.leftView = vw;
    [self.enterButton addTarget:self action:@selector(showWeather:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)showWeather:(id)sender
{
    self.cityString1 = self.cityOne.text;
    if ([[SharedClient sharedInstance].cityArray count]>0) {
        [[SharedClient sharedInstance].cityArray removeAllObjects];
    }
    if (!self.cityString1.length<1) {
        [[SharedClient sharedInstance].cityArray addObject:self.cityString1];

    }
    NSLog(@"City Array ; %@",[SharedClient sharedInstance].cityArray);
    if (self.cityString1.length<1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter city" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else{
        [SVProgressHUD show];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            WeatherInfoViewController *weatherInfoVC = (WeatherInfoViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"WeatherInfoVC"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.navigationController pushViewController:weatherInfoVC animated:YES];
                [SVProgressHUD dismiss];
                
            });
        });
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
