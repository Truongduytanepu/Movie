//
//  AppImage.swift
//  SelfieDemo
//
//  Created by Trịnh Xuân Minh on 16/08/2022.
//

import UIKit

struct AppImage {
    enum ImageName {
        case frame1
        case frame2
        case frame3
        case frame4
        case frame5
    }

    static func get(name: ImageName) -> UIImage {
        return UIImage(named: "\(name)")!
    }
}
