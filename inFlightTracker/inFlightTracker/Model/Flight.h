//
//  Flight.h
//  inFlightTracker
//
//  Created by Wei Shi on 11/27/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FlightPath;

@interface Flight : NSManagedObject

@property (nonatomic, retain) NSNumber * actualDepartureTime;
@property (nonatomic, retain) NSString * airline;
@property (nonatomic, retain) NSString * arrivalCity;
@property (nonatomic, retain) NSString * departureCity;
@property (nonatomic, retain) NSDate * departureDate;
@property (nonatomic, retain) NSString * flightNumber;
@property (nonatomic, retain) NSSet *path;
@end

@interface Flight (CoreDataGeneratedAccessors)

- (void)addPathObject:(FlightPath *)value;
- (void)removePathObject:(FlightPath *)value;
- (void)addPath:(NSSet *)values;
- (void)removePath:(NSSet *)values;

@end
