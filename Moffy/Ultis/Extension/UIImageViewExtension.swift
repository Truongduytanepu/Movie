//
//  UIImageViewExtension.swift
//  Wallpaper_Gacha_Life
//
//  Created by Trịnh Xuân Minh on 13/04/2021.
//

import Foundation
import UIKit

extension UIImageView {
    static var imageDefault = UIImage(named: "imageDefault")
    
    func realImageRect() -> CGRect {
        let imageViewSize = self.frame.size
        let imgSize = self.image?.size
        
        guard let imageSize = imgSize else {
            return CGRect.zero
        }
        
        let aspect = fmin(imageViewSize.width / imageSize.width, imageViewSize.height / imageSize.height)
        
        var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)
        
        imageRect.origin.x = (imageViewSize.width - imageRect.width) / 2
        imageRect.origin.y = (imageViewSize.height - imageRect.height) / 2
        
        imageRect.origin.x += self.frame.origin.x
        imageRect.origin.y += self.frame.origin.y
        
        return imageRect
    }
    
    func pulsate(toValue: Float = 1.5) {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 1.0
        pulse.fromValue = 0.95
        pulse.toValue = toValue
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        self.layer.add(pulse, forKey: "pulse")
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
    
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}

extension UIImage {
    class func image(with color: UIColor) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

extension UIImageView {
    func addBorderForTwoCorners(borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat, topLeft: Bool, bottomRight: Bool) {
        // Tạo một UIBezierPath để vẽ mask layer
        let maskPath = UIBezierPath()
        let layerWidth = bounds.width
        let layerHeight = bounds.height
        
        // Tính toán các điểm của góc trên bên trái
        let topLeftCorner = CGPoint(x: 0, y: cornerRadius)
        let topLeftCenter = CGPoint(x: cornerRadius, y: cornerRadius)
        
        // Tính toán các điểm của góc dưới bên phải
        let bottomRightCorner = CGPoint(x: layerWidth - cornerRadius, y: layerHeight)
        let bottomRightCenter = CGPoint(x: layerWidth - cornerRadius, y: layerHeight - cornerRadius)
        
        // Di chuyển đến điểm bắt đầu của đường vẽ
        maskPath.move(to: CGPoint(x: 0, y: cornerRadius))
        
        // Thêm các đoạn đường cho góc trên bên trái nếu cần
        if topLeft {
            maskPath.addArc(withCenter: topLeftCenter, radius: cornerRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi / 2, clockwise: true)
        } else {
            maskPath.addLine(to: CGPoint(x: 0, y: 0))
        }
        
        // Thêm các đoạn đường cho cạnh trên
        maskPath.addLine(to: CGPoint(x: layerWidth, y: 0))
        
        // Thêm các đoạn đường cho góc dưới bên phải nếu cần
        if bottomRight {
            maskPath.addArc(withCenter: bottomRightCenter, radius: cornerRadius, startAngle: CGFloat.pi * 1.5, endAngle: 0, clockwise: true)
        } else {
            maskPath.addLine(to: CGPoint(x: layerWidth, y: layerHeight))
        }
        
        // Thêm các đoạn đường cho cạnh dưới
        maskPath.addLine(to: CGPoint(x: 0, y: layerHeight))
        
        // Kết thúc path
        maskPath.close()
        
        // Tạo mask layer
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.fillColor = UIColor.white.cgColor
        
        // Áp dụng mask layer lên UIImageView
        layer.mask = maskLayer
        
        // Tạo border layer
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskPath.cgPath
        borderLayer.lineWidth = borderWidth
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        
        // Áp dụng border layer lên UIImageView
        layer.addSublayer(borderLayer)
    }
}
