//
//  NewFlightTVC.m
//  inFlightTracker
//
//  Created by Wei Shi on 11/26/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "NewFlightTVC.h"


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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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
