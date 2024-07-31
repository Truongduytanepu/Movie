//
//  UIImageExtension.swift
//  AI_Painting
//
//  Created by Trịnh Xuân Minh on 05/10/2023.
//

import UIKit

extension UIImage {
    //  class func image(with color: UIColor) -> UIImage {
    //    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 1, height: 1))
    //    UIGraphicsBeginImageContext(rect.size)
    //    let context = UIGraphicsGetCurrentContext()!
    //
    //    context.r(color.cgColor)
    //    context.fill(rect)
    //
    //    let image = UIGraphicsGetImageFromCurrentImageContext()
    //    UIGraphicsEndImageContext()
    //
    //    return image!
    //  }
    
    class func gradientImage(bounds: CGRect,
                             colors: [UIColor],
                             startPoint: CGPoint,
                             endPoint: CGPoint,
                             type: CAGradientLayerType = .axial,
                             locations: [NSNumber]? = nil
    ) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map(\.cgColor)
        gradientLayer.type = type
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        if let locations = locations {
            gradientLayer.locations = locations
        }
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        return renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }
    }
    
    func resize(maxSize: CGSize) -> UIImage {
        let size = self.size
        
        var ratio: CGFloat
        if size.width > size.height {
            ratio = maxSize.height / size.height
        } else {
            ratio = maxSize.width / size.width
        }
        
        if ratio >= 1.0 {
            return self
        }
        
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func withRoundedCornersAndBorder(radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, topLeft: Bool, bottomRight: Bool) -> UIImage? {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = radius
        imageView.layer.masksToBounds = true
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Vẽ ảnh đã được bo tròn vào context
        imageView.layer.render(in: context)
        
        // Nếu cần, vẽ border cho góc trên bên trái
        if topLeft {
            context.setStrokeColor(borderColor.cgColor)
            context.setLineWidth(borderWidth)
            let path1 = UIBezierPath(roundedRect: CGRect(x: borderWidth / 2, y: borderWidth / 2, width: radius * 2, height: radius * 2), cornerRadius: radius)
            context.addPath(path1.cgPath)
            context.strokePath()
        }
        
        // Nếu cần, vẽ border cho góc dưới bên phải
        if bottomRight {
            context.setStrokeColor(borderColor.cgColor)
            context.setLineWidth(borderWidth)
            let path2 = UIBezierPath(roundedRect: CGRect(x: imageView.bounds.width - radius * 2 - borderWidth / 2, y: imageView.bounds.height - radius * 2 - borderWidth / 2, width: radius * 2, height: radius * 2), cornerRadius: radius)
            context.addPath(path2.cgPath)
            context.strokePath()
        }
        
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage
    }
}
