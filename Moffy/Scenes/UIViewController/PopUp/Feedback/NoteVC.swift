//
//  NoteVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 07/03/2024.
//

import UIKit
import CustomBlurEffectView

protocol NoteVCDelegate: AnyObject {
    func showToast()
}

class NoteVC: BaseViewController {
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var numberTextLbl: UILabel!
    @IBOutlet weak var noteTV: UITextView!
    
    weak var delegate: NoteVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setProperties() {
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapgesture)
        noteTV.addPlaceholder(text: "Write your feedback")
        noteTV.delegate = self
    }
    
    override func setColor() {
        view.backgroundColor = UIColor(rgb: 0x000000, alpha: 0.6)
    }
    
    @objc func viewTapped(_ gesture: UITapGestureRecognizer){
        self.hideTab(self)
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        self.hideTab(self)
        delegate?.showToast()
    }
    
    @IBAction func cancleBtnTapped(_ sender: Any) {
        self.hideTab(self)
        
    }
}

extension NoteVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        numberTextLbl.text = "\(textView.text.count)"
        if textView.text.count > 0 {
            doneBtn.setBackgroundImage(UIImage(named: "doneBtn"), for: .normal)
        } else {
            doneBtn.setBackgroundImage(UIImage(named: "doneDefault"), for: .normal)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           guard let currentText = textView.text else { return true }
           let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
           return newText.count <= 500
       }
}
