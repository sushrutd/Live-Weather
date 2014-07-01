//
//  LiveWeatherViewController.h
//  LiveWeather
//
//  Created by sushrut dhanandhare on 04/06/14.
//  Copyright (c) 2014 sushrut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherAPIKey.h"
#import "SharedClient.h"
#import "WeatherInfoViewController.h"
#import "SVProgressHUD.h"

@interface LiveWeatherViewController : UIViewController<UITextFieldDelegate>
{
    NSArray *cityArray;
    NSDictionary *weatherServiceResponse;

}

@property (weak, nonatomic) IBOutlet UITextField *cityOne;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) NSString *cityString1;

@end
