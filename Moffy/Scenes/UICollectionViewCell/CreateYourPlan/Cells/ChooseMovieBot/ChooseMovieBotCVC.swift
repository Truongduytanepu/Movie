//
//  ChooseMovieBotCVC.swift
//  Moffy
//
//  Created by Trương Duy Tân on 04/03/2024.
//

import UIKit
import AdMobManager

class ChooseMovieBotCVC: BaseCollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataMovie: [MovieObject]?
    private var vcReceiveCreateYourPlanVC: UIViewController?
    private let height: CGFloat = 228
    var planReceiveCreatePlan: PlanObject?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(ofType: ChooseMovieInBotCVC.self)
    }
    
    func setUpCell(dataMovie: [MovieObject]?, vc: UIViewController?) {
        if let newDataMovie = dataMovie {
            self.dataMovie = newDataMovie
            self.vcReceiveCreateYourPlanVC = vc
        }
        collectionView.reloadData()
    }

    @IBAction func chooseMovieBtnTapped(_ sender: Any) {
        let vc = SuggestChooseVC()
        self.push(to: vc, animated: true)
        vc.screenHome = .chooseMovie
        vc.planReceiveChooseMovieBot = self.planReceiveCreatePlan
    }
}

extension ChooseMovieBotCVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataMovie = dataMovie{
            return dataMovie.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: ChooseMovieInBotCVC.self, indexPath: indexPath)
        if dataMovie != nil {
            if let data = dataMovie {
                cell.configMovie(data[indexPath.item])
            }
        }
        cell.hideCheckDoneImage()
        cell.chooseDelegate = self
        return cell
    }
}

extension ChooseMovieBotCVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 5 * 2, height: height)
    }
}

extension ChooseMovieBotCVC: ChooseMovieInBotCVCDelegate {
    func didRemoveMovdeFormDetail1(_ movie: MovieObject) {}
    
    func didRemoveMovdeFormDetail(_ movie: MovieObject) {
        // Xoá dữ liệu cho trường detail đi vào
        MovieTopRateManager.shared.movieDefaultRealm.removeAll(where: {$0.id == movie.id})
        self.dataMovie?.removeAll(where: {$0.id == movie.id})
        self.collectionView.reloadData()
    }
    
    func didRemoveMovie(_ movie: MovieObject) {
        // XOÁ DỮ LIỆU Ở ĐÂY
        dataMovie?.removeAll(where: {$0.id == movie.id})
        self.collectionView.reloadData()
    }
    
    func editPlan(for cell: ChooseMovieInBotCVC) {}
    
}
