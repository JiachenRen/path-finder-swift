//
//  SimulationView.swift
//  Machine Learning Simulation
//
//  Created by Jiachen Ren on 7/17/17.
//  Copyright © 2017 Jiachen. All rights reserved.
//

import Cocoa

@IBDesignable class SimulationView: NSView {
    @IBInspectable var originColor: NSColor = NSColor.green.withAlphaComponent(0.5)
    @IBInspectable var destinationColor: NSColor = NSColor.red.withAlphaComponent(0.5)
    
    var delegate: SimulationViewDelegate?
    var context: NSGraphicsContext? {return NSGraphicsContext.current()}
    var simulation: Simulation {return Simulation.sharedInstance}
    var obstacles: [Obstacle] {
        return simulation.obstacles
    }
    var mice: [Mouse] {
        return simulation.mice
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        //draws the background
        drawBackground(color: NSColor.white)
        
        //grabs the graphics context
        guard let context = self.context?.cgContext else {return}
        
        //draws the obstacles and the mice
        obstacles.forEach {$0.display(context)}
        mice.forEach {$0.display(context)}
        
        //draws the origin
        originColor.setFill()
        CGContext.fillCircle(center: simulation.origin, radius: simulation.targetRadius)
        
        //draws the destination
        destinationColor.setFill()
        CGContext.fillCircle(center: simulation.destination, radius: simulation.targetRadius)
    }
    
    override func resize(withOldSuperviewSize oldSize: NSSize) {
        super.resize(withOldSuperviewSize: oldSize)
        delegate?.simulationViewDidResize(newSize: self.bounds.size)
    }
    
    private func drawBackground(color: NSColor){
        color.setFill()
        NSBezierPath(rect: bounds).fill()
    }
    
}

extension CGContext {
    static func fillCircle(center: CGPoint, radius: CGFloat){
        let circle = NSBezierPath(ovalIn: CGRect(center: center, size: CGSize(width: radius * 2, height: radius * 2)))
        circle.fill()
    }
}

extension CGRect {
    init(center: CGPoint, size: CGSize){
        self.init(
            origin: CGPoint(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2
            ),
            size: size
        )
    }
}

protocol SimulationViewDelegate {
    func simulationViewDidResize(newSize: CGSize)
}
