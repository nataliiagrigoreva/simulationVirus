//
//  Person.swift
//  simulationVirus
//
//  Created by Nataly on 08.05.2023.
//
import UIKit

class Person {
    enum State {
        case healthy
        case infected
    }
    
    var state: State = .healthy
    var neighbors: [Person] = []
}

