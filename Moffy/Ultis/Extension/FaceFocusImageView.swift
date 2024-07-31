//
//  FaceFocusImageView.swift
//  MovieIOS11
//
//  Created by Trịnh Xuân Minh on 20/05/2022.
//

import Foundation
import UIKit

import UIKit

private var closureKey: UInt = 0
private var debugKey: UInt = 1

internal class ClosureWrapper<T> {
    var closure: (T) -> Void
    init(_ closure: @escaping (T) -> Void) {
        self.closure = closure
    }
}

internal protocol Attachable {
    func set(_ attachObj: Any?, forKey key: inout UInt)
    func getAttach(forKey key: inout UInt) -> Any?
}

extension Attachable {

    func set(_ attachObj: Any?, forKey key: inout UInt) {
        objc_setAssociatedObject(self, &key, attachObj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func getAttach(forKey key: inout UInt) -> Any? {
        return objc_getAssociatedObject(self, &key)
    }

}

let faceForcusImageCache = NSCache<AnyObject, AnyObject>()

@IBDesignable
class FaceFocusImageView: UIImageView, Attachable {
    
    var imageKey: String?
    
    @IBInspectable
    /// Adds a red bordered rectangle around any faces detected.
    var debugFaceAware: Bool {
        set {
            self.set(newValue, forKey: &debugKey)
        } get {
            guard let debug = self.getAttach(forKey: &debugKey) as? Bool else {
                return false
            }
            return debug
        }
    }

    @IBInspectable
    /// Set this to true if you want to center the image on any detected faces.
    var focusOnFaces: Bool = true

    func set(image: UIImage?, key: String?, down: CGFloat = 20.0) {
        self.imageKey = key
        self.setImageAndFocusOnFaces(image: image, key: key, down: down)
    }

    /// You can provide a closure here to receive a callback for when all face
    /// detection and image adjustments have been finished.
    var didFocusOnFaces: (() -> Void)? {
        set {
            self.set(newValue, forKey: &closureKey)
        } get {
            return self.getAttach(forKey: &closureKey) as? (() -> Void)
        }
    }

    private func setImageAndFocusOnFaces(image: UIImage?, key: String?, down: CGFloat) {
        if let features = faceForcusImageCache.object(forKey: key as AnyObject) as? [CIFeature] {
            guard let image = image else {
                return
            }
            let imgSize = CGSize(width: image.cgImage!.width, height: image.cgImage!.height)
            self.applyFaceDetection(for: features, size: imgSize, image: image, key: key, down: down)
        } else {
            DispatchQueue.global(qos: .default).async {
                guard let image = image else {
                    return
                }

                guard let ciImage = CIImage(image: image) else {
                    return
                }

                let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
                let features = detector!.features(in: ciImage)

                if features.isEmpty == false {
                    DispatchQueue.main.async {
                        let imgSize = CGSize(width: image.cgImage!.width, height: image.cgImage!.height)
                        self.applyFaceDetection(for: features, size: imgSize, image: image, key: key, down: down)
                    }
                } else {
                    if self.debugFaceAware == true {
                        print("No faces found")
                    }
                    self.removeImageLayer(image: image)
                }
            }
        }
    }

    private func applyFaceDetection(for features: [CIFeature], size: CGSize, image: UIImage, key: String?, down: CGFloat) {
        var rect = features[0].bounds
        rect.origin.y = size.height - rect.origin.y - rect.size.height
        var rightBorder = Double(rect.origin.x + rect.size.width)
        var bottomBorder = Double(rect.origin.y + rect.size.height)

        for feature in features[1..<features.count] {
            var oneRect = feature.bounds
            oneRect.origin.y = size.height - oneRect.origin.y - oneRect.size.height
            rect.origin.x = min(oneRect.origin.x, rect.origin.x)
            rect.origin.y = min(oneRect.origin.y, rect.origin.y)

            rightBorder = max(Double(oneRect.origin.x + oneRect.size.width), Double(rightBorder))
            bottomBorder = max(Double(oneRect.origin.y + oneRect.size.height), Double(bottomBorder))
        }

        rect.size.width = CGFloat(rightBorder) - rect.origin.x
        rect.size.height = CGFloat(bottomBorder) - rect.origin.y

        var offset = CGPoint.zero
        var finalSize = size

        if size.width / size.height > self.bounds.size.width / self.bounds.size.height {
            var centerX = rect.origin.x + rect.size.width / 2.0

            finalSize.height = self.bounds.size.height
            finalSize.width = size.width/size.height * finalSize.height
            centerX = finalSize.width / size.width * centerX

            offset.x = centerX - self.bounds.size.width * 0.5
            if offset.x < 0 {
                offset.x = 0
            } else if offset.x + self.bounds.size.width > finalSize.width {
                offset.x = finalSize.width - self.bounds.size.width
            }
            offset.x = -offset.x
        } else {
            var centerY = rect.origin.y + rect.size.height / 2.0

            finalSize.width = self.bounds.size.width
            finalSize.height = size.height / size.width * finalSize.width
            centerY = finalSize.width / size.width * centerY

            offset.y = centerY - self.bounds.size.height * CGFloat(1-0.618)
            if offset.y < 0 {
                offset.y = 0
            } else if offset.y + self.bounds.size.height > finalSize.height {
                finalSize.height = self.bounds.size.height
                offset.y = finalSize.height
            }
            offset.y = -offset.y
            if offset.y > -finalSize.height + down {
                offset.y += down
            }
            if offset.y > 0 {
                offset.y = 0
            }
        }
        
        var newImage: UIImage
        if self.debugFaceAware {
            newImage = self.drawDebugRectangles(from: image, size: size, features: features)
        } else {
            newImage = image
        }

        if self.imageKey == key {
            self.image = newImage

            let layer = self.imageLayer()
            layer.contents = newImage.cgImage
            layer.frame = CGRect(x: offset.x, y: offset.y, width: finalSize.width, height: finalSize.height)
            
            faceForcusImageCache.setObject(features as AnyObject, forKey: key as AnyObject)
            self.didFocusOnFaces?()
        } else {
            self.removeImageLayer(image: image)
        }
    }

    private func drawDebugRectangles(from image: UIImage, size: CGSize, features: [CIFeature]) -> UIImage {
        // Draw rectangles around detected faces
        let rawImage = UIImage(cgImage: image.cgImage!)
        UIGraphicsBeginImageContext(size)
        rawImage.draw(at: CGPoint.zero)

        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setLineWidth(3)

        features.forEach({
            var faceViewBounds = $0.bounds
            faceViewBounds.origin.y = size.height - faceViewBounds.origin.y - faceViewBounds.size.height

            context?.addRect(faceViewBounds)
            context?.drawPath(using: .stroke)
        })

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    private func imageLayer() -> CALayer {
        if let layer = sublayer() {
            return layer
        }

        let subLayer = CALayer()
        subLayer.name = "AspectFillFaceAware"
        subLayer.actions = ["contents": NSNull(), "bounds": NSNull(), "position": NSNull()]
        layer.addSublayer(subLayer)
        return subLayer
    }

    private func removeImageLayer(image: UIImage?) {
        DispatchQueue.main.async {
            // avoid redundant layer when focus on faces for the image of cell specified in UITableView
            self.imageLayer().removeFromSuperlayer()
            self.image = image
        }
    }

    private func sublayer() -> CALayer? {
        if let sublayers = layer.sublayers {
            for layer in sublayers where layer.name == "AspectFillFaceAware" {
                return layer
            }
        }
        return nil
    }
}
