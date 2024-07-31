//
//  AddExistingPlanVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 03/04/2024.
//

import UIKit

class AddExistingPlanVC: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movieReceivePopUpAddMovie = MovieObject()
    private var planObject = [PlanObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataPlanObject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataPlanObject()
    }
    
    override func setProperties() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(ofType: AddExistingPlanCVC.self)
    }
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        for item in PlanManager.shared.listDelete {
            RealmService.shared.removeMovieFromPlan(item, movieReceivePopUpAddMovie)
        }
        
        for item in PlanManager.shared.planSelected {
            RealmService.shared.addMovieToPlan(item, movieReceivePopUpAddMovie)
        }
        
        PlanManager.shared.planSelected.removeAll()
        MovieTopRateManager.shared.movieDefaultRealm.removeAll()
        pop(animated: true)
    }
    
    @IBAction func backNavigationBtnTapped(_ sender: Any) {
        PlanManager.shared.planSelected.removeAll()
        pop(animated: true)
    }
}

extension AddExistingPlanVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planObject.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: AddExistingPlanCVC.self, indexPath: indexPath)
        let planIndexpath = planObject[indexPath.item]
        
        if PlanManager.shared.planSelected.map({$0.id}).contains(planIndexpath.id) {
            cell.showCheckBox()
        } else {
            cell.hideCheckBox()
        }
        cell.configData(planIndexpath)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let plan = self.planObject[indexPath.item]
        PlanManager.shared.savePlanSelected(with: plan)
        collectionView.reloadItems(at: [indexPath])
    }
}

extension AddExistingPlanVC: UICollectionViewDelegate {
    
}

extension AddExistingPlanVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .phone {
            let width = (collectionView.frame.width / 2) - 14
            return CGSize(width: width, height: width * 1.35)
        }else{
            let width = (collectionView.frame.width / 4) - 14
            return CGSize(width: width, height: width * 1.35)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension AddExistingPlanVC: AddExistingPlanCVCDelegate {
    func editPlan(for cell: AddExistingPlanCVC) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let vc = CreatePlanVC()
            let planIndexpath = RealmService.shared.fetch(ofType: PlanObject.self)[indexPath.item]
            vc.plan = planIndexpath
            push(to: vc, animated: true)
        }
    }
}

extension AddExistingPlanVC {
    private func getDataPlanObject() {
        self.planObject = RealmService.shared.fetch(ofType: PlanObject.self)
        checkMovieInPlanSelected()
        self.collectionView.reloadData()
    }
    
    private func checkMovieInPlanSelected() {
        for plan in planObject {
            if plan.movies.map({$0.idMovie}).contains(movieReceivePopUpAddMovie.idMovie) {
                PlanManager.shared.planSelected.append(plan)
            } else {
                PlanManager.shared.planSelected.removeAll(where: {$0.id == plan.id})
            }
        }
    }
}
