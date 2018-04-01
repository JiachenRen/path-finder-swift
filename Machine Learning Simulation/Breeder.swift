//
//  Breeder.swift
//  Machine Learning Simulation
//
//  Created by Jiachen Ren on 7/17/17.
//  Copyright © 2017 Jiachen. All rights reserved.
//

import Foundation

public class Breeder {
    var geneLength: Int
    var numOffspring: Int
    var destination: CGPoint!
    var source: CGPoint!
    
    required public init(geneLength: Int, numOffspring: Int) {
        self.geneLength = geneLength
        self.numOffspring = numOffspring
    }
    
    public func getInitialGeneration() -> [Mouse] {
        var mice = [Mouse]()
        getInitialGenePool().forEach {
            mice.append(Mouse(gene: $0, pos: source))
        }
        return mice
    }
    
    private func getInitialGenePool() -> [Gene] {
        var genes = [Gene]()
        for _ in 0..<numOffspring {
            genes.append(self.makeRandomizedGene())
        }
        return genes
    }
    
    private func makeRandomizedGene() -> Gene {
        var gene = Gene()
        for _ in 0..<geneLength {
            let randIterations = Int(CGFloat.random() * CGFloat(Gene.maxIterations))
            let angle = CGFloat.random() * CGFloat.pi * 2
            gene.add(node: Steer(lifeSpan: randIterations, angle: angle))
        }
        return gene
    }
    
    public func nextGeneration(of curGen: [Mouse]) -> [Mouse] {
        let viable = filterViableOffspring(for: curGen, cutoff: 0.5)
        let offspring = crossBreed(from: viable)
        return mutateAndMultiply(from: offspring)
    }
    
    private func mutateAndMultiply(from prototypes: [Mouse]) -> [Mouse] {
        var gen = [Mouse]()
        loop: while gen.count < numOffspring {
            for proto in prototypes {
                var uniqueGene = proto.gene
                uniqueGene.mutate(from: proto.curSteeringIndex)
                gen.append(Mouse(gene: uniqueGene, pos: source))
                if gen.count == numOffspring {
                    break loop
                }
            }
        }
        return gen
    }
    
    private func filterViableOffspring(for gen: [Mouse], cutoff perc: Double) -> [Mouse] {
        var gen = gen.sorted{$0.distTo(destination.toVec2D()) < $1.distTo(Vec2D(point: destination))}
        var viable = [Mouse]()
        while Double(viable.count) / Double(numOffspring) <= perc {
            viable.append(gen.remove(at: 0))
        }
//        viable.forEach{debugPrint($0)}
        return viable
    }
    
    private func crossBreed(from viable: [Mouse]) -> [Mouse] {
        var offspring = [Mouse]()
        while offspring.count < numOffspring {
            for i in 0..<viable.count {
                let born = Mouse(gene: viable[i].gene, pos: source)
                let curIndex = CGFloat(viable[i].curSteeringIndex)
                let index = Int(curIndex - (CGFloat(i) / CGFloat(viable.count)) * curIndex / 2) + 3
                born.curSteeringIndex = index < 0 ? 0 : index
                offspring.append(born)
                if offspring.count == numOffspring {
                    break
                }
            }
        }
        return offspring
    }
}

extension CGPoint {
    public func toVec2D() -> Vec2D {
        return Vec2D(point: self)
    }
}
