//
//  BiographyCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 17/04/2024.
//

import UIKit

protocol BiographyCVCDelegate: AnyObject {
    func setBioHeight(_ height: CGFloat)
}

class BiographyCVC: BaseCollectionViewCell {
    @IBOutlet weak var heightBioTextView: NSLayoutConstraint!
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var bioTextView: UITextView!
    
    weak var delegate: BiographyCVCDelegate?
    var actorDetail: ActorDetail?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setProperties() {
        bioTextView.textContainer.lineBreakMode = .byTruncatingTail
        bioTextView.textContainer.maximumNumberOfLines = 3
        seeAllBtn.underline()
    }
    
    func configDataActor(_ actor: ActorDetail) {
        bioTextView.text = actor.biography
    }
    
    func updateTextViewHeight() {
        let widthConstraint = bioTextView.frame.size.width
        let sizeThatFits = bioTextView.sizeThatFits(CGSize(width: widthConstraint, height: CGFloat.greatestFiniteMagnitude))
        heightBioTextView.constant = sizeThatFits.height
        delegate?.setBioHeight(heightBioTextView.constant)
    }
    
    func checkLineText(_ actor: ActorDetail) {
        let font = AppFont.get(fontName: .manaropeMedium, size: 12)
        let width = UIScreen.main.bounds.width - 32
        let line = actor.biography?.numberOfLines(forWidth: width, font: font) ?? 0
        
        if line <= 2 {
            seeAllBtn.isHidden = true
        }
    }
    
    @IBAction func seeMoreBtnTapped(_ sender: Any) {
        bioTextView.textContainer.maximumNumberOfLines = 0
        updateTextViewHeight()
        seeAllBtn.isHidden = true
    }
}
