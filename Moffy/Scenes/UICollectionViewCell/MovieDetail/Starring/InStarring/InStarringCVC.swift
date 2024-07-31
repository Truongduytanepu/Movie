//
//  InStarringCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 02/04/2024.
//

import UIKit

class InStarringCVC: BaseCollectionViewCell {

    @IBOutlet weak var departMentLbl: UILabel!
    @IBOutlet weak var nameActorLbl: UILabel!
    @IBOutlet weak var imageActor: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configDataSrtarring(_ starring: Result?) {
        nameActorLbl.text = starring?.name
        departMentLbl.text = starring?.knownForDepartment
        imageActor.sd_setImage(with: URL(string: URLs.domainImage + "\(starring?.profilePath ?? "")"),
                               placeholderImage: UIImage(named: "DefaultNil"))
    }
}
