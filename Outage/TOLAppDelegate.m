//
//  TOLAppDelegate.m
//  Outage
//
//  Created by Lars Anderson on 1/1/13.
//  Copyright (c) 2013 Lars Anderson. All rights reserved.
//

#import "TOLAppDelegate.h"
#import "TOLBatterySession.h"
#import "TOLMainWindow.h"
#import "TOLPowerSessionManager.h"
#import "TOLMainWindowController.h"

static TOLBatterySession *__currentBatterySession;

@interface TOLAppDelegate ()

@property (nonatomic, assign) BOOL shouldNotifyOfTerminationPermission;

@end

@implementation TOLAppDelegate

#pragma mark - Application Lifecycle
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    [[TOLPowerSessionManager sharedManager] beginMonitoringPowerSupplies];
    
    [self.mainWindowController showWindow:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willPowerOff:)
                                                 name:NSWorkspaceWillPowerOffNotification
                                               object:nil];
}

- (void)applicationWillTerminate:(NSNotification *)notification{
    [MagicalRecord cleanUp];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender{
    if ((__currentBatterySession != nil) &&
        __currentBatterySession.wasInturruptedValue == NO) {
        self.shouldNotifyOfTerminationPermission = YES;
        return NSTerminateLater;
    }
    
    return NSTerminateNow;
}

#pragma mark - Static Storage
+ (TOLBatterySession *)currentBatterySession{
    return __currentBatterySession;
}

+ (void)setCurrentBatterySession:(TOLBatterySession *)newBatterySession{
    if ([__currentBatterySession isEqual:newBatterySession] == NO) {
        __currentBatterySession = newBatterySession;
    }
}

#pragma mark - System Events
- (void)notifySystemShutdown{
    __currentBatterySession.wasInturruptedValue = YES;
    [__currentBatterySession.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    if (self.shouldNotifyOfTerminationPermission) {
        self.shouldNotifyOfTerminationPermission = NO;
        [[NSApplication sharedApplication] replyToApplicationShouldTerminate:YES];
    }
}

- (void)willPowerOff:(NSNotification *)note{
    if (__currentBatterySession != nil) {
        NSLog(@"System is powering down during a battery session!");
        [self notifySystemShutdown];
    }
    else{
        NSLog(@"System is powering off without an active battery session");
    }
}

@end
