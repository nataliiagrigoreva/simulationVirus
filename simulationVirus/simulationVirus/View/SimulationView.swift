//
//  SimulationView.swift
//  simulationVirus
//
//  Created by Nataly on 08.05.2023.
//

import UIKit

class SimulationView: UIView {
    
    weak var viewController: SimulationViewController?
    var contentView: UIView? {
        return viewController?.contentView
    }
    
    private var simulation: Simulation
    private var scaleFactor: CGFloat = 1.0
    private let minScaleFactor: CGFloat = 0.1
    private let maxScaleFactor: CGFloat = 2.0
    
    init(simulation: Simulation, infectedCount: Int) {
        self.simulation = simulation
        super.init(frame: .zero)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        self.addGestureRecognizer(pinchGestureRecognizer)
        let healthStatusLabel = UILabel()
        healthStatusLabel.text = "Healthy: \(simulation.people.count - infectedCount), Infected: \(infectedCount)"
        healthStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(healthStatusLabel)
        NSLayoutConstraint.activate([
            healthStatusLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            healthStatusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let cellView = recognizer.view as? CellView else { return }
        let translation = recognizer.translation(in: contentView)
        cellView.center = CGPoint(x: cellView.center.x + translation.x, y: cellView.center.y + translation.y)
        recognizer.setTranslation(.zero, in: contentView)
    }
    
    @objc private func handlePinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            let newScaleFactor = scaleFactor * recognizer.scale
            if newScaleFactor > minScaleFactor && newScaleFactor < maxScaleFactor {
                scaleFactor = newScaleFactor
                self.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            }
            recognizer.scale = 1.0
        default:
            break
        }
    }
}
