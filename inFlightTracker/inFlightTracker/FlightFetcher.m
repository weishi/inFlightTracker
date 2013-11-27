//
//  FlightFetcher.m
//  inFlightTracker
//
//  Created by Wei Shi on 11/27/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "FlightFetcher.h"
#define SERVER_URL @"http://www.stanford.edu/~weishi/cgi-bin/flightDB/findFlightPath.php"
@implementation FlightFetcher
+ (NSURL *)URLforPathInAirline:(NSString *)airline flightNumber:(NSString *)number{
    
    NSURL *url= [NSURL URLWithString:[NSString stringWithFormat:@"%@?airline=%@&flightNumber=%@", SERVER_URL, airline, number]];
    return url;
}

@end
