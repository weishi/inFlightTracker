//
//  NewFlightTVC.m
//  inFlightTracker
//
//  Created by Wei Shi on 11/26/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "NewFlightTVC.h"
#import "FlightFetcher.h"
#import "FlightPath+Create.h"

@interface NewFlightTVC ()
@property (weak, nonatomic) IBOutlet UITextField *airlineField;
@property (weak, nonatomic) IBOutlet UITextField *flightNumberField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateField;

@end

@implementation NewFlightTVC

- (IBAction)saveFlight:(id)sender {

    
    Flight *flight=[Flight flightWithAirline:self.airlineField.text flightNumber:self.flightNumberField.text inManagedObjectContext:self.context];
    flight.departureDate=self.dateField.date;
    NSLog(@"%@",flight.airline);
    NSLog(@"%@",flight.flightNumber);
    NSLog(@"%@",flight.departureDate);
    //TODO create path
    [self fetchPathForFlight:flight intoContext:self.context];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)fetchPathForFlight:(Flight *)flight intoContext:(NSManagedObjectContext *)context{
    NSURL *pathURL=[FlightFetcher URLforPathInAirline:flight.airline flightNumber:flight.flightNumber];
    NSData *data=[NSData dataWithContentsOfURL:pathURL];
    NSArray *pathInfoDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:0];
    NSMutableSet *pathSet=[[NSMutableSet alloc]init];
    for(NSDictionary *entry in pathInfoDic){
        FlightPath *path=[FlightPath flightPathWithDict:entry inManagedObjectContext:context];
        path.flight=flight;
        [pathSet addObject:path];
        NSLog(@"new path %@ for flight %@%@",path.timestamp, flight.airline, flight.flightNumber);
    }
    flight.path=pathSet;
//    dispatch_queue_t fetchQ = dispatch_queue_create("flight fetcher", NULL);
//    // put a block to do the fetch onto that queue
//    dispatch_async(fetchQ, ^{
//        NSURL *pathURL=[FlightFetcher URLforPathInAirline:flight.airline flightNumber:flight.flightNumber];
//        NSData *data=[NSData dataWithContentsOfURL:pathURL];
//        NSArray *pathInfoDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:0];
//        NSMutableSet *pathSet=[[NSMutableSet alloc]init];
//        for(NSDictionary *entry in pathInfoDic){
//            FlightPath *path=[FlightPath flightPathWithDict:entry inManagedObjectContext:context];
//            path.flight=flight;
//            [pathSet addObject:path];
//            NSLog(@"new path %@ for flight %@%@",path.timestamp, flight.airline, flight.flightNumber);
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            flight.path=pathSet;
//
//        });
//    });
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];

}
- (void) hideKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Table view data source


@end
