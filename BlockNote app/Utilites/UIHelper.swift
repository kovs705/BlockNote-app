//
//  UIHelper.swift
//  BlockNote app
//
//  Created by Kovs on 09.08.2023.
//

import UIKit

final class UIHelper {
    
    static func giveConfigForImage(size: CGFloat, weight: UIImage.SymbolWeight) -> UIImage.SymbolConfiguration {
        let config = UIImage.SymbolConfiguration(pointSize: size, weight: weight)
        return config
    }
    
}
