//
//  DoubleExtension.swift
//  MoviesApp
//
//  Created by Trịnh Xuân Minh on 24/09/2021.
//

import Foundation

extension Double {
    func roundToDecimals(decimals: Int = 9) -> Double {
        let multiplier = pow(10, Double(decimals))
        return ((self * multiplier).rounded() / multiplier)
    }
}
