#import "TOLBatterySession.h"

@implementation TOLBatterySession

- (NSTimeInterval)sessionDuration{
    NSDate *beginTime = self.beginTime;
    NSDate *endTime = self.endTime;

    NSTimeInterval duration = [endTime timeIntervalSinceDate:beginTime];
    return duration;
}

@end
