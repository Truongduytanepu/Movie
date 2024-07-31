//
//  SettingVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 15/04/2024.
//

import UIKit
import SafariServices

class SettingVC: BaseViewController {
    @IBOutlet weak var feedbackBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var ratingBtn: UIButton!
    @IBOutlet weak var privacyBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    private let id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FavoriteMovieManager.shared.tabSelected = .movie
    }
    
    private func shareApp() {
        guard let topVC = UIApplication.shared.windows.first?.rootViewController else { return }
        if let urlStr = NSURL(string: "https://itunes.apple.com/us/app/myapp/id/\(self.id)?ls=1&mt=8") {
            let objectsToShare = [urlStr]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = topVC.view
                    popup.sourceRect = CGRect(x: 16, y: 0 + 60 + 18, width: topVC.view.frame.width, height: 60)
                    popup.permittedArrowDirections = .up
                }
            }
            topVC.present(activityVC, animated: true, completion: nil)
        }
    }
    
    private func privacy() {
      guard let url = URL(string: AppText.App.privacyLink) else {
        return
      }
      let safariVC = SFSafariViewController(url: url)
      present(to: safariVC, animated: true)
    }
    
    @IBAction func favoriteBtnTapped(_ sender: Any) {
        let vc = FavoriteVC()
        push(to: vc, animated: true)
    }
    
    @IBAction func privacyBtnTapped(_ sender: Any) {
        privacy()
    }
    
    @IBAction func ratingBtnTapped(_ sender: Any) {
        let vc = RatingVC()
        push(to: vc, animated: true)
    }
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        shareApp()
    }
    
    @IBAction func feedbackBtnTapped(_ sender: Any) {
        let vc = FeedbackVC()
        push(to: vc, animated: true)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        pop(animated: true)
    }
}
