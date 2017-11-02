//
//  AppleMenuBar.swift
//  DesktopMachineIdentifier
//
//  Created by Jon Cardasis on 9/26/17.
//  Copyright © 2017 Jonathan Cardasis. All rights reserved.
//

import Cocoa

/// This class serves to return info about the
/// Apple Menu bar present at the top of macOS screens
class AppleMenuBar {
    
    static let SystemThemeKey = "AppleInterfaceStyle"
    static let SystemThemeChangedNotificationKey = "AppleInterfaceThemeChangedNotification"
    
    static private var lightMenuBarColorDict = [CGDirectDisplayID: NSColor]()
    
    enum AppleMenuBarTheme {
        case light
        case dark
        
        /// Will return the opposite theme to the current one
        func inverse() -> AppleMenuBarTheme {
            if self == .light {
                return .dark
            }
            return .light
        }
    }
    
    
    static func currentTheme() -> AppleMenuBarTheme {
        // "AppleInterfaceStyle" will be nil in normal mode or "Dark" if in dark mode
        
        if UserDefaults.standard.string(forKey: SystemThemeKey) != nil {
            return .dark
        }
        return .light
    }
    
    
    static func color(for theme: AppleMenuBarTheme, screen: NSScreen) -> NSColor {
        if theme == .dark {
            return NSColor(red: 24/255.0, green: 24/255.0, blue: 24/255.0, alpha: 1)
        }
        
        let defaultLightColor = NSColor(red: 203/255.0, green: 203/255.0, blue: 203/255.0, alpha: 1)
        
        if let screenId = screen.deviceDescription["NSScreenNumber"] as? NSNumber {
            let displayId = screenId.uint32Value
            print("display: \(displayId)")
            
            if let cachedLightColor = lightMenuBarColorDict[displayId] {
                return cachedLightColor
            }
            else {
                let color = lightColor(for: displayId) ?? defaultLightColor
                lightMenuBarColorDict[displayId] = color // Cache the color for the screen
                print("Light color: \(color)")
                return color
            }
        }
        else {
            return defaultLightColor
        }
        
    }
    
    private static func lightColor(for displayId: CGDirectDisplayID) -> NSColor? {
        // Get color at pixel (1,1)
        guard let image = CGDisplayCreateImage(displayId, rect: CGRect(x: 1, y: 1, width: 1, height: 1)) else {
            return nil
        }
        let bitmap = NSBitmapImageRep(cgImage: image)
        guard let color = bitmap.colorAt(x: 0, y: 0) else {
            return nil
        }
        
        return (color.alphaComponent > 0.0) ? color : nil
    }
    
}
