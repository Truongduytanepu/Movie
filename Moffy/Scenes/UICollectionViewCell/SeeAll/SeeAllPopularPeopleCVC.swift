//
//  SeeAllPopularPeopleCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 26/03/2024.
//

import UIKit

protocol SeeAllPopularPeopleCVCDelegate: AnyObject {
    func addActorToFavotite(at indexPath: IndexPath)
}

class SeeAllPopularPeopleCVC: BaseCollectionViewCell {
    @IBOutlet weak var nameActorLbl: UILabel!
    @IBOutlet weak var departmentLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var imageActor: UIImageView!
    
    weak var delegate: SeeAllPopularPeopleCVCDelegate?
    var indexPathReceiveVC: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setProperties() {
        imageActor.cornerRadius = imageActor.frame.height / 2
    }
    
    func configDataActor(_ actor: Result) {
        imageActor.sd_setImage(with: URL(string: URLs.domainImage + "\(actor.profilePath ?? "")"),
                               placeholderImage: UIImage(named: "DefaultNil"))
        departmentLbl.text = actor.knownForDepartment
        nameActorLbl.text = actor.name
        
        let actorFavorite = RealmService.shared.fetch(ofType: ActorFavoriteObject.self)
        if actorFavorite.contains(where: { $0.id == actor.id}) {
            favoriteBtn.setImage(UIImage(named: "Favorite"), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(named: "UnFavotite"), for: .normal)
        }
    }
    
    @IBAction func favoriteBtnTapped(_ sender: Any) {
        delegate?.addActorToFavotite(at: indexPathReceiveVC ?? IndexPath())
    }
}
