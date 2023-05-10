//
//  ViewController.swift
//  simulationVirus
//
//  Created by Nataly on 08.05.2023.
//

import UIKit

class InputViewController: UIViewController {
    
    let groupSizeTextField = UITextField()
    let infectionFactorTextField = UITextField()
    let periodTextField = UITextField()
    let startButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "backgroundImage")
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        
        groupSizeTextField.placeholder = "Group Size"
        groupSizeTextField.borderStyle = .roundedRect
        groupSizeTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(groupSizeTextField)
        
        infectionFactorTextField.placeholder = "Infection Factor"
        infectionFactorTextField.borderStyle = .roundedRect
        infectionFactorTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infectionFactorTextField)
        
        periodTextField.placeholder = "Period"
        periodTextField.borderStyle = .roundedRect
        periodTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(periodTextField)
        
        startButton.setTitle("Start Simulation", for: .normal)
        startButton.setTitleColor(.red, for: .normal)
        startButton.layer.cornerRadius = startButton.frame.height / 2
        startButton.backgroundColor = .lightBlue
        startButton.addTarget(self, action: #selector(startSimulation), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            groupSizeTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            groupSizeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            groupSizeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            groupSizeTextField.heightAnchor.constraint(equalToConstant: 40),
            
            infectionFactorTextField.topAnchor.constraint(equalTo: groupSizeTextField.bottomAnchor, constant: 20),
            infectionFactorTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infectionFactorTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infectionFactorTextField.heightAnchor.constraint(equalToConstant: 40),
            
            periodTextField.topAnchor.constraint(equalTo: infectionFactorTextField.bottomAnchor, constant: 20),
            periodTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            periodTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            periodTextField.heightAnchor.constraint(equalToConstant: 40),
            
            startButton.topAnchor.constraint(equalTo: periodTextField.bottomAnchor, constant: 20),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func startSimulation() {
        let groupSize = Int(groupSizeTextField.text ?? "0") ?? 0
        let infectionFactor = Int(infectionFactorTextField.text ?? "0") ?? 0
        let period = Int(periodTextField.text ?? "0") ?? 0
        let simulationViewController = SimulationViewController(groupSize: groupSize, infectionFactor: infectionFactor, period: period)
        let navigationController = UINavigationController(rootViewController: simulationViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

extension UIColor {
    static let lightBlue = UIColor(red: 102/255, green: 204/255, blue: 255/255, alpha: 1)
    
}
