//
//  SharedClient.h
//  LiveWeather
//
//  Created by sushrut dhanandhare on 05/06/14.
//  Copyright (c) 2014 sushrut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedClient : NSObject



@property(nonatomic,strong)NSMutableArray *cityArray;


+ (SharedClient *)sharedInstance;


@property (nonatomic, copy, readonly) NSDate *reportTime;


@end
