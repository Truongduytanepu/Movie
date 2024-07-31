//
//  SeasonDetailCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 10/04/2024.
//

import UIKit

class SeasonDetailCVC: BaseCollectionViewCell {
    @IBOutlet weak var textViewEposide: UITextView!
    @IBOutlet weak var nameEposide: UILabel!
    @IBOutlet weak var imageEposides: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configEposide(_ episode: Episode?) {
        textViewEposide.text = episode?.overview
        imageEposides.sd_setImage(with: URL(string: URLs.domainImage + "\(episode?.stillPath ?? "")"), placeholderImage: UIImage(named: "DefaultNil"))
        nameEposide.text = "Episodes \(episode?.episodeNumber ?? 0)"
    }
}
