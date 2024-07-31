//
//  PlanDetailVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 01/03/2024.
//

import UIKit
import AdMobManager

class PlanDetailVC: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    enum ScreenPlan: CaseIterable {
        case planProgress
        case yourPlan
    }
    
    var numberOfItem: Int = 0
    var movies: [MovieObject] = []
    var imagePlan: String?
    var endDate: Date?
    var startDate: Date?
    var namePlan: String?
    var plan: PlanObject?
    var yourPlanHeight: CGFloat?
    let height: CGFloat = 228
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MovieTopRateManager.shared.checkEditOrCreatePlan = 2
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveMovie), name: Notification.Name("DidRemoveMovie"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveMovie), name: Notification.Name("DidRemoveMoivePlanDetail"), object: nil)
    }
    
    override func binding() {
        PlanManager.shared.planDetail = plan
        PlanManager.shared.movies = Array(plan!.movies)
    }
    
    @objc func didRemoveMovie() {
        PlanManager.shared.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {
                    return
                }
                collectionView.reloadData()
            }.store(in: &subscriptions)
        
    }
    
    override func setProperties() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(ofType: PlanProgressCVC.self)
        collectionView.registerNib(ofType: YourPlanCVC.self)
        
        
    }
    @IBAction func editPlanBtnTapped(_ sender: Any) {
        let vc = CreatePlanVC()
        vc.namePlan = plan?.namePlan
        vc.startDate = plan?.startDate ?? Date()
        vc.endDate = plan?.endDate ?? Date()
        vc.image = plan?.image
        vc.plan = plan
        MovieTopRateManager.shared.checkEditOrCreatePlan = 1
        push(to: vc, animated: true)
    }
    @IBAction func backScreen(_ sender: Any) {
        pop(animated: true)
    }
}

extension PlanDetailVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch ScreenPlan.allCases[section] {
        case .planProgress:
            return 1
        case .yourPlan:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch ScreenPlan.allCases[indexPath.section] {
        case .planProgress:
            let cell = collectionView.dequeueCell(ofType: PlanProgressCVC.self, indexPath: indexPath)
            cell.configDataPlan(plan ?? PlanObject())
            cell.plan = plan
            if PlanManager.shared.planDetail?.note == nil  || PlanManager.shared.planDetail?.note == ""{
                cell.viewTextView.isHidden = true
            } else {
                cell.viewTextView.isHidden = false
            }
            cell.delegate = self
            return cell
        case .yourPlan:
            let cell = collectionView.dequeueCell(ofType: YourPlanCVC.self, indexPath: indexPath)
            cell.plan = plan
            cell.configCell(with: plan, numberOfItem: numberOfItem, vc: self)
            cell.delegate = self
            return cell
        }
    }
}

extension PlanDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch ScreenPlan.allCases[indexPath.section] {
        case .planProgress:
            let numberOfRow = ceil(CGFloat(plan?.movies.count ?? 0) / 5)
            var totalHeight = numberOfRow * 63 + 235 + 134
            if PlanManager.shared.planDetail?.note == nil  || PlanManager.shared.planDetail?.note == "" {
                totalHeight = totalHeight - 140
            }
            return CGSize(width: collectionView.frame.width, height: totalHeight)
        case .yourPlan:
            let numberOfRow = ceil(CGFloat(plan?.movies.count ?? 0) / 3)
            var minimumLineSpacing: CGFloat = 0
            
            if numberOfRow > 0 {
                minimumLineSpacing = CGFloat((numberOfRow - 1) * 10)
            }
            
            let totalHeight = numberOfRow * height + minimumLineSpacing + 50
            return CGSize(width: collectionView.frame.width, height: totalHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch ScreenPlan.allCases[section] {
        case .planProgress:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .yourPlan:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch ScreenPlan.allCases[section] {
        case .planProgress:
            return 0
        case .yourPlan:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch ScreenPlan.allCases[section] {
        case .planProgress:
            return 0
        case .yourPlan:
            return 0
        }
    }
}

extension PlanDetailVC: YourPlanCVCDelegate {
    func showYourPlanMovieDetail(at indexPath: IndexPath) {
        guard let plan = self.plan else {
            return
        }
        let arrayMovie = RealmService.shared.convertToArray(list: plan.movies)
        let movie = arrayMovie[indexPath.item]
        let vc = MovieDetailVC()
        let vcTV = TVDetailVC()
        AdMobManager.shared.show(type: .interstitial,
                                 name: "AllLayout_Inter",
                                 rootViewController: self,
                                 didFail: nil,
                                 didHide: nil)
       
        if movie.title != nil && movie.name == nil || movie.name == "" {
            vc.movieReceiveSeeAllVC = movie.idMovie
            push(to: vc, animated: true)
        } else {
            vcTV.genreIDReceiveTVShowVC = "\(movie.idMovie ?? 0)"
            push(to: vcTV, animated: true)
        }
    }
    
    func showAlert() {
        showAlert(title: "No Internet", message: "Please connect to the interntet")
    }
    
    func updateCollectionViewHeight(_ height: CGFloat) {
        yourPlanHeight = height
    }
}

extension PlanDetailVC: PlanProgressCVCDelegate {
    func passPlanData(_ plan: PlanObject) {
        
    }
    
    func showPlan(_ plan: PlanObject) {
        let vc = CreatePlanVC()
        vc.namePlan = plan.namePlan
        vc.startDate = plan.startDate ?? Date()
        vc.endDate = plan.endDate ?? Date()
        vc.image = plan.image
        vc.plan = plan
        push(to: vc, animated: true)
    }
    
    func didSelectedProgress() {
        collectionView.reloadData()
    }
    
}
