//
//  Flight+Create.h
//  inFlightTracker
//
//  Created by Wei Shi on 11/26/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Flight.h"

@interface Flight (Create)
+ (Flight *)flightWithAirline:(NSString *)airline
                 flightNumber:(NSString *)number
       inManagedObjectContext:(NSManagedObjectContext *)context;
@end
