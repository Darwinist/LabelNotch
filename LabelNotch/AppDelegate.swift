//
//  AppDelegate.swift
//  DesktopMachineIdentifier
//
//  Created by Jon Cardasis on 9/18/17.
//  Copyright © 2017 Jonathan Cardasis. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    /// The label windows being displayed on each Screen
    var windows = [FloatingLabelWindow]()
    
    /// The text to display in the floating label
    var textToDisplay: String = "" // will be filled by userdefaults
    
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupWindows()
        listenForThemeChange()
    }
    
    func applicationDidChangeScreenParameters(_ notification: Notification) {
        print("[Info] Screen Changed Size")
        setupWindows()
    }
    
    /// Listen for if the theme changes between light or dark
    func listenForThemeChange() {
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(darkModeChanged(_:)), name: NSNotification.Name(rawValue: AppleMenuBar.SystemThemeChangedNotificationKey), object: nil)
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }
    
    func darkModeChanged(_ notification: Notification) {
        setupWindows()
    }
    
    //-------------------------------------------------
    // HANDLE WINDOW LAYOUT
    //-------------------------------------------------
    
    fileprivate func setupWindows() {
        guard let screens = NSScreen.screens() else { return }
        
        removeAllViews()
        for screen in screens {
            
            let window: FloatingLabelWindow = createWindow(in: screen)
            windows.append(window)
            
            // Setup Color Scheme
            let currentMenuBarTheme = AppleMenuBar.currentTheme()
            let backgroundViewColor = AppleMenuBar.color(for: currentMenuBarTheme, screen: screen)
            let titleColor = AppleMenuBar.color(for: currentMenuBarTheme.inverse(), screen: screen)
            
            // Create Label Tab
            let appleMenuBarHeight = screen.frame.height - screen.visibleFrame.height - (screen.visibleFrame.origin.y - screen.frame.origin.y) - 1
            //print("Actual: \(screen.frame)")
            //print("Visble: \(screen.visibleFrame)")
            
            var workingFrame = window.frame
            workingFrame.size.height = screen.frame.height - appleMenuBarHeight
            
            textToDisplay = PropertyListManager.shared.title // Obtain text to show from plist
            let label = createTextLabelForWindow(window, text: textToDisplay, inRect: workingFrame)
            label.alignment = .center
            label.textColor = titleColor
            
            // Create Flare View Below Label
            let flareView = generateFlareView(containsRect: label.frame)
            flareView.layer?.backgroundColor = backgroundViewColor.cgColor
            
            // Fix vertical positioning for flareView and label after generation
            var fixFlareFrame = flareView.frame
            fixFlareFrame.origin.y = screen.frame.height - appleMenuBarHeight - flareView.frame.height
            let verticalShift = flareView.frame.origin.y - fixFlareFrame.origin.y
            
            var fixLabelFrame = label.frame
            fixLabelFrame.origin.y -= verticalShift
            
            label.frame = fixLabelFrame
            flareView.frame = fixFlareFrame

            // Add Views
            window.contentView?.addSubview(flareView)
            window.contentView?.addSubview(label)
            
            // Configure and present window
            window.contentView!.wantsLayer = true // Need in order for Core Animation to to respect drawing process of subviews (i.e. flareView background)
            window.backgroundColor = .clear
            window.isOpaque = false
            window.orderFront(nil) // Displays window on screen
        }
    }
    
    private func createWindow(in screen: NSScreen) -> FloatingLabelWindow {
        let screenFrame = screen.frame
        
        let windowFrame = CGRect(x: screenFrame.origin.x,
                                 y: screenFrame.origin.y,
                                 width: screenFrame.size.width,
                                 height: screenFrame.size.height)
        
        let window = FloatingLabelWindow(contentRect: windowFrame, styleMask: .borderless, backing: .buffered, defer: true)
        
        // Set the proper frame to display
        window.setFrame(windowFrame, display: true)
        
        return window
    }
    
    private func createTextLabelForWindow(_ window: NSWindow, text: String, inRect: CGRect) -> NSTextField {
        
        // Dynamicly determine the best size to fit for the text in bounds given
        let systemFont = NSFont.systemFont(ofSize: 13, weight: 400)
 
        let label = NSTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.stringValue = text
        label.font = systemFont
        
        // Remove background coloring
        label.isEditable = false
        label.drawsBackground = false
        label.backgroundColor = nil
        
        label.sizeToFit() // obtain initial bounding box
        
        // Update label to fit in the center of the screen
        label.frame = CGRect(x: inRect.midX - label.frame.width / 2.0,
                             y: inRect.maxY - label.frame.height,
                             width: label.frame.width,
                             height: label.attributedStringValue.size().height)
        
        label.isBordered = false
        
        return label
    }
    
    
    private func generateFlareView(containsRect: CGRect, cornerRadius: CGFloat = 12.0) -> NSView {
        
        let view = NSView(frame: containsRect.insetBy(dx: -containsRect.width/10.0, dy: -containsRect.height/10.0))
        
        view.wantsLayer = true
        view.layer?.masksToBounds = true

        // Draw mask clockwise
        let path = NSBezierPath()
        path.move(to: CGPoint(x: 0, y: view.bounds.height))
        path.line(to: CGPoint(x: view.bounds.width, y: view.bounds.height))
        path.line(to: CGPoint(x: view.bounds.width, y: cornerRadius)) // point before arc (bottom, right)
        path.appendArc(withCenter: CGPoint(x: view.bounds.width - cornerRadius, y: cornerRadius),
                       radius: cornerRadius,
                       startAngle: 0,
                       endAngle: -90,
                       clockwise: true) // Bottom right curve
        path.line(to: CGPoint(x: cornerRadius, y: 0))
        path.appendArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius),
                        radius: cornerRadius,
                        startAngle: 90,
                        endAngle: 180,
                        clockwise: true) // Bottom left curve
        path.close()
        
        // Apply layer mask
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        view.layer?.mask = maskLayer
        
        return view
    }
    
    private func removeAllViews() {
        for window in windows {
            guard let contentView = window.contentView else { continue }
            
            for subview in contentView.subviews {
                subview.removeFromSuperview()
            }
            window.close()
        }
        
        windows.removeAll()
    }
    
}
