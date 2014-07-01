//
//  WeatherCell.h
//  LiveWeather
//
//  Created by sushrut dhanandhare on 25/06/14.
//  Copyright (c) 2014 sushrut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLAbel;

@end
