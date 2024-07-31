//
//  BaseView.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit
import Combine

class BaseView: UIView, ViewProtocol {
    var subscriptions = [AnyCancellable]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setConstraints()
        setProperties()
        binding()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addComponents()
        setConstraints()
        setProperties()
        binding()
    }
    
    func addComponents() {}
    
    func setConstraints() {}
    
    func setProperties() {}
    
    func setColor() {}
    
    func binding() {}
    
    func changeLocation(_ sender: UIView, newLocation: ComponentLocation) {
        guard let superview = sender.superview else {
            return
        }
        sender.snp.remakeConstraints { make in
            make.leading.equalToSuperview().inset(newLocation.x / AppSize.widthFrameDefault * superview.frame.width)
            make.top.equalToSuperview().inset(newLocation.y / AppSize.heightFrameDefault * superview.frame.height)
            make.width.equalToSuperview().multipliedBy(newLocation.width / AppSize.widthFrameDefault)
            make.height.equalToSuperview().multipliedBy(newLocation.height / AppSize.heightFrameDefault)
        }
        sender.transform = CGAffineTransform(rotationAngle: -newLocation.rotationAngle * CGFloat.pi / 180)
        self.layoutIfNeeded()
        setNeedsLayout()
    }
    
    func changeLabelProperties(_ sender: UILabel, newProperties: LabelProperties) {
        self.changeLocation(sender, newLocation: newProperties.location)
        sender.textColor = newProperties.textColor
        sender.font = newProperties.font
        sender.numberOfLines = newProperties.numberOfLines
        sender.textAlignment = newProperties.textAlignment
    }
    
    func addBorderToImageViewCorners(_ imageView: UIImageView) {
        // Tạo đường viền
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.black.cgColor // Màu của đường viền
        borderLayer.fillColor = UIColor.clear.cgColor // Không tô màu cho đường viền
        borderLayer.lineWidth = 2 // Độ rộng của đường viền
        
        // Tạo hình dạng của đường viền
        let borderPath = UIBezierPath()
        // Vẽ đường từ góc trên bên phải đến góc dưới bên trái
        borderPath.move(to: CGPoint(x: imageView.bounds.maxX, y: 0))
        borderPath.addLine(to: CGPoint(x: imageView.bounds.minX, y: imageView.bounds.maxY))
        
        // Gán hình dạng cho đường viền
        borderLayer.path = borderPath.cgPath
        
        // Thêm đường viền vào imageView
        imageView.layer.addSublayer(borderLayer)
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setColor()
    }
}
