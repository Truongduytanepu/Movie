//
//  InTrailerCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 02/04/2024.
//

import UIKit

class InTrailerCVC: BaseCollectionViewCell {
    
    @IBOutlet weak var thumbYtb: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configDataThumb(_ key: String?) {
        let url = "https://i.ytimg.com/vi/\(key ?? "")/hqdefault.jpg"
        thumbYtb.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "DefaultNil"))
    }
}
