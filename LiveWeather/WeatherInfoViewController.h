//
//  WeatherInfoViewController.h
//  LiveWeather
//
//  Created by sushrut dhanandhare on 09/06/14.
//  Copyright (c) 2014 sushrut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherAPIKey.h"
#import "WeatherCell.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

@interface WeatherInfoViewController:UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    NSMutableArray *listArray;
    NSMutableArray * mainArr;
    NSArray *colorsArray;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;

}
@property (weak, nonatomic) IBOutlet UITableView *weatherInfoTable;
@property (nonatomic, strong) NSCache *cache;
- (double)kelvinToCelsius:(double)degreesKelvin;
@end
