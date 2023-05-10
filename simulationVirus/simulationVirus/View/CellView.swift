//
//  CellView.swift
//  simulationVirus
//
//  Created by Nataly on 08.05.2023.
//

import UIKit

class CellView: UIButton {
    var onPan: ((UIPanGestureRecognizer) -> Void)?
    var neighbors = [CellView]()
    
    func getNeighbors() -> [CellView] {
        return neighbors
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:)))
        addGestureRecognizer(panGesture)
        panGesture.cancelsTouchesInView = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(sender:)))
        addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
    }
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        onPan?(sender)
    }
    
    @objc func cellTapped(sender: UITapGestureRecognizer) {
    }
}
