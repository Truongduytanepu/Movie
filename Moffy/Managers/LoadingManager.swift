//
//  LoadingManager.swift
//  Moffy
//
//  Created by Trương Duy Tân on 26/03/2024.
//

import Foundation
import UIKit

class LoadingManager {
  static let shared = LoadingManager()
  
  private var taskLoadingView: TaskLoadingView?
  private var rootViewController: UIViewController?
  
  func show(rootViewController: UIViewController? = nil) {
    var viewController: UIViewController?
    if let rootViewController = rootViewController {
      viewController = rootViewController
    } else if let topVC = UIApplication.topViewController() {
      viewController = topVC
    }
    guard let viewController = viewController else {
      return
    }
    let taskLoadingView = TaskLoadingView()
    taskLoadingView.frame = viewController.view.frame
    self.taskLoadingView = taskLoadingView
    viewController.view.addSubview(taskLoadingView)
    self.rootViewController = viewController
  }
  
  func remove() {
    guard let topVC = UIApplication.topViewController() else {
      return
    }
    guard topVC != rootViewController else {
      return
    }
    hide()
  }
  
  func hide() {
    taskLoadingView?.removeFromSuperview()
    self.rootViewController = nil
  }
}
