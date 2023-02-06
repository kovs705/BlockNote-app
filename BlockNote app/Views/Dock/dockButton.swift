//
//  dockButton.swift
//  BlockNote app
//
//  Created by Kovs on 03.02.2023.
//

import UIKit

class dockButton: UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    convenience init(fontSize: CGFloat, icon: String, color: UIColor) {
        self.init(frame: .zero)
        
        let config = UIImage.SymbolConfiguration(pointSize: fontSize, weight: .medium, scale: .default)
        guard let image = UIImage(systemName: icon, withConfiguration: config) else { return }
        image.withTintColor(color)
        
        self.backgroundColor = .systemBackground
        self.setImage(image, for: .normal)
    }
    
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
//    func set(fontSize: CGFloat, icon: String, color: UIColor) {
//        let config = UIImage.SymbolConfiguration(pointSize: fontSize, weight: .medium, scale: .default)
//        guard let image = UIImage(systemName: icon, withConfiguration: config) else { return }
//        image.withTintColor(color)
//
//        self.backgroundColor = .systemBackground
//        self.setImage(image, for: .normal)
//    }
}
