//
//  GroupUICollectionViewCellAnimated.swift
//  BlockNote app
//
//  Created by Kovs on 18.03.2023.
//

import UIKit

class GroupUICollectionViewCellAnimated: UICollectionViewCell {
        
    override var isSelected: Bool {
        didSet {
            if !isSelected {
                handleTouchUp()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        handleTouchDown()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        handleTouchUp()
    }
    
    private func handleTouchDown() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            guard let self = self else { return }
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    
    private func handleTouchUp() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            guard let self = self else { return }
            self.transform = .identity
        }, completion: nil)
    }
}
