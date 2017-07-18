//
//  ViewController.swift
//  Machine Learning Simulation
//
//  Created by Jiachen Ren on 7/17/17.
//  Copyright © 2017 Jiachen. All rights reserved.
//

import Cocoa

class SimulationViewController: NSViewController, SimulationDelegate, SimulationViewDelegate {
    
    @IBOutlet weak var simulationView: SimulationView!
    var simulation: Simulation {return Simulation.sharedInstance}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        simulation.delegate = self
        simulationView.delegate = self
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func simulationLoopDidComplete() {
        simulationView.setNeedsDisplay(simulationView.bounds)
    }
    
    func simulationViewDidResize(newSize: CGSize) {
        simulation.window = newSize
    }
    
    func restartSimulation() {
        simulation.initialize()
    }


}

