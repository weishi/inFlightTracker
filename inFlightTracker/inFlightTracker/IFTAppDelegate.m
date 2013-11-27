//
//  IFTAppDelegate.m
//  inFlightTracker
//
//  Created by Wei Shi on 11/9/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "IFTAppDelegate.h"
#import "FlightDatabase.h"
@implementation IFTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSURL *documentDirectory=[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]firstObject];
    NSString *documentName=@"FlightDoc";
    NSURL *url=[documentDirectory URLByAppendingPathComponent:documentName];
    UIManagedDocument *document=[[UIManagedDocument alloc] initWithFileURL:url];
    BOOL fileExists=[[NSFileManager defaultManager]fileExistsAtPath:[url path]];
    if(fileExists){
        [document openWithCompletionHandler:^(BOOL success){
            if(success){
                self.document=document;
                [self documentIsReady];
            }else{
                NSLog(@"failed to open doc exists");
            }
        }];
    }else{
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if(success){
                self.document=document;
                [self documentIsReady];
            }else{
                NSLog(@"failed to create doc");
            }
        }];
    }
    NSLog(@"created doc");
    return YES;
}

-(void)documentIsReady{
    if (self.document.documentState == UIDocumentStateNormal) {
        self.flightDatabaseContext = self.document.managedObjectContext;
        NSDictionary *userInfo = self.flightDatabaseContext ? @{ FlightDatabaseContext : self.flightDatabaseContext } : nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:FlightDatabaseNotification
                                                            object:self
                                                          userInfo:userInfo];
        NSLog(@"sent notification doc");

    }
}

@end
