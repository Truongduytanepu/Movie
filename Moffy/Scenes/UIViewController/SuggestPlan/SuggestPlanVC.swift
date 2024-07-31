//
//  SuggestPlanVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 21/02/2024.
//

import UIKit

class SuggestPlanVC: BaseViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    enum PlanHome: CaseIterable {
        case planTop
        case planBot
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: NSNotification.Name(rawValue: "ReloadSuggestPlanVC"), object: nil)
    }
    
    @objc func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    override func binding() {
        PlanManager.shared.$planObject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self = self else {
                    return
                }
                self.collectionView.reloadData()
            }
            .store(in: &subscriptions)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        PlanManager.shared.planObject = RealmService.shared.fetch(ofType: PlanObject.self)
    }
    
    override func setProperties() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(ofType: SuggestPlanTopCVC.self)
        collectionView.registerNib(ofType: SuggestPlanBotCVC.self)
        collectionView.delegate = self
    }
    
    
    @IBAction func settingBtnTapped(_ sender: Any) {
        let vc = SettingVC()
        push(to: vc, animated: true)
    }
}

extension SuggestPlanVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return PlanHome.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch PlanHome.allCases[section] {
        case .planTop:
            return 1
        case .planBot:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch PlanHome.allCases[indexPath.section] {
        case .planTop:
            let cell = collectionView.dequeueCell(ofType: SuggestPlanTopCVC.self, indexPath: indexPath)
            cell.setUpCell(dataTopPlan: RealmService.shared.fetch(ofType: PlanSuggestObject.self))
            return cell
        case .planBot:
            let cell = collectionView.dequeueCell(ofType: SuggestPlanBotCVC.self, indexPath: indexPath)
            cell.setUpCell(dataPlanBot: RealmService.shared.fetch(ofType: PlanObject.self))
            cell.delegate = self
            return cell
        }
    }
}

extension SuggestPlanVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch PlanHome.allCases[indexPath.section] {
            
        case .planTop:
                return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height / 1.7)
        case .planBot:
            return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height * 0.295)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch PlanHome.allCases[section] {
            
        case .planTop:
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .planBot:
            return UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        }
    }
}

extension SuggestPlanVC: SuggestPlanBotCVCDelegate {
    func showPlan(_ plan: PlanObject) {
        let vc = CreatePlanVC()
        vc.namePlan = plan.namePlan
        vc.startDate = plan.startDate ?? Date()
        vc.endDate = plan.endDate ?? Date()
        vc.image = plan.image
        vc.plan = plan
        vc.delegate = self
        push(to: vc, animated: true)
    }
    
    func showPlanDetail(_ plan: PlanObject) {
        let vc = PlanDetailVC()
        vc.namePlan = plan.namePlan
        vc.plan = plan
        vc.startDate = plan.startDate ?? Date()
        vc.endDate = plan.endDate ?? Date()
        vc.imagePlan = plan.image
        vc.movies = Array(plan.movies)
        vc.numberOfItem = plan.movies.count
        push(to: vc, animated: true)
    }
}

extension SuggestPlanVC: CreatePlanVCDelegate {
    func didUpdateOrCreatePlan() {
        collectionView.reloadData()
    }
}
