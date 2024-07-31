//
//  PopUpVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 16/02/2024.
//

import UIKit
import CustomBlurEffectView

class PopUpVC: BaseViewController {
    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var viewPopUp: UIView!
    
    var popupContent = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPopUp.layer.cornerRadius = 20
        changeContent(text: popupContent)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            let customBlurEffectView = CustomBlurEffectView(
                radius: 20,
                color: UIColor(red: 109/255, green: 77/255, blue: 116/255, alpha: 0.9)
            )
            customBlurEffectView.frame = self.view.bounds
            self.view.insertSubview(customBlurEffectView, at: 0)
            customBlurEffectView.alpha = 0.8
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
            customBlurEffectView.addGestureRecognizer(tapgesture)
        }
    }
    
    private func changeContent(text: String) {
        content.text = text
    }

    @objc func viewTapped(_ gesture: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
}
