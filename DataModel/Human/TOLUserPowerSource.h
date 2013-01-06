#import "_TOLUserPowerSource.h"

@class TOLPowerSource;

@interface TOLUserPowerSource : _TOLUserPowerSource {}

+ (id)userPowerSourceFromPowerSource:(TOLPowerSource *)powerSource;
+ (TOLPowerSource *)powerSourceFromUserPowerSource:(TOLUserPowerSource *)userPowerSource;

@end
