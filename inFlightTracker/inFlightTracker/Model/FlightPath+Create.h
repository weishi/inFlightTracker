//
//  FlightPath+Create.h
//  inFlightTracker
//
//  Created by Wei Shi on 11/27/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "FlightPath.h"

@interface FlightPath (Create)
+ (FlightPath *)flightPathWithDict:(NSDictionary *)dict
       inManagedObjectContext:(NSManagedObjectContext *)context;
@end
