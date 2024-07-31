//
//  SuggestPlanBotCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 21/02/2024.
//

import UIKit

class SuggestPlanBotCVC: UICollectionViewCell {

    @IBOutlet weak var namePlan: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var startLbl: UILabel!
    @IBOutlet weak var endLbl: UILabel!
    @IBOutlet weak var imagePlan: UIImageView!
    
    var planObject: PlanObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func config(_ plan: PlanObject) {
        planObject = plan
        
//        totalMovie.text = "8 Movies"
        namePlan.text = plan.namePlan
//        genre.text = plan.generPlan
        startLbl.text = "Start: \(plan.startDate)"
        endLbl.text = "End: \(plan.endDate)"
//        imagePlan.sd_setImage(with: URL(string: URLs.domainImage + "\(plan. ?? "")"), placeholderImage: UIImage(named: "placeholder.png"))
    }
}
