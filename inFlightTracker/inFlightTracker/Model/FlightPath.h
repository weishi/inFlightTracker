//
//  FlightPath.h
//  inFlightTracker
//
//  Created by Wei Shi on 11/27/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Flight;

@interface FlightPath : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSString * airline;
@property (nonatomic, retain) NSString * flightNumber;
@property (nonatomic, retain) Flight *flight;

@end
