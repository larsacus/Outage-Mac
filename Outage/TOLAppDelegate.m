//
//  TOLAppDelegate.m
//  Outage
//
//  Created by Lars Anderson on 1/1/13.
//  Copyright (c) 2013 Lars Anderson. All rights reserved.
//

#import "TOLAppDelegate.h"
#import <IOKit/ps/IOPowerSources.h>
#import "TOLPowerSource.h"
#import "TOLBatterySession.h"

@interface TOLAppDelegate ()

@property (strong, nonatomic) TOLBatterySession *currentBatterySession;
@property (nonatomic, copy) NSArray *batterySessions;
@property (nonatomic, assign) BOOL shouldNotifyOfTerminationPermission;

- (NSString *)timeStringFromSeconds:(NSInteger)seconds;
- (NSInteger)totalSecondsOnBatteryForAllSessions;

@end

@implementation TOLAppDelegate

- (void)endBatterySession{
    NSDate *endDate = [NSDate date];
    self.currentBatterySession.endTime = endDate;
    
    NSInteger secondsThisSession = [endDate timeIntervalSinceDate:self.currentBatterySession.beginTime];
    
    TOLPowerSource *sessionPowerSource = [TOLUserPowerSource powerSourceFromUserPowerSource:self.currentBatterySession.powerSource];
    NSLog(@"Session power source: %@", sessionPowerSource);
    self.currentBatterySession.endCapacityValue = sessionPowerSource.batteryPercentage;
    
    NSLog(@"AC power resumed. Battery session lasted %li seconds.", secondsThisSession);
    
    //TODO:save incomplete sessions
    [self.currentBatterySession.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (error != nil) {
            NSLog(@"Error saving battery session data: %@", error);
        }
        else{
            NSLog(@"Saved current session! %@", self.currentBatterySession);
        }
        
        NSInteger secondsOnBattery = [self totalSecondsOnBatteryForAllSessions];
        NSString *timeString = [self timeStringFromSeconds:secondsOnBattery];
        self.timeOnBatteryLabel.stringValue = timeString;
        
        self.currentBatterySession = nil;
        [self notifyPowerRestored];
        
        [self reloadTableData];
    }];
}

- (void)startBatterySession{
    self.currentBatterySession = [TOLBatterySession MR_createEntity];
    self.currentBatterySession.beginTime = [NSDate date];
    
    TOLPowerSource *providingPowerSource = [TOLPowerSource providingPowerSource];
    self.currentBatterySession.powerSource = [TOLUserPowerSource userPowerSourceFromPowerSource:providingPowerSource];
    self.currentBatterySession.beginCapacityValue = providingPowerSource.batteryPercentage;
    
    NSLog(@"AC power lost beginning at %@", self.currentBatterySession.beginTime);
    
    [self.currentBatterySession.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (error != nil) {
            NSLog(@"Error saving battery session data: %@", error);
        }
        else{
            NSLog(@"Done saving!");
        }
        
        [self notifyPowerLost];
    }];
}

void powerChanged(void *context) {
    TOLAppDelegate *self = (__bridge TOLAppDelegate *)(context);
    
    BOOL isOnBattery = [TOLPowerSource isOnBatteryPower];
    BOOL hasActiveBatterySession = (self.currentBatterySession != nil);
    
    if (isOnBattery &&
        (hasActiveBatterySession == NO)) {
        [self startBatterySession];
    }
    else if ((isOnBattery == NO) &&
             hasActiveBatterySession) {
        [self endBatterySession];
    }
    else{
        [self updateBatteryPercentageIndicator];
    }
}

- (void)updateBatteryPercentageIndicator{
    self.timeRemainingIndicator.floatValue = [[TOLPowerSource upsBatterySource] batteryPercentage]*100.f;
}

- (void)notifyPowerLost{
    
}

- (void)notifyPowerRestored{
    
}

