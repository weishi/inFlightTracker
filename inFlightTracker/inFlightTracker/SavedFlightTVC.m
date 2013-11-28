//
//  SavedFlightTVC.m
//  inFlightTracker
//
//  Created by Wei Shi on 11/26/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "SavedFlightTVC.h"
#import "FlightDatabase.h"
#import "NewFlightTVC.h"
#import "FlightDetailTBC.h"
@interface SavedFlightTVC ()

@end

@implementation SavedFlightTVC

- (void)awakeFromNib
{
    NSLog(@"listening context");
    [[NSNotificationCenter defaultCenter] addObserverForName:FlightDatabaseNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      NSLog(@"got context");
                                                      self.context = note.userInfo[FlightDatabaseContext];
                                                  }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"tbc"]){
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Flight *flight = [self.fetchedResultsController objectAtIndexPath:path];
        NSLog(@"segue to tbc selected flight%@%@", flight.airline, flight.flightNumber);
        FlightDetailTBC *tbc=segue.destinationViewController;
        tbc.flight=flight;
        tbc.context=self.context;
        tbc.timePast=0;
    }else{
        NSLog(@"segue to add flight");
        NewFlightTVC *tvc=segue.destinationViewController;
        tvc.context=self.context;
    }
}

#pragma mark - Table view data source
- (void)setContext:(NSManagedObjectContext *)managedObjectContext
{
    _context = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Flight"];
    request.predicate = [self getPredicate];
    request.sortDescriptors = [self getSort];
    [managedObjectContext performBlock:^{
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    }];
}

-(NSPredicate *)getPredicate{
    return nil;
}

-(NSArray *)getSort{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"departureDate"
                                           ascending:NO
                                            selector:@selector(localizedStandardCompare:)]
             ];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"flightCell"];
    
    Flight *flight = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", flight.airline, flight.flightNumber];
    cell.detailTextLabel.text = [formatter stringFromDate:flight.departureDate];
    
    return cell;
}

@end
