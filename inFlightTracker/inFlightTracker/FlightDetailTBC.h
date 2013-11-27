//
//  FlightDetailTBC.h
//  inFlightTracker
//
//  Created by Wei Shi on 11/26/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flight.h"
@interface FlightDetailTBC : UITabBarController
@property (nonatomic, strong) Flight *flight;
@property (nonatomic, strong) NSManagedObjectContext *context;
@end
