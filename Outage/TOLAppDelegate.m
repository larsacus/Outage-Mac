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

- (NSString *)timeStringFromSeconds:(NSInteger)seconds;
- (NSInteger)totalSecondsOnBatteryForAllSessions;

@end

@implementation TOLAppDelegate

void powerChanged(void *context) {
    TOLAppDelegate *self = (__bridge TOLAppDelegate *)(context);
    
    if (([TOLPowerSource isOnBatteryPower] == YES) &&
        (self.currentBatterySession == nil)) {
        self.currentBatterySession = [TOLBatterySession MR_createEntity];
        self.currentBatterySession.beginTime = [NSDate date];
        
        TOLPowerSource *providingPowerSource = [TOLPowerSource providingPowerSource];
        self.currentBatterySession.powerSource = [TOLUserPowerSource userPowerSourceFromPowerSource:providingPowerSource];
        self.currentBatterySession.beginCapacityValue = providingPowerSource.batteryPercentage;
        
        NSLog(@"AC power lost beginning at %@", self.currentBatterySession.beginTime);
        
        [self.currentBatterySession.managedObjectContext MR_saveInBackgroundCompletion:^{
            NSLog(@"Done saving");
        }];
    }
    else if (self.currentBatterySession != nil) {
        NSDate *endDate = [NSDate date];
        self.currentBatterySession.endTime = endDate;
        
        NSInteger secondsThisSession = [endDate timeIntervalSinceDate:self.currentBatterySession.beginTime];
        
        TOLPowerSource *sessionPowerSource = [TOLUserPowerSource powerSourceFromUserPowerSource:self.currentBatterySession.powerSource];
        NSLog(@"Session power source: %@", sessionPowerSource);
        self.currentBatterySession.endCapacityValue = sessionPowerSource.batteryPercentage;
        
        NSLog(@"AC power resumed. Battery session lasted %li seconds.", secondsThisSession);
        
        //TODO:save incomplete sessions
        [self.currentBatterySession.managedObjectContext MR_saveInBackgroundCompletion:^{
            NSLog(@"saved current session: %@", self.currentBatterySession);
            
            self.timeOnBatteryLabel.stringValue = [self timeStringFromSeconds:[self totalSecondsOnBatteryForAllSessions]];
            
            self.currentBatterySession = nil;
        }];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    self.timeRemainingIndicator.floatValue = [[TOLPowerSource upsBatterySource] batteryPercentage]*100.f;
    
    NSInteger secondsOnBattery = [self totalSecondsOnBatteryForAllSessions];
    self.timeOnBatteryLabel.stringValue = [self timeStringFromSeconds:secondsOnBattery];
    
    CFRunLoopSourceRef loop = IOPSNotificationCreateRunLoopSource(powerChanged, (__bridge void *)(self));
    CFRunLoopAddSource(CFRunLoopGetCurrent(), loop, kCFRunLoopDefaultMode);
    CFRelease(loop);
}

- (NSString *)timeStringFromSeconds:(NSInteger)seconds{
    NSDate *modifiedDate = [[NSDate date] dateByAddingTimeInterval:-seconds];
    NSUInteger desiredComponents = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *elapsedTimeUnits = [[NSCalendar currentCalendar] components:desiredComponents
                                                                         fromDate:modifiedDate
                                                                           toDate:[NSDate date]
                                                                          options:0];
    
    NSString *timeOnBattery = [NSString stringWithFormat:@"%0.2li:%0.2li:%0.2li", elapsedTimeUnits.hour, elapsedTimeUnits.minute, elapsedTimeUnits.second];
    
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

@end
