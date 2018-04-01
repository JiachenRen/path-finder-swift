//
//  SimulationWindow.swift
//  Machine Learning Simulation
//
//  Created by Jiachen Ren on 7/18/17.
//  Copyright © 2017 Jiachen. All rights reserved.
//

import Cocoa

class SimulationWindow: NSWindow {
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0xf: Simulation.sharedInstance.initialize()
        case 0x11: Mouse.tailVisible = !Mouse.tailVisible
        case 0x4: Mouse.headVisible = !Mouse.headVisible
        default: debugPrint(event.keyCode)
        }
    }
}
