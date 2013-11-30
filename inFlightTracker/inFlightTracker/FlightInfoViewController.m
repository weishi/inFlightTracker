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
#import <CoreMotion/CoreMotion.h>

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
        if([CMMotionActivityManager isActivityAvailable]) {
            CMMotionActivityManager *cm = [[CMMotionActivityManager alloc] init];
            NSDate *today = [NSDate date];
            NSDate *checkSpan = [today dateByAddingTimeInterval:-(3600*12)];
            [cm queryActivityStartingFromDate:checkSpan toDate:today toQueue:[NSOperationQueue mainQueue] withHandler:^(NSArray *activities, NSError *error){
                BOOL foundAutomotive=NO;
                BOOL foundTakeOffTime=NO;
                for(int i=(int)[activities count]-1;i>=0;i--) {
                    CMMotionActivity *a = [activities objectAtIndex:i];
                    if(!foundAutomotive){
                        if (a.automotive){
                            foundAutomotive=YES;
                        }
                    }else{
                        if(a.stationary || a.walking || a.running){
                            self.takeOffTime=a.startDate;
                            NSLog(@"found switch");
                            foundTakeOffTime=YES;
                            break;
                        }
                    }
               }
                if(!foundTakeOffTime){
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @"Auto Detection"
                                          message: @"No in flight motion detected!"
                                          delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                    self.autoDetectSwitch.on=NO;
                    [self.datePicker setHidden:NO];
                }
            }];
        }
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

-(void) viewWillAppear: (BOOL) animated {
    FlightDetailTBC *tbc=(FlightDetailTBC *)self.tabBarController;
    self.flight=tbc.flight;
    self.context = tbc.context;
    self.takeOffTime=nil;
}

-(void) updatePredictionForTime{
    if (self.takeOffTime==nil) {
        return;
    }
    NSDate *curTime=[NSDate date];
    NSTimeInterval past=[curTime timeIntervalSinceDate:self.takeOffTime];
    if(past<=0){
        return;
    }
    double total=[Flight durationForFlight:self.flight];
    double left=total-past;
    NSString *hoursStr=[NSString stringWithFormat:@"%@ | %@",[self formattedTime:past],[self formattedTime:left]];
    self.hours.text=hoursStr;
    [self.progressBar setProgress:past/total animated:YES];
    FlightDetailTBC *tbc=(FlightDetailTBC *)self.tabBarController;
    tbc.timePast=past;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.takeOffTime=nil;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatePredictionForTime) userInfo:nil repeats:YES];

}

- (NSString *)formattedTime:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

- (void)viewDidLayoutSubviews {
    self.navigationController.navigationBar.translucent = NO;
}

@end
