//
//  BaseViewController.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit
import Combine

class BaseViewController: UIViewController, ViewProtocol {
    var subscriptions = [AnyCancellable]()
    var isNetworkConnected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addComponents()
        setConstraints()
        setProperties()
        binding()
        observeNetworkStatus()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setColor()
    }
    
    func addComponents() {}
    
    func setConstraints() {}
    
    func setProperties() {}
    
    func setColor() {}
    
    func binding() {}
    
    func network(_ completionHandler: @escaping(Bool) -> Void) {
        NetworkMonitor.shared.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnetion in
                guard let self = self else {
                    return
                }
                completionHandler(isConnetion)
            }.store(in: &subscriptions)
    }
    
    func observeNetworkStatus() {
        NetworkMonitor.shared.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.isNetworkConnected = isConnected
            }.store(in: &subscriptions)
    }
    
    func changeLocation(_ sender: UIView, newLocation: ComponentLocation) {
        guard let superview = sender.superview else {
          return
        }
        sender.snp.remakeConstraints { make in
          make.leading.equalToSuperview().inset(newLocation.x / AppSize.widthFrameDefault * superview.frame.width)
          make.top.equalToSuperview().inset(newLocation.y / AppSize.heightFrameDefault * superview.frame.height)
          make.width.equalToSuperview().multipliedBy(newLocation.width / AppSize.widthFrameDefault)
          make.height.equalToSuperview().multipliedBy(newLocation.height / AppSize.heightFrameDefault)
        }
        sender.transform = CGAffineTransform(rotationAngle: -newLocation.rotationAngle * CGFloat.pi / 180)
        sender.layoutIfNeeded()
        sender.setNeedsLayout()
      }
    
//    func mergeSelfieImage(sourceView: UIView) -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(sourceView.frame.size, false, 0.0)
//        sourceView.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
}
