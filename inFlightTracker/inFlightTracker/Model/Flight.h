//
//  Flight.h
//  inFlightTracker
//
//  Created by Wei Shi on 11/26/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FlightPath;

@interface Flight : NSManagedObject

@property (nonatomic, retain) NSString * airline;
@property (nonatomic, retain) NSString * flightNumber;
@property (nonatomic, retain) NSDate * departureDate;
@property (nonatomic, retain) NSNumber * actualDepartureTime;
@property (nonatomic, retain) NSString * departureCity;
@property (nonatomic, retain) NSString * arrivalCity;
@property (nonatomic, retain) FlightPath *path;

@end
