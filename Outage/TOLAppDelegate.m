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
    
    if ((BOOL)[TOLPowerSource isOnBatteryPower] == YES) {
        NSLog(@"Running on battery power");
        
        if (self.lostPowerDate == nil) {
            self.lostPowerDate = [NSDate date];
        }
    }
    else{
        NSLog(@"Not running on battery power");
        
        if (self.lostPowerDate != nil) {
            NSInteger secondsThisSession = [[NSDate date] timeIntervalSinceDate:self.lostPowerDate];
            
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
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self.timeRemainingIndicator setFloatValue:0.f];
    
    self.timeRemainingIndicator.floatValue = [[TOLPowerSource upsBatterySource] batteryPercentage]*100.f;
    self.timeOnBatteryLabel.stringValue = @"00:00:00";
    
    NSLog(@"%@", [TOLPowerSource allPowerSources]);
    
    CFRunLoopSourceRef loop = IOPSNotificationCreateRunLoopSource(powerChanged, (__bridge void *)(self));
    CFRunLoopAddSource(CFRunLoopGetCurrent(), loop, kCFRunLoopDefaultMode);
    CFRelease(loop);
}



@end
