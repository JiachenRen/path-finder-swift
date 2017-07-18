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
        default: debugPrint(event.keyCode)
        }
    }
}
