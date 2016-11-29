//
//  WeatherInfoViewController.m
//  LiveWeather
//
//  Created by sushrut dhanandhare on 09/06/14.
//  Copyright (c) 2014 sushrut. All rights reserved.
//

#import "WeatherInfoViewController.h"

NSString *const BASE_URL_STRING = @"http://api.openweathermap.org/data/2.5/forecast/daily?";
NSString *const IMAGE_URL_STRING = @"http://openweathermap.org/img/w/";

@interface WeatherInfoViewController ()
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
    _cache = [[NSCache alloc]init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    
    geocoder = [[CLGeocoder alloc] init];
    
    listArray = [[NSMutableArray alloc]init];
    colorsArray = @[@"#FC9B5B",@"#DFEC57",@"#58DEF9",@"#EDDFCB",@"#FBED68",@"#FC9B5B",@"#DFEC57",@"#58DEF9",@"#EDDFCB",@"#FBED68",@"#FC9B5B",@"#DFEC57",@"#58DEF9",@"#EDDFCB",@"#FBED68"];
    
    self.weatherInfoTable.backgroundColor = [self colorWithHexString:@"#43424F"];
    
}
-(UIColor*)colorWithHexString:(NSString*)hex
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    WeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"WeatherCell" owner:self options:nil];
        cell = nib[0];
    }
    
    @try {
        
        NSString *color = [colorsArray objectAtIndex:indexPath.row];
        cell.cellBackgroundView.backgroundColor = [self colorWithHexString:color];
        cell.backgroundColor = [self colorWithHexString:@"#43424F"];
        cell.cellBackgroundView.layer.cornerRadius = 5;
        
        //Description
        cell.descriptionLabel.text = [[[[listArray objectAtIndex:indexPath.row]valueForKey:@"weather"]objectAtIndex:0]valueForKey:@"description"];
        
        
        //Temperature
        double tempInCelcius = [self kelvinToCelsius:[[[[listArray objectAtIndex:indexPath.row]valueForKey:@"temp"]valueForKey:@"day"]doubleValue]];
        int temp = (int)tempInCelcius;
        cell.temperatureLabel.text = [NSString stringWithFormat:@"%d\u00B0C",temp];
        
        
        //Date
        double tempDate = [[[listArray objectAtIndex:indexPath.row]valueForKey:@"dt"]doubleValue];
        NSString *dateStr = [self convertDate:tempDate];
        cell.dateLAbel.text = dateStr;
        
        
        //Icon
        NSString *iconName = [[[[listArray objectAtIndex:indexPath.row]valueForKey:@"weather"]objectAtIndex:0]valueForKey:@"icon"];
        
        if ([self.cache objectForKey:iconName]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.iconImageView.image = [self.cache objectForKey:iconName];
            });
            //NSLog(@"Cached image used, no need to download it");
            
        }else{
            //NSLog(@"Downloading...");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *weatherImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",IMAGE_URL_STRING,iconName]]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.iconImageView setImage:weatherImage];
                     [self.cache setObject:weatherImage forKey:iconName];
                });
                
            });
            
        }
        
    } @catch (NSException *exception) {
        NSLog(@"exception = %@",exception.reason);
    } @finally {
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            NSString *city = placemark.addressDictionary[@"City"];
            NSLog(@"City Name - %@",city);
            [self makeWeatherRequestForCity:city];
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
     
}

-(void)makeWeatherRequestForCity:(NSString *)city{
    
    mainArr=[[NSMutableArray alloc]init]; // to store values
    NSString *urlString =[NSString stringWithFormat:@"%@q=%@&APPID=%@&cnt=15",BASE_URL_STRING,city,kOpenWeatherMapAPIKey];
    
    NSLog(@"url string - %@",urlString);
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    @try{
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *responseData,NSURLResponse *response,NSError *error){
            if (responseData) {
                NSArray *parsedObject= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
                listArray = [parsedObject valueForKey:@"list"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.weatherInfoTable reloadData];
                });
            }
            
        }]resume];
        
    }@catch(NSException *exception){
        NSLog(@"Exception - %@",exception.reason);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
