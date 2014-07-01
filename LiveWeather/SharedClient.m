//
//  SharedClient.m
//  LiveWeather
//
//  Created by sushrut dhanandhare on 05/06/14.
//  Copyright (c) 2014 sushrut. All rights reserved.
//

#import "SharedClient.h"


@implementation SharedClient

#pragma mark - Initialization -

+ (SharedClient *)sharedInstance
{
    static dispatch_once_t pred;
    static SharedClient *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedClient alloc] init];
        shared.cityArray = [[NSMutableArray alloc]init];
    });
    
	return shared;
}

@end
