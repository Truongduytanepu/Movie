//
//  PopularPeopleDetailCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 22/03/2024.
//

import UIKit

class PopularPeopleDetailCVC: BaseCollectionViewCell {

    @IBOutlet weak var nameActorLbl: UILabel!
    @IBOutlet weak var imagePeople: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setProperties() {
        imagePeople.cornerRadius = imagePeople.frame.height / 2
    }
    
    func configData(_ actor: Result) {
        imagePeople.sd_setImage(with: URL(string: URLs.domainImage + "\(actor.profilePath ?? "")"), 
                                placeholderImage: UIImage(named: "DefaultNil"))
        
        nameActorLbl.text = actor.name ?? actor.originalName
    }
}
