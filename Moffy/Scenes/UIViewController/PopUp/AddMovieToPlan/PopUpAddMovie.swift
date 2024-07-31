//
//  PopUpAddMovie.swift
//  Moffy
//
//  Created by Trương Duy Tân on 03/04/2024.
//

import UIKit

class PopUpAddMovie: BaseViewController {
    
    var movieReceiveMovieDetail = MovieObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func setProperties() {
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapgesture)
    }
    
    override func setColor() {
        view.backgroundColor = UIColor(rgb: 0x000000, alpha: 0.6)
    }
    
    @objc func viewTapped(_ gesture: UITapGestureRecognizer){
        self.hideTab(self)
    }
    
    @IBAction func addExítingPlanBtnTapped(_ sender: Any) {
        if isNetworkConnected {
            let vc = AddExistingPlanVC()
            vc.movieReceivePopUpAddMovie = movieReceiveMovieDetail
            push(to: vc, animated: true)
            self.hideTab(self)
        } else {
            showAlert(title: "No Internet", message: "Please connect to the internet")
        }
    }
    
    @IBAction func addNewPlanBtnTapped(_ sender: Any) {
        if isNetworkConnected {
            let createPlan = CreatePlanVC()
            push(to: createPlan, animated: true)
            MovieTopRateManager.shared.checkEditOrCreatePlan = 0
            MovieTopRateManager.shared.movieDefaultRealm.removeAll()
            if !MovieTopRateManager.shared.movieChooseArray.contains(where: {$0.idMovie == movieReceiveMovieDetail.idMovie}) {
                MovieTopRateManager.shared.movieChooseArray.append(movieReceiveMovieDetail)
            }
            if !MovieTopRateManager.shared.movieDefaultRealm.contains(where: {$0.idMovie == movieReceiveMovieDetail.idMovie}) {
                MovieTopRateManager.shared.movieDefaultRealm.append(movieReceiveMovieDetail)
            }
            
            self.hideTab(self)
        } else {
            showAlert(title: "No Internet", message: "Please connect to the internet")
        }
    }
    
    @IBAction func cancleBtnTapped(_ sender: Any) {
        self.hideTab(self)
    }
}
