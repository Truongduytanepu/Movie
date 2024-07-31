//
//  FeedbackVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 16/04/2024.
//

import UIKit

class FeedbackVC: BaseViewController {
    @IBOutlet weak var borderFeedbackImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setProperties() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            borderFeedbackImage.image = UIImage(named: "BorderFeedback")
        } else {
            borderFeedbackImage.image = UIImage(named: "BorderFeedbackIpad")
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        pop(animated: true)
    }
    
    @IBAction func textViewBtnTapped(_ sender: Any) {
        let childVC = NoteVC()
        self.addSubViewController(childVC)
        childVC.delegate = self
    }
}

extension FeedbackVC: NoteVCDelegate {
    func showToast() {
        showToast(message: "Thank you")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.pop(animated: true)
        }
    }
}
