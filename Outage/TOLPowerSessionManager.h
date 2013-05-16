//
//  TOLPowerSessionManager.h
//  Outage
//
//  Created by Lars Anderson on 5/15/13.
//  Copyright (c) 2013 Lars Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOLPowerSessionManager : NSObject

+ (instancetype)sharedManager;
- (void)beginMonitoringPowerSupplies;

@end
