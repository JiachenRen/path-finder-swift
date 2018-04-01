//
//  Genetics.swift
//  Machine Learning Simulation
//
//  Created by Jiachen Ren on 7/18/17.
//  Copyright © 2017 Jiachen. All rights reserved.
//

import Foundation

public struct Steer {
    static var speed: CGFloat = 0.5
    
    var lifeSpan: Int
    var iterationsLeft: Int
    var angle: CGFloat
    
    var isExpired: Bool {
        return iterationsLeft <= 0
    }
    
    public mutating func nextDirection() -> Vec2D {
        let point = CGPoint(x: cos(angle), y: sin(angle))
        iterationsLeft -= 1
        return Vec2D(point: point).norm().mult(Steer.speed)
    }
    
    public init(lifeSpan: Int, angle: CGFloat) {
        self.angle = angle
        self.lifeSpan = lifeSpan
        self.iterationsLeft = lifeSpan
    }
    
    public mutating func reset() {
        iterationsLeft = lifeSpan
    }
}

public struct Gene {
    static var lifeSpanVariance: CGFloat = 5
    static var directionVariance: CGFloat = 6
    static var maxIterations = 15
    
    var steers: [Steer] = [Steer]()
    
    func performMeiosisWith(_ gene: Gene) -> Gene {
        var mixed = Gene()
        for i in 0..<gene.steers.count {
            let section = (i % 2 == 0 ? self : gene).steers[i]
            mixed.steers.append(section)
        }
        return mixed
    }
    
    mutating func mutate(from index: Int) {
        for i in index..<steers.count {
            var st1 = CGFloat(steers[i].lifeSpan) - Gene.lifeSpanVariance / 2
            var st2 = CGFloat(steers[i].lifeSpan) + Gene.lifeSpanVariance / 2
            var temp = Int(CGFloat.random(min: st1, max: st2))
            st1 = steers[i].angle + Gene.directionVariance / 2
            st2 = steers[i].angle - Gene.directionVariance / 2
            steers[i].angle = CGFloat.random(min: st1, max: st2)
            temp = temp < 1 ? 1 : temp
            steers[i].lifeSpan = temp
        }
    }
    
    mutating func add(node: Steer) {
        self.steers.append(node)
    }
}
