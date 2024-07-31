//
//  FavoriteActorCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 21/04/2024.
//

import UIKit

protocol FavoriteActorCVCDelegate: AnyObject {
    func removeFavorite(at indexPath: IndexPath?)
}

class FavoriteActorCVC: BaseCollectionViewCell {
    @IBOutlet weak var departmentActorLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var nameActorLbl: UILabel!
    @IBOutlet weak var imageActor: UIImageView!
    
    weak var delegate: FavoriteActorCVCDelegate?
    var indexPathReceiveFavoriteVC: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageActor.cornerRadius = imageActor.frame.height / 2
    }

    func configDataActorFavorite(_ actor: ActorFavoriteObject) {
        imageActor.sd_setImage(with: URL(string: URLs.domainImage + "\(actor.profilePath ?? "")"),
                               placeholderImage: UIImage(named: "DefaultNil"))
        departmentActorLbl.text = actor.department
        nameActorLbl.text = actor.name
        favoriteBtn.setImage(UIImage(named: "Favorite"), for: .normal)
    }
    
    @IBAction func removeFavoriteBtnTapped(_ sender: Any) {
        delegate?.removeFavorite(at: indexPathReceiveFavoriteVC)
    }
}
