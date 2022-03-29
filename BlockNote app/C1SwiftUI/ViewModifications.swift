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
        set {
            layer.shadowRadius = newValue
        }
        
        get {
            return layer.shadowRadius
        }
    }

    @IBInspectable var shadowOpacity: CGFloat {
        set {
            layer.shadowOpacity = Float(newValue)
        }
        
        get {
            return CGFloat(layer.shadowOpacity)
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        
        get {
            return layer.shadowOffset
        }
    }

    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue?.cgColor
            
        }
        
        get {
            guard let cgColor = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        
    }
}
