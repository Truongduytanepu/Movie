//
//  SuggestTopCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 26/02/2024.
//

import UIKit
import CustomBlurEffectView

class SuggestTopCVC: UICollectionViewCell {

    @IBOutlet weak var imagePlan: UIImageView!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var totalMovieLbl: UILabel!
    @IBOutlet weak var viewPlan: UIView!
    @IBOutlet weak var namePlanLbl: UILabel!
    
    var planSuggest: PlanSuggestObject?
    var blurColor: UIColor?
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Khởi tạo màu blur
        let blurColor = UIColor(rgb: 0xE2E2E2, alpha: 1)
            self.blurColor = blurColor
            setupBlurEffectView(with: blurColor)
        }

        // Hàm thiết lập màu blur
        private func setupBlurEffectView(with color: UIColor) {
            imagePlan.cornerRadius = imagePlan.frame.height / 19.3
            viewPlan.layer.cornerRadius = viewPlan.frame.height / 5.4
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                let customBlurEffectView = CustomBlurEffectView(
                    color: blurColor
                )
                customBlurEffectView.frame = self.viewPlan.bounds
                
                self.viewPlan.insertSubview(customBlurEffectView, at: 0)
                customBlurEffectView.alpha = 1
            }
        }
    
    func config(_ plan: PlanSuggestObject) {
            planSuggest = plan
            totalMovieLbl.text = "3 Movies"
            namePlanLbl.text = plan.namePlan
            genreLbl.text = plan.generPlan
            startDateLbl.text = "Start: \(plan.startDate)"
            endDateLbl.text = "End: \(plan.endDate)"
            imagePlan.sd_setImage(with: URL(string: URLs.domainImage + "\(plan.imagePlan ?? "")"), placeholderImage: UIImage(named: "placeholder.png"))
        }

    
}
