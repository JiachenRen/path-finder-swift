//
//  ParentView.swift
//  Machine Learning Simulation
//
//  Created by Jiachen Ren on 7/18/17.
//  Copyright © 2017 Jiachen. All rights reserved.
//

import Cocoa

@IBDesignable class ParentView: NSView {
    @IBInspectable var backgroundColor: NSColor = NSColor.white
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        backgroundColor.setFill()
        NSBezierPath(rect: bounds).fill()
        // Drawing code here.
    }
    
}
