//
//  CameraFilterCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 22/04/2024.
//

import UIKit

class CameraFilterCVC: BaseCollectionViewCell {
    @IBOutlet weak var filterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configFilter(_ image: UIImage) {
        filterImage.image = image
    }

}