- (void)notifySystemShutdown{
    self.currentBatterySession.wasInturruptedValue = YES;
    [self.currentBatterySession.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    if (self.shouldNotifyOfTerminationPermission) {
        self.shouldNotifyOfTerminationPermission = NO;
        [[NSApplication sharedApplication] replyToApplicationShouldTerminate:YES];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    [self updateBatteryPercentageIndicator];
    
    NSInteger secondsOnBattery = [self totalSecondsOnBatteryForAllSessions];
    self.timeOnBatteryLabel.stringValue = [self timeStringFromSeconds:secondsOnBattery];
    
    NSLog(@"All sources: %@", [TOLPowerSource allPowerSources]);
    
    CFRunLoopSourceRef loop = IOPSNotificationCreateRunLoopSource(powerChanged, (__bridge void *)(self));
    CFRunLoopAddSource(CFRunLoopGetCurrent(), loop, kCFRunLoopDefaultMode);
    CFRelease(loop);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willPowerOff:)
                                                 name:NSWorkspaceWillPowerOffNotification
                                               object:nil];
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self reloadTableData];
}

- (void)reloadTableData{
    self.batterySessions = [TOLBatterySession MR_findAllSortedBy:TOLBatterySessionAttributes.endTime ascending:NO];
    [self.tableView reloadData];
}

#pragma mark - Time Helpers
- (NSString *)timeStringFromSeconds:(NSInteger)seconds{
    NSDate *modifiedDate = [[NSDate date] dateByAddingTimeInterval:-seconds];
    NSUInteger desiredComponents = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *elapsedTimeUnits = [[NSCalendar currentCalendar] components:desiredComponents
                                                                         fromDate:modifiedDate
                                                                           toDate:[NSDate date]
                                                                          options:0];
    
    NSString *timeOnBattery = [NSString stringWithFormat:@"%0.1li:%0.2li:%0.2li", elapsedTimeUnits.hour, elapsedTimeUnits.minute, elapsedTimeUnits.second];
    
    return timeOnBattery;
}

- (NSInteger)totalSecondsOnBatteryForAllSessions{
    NSInteger secondsOnBattery = 0;
    NSArray *allBatterySessions = [TOLBatterySession MR_findAll];
    
    NSLog(@"All sessions: %@", allBatterySessions);
    
    for (TOLBatterySession *batterySession in allBatterySessions) {
        NSInteger secondsThisSession = [batterySession.endTime timeIntervalSinceDate:batterySession.beginTime];
        
        secondsOnBattery += secondsThisSession;
    }
    
    return secondsOnBattery;
}

- (void)applicationWillTerminate:(NSNotification *)notification{
    [MagicalRecord cleanUp];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender{
    if (self.currentBatterySession && self.currentBatterySession.wasInturruptedValue == NO) {
        self.shouldNotifyOfTerminationPermission = YES;
        return NSTerminateLater;
    }
    
    return NSTerminateNow;
}

#pragma mark - System Events
- (void)willPowerOff:(NSNotification *)note{
    if (self.currentBatterySession != nil) {
        NSLog(@"System is powering down during a battery session!");
        [self notifySystemShutdown];
    }
    else{
        NSLog(@"System is powering off without an active battery session");
    }
}

#pragma mark - Table View Delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.batterySessions.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    static NSDateFormatter *__dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __dateFormatter = [[NSDateFormatter alloc] init];
        [__dateFormatter setDateFormat:@"MMM dd, yyyy, h:mm:ss a"];
    });
    
    TOLBatterySession *batterySession = self.batterySessions[row];
    if ([tableColumn.identifier isEqualToString:@"endTime"]) {
        return [__dateFormatter stringFromDate:batterySession.endTime];
    }
    else if([tableColumn.identifier isEqualToString:@"length"]){
        return [self timeStringFromSeconds:[batterySession sessionDuration]];
    }
    return @"bleh";
}

@end
