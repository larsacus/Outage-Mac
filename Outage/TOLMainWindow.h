//
//  TOLMainWindow.h
//  Outage
//
//  Created by Lars Anderson on 5/15/13.
//  Copyright (c) 2013 Lars Anderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TOLMainWindow : NSWindow <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTextField *timeOnBatteryLabel;
@property (weak) IBOutlet NSLevelIndicator *timeRemainingIndicator;
@property (weak) IBOutlet NSTableView *tableView;

@end
