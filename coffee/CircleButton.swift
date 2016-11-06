//
//  CircleButton.swift
//  coffee
//
//  Created by admin on 11/1/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import UIKit
@IBDesignable

class CircleButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 30.0 {
        didSet {
            setupView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }

    func setupView() {
        layer.cornerRadius = cornerRadius

    }
}
