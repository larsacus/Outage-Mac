#import "TOLBatterySession.h"

NSString * const kTOLPowerSessionBeganNotification = @"TOLPowerSessionBegan";
NSString * const kTOLPowerSessionEndedNotification = @"TOLPowerSessionEnded";
NSString * const kTOLPowerStateChangedNotification = @"TOLPowerStateChanged";

@implementation TOLBatterySession

- (NSTimeInterval)sessionDuration{
    NSDate *beginTime = self.beginTime;
    NSDate *endTime = self.endTime;

    NSTimeInterval duration = [endTime timeIntervalSinceDate:beginTime];
    return duration;
}

@end
