//
//  Flight+Info.m
//  inFlightTracker
//
//  Created by Wei Shi on 11/28/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Flight+Info.h"
#import "FlightPath.h"

@implementation Flight (Info)
+ (double)durationForFlight:(Flight*)flight{
    NSSet *paths=flight.path;
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES]];
    
    NSArray *sortedPath = [[paths allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    FlightPath *last=[sortedPath lastObject];
    return [last.timestamp doubleValue]*24*3600;
}
@end
