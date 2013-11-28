//
//  FlightInfoViewController.m
//  inFlightTracker
//
//  Created by Wei Shi on 11/28/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "FlightInfoViewController.h"
#import "FlightDetailTBC.h"
#import "Flight+Info.h"

@interface FlightInfoViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISwitch *autoDetectSwitch;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *hours;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) NSNumber *duration;
@property (strong, nonatomic) NSDate *takeOffTime;
@end

@implementation FlightInfoViewController
- (IBAction)toggleAutoDetect:(id)sender {
    if([self.autoDetectSwitch isOn]){
        [self.datePicker setHidden:YES];
    }else{
        [self.datePicker setHidden:NO];
    }
    
}
- (IBAction)changeDatePicker:(id)sender {
    self.takeOffTime=self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM. dd HH:mm"];
    self.dateLabel.text = [dateFormatter stringFromDate:self.takeOffTime];
    [self updatePredictionForTime];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewWillAppear: (BOOL) animated {
    FlightDetailTBC *tbc=(FlightDetailTBC *)self.tabBarController;
    self.flight=tbc.flight;
    self.context = tbc.context;
    self.takeOffTime=[NSDate date];
}

-(void) updatePredictionForTime{
    NSDate *curTime=[NSDate date];
    NSTimeInterval past=[curTime timeIntervalSinceDate:self.takeOffTime];
    double total=[Flight durationForFlight:self.flight];
    double left=total-past;
    NSString *hoursStr=[NSString stringWithFormat:@"%.1f hours | %.1f hours",past/3600,left/3600];
    self.hours.text=hoursStr;
    [self.progressBar setProgress:past/total animated:YES];
    FlightDetailTBC *tbc=(FlightDetailTBC *)self.tabBarController;
    tbc.timePast=past;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    self.navigationController.navigationBar.translucent = NO;
}

@end
