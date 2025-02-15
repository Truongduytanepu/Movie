////
////  CustomBannerView.swift
////  Palestine
////
////  Created by Trịnh Xuân Minh on 30/11/2023.
////
//
//import UIKit
//import SnapKit
//import AdMobManager
//import NVActivityIndicatorView
//
//class CustomBannerAdView: BaseView {
//  @IBOutlet var contentView: UIView!
//  @IBOutlet weak var bannerAdView: BannerAdMobView!
//  
//  private lazy var loadingView: NVActivityIndicatorView = {
//    let loadingView = NVActivityIndicatorView(frame: .zero)
//    loadingView.type = .ballPulse
//    loadingView.padding = 25.0
//    loadingView.color = UIColor(rgb: 0xFFFFFF)
//    return loadingView
//  }()
//  
//  override func addComponents() {
//    loadNibNamed()
//    addSubview(contentView)
//    addSubview(loadingView)
//  }
//  
//  override func setConstraints() {
//    contentView.frame = self.bounds
//    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//    
//    loadingView.snp.makeConstraints { make in
//      make.width.height.equalTo(20.0)
//      make.center.equalToSuperview()
//    }
//  }
//  
//    override func setProperties() {
//      loadingView.startAnimating()
//        bannerAdView.load(name: "Banner_2", rootViewController: nil, didReceive: { [weak self] in
//        guard let self = self else {
//          return
//        }
//        self.loadingView.stopAnimating()
//      }, didError: nil)
//    }
//    
//    override func setColor() {
//      changeLoading(color: .white)
//    }
//    
//    private func changeLoading(color: UIColor) {
//      var isAnimating = false
//      if loadingView.isAnimating {
//        isAnimating = true
//        loadingView.stopAnimating()
//      }
//      loadingView.color = color
//      guard isAnimating else {
//        return
//      }
//      loadingView.startAnimating()
//    }
//  }
