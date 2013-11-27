//
//  Flight+Create.m
//  inFlightTracker
//
//  Created by Wei Shi on 11/26/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Flight+Create.h"

@implementation Flight (Create)
+ (Flight *)flightWithAirline:(NSString *)airline
                 flightNumber:(NSString *)number
    inManagedObjectContext:(NSManagedObjectContext *)context
{
    Flight *flight = nil;
    
    if ([airline length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Flight"];
        request.predicate = [NSPredicate predicateWithFormat:@"airline == %@ AND flightNumber == %@", airline, number];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            NSLog(@"error %@",error);
        } else if (![matches count]) {
            flight = [NSEntityDescription insertNewObjectForEntityForName:@"Flight"
                                                   inManagedObjectContext:context];
            flight.airline = airline;
            flight.flightNumber=number;
        } else {
            flight = [matches lastObject];
        }
    }
    
    return flight;
}
@end
