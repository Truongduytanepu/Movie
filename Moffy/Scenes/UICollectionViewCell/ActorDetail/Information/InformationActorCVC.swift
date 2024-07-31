//
//  InformationActorCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 28/03/2024.
//

import UIKit

protocol InformationActorCVCDelegate: AnyObject {
    func addActorFavorite()
}

class InformationActorCVC: BaseCollectionViewCell {
    @IBOutlet weak var departmentActorLbl: UILabel!
    @IBOutlet weak var nameActorLbl: UILabel!
    @IBOutlet weak var imageActor: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    weak var delegate: InformationActorCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configDataActor(_ actor: ActorDetail) {
        nameActorLbl.text = actor.name
        departmentActorLbl.text = actor.knownForDepartment
        imageActor.sd_setImage(with: URL(string: URLs.domainImage + "\(actor.profilePath ?? "")"),
                               placeholderImage: UIImage(named: "DefaultNil"))
        let actorFavorite = RealmService.shared.fetch(ofType: ActorFavoriteObject.self)
        if actorFavorite.contains(where: { $0.id == actor.id}) {
            favoriteBtn.setImage(UIImage(named: "Favorite"), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(named: "UnFavotite"), for: .normal)
        }
    }
    
    @IBAction func favoriteBtnTapped(_ sender: Any) {
        delegate?.addActorFavorite()
    }
}
