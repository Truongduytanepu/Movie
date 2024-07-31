//
//  AddExistingPlanCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 03/04/2024.
//

import UIKit

protocol AddExistingPlanCVCDelegate: AnyObject {
    func editPlan(for cell: AddExistingPlanCVC)
}

class AddExistingPlanCVC: BaseCollectionViewCell {
    @IBOutlet weak var borderImage: UIImageView!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var namePlanLbl: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var totalMovieLbl: UILabel!
    @IBOutlet weak var viewWrapped: UIView!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var imagePlan: UIImageView!
    
    weak var delegate: AddExistingPlanCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBox.isHidden = true
        borderImage.isHidden = true
    }
    
    override func setColor() {
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
    
    func showCheckBox() {
        checkBox.isHidden = false
        borderImage.isHidden = false
    }
    
    func hideCheckBox() {
        checkBox.isHidden = true
        borderImage.isHidden = true
    }
    
    @IBAction func editPlanBtnTapped(_ sender: Any) {
        delegate?.editPlan(for: self)
        MovieTopRateManager.shared.checkEditOrCreatePlan = 1
    }
}
