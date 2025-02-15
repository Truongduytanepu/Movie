//
//  TaskLoadingView.swift
//  Moffy
//
//  Created by Trương Duy Tân on 26/03/2024.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

class TaskLoadingView: BaseView {
  @IBOutlet var contentView: UIView!
  
  private lazy var loadingView: NVActivityIndicatorView = {
    let loadingView = NVActivityIndicatorView(frame: .zero)
    loadingView.type = .ballSpinFadeLoader
    loadingView.padding = 30.0
    return loadingView
  }()
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    loadingView.startAnimating()
  }
  
  override func addComponents() {
    loadNibNamed()
    addSubview(contentView)
    addSubview(loadingView)
  }
  
  override func setConstraints() {
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    loadingView.snp.makeConstraints { make in
      make.width.height.equalTo(20.0)
      make.center.equalToSuperview()
    }
  }
  
  override func setColor() {
    loadingView.color = UIColor(rgb: 0x000000)
  }
}
