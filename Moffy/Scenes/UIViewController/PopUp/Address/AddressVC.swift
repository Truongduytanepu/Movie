//
//  AddressVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 16/04/2024.
//

import UIKit

class AddressVC: BaseViewController {
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var numberTextLbl: UILabel!
    @IBOutlet weak var noteTV: UITextView!
    
    private var noteText: String = ""
    var didSetAddress: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setProperties() {
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapgesture)
        noteTV.text = FavoriteMovieManager.shared.address
        numberTextLbl.text = "\(noteTV.text.count)"
        if noteTV.text.isEmpty {
            noteTV.addPlaceholder(text: "Write your address")
        }
        noteTV.delegate = self
    }
    
    override func setColor() {
        view.backgroundColor = UIColor(rgb: 0x000000, alpha: 0.8)
    }
    
    @objc func viewTapped(_ gesture: UITapGestureRecognizer){
        self.hideTab(self)
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        FavoriteMovieManager.shared.address = noteTV.text
        didSetAddress?(noteText)
        self.hideTab(self)
    }
    
    @IBAction func cancleBtnTapped(_ sender: Any) {
        self.hideTab(self)
    }
}

extension AddressVC: UITextViewDelegate {
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
        return newText.count <= 100
    }
}
