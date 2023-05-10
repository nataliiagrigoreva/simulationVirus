//
//  InfectedModel.swift
//  simulationVirus
//
//  Created by Nataly on 10.05.2023.
//

// InfectedModel.swift

import Foundation
import UIKit

class InfectedModel {
    
    var infectedElements = Set<Int>()
    var maxIndex = 99
    var infectionFactor = 3
    var queue: DispatchQueue
    
    init(queue: DispatchQueue) {
        self.queue = queue
    }
    
    func updateInfectedElements(period: Double, infectedLabel: UILabel) {
        let randIndex = Int.random(in: 0...maxIndex)
        if infectedElements.contains(randIndex) {
            let neighbors = getNeighbors(index: randIndex)
            let infectedNeighbors = getInfectableNeighbors(neighbors: neighbors)
            for neighborIndex in infectedNeighbors {
                let subsetSize = Int.random(in: 1...infectionFactor)
                let subset = getSubsetOfNeighbors(index: neighborIndex, size: subsetSize)
                for subsetIndex in subset {
                    infectedElements.insert(subsetIndex)
                }
            }
        }

        DispatchQueue.main.async {
            infectedLabel.text = "Infected: \(self.infectedElements.count)"

        }
    }
    
    func getNeighbors(index: Int) -> [Int] {
        let prevIndex = max(index - 1, 0)
        let nextIndex = min(index + 1, maxIndex)
        return [prevIndex, index, nextIndex]
    }
    
    func getInfectableNeighbors(neighbors: [Int]) -> [Int] {
        return neighbors.filter { neighbor in
            !infectedElements.contains(neighbor)
            && getNeighbors(index: neighbor).contains(where: infectedElements.contains)
        }
    }
        
    func getSubsetOfNeighbors(index: Int, size: Int) -> [Int] {
        var subset = [index]
        var availableNeighbors = getNeighbors(index: index).filter { !infectedElements.contains($0) }
        availableNeighbors.shuffle()
        subset.append(contentsOf: availableNeighbors.prefix(size - 1))
        return subset
    }
    
}
