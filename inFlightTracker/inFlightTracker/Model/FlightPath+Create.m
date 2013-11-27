//
//  FlightPath+Create.m
//  inFlightTracker
//
//  Created by Wei Shi on 11/27/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "FlightPath+Create.h"

@implementation FlightPath (Create)
+ (FlightPath *)flightPathWithDict:(NSDictionary *)dict
            inManagedObjectContext:(NSManagedObjectContext *)context{
    FlightPath *path = nil;
    NSString *airline=[dict valueForKey:@"airline"];
    NSString *flightNumber=[dict valueForKey:@"flightNumber"];
    NSString *timestamp=[dict valueForKey:@"timestamp"];
    NSString *latitude=[dict valueForKey:@"latitude"];
    NSString *longitude=[dict valueForKey:@"longitude"];
    if ([airline length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FlightPath"];
        request.predicate = [NSPredicate predicateWithFormat:@"airline == %@ AND flightNumber == %@ AND timestamp == %@", airline, flightNumber, timestamp];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            NSLog(@"error %@",error);
        } else if (![matches count]) {
            path = [NSEntityDescription insertNewObjectForEntityForName:@"FlightPath"
                                                   inManagedObjectContext:context];
            path.airline = airline;
            path.flightNumber=flightNumber;
            path.timestamp=[NSNumber numberWithFloat:[timestamp floatValue]];
            path.latitude=[NSNumber numberWithFloat:[latitude floatValue]];
            path.longitude=[NSNumber numberWithFloat:[longitude floatValue]];
        } else {
            path = [matches lastObject];
        }
    }
    
    return path;
}

@end
