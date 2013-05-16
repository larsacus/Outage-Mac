#import "_TOLBatterySession.h"

extern NSString * const kTOLPowerSessionBeganNotification;
extern NSString * const kTOLPowerSessionEndedNotification;
extern NSString * const kTOLPowerStateChangedNotification;

@interface TOLBatterySession : _TOLBatterySession {}

- (NSTimeInterval)sessionDuration;

@end
