//
//  RoundedCornerView.swift
//  BlockNote app
//
//  Created by Kovs on 12.12.2021.
//

import UIKit
    
@IBDesignable extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = cornerRadius > 0
        }
        
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var shadowOpacity: CGFloat {
        get { return CGFloat(layer.shadowOpacity) }
        set { layer.shadowOpacity = Float(newValue) }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
}