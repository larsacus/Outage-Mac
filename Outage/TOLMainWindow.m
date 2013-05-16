//
//  TOLMainWindow.m
//  Outage
//
//  Created by Lars Anderson on 5/15/13.
//  Copyright (c) 2013 Lars Anderson. All rights reserved.
//

#import "TOLMainWindow.h"
#import "TOLBatterySession.h"
#import "TOLPowerSource.h"

@interface TOLMainWindow ()

@property (nonatomic, copy) NSArray *batterySessions;
- (NSString *)timeStringFromSeconds:(NSInteger)seconds;
- (NSInteger)totalSecondsOnBatteryForAllSessions;
@end

@implementation TOLMainWindow

- (void)awakeFromNib{
    [super awakeFromNib];
    
    NSLog(@"All sources: %@", [TOLPowerSource allPowerSources]);
    
    [self updateBatteryPercentageIndicator:nil];
    
    NSInteger secondsOnBattery = [self totalSecondsOnBatteryForAllSessions];
    self.timeOnBatteryLabel.stringValue = [self timeStringFromSeconds:secondsOnBattery];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(batterySessionBegan:)
     name:kTOLPowerSessionBeganNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(batterySessionEnded:)
     name:kTOLPowerSessionEndedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(updateBatteryPercentageIndicator:)
     name:kTOLPowerStateChangedNotification object:nil];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self reloadTableData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)batterySessionBegan:(NSNotification *)note{
    
}

- (void)batterySessionEnded:(NSNotification *)note{
    
    NSInteger secondsOnBattery = [self totalSecondsOnBatteryForAllSessions];
    NSString *timeString = [self timeStringFromSeconds:secondsOnBattery];
    self.timeOnBatteryLabel.stringValue = timeString;
    
    [self reloadTableData];
}

- (void)updateBatteryPercentageIndicator:(NSNotification *)note{
    self.timeRemainingIndicator.floatValue = [[TOLPowerSource upsBatterySource] batteryPercentage]*100.f;
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
