//
//  TOLAppDelegate.h
//  Outage
//
//  Created by Lars Anderson on 1/1/13.
//  Copyright (c) 2013 Lars Anderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TOLMainWindowController;

@interface TOLAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) IBOutlet TOLMainWindowController *mainWindowController;

+ (TOLBatterySession *)currentBatterySession;

@end
