//
//  Obstacle.swift
//  Machine Learning Simulation
//
//  Created by Jiachen Ren on 7/17/17.
//  Copyright © 2017 Jiachen. All rights reserved.
//

import Foundation
import Cocoa

public class Obstacle {
    var length: CGFloat
    var pos: Vec2D
    
    static var lineWidth: CGFloat = 3
    static var color: NSColor = NSColor.black
    
    required public init(x: CGFloat, y: CGFloat, length: CGFloat) {
        self.length = length
        self.pos = Vec2D(x: x, y: y)
    }
    
    convenience init(point: CGPoint, length: CGFloat) {
        self.init(x: point.x, y: point.y, length: length)
    }
    
    public func display(_ context: CGContext) {
        context.saveGState()
        context.translateBy(x: pos.x, y: pos.y)
        let path = NSBezierPath()
        path.move(to: NSPoint(x: 0, y: 0 - length / 2))
        path.line(to: NSPoint(x: 0, y: 0 + length / 2))
        path.lineWidth = Obstacle.lineWidth
        path.lineCapStyle = .roundLineCapStyle
        Obstacle.color.setStroke()
        path.stroke()
        context.restoreGState()
    }
    
    private func isCollidingWith(mouse: Mouse) -> Bool {
        return !(abs(mouse.pos.y - self.pos.y) > length / 2) && abs(mouse.pos.x - self.pos.x) <= Mouse.radius
    }
    
    public func checkCollisionWith(mice: [Mouse]) {
        mice.forEach {
            if self.isCollidingWith(mouse: $0) {
                $0.hasExpired = true
            }
        }
    }
    
}

public class Mouse: CustomStringConvertible{
    static var radius: CGFloat = 15
    static var maxAcc: CGFloat = 15
    static var tailVisible: Bool = true
    static var color: NSColor = NSColor.green
    static var path: NSBezierPath = getPath()
    static var tailLineWidth: CGFloat = 0.5
    static var lineWidth: CGFloat = 2 {
        didSet {
            path = getPath()
        }
    }
    
    private static func getPath() -> NSBezierPath {
        let path = NSBezierPath()
        path.move(to: CGPoint(x: 0, y: -radius / 2))
        path.curve(
            to: CGPoint(x: 0, y: radius / 2),
            controlPoint1: CGPoint(x: -radius / 4, y: -radius / 6),
            controlPoint2: CGPoint(x: -radius / 2, y: radius / 3)
        )
        path.curve(
            to: CGPoint(x: 0, y: -radius / 2),
            controlPoint1: CGPoint(x: radius / 2, y: radius / 3),
            controlPoint2: CGPoint(x: radius / 4, y: -radius / 6)
        )
        path.lineWidth = lineWidth
        return path
    }
    
    public var description: String {
        return "pos: \(pos)"
    }
    
    var gene: Gene
    var curSteeringIndex: Int
    var hasExpired: Bool = false
    var pos: Vec2D
    var dir: Vec2D
    var r: CGFloat {return Mouse.radius}
    var source: CGPoint
    var bounds: CGSize {
        return Simulation.sharedInstance.window
    }
    var isOutOfBounds: Bool {
        return pos.x - r < 0 || pos.x + r > bounds.width || pos.y  - r <  0 || pos.y + r > bounds.height
    }
    
    private var prevPos: [Vec2D] = [Vec2D]()
    
    required public init(gene: Gene, pos: CGPoint) {
        if Mouse.tailVisible {prevPos.append(Vec2D(point: pos))}
        self.curSteeringIndex = 0
        self.source = pos
        self.gene = gene
        self.pos = Vec2D(point: pos)
        self.dir = Vec2D()
    }
    
    public func display(_ ctx: CGContext) {
        if Mouse.tailVisible {drawTail(ctx)}
        ctx.saveGState()
        ctx.translateBy(x: pos.x, y: pos.y)
        ctx.rotate(by: self.dir.heading() + CGFloat.pi / 2)
        Mouse.color.setStroke()
        Mouse.path.stroke()
        ctx.restoreGState()
    }
    
    private func drawTail(_ ctx: CGContext) {
        let tailPath = NSBezierPath()
        tailPath.move(to: prevPos[0].cgPoint)
        for i in 1..<prevPos.count {
            tailPath.line(to: prevPos[i].cgPoint)
        }
        tailPath.lineWidth = Mouse.tailLineWidth
        Mouse.color.setStroke()
        tailPath.stroke()
    }
    
    public func update() {
        guard !hasExpired else {return}
        if curSteeringIndex == gene.steers.count - 1 || isOutOfBounds {
            hasExpired = true
        }else if gene.steers[curSteeringIndex].isExpired {
            gene.steers[curSteeringIndex].reset()
            curSteeringIndex += 1
            return
        }
        let heading = gene.steers[curSteeringIndex].nextDirection()
        let _ = self.pos.add(dir.add(heading))
        if Mouse.tailVisible {
            prevPos.append(Vec2D(point: pos.cgPoint))
        }
    }
    
//    public func breedWith(mouse other: Mouse) -> Mouse {
//        return Mouse(self.gene.performMeiosisWith(other))
//    }
    
    public func distTo(_ vec: Vec2D) -> CGFloat {
        return sqrt(pow(self.pos.x - vec.x, 2) + pow(self.pos.y - vec.y, 2))
    }
    
}


