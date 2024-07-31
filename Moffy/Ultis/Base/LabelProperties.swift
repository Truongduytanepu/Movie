//
//  LabelProperties.swift
//  Moffy
//
//  Created by Trương Duy Tân on 18/04/2024.
//

import Foundation
import UIKit

struct LabelProperties {
    let font: UIFont
    let textColor: UIColor
    let location: ComponentLocation
    let numberOfLines: Int
    let textAlignment: NSTextAlignment
    let textShadow: NSShadow?
    let textBorder: (color: UIColor, width: CGFloat)?

    init(font: UIFont, textColor: UIColor, location: ComponentLocation, numberOfLines: Int, textAlignment: NSTextAlignment = .left, textShadow: NSShadow? = nil, textBorder: (color: UIColor, width: CGFloat)? = nil) {
        self.font = font
        self.textColor = textColor
        self.location = location
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
        self.textShadow = textShadow
        self.textBorder = textBorder
    }
}
