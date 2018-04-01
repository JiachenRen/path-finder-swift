//
//  AppDelegate.swift
//  Machine Learning Simulation
//
//  Created by Jiachen Ren on 7/17/17.
//  Copyright © 2017 Jiachen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBAction func actionMenuItemTriggered(_ sender: NSMenuItem) {
        switch sender.title {
        case "Restart":
            Simulation.sharedInstance.initialize()
        case "Re-spawn":
            Simulation.sharedInstance.respawn()
        default:
            debugPrint(sender.title)
        }
        
    }


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

