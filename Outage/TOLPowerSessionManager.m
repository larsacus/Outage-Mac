//
//  TOLPowerSessionManager.m
//  Outage
//
//  Created by Lars Anderson on 5/15/13.
//  Copyright (c) 2013 Lars Anderson. All rights reserved.
//

#import "TOLPowerSessionManager.h"
#import "TOLPowerSource.h"

#import <IOKit/ps/IOPowerSources.h>
#import <ParseOSX/ParseOSX.h>

@interface TOLPowerSessionManager ()
@property (strong, nonatomic) TOLBatterySession *currentBatterySession;
@end

@implementation TOLPowerSessionManager

+ (instancetype)sharedManager{
    static TOLPowerSessionManager *__sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedManager = [[TOLPowerSessionManager alloc] init];
    });
    return __sharedManager;
}

- (void)beginMonitoringPowerSupplies{
    CFRunLoopSourceRef loop = IOPSNotificationCreateRunLoopSource(powerChanged, (__bridge void *)(self));
    CFRunLoopAddSource(CFRunLoopGetCurrent(), loop, kCFRunLoopDefaultMode);
    CFRelease(loop);
}

- (void)endBatterySession{
    NSDate *endDate = [NSDate date];
    self.currentBatterySession.endTime = endDate;
    
    NSInteger secondsThisSession = [endDate timeIntervalSinceDate:self.currentBatterySession.beginTime];
    
    TOLPowerSource *sessionPowerSource = [TOLUserPowerSource powerSourceFromUserPowerSource:self.currentBatterySession.powerSource];
    NSLog(@"Session power source: %@", sessionPowerSource);
    self.currentBatterySession.endCapacityValue = sessionPowerSource.batteryPercentage;
    
    NSLog(@"AC power resumed. Battery session lasted %li seconds.", secondsThisSession);
    
    //TODO:save incomplete sessions
    [self.currentBatterySession.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (error != nil) {
            NSLog(@"Error saving battery session data: %@", error);
        }
        else{
            NSLog(@"Saved current session! %@", self.currentBatterySession);
        }
        
        self.currentBatterySession = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kTOLPowerSessionEndedNotification
                                                            object:sessionPowerSource];
        
        [self pushBatterySessionEndedNotification];
    }];
}

- (void)startBatterySession{
    self.currentBatterySession = [TOLBatterySession MR_createEntity];
    self.currentBatterySession.beginTime = [NSDate date];
    
    TOLPowerSource *providingPowerSource = [TOLPowerSource providingPowerSource];
    self.currentBatterySession.powerSource = [TOLUserPowerSource userPowerSourceFromPowerSource:providingPowerSource];
    self.currentBatterySession.beginCapacityValue = providingPowerSource.batteryPercentage;
    
    NSLog(@"AC power lost beginning at %@", self.currentBatterySession.beginTime);
    
    [self.currentBatterySession.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (error != nil) {
            NSLog(@"Error saving battery session data: %@", error);
        }
        else{
            NSLog(@"Done saving!");
        }
        
     [[NSNotificationCenter defaultCenter]
      postNotificationName:kTOLPowerSessionBeganNotification
      object:providingPowerSource];
        
        [self pushBatterySessionStartedNotification];
    }];
}

void powerChanged(void *context) {
    TOLPowerSessionManager *self = (__bridge TOLPowerSessionManager *)(context);
    
    BOOL isOnBattery = [TOLPowerSource isOnBatteryPower];
    BOOL hasActiveBatterySession = (self.currentBatterySession != nil);
    
    if (isOnBattery &&
        (hasActiveBatterySession == NO)) {
        [self startBatterySession];
    }
    else if ((isOnBattery == NO) &&
             hasActiveBatterySession) {
        [self endBatterySession];
    }
    else{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kTOLPowerStateChangedNotification
         object:nil];
    }
}

#pragma mark - Push Notifications
- (void)pushGlobalMessageWithAlertText:(NSString *)alertString{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.parse.com/1/"];
    NSURL *url = [NSURL URLWithString:@"push" relativeToURL:baseURL];
    NSMutableURLRequest *pushRequest = [NSMutableURLRequest requestWithURL:url];
    [pushRequest setHTTPMethod:@"POST"];
    NSString *parseAppId = @"xT2nmVvLDFHg4fdxs84y7EDVeDLq7l84XfHjnkN7";
    NSString *parseRestAPIKey = @"R5RwNRZcP3fQX2YUM2QW5upU2vctgkiXgGkXcwlw";
    
    NSDictionary *headerFields = @{@"X-Parse-Application-Id": parseAppId,
                                   @"X-Parse-REST-API-Key": parseRestAPIKey,
                                   @"Content-Type": @"application/json"};
    [pushRequest setAllHTTPHeaderFields:headerFields];
    
    NSDictionary *pushPayload = @{@"where": @{@"deviceType": @"ios"},
                                  @"data": @{@"alert":alertString,
                                             @"sound":@""}};
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:pushPayload
                                                       options:0
                                                         error:&error];
    
    if (error == nil) {
        [pushRequest setHTTPBody:jsonData];
        
        [NSURLConnection
         sendAsynchronousRequest:pushRequest
         queue:[NSOperationQueue mainQueue]
         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
             if (error != nil) {
                 NSLog(@"Error sending push: %@", error);
             }
             else{
                 NSLog(@"Recieved successful response: %@", response);
             }
         }];
    }
    else{
        NSLog(@"Error serializing json: %@", error);
    }
}

- (void)pushBatterySessionStartedNotification{
    NSString *alertString = [NSString stringWithFormat:@"The server %@ is now running on battery power!", [[NSHost currentHost] name]];
    
    [self pushGlobalMessageWithAlertText:alertString];
}

- (void)pushBatterySessionEndedNotification{
    NSString *alertString = [NSString stringWithFormat:@"The server %@ is back on AC power.", [[NSHost currentHost] name]];
    
    [self pushGlobalMessageWithAlertText:alertString];
}

@end
