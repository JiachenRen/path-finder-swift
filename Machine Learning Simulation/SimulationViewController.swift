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
        simulation.resize(to: simulationView.bounds.size)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func restartButtonPressed(_ sender: NSButton) {
        simulation.initialize()
    }
    
    @IBAction func respawnButtonPressed(_ sender: NSButton) {
        simulation.respawn()
    }
    
    @IBAction func appearanceRadioButtonChanged(_ sender: NSButton) {
//        let isOn = sender.state == 1
        sender.state = (sender.state == 1 ? 0 : 1)
        debugPrint(sender.state)
//        switch sender.title {
//        case "HeadVisible":
//            Mouse.headVisible = isOn
//        case "TailVisible":
//            Mouse.tailVisible = isOn
//        default:
//            break
//        }
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
        simulation.resize(to: newSize)
    }
    
    func restartSimulation() {
        simulation.initialize()
    }


}

