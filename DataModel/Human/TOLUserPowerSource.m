#import "TOLUserPowerSource.h"
#import "TOLPowerSource.h"

@implementation TOLUserPowerSource

// Custom logic goes here.
+ (id)userPowerSourceFromPowerSource:(TOLPowerSource *)powerSource{
    
    TOLUserPowerSource *ps;
    if (powerSource.hardwareSerialNumber != nil) {
        ps = [TOLUserPowerSource MR_findFirstByAttribute:@"serialNumber" withValue:powerSource.name];
    }
    else{
        ps = [TOLUserPowerSource MR_findFirstByAttribute:@"name" withValue:powerSource.name];
    }
    
    if (ps == nil) {
        ps = [self MR_createEntity];
        
        ps.serialNumber = powerSource.hardwareSerialNumber;
        ps.transportTypeValue = powerSource.transportType;
        ps.typeValue = powerSource.type;
    }
    
    return ps;
}

+ (TOLPowerSource *)powerSourceFromUserPowerSource:(TOLUserPowerSource *)userPowerSource{
    NSArray *allPowerSources = [TOLPowerSource allPowerSources];
    
    for (TOLPowerSource *powerSource in allPowerSources) {
        if ([powerSource.hardwareSerialNumber isEqualToString:userPowerSource.serialNumber] &&
            ([powerSource.hardwareSerialNumber isEqualToString:@""] == NO)) {
            return powerSource;
        }
        else if([powerSource.name isEqualToString:userPowerSource.name] &&
                ([powerSource.name isEqualToString:@""] == NO)){
            return powerSource;
        }
    }
    
    return nil;
}

@end
