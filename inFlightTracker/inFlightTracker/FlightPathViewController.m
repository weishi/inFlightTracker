//
//  FlightPathViewController.m
//  inFlightTracker
//
//  Created by Wei Shi on 11/26/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "FlightPathViewController.h"

@interface FlightPathViewController ()

@end

@implementation FlightPathViewController

- (void)awakeFromNib
{

}
-(void) viewWillAppear: (BOOL) animated {
    FlightDetailTBC *tbc=(FlightDetailTBC *)self.tabBarController;
    self.flight=tbc.flight;
    self.context = tbc.context;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source
- (void)setContext:(NSManagedObjectContext *)managedObjectContext
{
    _context = managedObjectContext;
    NSLog(@"fetching flightPath for flight %@%@", self.flight.airline,self.flight.flightNumber);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FlightPath"];
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
    return [NSPredicate predicateWithFormat:@"flight == %@", self.flight];;
}

-(NSArray *)getSort{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"timestamp"
                                           ascending:YES
                                            selector:@selector(localizedStandardCompare:)]
             ];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"flightPathCell"];
    
    FlightPath *path = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", path.latitude, path.longitude];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Time: %@", path.timestamp];
    
    return cell;
}



@end
