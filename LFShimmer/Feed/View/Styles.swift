//
//  Styles.swift
//  LFShimmer
//
//  Created by Florian LUDOT on 6/19/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: Float = 1.0) {
        let red = max(min(CGFloat(r)/255.0, 1.0), 0.0)
        let green = max(min(CGFloat(g)/255.0, 1.0), 0.0)
        let blue = max(min(CGFloat(b)/255.0, 1.0), 0.0)
        let alpha = max(min(CGFloat(a), 1.0), 0.0)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(flatGray: Int, a: Float = 1.0) {
        self.init(r: flatGray, g: flatGray, b: flatGray, a: a)
    }
}

struct Sizes {
    static let gutter: CGFloat = 16.0
}


struct Color {
    static let
    tint = UIColor(r: 126, g: 206, b: 22)
    
    static let
    danger = UIColor(r: 204, g: 46, b: 46),
    caution = UIColor(r: 240, g: 224, b: 53),
    success = UIColor(r: 51, g: 204, b: 46)
    
    static let
    white = UIColor(flatGray: 255),
    gray00 = UIColor(flatGray: 249),
    gray10 = UIColor(flatGray: 242),
    gray20 = UIColor(flatGray: 230),
    gray35 = UIColor(flatGray: 202),
    gray45 = UIColor(flatGray: 177),
    gray60 = UIColor(flatGray: 146),
    gray75 = UIColor(flatGray: 100),
    gray85 = UIColor(flatGray: 67),
    gray95 = UIColor(flatGray: 33),
    black = UIColor(flatGray: 0)
    
    static let
    clear = UIColor.clear
    
}

struct Font {
    enum TextStyle {
        static let title = UIFont(name: "Helvetica", size: 16)
        static let subtitle = UIFont(name: "Helvetica", size: 11)
    }
}
