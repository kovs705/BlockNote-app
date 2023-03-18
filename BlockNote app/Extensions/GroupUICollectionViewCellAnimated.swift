//
//  GroupUICollectionViewCellAnimated.swift
//  BlockNote app
//
//  Created by Kovs on 18.03.2023.
//

import UIKit

class GroupUICollectionViewCellAnimated: UICollectionViewCell {
    
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                handleTouchDown()
            } else {
                handleTouchUp()
            }
        }
    }
    
    private func handleTouchDown() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: { [weak self] in
            guard let self = self else { return }
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    
    private func handleTouchUp() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: { [weak self] in
            guard let self = self else { return }
            self.transform = .identity
        }, completion: nil)
    }
}
