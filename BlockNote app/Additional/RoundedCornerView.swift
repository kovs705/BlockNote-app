//
//  RoundedCornerView.swift
//  BlockNote app
//
//  Created by Kovs on 12.12.2021.
//

import UIKit

class RoundedCornerView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

}
