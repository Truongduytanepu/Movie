//
//  IntExtension.swift
//  MoviesApp
//
//  Created by Trịnh Xuân Minh on 18/09/2021.
//

import Foundation

extension Int {
    func convertToRunTime() -> String {
        if self <= 0 {
            return "0m"
        }
        let h = self / 60
        let m = self % 60
        if h == 0 {
            return "\(m)m"
        } else if m == 0 {
            return "\(h)h"
        } else {
            return "\(h)h \(m)m"
        }
    }
}
