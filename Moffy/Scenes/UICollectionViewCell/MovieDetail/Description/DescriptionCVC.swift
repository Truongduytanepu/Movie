//
//  DescriptionCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 01/04/2024.
//

import UIKit

protocol DescriptionCVCDelegate: AnyObject {
    func setBioHeight(_ height: CGFloat)
}

class DescriptionCVC: BaseCollectionViewCell {
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var heightBio: NSLayoutConstraint!
    @IBOutlet weak var seeAllBtn: UIButton!
    
    weak var delegate: DescriptionCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setProperties() {
        descriptionTextView.textContainer.lineBreakMode = .byTruncatingTail
        descriptionTextView.textContainer.maximumNumberOfLines = 3
        seeAllBtn.underline()
    }
    
    func configDataDescription(_ movie: MovieDetailModel) {
        descriptionTextView.text = movie.overview
    }
    
    func updateTextViewHeight() {
        let widthConstraint = descriptionTextView.frame.size.width
        let sizeThatFits = descriptionTextView.sizeThatFits(CGSize(width: widthConstraint, height: CGFloat.greatestFiniteMagnitude))
        heightBio.constant = sizeThatFits.height
        delegate?.setBioHeight(heightBio.constant)
    }
    
    func checkLineText(_ movie: MovieDetailModel) {
        let font = AppFont.get(fontName: .manaropeMedium, size: 12)
        let width = UIScreen.main.bounds.width - 32
        let line = movie.overview?.numberOfLines(forWidth: width, font: font) ?? 0
        
        if line <= 2 {
            seeAllBtn.isHidden = true
        }
    }
    
    @IBAction func seeMoreBioBtnTapped(_ sender: Any) {
        descriptionTextView.textContainer.maximumNumberOfLines = 0
        updateTextViewHeight()
        seeAllBtn.isHidden = true
    }
}
