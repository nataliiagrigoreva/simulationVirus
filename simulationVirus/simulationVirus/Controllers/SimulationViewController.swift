
//
//  CellView.swift
//  simulationVirus
//
//  Created by Nataly on 08.05.2023.
//

import UIKit
import Foundation

class SimulationViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let healthyLabel = UILabel()
    let infectedLabel = UILabel()
    var cells = [CellView]()
    var infectedCells = Set<CellView>()
    var groupSize: Int
    var infectionFactor: Int
    var period: Int
    private let queue = DispatchQueue(label: "infectedElementsQueue", qos: .userInteractive)
    private var infectedModel: InfectedModel
    private var timer: Timer?
    
    init(groupSize: Int, infectionFactor: Int, period: Int) {
        self.groupSize = groupSize
        self.infectionFactor = infectionFactor
        self.period = period
        self.infectedModel = InfectedModel(queue: self.queue)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImage(named: "backgroundImage")
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        let cellWidth: CGFloat = 40
        let cellHeight: CGFloat = 40
        let _: CGFloat = 10
        var randomPositions = [CGPoint]()
        for _ in 0..<groupSize {
            let randomX = CGFloat(arc4random_uniform(UInt32(view.frame.width - cellWidth)))
            let randomY = CGFloat(arc4random_uniform(UInt32(view.frame.height - cellHeight)))
            randomPositions.append(CGPoint(x: randomX, y: randomY))
        }
        
        for i in 0..<groupSize {
            let cellView = CellView(frame: CGRect(x: randomPositions[i].x, y: randomPositions[i].y, width: cellWidth, height: cellHeight))
            cellView.backgroundColor = .green
            contentView.addSubview(cellView)
            cellView.isUserInteractionEnabled = true
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            cellView.addGestureRecognizer(panGesture)
            panGesture.cancelsTouchesInView = false
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(sender:)))
            tapGesture.cancelsTouchesInView = false
            cellView.addGestureRecognizer(tapGesture)
            cells.append(cellView)
        }
        
        scrollView.contentSize = contentView.bounds.size
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        healthyLabel.translatesAutoresizingMaskIntoConstraints = false
        infectedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.insertSubview(scrollView, at: 0)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(healthyLabel)
        contentView.addSubview(infectedLabel)
        
        healthyLabel.text = "Healthy: \(groupSize)"
        healthyLabel.textColor = .black
        
        healthyLabel.backgroundColor = .white
        infectedLabel.text = "Infected: \(infectedCells.count)"
        infectedLabel.textColor = .red
        infectedLabel.backgroundColor = .white

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            healthyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            healthyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            healthyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            infectedLabel.topAnchor.constraint(equalTo: healthyLabel.bottomAnchor, constant: 10),
            infectedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infectedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.0
        scrollView.setNeedsLayout()
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true
        scrollView.panGestureRecognizer.cancelsTouchesInView = false
        scrollView.delegate = self
        
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(period), repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.queue.async {
                self.infectedModel.updateInfectedElements(period: Double(self.period), infectedLabel: self.infectedLabel)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let cellWidth: CGFloat = 50
        let cellHeight: CGFloat = 50
        let cellSpacing: CGFloat = 10
        let numCellsPerRow = max(Int((contentView.frame.width - cellSpacing) / (cellWidth + cellSpacing)), 1)
        let numRows = groupSize / numCellsPerRow + (groupSize % numCellsPerRow > 0 ? 1 : 0)
        let totalHeight = CGFloat(numRows) * (cellHeight + cellSpacing) + cellSpacing
        contentView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
        scrollView.contentSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height)
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let cellView = recognizer.view as? CellView else { return }
        let translation = recognizer.translation(in: contentView)
        cellView.center = CGPoint(x: cellView.center.x + translation.x, y: cellView.center.y + translation.y)
        recognizer.setTranslation(.zero, in: contentView)
        
        if recognizer.state == .began {
            recognizer.view?.subviews.forEach({ $0.isUserInteractionEnabled = false })
        } else if recognizer.state == .ended || recognizer.state == .cancelled {
            recognizer.view?.subviews.forEach({ $0.isUserInteractionEnabled = true })
        }
        if infectedCells.contains(cellView) {
            infectedCells.remove(cellView)
        } else {
            infectedCells.insert(cellView)
            infectedModel.updateInfectedElements(period: Double(period), infectedLabel: infectedLabel)
        }
    }
        
    private func moveCells() {
        let cellWidth: CGFloat = 50
        let cellHeight: CGFloat = 50
        
        for cellView in cells {
            var randomX = CGFloat(arc4random_uniform(UInt32(view.frame.width - cellWidth)))
            var randomY = CGFloat(arc4random_uniform(UInt32(view.frame.height - cellHeight)))
            
            if randomX + cellWidth > view.frame.width {
                randomX = view.frame.width - cellWidth
            }
            if randomY + cellHeight > view.frame.height {
                randomY = view.frame.height - cellHeight
            }
            cellView.frame = CGRect(x: randomX, y: randomY, width: cellWidth, height: cellHeight)
        }
    }
    
    @objc func cellTapped(sender: UITapGestureRecognizer) {
        
        guard let cellView = sender.view as? CellView else { return }
        infectedCells.insert(cellView)
        cellView.backgroundColor = .red
        healthyLabel.text = "Healthy: \(groupSize - infectedCells.count)"
        infectedLabel.text = "Infected: \(infectedCells.count)"
        
        super.touchesBegan(Set<UITouch>(), with: nil)
        for gesture in cellView.gestureRecognizers ?? [] {
            if let panGesture = gesture as? UIPanGestureRecognizer {
                cellView.removeGestureRecognizer(panGesture)
            }
            if let tapGesture = gesture as? UITapGestureRecognizer {
                cellView.removeGestureRecognizer(tapGesture)
            }
        }
        scrollView.layoutIfNeeded()
    }
    
    func recalculateInfected() {
        cells.forEach { cell in
            if !infectedCells.contains(cell) {
                let neighbors = cells.filter { $0 != cell && $0.frame.intersects(cell.frame) }
                let infectedNeighbors = Set(neighbors).intersection(infectedCells)
                if infectedNeighbors.count >= infectionFactor {
                    infectedCells.insert(cell)
                    DispatchQueue.main.async {
                        cell.backgroundColor = .red
                        self.infectedLabel.text = "Infected: \(self.infectedCells.count)"
                    }
                }
            }
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.panGestureRecognizer.isEnabled = true
    }
    
    func scrollView(_ scrollView: UIScrollView, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension SimulationViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.setNeedsLayout()
        scrollView.layoutIfNeeded()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
