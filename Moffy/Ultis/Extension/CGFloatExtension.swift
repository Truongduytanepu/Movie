//
//  CGFloatExtension.swift
//  InterFilm
//
//  Created by Trịnh Xuân Minh on 02/12/2021.
//

import Foundation
import UIKit

extension CGFloat {
    func roundToDecimals(decimals: Int = 9) -> CGFloat {
        let multiplier = pow(10, CGFloat(decimals))
        return ((self * multiplier).rounded() / multiplier)
    }
}
