//
//  UiViewController.swift
//  Task4ProX
//
//  Created by Trương Duy Tân on 17/01/2024.
//

import Foundation
import UIKit

extension UIViewController{
    
    func setBackground(imageName: String){
        let backgroundImage = UIImageView(image: UIImage(named: imageName))
        backgroundImage.frame = self.view.bounds
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
        self.view.sendSubviewToBack(backgroundImage)
    }
    
    func background(image: String){
        DispatchQueue.main.async {
            self.setBackground(imageName: image)
        }
    }
    
    func showPopUp(content: String) {
        let popupVC = PopUpVC()
        popupVC.popupContent = content
        popupVC.modalPresentationStyle = .overCurrentContext
        present(popupVC, animated: true, completion: nil)
    }
    
    func gradiant(button: UIButton) {
        DispatchQueue.main.async {
            button.addArrayColorGradient(arrayColor: [
                UIColor(rgb: 0x4F49EA),
                UIColor(rgb: 0x5AA7C4),
                UIColor(rgb: 0x79FAAC)
            ],startPoint: CGPoint(x: 0.1, y: 0.5),endPoint: CGPoint(x: 0.9, y: 0.5))
        }
    }
    
    func hideTab(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    func addSubViewController(_ childViewController: UIViewController) {
        addChild(childViewController)
        childViewController.view.frame = view.bounds
        view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    func showToast(message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        toastLabel.sizeToFit()
        
        let bottomPadding: CGFloat = 50
        let windowHeight = UIScreen.main.bounds.height
        let yPosition = windowHeight - bottomPadding - toastLabel.bounds.height
        
        toastLabel.frame = CGRect(x: (self.view.frame.size.width - toastLabel.bounds.width) / 2, y: yPosition, width: toastLabel.bounds.width + 30, height: toastLabel.bounds.height + 30)
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion?()
        }
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
