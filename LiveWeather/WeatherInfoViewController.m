//
//  WeatherInfoViewController.m
//  LiveWeather
//
//  Created by sushrut dhanandhare on 09/06/14.
//  Copyright (c) 2014 sushrut. All rights reserved.
//

#import "WeatherInfoViewController.h"


NSString *const BASE_URL_STRING = @"http://openweathermap.org/data/2.5/forecast/daily?";
//NSString *const BASE_URL_STRING = @"http://openweathermap.org/data/2.5/history/city?";

NSString *const IMAGE_URL_STRING = @"http://openweathermap.org/img/w/";

@interface WeatherInfoViewController ()
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, assign) CGFloat screenHeight;
@end


@implementation WeatherInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    listArray = [[NSMutableArray alloc]init];
    [self makeWeatherRequest];
    
   }

-(void)makeWeatherRequest
{
    mainArr=[[NSMutableArray alloc]init]; // to store values
    for (NSString *tempObj in [SharedClient sharedInstance].cityArray) {
         NSString *urlString =[NSString stringWithFormat:@"%@q=%@&APPID=%@&cnt=14",BASE_URL_STRING,tempObj,kWeatherUndergroundAPIKey];
        
        
        NSURL *url =[NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSURLResponse *response = NULL;
        NSError *requestError = NULL;
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request        returningResponse:&response error:&requestError];
        
        NSArray *parsedObject= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (parsedObject==nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:nil delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        listArray = [parsedObject valueForKey:@"list"];
}
}

-(NSString *)convertDate:(double)dateValue
{
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:dateValue];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setLocale:[NSLocale currentLocale]];
    [_formatter setDateFormat:@"EEEE dd MMMM yyyy"];
    NSString *dateString=[_formatter stringFromDate:newDate];
    
    //For current day
    NSDate *todaysDate = [NSDate date];
    NSString *todaysDateStr = [_formatter stringFromDate:todaysDate];
    if ([todaysDateStr isEqualToString:dateString]) {
        return @"Today";
    }
    else{
    return dateString;
    }
}

- (double)kelvinToCelsius:(double)degreesKelvin
{
    const double ZERO_CELSIUS_IN_KELVIN = 273.15;
    return degreesKelvin - ZERO_CELSIUS_IN_KELVIN;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 14;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *temp=nil;
    if (section == 0) {
        temp=[[SharedClient sharedInstance].cityArray objectAtIndex:0];
        
    }
    return temp;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    WeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"WeatherCell" owner:self options:nil];
        cell = nib[0];
    }
    //Description
    cell.descriptionLabel.text = [[[[listArray objectAtIndex:indexPath.row]valueForKey:@"weather"]objectAtIndex:0]valueForKey:@"description"];
    //cell.descriptionLabel.textColor = [UIColor whiteColor];
    
    //Temperature
    double tempInCelcius = [self kelvinToCelsius:[[[[listArray objectAtIndex:indexPath.row]valueForKey:@"temp"]valueForKey:@"day"]doubleValue]];
    int temp = (int)tempInCelcius;
    cell.temperatureLabel.text = [NSString stringWithFormat:@"%d C",temp];
   // cell.temperatureLabel.textColor = [UIColor whiteColor];
    
    //Date
    double tempDate = [[[listArray objectAtIndex:indexPath.row]valueForKey:@"dt"]doubleValue];
    NSString *dateStr = [self convertDate:tempDate];
    cell.dateLAbel.text = dateStr;
     //cell.dateLAbel.textColor = [UIColor whiteColor];
    
    //Icon
    NSString *iconName = [[[[listArray objectAtIndex:indexPath.row]valueForKey:@"weather"]objectAtIndex:0]valueForKey:@"icon"];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *weatherImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",IMAGE_URL_STRING,iconName]]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [cell.iconImageView setImage:weatherImage];
        
            // cell.iconImageView.layer.shadowRadius =2.0;
            //cell.iconImageView.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]CGColor];
            
        });
        
    });
    
    return cell;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[SharedClient sharedInstance].cityArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
