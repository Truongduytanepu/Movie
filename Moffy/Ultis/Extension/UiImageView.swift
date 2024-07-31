//
//  File.swift
//  Task1
//
//  Created by Trương Duy Tân on 12/01/2024.
//

import Foundation
import UIKit

extension UIImageView {
    
    func elipImage(_ isElip: Bool) {
        if isElip {
            let path = UIBezierPath(ovalIn: bounds)
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            layer.mask = maskLayer
        } else {
            let path = UIBezierPath(ovalIn: bounds)
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            layer.mask = nil
        }
    }
    
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


extension UIImageView {
    func addBorder(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = maskedCorners
        self.clipsToBounds = true
    }
}
