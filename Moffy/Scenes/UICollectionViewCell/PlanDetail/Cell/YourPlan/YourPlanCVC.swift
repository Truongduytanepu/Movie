//
//  YourPlanCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 01/03/2024.
//

import UIKit
import AdMobManager

protocol YourPlanCVCDelegate: AnyObject {
    func updateCollectionViewHeight(_ height: CGFloat)
    func showPlan(_ plan: PlanObject)
    func showAlert()
    func showYourPlanMovieDetail(at indexPath: IndexPath)
}

class YourPlanCVC: BaseCollectionViewCell {
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var vcReceivePlanDetailVC: UIViewController?
    private var dataMovie: [MovieObject]?
    private var movies = MovieObject()
    private var numberOfItemPlan = 0
    private let height: CGFloat = 228
    private let itemsPerRow = 3
    private let horizontalSpacing: CGFloat = 10
    private let verticalSpacing: CGFloat = 10
    var plan: PlanObject?
    weak var delegate: YourPlanCVCDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func binding() {
        PlanManager.shared.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movie in
                guard let self = self else {
                    return
                }
                self.collectionView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    
    override func setProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: ChooseMovieInBotCVC.self)
    }
    
    func configCell(with plan: PlanObject?, numberOfItem: Int, vc: UIViewController?) {
        guard let plan = plan else {
            return
        }
        
        let arrayMovie = RealmService.shared.convertToArray(list: plan.movies)
        self.dataMovie = arrayMovie
        self.numberOfItemPlan = numberOfItem
        self.vcReceivePlanDetailVC = vc
        heightCollectionView.constant = calculateCollectionViewHeight()
        collectionView.reloadData()
    }
    
    private func calculateCollectionViewHeight() -> CGFloat {
        guard let dataMovie = dataMovie else {
            return 0
        }
        let numberOfRows = Int(ceil(Double(dataMovie.count) / Double(itemsPerRow)))
        let totalHeight = CGFloat(numberOfRows) * height + verticalSpacing * CGFloat(numberOfRows) + 29
        delegate?.updateCollectionViewHeight(totalHeight)
        return totalHeight
    }
}

extension YourPlanCVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataMovie?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: ChooseMovieInBotCVC.self, indexPath: indexPath)
        if let data = dataMovie {
            cell.configMovie(data[indexPath.item])
            cell.movies = data
            cell.chooseDelegate = self
        }
        cell.plan = self.plan
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isNetworkConnected {
            delegate?.showYourPlanMovieDetail(at: indexPath)
        } else {
            delegate?.showAlert()
        }
    }
    
}

extension YourPlanCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 5 * 2, height: height)
    }
}

//extension YourPlanCVC: SuggestPlanInBotCVCDelegate {
//    func editPlan(for cell: SuggestPlanInBotCVC) {
//        if let indexPath = collectionView.indexPath(for: cell), let plan = self.plan {
//            delegate?.showPlan(plan)
//        }
//    }
//}

extension YourPlanCVC: ChooseMovieInBotCVCDelegate {
    func didRemoveMovie(_ movie: MovieObject) {}
    
    func didRemoveMovdeFormDetail(_ movie: MovieObject) {}
    
    func didRemoveMovdeFormDetail1(_ movie: MovieObject) {
        dataMovie?.removeAll(where: {$0.name == movie.name && $0.title == movie.title})
        if let plan = plan, let data = dataMovie {
            RealmService.shared.updateAllPlanMovies(plan: plan, newMovieArray: data)
        }
        self.collectionView.reloadData()
        
        NotificationCenter.default.post(name: Notification.Name("DidRemoveMoivePlanDetail"), object: nil)
    }
    
    func editPlan(for cell: ChooseMovieInBotCVC) {}
}
