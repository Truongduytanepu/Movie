//
//  FrameView.swift
//  Moffy
//
//  Created by Trương Duy Tân on 18/04/2024.
//

import UIKit
import Combine

@IBDesignable class FrameView: BaseView {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner]
        return imageView
    }()
    private lazy var secondPosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private lazy var secondTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func addComponents() {
        self.addSubview(self.secondPosterImageView)
        self.addSubview(self.backgroundImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.secondTitleLabel)
        self.addSubview(self.dateLabel)
        self.addSubview(self.addressLabel)
    }
    
    override func setProperties() {
        self.backgroundColor = .clear
        self.clipsToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundImageView.frame.size = self.frame.size
    }
}

extension FrameView {
    func changeFrame(_ newFrame: BaseFrame) {
        self.backgroundImageView.image = AppImage.get(name: newFrame.background)
        
        self.changeLocation(self.posterImageView, newLocation: newFrame.poster)
        
        if let secondPoster = newFrame.secondPoster {
            self.secondPosterImageView.isHidden = false
            self.changeLocation(self.secondPosterImageView, newLocation: secondPoster)
        } else {
            self.secondPosterImageView.isHidden = true
        }
        
        self.changeLabelProperties(self.titleLabel, newProperties: newFrame.title)
        
        if let secondTitle = newFrame.secondTitle {
            self.secondTitleLabel.isHidden = false
            self.changeLabelProperties(self.secondTitleLabel, newProperties: secondTitle)
        } else {
            self.secondTitleLabel.isHidden = true
        }
        
        self.changeLabelProperties(self.dateLabel, newProperties: newFrame.date)
        
        self.changeLabelProperties(self.addressLabel, newProperties: newFrame.address)
    }
    
    func changePoster(_ newValue: String, isBorder: Bool) {
        self.posterImageView.sd_setImage(with: URL(string: URLs.domainImage + newValue))
        if isBorder {
            self.posterImageView.layer.cornerRadius = posterImageView.frame.height / 2
        } else {
            self.posterImageView.layer.cornerRadius = 0
        }
    }
    
    func changeSecondPoster(_ newValue: UIImage?) {
        self.secondPosterImageView.image = newValue
    }
    
    func changeTitle(_ newValue: String?, isBoderText: Bool, isTextShadow: Bool) {
        self.titleLabel.text = newValue
        
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        if isTextShadow {
            let shadow = NSShadow()
            shadow.shadowOffset = CGSize(width: 2, height: 2)
            shadow.shadowColor = UIColor.black
            attributes[.shadow] = shadow
        } else if !isTextShadow {
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.clear
            attributes[.shadow] = shadow
        } else if !isBoderText && !isTextShadow{
            attributes[.strokeColor] = UIColor.clear
            attributes[.strokeWidth] = 0
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.clear
            attributes[.shadow] = shadow
        }
        
        if isBoderText {
            let borderColor: UIColor = isBoderText ? .black : .clear
            let borderWidth: CGFloat = isBoderText ? -3.0 : 0.0
            attributes[.strokeColor] = borderColor
            attributes[.strokeWidth] = borderWidth
            
            titleLabel.clipsToBounds = false
        } else if !isBoderText {
            attributes[.strokeColor] = UIColor.clear
            attributes[.strokeWidth] = 0
        } else if !isTextShadow && !isTextShadow {
            attributes[.strokeColor] = UIColor.clear
            attributes[.strokeWidth] = 0
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.clear
            attributes[.shadow] = shadow
        }
        
        titleLabel.attributedText = NSAttributedString(string: newValue ?? "", attributes: attributes)
    }

    
    func changeSecondTitle(_ newValue: String?) {
        self.secondTitleLabel.text = newValue
    }
    
    func changeDate(_ newValue: String?) {
        self.dateLabel.text = newValue
    }
    
    func changeAddress(_ newValue: String?, isBorder: Bool) {
        self.addressLabel.text = newValue
        if isBorder {
            self.addressLabel.addBorderToText(color: .black, width: 3.0)
        } else {
            self.addressLabel.addBorderToText(color: .clear, width: 0)
        }
    }
}
