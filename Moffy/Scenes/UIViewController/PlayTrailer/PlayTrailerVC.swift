//
//  PlayTrailerVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 05/04/2024.
//

import UIKit
import YouTubePlayer
import NVActivityIndicatorView

class PlayTrailerVC: BaseViewController {
    @IBOutlet weak var loadingView: NVActivityIndicatorView!
    @IBOutlet weak var playTrailerView: YouTubePlayerView!
    
    var trailerID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setProperties() {
        loadingView.startAnimating()
        playTrailerView.loadVideoID(trailerID ?? "")
    }
    
    override func setColor() {
        loadingView.color = UIColor(rgb: 0x79FAAC, alpha: 1)
    }
    
    @IBAction func backNavigationBtnTapped(_ sender: Any) {
        pop(animated: true)
    }
}
