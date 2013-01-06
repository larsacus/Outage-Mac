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

@interface TOLAppDelegate ()

@property (nonatomic) NSInteger secondsOnBattery;
@property (strong, nonatomic) NSDate *lostPowerDate;

@end

@implementation TOLAppDelegate

void powerChanged(void *context) {
    TOLAppDelegate *self = (__bridge TOLAppDelegate *)(context);
    
    if (([TOLPowerSource isOnBatteryPower] == YES) &&
        (self.lostPowerDate == nil)) {
        self.lostPowerDate = [NSDate date];
        
        NSLog(@"AC power lost beginning at %@", self.lostPowerDate);
    }
    else if (self.lostPowerDate != nil) {
        NSInteger secondsThisSession = [[NSDate date] timeIntervalSinceDate:self.lostPowerDate];
        
        NSLog(@"AC power resumed. Battery session lasted %li seconds.", secondsThisSession);
        
        NSDate *modifiedDate = [self.lostPowerDate dateByAddingTimeInterval:-self.secondsOnBattery];
        
        self.secondsOnBattery += secondsThisSession;
        
        NSUInteger desiredComponents = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *elapsedTimeUnits = [[NSCalendar currentCalendar] components:desiredComponents
                                                                             fromDate:modifiedDate
                                                                               toDate:[NSDate date]
                                                                              options:0];
        
        NSString *timeOnBattery = [NSString stringWithFormat:@"%0.2li:%0.2li:%0.2li", elapsedTimeUnits.hour, elapsedTimeUnits.minute, elapsedTimeUnits.second];
        self.timeOnBatteryLabel.stringValue = timeOnBattery;
        
        self.lostPowerDate = nil;
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self.timeRemainingIndicator setFloatValue:0.f];
    
    self.timeRemainingIndicator.floatValue = [[TOLPowerSource upsBatterySource] batteryPercentage]*100.f;
    self.timeOnBatteryLabel.stringValue = @"00:00:00";
    
    NSArray *allPowerSources = [TOLPowerSource allPowerSources];
    NSLog(@"%@", allPowerSources);
    
    for (TOLPowerSource *powerSource in allPowerSources) {
        TOLUserPowerSource *userPowerSource = [TOLUserPowerSource MR_findFirstByAttribute:@"serialNumber" withValue:powerSource.hardwareSerialNumber];
        
        if (userPowerSource == nil) {
            userPowerSource = [TOLUserPowerSource userPowerSourceFromPowerSource:powerSource];
        }
    }
    
    CFRunLoopSourceRef loop = IOPSNotificationCreateRunLoopSource(powerChanged, (__bridge void *)(self));
    CFRunLoopAddSource(CFRunLoopGetCurrent(), loop, kCFRunLoopDefaultMode);
    CFRelease(loop);
}



@end
