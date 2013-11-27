//
//  FlightFetcher.h
//  inFlightTracker
//
//  Created by Wei Shi on 11/27/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlightFetcher : NSObject
+ (NSURL *)URLforPathInAirline:(NSString *)airline flightNumber:(NSString *)number;

@end
