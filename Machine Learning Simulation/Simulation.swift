//
//  Simulation.swift
//  Machine Learning Simulation
//
//  Created by Jiachen Ren on 7/17/17.
//  Copyright © 2017 Jiachen. All rights reserved.
//

import Foundation

public class Simulation: SimulationProtocol {
    var obstacles = [Obstacle]()
    var mice: [Mouse]!
    var offset: CGFloat = 100
    var targetRadius: CGFloat = 25
    var breeder: Breeder!
    var origin: CGPoint!
    var destination: CGPoint!
    var loop: Timer?
    var delegate: SimulationDelegate?
    
    var window: NSSize = NSSize(width: 800, height: 600)
    
    static let sharedInstance: Simulation =  {
        let sim = Simulation()
        sim.initialize()
        return sim
    }()

    
    public func initialize() {
        self.obstacles = initObstacles(maxLength: window.height/3, minLength: 5, num: 30)
        self.breeder = Breeder(geneLength: 1000, numOffspring: 100)
        defineOrigin()
        defineDestination()
        breeder.source = origin
        breeder.destination = destination
        mice = breeder.getInitialGeneration()
        setupSimulationLoop() //starts the simulation!
    }
    
    public func resize(to window: CGSize) {
        self.window = window
        self.initialize()
    }
    
    private func setupSimulationLoop() {
        loop?.invalidate()
        //60 fps
        loop = Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true){[unowned self] _ in
            self.obstacles.forEach {obstacle in
                obstacle.checkCollisionWith(mice: self.mice)
            }
            
            self.mice.forEach {mouse in
                if !mouse.hasExpired {
                    mouse.update()
                }
            }
            
            if self.checkCollisionWith(self.destination) {
                self.initialize()
            } else if self.iterationCompleted() {
                self.respawn()
            }
            
            self.delegate?.simulationLoopDidComplete()
        }
    }
    
    public func respawn(){
        mice = breeder.nextGeneration(of: mice)
    }
    
    private func defineOrigin() {
        origin = CGPoint(
            x: CGFloat.random(min: window.width - offset + targetRadius, max: window.width - targetRadius),
            y: CGFloat.random(min: targetRadius, max: window.height - targetRadius)
        )
    }
    
    private func defineDestination() {
        destination = CGPoint(
            x: CGFloat.random(min: 0, max: offset - targetRadius),
            y: CGFloat.random(min: targetRadius, max: window.height - targetRadius)
        )
    }
    
    private func initObstacles(maxLength: CGFloat, minLength: CGFloat, num: Int) -> [Obstacle] {
        var tempArr = [Obstacle]()
        (0..<num).forEach {_ in
            let pos = getRandomPos()
            let length = CGFloat.random(min: minLength, max: maxLength)
            tempArr.append(Obstacle(point: pos.cgPoint, length: length))
        }
        return tempArr
    }
    
    private func getRandomPos() -> Vec2D {
        let posX = CGFloat.random(min: offset, max: window.width-offset)
        let posY = CGFloat.random() * window.height
        return Vec2D(x: posX, y: posY)
    }
    
    public func iterationCompleted() -> Bool {
        for mouse in mice {
            if !mouse.hasExpired {
                return false
            }
        }
        return true
    }
    
    public func checkCollisionWith(_ point: CGPoint) -> Bool {
        for mouse in mice {
            if mouse.distTo(Vec2D(point: point)) < Mouse.radius + targetRadius {
                mouse.hasExpired = true
                return true
            }
        }
        return false
    }
    
}

protocol SimulationDelegate {
    func simulationLoopDidComplete()
}

protocol SimulationProtocol {
    var window: CGSize {get}
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / 4294967295
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        var min = min, max = max
        if (max < min) {swap(&min, &max)}
        return min + random() * (max - min)
    }
    
    private static func swap(_ a: inout CGFloat, _ b: inout CGFloat){
        let temp = a
        a = b
        b = temp
    }
}

