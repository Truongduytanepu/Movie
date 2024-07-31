//
//  BaseCollectionViewCell.swift
//  Palestine
//
//  Created by Trịnh Xuân Minh on 25/11/2023.
//

import UIKit
import Combine

class BaseCollectionViewCell: UICollectionViewCell, ViewProtocol {
    var subscriptions = [AnyCancellable]()
    var isNetworkConnected = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setConstraints()
        setProperties()
        binding()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addComponents()
        setConstraints()
        setProperties()
        binding()
        observeNetworkStatus()
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setColor()
    }
}
