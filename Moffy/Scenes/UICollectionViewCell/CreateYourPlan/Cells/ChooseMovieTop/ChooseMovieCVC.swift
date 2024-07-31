//
//  ChooseMovieCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 03/03/2024.
//

import UIKit

protocol ChooseMovieCVCDelegate: AnyObject {
    func chooseCover()
    func chooseStartDate()
    func chooseEndDate()
    func chooseBack()
    func didCreatePlan()
    func showNamePlan(_ namePlan: String)
}

class ChooseMovieCVC: BaseCollectionViewCell {
    
    @IBOutlet weak var noCoverBtn: UIButton!
    @IBOutlet weak var viewNoCover: UIView!
    @IBOutlet weak var viewCover: UIView!
    @IBOutlet weak var namePlanTF: UITextField!
    @IBOutlet weak var startPlanTF: UITextField!
    @IBOutlet weak var endPlanTF: UITextField!
    @IBOutlet weak var notePlanTV: UITextView!
    @IBOutlet weak var imageCover: UIImageView!
    
    weak var delegate: ChooseMovieCVCDelegate?
    var planReceiveCreatePlanVC: PlanObject?
    var editedNamePlan: String?
    var editedNotePlan: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setProperties() {
        viewCover.isHidden = true
        noCoverBtn.backgroundColor = UIColor(rgb: 0x000000, alpha: 0.4)
        notePlanTV.delegate = self
        startPlanTF.delegate = self
        endPlanTF.delegate = self
        
    }
    
    func setUpCover(_ image: String) {
        imageCover.sd_setImage(with: URL(string: URLs.domainImage + "\(image)"), 
                               placeholderImage: UIImage(named: "DefaultNil"))
        viewNoCover.isHidden = true
        viewCover.isHidden = false
    }
    
    func setUpNoCover() {
        imageCover.image = UIImage(named: "BackgroundCover")
        viewNoCover.isHidden = false
        viewCover.isHidden = true
    }
    
    func setUpTextField(startDate: Date?, endDate: Date?) {
        if let startDate = PlanManager.shared.startDate {
            startPlanTF.text = "\(startDate.asStringDate())"
        } else {
            startPlanTF.placeholder = "mm/dd"
        }
        
        if let endDate = PlanManager.shared.endDate {
            endPlanTF.text = "\(endDate.asStringDate())"
        } else {
            endPlanTF.placeholder = "mm/dd"
        }
    }
    
    func showDataMovieEdit(_ plan: PlanObject) {
        let temporaryNamePlan = plan.namePlan ?? ""
        let temporaryNotePlan = plan.note ?? ""
        
        let nameToShow = editedNamePlan ?? temporaryNamePlan
        let noteToShow = editedNotePlan ?? temporaryNotePlan
        
        delegate?.showNamePlan(nameToShow)
        namePlanTF.text = nameToShow
        notePlanTV.text = noteToShow
        
        if PlanManager.shared.startDate != nil  {
            if let startDate = PlanManager.shared.startDate {
                startPlanTF.text = "\(startDate.asStringDate())"
            } else {
                startPlanTF.placeholder = "mm/dd"
            }
        }
        if PlanManager.shared.endDate != nil {
            if let endDate = PlanManager.shared.endDate {
                endPlanTF.text = "\(endDate.asStringDate())"
            } else {
                endPlanTF.placeholder = "mm/dd"
            }
        }
        if PlanManager.shared.startDate == nil {
            if let startDate = plan.startDate {
                startPlanTF.text = "\(startDate.asStringDate())"
            } else {
                startPlanTF.placeholder = "mm/dd"
            }
        }
        if PlanManager.shared.endDate == nil {
            if let endDate = plan.endDate {
                endPlanTF.text = "\(endDate.asStringDate())"
            } else {
                endPlanTF.placeholder = "mm/dd"
            }
        }
        
    }
    
    func updateEditedValues(namePlan: String?) {
        editedNamePlan = namePlan
        delegate?.showNamePlan(editedNamePlan ?? "")
    }
    
    func updateEditNote(notePlan: String?) {
        editedNotePlan = notePlan
    }
    
    @IBAction func namePlanEditingChanged(_ sender: UITextField) {
        updateEditedValues(namePlan: sender.text)
    }
    
    @IBAction func startDatePlanEditngChanged(_ sender: UITextField) {
    }
    
    @IBAction func endDatePlanEditingChanged(_ sender: UITextField) {
    }
    
    
    @IBAction func chooseStartDateTapped(_ sender: Any) {
        delegate?.chooseStartDate()
    }
    
    @IBAction func chooseEndDateTapped(_ sender: Any) {
        delegate?.chooseEndDate()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        delegate?.chooseBack()
    }
    
    @IBAction func chooseCoverButtonTapped(_ sender: Any) {
        delegate?.chooseCover()
    }
    @IBAction func chooseNoCoverBtnTapped(_ sender: Any) {
        delegate?.chooseCover()
    }
    
}

extension ChooseMovieCVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateEditNote(notePlan: textView.text)
    }
}

extension ChooseMovieCVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == startPlanTF || textField == endPlanTF{
            return false
        }
        return true
    }
}
