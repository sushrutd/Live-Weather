//
//  WeatherInfoViewController.h
//  LiveWeather
//
//  Created by sushrut dhanandhare on 09/06/14.
//  Copyright (c) 2014 sushrut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedClient.h"
#import "WeatherAPIKey.h"
#import "WeatherCell.h"
#import <QuartzCore/QuartzCore.h>

@interface WeatherInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray *listArray;
    NSMutableArray * mainArr;
        
}
@property (weak, nonatomic) IBOutlet UITableView *weatherInfoTable;

- (double)kelvinToCelsius:(double)degreesKelvin;
@end
