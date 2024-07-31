//
//  SuggestPlanInTopCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 28/02/2024.
//

import UIKit
import CustomBlurEffectView

class SuggestPlanInTopCVC: BaseCollectionViewCell {
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var namePlanLbl: UILabel!
    @IBOutlet weak var totalMovieLbl: UILabel!
    @IBOutlet weak var genreMovieLbl: UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var imagePlan: UIImageView!
    @IBOutlet weak var viewPlan: UIView!
    
    var plan: PlanSuggestObject?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setProperties() {
        imagePlan.layer.cornerRadius = imagePlan.frame.height / 19.27
        let blurColor = UIColor(rgb: 0xE2E2E2, alpha: 0.7)
        setupBlurEffectView(with: blurColor)
        viewPlan.layer.cornerRadius = viewPlan.frame.height / 5.4
    }
    
    func configData(_ plan: PlanSuggestObject) {
        let startDateString = plan.startDate?.asStringDate() ?? ""
        let endDateString = plan.endDate?.asStringDate() ?? ""
        
        namePlanLbl.text = plan.namePlan
        totalMovieLbl.text = "\(plan.movies.count) Movies"
        genreMovieLbl.text = plan.generPlan
        startDateLbl.text = "Start: \(startDateString)"
        endDateLbl.text = "End: \(endDateString)"
        imagePlan.sd_setImage(with: URL(string: URLs.domainImage + "\(plan.imagePlan ?? "")"), 
                              placeholderImage: UIImage(named: "DefaultNil"))
        
        let existingPlans = RealmService.shared.fetch(ofType: PlanObject.self).filter { $0.namePlan == plan.namePlan }
            if !(existingPlans.isEmpty) {
                addBtn.setImage(UIImage(named: "AddBtnDone"), for: .normal)
            } else {
                addBtn.setImage(UIImage(named: "AddBtn"), for: .normal)
            }
    }
    
    private func setupBlurEffectView(with color: UIColor) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            let customBlurEffectView = CustomBlurEffectView(
                color: color
            )
            customBlurEffectView.frame = self.viewPlan.bounds
            self.viewPlan.insertSubview(customBlurEffectView, at: 0)
            customBlurEffectView.alpha = 0.9
        }
    }
    
    func createYourPlan(_ plan: PlanSuggestObject) {
        let existingPlans = RealmService.shared.fetch(ofType: PlanObject.self).filter { $0.namePlan == plan.namePlan }
        if existingPlans.isEmpty {
            let movies = Array(plan.movies)
            let namePlan = plan.namePlan
            let startDate = plan.startDate
            let endDate = plan.endDate
            let note = plan.note
            let image = plan.imagePlan
            
            let yourPlan = PlanItem(namePlan: namePlan,
                                    movies: movies,
                                    endDate: endDate,
                                    startDate: startDate,
                                    image: image,
                                    note: note)
            
            let planObject = PlanObject(with: yourPlan)
            
            RealmService.shared.add(planObject)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadSuggestPlanVC"), object: nil)
        }
    }
    
    @IBAction func addSuggestPlanToYourPlanTapped(_ sender: Any) {
        if let plan = plan {
            createYourPlan(plan)
        }
    }
}
