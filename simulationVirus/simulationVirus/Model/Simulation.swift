//
//  Simulation.swift
//  simulationVirus
//
//  Created by Nataly on 08.05.2023.
//

//  Simulation.swift

import UIKit

class Simulation {
    
    static var infectionFactor: Int = 2
    var people: [Person] = []
    var infectedPeople: [Person] = []
    
    func infectPeople() {
        var newlyInfectedPeople: [Person] = []
        for person in infectedPeople {
            let neighbors = person.neighbors.filter { $0.state == .healthy }
            let count = min(neighbors.count, Simulation.infectionFactor)
            let infectedNeighbors = Array(neighbors.shuffled().prefix(count))
            infectedNeighbors.forEach { $0.state = .infected }
            newlyInfectedPeople.append(contentsOf: infectedNeighbors)
        }
        infectedPeople.append(contentsOf: newlyInfectedPeople)
    }
}

