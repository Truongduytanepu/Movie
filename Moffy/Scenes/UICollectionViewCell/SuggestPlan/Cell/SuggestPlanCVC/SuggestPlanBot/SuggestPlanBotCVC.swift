//
//  SuggestPlanBotCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 28/02/2024.
//

import UIKit
protocol SuggestPlanBotCVCDelegate: AnyObject {
    func showPlan(_ plan: PlanObject)
    func showPlanDetail(_ plan: PlanObject)
}
class SuggestPlanBotCVC: BaseCollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataPlanBot: [PlanObject]?
    weak var delegate: SuggestPlanBotCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: NSNotification.Name(rawValue: "NewPlanAdded"), object: nil)
    }
    
    @objc func reloadCollectionView() {
        self.collectionView.reloadData()
    }
    
    override func setProperties() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(ofType: SuggestPlanInBotCVC.self)
        
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
    
    func setUpCell(dataPlanBot: [PlanObject]?) {
        self.dataPlanBot = dataPlanBot
        self.collectionView.reloadData()
    }
}

extension SuggestPlanBotCVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataPlanBot?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: SuggestPlanInBotCVC.self, indexPath: indexPath)
        if let data = dataPlanBot {
            cell.configData(data[indexPath.item])
            cell.delegate = self
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let plan = dataPlanBot?[indexPath.item] else { return }
        delegate?.showPlanDetail(plan)
//        MovieTopRateManager.shared.checkEditOrCreatePlan = 2
    }
}

extension SuggestPlanBotCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        return CGSize(width: height * 0.74, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 13)
    }
}

extension SuggestPlanBotCVC: SuggestPlanInBotCVCDelegate {
    func editPlan(for cell: SuggestPlanInBotCVC) {
        if let indexPath = collectionView.indexPath(for: cell), let plan = dataPlanBot?[indexPath.item] {
            delegate?.showPlan(plan)
        }
    }
}
