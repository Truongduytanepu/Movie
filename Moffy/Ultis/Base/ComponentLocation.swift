//
//  ComponentLocation.swift
//  Moffy
//
//  Created by Trương Duy Tân on 18/04/2024.
//

import Foundation

struct ComponentLocation {
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
    let rotationAngle: CGFloat

    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, rotationAngle: CGFloat) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.rotationAngle = rotationAngle
    }
}

