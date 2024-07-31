//
//  SuggestPlanInBotCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 28/02/2024.
//

import UIKit
import CustomBlurEffectView

protocol SuggestPlanInBotCVCDelegate {
    func editPlan(for cell: SuggestPlanInBotCVC)
}

class SuggestPlanInBotCVC: BaseCollectionViewCell {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var totalTimeLbl: UILabel!
    @IBOutlet weak var totalMovieLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var namePlanLbl: UILabel!
    @IBOutlet weak var viewWrapper: UIView!
    @IBOutlet weak var imagePlan: UIImageView!
    
    var delegate: SuggestPlanInBotCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setProperties() {
        self.imagePlan.layer.cornerRadius = self.imagePlan.frame.height / 13.2
        self.imagePlan.clipsToBounds = true
        self.imagePlan.layer.cornerRadius = self.imagePlan.frame.height / 13.2
        self.contentView.layer.cornerRadius = self.contentView.frame.height / 20.2
        let blurColor = UIColor(rgb: 0xE2E2E2, alpha: 0.7)
        self.setupBlurEffectView(with: blurColor)
        self.progressView.cornerRadius = 4
    }
    
    func configData(_ plan: PlanObject) {
        let movieDoneCount = plan.movies.filter({$0.isDone}).count
        namePlanLbl.text = plan.namePlan
        totalMovieLbl.text = "\(movieDoneCount)/\(plan.movies.count)"
        progressView.progress = Float(movieDoneCount) / Float(plan.movies.count)
        if plan.movies.count == 0 {
            progressView.progress = 0
        }
        startDateLbl.text = "Start: \(plan.startDate?.asStringDate() ?? "mm/dd")"
        endDateLbl.text = "End: \(plan.endDate?.asStringDate() ?? "mm/dd")"
        
        imagePlan.sd_setImage(with: URL(string: URLs.domainImage + "\(plan.image ?? "")"), 
                              placeholderImage: UIImage(named: "DefaultNil"))
    }
    
    private func setupBlurEffectView(with color: UIColor) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            let customBlurEffectView = CustomBlurEffectView(
                color: color
            )
            customBlurEffectView.frame = self.viewWrapper.bounds
            self.viewWrapper.insertSubview(customBlurEffectView, at: 0)
            customBlurEffectView.alpha = 0.9
        }
    }
    
    @IBAction func editPlanBtnTapped(_ sender: Any) {
        let vc = CreatePlanVC()
        delegate?.editPlan(for: self)
        MovieTopRateManager.shared.checkEditOrCreatePlan = 1
    }
}
 
