#import "TOLUserPowerSource.h"
#import "TOLPowerSource.h"

@implementation TOLUserPowerSource

// Custom logic goes here.
+ (id)userPowerSourceFromPowerSource:(TOLPowerSource *)powerSource{
    TOLUserPowerSource *ps = [self.class MR_createEntity];
    
    ps.serialNumber = powerSource.hardwareSerialNumber;
    ps.transportTypeValue = powerSource.transportType;
    ps.typeValue = powerSource.type;
    
    return ps;
}

@end
