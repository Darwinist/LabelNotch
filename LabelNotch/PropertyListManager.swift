//
//  PropertyListManager.swift
//  DesktopMachineIdentifier
//
//  Created by Jon Cardasis on 10/31/17.
//  Copyright © 2017 Jonathan Cardasis. All rights reserved.
//

import Cocoa


class PropertyListManager: NSObject {
    
    static let shared = PropertyListManager()
    
    /// The currently set title
    var title: String {
        get {
            return UserDefaults.standard.value(forKey: PropertyListKey.titleKey) as! String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: PropertyListKey.titleKey)
        }
    }
    
    
    override init() {
        super.init()
        
        // Create property file if it does not exist
        if UserDefaults.standard.value(forKey: PropertyListKey.titleKey) == nil {
            UserDefaults.standard.set(machineHostname ?? "Title", forKey: PropertyListKey.titleKey)
        }
    }
    
    private var machineHostname: String? {
        return Host.current().localizedName
    }
    
}
