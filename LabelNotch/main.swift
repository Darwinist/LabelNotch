//
//  main.swift
//  DesktopMachineIdentifier
//
//  Created by Jon Cardasis on 9/18/17.
//  Copyright © 2017 Jonathan Cardasis. All rights reserved.
//

import Cocoa

let delegate = AppDelegate()
NSApplication.shared().delegate = delegate

let _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv) // Start application loop
