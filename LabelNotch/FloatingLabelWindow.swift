//
//  FloatingLabelWindow.swift
//  DesktopMachineIdentifier
//
//  Created by Jon Cardasis on 9/18/17.
//  Copyright © 2017 Jonathan Cardasis. All rights reserved.
//

import AppKit

class FloatingLabelWindow: NSWindow {
    
    override init(contentRect: NSRect, styleMask style: NSWindowStyleMask, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: bufferingType, defer: flag)
        
        //level = Int(CGWindowLevelForKey(CGWindowLevelKey.desktopWindow)) - 1 // Set display level behind desktop icons
        collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
    }
    
    // Override values to ensure the window handles expose/spaces by not moving
    override var canBecomeMain: Bool { return false }
    override var canBecomeKey: Bool { return false }
    
}
